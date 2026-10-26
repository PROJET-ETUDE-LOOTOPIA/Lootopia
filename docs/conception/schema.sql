-- Schéma PostgreSQL de Lootopia (MVP), proposition pour le jalon 2.
--
-- Statut : brouillon à valider par l'équipe (référent Données et sécurité).
-- Rédigé avec l'aide de Claude (Anthropic). Selon la politique d'usage de
-- l'IA, ce script n'est exécuté que par un humain, sur une base locale.
--
-- Principes de conception (voir modele-de-donnees.md) :
--   * Aucun compte n'est supprimé physiquement. Une suppression volontaire ou
--     un bannissement change le statut du compte (RM11, RM12), vide ses
--     données personnelles, et l'identifiant non personnel reste en base. Le
--     libellé "compte supprimé" s'affiche à partir de ce statut.
--   * Suppression volontaire : les chasses publiées restent ouvertes jusqu'à
--     la fin des participations en cours (statut 'closing'), puis se ferment.
--   * Bannissement : les chasses du compte et toutes leurs participations
--     sont supprimées, ainsi que ses propres participations.
--   * Une chasse ne se joue qu'une fois par joueur (Q4).
--   * Les identifiants sont des UUID non devinables, car une ressource
--     d'autrui répond 403 (Q7) et non 404.
--   * Toutes les dates sont en UTC (timestamptz). La date de fermeture est
--     interprétée dans le fuseau Europe/Paris par l'application.
--   * Aucune réponse saisie par un joueur n'est stockée (TR-1).
--
-- Chargé et testé sur PostgreSQL 16. gen_random_uuid et num_nonnulls sont
-- fournis sans extension depuis la version 13.

BEGIN;

-- ---------------------------------------------------------------------------
-- Types énumérés
-- ---------------------------------------------------------------------------

-- Type de compte, fixé à la création (section 2 du cahier).
CREATE TYPE account_type AS ENUM ('user', 'admin');

-- Statut d'un compte. 'deleted' : suppression volontaire (RM11).
-- 'banned' : bannissement par un Admin (RM12, Q6).
CREATE TYPE account_status AS ENUM ('active', 'deleted', 'banned');

-- Statut d'une chasse. 'closing' : l'organisateur a supprimé son compte, la
-- chasse n'accepte plus de nouveaux joueurs mais reste ouverte aux
-- participations en cours (Q5). 'closed' : état terminal, atteint quand plus
-- aucune participation n'est en cours. La date de fermeture optionnelle
-- (RM15) ne change pas le statut : elle est comparée à l'heure courante.
CREATE TYPE hunt_status AS ENUM ('draft', 'published', 'closing', 'closed');

-- Visibilité d'une chasse publiée (RM14).
CREATE TYPE hunt_visibility AS ENUM ('public', 'private');

-- Cause de la fin d'une chasse (Q5). Un bannissement ne passe pas par ces
-- statuts : les chasses du compte banni sont supprimées (Q6).
CREATE TYPE hunt_end_reason AS ENUM ('owner_deleted');

-- Statut d'une participation (RM7).
CREATE TYPE participation_status AS ENUM ('in_progress', 'completed');

-- Jeton à usage unique envoyé par e-mail (US-1.5, US-1.6).
CREATE TYPE token_purpose AS ENUM ('email_confirmation', 'password_reset');

-- Actions journalisées (TR-1).
CREATE TYPE audit_action AS ENUM (
    'signup',
    'login',
    'hunt_publish',
    'hunt_join',
    'step_validate',
    'authorization_denied',
    'report_create',
    'account_ban'
);

-- Type de ressource visée par une entrée de journal.
CREATE TYPE audit_resource_type AS ENUM (
    'user', 'hunt', 'step', 'participation', 'report'
);

-- Résultat d'une action journalisée.
CREATE TYPE audit_result AS ENUM ('success', 'failure');

