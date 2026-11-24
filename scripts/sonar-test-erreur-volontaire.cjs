// FICHIER DE TEST A SUPPRIMER.
// Contient une erreur volontaire pour verifier que SonarQube la detecte
// (dans l'IDE et dans la pipeline) et que la Quality Gate echoue.
// Ce fichier n'est appele par aucun script ni hook.

/**
 * Indique si une valeur n'est pas un nombre.
 * Erreur volontaire (regle javascript:S2688) : une comparaison avec NaN est
 * toujours fausse, il faudrait utiliser Number.isNaN(value).
 * @param {number} value Valeur a tester.
 * @returns {boolean} Toujours false a cause de l'erreur volontaire.
 */
function isNotANumber(value) {
  return value === NaN;
}

module.exports = { isNotANumber };
