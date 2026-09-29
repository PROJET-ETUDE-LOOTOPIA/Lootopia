#!/usr/bin/env node
// Verifie que le message de commit respecte les conventions du projet
// (voir CONTRIBUTING.md, section "Conventions de nommage des commits").
// Affiche un message d'erreur clair.

const fs = require('fs');
const { validateHeader } = require('./lib/validate-header.cjs');

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

// Laisse passer les commits générés automatiquement par git.
if (/^(Merge|Revert) /.test(header)) {
  process.exit(0);
}

const result = validateHeader(header);

if (!result.valid) {
  fail(result.problem, result.example);
}

process.exit(0);
