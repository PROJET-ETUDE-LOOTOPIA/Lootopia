-- Schéma PostgreSQL de Lootopia (MVP). Voir modele-de-donnees.md pour les
-- principes de conception, le rôle de chaque entité et les règles liées.

BEGIN;

CREATE TYPE account_type AS ENUM ('user', 'admin');
CREATE TYPE account_status AS ENUM ('active', 'deleted', 'banned');
CREATE TYPE hunt_status AS ENUM ('draft', 'published', 'closing', 'closed');
CREATE TYPE hunt_visibility AS ENUM ('public', 'private');
CREATE TYPE hunt_end_reason AS ENUM ('owner_deleted', 'closing_date_reached');
CREATE TYPE participation_status AS ENUM ('in_progress', 'completed');
CREATE TYPE token_purpose AS ENUM ('email_confirmation', 'password_reset');

CREATE TABLE users (
    id                uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    email             text,
    pseudo            text,
    password_hash     text,
    google_subject    text UNIQUE,
    account_type      account_type   NOT NULL DEFAULT 'user',
    status            account_status NOT NULL DEFAULT 'active',
    email_verified_at timestamptz,
    created_at        timestamptz    NOT NULL DEFAULT now(),
    deleted_at        timestamptz,
    banned_at         timestamptz,

    CONSTRAINT users_active_identity CHECK (
        status <> 'active'
        OR (email IS NOT NULL AND pseudo IS NOT NULL
            AND (password_hash IS NOT NULL OR google_subject IS NOT NULL))
    ),
    CONSTRAINT users_inactive_no_personal_data CHECK (
        status = 'active'
        OR (email IS NULL AND pseudo IS NULL
            AND password_hash IS NULL AND google_subject IS NULL)
    ),
    CONSTRAINT users_status_dates CHECK (
        (status = 'deleted') = (deleted_at IS NOT NULL)
        AND (status = 'banned') = (banned_at IS NOT NULL)
    )
);

CREATE UNIQUE INDEX users_email_unique ON users (lower(email))
    WHERE email IS NOT NULL;

CREATE TABLE auth_tokens (
    id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id    uuid          NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    purpose    token_purpose NOT NULL,
    token_hash text          NOT NULL UNIQUE,
    expires_at timestamptz   NOT NULL,
    used_at    timestamptz,
    created_at timestamptz   NOT NULL DEFAULT now()
);

CREATE INDEX auth_tokens_user_idx ON auth_tokens (user_id, purpose);

CREATE TABLE hunts (
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    owner_id        uuid NOT NULL REFERENCES users (id),
    title           text NOT NULL,
    description     text NOT NULL DEFAULT '',
    status          hunt_status     NOT NULL DEFAULT 'draft',
    visibility      hunt_visibility NOT NULL DEFAULT 'public',
    invitation_code char(6),
    closes_at       timestamptz,
    published_at    timestamptz,
    closing_at      timestamptz,
    closed_at       timestamptz,
    end_reason      hunt_end_reason,
    created_at      timestamptz NOT NULL DEFAULT now(),
    updated_at      timestamptz NOT NULL DEFAULT now(),

    CONSTRAINT hunts_title_length CHECK (char_length(title) BETWEEN 3 AND 100),
    CONSTRAINT hunts_description_length CHECK (char_length(description) <= 1000),
    CONSTRAINT hunts_invitation_code_format CHECK (
        invitation_code IS NULL OR invitation_code ~ '^[A-Z0-9]{6}$'
    ),
    CONSTRAINT hunts_private_has_code CHECK (
        (visibility = 'private') = (invitation_code IS NOT NULL)
    ),
    CONSTRAINT hunts_published_date CHECK (
        status = 'draft' OR published_at IS NOT NULL
    ),
    CONSTRAINT hunts_ending_fields CHECK (
        (status IN ('closing', 'closed'))
        = (end_reason IS NOT NULL AND closing_at IS NOT NULL)
    ),
    CONSTRAINT hunts_closed_date CHECK (
        (status = 'closed') = (closed_at IS NOT NULL)
    )
);

