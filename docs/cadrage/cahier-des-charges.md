# Cahier des charges - Lootopia (MVP)

## Version et validation du document

| | |
| --- | --- |
| **Document** | Cahier des charges, Lootopia (MVP) |
| **Version** | 0.3 |
| **Date** | 26/10/2026 |
| **Statut** | Brouillon, en attente de validation par l'équipe |
| **Rédacteurs** | Mathéo Souchet, Elias Forget, Alexis Ballenghien, Alexis Cantin, Arthur Millet |
| **Document de référence** | Note de cadrage v1.0 du 28/09/2026 |

### Historique des versions

| Version | Date | Auteur | Modifications |
| --- | --- | --- | --- |
| 0.1 | 05/10/2026 | Équipe | Création du cahier des charges à partir de la note de cadrage v1.0 |
| 0.2 | 07/10/2026 | Équipe | Rôle par chasse à la place du rôle choisi à l'inscription, suppression de compte en cascade ajoutée au périmètre, décisions techniques retirées (renvoyées au jalon 2), table des matières et contraintes ajoutées |
| 0.3 | 26/10/2026 | Équipe | Réponses aux questions ouvertes intégrées : mode essai pour l'Organisateur, confirmation d'e-mail et mot de passe oublié, modération (signalement, rôle Admin, bannissement), distinction suppression volontaire et bannissement, chasses privées et date de fermeture optionnelle, langue française seule, chasse par équipe confirmée hors périmètre. Voir le journal des décisions D-005 à D-012 |

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
  - [M7 : Signalement et modération (Admin)](#m7---signalement-et-modération-admin)
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
  - [8.3 Questions tranchées](#83-questions-tranchées)

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
| Inscription, connexion, rôles Organisateur et Joueur attribués par chasse | Must | M1 |
| Suppression de compte en cascade (chasses créées et participations) | Must | M1 |
| Création d'une chasse (titre, description, étapes ordonnées) et publication | Must | M2 |
| Liste des chasses publiées | Must | M3 |
| Inscription d'un joueur à une chasse | Must | M4 |
| Progression par étapes et énigmes, validation côté serveur | Must | M4 |
| Progression conservée entre les sessions | Must | M4 |
| Résultat final : badge de complétion, temps total, étapes franchies | Must | M5 |
| Vue de suivi Organisateur | Must | M6 |
| Journalisation des actions sensibles | Must | Transverse |
| Confirmation d'e-mail à l'inscription et réinitialisation du mot de passe oublié | Must | M1 |
| Mode essai d'une chasse par son Organisateur avant publication | Must | M3 |
| Signalement d'une chasse ou d'un organisateur, rôle Admin et traitement des signalements (bannissement) | Must | M7 |
| Gestion du profil | Should | Après MVP |
| Modification et dépublication d'une chasse | Should | Après MVP |
| Indices optionnels par étape | Should | Après MVP |
| Chasses privées, accessibles par lien ou code d'invitation | Should | Après MVP |
| Date de fermeture optionnelle d'une chasse | Should | Après MVP |
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
| Notifications générales (rappels, réengagement) | Inutiles à la démonstration. Seul le cas du bannissement nécessite un e-mail (voir M7 et RM13) | Besoin de réengagement |
| Administration complète (tableau de bord, gestion globale des comptes et des chasses) | Modération minimale (signalement et bannissement, voir M7) nécessaire pour le MVP | Besoin d'une administration plus large |
| Chasse par équipe | Hors scénario de référence, complexité de progression partagée non nécessaire au MVP | Besoin confirmé après le MVP |
| Multilinguisme | Le français seul suffit pour le MVP | Besoin international identifié |
| Variantes de réponse acceptées par étape | Non traité pour le MVP : une seule réponse attendue par étape (RM9) | Non réexaminé pour le MVP |

Le modèle de données et la gestion des droits restent extensibles pour ajouter ensuite un rôle Partenaire.

## 2. Acteurs, rôles et permissions

Le MVP distingue deux niveaux de rôle, indépendants l'un de l'autre :

- **Le type de compte**, fixé à la création du compte : **Utilisateur standard** (par défaut) ou **Admin**. Les comptes Admin sont créés hors inscription publique (jeu de données de démonstration ou action manuelle de l'équipe), aucun utilisateur ne peut s'auto-attribuer ce type.
- **Le rôle par chasse**, contextuel : celui qui crée une chasse en est l'**Organisateur**, et celui qui la rejoint en est **Joueur**. Un même utilisateur peut donc organiser certaines chasses et en jouer d'autres. Ce rôle par chasse s'applique aussi bien à un Utilisateur standard qu'à un Admin.

Un visiteur non connecté ne peut que s'inscrire ou se connecter.

|  | Joueur | Organisateur |
| --- | --- | --- |
| Profil | Personne ou petit groupe cherchant une activité ludique | Personne souhaitant animer une expérience, sans compétence technique |
| Objectif | Trouver une chasse, la rejoindre vite, savoir où il en est, aller au bout | Créer et publier vite, voir qui joue et où |
| Freins à lever | Inscription longue, consignes floues, progression perdue, étape bloquante | Création complexe, aucune visibilité, pas de suivi |
| Contexte d'usage | Surtout mobile | Surtout ordinateur, mobile possible |

### 2.1 Matrice des permissions

| Action | Visiteur | Utilisateur connecté | Organisateur de la chasse | Joueur de la chasse | Admin | Condition d'accès |
| --- | --- | --- | --- | --- | --- | --- |
| S'inscrire, se connecter | Oui | - | - | - | - | Public |
| Lister les chasses publiées | Non | Oui | Oui | Oui | Oui | Authentifié |
| Créer une chasse | Non | Oui (il en devient l'Organisateur) | - | - | Oui | Authentifié |
| Voir une chasse en brouillon | Non | Non | Oui | Non | Non | Propriétaire de la chasse |
| Tester sa chasse en mode essai (aperçu) | Non | Non | Oui | Non | Non | Propriétaire de la chasse, chasse en brouillon |
| Modifier les étapes, publier | Non | Non | Oui | Non | Non | Propriétaire de la chasse |
| Rejoindre une chasse publiée | Non | Oui, sauf sa propre chasse | Non (sa propre chasse) | Déjà inscrit : refus (409) | Oui, sauf sa propre chasse | Statut de la chasse + non-propriétaire |
| Valider une étape | Non | Non | Non | Oui (sa participation) | Non | Propriétaire de la participation |
| Voir sa progression et son résultat | Non | Non | Non | Oui | Non | Propriétaire de la participation |
| Voir la liste des participants | Non | Non | Oui | Non | Non | Propriétaire de la chasse |
| Signaler une chasse ou un organisateur | Non | Oui | Oui | Oui | Oui | Authentifié |
| Consulter la liste des signalements | Non | Non | Non | Non | Oui | Type de compte Admin |
| Bannir un compte | Non | Non | Non | Non | Oui | Type de compte Admin |

Chaque ligne donne lieu à au moins un test d'autorisation : 401 sans session, 403 si l'utilisateur n'est ni Organisateur ni Joueur de la ressource ni Admin quand l'action l'exige, 404 ou 403 si la ressource appartient à un autre utilisateur.

### 2.2 Écart avec le cadrage et limites assumées

Le cadrage prévoyait un rôle choisi à l'inscription. L'équipe retient à la place **un rôle par chasse**, car il permet à chacun de créer et de rejoindre des chasses sans multiplier les comptes.  Cette décision sera consignée dans le journal des décisions.

- **Règle associée** : on ne peut pas rejoindre sa propre chasse (l'Organisateur ne joue pas la sienne), mais il peut la tester en mode essai avant publication (voir M3, US-3.5).
- **Limite assumée** : n'importe quel utilisateur peut publier une chasse sans validation préalable. La modération reste a posteriori, via le signalement traité par un Admin (voir M7), et non une validation systématique avant publication.
- **Extensibilité** : un futur rôle Partenaire s'ajoutera comme un droit supplémentaire (type de compte ou permission sur une chasse), au même titre que le type de compte Admin introduit dans cette version.

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
| RM11 | La suppression volontaire de son propre compte par un utilisateur est définitive. Ses propres participations en tant que Joueur sont supprimées. Les chasses dont il est l'Organisateur ne sont plus listées publiquement (M2) ni rejoignables par de nouveaux joueurs, mais les participations déjà en cours sur ces chasses peuvent être terminées normalement par les joueurs concernés (progression, résultat et badge conservés). Les données personnelles de l'Organisateur (pseudo, e-mail, mot de passe) sont supprimées et seul un identifiant non personnel reste associé à ces chasses tant qu'une participation y est en cours. Les chasses créées par d'autres ne sont pas modifiées. |
| RM12 | Le bannissement d'un compte par un Admin est définitif et en cascade totale il supprime les chasses dont l'utilisateur banni est l'Organisateur (avec leurs étapes et toutes les participations des autres joueurs, y compris celles en cours), ainsi que ses propres participations en tant que Joueur. Aucune donnée, y compris les entrées de journal le concernant, n'est conservée. Un e-mail est envoyé à chaque joueur dont une participation en cours est supprimée. |
| RM13 | L'Organisateur d'une chasse en brouillon peut la parcourir en mode essai (aperçu des étapes et consignes) avant publication. Le mode essai ne crée pas de participation et n'enregistre aucun résultat. |
| RM14 | Une chasse peut être publiée en mode privé : elle n'apparaît pas dans la liste publique (M2) mais reste accessible par lien direct ou par code d'invitation. |
| RM15 | L'Organisateur peut fixer, à la publication ou tant que la chasse n'est pas fermée, une date de fermeture optionnelle. Passé cette date, la chasse n'est plus proposée aux nouveaux joueurs, mais les participations déjà en cours peuvent être terminées normalement. |

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
| 9 | Compte A | Supprime son compte | Sa chasse disparaît de la liste publique et n'est plus rejoignable. A ne peut plus se connecter. Si le compte B avait déjà une participation en cours, il peut toujours la terminer |

Ce scénario sert de test de bout en bout automatisé et de démonstration enregistrée (vidéo). Un jeu de données de démonstration (compte Organisateur de test, chasse d'exemple) sera fourni avec le prototype.

## 4. Spécifications fonctionnelles

Chaque module correspond à une étape du scénario et à un lot Must. Les critères d'acceptation servent directement de base aux tests automatisés.

### M1 - Comptes, authentification et rôles

| ID | User story | Critères d'acceptation |
| --- | --- | --- |
| US-1.1 | En tant que visiteur, je crée un compte | Champs : pseudo, e-mail, mot de passe (aucun rôle à choisir, le type de compte Admin n'est jamais proposé à l'inscription). E-mail unique. Mot de passe de 8 caractères minimum avec chiffre et caractère spécial, jamais stocké ni affiché en clair. Possibilité de se connecter via Google. Erreurs explicites par champ. |
| US-1.2 | En tant qu'utilisateur, je me connecte et me déconnecte | Identifiants invalides : message générique, sans révéler si l'e-mail existe. Session sécurisée, qui expire. Limitation des tentatives de connexion. Déconnexion invalide la session. |
| US-1.3 | En tant qu'utilisateur connecté, j'accède à mes deux espaces : « Jouer » et « Mes chasses » | Accueil sur la liste des chasses, accès à « Mes chasses » (celles que j'organise) et « Mes participations » (celles que je joue). Une route protégée renvoie 401 sans session, et 403 si je ne suis ni l'Organisateur ni le Joueur concerné. |
| US-1.4 | En tant qu'utilisateur connecté, je supprime mon compte | Confirmation explicite, avec un avertissement clair sur ce qui sera perdu (RM11). Mes participations aux chasses des autres sont supprimées avec ma progression, mes résultats et mes badges. Les chasses que j'ai créées ne sont plus listées publiquement ni rejoignables, mais les joueurs ayant déjà une participation en cours peuvent la terminer. Mes données personnelles sont supprimées. Les chasses des autres ne sont pas modifiées. Ma session est fermée et je ne peux plus me connecter avec ces identifiants. L'opération est tout ou rien : jamais de suppression partielle. |
| US-1.5 | En tant que visiteur, je confirme mon e-mail après l'inscription | Un lien de confirmation à usage unique et à durée limitée est envoyé par e-mail. Le compte reste utilisable avant confirmation mais un rappel est affiché. Lien expiré ou déjà utilisé : message explicite et possibilité de le renvoyer. |
| US-1.6 | En tant qu'utilisateur, je réinitialise mon mot de passe oublié | Demande par e-mail, lien à usage unique et à durée limitée, aucune confirmation de l'existence du compte dans la réponse (comme US-1.2). Le nouveau mot de passe suit les mêmes règles que US-1.1. Toutes les sessions actives sont invalidées après réinitialisation. |

### M2 - Liste des chasses publiées

| ID | User story | Critères d'acceptation |
| --- | --- | --- |
| US-2.1 | En tant qu'utilisateur connecté, je consulte les chasses publiées | Affiche titre, description courte, nombre d'étapes, organisateur. Aucune chasse brouillon, aucune chasse privée (US-3.6), aucune chasse dont la date de fermeture (US-3.7) est dépassée. Liste paginée (20 par page). État vide explicite. |
| US-2.2 | En tant qu'utilisateur connecté, j'ouvre le détail d'une chasse | Affiche description et nombre d'étapes, jamais le contenu des étapes ni les réponses. Bouton « Rejoindre » ou « Reprendre » selon l'état de ma participation, et aucun bouton si j'en suis l'Organisateur. |

### M3 - Création et publication d'une chasse (Organisateur)

| ID | User story | Critères d'acceptation |
| --- | --- | --- |
| US-3.1 | En tant qu'utilisateur connecté, je crée une chasse en brouillon | Titre (3 à 100 caractères) et description (jusqu'à 1 000 caractères) validés côté serveur. La chasse m'appartient : j'en deviens l'Organisateur. |
| US-3.2 | J'ajoute des étapes ordonnées | Chaque étape : titre, consigne (indice ou énigme), réponse attendue (relisible par l'Organisateur tant que la chasse est en brouillon, jamais visible d'un joueur), position. Ordre modifiable par réordonnancement. Suppression d'une étape tant que la chasse est en brouillon. |
| US-3.3 | Je publie ma chasse | Refusée sans étape ou sans titre (RM4). Statut passe de brouillon à publiée et la chasse apparaît dans la liste (sauf si privée, US-3.6). Action journalisée. |
| US-3.4 | Je vois la liste de mes chasses | Seules les miennes, avec statut et nombre de participants. |
| US-3.5 | Je teste ma chasse en mode essai avant de la publier | Disponible uniquement sur une chasse en brouillon dont je suis l'Organisateur (RM13). Parcours identique à celui d'un Joueur (consignes, saisie de réponse, RM9) mais aucune participation ni résultat n'est enregistré. |
| US-3.6 | Je choisis de publier ma chasse en privé | Une chasse privée n'apparaît pas dans la liste publique (US-2.1) mais reste accessible par un lien direct ou un code d'invitation que je peux partager (RM14). |
| US-3.7 | Je fixe une date de fermeture optionnelle à ma chasse | Tant que la chasse n'est pas fermée, je peux fixer ou modifier cette date. Passée cette date, ma chasse n'est plus proposée aux nouveaux joueurs mais reste visible dans ma vue de suivi (M6) et les participations en cours peuvent être terminées (RM15). |

Parcours conçu pour que la création d'une chasse de 3 étapes prenne moins de 5 minutes pour un utilisateur novice (cible à vérifier lors de l'essai avec un tiers).

### M4 - Participation, progression et validation

| ID | User story | Critères d'acceptation |
| --- | --- | --- |
| US-4.1 | En tant qu'utilisateur connecté, je rejoins une chasse publiée dont je ne suis pas l'Organisateur | Création d'une participation (statut « en cours », étape 1, horodatage de début). Une seule participation active par chasse : un second essai renvoie la participation existante ou 409. Rejoindre sa propre chasse renvoie 403. Une chasse privée (RM14) se rejoint uniquement via son lien ou son code. Une chasse dont la date de fermeture (RM15) est dépassée ne peut plus être rejointe (403). Je deviens le Joueur de cette chasse. |
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

### M7 - Signalement et modération (Admin)

| ID | User story | Critères d'acceptation |
| --- | --- | --- |
| US-7.1 | En tant qu'utilisateur connecté, je signale une chasse ou un organisateur | Motif obligatoire. Le signalement est journalisé (TR-1). Aucune action automatique sur la chasse ou le compte signalé : le traitement est manuel par un Admin. |
| US-7.2 | En tant qu'Admin, je consulte la liste des signalements | Liste : chasse ou compte signalé, motif, auteur du signalement, date. 403 pour un compte qui n'est pas de type Admin. |
| US-7.3 | En tant qu'Admin, je bannis un compte | Confirmation explicite. Applique RM12 : suppression totale et immédiate du compte banni, de ses chasses, de toutes les participations associées (y compris en cours) et des entrées de journal le concernant. Un e-mail est envoyé à chaque joueur dont une participation en cours est supprimée. Action journalisée avant la suppression des journaux du compte banni lui-même. |

### Transverse - Journalisation des actions sensibles

| ID | Exigence | Critères d'acceptation |
| --- | --- | --- |
| TR-1 | Journaliser les actions sensibles | Sont journalisés : inscription, connexion réussie ou échouée, publication de chasse, inscription à une chasse, validation d'étape (succès ou échec), refus d'autorisation, signalement, bannissement. Chaque entrée : horodatage, acteur, action, ressource, résultat. Jamais de mot de passe ni de réponse attendue dans les logs. |
| TR-2 | Gestion des erreurs | Messages d'erreur clairs, aucune information technique exposée à l'utilisateur. |
| TR-3 | Journal et suppression de compte | Suppression volontaire (RM11) : les entrées existantes sont conservées mais l'acteur est anonymisé (remplacé par un identifiant non personnel). Bannissement (RM12) : les entrées concernant le compte banni sont supprimées avec le reste de ses données. |

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
- Suppression de compte à tout moment (US-1.4) : les données personnelles de l'utilisateur sont supprimées. Ses propres participations sont supprimées avec elles. Ses chasses ne restent accessibles qu'aux joueurs ayant déjà une participation en cours, sans donnée personnelle rattachée (RM11, TR-3).
- Bannissement par un Admin (US-7.3) : suppression totale, sans anonymisation ni conservation (RM12, TR-3).
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
| 2. Conception | 01/11/2026 au 15/12/2026 | Parcours, écrans essentiels, règles métier, backlog, architecture, modèle de données, sécurité, stratégie de tests, hébergement | Jalon 1 validé |
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

### 8.3 Questions tranchées

Toutes les questions de la version 0.2 ont été tranchées en équipe et intégrées dans ce document (sections 1 à 7). Le détail de chaque décision (contexte, options, raison, conséquences, condition de réexamen) figure dans le journal des décisions, entrées D-005 à D-012 :

- **Tester sa propre chasse** : oui, en mode essai (RM13, US-3.5).
- **Modération** : signalement par tout utilisateur, traité par un Admin qui peut bannir un compte (M7, RM12).
- **Groupes de joueurs** : chasses par équipe confirmées hors périmètre du MVP.
- **Mot de passe oublié et confirmation d'e-mail** : intégrés au MVP (US-1.5, US-1.6).
- **Langue de l'interface** : français seul pour le MVP.
- **Réponses tolérantes** : point non traité pour le MVP, une seule réponse attendue par étape reste la règle (RM9).
- **Joueurs d'une chasse supprimée** : suppression volontaire par l'Organisateur, les participations en cours peuvent être terminées (RM11) ; bannissement par un Admin, suppression totale et e-mail aux joueurs concernés (RM12).
- **Journal des actions sensibles après suppression** : anonymisé en cas de suppression volontaire, supprimé en cas de bannissement (TR-3).
- **Chasses privées** : oui, accessibles par lien ou code d'invitation (RM14, US-3.6).

Aucune question ouverte à ce stade.
