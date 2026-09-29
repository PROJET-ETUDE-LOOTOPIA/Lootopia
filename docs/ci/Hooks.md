# Git hooks

## Table des matières

- [Commits](#commits)
  - [Choix des technologies](#choix-des-technologies)
    - [Husky](#husky)
    - [Script Node](#script-node)
  - [Fonctionnement du script](#fonctionnement-du-script)
  - [Tests manuels à effectuer](#tests-manuels-à-effectuer)
    - [Vérifier que les hooks sont bien installés](#vérifier-que-les-hooks-sont-bien-installés)
    - [Commit invalide en terminal → doit être rejeté avec un message clair](#commit-invalide-en-terminal--doit-être-rejeté-avec-un-message-clair)
    - [Vérifier qu'un `git commit --no-verify` contourne le hook](#vérifier-quun-git-commit---no-verify-contourne-le-hook)

## Commits

Ce projet bloque tout commit dont le message ne respecte pas la convention
[Conventional Commits](https://www.conventionalcommits.org/) (`feat:`, `fix:`, `chore:`, `docs:`, `refactor:`, `test:`, `style:`, `perf:`, `ci:`).

### Choix des technologies

#### Husky

La vérification est faite par un hook git natif (`commit-msg`), installé par **Husky**, qui appelle un script Node ([scripts/verify-commit-msg.cjs](scripts/verify-commit-msg.cjs)). Le hook s'applique depuis n'importe quel terminal/interface utilisant git.

Nous avons choisi de ne pas passer directement via le `.git/hooks` car ce dernier n'est pas versionné. Par conséquent, chaque personne qui va cloner le projet devra recréer à la main le fichier. C'est pour cette raison que nouos passons par Husky qui change l'emplacement où git va chercher les hooks.

Le script `"prepare": "husky"` dans [package.json](package.json) configure `core.hooksPath` vers `.husky/_` à chaque `npm install`

#### Script Node

La première version de ce hook utilisait commitlint, mais ses messages sortent avec des codes couleur ANSI (`[90m`, `[31m`...) que l'interface de VsCode n'interprète pas. Le résultat en sortie après un commit bloqué était donc illisible. Le script `verify-commit-msg.cjs` lui, n'affiche que du texte brut, avec un seul message ciblé par situation.

### Fonctionnement du script

Les messages d'erreur sont personnalisés en français, un par situation :

| Situation | Message |
|---|---|
| Message vide | `le message est vide.` |
| Pas de type (`corrige le bug`) | `aucun type reconnu au debut du message. Types valides : ...` |
| Type invalide (`feature: ...`) | `le type "feature" n'existe pas. Types valides : ...` |
| Scope en majuscule (`feat(Auth): ...`) | `le scope "(Auth)" doit etre en minuscules.` |
| Description vide (`feat:`) | `il manque une description apres "feat:".` |
| Point final (`fix: corrige le bug.`) | `la description ne doit pas se terminer par un point.` |
| Majuscule en début de description (`fix: Corrige...`) | `la description doit commencer par une minuscule.` |
| Première ligne trop longue (>100 car.) | `la premiere ligne fait X caracteres (max 100)...` |

Chaque erreur affiche aussi le message reçu et un exemple valide, par exemple :
```
Commit refuse : le message ne respecte pas le format Conventional Commits.
Message recu  : "test"
Probleme      : aucun type reconnu au debut du message. Types valides : feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert.
Exemple valide: "fix: corrige le crash au demarrage"
```

Pour changer un message ou ajouter une règle, il faut éditer directement [scripts/verify-commit-msg.cjs](scripts/verify-commit-msg.cjs). Chaque cas est représenté par un `if` qui appelle `fail(problème, exemple)`.

### Tests manuels à effectuer

#### Vérifier que les hooks sont bien installés
```bash
npm install
git config core.hooksPath
# doit afficher : .husky/_
```

#### Commit invalide en terminal → doit être rejeté avec un message clair
Tester chaque situation ci-dessous et vérifier que le message affiché correspond bien au tableau plus haut :
```bash
git commit --allow-empty -m "corrige le bug de connexion"     # pas de type
git commit --allow-empty -m "feature: ajoute un truc"         # type invalide
git commit --allow-empty -m "feat(Auth): ajoute le login"     # scope en majuscule
git commit --allow-empty -m "feat:"                           # description vide
git commit --allow-empty -m "fix: corrige le bug."            # point final
git commit --allow-empty -m "fix: Corrige le bug"             # majuscule en début de description
```

Tester également depuis une interface comme celle de VsCode

#### Vérifier qu'un `git commit --no-verify` contourne le hook
```bash
git commit --allow-empty -m "mauvais message" --no-verify
```