CREATE UNIQUE INDEX hunts_invitation_code_unique ON hunts (invitation_code)
    WHERE invitation_code IS NOT NULL;
CREATE INDEX hunts_owner_idx ON hunts (owner_id);
CREATE INDEX hunts_closing_idx ON hunts (closing_at) WHERE status = 'closing';
CREATE INDEX hunts_closes_at_idx ON hunts (closes_at)
    WHERE status = 'published' AND closes_at IS NOT NULL;
CREATE INDEX hunts_public_list_idx ON hunts (published_at DESC)
    WHERE status = 'published' AND visibility = 'public';

CREATE TABLE steps (
    id                         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    hunt_id                    uuid NOT NULL REFERENCES hunts (id) ON DELETE CASCADE,
    position                   integer NOT NULL,
    title                      text NOT NULL,
    instruction                text NOT NULL,
    expected_answer            text NOT NULL,
    expected_answer_normalized text NOT NULL,
    created_at                 timestamptz NOT NULL DEFAULT now(),

    CONSTRAINT steps_position_positive CHECK (position >= 1),
    CONSTRAINT steps_position_unique UNIQUE (hunt_id, position)
        DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE participations (
    id                       uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    hunt_id                  uuid NOT NULL REFERENCES hunts (id) ON DELETE CASCADE,
    player_id                uuid NOT NULL REFERENCES users (id),
    status                   participation_status NOT NULL DEFAULT 'in_progress',
    last_validated_position  integer NOT NULL DEFAULT 0,
    started_at               timestamptz NOT NULL DEFAULT now(),
    completed_at             timestamptz,
    active_seconds           integer NOT NULL DEFAULT 0,
    last_activity_at         timestamptz NOT NULL DEFAULT now(),
    closure_notified_at      timestamptz,

    CONSTRAINT participations_last_validated_position_positive CHECK (last_validated_position >= 0),
    CONSTRAINT participations_active_seconds_positive CHECK (active_seconds >= 0),
    CONSTRAINT participations_completed_date CHECK (
        (status = 'completed') = (completed_at IS NOT NULL)
    ),
    CONSTRAINT participations_one_per_player UNIQUE (hunt_id, player_id)
);

CREATE INDEX participations_player_idx ON participations (player_id);
CREATE INDEX participations_hunt_status_idx ON participations (hunt_id, status);

CREATE TABLE attempts (
    id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    participation_id uuid NOT NULL REFERENCES participations (id) ON DELETE CASCADE,
    step_id          uuid NOT NULL REFERENCES steps (id) ON DELETE CASCADE,
    attempted_at     timestamptz NOT NULL DEFAULT now(),
    is_correct       boolean NOT NULL
);

CREATE INDEX attempts_participation_idx ON attempts (participation_id, step_id);

CREATE TABLE badges (
    id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    participation_id uuid NOT NULL REFERENCES participations (id) ON DELETE CASCADE,
    code             text NOT NULL DEFAULT 'completion',
    awarded_at       timestamptz NOT NULL DEFAULT now(),

    CONSTRAINT badges_one_per_code UNIQUE (participation_id, code)
);

CREATE TABLE reports (
    id             uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    reporter_id    uuid NOT NULL REFERENCES users (id),
    target_hunt_id uuid REFERENCES hunts (id) ON DELETE CASCADE,
    target_user_id uuid REFERENCES users (id),
    reason         text NOT NULL,
    created_at     timestamptz NOT NULL DEFAULT now(),

    CONSTRAINT reports_reason_not_blank CHECK (char_length(btrim(reason)) > 0),
    CONSTRAINT reports_one_target CHECK (
        num_nonnulls(target_hunt_id, target_user_id) = 1
    )
);

CREATE INDEX reports_created_idx ON reports (created_at DESC);

COMMIT;
