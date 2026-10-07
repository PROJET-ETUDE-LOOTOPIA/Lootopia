# Cahier des charges - Lootopia (MVP)

## Version et validation du document

| | |
| --- | --- |
| **Document** | Cahier des charges, Lootopia (MVP) |
| **Version** | 0.2 |
| **Date** | 07/10/2026 |
| **Statut** | Brouillon, en attente de validation par l'équipe |
| **Rédacteurs** | Mathéo Souchet, Elias Forget, Alexis Ballenghien, Alexis Cantin, Arthur Millet |
| **Document de référence** | Note de cadrage v1.0 du 28/09/2026 |

### Historique des versions

| Version | Date | Auteur | Modifications |
| --- | --- | --- | --- |
| 0.1 | 05/10/2026 | Équipe | Création du cahier des charges à partir de la note de cadrage v1.0 |
| 0.2 | 07/10/2026 | Équipe | Rôle par chasse à la place du rôle choisi à l'inscription, suppression de compte en cascade ajoutée au périmètre, décisions techniques retirées (renvoyées au jalon 2), table des matières et contraintes ajoutées |

**Table des matières**

- [1. Contexte, objectifs et périmètre du MVP](#1-contexte-objectifs-et-périmètre-du-mvp)
  - [1.1 Objectifs](#11-objectifs)
  - [1.2 Périmètre MoSCoW](#12-périmètre-moscow)
  - [1.3 Renoncements (hors périmètre)](#13-renoncements-hors-périmètre)
- [2. Acteurs, rôles et permissions](#2-acteurs-rôles-et-permissions)
  - [2.1 Matrice des permissions](#21-matrice-des-permissions)
  - [2.2 Écart avec le cadrage et limites assumées](#22-écart-avec-le-cadrage-et-limites-assumées)
- [3. Parcours de référence, règles métier et démonstration](#3-parcours-de-référence-règles-métier-et-démonstration)
  - [3.1 Scénario de référence](#31-scénario-de-référence)
  - [3.2 Règles métier](#32-règles-métier)
  - [3.3 Scénario de démonstration](#33-scénario-de-démonstration)
- [4. Spécifications fonctionnelles](#4-spécifications-fonctionnelles)
  - [M1 : Comptes, authentification et rôles](#m1---comptes-authentification-et-rôles)
  - [M2 : Liste des chasses publiées](#m2---liste-des-chasses-publiées)
  - [M3 : Création et publication d'une chasse](#m3---création-et-publication-dune-chasse-organisateur)
  - [M4 : Participation, progression et validation](#m4---participation-progression-et-validation)
  - [M5 : Résultat final](#m5---résultat-final)
  - [M6 : Vue de suivi Organisateur](#m6---vue-de-suivi-organisateur)
  - [Transverse : Journalisation des actions sensibles](#transverse---journalisation-des-actions-sensibles)
- [5. Exigences non fonctionnelles](#5-exigences-non-fonctionnelles)
  - [5.1 Sécurité](#51-sécurité)
  - [5.2 Accessibilité et UX](#52-accessibilité-et-ux)
  - [5.3 Performance et sobriété](#53-performance-et-sobriété)
  - [5.4 Données personnelles (RGPD)](#54-données-personnelles-rgpd)
  - [5.5 Maintenabilité et reproductibilité](#55-maintenabilité-et-reproductibilité)
- [6. Critères de réussite](#6-critères-de-réussite)
- [7. Planification](#7-planification)
  - [7.1 Jalons](#71-jalons)
  - [7.2 Règles de pilotage](#72-règles-de-pilotage)
  - [7.3 Backlog initial](#73-backlog-initial)
  - [7.4 Responsabilités](#74-responsabilités)
  - [7.5 Definition of Done](#75-definition-of-done)
- [8. Risques, contraintes et questions](#8-risques-contraintes-et-questions)
  - [8.1 Risques](#81-risques)
  - [8.2 Contraintes](#82-contraintes)
  - [8.3 Questions ouvertes](#83-questions-ouvertes)

## 1. Contexte, objectifs et périmètre du MVP

Le MVP de Lootopia est un prototype web responsive qui prouve la boucle **créer, jouer, suivre** . Un Organisateur publie une chasse au trésor, un Joueur la termine sans perdre sa progression, l'Organisateur voit où en est chacun. Le commanditaire (Out of Cache) décidera en fin de projet de poursuivre ou non Lootopia. Il n'attend ni plateforme complète ni mise en production.

Ce cahier des charges décrit **ce que le MVP doit faire**. Les choix techniques (stack, architecture, modèle de données, API, tests, intégration continue) relèvent du jalon 2 et n'y figurent pas.

### 1.1 Objectifs

- Livrer les 6 étapes du scénario de référence de bout en bout, sans intervention en base de données.
- Fournir des preuves de qualité, sécurité, maintenabilité et reproductibilité exploitables par une autre équipe.
- Rester dans la capacité de 5 personnes sur 5 jalons (28/09/2026 au 30/06/2027).

### 1.2 Périmètre MoSCoW

| Fonction | Priorité | Lot MVP |
| --- | --- | --- |
| Inscription, connexion ; rôles Organisateur et Joueur attribués par chasse | Must | M1 |
| Suppression de compte en cascade (chasses créées et participations) | Must | M1 |
| Liste des chasses publiées | Must | M2 |
| Création d'une chasse (titre, description, étapes ordonnées) et publication | Must | M3 |
| Inscription d'un joueur à une chasse | Must | M4 |
| Progression par étapes et énigmes, validation côté serveur | Must | M4 |
| Progression conservée entre les sessions | Must | M4 |
| Résultat final : badge de complétion, temps total, étapes franchies | Must | M5 |
| Vue de suivi Organisateur | Must | M6 |
| Journalisation des actions sensibles | Must | Transverse |
| Gestion du profil | Should | Après MVP |
| Modification et dépublication d'une chasse | Should | Après MVP |
| Indices optionnels par étape | Should | Après MVP |
| Badges supplémentaires | Could | Après MVP |
| Carte simple des étapes | Could | Après MVP |

Règle de coupe : en cas de dérive, les Could sautent en premier, puis les Should non critiques. Aucun Could ne démarre tant qu'un Must critique n'est pas finalisé.

### 1.3 Renoncements (hors périmètre)

| Écarté | Raison | Réexamen si |
| --- | --- | --- |
| Réalité augmentée | Coût et risque élevés, non nécessaire à la boucle | Un cas d'usage clair apparaît |
| Géolocalisation temps réel | Permissions difficiles, données sensibles (RGPD) | La validation sur le terrain devient prioritaire |
| Couronnes, artefacts, marketplace | Hors scénario, règles lourdes | Concept validé et modèle économique défini |
| Rôle Partenaire | Troisième rôle sans utilité pour la boucle | Un besoin partenaire est identifié |
| Application mobile native | Le web responsive suffit (PWA possible) | Fonctions natives nécessaires |
| Classements | Pas de sens sans volume de joueurs&#32; | Après un déploiement réel |
| Notifications | Inutiles à la démonstration | Besoin de réengagement |
| Administration complète | La vue de suivi suffit | Besoin de modération |

Le modèle de données et la gestion des droits restent extensibles pour ajouter ensuite un rôle Partenaire.

## 2. Acteurs, rôles et permissions

Tout utilisateur inscrit dispose du même compte. Le rôle est contextuel et attribué par chasse.  Celui qui crée une chasse en est l'**Organisateur**, et celui qui la rejoint en est **Joueur**. Un même utilisateur peut donc organiser certaines chasses et en jouer d'autres. Un visiteur non connecté ne peut que s'inscrire ou se connecter.

|  | Joueur | Organisateur |
| --- | --- | --- |
| Profil | Personne ou petit groupe cherchant une activité ludique | Personne souhaitant animer une expérience, sans compétence technique |
| Objectif | Trouver une chasse, la rejoindre vite, savoir où il en est, aller au bout | Créer et publier vite, voir qui joue et où |
| Freins à lever | Inscription longue, consignes floues, progression perdue, étape bloquante | Création complexe, aucune visibilité, pas de suivi |
| Contexte d'usage | Surtout mobile | Surtout ordinateur, mobile possible |

### 2.1 Matrice des permissions

| Action | Visiteur | Utilisateur connecté | Organisateur de la chasse | Joueur de la chasse | Condition d'accès |
| --- | --- | --- | --- | --- | --- |
| S'inscrire, se connecter | Oui | – | – | – | Public |
| Lister les chasses publiées | Non | Oui | Oui | Oui | Authentifié |
| Créer une chasse | Non | Oui (il en devient l'Organisateur) | – | – | Authentifié |
| Voir une chasse en brouillon | Non | Non | Oui | Non | Propriétaire de la chasse |
| Modifier les étapes, publier | Non | Non | Oui | Non | Propriétaire de la chasse |
| Rejoindre une chasse publiée | Non | Oui, sauf sa propre chasse | Non (sa propre chasse) | Déjà inscrit : refus (409) | Statut de la chasse + non-propriétaire |
| Valider une étape | Non | Non | Non | Oui (sa participation) | Propriétaire de la participation |
| Voir sa progression et son résultat | Non | Non | Non | Oui | Propriétaire de la participation |
| Voir la liste des participants | Non | Non | Oui | Non | Propriétaire de la chasse |

Chaque ligne donne lieu à au moins un test d'autorisation : 401 sans session, 403 si l'utilisateur n'est ni Organisateur ni Joueur de la ressource, 404 ou 403 si la ressource appartient à un autre utilisateur.

### 2.2 Écart avec le cadrage et limites assumées

Le cadrage prévoyait un rôle choisi à l'inscription. L'équipe retient à la place **un rôle par chasse**, car il permet à chacun de créer et de rejoindre des chasses sans multiplier les comptes.  Cette décision sera consignée dans le journal des décisions.

- **Règle associée** : on ne peut pas rejoindre sa propre chasse (l'Organisateur ne joue pas la sienne).
- **Limite assumée** : n'importe quel utilisateur peut publier une chasse, sans validation ni modération (aucun signalement ni administrateur dans le MVP). À documenter comme telle.
- **Extensibilité** : un futur rôle Partenaire ou Admin s'ajoutera comme un droit supplémentaire (type de compte ou permission sur une chasse).

## 3. Parcours de référence, règles métier et démonstration

Le scénario de référence du client est retenu. Six étapes doivent s'exécuter de bout en bout, sans toucher à la base de données.

### 3.1 Scénario de référence

1. Un utilisateur crée son compte et se connecte.
2. Il consulte la liste des chasses publiées.
3. Un utilisateur crée une chasse, dont il devient l'Organisateur, y ajoute des étapes ordonnées (indice ou énigme + réponse attendue) puis la publie.
4. Un autre utilisateur rejoint la chasse, dont il devient le Joueur, et valide les étapes une à une.
5. Le système enregistre la progression à chaque validation et, à la fin, attribue un badge de complétion et un récapitulatif (temps total, étapes franchies).
6. L'Organisateur de la chasse consulte la liste des participants et l'étape atteinte par chacun.

### 3.2 Règles métier

| Réf. | Règle |
| --- | --- |
| RM1 | Tout utilisateur connecté peut créer une chasse et en devient l'Organisateur. Seul l'Organisateur d'une chasse la modifie, la publie et consulte ses participants. Un organisateur ne gère que ses propres chasses. |
| RM2 | Tout utilisateur connecté, sauf l'Organisateur de la chasse, peut rejoindre une chasse publiée et en devient le Joueur. Une seule participation active par chasse. |
| RM3 | Seules les chasses publiées sont visibles des autres utilisateurs Un brouillon n'est visible que de son Organisateur. |
| RM4 | Une chasse ne peut être publiée que si elle compte au moins 1 étape (3 pour la démo) et un titre non vide. |
| RM5 | Les étapes se valident dans l'ordre : l'étape suivante n'est visible qu'après validation de la courante. |
| RM6 | La validation se fait côté serveur. La réponse attendue n'est jamais transmise au navigateur. |
| RM7 | Valider la dernière étape clôt la participation (statut « terminé »), fige le temps total et déclenche l'attribution du badge. |
| RM8 | Une chasse publiée ne peut plus voir ses étapes modifiées (évite d'invalider des progressions en cours, modification complète = Should hors MVP). |
| RM9 | La comparaison des réponses est insensible à la casse, aux accents et aux espaces en début ou fin de saisie. |
| RM10 | Un même utilisateur peut être Organisateur de certaines chasses et Joueur d'autres. Il n'existe pas de rôle global. |
| RM11 | La suppression d'un compte est définitive et en cascade : elle supprime les chasses dont l'utilisateur est l'Organisateur (avec leurs étapes et toutes les participations des autres joueurs), ainsi que ses propres participations en tant que Joueur. Les chasses créées par d'autres ne sont pas modifiées. |

### 3.3 Scénario de démonstration

| # | Acteur | Action | Résultat attendu |
| --- | --- | --- | --- |
| 1 | Compte A (compte de test), Organisateur | Se connecte, crée une chasse de 3 étapes, la publie | Chasse visible dans la liste |
| 2 | Compte B (nouveau compte), Joueur | Crée son compte, se connecte, consulte la liste, rejoint la chasse | Participation créée à l'étape 1 |
| 3 | Compte B | Saisit une mauvaise réponse, puis les bonnes aux 3 étapes | Message d'erreur explicite, puis avancement |
| 4 | Compte B | Se déconnecte puis se reconnecte en cours de chasse | Progression conservée |
| 5 | Compte B | Termine la chasse | Badge et récapitulatif affichés |
| 6 | Compte A | Ouvre sa vue de suivi | Compte B au statut « terminé » |
| 7 | Compte B | Tente de modifier ou de publier la chasse du compte A | Accès refusé (403) |
| 8 | Compte A | Tente de rejoindre sa propre chasse | Accès refusé (403) |
| 9 | Compte A | Supprime son compte | Sa chasse et la participation du compte B disparaissent. A ne peut plus se connecter |

Ce scénario sert de test de bout en bout automatisé et de démonstration enregistrée (vidéo). Un jeu de données de démonstration (compte Organisateur de test, chasse d'exemple) sera fourni avec le prototype.

## 4. Spécifications fonctionnelles

Chaque module correspond à une étape du scénario et à un lot Must. Les critères d'acceptation servent directement de base aux tests automatisés.

### M1 - Comptes, authentification et rôles

| ID | User story | Critères d'acceptation |
| --- | --- | --- |
| US-1.1 | En tant que visiteur, je crée un compte | Champs : pseudo, e-mail, mot de passe (aucun rôle à choisir). E-mail unique. Mot de passe de 8 caractères minimum avec chiffre et caractère spécial, jamais stocké ni affiché en clair. Possibilité de se connecter via Google. Erreurs explicites par champ. |
| US-1.2 | En tant qu'utilisateur, je me connecte et me déconnecte | Identifiants invalides : message générique, sans révéler si l'e-mail existe. Session sécurisée, qui expire. Limitation des tentatives de connexion. Déconnexion invalide la session. |
| US-1.3 | En tant qu'utilisateur connecté, j'accède à mes deux espaces : « Jouer » et « Mes chasses » | Accueil sur la liste des chasses, accès à « Mes chasses » (celles que j'organise) et « Mes participations » (celles que je joue). Une route protégée renvoie 401 sans session, et 403 si je ne suis ni l'Organisateur ni le Joueur concerné. |
| US-1.4 | En tant qu'utilisateur connecté, je supprime mon compte | Confirmation explicite, avec un avertissement clair sur ce qui sera perdu. Suppression en cascade : les chasses que j'ai créées sont supprimées avec leurs étapes et toutes les participations des autres joueurs à ces chasses. Mes participations aux chasses des autres sont supprimées avec ma progression, mes résultats et mes badges. Les chasses des autres ne sont pas modifiées. Ma session est fermée et je ne peux plus me connecter avec ces identifiants. L'opération est tout ou rien : jamais de suppression partielle. |

### M2 - Liste des chasses publiées

| ID | User story | Critères d'acceptation |
| --- | --- | --- |
| US-2.1 | En tant qu'utilisateur connecté, je consulte les chasses publiées | Affiche titre, description courte, nombre d'étapes, organisateur. Aucune chasse brouillon. Liste paginée (20 par page). État vide explicite. |
| US-2.2 | En tant qu'utilisateur connecté, j'ouvre le détail d'une chasse | Affiche description et nombre d'étapes, jamais le contenu des étapes ni les réponses. Bouton « Rejoindre » ou « Reprendre » selon l'état de ma participation, et aucun bouton si j'en suis l'Organisateur. |

### M3 - Création et publication d'une chasse (Organisateur)

| ID | User story | Critères d'acceptation |
| --- | --- | --- |
| US-3.1 | En tant qu'utilisateur connecté, je crée une chasse en brouillon | Titre (3 à 100 caractères) et description (jusqu'à 1 000 caractères) validés côté serveur. La chasse m'appartient : j'en deviens l'Organisateur. |
| US-3.2 | J'ajoute des étapes ordonnées | Chaque étape : titre, consigne (indice ou énigme), réponse attendue (relisible par l'Organisateur tant que la chasse est en brouillon, jamais visible d'un joueur), position. Ordre modifiable par réordonnancement. Suppression d'une étape tant que la chasse est en brouillon. |
| US-3.3 | Je publie ma chasse | Refusée sans étape ou sans titre (RM4). Statut passe de brouillon à publiée et la chasse apparaît dans la liste. Action journalisée. |
| US-3.4 | Je vois la liste de mes chasses | Seules les miennes, avec statut et nombre de participants. |

Parcours conçu pour que la création d'une chasse de 3 étapes prenne moins de 5 minutes pour un utilisateur novice (cible à vérifier lors de l'essai avec un tiers).

### M4 - Participation, progression et validation

| ID | User story | Critères d'acceptation |
| --- | --- | --- |
| US-4.1 | En tant qu'utilisateur connecté, je rejoins une chasse publiée dont je ne suis pas l'Organisateur | Création d'une participation (statut « en cours », étape 1, horodatage de début). Une seule participation active par chasse : un second essai renvoie la participation existante ou 409. Rejoindre sa propre chasse renvoie 403. Je deviens le Joueur de cette chasse. |
| US-4.2 | Je vois l'étape courante | Seule l'étape courante est renvoyée. Accès à une étape future refusé (403). |
| US-4.3 | Je valide une étape en saisissant ma réponse | Comparaison côté serveur selon RM9. Bonne réponse : progression enregistrée immédiatement et étape suivante renvoyée. Mauvaise réponse : message d'erreur clair, aucun changement d'état, nombre d'essais enregistré. |
| US-4.4 | Je reprends ma chasse après déconnexion | À la reconnexion, je retrouve l'étape courante exacte. L'état est conservé côté serveur, jamais déduit du navigateur. |
| US-4.5 | Je suis bloqué sur une étape | La consigne reste affichée et lisible ; les erreurs ne verrouillent pas le joueur. (Les indices sont un Should hors MVP.) |

### M5 - Résultat final

| ID | User story | Critères d'acceptation |
| --- | --- | --- |
| US-5.1 | En tant que Joueur, je termine la chasse et reçois mon résultat | La validation de la dernière étape passe la participation à « terminée », fige la date de fin et le temps total, attribue le badge de complétion. |
| US-5.2 | Je consulte mon récapitulatif | Affiche temps total, étapes franchies, nombre d'essais, badge. Consultable à nouveau plus tard. Une participation terminée ne peut plus être modifiée. |

### M6 - Vue de suivi Organisateur

| ID | User story | Critères d'acceptation |
| --- | --- | --- |
| US-6.1 | En tant qu'Organisateur, je vois les participants de ma chasse | Liste : pseudo, étape atteinte (X sur N), statut (en cours ou terminé), date de début, temps total si terminé. Uniquement pour mes chasses 403 sinon. |
| US-6.2 | Je filtre par statut | Filtre « en cours » et « terminé » ; compteurs agrégés (nombre de participants, nombre de terminés). |

### Transverse - Journalisation des actions sensibles

| ID | Exigence | Critères d'acceptation |
| --- | --- | --- |
| TR-1 | Journaliser les actions sensibles | Sont journalisés : inscription, connexion réussie ou échouée, publication de chasse, inscription à une chasse, validation d'étape (succès ou échec), refus d'autorisation. Chaque entrée : horodatage, acteur, action, ressource, résultat. Jamais de mot de passe ni de réponse attendue dans les logs. |
| TR-2 | Gestion des erreurs | Messages d'erreur clairs, aucune information technique exposée à l'utilisateur. |

## 5. Exigences non fonctionnelles

Ces exigences décrivent le niveau attendu, pas la façon de l'obtenir : les moyens techniques seront choisis au jalon 2.

### 5.1 Sécurité

- Les mots de passe ne sont jamais stockés ni affichés en clair.
- Les droits sont contrôlés côté serveur à chaque action (masquer un bouton ne suffit pas)
- La réponse attendue d'une étape n'est jamais transmise au navigateur.
- Toutes les saisies sont validées côté serveur.
- Aucun secret (mot de passe, clé) ne figure dans le dépôt de code.
- Les actions sensibles sont journalisées (TR-1), sans mot de passe ni réponse attendue dans les journaux.
- Les messages d'erreur ne révèlent ni information technique ni l'existence d'un compte.

### 5.2 Accessibilité et UX

- Niveau **WCAG 2.1 AA** sur les écrans du scénario : navigation au clavier, contrastes suffisants, champs étiquetés, messages d'erreur explicites, cibles tactiles adaptées, information jamais portée par la seule couleur.
- Score **Lighthouse accessibilité d'au moins 90** sur chaque écran du scénario, complété par des tests manuels.
- Parcours complet utilisable sur mobile et sur ordinateur.
- Retour visible à chaque action (chargement, succès, erreur) et aucune perte de saisie sur erreur de validation.

### 5.3 Performance et sobriété

- Parcours fluide sur mobile comme sur ordinateur : pages légères, listes paginées.
- Pas de service externe payant ou limité dans le MVP. Tout service ajouté est justifié au préalable (coût, limites, solution de remplacement).

### 5.4 Données personnelles (RGPD)

- Données collectées limitées au strict nécessaire : e-mail, pseudo, mot de passe, historique de participation.
- Aucune géolocalisation.
- Information claire à l'inscription, finalités et durées de conservation documentées.
- Suppression de compte à tout moment (US-1.4) : les données personnelles de l'utilisateur et les contenus qui lui sont rattachés sont supprimés en cascade.
- Comptes et chasses fictifs en démonstration.

### 5.5 Maintenabilité et reproductibilité

- Un tiers installe et lance le prototype depuis zéro en moins de 15 minutes avec le seul README.
- Architecture, API et choix techniques documentés, un tiers retrouve où modifier une règle de progression.
- Les choix techniques importants sont consignés dans le journal des décisions.
- Un jeu de données de démonstration est fourni.

## 6. Critères de réussite

La qualité et la sécurité doivent être prouvées avec une preuve pour chaque critère.

| Axe | Critère | Preuve |
| --- | --- | --- |
| Fonctionnel | Les 6 étapes du scénario s'exécutent de bout en bout, sans toucher à la base de données | Démonstration enregistrée, test de bout en bout |
| Qualité | Authentification, contrôle des droits, validation d'une étape et attribution du résultat couverts par des tests automatisés, tous verts en intégration continue | Rapport de tests, couverture d'au moins 70 % sur ces modules |
| Sécurité | Un utilisateur ne peut ni modifier ni publier une chasse dont il n'est pas l'Organisateur, ni rejoindre la sienne. La réponse attendue n'est jamais envoyée au navigateur. Mots de passe protégés, entrées validées, aucun secret dans le dépôt | Tests d'autorisation, revue du dépôt |
| Reproductibilité | Une personne extérieure installe et lance le prototype depuis zéro en moins de 15 minutes, avec le seul README | Essai chronométré avec un tiers |
| Maintenabilité | Architecture, API et choix techniques documentés, un tiers retrouve où modifier une règle de progression | Relecture par un tiers |
| UX et accessibilité | Parcours complet utilisable sur mobile et ordinateur, score Lighthouse d'accessibilité d'au moins 90 sur les écrans du scénario | Audit Lighthouse, tests manuels |

## 7. Planification

Le séquencement des cinq jalons est fixé par le client. Le MVP correspond au cœur du scénario exécutable (tous les Must) à l'issue du jalon 3, puis consolidé au jalon 4.

### 7.1 Jalons

| Jalon | Période | Sortie attendue | Prérequis |
| --- | --- | --- | --- |
| 1. Cadrage | 28/09/2026 au 30/10/2026 | Périmètre, proposition de valeur, utilisateurs, scénario de démonstration, risques | Aucun |
| 2. Conception | 01/11/2026 au 15/12/2026 | Parcours, écrans essentiels, règles métier, backlog, architecture, modèle de données, sécurité, stratégie de tests | Jalon 1 validé |
| 3. Construction | 16/12/2026 au 31/03/2027 | Version exécutable du cœur du scénario | Architecture et backlog stabilisés |
| 4. Consolidation | 01/04/2027 au 15/05/2027 | Version corrigée, sécurisée, testée, éventuellement enrichie | Cœur démontrable |
| 5. Démonstration | 16/05/2027 au 30/06/2027 | Version installable, résultats, limites, suites | Critères de réussite vérifiés |

### 7.2 Règles de pilotage

- Aucun Could ne démarre tant qu'un Must critique n'est pas finalisé.
- Aucune nouvelle fonctionnalité après le début du jalon 5 : le temps restant va aux tests, à la documentation et à la reproductibilité.
- Chaque jalon a des critères d'entrée et de sortie vérifiables.

### 7.3 Backlog initial

Le backlog unique reprend les user stories de la section 4, avec pour chacune : responsable, priorité MoSCoW, état et lien vers sa revue. Le benchmark de trois offres existantes prévus avant la fin du jalon 2 alimentent et réordonnent ce backlog.

### 7.4 Responsabilités

| Domaine | Référent | Suppléant |
| --- | --- | --- |
| Pilotage, produit et backlog | Elias | Mathéo |
| UX et Front | Alexis C. | Arthur |
| Back et API | Alexis B. | Alexis C. |
| Données et sécurité | Arthur | Alexis B. |
| Qualité, CI/CD et documentation | Mathéo | Elias |

### 7.5 Definition of Done

Une user story est terminée lorsque :

- ses critères d'acceptation sont vérifiés par des tests automatisés qui passent
- elle est relue et approuvée par le référent du domaine, via une revue nominative
- les saisies sont validées et les contrôles d'accès côté serveur sont testés
- l'écran concerné est utilisable sur mobile et ordinateur, au clavier, sans erreur d'accessibilité bloquante
- l'action sensible est journalisée si elle figure dans TR-1
- la documentation est à jour
- l'installation depuis zéro fonctionne toujours avec le README.

## 8. Risques, contraintes et questions

### 8.1 Risques

| Réf. | Risque | Prob. | Impact | Réponse |
| --- | --- | --- | --- | --- |
| R1 | Périmètre trop large | Élevée | Élevé | MoSCoW, Must protégés, règle de coupe, premier sprint sur le scénario complet minimal |
| R2 | Un enrichissement fragilise l'existant | Moyenne | Élevé | Aucun Could avant que les Must soient testés, une branche par enrichissement |
| R3 | Droits d'accès mal maîtrisés | Moyenne | Élevé | Matrice 2.1 vérifiée par des tests d'autorisation, par rôle et par propriétaire |
| R4 | Progression perdue ou incohérente | Moyenne | Élevé | Enregistrement à chaque validation, test de reprise de session (US-4.4) |
| R5 | Disponibilité inégale, compétences variables | Élevée | Moyen | Référent et suppléant par domaine, capacité recalculée à chaque itération |
| R6 | Preuves de qualité et de contribution insuffisantes | Moyenne | Élevé | Intégration continue dès la première itération, tickets et revues nominatifs, journal des décisions |
| R7 | Démonstration non reproductible | Moyenne | Élevé | Jeu de données de démonstration, essai par un tiers, vidéo de démo/explicative |
| R8 | Dépendance à un service externe payant ou limité | Moyenne | Moyen | Aucun service externe dans le MVP |

### 8.2 Contraintes
- **Temps** : cinq jalons aux dates fixées par le client. La capacité tient compte des périodes de cours et d'entreprise et est recalculée à chaque itération. En cas de dérive, la règle de coupe s'applique.
- **Budget** : aucun budget alloué. Solutions locales, libres ou avec un niveau gratuit suffisant. Tout service payant ou limité par quota est documenté (coût, limites, solution de remplacement) avant d'être intégré.
- **Technique** : aucune technologie imposée, la stack est choisie au jalon 2. La cible est un service web responsive dont le code et l'architecture peuvent être repris par une autre équipe.
- **Réglementaire et qualité** : respect du RGPD (données minimales, aucune géolocalisation), accessibilité WCAG 2.1 AA sur les écrans du scénario, qualité et sécurité prouvées par des tests et des revues.
- **Équipe** : cinq personnes, un référent et un suppléant par domaine, contributions nominatives (tickets, commits, revues).

### 8.3 Questions à débattre

- **Tester sa propre chasse** : l'Organisateur peut-il parcourir sa chasse en mode essai avant de la publier, puisqu'il ne peut pas la rejoindre ?
- **Modération** : accepte-t-on que tout utilisateur publie sans validation (limite documentée), ou prévoit-on au minimum un signalement ?
- **Groupes de joueurs** : Prévoit-on des chasses par équipe
- **Mot de passe oublié et confirmation d'e-mail** : hors MVP, à confirmer.
- **Langue de l'interface** : français seul pour le MVP ?
- **Réponses tolérantes** : accepter plusieurs réponses valides par étape (variantes) dès le MVP, ou une seule ?

* **Joueurs d'une chasse supprimée** : faut-il les prévenir, ou accepte-t-on qu'ils perdent leur progression et leur badge quand l'Organisateur supprime son compte ?
* **Journal des actions sensibles après suppression** : les entrées d'un compte supprimé sont-elles anonymisées ou supprimées aussi (RGPD et traçabilité) ?

- **Chasses privées** : peut-on créer une chasse non listée publiquement, accessible seulement par lien ou code d'invitation ? À poser au client.
