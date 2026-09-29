# Guide de contribution

Ce document décrit les conventions à suivre pour contribuer au projet Lootopia.

## Conventions de nommage des branches

Les branches doivent suivre le format suivant :

```
<type>/<description-courte>
```

Types autorisés :

- `feature/` : ajout d'une nouvelle fonctionnalité
- `fix/` : correction d'un bug
- `hotfix/` : correction urgente sur une version en production
- `refactor/` : refactorisation sans changement de comportement
- `docs/` : modification de la documentation
- `test/` : ajout ou modification de tests
- `chore/` : tâches diverses (configuration, dépendances, outillage)
- `ci/` : tâches liées à l'intégration continue

La description doit être courte, en minuscules, en anglais ou en français (au choix mais rester cohérent dans le projet), avec des mots séparés par des tirets.

Exemples :

```
feature/authentification-utilisateur
fix/erreur-calcul-score
docs/mise-a-jour-readme
```

## Conventions de nommage des commits

Le projet suit la convention [Conventional Commits](https://www.conventionalcommits.org/).

Format :

```
<type>(<scope optionnel>): <description>
```

Types autorisés :

- `feat` : nouvelle fonctionnalité
- `fix` : correction de bug
- `docs` : documentation uniquement
- `style` : mise en forme du code (indentation, espaces, etc.), sans changement de logique
- `refactor` : modification du code sans ajout de fonctionnalité ni correction de bug
- `perf` : amélioration de performance
- `test` : ajout ou correction de tests
- `chore` : tâches de maintenance (configuration, dépendances, outillage)
- `ci` : modification de la configuration d'intégration continue

Règles :

- La description est rédigée à l'impératif présent (ex : "ajoute", "corrige", "supprime").
- La description commence par une minuscule et ne se termine pas par un point.
- La description ne dépasse pas 72 caractères.
- Le scope (entre parenthèses) est optionnel et précise la partie du projet concernée.

Exemples :

```
feat(auth): ajoute la connexion via email
fix(score): corrige le calcul du score final
docs(readme): met a jour les instructions d'installation
chore(deps): met a jour les dependances
```

Pour en savoir plus, n'hésitez pas à consulter la documentation associée : [Git hooks](ci/Hooks.md)

## Conventions de nommage des pull requests

Le titre d'une pull request suit le même format que les commits :

```
<type>(<scope optionnel>): <description>
```

Exemple de titre :

```
feat(auth): ajoute la connexion via email
```

## Conventions liées au code

Les conventions spécifiques au code (style, formatage, organisation) dépendent du ou des langages utilisés dans le projet. Elles seront ajoutées ici une fois les technologies du projet définies.
