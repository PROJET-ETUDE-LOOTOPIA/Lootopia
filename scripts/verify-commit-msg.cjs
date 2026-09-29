#!/usr/bin/env node
// Verifie que le message de commit respecte les conventions du projet
// (voir CONTRIBUTING.md, section "Conventions de nommage des commits").
// Affiche un message d'erreur clair, en texte brut (pas de couleurs ANSI :
// le panneau Source Control de VSCode ne les interprete pas).

const fs = require('fs');

const TYPES = [
  'feat', 'fix', 'docs', 'style', 'refactor',
  'perf', 'test', 'chore', 'ci',
];

const MAX_SUBJECT_LENGTH = 72;

const filePath = process.argv[2];
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

// Laisse passer les commits generes automatiquement par git.
if (/^(Merge|Revert) /.test(header)) {
  process.exit(0);
}

if (!header.trim()) {
  fail(
    'le message est vide.',
    'feat(auth): ajoute la connexion via email',
  );
}

const match = header.match(/^([a-zA-Z-]+)(\(([^)]+)\))?:\s?(.*)$/);

if (!match) {
  fail(
    `aucun type reconnu au debut du message. Types autorises : ${TYPES.join(', ')}.`,
    'fix(score): corrige le calcul du score final',
  );
}

const [, type, , scope, subject] = match;

if (!TYPES.includes(type)) {
  fail(
    `le type "${type}" n'existe pas. Types autorises : ${TYPES.join(', ')}.`,
    'feat(auth): ajoute la connexion via email',
  );
}

if (!subject || !subject.trim()) {
  const prefix = `${type}${scope ? `(${scope})` : ''}`;
  fail(
    `il manque une description apres "${prefix}:".`,
    `${prefix}: ajoute la connexion via email`,
  );
}

if (subject.trim().endsWith('.')) {
  fail(
    'la description ne doit pas se terminer par un point.',
    'fix(score): corrige le calcul du score final',
  );
}

if (/^[A-Z]/.test(subject.trim())) {
  fail(
    'la description doit commencer par une minuscule.',
    'fix(score): corrige le calcul du score final',
  );
}

if (subject.trim().length > MAX_SUBJECT_LENGTH) {
  fail(
    `la description fait ${subject.trim().length} caracteres (max ${MAX_SUBJECT_LENGTH}).`,
  );
}

process.exit(0);