-- ---------------------------------------------------------------------------
-- Comptes
-- ---------------------------------------------------------------------------

CREATE TABLE users (
    id                uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    -- Données personnelles : vidées à la suppression volontaire (RM11).
    email             text,
    pseudo            text,
    password_hash     text,           -- nul pour un compte créé via Google
    google_subject    text UNIQUE,    -- identifiant stable côté Google (Q1)
    account_type      account_type   NOT NULL DEFAULT 'user',
    status            account_status NOT NULL DEFAULT 'active',
    email_verified_at timestamptz,
    created_at        timestamptz    NOT NULL DEFAULT now(),
    deleted_at        timestamptz,
    banned_at         timestamptz,

    -- Un compte actif a une identité et au moins un moyen de se connecter.
    CONSTRAINT users_active_identity CHECK (
        status <> 'active'
        OR (email IS NOT NULL AND pseudo IS NOT NULL
            AND (password_hash IS NOT NULL OR google_subject IS NOT NULL))
    ),
    -- Un compte supprimé ou banni ne garde aucune donnée personnelle (RM11,
    -- Q6). Seuls l'identifiant, le statut et les dates restent.
    CONSTRAINT users_inactive_no_personal_data CHECK (
        status = 'active'
        OR (email IS NULL AND pseudo IS NULL
            AND password_hash IS NULL AND google_subject IS NULL)
    ),
    -- Les dates de suppression et de bannissement suivent le statut.
    CONSTRAINT users_status_dates CHECK (
        (status = 'deleted') = (deleted_at IS NOT NULL)
        AND (status = 'banned') = (banned_at IS NOT NULL)
    )
);

-- E-mail unique, sans tenir compte de la casse (US-1.1).
CREATE UNIQUE INDEX users_email_unique ON users (lower(email))
    WHERE email IS NOT NULL;

-- Jetons de confirmation d'e-mail et de réinitialisation de mot de passe.
-- Seul le hachage du jeton est stocké, jamais le jeton lui-même.
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

-- Les sessions ne sont pas modélisées : elles dépendent du choix entre session
-- côté serveur et jeton, pas encore tranché (voir la synthèse des réponses).

-- ---------------------------------------------------------------------------
-- Chasses et étapes
-- ---------------------------------------------------------------------------

