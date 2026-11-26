import js from "@eslint/js";
import globals from "globals";
import tseslint from "typescript-eslint";
import reactHooks from "eslint-plugin-react-hooks";
import prettier from "eslint-config-prettier";
import checkFile from "eslint-plugin-check-file";

/**
 * Motif micromatch acceptant un nom en kebab-case ou en PascalCase.
 * Il reprend les motifs KEBAB_CASE et PASCAL_CASE d'eslint-plugin-check-file, qui ne permet pas
 * de combiner deux conventions nommées.
 */
const KEBAB_OU_PASCAL_CASE = "@(+([a-z])*([a-z0-9])*(-+([a-z0-9]))|*([A-Z]*([a-z0-9])))";

/**
 * Règles de nommage du code TypeScript (voir CONTRIBUTING.md, "Nommage dans le code TypeScript").
 * Les propriétés d'objets ne sont volontairement pas contrôlées (formats imposés par des
 * bibliothèques ou des API externes).
 *
 * @param {{ pascalCaseAutorise: boolean }} options Autorise le PascalCase pour les variables et
 * fonctions (composants React côté frontend).
 * @returns {object} Configuration de la règle @typescript-eslint/naming-convention.
 */
function reglesNommageTypeScript({ pascalCaseAutorise }) {
  const formatsVariable = pascalCaseAutorise
    ? ["camelCase", "UPPER_CASE", "PascalCase"]
    : ["camelCase", "UPPER_CASE"];

  return [
    "error",
    {
      selector: "variable",
      format: formatsVariable,
      leadingUnderscore: "allow",
    },
    {
      selector: "function",
      format: pascalCaseAutorise ? ["camelCase", "PascalCase"] : ["camelCase"],
    },
    {
      selector: "parameter",
      format: ["camelCase"],
      leadingUnderscore: "allow",
    },
    { selector: "typeLike", format: ["PascalCase"] },
    { selector: "enumMember", format: ["PascalCase"] },
  ];
}

/**
 * Configuration ESLint unique du dépôt (backend, frontend et scripts).
 * Les règles de style sont désactivées par eslint-config-prettier,
 * le formatage étant délégué à Prettier.
 */
export default tseslint.config(
  {
    ignores: ["**/node_modules/**", "**/dist/**", "**/coverage/**"],
  },
  js.configs.recommended,
  {
    files: ["**/*.ts", "**/*.tsx"],
    extends: [tseslint.configs.recommended],
  },
  {
    files: ["backend/**/*.ts"],
    languageOptions: { globals: globals.node },
  },
  {
    files: ["backend/src/**/*.ts"],
    rules: {
      "@typescript-eslint/naming-convention": reglesNommageTypeScript({
        pascalCaseAutorise: false,
      }),
    },
  },
  {
    files: ["frontend/**/*.{ts,tsx}"],
    languageOptions: { globals: globals.browser },
    extends: [reactHooks.configs.flat.recommended],
  },
  {
    files: ["frontend/src/**/*.{ts,tsx}"],
    rules: {
      "@typescript-eslint/naming-convention": reglesNommageTypeScript({
        pascalCaseAutorise: true,
      }),
    },
  },
  {
    // Nommage des fichiers et dossiers (voir CONTRIBUTING.md, "Nommage des fichiers et dossiers").
    // L'option ignoreMiddleExtensions permet les suffixes de type "compte.service.ts" ou ".test.ts".
    files: ["backend/src/**/*.ts"],
    plugins: { "check-file": checkFile },
    rules: {
      "check-file/filename-naming-convention": [
        "error",
        { "backend/src/**/*.ts": "KEBAB_CASE" },
        { ignoreMiddleExtensions: true },
      ],
      "check-file/folder-naming-convention": ["error", { "backend/src/**/": "KEBAB_CASE" }],
    },
  },
  {
    // Les composants et pages React sont en PascalCase. main.tsx est le point d'entree de Vite.
    files: ["frontend/src/**/*.tsx"],
    ignores: ["frontend/src/main.tsx"],
    plugins: { "check-file": checkFile },
    rules: {
      "check-file/filename-naming-convention": [
        "error",
        { "frontend/src/**/*.tsx": "PASCAL_CASE" },
        { ignoreMiddleExtensions: true },
      ],
    },
  },
  {
    // Les dossiers du frontend sont soit des dossiers de features (kebab-case),
    // soit des dossiers de composants (PascalCase).
    files: ["frontend/src/**/*.{ts,tsx}"],
    plugins: { "check-file": checkFile },
    rules: {
      "check-file/folder-naming-convention": [
        "error",
        { "frontend/src/**/": KEBAB_OU_PASCAL_CASE },
      ],
    },
  },
  {
    files: ["**/*.test.{ts,tsx}", "frontend/jest.setup.ts"],
    languageOptions: { globals: globals.jest },
  },
  {
    files: ["**/*.cjs"],
    languageOptions: { sourceType: "commonjs", globals: globals.node },
  },
  prettier,
);
