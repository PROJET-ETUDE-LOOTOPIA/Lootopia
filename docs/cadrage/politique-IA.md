# Politique d'usage de l'IA - Lootopia

| | |
| --- | --- |
| **Document** | Politique IA, Lootopia |
| **Version** | 1.0 |
| **Date** | 26/10/2026 |
| **Statut** | Validé par l'équipe |
| **Rédacteurs** | Mathéo Souchet, Elias Forget, Alexis Ballenghien, Alexis Cantin, Arthur Millet |

L'équipe utilise l'IA générative sur tout le projet, sauf pour la gestion de projet. Pour le code, l'IA est un assistant encadré : elle propose, un membre de l'équipe relit, teste et assume, et elle n'a accès qu'au strict nécessaire.

## 1. Principes

Tout ce qui est produit avec l'IA est de la responsabilité de la personne qui le livre, comme si elle l'avait écrit seule.

1. **Responsabilité humaine** : l'auteur d'une PR, d'un document ou d'une maquette en répond, quel que soit l'outil utilisé.
2. **Compréhension obligatoire** : chaque membre doit pouvoir expliquer ligne par ligne ce qu'il livre. C'est aussi une exigence du dossier technique et de l'oral individuels.
3. **Moindre accès** : l'IA n'accède qu'aux fichiers et commandes nécessaires à la tâche en cours, jamais aux secrets ni aux données réelles.
4. **Décisions humaines** : l'IA peut proposer des options, mais aucune décision (périmètre, priorité, choix technique) n'est prise par elle. Les choix sont consignés et justifiés par l'équipe.
5. **Transparence** : l'usage de l'IA est déclaré là où il a lieu (PR, document), sans honte ni excès de détail.

## 2. Où l'IA est autorisée

L'IA est autorisée partout, encadrée sur le code, et interdite sur la gestion de projet (sauf formulation de phrases).

