# Structure des tests

## Table des matières

- [Vue d'ensemble](#vue-densemble)
- [Organisation des fichiers](#organisation-des-fichiers)
- [Convention de nommage et d'emplacement](#convention-de-nommage-et-demplacement)
- [Backend](#backend)
- [Frontend](#frontend)
- [Lancer les tests](#lancer-les-tests)
- [Intégration continue](#intégration-continue)
- [Points à finaliser](#points-à-finaliser)

## Vue d'ensemble

Le dépôt contient deux applications TypeScript indépendantes, `backend/` et `frontend/`. Chacune possède son propre `package.json`, son `tsconfig.json` et sa configuration Jest, car leurs besoins diffèrent (environnement Node pour l'une, environnement navigateur simulé pour l'autre). Le `package.json` de la racine ne sert qu'à `husky` et à lancer les deux suites d'un seul coup.

Outils utilisés :

- **Jest** comme lanceur de tests.
- **ts-jest** pour exécuter directement les fichiers TypeScript.
- **supertest** (backend) pour tester les routes Express sans démarrer de serveur.
- **Testing Library** et **jest-environment-jsdom** (frontend) pour tester les composants React comme un utilisateur les utiliserait.

## Organisation des fichiers

```
Lootopia/
  package.json              lance les tests du backend puis du frontend
  backend/
    package.json
    tsconfig.json
    jest.config.cjs         environnement node
    src/
      **/*.test.ts          tests colocalisés avec le code testé
  frontend/
    package.json
    tsconfig.json
    jest.config.cjs         environnement jsdom
    jest.setup.ts           importe les matchers de jest-dom
    src/
      **/*.test.ts
      **/*.test.tsx
  .github/workflows/
    tests.yml               job de CI qui exécute les deux suites
```

## Convention de nommage et d'emplacement

Les tests unitaires et de composants sont colocalisés : le fichier de test se trouve dans le même dossier que le fichier qu'il teste, avec le même nom suivi de `.test`.

```
src/components/Button/
  Button.tsx
  Button.test.tsx
```

Avantages : le test est facile à retrouver, il suit le fichier quand celui-ci est déplacé ou supprimé, et les imports restent courts (`./Button`).

Règles :

- Un fichier de test par fichier testé.
- Le nom du fichier de test est `<nom-du-fichier>.test.ts` (ou `.test.tsx` pour un composant React).
- Un fichier de test ne couvre que la responsabilité du fichier qu'il teste.
- Les tests de bout en bout, s'il y en a un jour, ne sont pas colocalisés : ils concernent plusieurs composants et auront leur propre dossier à la racine, hors de `src/`.

## Backend

Configuration : [backend/jest.config.cjs](../../backend/jest.config.cjs).

- Preset `ts-jest`, environnement `node`.
- Fichiers détectés : `src/**/*.test.ts`.
- Compilation TypeScript en mode `strict` ([backend/tsconfig.json](../../backend/tsconfig.json)).
- `supertest` est installé pour tester les routes HTTP de l'application Express en important l'application sans l'écouter sur un port.

## Frontend

Configuration : [frontend/jest.config.cjs](../../frontend/jest.config.cjs).

- Preset `ts-jest`, environnement `jsdom` (navigateur simulé).
- Fichiers détectés : `src/**/*.test.ts` et `src/**/*.test.tsx`.
- [frontend/jest.setup.ts](../../frontend/jest.setup.ts) est exécuté avant chaque fichier de test et importe `@testing-library/jest-dom`, ce qui ajoute des matchers comme `toBeInTheDocument()`.
- Le JSX est compilé avec `jsx: react-jsx` ([frontend/tsconfig.json](../../frontend/tsconfig.json)).
- Les composants se testent avec `@testing-library/react` et `@testing-library/user-event`.

## Lancer les tests

Depuis la racine du dépôt, après avoir installé les dépendances des trois `package.json` (`npm install` à la racine, dans `backend/` et dans `frontend/`) :

```bash
npm test                      # backend puis frontend
npm test --prefix backend     # backend uniquement
npm test --prefix frontend    # frontend uniquement
```

Pour cibler un seul fichier ou un seul test, passer les arguments à Jest :

```bash
npm test --prefix backend -- src/routes/chasse.test.ts
npm test --prefix frontend -- -t "affiche le titre"
```

## Intégration continue

Le workflow [.github/workflows/tests.yml](../../.github/workflows/tests.yml) se déclenche sur chaque pull request et sur chaque push vers `develop` et `main`. Il installe les dépendances des trois `package.json`, puis exécute les tests du backend et ceux du frontend. Si l'une des deux suites échoue, le job `run-tests` échoue.

Pour que cet échec bloque réellement le merge, le check `run-tests` doit être ajouté aux status checks obligatoires du ruleset de branche. La procédure est décrite dans [Pipelines CI](../ci/pipelines.md#rendre-la-vérification-obligatoire).

## Points à finaliser

- Le script `test` de chaque application utilise l'option `--passWithNoTests` tant qu'aucun test n'existe. Cette option doit être retirée dès l'écriture des premiers tests, sinon la CI passerait au vert même si les tests disparaissaient par erreur.
- `express`, `react` et `react-dom` ne sont pas encore installés : seuls les outils de test le sont. Ils arriveront avec la mise en place de chaque application.
- Si le frontend est généré avec un outil comme Vite, la configuration TypeScript et Jest du frontend devra être rapprochée de celle générée (notamment en cas de modules ESM).
