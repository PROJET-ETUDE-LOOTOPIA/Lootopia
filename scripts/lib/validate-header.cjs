// Regles de validation partagees entre le message de commit et le titre de
// pull request, les deux suivant le meme format dans CONTRIBUTING.md :
// <type>(<scope optionnel>): <description>

const TYPES = [
  'feat', 'fix', 'docs', 'style', 'refactor',
  'perf', 'test', 'chore', 'ci',
];

const MAX_SUBJECT_LENGTH = 72;

// Extrait { type, scope, subject } d'un header, ou null s'il ne correspond
// pas du tout au format <type>(<scope>): <description>.
// Ne valide pas les regles (type autorise, casse, etc.), juste la forme.
function parseHeader(header) {
  const match = header.match(/^([a-zA-Z-]+)(\(([^)]+)\))?:\s?(.*)$/);

  if (!match) {
    return null;
  }

  const [, type, , scope, subject] = match;

  return { type, scope: scope || null, subject };
}

function validateHeader(header) {
  if (!header || !header.trim()) {
    return {
      valid: false,
      problem: 'le message est vide.',
      example: 'feat(auth): ajoute la connexion via email',
    };
  }

  const match = header.match(/^([a-zA-Z-]+)(\(([^)]+)\))?:\s?(.*)$/);

  if (!match) {
    return {
      valid: false,
      problem: `aucun type reconnu au debut du message. Types autorises : ${TYPES.join(', ')}.`,
      example: 'fix(score): corrige le calcul du score final',
    };
  }

  const [, type, , scope, subject] = match;

  if (!TYPES.includes(type)) {
    return {
      valid: false,
      problem: `le type "${type}" n'existe pas. Types autorises : ${TYPES.join(', ')}.`,
      example: 'feat(auth): ajoute la connexion via email',
    };
  }

  if (!subject || !subject.trim()) {
    const prefix = `${type}${scope ? `(${scope})` : ''}`;
    return {
      valid: false,
      problem: `il manque une description apres "${prefix}:".`,
      example: `${prefix}: ajoute la connexion via email`,
    };
  }

  if (subject.trim().endsWith('.')) {
    return {
      valid: false,
      problem: 'la description ne doit pas se terminer par un point.',
      example: 'fix(score): corrige le calcul du score final',
    };
  }

  if (/^[A-Z]/.test(subject.trim())) {
    return {
      valid: false,
      problem: 'la description doit commencer par une minuscule.',
      example: 'fix(score): corrige le calcul du score final',
    };
  }

  if (subject.trim().length > MAX_SUBJECT_LENGTH) {
    return {
      valid: false,
      problem: `la description fait ${subject.trim().length} caracteres (max ${MAX_SUBJECT_LENGTH}).`,
    };
  }

  return { valid: true };
}

module.exports = { validateHeader, parseHeader, TYPES, MAX_SUBJECT_LENGTH };