| Domaine | Statut | Usages permis | Limites |
| --- | --- | --- | --- |
| Gestion de projet (backlog, priorisation MoSCoW, planning, capacité, répartition des tâches, tickets, suivi d'avancement, comptes rendus de revue, journal des décisions) | **Interdit** | Formulation de phrases | Décidé par l'équipe uniquement. |
| Recherche et benchmark | Autorisé | Explorer un sujet, résumer une documentation, comparer des offres | Toute source citée est vérifiée à la main. Aucun chiffre repris sans source. |
| Conception UX et maquettes | Autorisé | Idées de parcours, variantes d'écrans, textes d'interface, revue d'accessibilité | Les écrans retenus respectent WCAG 2.1 AA et sont validés par le référent UX. |
| Architecture et modèle de données | Encadré | Proposer des options, challenger un schéma, lister des risques | Le choix final est pris et justifié par l'équipe dans le journal des décisions. |
| Développement front et back | Encadré | Génération de code, refactoring, explication, débogage | Sections 3 à 5. Code relu et testé avant fusion. |
| Tests | Encadré | Écrire des tests à partir des critères d'acceptation, trouver des cas limites | Un test généré est relu : il doit échouer quand la règle est cassée. |
| CI/CD et configuration | Encadré | Écrire des workflows, Dockerfile, scripts d'installation | Aucun secret fourni à l'IA. Le référent Qualité, CI/CD valide chaque changement. |
| Revue de code | Autorisé en complément | Pré-revue automatique d'une PR | Ne remplace jamais la revue nominative du référent exigée par la Definition of Done. |
| Documentation technique et README | Autorisé | Rédaction, reformulation, traduction | Relue par l'auteur. Le README est testé par une installation réelle. |
| Livrables d'évaluation individuels (dossier technique, oral) | Encadré | Relecture, reformulation | Le contenu et les preuves de contribution sont ceux de l'étudiant. Suivre aussi les règles de l'école. |

## 3. Ce que l'IA peut toucher

Un assistant ou un agent IA travaille sur la branche de la personne qui l'utilise, sans secrets, sans données réelles et sans droit d'écrire sur les branches partagées.

| Ressource | Accès de l'IA | Règle |
| --- | --- | --- |
| Code de sa branche de fonctionnalité | Lecture et écriture | Une branche par ticket. L'IA ne travaille jamais directement sur une branche partagée. |
| Branches main et develop | Aucune écriture | Pas de commit, push, merge ni rebase par l'IA. La fusion passe par une PR revue. |
| Secrets (.env, clés, certificats, identifiants OAuth Google, tokens) | Aucun | Lecture bloquée dans la configuration de l'outil. Jamais collés dans un prompt. |
| Secrets et réglages CI, paramètres du dépôt GitHub | Aucun | Gérés par le référent Qualité, CI/CD uniquement. |
| Base de données | Base locale de développement uniquement | Avec le jeu de données de démonstration. Jamais une base partagée ou hébergée. |
| Données personnelles réelles | Aucun | Pas de vrais e-mails, pseudos ou journaux dans un prompt. Données fictives seulement. |
| Commandes shell | Sur validation | Tests, linter et build : validés au cas par cas. Suppression de fichiers, git push, git reset, migrations, installation de paquets : jamais sans validation humaine explicite. |
| Dépendances | Proposition seulement | Un humain vérifie que le paquet existe, qu'il est maintenu et que sa licence convient avant de l'ajouter. |
| Connecteurs et accès réseau | Documentation publique | Aucun accès à une messagerie, un drive ou un compte personnel depuis l'outil de code. |

Ces règles sont appliquées par la configuration des outils, pas seulement par la bonne volonté. Le dépôt contient :

- un fichier de consignes pour les agents à la racine (par exemple `AGENTS.md` ou `CLAUDE.md`) qui reprend ces règles et les règles métier sensibles (RM6, RM11)
- les fichiers de permissions de chaque outil utilisé, versionnés et relus comme du code
- un `.gitignore` et un scan de secrets en CI, pour qu'un secret ne puisse pas atterrir dans le dépôt.

Exemple de permissions pour Claude Code (`.claude/settings.json`), à adapter à la stack choisie au jalon 2 :

```json
{
  "permissions": {
    "deny": [
      "Read(./.env)",
      "Read(./.env.*)",
      "Read(./secrets/**)",
      "Edit(./.github/workflows/**)",
      "Bash(git push:*)",
      "Bash(git reset:*)",
      "Bash(rm -rf:*)"
    ],
    "ask": [
      "Bash(npm install:*)",
      "Bash(git commit:*)"
    ]
  }
}
```

Les autres outils (Copilot, Cursor, etc.) ont des réglages équivalents : chaque membre configure le sien avant le premier usage sur le dépôt.

## 4. Zones sensibles du code

Sur les modules qui portent la sécurité du MVP, l'IA peut proposer du code, mais la revue est faite par le référent Données et sécurité et les tests d'autorisation sont écrits ou relus par un humain.

| Zone | Exigences liées | Règle supplémentaire |
| --- | --- | --- |
| Authentification et sessions | US-1.1, US-1.2 | Hachage des mots de passe, expiration de session et limitation des tentatives vérifiés par un test. Aucun secret de test réel. |
| Contrôle des droits | Matrice 2.1, RM1, RM2, RM3 | Chaque route générée a ses tests 401, 403 et 404 avant fusion. Un contrôle côté client seul est refusé. |
| Validation des réponses | RM5, RM6, RM9 | La réponse attendue ne doit jamais apparaître dans une réponse API ni dans le code front. Vérifié en revue et par test. |
| Suppression de compte en cascade | RM11, US-1.4 | Transaction tout ou rien testée. Aucune commande de suppression lancée par l'IA sur une base autre que locale. |
| Journalisation | TR-1 | Revue ciblée : aucun mot de passe ni réponse attendue dans les journaux. |
| Migrations de base | Modèle de données | Écrites avec l'aide de l'IA si besoin, mais exécutées uniquement par un humain. |

Une PR qui touche l'une de ces zones est marquée « sécurité » et ne peut pas être fusionnée sur la seule revue automatique.

## 5. Outils, coût et données

Seuls les outils inscrits dans la liste de l'équipe sont utilisés sur le dépôt, avec un compte gratuit ou déjà fourni (école, entreprise), conformément à la contrainte budgétaire 8.2.

- **Liste des outils** : tenue dans le README (outil, usage, compte utilisé, limites du niveau gratuit). Un nouvel outil y est ajouté après accord de l'équipe et consigné dans le journal des décisions.
- **Pas d'IA dans le produit** : le MVP n'intègre aucun service d'IA externe (exigence 5.3 et risque R8). Cette politique couvre l'usage par l'équipe, pas les fonctionnalités de Lootopia.
- **Données envoyées** : uniquement du code du projet et des données fictives. Les options de partage des données pour l'entraînement sont désactivées quand l'outil le permet.
- **Propriété et licences** : un extrait généré qui reproduit visiblement du code existant (licence, commentaire d'origine) est retiré ou attribué correctement.

## 6. Application et révision

La politique s'applique dès sa validation par l'équipe et est relue à chaque fin de jalon.

| Situation | Réponse |
| --- | --- |
| Secret partagé avec une IA ou poussé dans le dépôt | Secret révoqué et régénéré immédiatement, incident noté dans le journal des décisions |
| Usage de l'IA en gestion de projet | Production retirée et refaite par l'équipe |
| Configuration de permissions absente ou contournée | Outil suspendu sur le dépôt jusqu'à correction |

- **Garant** : le référent Qualité, CI/CD et documentation vérifie la présence des fichiers de règles et de permissions dans le dépôt.
- **Révision** : à chaque revue de jalon, l'équipe garde, ajuste ou retire une règle et note le changement dans l'historique des versions de ce document.
