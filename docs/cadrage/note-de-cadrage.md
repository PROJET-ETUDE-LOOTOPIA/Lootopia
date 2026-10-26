# Note de cadrage : Lootopia

Projet fil rouge M2 EDDSNS - RNCP40166 - Année 2026/2027

| | |
| --- | --- |
| **Projet** | Projet Lootopia, plateforme numérique de chasses au trésor |
| **Commanditaire** | Out of Cache |
| **Cadre** | Projet fil rouge M2 EDDSNS, Sup de Vinci |
| **Équipe** | Mathéo SOUCHET, Elias FORGET, Alexis BALLENGHIEN, Alexis CANTIN, Arthur MILLET |
| **Version** | 1.0, 28/09/2026 |

## Table des matières

1. [Contexte et objectif](#1-contexte-et-objectif)
2. [Proposition de valeur et critères de réussite](#2-proposition-de-valeur-et-critères-de-réussite)
3. [Utilisateurs et besoins](#3-utilisateurs-et-besoins)
4. [Périmètre](#4-périmètre)
   - [4.1 Priorisation](#41-priorisation)
   - [4.2 Renoncements](#42-renoncements)
5. [Parcours de référence](#5-parcours-de-référence)
   - [5.1 Scénario retenu](#51-scénario-retenu)
   - [5.2 Règles métier](#52-règles-métier)
   - [5.3 Scénario de démonstration](#53-scénario-de-démonstration)
6. [Contraintes](#6-contraintes)
7. [Équipe, ressources et organisation](#7-équipe-ressources-et-organisation)
   - [7.1 Responsabilités](#71-responsabilités)
   - [7.2 Fonctionnement](#72-fonctionnement)
   - [7.3 Outils](#73-outils)
8. [Livrables](#8-livrables)
9. [Rétroplanning](#9-rétroplanning)
10. [Risques](#10-risques)

## 1. Contexte et objectif

Out of Cache veut savoir si Lootopia mérite d'être développée. Lootopia est une plateforme de chasses au trésor qui mêle jeu, cartographie, gamification et, quand elle apporte une vraie valeur, réalité augmentée. Il nous confie la réalisation d'un premier prototype. Nous partons de zéro : aucun code, backlog ou architecture n'existe.

La vision du client est plus large que ce que cinq personnes peuvent livrer sur l'année. Notre premier travail est donc un choix entre ce que nous construisons, ce que nous écartons, et pourquoi.

**Objectif.** Un prototype fonctionnel, installable et démontrable. Le client ne demande ni une plateforme complète ni une mise en production.

**Décision du client en fin de projet.** Poursuivre ou non Lootopia. Il attend pour cela des preuves sur le fonctionnement, la qualité, la sécurité, la maintenabilité et les limites de la solution.

**Décision attendue à ce jalon.** Valider le périmètre du prototype et le parcours utilisateur à démontrer (demande client 1).

## 2. Proposition de valeur et critères de réussite

Avec Lootopia, un organisateur sans compétence technique crée et publie une chasse jouable. Un joueur la découvre, la rejoint et la termine sans perdre sa progression. L'organisateur voit qui joue et où en est chacun.

Nous jugerons le prototype sur six critères vérifiables :

| Axe | Critère | Preuve |
| --- | --- | --- |
| Fonctionnel | Les 6 étapes du scénario de référence s'exécutent de bout en bout, sans toucher à la base de données | Démonstration enregistrée, test de bout en bout |
| Qualité | Authentification, contrôle des rôles, validation d'une étape et attribution du résultat sont couverts par des tests automatisés, tous verts en intégration continue | Rapport de tests, couverture d'au moins 70 % sur ces modules |
| Sécurité | Un joueur ne peut ni créer ni modifier une chasse. La réponse attendue d'une étape n'est jamais envoyée au navigateur. Mots de passe hachés, entrées validées, aucun secret dans le dépôt | Tests d'autorisation, revue du dépôt |
| Reproductibilité | Une personne extérieure installe et lance le prototype depuis zéro en moins de 15 minutes, avec le seul README | Essai chronométré avec un tiers |
| Maintenabilité | Architecture, API et choix techniques documentés. Un tiers retrouve où modifier une règle de progression | Relecture par un tiers |
| UX et accessibilité | Parcours complet utilisable sur mobile et sur ordinateur, score d'accessibilité Lighthouse d'au moins 90 sur les écrans du scénario | Audit Lighthouse, tests manuels |

## 3. Utilisateurs et besoins

Deux rôles structurent le prototype : le Joueur et l'Organisateur.

Les Partenaires (acteurs professionnels ou institutionnels) ne sont pas retenus. Ils ajouteraient un troisième rôle, avec ses écrans, ses droits et ses règles, sans être nécessaires à la boucle que nous voulons démontrer : créer, jouer, suivre. Le modèle de données et la gestion des droits resteront extensibles pour qu'un rôle Partenaire puisse être ajouté ensuite.

| | Joueur | Organisateur |
| --- | --- | --- |
| Profil | Personne ou petit groupe qui cherche une activité ludique | Personne qui veut animer une expérience, sans compétence technique |
| Motivation | Défi, découverte, reconnaissance de la réussite | Proposer une animation, mesurer l'engagement |
| Objectif | Trouver une chasse, la rejoindre vite, savoir où il en est, aller au bout | Créer et publier une chasse rapidement, voir qui joue |
| Freins | Inscription longue, consignes floues, progression perdue, étape bloquante sans aide | Création trop complexe, aucune visibilité sur ce que voit le joueur, pas de suivi |
| Contexte | Surtout sur mobile | Surtout sur ordinateur pour l'administration, mobile possible |

**Accessibilité.** Nous visons le niveau AA des WCAG 2.1 (base du RGAA) sur les écrans du scénario de démonstration : navigation au clavier, contrastes suffisants, champs étiquetés, messages d'erreur explicites, cibles tactiles adaptées, information jamais portée par la seule couleur.

**Validation des hypothèses.** Ces profils sont des hypothèses tirées de l'analyse de la demande client. Nous les confronterons au terrain avant la fin du jalon 2 : benchmark de trois offres existantes de chasses au trésor ou de balades ludiques, et cinq entretiens courts (deux organisateurs potentiels, trois joueurs). Les résultats alimenteront le backlog.

## 4. Périmètre

### 4.1 Priorisation

Nous avons classé les fonctions selon la méthode MoSCoW, en pesant cinq critères : valeur pour l'utilisateur, contribution à la démonstration, faisabilité, risque et coût.

| Fonction | Priorité | Pourquoi |
| --- | --- | --- |
| Inscription, connexion, rôles Joueur et Organisateur | Must | Sans compte = aucun parcours |
| Liste des chasses publiées | Must | Étape 2 du scénario |
| Création d'une chasse (titre, description, étapes ordonnées) et publication | Must | Étape 3 : sans elle, rien à jouer |
| Inscription d'un joueur à une chasse | Must | Étape 4 |
| Progression par étapes et énigmes, validation côté serveur | Must | C'est la mécanique de jeu |
| Progression conservée entre les sessions | Must | Étape 5 |
| Résultat final : badge de complétion et temps | Must | Étape 5 |
| Vue de suivi pour l'Organisateur | Must | Étape 6 |
| Journalisation des actions sensibles | Must | Transverse : exigée pour la sécurité et le diagnostic |
| Gestion du profil | Should | Utile, mais hors boucle principale |
| Modification et dépublication d'une chasse | Should | Confort de gestion |
| Indices optionnels par étape | Should | Réduit le risque d'étape bloquante |
| Badges supplémentaires | Could | Enrichissement de la gamification |
| Carte simple des étapes | Could | Belle valeur visuelle, mais dépend d'un service de cartes |
| Notifications | Won't | Inutile à la démonstration |

**Règle de coupe :** Les Must sont protégés. En cas de problème, les Could sautent en premier, puis les Should non critiques.

### 4.2 Renoncements

| Écarté | Raison | Réexamen si |
| --- | --- | --- |
| Réalité augmentée | Coût et risque élevés, valeur non nécessaire à la boucle créer, jouer, suivre | Un cas d'usage clair apparaît |
| Géolocalisation en temps réel | Précision et permissions difficiles, données personnelles sensibles au regard du RGPD | La validation d'étapes sur le terrain devient prioritaire |
| Couronnes, artefacts, marketplace | Hors scénario, règles métier et sécurité lourdes | Le concept est validé et le modèle économique défini |
| Fonctions Partenaires | Voir section 3 | Un besoin partenaire est identifié |
| Application mobile native | Le web responsive couvre l'usage mobile. Une PWA reste possible sans passer par les boutiques | Des fonctions natives deviennent nécessaires |
| Classements | N'ont de sens qu'avec un volume de joueurs réel | Après un déploiement |
| Notifications | Inutiles à la démonstration | Un besoin de réengagement est identifié |
| Administration complète | La vue de suivi Organisateur suffit au scénario | Un besoin de modération apparaît |

## 5. Parcours de référence

### 5.1 Scénario retenu

Nous retenons tel quel le scénario de référence du client :

1. Un utilisateur crée son compte, choisit son rôle et se connecte.
2. Il consulte la liste des chasses publiées.
3. Un Organisateur crée une chasse, y ajoute des étapes ordonnées (chacune avec un indice ou une énigme et sa réponse attendue) puis la publie.
4. Un Joueur rejoint la chasse et valide les étapes une à une jusqu'à la dernière, qui est la cache finale.
5. Le système enregistre la progression à chaque validation et attribue un résultat à la fin : un badge de complétion et un récapitulatif (temps total, étapes franchies).
6. L'Organisateur consulte la liste des participants et l'étape atteinte par chacun.

### 5.2 Règles métier

- Seul un Organisateur crée, modifie et publie une chasse, et il ne gère que les siennes.
- Seul un Joueur participe à une chasse, avec une seule participation active par chasse.
- Seules les chasses publiées sont visibles des joueurs.
- Les étapes se valident dans l'ordre : le joueur ne voit l'étape suivante qu'après avoir validé la courante.
- La validation se fait côté serveur. La réponse attendue n'est jamais transmise au navigateur.
- Valider la dernière étape clôt la participation et déclenche le résultat.

**Limite assumée :** Le rôle est choisi à l'inscription, sans validation des organisateurs. C'est une simplification acceptable pour un prototype, que nous documenterons comme telle.

### 5.3 Scénario de démonstration

| # | Acteur | Action |
| --- | --- | --- |
| 1 | Organisateur (compte de test) | Se connecte, crée une chasse de 3 étapes, la publie |
| 2 | Joueur | Crée son compte, se connecte, consulte la liste, rejoint la chasse |
| 3 | Joueur | Saisit une mauvaise réponse (message d'erreur), puis les bonnes réponses aux 3 étapes |
| 4 | Joueur | Se déconnecte puis se reconnecte en cours de chasse : la progression est conservée |
| 5 | Joueur | Termine la chasse, reçoit son badge et son récapitulatif |
| 6 | Organisateur | Ouvre sa vue de suivi et voit le joueur au statut « terminé » |
| 7 | Joueur | Tente d'accéder à la création de chasse : accès refusé |

## 6. Contraintes

Le client impose que nos choix techniques soient justifiés par la sécurité, la performance, la maintenabilité, le coût, l'accessibilité et la sobriété. Le code et l'architecture doivent pouvoir être repris par une autre équipe, et la qualité comme la sécurité doivent être prouvées.

**Temps.** Le projet suit les cinq jalons de l'année (section 9). Notre capacité tient compte des périodes de cours et d'entreprise et sera recalculée à chaque itération. En cas de dérive, la règle de coupe de la section 4.1 s'applique.

**Budget.** Aucun budget n'est alloué. Nous retenons des solutions locales, libres ou avec un niveau gratuit suffisant. Tout service payant ou limité par quota sera documenté (coût, limites, solution de remplacement) avant d'être intégré.

**Technique.** Aucune technologie n'est imposée. Nous choisirons la stack au jalon 2 selon cinq critères : maîtrise par l'équipe, sécurité, maintenabilité, sobriété, coût. La cible est un service web responsive, installable de façon reproductible, avec une architecture Front / Back / données documentée. L'environnement de démonstration (local ou hébergé, appareils utilisés) sera lui aussi sélectionné au jalon 2.

## 7. Équipe, ressources et organisation

Le client, Out of Cache, formule une demande à chaque jalon et décide de la suite du projet. Les encadrants suivent l'avancement lors des revues de jalon.

### 7.1 Responsabilités

Chaque domaine a un référent et un suppléant, ce qui permet de cumuler les rôles tout en gardant la continuité. Chaque étudiant doit pouvoir expliquer sa contribution : tickets, commits, revues et documents restent nominatifs.

| Domaine | Référent | Suppléant |
| --- | --- | --- |
| Pilotage, produit et backlog | Elias | Mathéo |
| UX et Front | Alexis.C | Arthur |
| Back et API | Alexis.B | Alexis.C |
| Données et sécurité | Arthur | Alexis.B |
| Qualité, CI/CD et documentation | Mathéo | Elias |

Le référent d'un domaine approuve les livrables de ce domaine. Les décisions qui touchent le périmètre se prennent en équipe.

### 7.2 Fonctionnement

- Un point d'équipe par semaine au minimum, une revue et une rétrospective à la fin de chaque itération de deux semaines.
- Un backlog unique, où chaque élément a un responsable et un état.
- Un journal des décisions : pour chaque choix technique important, les options considérées, le choix retenu et ses conséquences.
- Tout changement de périmètre est daté, motivé et relié à son impact sur le planning, la qualité ou les risques.

### 7.3 Outils

Dépôt Github avec historique, backlog, documentation partagée (wiki), intégration continue (github workflows). Services externes éventuels (cartes, hébergement) : voir section 6.

## 8. Livrables

- Un backlog priorisé, tenu à jour pendant tout le projet.
- La conception : parcours, maquettes, modèle de données, architecture, choix techniques.
- Le code source et les instructions pour l'exécuter.
- Les tests et les preuves de qualité.
- La documentation technique.
- Une démonstration fonctionnelle du prototype.
- Les preuves individuelles de contribution.

## 9. Rétroplanning

Le séquencement des cinq jalons est fixé. Nous construirons le planning détaillé à rebours depuis la démonstration finale.

| Jalon | Sortie attendue | Demande client | Prérequis | Date |
| --- | --- | --- | --- | --- |
| 1. Cadrage | Périmètre, proposition de valeur, utilisateurs, scénario de démonstration, risques | 1 | Aucun | 28/09/2026 - 30/10/2026 |
| 2. Conception | Parcours, écrans essentiels, règles métier, backlog, architecture, modèle de données, sécurité, stratégie de tests | 2 | Jalon 1 validé | 01/11/2026 - 15/12/2026 |
| 3. Construction | Version exécutable du cœur du scénario | 3 | Architecture et backlog stabilisés | 16/12/2026 - 31/03/2027 |
| 4. Consolidation | Version corrigée, sécurisée, testée, éventuellement enrichie | 4 | Cœur démontrable | 01/04/2027 - 15/05/2027 |
| 5. Démonstration | Version installable, résultats, limites, suites | 5 | Critères de réussite vérifiés | 16/05/2027 - 30/06/2027 |

Trois règles de pilotage :

- Aucun Could ne démarre tant qu'un Must critique n'est pas finalisé.
- Aucune nouvelle fonctionnalité après le début du jalon 5 : le temps restant va aux tests, à la documentation et à la reproductibilité.
- Chaque jalon a des critères d'entrée et de sortie vérifiables.

## 10. Risques

Évaluation de cadrage, revue à chaque jalon.

| # | Risque | Prob. | Impact | Prévention | Plan B |
| --- | --- | --- | --- | --- | --- |
| R1 | Périmètre trop large pour le temps disponible | Élevée | Élevé | MoSCoW, Must protégés, premier sprint consacré au scénario complet en version minimale | Retirer les Could puis les Should. Garder le scénario de référence |
| R2 | Un enrichissement fragilise le cœur | Moyenne | Élevé | Aucun Could avant que les Must soient testés, une branche par enrichissement | Retour à la dernière version stable, enrichissement désactivé |
| R3 | Droits d'accès mal maîtrisés (un joueur agit en organisateur, accède aux chasses d'un autre) | Moyenne | Élevé | Contrôles côté serveur, tests d'autorisation par rôle et par propriétaire | Réduire aux droits minimaux jusqu'à correction |
| R4 | Progression perdue ou incohérente | Moyenne | Élevé | Enregistrement à chaque validation, contraintes d'intégrité, test de reprise de session | Simplifier la mécanique : une participation, étapes linéaires |
| R5 | Disponibilité inégale et compétences variables (sécurité, CI/CD) | Élevée | Moyen | Référent et suppléant par domaine, capacité recalculée à chaque itération, temps de montée en compétence planifié | Redistribuer les tâches |
| R6 | Preuves de qualité et de contribution insuffisantes | Moyenne | Élevé | Intégration continue dès la première itération, tickets et PR nominatifs, journal des décisions | Consacrer du temps aux tests et à la documentation. Récapitulatif individuel tiré de l'historique |
| R7 | Démonstration non reproductible | Moyenne | Élevé | Environnement reproductible, jeu de données de démonstration, essai par un tiers avant la démo | Démonstration sur machine locale, vidéo de secours |
| R8 | Dépendance à un service externe payant ou limité (cartes, hébergement) | Moyenne | Moyen | Vérifier coûts et quotas avant intégration, solution locale par défaut | Solution libre, ou retrait de la fonction |