#!/usr/bin/env node
// Verifie que le message de commit respecte les conventions du projet
// (voir CONTRIBUTING.md, section "Conventions de nommage des commits").
// Affiche un message d'erreur clair.

const fs = require('fs');
const path = require('path');
const { execFileSync } = require('child_process');
const { validateHeader } = require('./lib/validate-header.cjs');

/**
 * Arrete le script avec un message d'erreur lorsque le fichier recu est refuse.
 * @param {string} reason Raison du refus.
 * @returns {never} Ne retourne pas, le processus se termine avec le code 1.
 */
function rejectPath(reason) {
  console.error('');
  console.error(`Verification du commit impossible : ${reason}`);
  console.error('');
  process.exit(1);
}

/**
 * Renvoie le chemin absolu du dossier git du depot courant.
 * @returns {string} Chemin absolu du dossier git (par exemple .git, ou le dossier d'un worktree).
 */
function gitDirectory() {
  return execFileSync('git', ['rev-parse', '--absolute-git-dir'], { encoding: 'utf8' }).trim();
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
 * Verifie que le chemin recu designe un fichier situe dans le dossier git du depot,
 * comme le fichier COMMIT_EDITMSG transmis par git au hook commit-msg.
 * Empeche de lire un fichier arbitraire via l'argument de la ligne de commande.
 * @param {string | undefined} input Chemin transmis en argument.
 * @returns {string} Chemin absolu et normalise du fichier de message.
 */
function resolveCommitMessagePath(input) {
  if (!input) {
    rejectPath('aucun fichier de message fourni.');
  }
  const gitDir = comparablePath(gitDirectory());
  const resolved = path.resolve(input);
  if (!comparablePath(resolved).startsWith(gitDir + path.sep)) {
    rejectPath('le fichier de message doit se trouver dans le dossier git du depot.');
  }
  if (!fs.statSync(resolved, { throwIfNoEntry: false })?.isFile()) {
    rejectPath('le fichier de message est introuvable.');
  }
  return resolved;
}

const filePath = resolveCommitMessagePath(process.argv[2]);
const raw = fs.readFileSync(filePath, 'utf8');
const header = raw.split('\n')[0].replace(/\r$/, '');

function fail(problem, example) {
  console.error('');
  console.error('Commit refuse : le message ne respecte pas les conventions du projet (voir CONTRIBUTING.md).');
  console.error(`Message recu  : "${header}"`);
  console.error(`Probleme      : ${problem}`);
  if (example) {
    console.error(`Exemple valide: "${example}"`);
  }
  console.error('');
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
