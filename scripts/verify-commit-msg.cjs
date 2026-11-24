#!/usr/bin/env node
// Verifie que le message de commit respecte les conventions du projet
// (voir CONTRIBUTING.md, section "Conventions de nommage des commits").
// Affiche un message d'erreur clair.

const fs = require("fs");
const path = require("path");
const { validateHeader } = require("./lib/validate-header.cjs");

/**
 * Dossier git attendu, relatif a la racine du depot. Git lance toujours les hooks
 * depuis la racine du depot, donc ce chemin est resolu depuis le dossier courant.
 * Les worktrees et sous-modules, ou .git est un fichier, ne sont pas pris en charge.
 */
const GIT_DIR = ".git";

/**
 * Fichiers de message que git transmet au hook commit-msg : COMMIT_EDITMSG pour
 * un commit classique, MERGE_MSG pour un commit de fusion.
 */
const ALLOWED_MESSAGE_FILES = ["COMMIT_EDITMSG", "MERGE_MSG"];

/**
 * Arrete le script avec un message d'erreur lorsque le fichier recu est refuse.
 * @param {string} reason Raison du refus.
 * @returns {never} Ne retourne pas, le processus se termine avec le code 1.
 */
function rejectPath(reason) {
  console.error("");
  console.error(`Verification du commit impossible : ${reason}`);
  console.error("");
  process.exit(1);
}

/**
 * Normalise un chemin pour la comparaison : absolu, et en minuscules sous Windows
 * ou le systeme de fichiers ignore la casse (c:\ et C:\ designent le meme dossier).
 * @param {string} p Chemin a normaliser.
 * @returns {string} Chemin absolu comparable.
 */
function comparablePath(p) {
  const resolved = path.resolve(p);
  return process.platform === 'win32' ? resolved.toLowerCase() : resolved;
}

/**
 * Determine le fichier de message a lire. Le chemin recu en argument sert
 * uniquement a choisir parmi les fichiers autorises du dossier .git : le chemin
 * renvoye est construit par le script, jamais repris de l'argument. Empeche ainsi
 * de lire un fichier arbitraire via la ligne de commande.
 * @param {string | undefined} input Chemin transmis en argument par git.
 * @returns {string} Chemin absolu du fichier de message.
 */
function resolveCommitMessagePath(input) {
  if (!input) {
    rejectPath('aucun fichier de message fourni.');
  }
  if (!fs.statSync(GIT_DIR, { throwIfNoEntry: false })?.isDirectory()) {
    rejectPath('le hook doit etre lance a la racine du depot, ou .git est un dossier (worktrees et sous-modules non pris en charge).');
  }
  const requested = comparablePath(input);
  const match = ALLOWED_MESSAGE_FILES.map((name) => path.resolve(GIT_DIR, name)).find(
    (candidate) => comparablePath(candidate) === requested,
  );
  if (!match) {
    rejectPath(`le fichier de message doit etre l'un de ${ALLOWED_MESSAGE_FILES.join(', ')} dans le dossier .git du depot.`);
  }
  if (!fs.statSync(match, { throwIfNoEntry: false })?.isFile()) {
    rejectPath('le fichier de message est introuvable.');
  }
  return match;
}

const filePath = resolveCommitMessagePath(process.argv[2]);
const raw = fs.readFileSync(filePath, 'utf8');
const header = raw.split('\n')[0].replace(/\r$/, '');

function fail(problem, example) {
  console.error("");
  console.error(
    "Commit refuse : le message ne respecte pas les conventions du projet (voir CONTRIBUTING.md).",
  );
  console.error(`Message recu  : "${header}"`);
  console.error(`Probleme      : ${problem}`);
  if (example) {
    console.error(`Exemple valide: "${example}"`);
  }
  console.error("");
  process.exit(1);
}

// Laisse passer les commits générés automatiquement par git.
if (/^(Merge|Revert) /.test(header)) {
  process.exit(0);
}

const result = validateHeader(header);

if (!result.valid) {
  fail(result.problem, result.example);
}

process.exit(0);
