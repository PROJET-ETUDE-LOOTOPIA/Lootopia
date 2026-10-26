# Rétroplanning - Lootopia

| | |
| --- | --- |
| **Document** | Rétroplanning, Lootopia (MVP) |
| **Version** | 1.0 |
| **Date** | 26/10/2026 |
| **Statut** | Validé par l'équipe |
| **Rédacteurs** | Mathéo Souchet, Elias Forget, Alexis Ballenghien, Alexis Cantin, Arthur Millet |
| **Documents liés** | [Cahier des charges](cahier-des-charges.md), [Analyse des risques et plans B](analyse-des-risques.md), [RACI](raci.md) |

### Historique des versions

| Version | Date | Auteur | Modifications |
| --- | --- | --- | --- |
| 1.0 | 26/10/2026 | Équipe | Extraction des sections 7.1 et 7.2 du cahier des charges v1.0 dans un document dédié |

Le séquencement des cinq jalons est fixé par le client. Le MVP correspond au cœur du scénario exécutable (tous les Must) à l'issue du jalon 3, puis consolidé au jalon 4.

## 1. Jalons

| Jalon | Période | Sortie attendue | Prérequis |
| --- | --- | --- | --- |
| 1. Cadrage | 28/09/2026 au 30/10/2026 | Périmètre, proposition de valeur, utilisateurs, scénario de démonstration, risques | Aucun |
| 2. Conception | 01/11/2026 au 15/12/2026 | Parcours, écrans essentiels, règles métier, backlog, architecture, modèle de données, sécurité, stratégie de tests, hébergement | Jalon 1 validé |
| 3. Construction | 16/12/2026 au 31/03/2027 | Version exécutable du cœur du scénario | Architecture et backlog stabilisés |
| 4. Consolidation | 01/04/2027 au 15/05/2027 | Version corrigée, sécurisée, testée, éventuellement enrichie | Cœur démontrable |
| 5. Démonstration | 16/05/2027 au 30/06/2027 | Version installable, résultats, limites, suites | Critères de réussite vérifiés |

## 2. Règles de pilotage

- Aucun Could ne démarre tant qu'un Must critique n'est pas finalisé.
- Aucune nouvelle fonctionnalité après le début du jalon 5 : le temps restant va aux tests, à la documentation et à la reproductibilité.
- Chaque jalon a des critères d'entrée et de sortie vérifiables.
- En cas de dérive, la règle de coupe du [cahier des charges](cahier-des-charges.md#12-périmètre-moscow) s'applique : les Could sautent en premier, puis les Should non critiques.