CREATE TABLE hunts (
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    -- Jamais nul : un compte supprimé reste en base avec son statut (Q5).
    owner_id        uuid NOT NULL REFERENCES users (id),
    title           text NOT NULL,
    description     text NOT NULL DEFAULT '',
    status          hunt_status     NOT NULL DEFAULT 'draft',
    visibility      hunt_visibility NOT NULL DEFAULT 'public',
    invitation_code char(6),        -- 6 caractères majuscules et chiffres (Q18)
    closes_at       timestamptz,    -- date de fermeture optionnelle (RM15)
    published_at    timestamptz,
    closing_at      timestamptz,    -- début de la fermeture progressive (Q5)
    closed_at       timestamptz,    -- fermeture effective
    end_reason      hunt_end_reason,
    created_at      timestamptz NOT NULL DEFAULT now(),
    updated_at      timestamptz NOT NULL DEFAULT now(),

    CONSTRAINT hunts_title_length CHECK (char_length(title) BETWEEN 3 AND 100),
    CONSTRAINT hunts_description_length CHECK (char_length(description) <= 1000),
    -- Une chasse privée a un code, une chasse publique n'en a pas (RM14).
    CONSTRAINT hunts_invitation_code_format CHECK (
        invitation_code IS NULL OR invitation_code ~ '^[A-Z0-9]{6}$'
    ),
    CONSTRAINT hunts_private_has_code CHECK (
        (visibility = 'private') = (invitation_code IS NOT NULL)
    ),
    -- Une chasse sortie du brouillon a une date de publication. Un brouillon
    -- est supprimé avec le compte de son organisateur, il ne se ferme pas.
    CONSTRAINT hunts_published_date CHECK (
        status = 'draft' OR published_at IS NOT NULL
    ),
    -- Une chasse en fermeture ou fermée a une cause et une date de début de
    -- fermeture (Q5). La date de fermeture effective n'existe qu'une fois fermée.
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
-- Chasses en fermeture progressive, à clore quand plus rien n'est en cours.
CREATE INDEX hunts_closing_idx ON hunts (closing_at) WHERE status = 'closing';
-- Liste publique paginée (US-2.1) : chasses publiées et publiques.
CREATE INDEX hunts_public_list_idx ON hunts (published_at DESC)
    WHERE status = 'published' AND visibility = 'public';

CREATE TABLE steps (
    id                         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    hunt_id                    uuid NOT NULL REFERENCES hunts (id) ON DELETE CASCADE,
    position                   integer NOT NULL,
    title                      text NOT NULL,
    instruction                text NOT NULL,   -- indice ou énigme
    -- Relisible par l'Organisateur en brouillon (US-3.2), jamais exposée à un
    -- joueur ni dans une réponse de l'API (RM6, Q23).
    expected_answer            text NOT NULL,
    -- Forme normalisée selon RM9, calculée par l'application à l'écriture.
    expected_answer_normalized text NOT NULL,
    created_at                 timestamptz NOT NULL DEFAULT now(),

    CONSTRAINT steps_position_positive CHECK (position >= 1),
    -- Différée pour permettre le réordonnancement dans une transaction.
    CONSTRAINT steps_position_unique UNIQUE (hunt_id, position)
        DEFERRABLE INITIALLY DEFERRED
);

-- ---------------------------------------------------------------------------
-- Participations, essais, badges
-- ---------------------------------------------------------------------------

CREATE TABLE participations (
    id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    hunt_id          uuid NOT NULL REFERENCES hunts (id) ON DELETE CASCADE,
    player_id        uuid NOT NULL REFERENCES users (id),
    status           participation_status NOT NULL DEFAULT 'in_progress',
    -- Nombre d'étapes validées. L'étape courante est celle de position
    -- validated_steps + 1 ; la progression est donc enregistrée à chaque
    -- validation (US-4.3, US-4.4).
    validated_steps  integer NOT NULL DEFAULT 0,
    started_at       timestamptz NOT NULL DEFAULT now(),
    completed_at     timestamptz,
    -- Temps passé à réaliser la chasse, en secondes (Q15). Le serveur incrémente
    -- ce compteur régulièrement pendant que le joueur joue. Figé à la fin (RM7).
    active_seconds   integer NOT NULL DEFAULT 0,
    last_activity_at timestamptz NOT NULL DEFAULT now(),
    -- Date d'envoi de l'e-mail prévenant de la fermeture prochaine de la chasse
    -- (Q5). Évite un second envoi.
    closure_notified_at timestamptz,

    CONSTRAINT participations_validated_steps_positive CHECK (validated_steps >= 0),
    CONSTRAINT participations_active_seconds_positive CHECK (active_seconds >= 0),
    CONSTRAINT participations_completed_date CHECK (
        (status = 'completed') = (completed_at IS NOT NULL)
    ),
    -- Une chasse ne se joue qu'une fois par joueur, même terminée (Q4).
    CONSTRAINT participations_one_per_player UNIQUE (hunt_id, player_id)
);

CREATE INDEX participations_player_idx ON participations (player_id);
-- Vue de suivi de l'Organisateur, filtrée par statut (US-6.1, US-6.2).
CREATE INDEX participations_hunt_status_idx ON participations (hunt_id, status);

-- Une tentative de réponse. La saisie brute n'est pas stockée (TR-1).
CREATE TABLE attempts (
    id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    participation_id uuid NOT NULL REFERENCES participations (id) ON DELETE CASCADE,
    step_id          uuid NOT NULL REFERENCES steps (id) ON DELETE CASCADE,
    attempted_at     timestamptz NOT NULL DEFAULT now(),
    is_correct       boolean NOT NULL
);

CREATE INDEX attempts_participation_idx ON attempts (participation_id, step_id);

-- Badge de complétion (US-5.1). Une table dédiée prépare les badges
-- supplémentaires, classés Could dans le cahier.
CREATE TABLE badges (
    id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    participation_id uuid NOT NULL REFERENCES participations (id) ON DELETE CASCADE,
    code             text NOT NULL DEFAULT 'completion',
    awarded_at       timestamptz NOT NULL DEFAULT now(),

    CONSTRAINT badges_one_per_code UNIQUE (participation_id, code)
);

-- ---------------------------------------------------------------------------
-- Modération et journal
-- ---------------------------------------------------------------------------

-- Signalement d'une chasse ou d'un organisateur (US-7.1).
CREATE TABLE reports (
    id             uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    reporter_id    uuid NOT NULL REFERENCES users (id),
    target_hunt_id uuid REFERENCES hunts (id) ON DELETE CASCADE,
    target_user_id uuid REFERENCES users (id),
    reason         text NOT NULL,
    created_at     timestamptz NOT NULL DEFAULT now(),

    -- Motif obligatoire.
    CONSTRAINT reports_reason_not_blank CHECK (char_length(btrim(reason)) > 0),
    -- Exactement une cible : une chasse ou un organisateur.
    CONSTRAINT reports_one_target CHECK (
        num_nonnulls(target_hunt_id, target_user_id) = 1
    )
);

CREATE INDEX reports_created_idx ON reports (created_at DESC);

-- Journal des actions sensibles (TR-1) : horodatage, acteur, action,
-- ressource, résultat. Ne contient jamais de mot de passe, de réponse
-- attendue ni de donnée personnelle. Pour un bannissement, resource_id est
-- l'identifiant du compte concerné (Q6). L'acteur reste un identifiant non
-- personnel même après suppression du compte (TR-3).
CREATE TABLE audit_logs (
    id            bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    occurred_at   timestamptz NOT NULL DEFAULT now(),
    actor_id      uuid REFERENCES users (id),  -- nul pour un visiteur anonyme
    action        audit_action NOT NULL,
    resource_type audit_resource_type,
    resource_id   uuid,
    result        audit_result NOT NULL
);

CREATE INDEX audit_logs_occurred_idx ON audit_logs (occurred_at DESC);
CREATE INDEX audit_logs_actor_idx ON audit_logs (actor_id);

COMMIT;

-- ---------------------------------------------------------------------------
-- Règles non exprimées en base, portées par les services applicatifs :
--   * RM2 : un joueur ne rejoint pas sa propre chasse (hunts.owner_id).
--   * RM4 : publication seulement avec au moins une étape et un titre.
--   * RM5, RM6, RM9 : validation des étapes dans l'ordre, côté serveur.
--   * RM8 : les étapes d'une chasse publiée ne sont plus modifiées.
--   * RM13 : le mode essai ne crée aucune participation.
--   * RM15 : une chasse dont closes_at est dépassée n'est plus proposée à de
--     nouveaux joueurs.
--   * Une chasse 'closing' n'accepte plus de nouveau joueur. Elle passe à
--     'closed' quand sa dernière participation en cours se termine ou est
--     supprimée (fin de partie, suppression ou bannissement d'un joueur).
--   * Suppression volontaire : supprimer les brouillons du compte, passer ses
--     chasses publiées à 'closing' (ou 'closed' s'il n'y a aucune participation
--     en cours), puis envoyer l'e-mail de prévenance aux joueurs en cours.
--   * Bannissement : récupérer d'abord les joueurs à prévenir, supprimer les
--     chasses du compte (les étapes, participations, essais, badges et
--     signalements de ces chasses partent en cascade), supprimer ses
--     participations, puis envoyer les e-mails après validation de la
--     transaction.
-- ---------------------------------------------------------------------------
