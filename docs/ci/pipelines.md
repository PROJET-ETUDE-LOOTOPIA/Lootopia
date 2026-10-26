# Pipelines CI

## Table des matières

- [Pull requests](#pull-requests)
  - [Fonctionnement](#fonctionnement)
  - [Rendre la vérification obligatoire](#rendre-la-vérification-obligatoire)
  - [Bloquer les push directs](#bloquer-les-push-directs)
  - [Tests manuels à effectuer](#tests-manuels-à-effectuer)
- [Changelog et tag de version](#changelog-et-tag-de-version)
  - [Prérequis GitHub](#prérequis-github)
  - [Pousser sur `develop` protégée](#pousser-sur-develop-protégée)
  - [Fonctionnement](#fonctionnement-1)
  - [Calcul de la version](#calcul-de-la-version)
  - [Répartition par section](#répartition-par-section)
  - [Cas particuliers gérés](#cas-particuliers-gérés)
  - [Tests manuels à effectuer](#tests-manuels-à-effectuer-1)

## Pull requests

Ce projet vérifie le titre des pull requests (même format que les commits, décrit dans [CONTRIBUTING.md](../../CONTRIBUTING.md)). Contrairement aux commits et aux branches (voir [Git hooks](hooks.md)), cette vérification ne peut pas passer par un hook git car le titre d'une PR est un objet GitHub.

La vérification est faite via une CI GitHub Actions ([.github/workflows/pr-title.yml](../../.github/workflows/pr-title.yml)), déclenchée à l'ouverture, la modification ou la mise à jour d'une pull request. Elle appelle [scripts/verify-pr-title.cjs](../../scripts/verify-pr-title.cjs), qui réutilise la même logique de validation que le hook de commit, factorisée dans [scripts/lib/validate-header.cjs](../../scripts/lib/validate-header.cjs) pour ne pas dupliquer les règles entre les deux scripts.

### Fonctionnement

Le workflow lit `github.event.pull_request.title` et le transmet au script via la variable d'environnement `PR_TITLE`. Le script applique les mêmes règles que pour un message de commit (type, description non vide, minuscule, pas de point final, 72 caractères max) et échoue si le titre n'est pas conforme, ce qui fait échouer le job.

### Rendre la vérification obligatoire

Un job GitHub Actions qui échoue n'empêche pas par défaut de merger la pull request. Pour bloquer réellement le merge, il faut une règle côté GitHub qui exige que ce check passe.

Mise en place :

1. Repo GitHub → **Settings** → **Rules** → **Rulesets** → **New branch ruleset**.
2. **Ruleset Name** : ex. `main-protection`.
3. **Enforcement status** : `Active`
4. **Target branches** → **Add target** → `Include by pattern` puis un pattern (ex. `main`, `develop`).
5. Dans **Rules**, cocher **Require status checks to pass** → **Add checks** → chercher `verify-pr-title` (n'apparaît dans la liste qu'après au moins une exécution du workflow, donc ouvrir d'abord une PR de test si ce n'est pas déjà fait).
6. Sauvegarder.

Tant que cette règle n'est pas active, l'échec du check reste visible dans l'onglet **Checks** de la PR mais n'empêche pas le merge.

### Bloquer les push directs

Ce même ruleset peut aussi empêcher de pousser directement sur la branche protégée: 
- cocher **Require a pull request before merging** dans les **Rules** du ruleset. 

Une fois activée, le seul moyen de faire arriver du code sur `main`/`develop` est de passer par une pull request mergée.

### Tests manuels à effectuer

1. Ouvrir une pull request avec un titre non conforme (ex. `ajoute un truc`) → le check doit échouer, avec le message d'erreur visible dans les logs du job.
2. Modifier le titre pour qu'il soit conforme (ex. `feat(auth): ajoute la connexion via email`) → le check doit repasser au vert.
3. Une fois le ruleset actif, vérifier que le bouton de merge reste désactivé tant que le check `verify-pr-title` n'est pas au vert.
4. Essayer un `git push` direct sur `main` depuis une modification locale → doit être rejeté par GitHub une fois **Require a pull request before merging** activé.

## Changelog et tag de version

Quand une pull request `develop → main` est ouverte, deux workflows travaillent ensemble pour tenir `CHANGELOG.md` à jour et créer automatiquement le tag de version :

### Prérequis GitHub

Ces workflows poussent des commits (`changelog-preview.yml` sur `develop`) et des tags (`release-tag.yml`) avec le `GITHUB_TOKEN` par défaut. Sans ce réglage, le push échoue même si le workflow déclare `permissions: contents: write` dans son YAML :

1. Repo GitHub → **Settings** → **Actions** → **General**.
2. Descendre jusqu'à **Workflow permissions**.
3. Passer de **Read repository contents and packages permissions** (réglage par défaut, lecture seule) à **Read and write permissions**.
4. Sauvegarder.

Ce réglage définit un plafond global pour le dépôt : même si un workflow demande `contents: write` dans son YAML, GitHub le limite quand même à la lecture seule tant que ce paramètre n'est pas passé sur "Read and write". C'est ce qui bloquait le push initialement pendant les tests (le job restait en attente d'approbation/échouait silencieusement sur le push).

### Pousser sur `develop` protégée

`develop` est protégée par un ruleset (pull request et status checks obligatoires). Le `GITHUB_TOKEN` du workflow ne figure pas dans la bypass list et son push est refusé. `changelog-preview.yml` pousse donc avec un token personnel d'un admin du repo, qui a le bypass via le rôle **Repository admin** :

1. Compte GitHub d'un admin → **Settings** → **Developer settings** → **Personal access tokens** → **Fine-grained tokens** → **Generate new token**.
2. **Resource owner** : l'organisation `PROJET-ETUDE-LOOTOPIA` (si elle exige une approbation des tokens, un owner doit l'approuver). **Repository access** : `Only select repositories` → Lootopia.
3. **Repository permissions** → **Contents** : `Read and write`. Choisir une expiration et noter la date pour le renouveler.
4. Repo → **Settings** → **Secrets and variables** → **Actions** → **New repository secret** nommé `CHANGELOG_PUSH_TOKEN`, avec le token comme valeur.
5. Dans le ruleset de `develop`, vérifier que **Repository admin** est dans la **Bypass list** (mode `Always allow`).

Le token est lié à une personne : s'il expire ou si elle quitte l'organisation, le push du changelog échoue jusqu'à son remplacement.

- [.github/workflows/changelog-preview.yml](../../.github/workflows/changelog-preview.yml) : se déclenche à l'ouverture ou la mise à jour de la PR. Calcule la prochaine version et écrit la section de changelog correspondante, puis pousse un commit directement sur `develop` (donc visible dans le diff de la PR avant le merge).
- [.github/workflows/release-tag.yml](../../.github/workflows/release-tag.yml) : se déclenche quand cette PR est **mergée**. Relit la version déjà écrite en tête de `CHANGELOG.md` (elle vient d'arriver sur `main` via le merge) et crée le tag git correspondant.

Cette séparation en deux temps est volontaire : le tag ne doit exister que pour du code réellement livré sur `main`, pas pour un brouillon encore en cours de revue. Créer un tag est un `git push` sur une ref `refs/tags/...`, pas sur la branche `main` elle-même : ce n'est donc pas bloqué par une règle "Require a pull request before merging" sur `main` (voir [Bloquer les push directs](#bloquer-les-push-directs)), contrairement à un commit qui modifierait directement `main`.

### Fonctionnement

Toute la logique de calcul (version, sections) est factorisée dans [scripts/lib/changelog.cjs](../../scripts/lib/changelog.cjs), sans aucun appel git/GitHub, pour rester testable isolément. L'orchestration se fait dans deux scripts :

- [scripts/generate-changelog.cjs](../../scripts/generate-changelog.cjs) : appelé par `changelog-preview.yml`. Trouve le dernier tag réel (`git tag`), liste les PR mergées dans `develop` depuis la date de ce tag (via `gh pr list --state merged --base develop`, sans filtre de date si aucun tag n'existe), les regroupe par type, calcule la prochaine version et écrit le résultat en tête de `CHANGELOG.md`.
- [scripts/extract-latest-version.cjs](../../scripts/extract-latest-version.cjs) : appelé par `release-tag.yml`. Relit simplement la version en tête de `CHANGELOG.md`.

### Calcul de la version

Le chiffre **MAJOR** (premier chiffre) n'est jamais modifié automatiquement : c'est une décision manuelle, réservée à une vraie mise en production. Les deux autres chiffres suivent la règle donnée au départ :

- Au moins une PR `feat` dans le lot → le chiffre **MINOR** (au milieu) monte d'un cran, **PATCH** repart à 0.
- Sinon (uniquement des `fix`, `docs`, `test`, etc.) → seul le chiffre **PATCH** (dernier) monte d'un cran.

Si aucun tag n'existe encore, la version de référence est `0.0.0`, donc le tout premier tag généré sera `0.1.0` (s'il y a un `feat` dans le lot) ou `0.0.1` (sinon).

### Répartition par section

Chaque type de commit/PR a sa propre section dans le changelog :

| Type | Section |
|---|---|
| `feat` | `### Added` |
| `fix` | `### Fixed` |
| `refactor` | `### Changed` |
| `perf` | `### Performance` |
| `docs` | `### Documentation` |
| `style` | `### Style` |
| `test` | `### Tests` |
| `build` | `### Build` |
| `ci` | `### CI` |
| `chore` | `### Chore` |
| `revert` | `### Reverted` |

### Cas particuliers gérés

- **PR relancée plusieurs fois avant merge** (`synchronize`) : le script détecte que la dernière entrée de `CHANGELOG.md` ne correspond à aucun tag réel (c'est un brouillon d'une exécution précédente du même job) et la remplace, au lieu d'empiler des entrées en double.
- **Idempotence** : si rien n'a changé depuis la dernière exécution, le fichier généré est strictement identique à l'existant, donc aucun commit n'est poussé.
- **Comparaison de dates entre fuseaux horaires** : `git log --format=%aI` renvoie une date avec l'offset local (ex. `+02:00`) alors que l'API GitHub renvoie de l'UTC (`Z`). Une comparaison de chaînes de caractères entre les deux est incorrecte (testé et corrigé pendant le développement). Le script convertit les deux en objets `Date` avant de comparer.

### Tests manuels à effectuer

Test réalisé en conditions réelles sur le dépôt GitHub (nécessite `gh` authentifié) :

```bash
# Préparation : une branche develop à jour avec main
# (remplacer origin par le nom de ton remote si besoin)
git checkout -b develop main
git push origin develop

# Simuler une PR feat mergée dans develop
git checkout -b feature/exemple develop
# ... modifications ...
git commit -m "feat: exemple de fonctionnalite"
git push origin feature/exemple
gh pr create --base develop --head feature/exemple --title "feat: exemple de fonctionnalite" --body "test"
gh pr merge --merge --delete-branch

# Lancer le générateur localement (ou ouvrir une vraie PR develop -> main pour tester le workflow)
node scripts/generate-changelog.cjs
cat CHANGELOG.md   # doit afficher # [0.1.0 - <date>] avec la section ### Added
```

Puis :
1. Relancer `node scripts/generate-changelog.cjs` sans nouvelle PR mergée → doit afficher "Changelog deja a jour, rien a faire." sans modifier le fichier.
2. Committer `CHANGELOG.md` sur `develop`, merger dans `main`, puis lancer `node scripts/extract-latest-version.cjs` sur `main` → doit afficher la version attendue (`0.1.0`).
3. Créer le tag (`git tag -a v0.1.0 -m "Release v0.1.0"` puis `git push origin v0.1.0`) et vérifier qu'il apparaît bien sur GitHub.
4. Merger une nouvelle PR (ex. `fix: ...`) dans `develop` après ce tag, relancer le générateur → doit produire une nouvelle entrée `0.1.1` au-dessus de l'ancienne, sans toucher à l'entrée `0.1.0` déjà taguée.
