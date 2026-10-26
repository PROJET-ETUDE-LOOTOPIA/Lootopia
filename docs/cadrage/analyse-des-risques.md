# Analyse des risques et plans B - Lootopia

| | |
| --- | --- |
| **Document** | Analyse des risques et plans B, Lootopia (MVP) |
| **Version** | 1.0 |
| **Date** | 26/10/2026 |
| **Statut** | Validé par l'équipe |
| **Rédacteurs** | Mathéo Souchet, Elias Forget, Alexis Ballenghien, Alexis Cantin, Arthur Millet |
| **Documents liés** | [Cahier des charges](cahier-des-charges.md), [Rétroplanning](retroplanning.md), [RACI](raci.md) |

### Historique des versions

| Version | Date | Auteur | Modifications |
| --- | --- | --- | --- |
| 1.0 | 26/10/2026 | Équipe | Extraction de la section 8.1 du cahier des charges v1.0 dans un document dédié |

## 1. Risques

| Réf. | Risque | Prob. | Impact | Réponse |
| --- | --- | --- | --- | --- |
| R1 | Périmètre trop large | Élevée | Élevé | MoSCoW, Must protégés, règle de coupe, premier sprint sur le scénario complet minimal |
| R2 | Un enrichissement fragilise l'existant | Moyenne | Élevé | Aucun Could avant que les Must soient testés, une branche par enrichissement |
| R3 | Droits d'accès mal maîtrisés | Moyenne | Élevé | Matrice des permissions (section 2.1 du [cahier des charges](cahier-des-charges.md#21-matrice-des-permissions)) vérifiée par des tests d'autorisation, par rôle et par propriétaire |
| R4 | Progression perdue ou incohérente | Moyenne | Élevé | Enregistrement à chaque validation, test de reprise de session (US-4.4) |
| R5 | Disponibilité inégale, compétences variables | Élevée | Moyen | Référent et suppléant par domaine ([RACI](raci.md)), capacité recalculée à chaque itération |
| R6 | Preuves de qualité et de contribution insuffisantes | Moyenne | Élevé | Intégration continue dès la première itération, tickets et revues nominatifs, journal des décisions |
| R7 | Démonstration non reproductible | Moyenne | Élevé | Jeu de données de démonstration, essai par un tiers, vidéo de démo/explicative |
| R8 | Dépendance à un service externe payant ou limité | Moyenne | Moyen | Aucun service externe dans le MVP |
