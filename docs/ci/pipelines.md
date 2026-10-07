# Pipelines CI

## Table des matières

- [Pull requests](#pull-requests)
  - [Fonctionnement](#fonctionnement)
  - [Rendre la vérification obligatoire](#rendre-la-vérification-obligatoire)
  - [Bloquer les push directs](#bloquer-les-push-directs)
  - [Tests manuels à effectuer](#tests-manuels-à-effectuer)

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
