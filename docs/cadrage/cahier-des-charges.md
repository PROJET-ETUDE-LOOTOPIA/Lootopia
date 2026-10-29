# Cahier des charges - Lootopia (MVP)

## Version et validation du document

| | |
| --- | --- |
| **Document** | Cahier des charges, Lootopia (MVP) |
| **Version** | 1.4 |
| **Date** | 29/10/2026 |
| **Statut** | À relire et valider par l'équipe |
| **Rédacteurs** | Mathéo Souchet, Elias Forget, Alexis Ballenghien, Alexis Cantin, Arthur Millet |
| **Document de référence** | Note de cadrage v1.0 du 28/09/2026 |
| **Documents liés** | [Journal des décisions](journal-des-decisions.md), [Politique d'usage de l'IA](politique-IA.md), [Rétroplanning](retroplanning.md), [Analyse des risques et plans B](analyse-des-risques.md), [RACI](raci.md), [Synthèse des réponses du jalon 2](../conception/synthese-reponses-jalon-2.md), [Modèle de données](../conception/modele-de-donnees.md) |

### Historique des versions

| Version | Date | Auteur | Modifications |
| --- | --- | --- | --- |
| 0.1 | 05/10/2026 | Équipe | Création du cahier des charges à partir de la note de cadrage v1.0 |
| 0.2 | 07/10/2026 | Équipe | Rôle par chasse à la place du rôle choisi à l'inscription, suppression de compte en cascade ajoutée au périmètre, décisions techniques retirées (renvoyées au jalon 2), table des matières et contraintes ajoutées |
| 0.3 | 26/10/2026 | Équipe | Réponses aux questions ouvertes intégrées : mode essai pour l'Organisateur, confirmation d'e-mail et mot de passe oublié, modération (signalement, rôle Admin, bannissement), distinction suppression volontaire et bannissement, chasses privées et date de fermeture optionnelle, langue française seule, chasse par équipe confirmée hors périmètre. Voir le journal des décisions D-005 à D-012 |
| 1.1 | 26/10/2026 | Équipe | Jalons et règles de pilotage déplacés dans le [rétroplanning](retroplanning.md), responsabilités dans le [RACI](raci.md), risques dans l'[analyse des risques et plans B](analyse-des-risques.md). Les titres sont conservés et renvoient vers ces documents |
| 1.2 | 26/10/2026 | Équipe, rédaction assistée par Claude (Anthropic) | Réponses de l'équipe au jalon 2 intégrées (voir la [synthèse](../conception/synthese-reponses-jalon-2.md)) : connexion Google et e-mails par Mailjet, une seule participation par joueur et par chasse, suppression de compte avec fermeture progressive des chasses, bannissement par anonymisation (compte conservé avec le statut « banni »), 403 pour toute ressource d'autrui, message neutre à l'inscription, temps de jeu mesuré par le serveur, fuseau de Paris, code d'invitation de 6 caractères, stack retenue. Questions encore ouvertes listées en 8.3. Les décisions ne sont pas encore au journal (entrées à partir de D-013, à rédiger par l'équipe). Mise à jour à relire par l'équipe |
| 1.3 | 29/10/2026 | Équipe, rédaction assistée par Claude (Anthropic) | Retrait du journal des actions sensibles (TR-1 et TR-3 supprimées, TR-2 renumérotée TR-1). Complexité jugée disproportionnée par rapport à la valeur apportée pour le MVP, remplacé par du logging applicatif classique. Voir [D-013](journal-des-decisions.md#d-013--retrait-du-journal-des-actions-sensibles) |
| 1.4 | 29/10/2026 | Équipe, rédaction assistée par Claude (Anthropic) | RM15 alignée sur le même mécanisme de fermeture que RM11. Une chasse dont la date de fermeture est dépassée entre en fermeture (statut `closing` puis `closed`) comme pour une suppression volontaire, au lieu de rester indéfiniment `published`, sans e-mail de prévenance. Voir [D-014](journal-des-decisions.md#d-014--fermeture-dune-chasse-par-date-alignée-sur-rm11) |

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
  - [Transverse : Gestion des erreurs](#transverse---gestion-des-erreurs)
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
  - [7.5 Definition of Ready](#75-definition-of-ready)
  - [7.6 Definition of Done](#76-definition-of-done)
- [8. Risques, contraintes et questions](#8-risques-contraintes-et-questions)
  - [8.1 Risques](#81-risques)
  - [8.2 Contraintes](#82-contraintes)
  - [8.3 Questions tranchées](#83-questions-tranchées)

## 1. Contexte, objectifs et périmètre du MVP

Le MVP de Lootopia est un prototype web responsive qui prouve la boucle **créer, jouer, suivre** . Un Organisateur publie une chasse au trésor, un Joueur la termine sans perdre sa progression, l'Organisateur voit où en est chacun. Le commanditaire (Out of Cache) décidera en fin de projet de poursuivre ou non Lootopia. Il n'attend ni plateforme complète ni mise en production.

Ce cahier des charges décrit **ce que le MVP doit faire**. Seule la stack retenue au jalon 2 y figure (8.2). L'architecture, le modèle de données, l'API, les tests et l'intégration continue sont décrits dans les documents de conception.

### 1.1 Objectifs

- Livrer les 6 étapes du scénario de référence de bout en bout, sans intervention en base de données.
- Fournir des preuves de qualité, sécurité, maintenabilité et reproductibilité exploitables par une autre équipe.
- Rester dans la capacité de 5 personnes sur 5 jalons (28/09/2026 au 30/06/2027).

### 1.2 Périmètre MoSCoW

| Fonction | Priorité | Lot MVP |
| --- | --- | --- |
| Inscription, connexion (e-mail et mot de passe, ou compte Google), rôles Organisateur et Joueur attribués par chasse | Must | M1 |
| Suppression de compte (participations supprimées, chasses créées fermées progressivement) | Must | M1 |
| Création d'une chasse (titre, description, étapes ordonnées) et publication | Must | M3 |
| Liste des chasses publiées | Must | M2 |
| Inscription d'un joueur à une chasse | Must | M4 |
| Progression par étapes et énigmes, validation côté serveur | Must | M4 |
| Progression conservée entre les sessions | Must | M4 |
| Résultat final : badge de complétion, temps total, étapes franchies | Must | M5 |
| Vue de suivi Organisateur | Must | M6 |
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
| Notifications générales (rappels, réengagement) | Inutiles à la démonstration. Seuls les e-mails de confirmation, de mot de passe oublié, de prévenance de fermeture d'une chasse (RM11) et de bannissement (RM12) sont envoyés | Besoin de réengagement |
| Administration complète (tableau de bord, gestion globale des comptes et des chasses) | Modération minimale (signalement et bannissement, voir M7) nécessaire pour le MVP | Besoin d'une administration plus large |
| Chasse par équipe | Hors scénario de référence, complexité de progression partagée non nécessaire au MVP | Besoin confirmé après le MVP |
| Multilinguisme | Le français seul suffit pour le MVP | Besoin international identifié |
| Variantes de réponse acceptées par étape | Non traité pour le MVP : une seule réponse attendue par étape (RM9) | Non réexaminé pour le MVP |

Le modèle de données et la gestion des droits restent extensibles pour ajouter ensuite un rôle Partenaire.

## 2. Acteurs, rôles et permissions

Le MVP distingue deux niveaux de rôle, indépendants l'un de l'autre :

- **Le type de compte**, fixé à la création du compte : **Utilisateur standard** (par défaut) ou **Admin**. Les comptes Admin sont créés hors inscription publique (jeu de données de démonstration ou action manuelle de l'équipe), aucun utilisateur ne peut s'auto-attribuer ce type. Un compte a aussi un **statut** : actif, supprimé (RM11) ou banni (RM12). Un compte supprimé ou banni ne peut plus se connecter.
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
| Rejoindre une chasse publiée | Non | Oui, sauf sa propre chasse | Non (sa propre chasse) | Déjà inscrit, même si la participation est terminée : refus (409) | Oui, sauf sa propre chasse | Chasse publiée et non en fermeture (RM11, RM15), non-propriétaire |
| Valider une étape | Non | Non | Non | Oui (sa participation) | Non | Propriétaire de la participation |
| Voir sa progression et son résultat | Non | Non | Non | Oui | Non | Propriétaire de la participation |
| Voir la liste des participants | Non | Non | Oui | Non | Non | Propriétaire de la chasse |
| Signaler une chasse ou un organisateur | Non | Oui | Oui | Oui | Oui | Authentifié |
| Consulter la liste des signalements | Non | Non | Non | Non | Oui | Type de compte Admin |
| Bannir un compte | Non | Non | Non | Non | Oui | Type de compte Admin |

Chaque ligne donne lieu à au moins un test d'autorisation : 401 sans session, 403 si l'utilisateur n'est ni Organisateur ni Joueur de la ressource ni Admin quand l'action l'exige, et 403 (jamais 404) si la ressource appartient à un autre utilisateur.

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
| RM2 | Tout utilisateur connecté, sauf l'Organisateur de la chasse, peut rejoindre une chasse publiée et en devient le Joueur. Il n'y a qu'une seule participation par joueur et par chasse, quel que soit son statut : une chasse terminée ne se rejoue pas. Une chasse en fermeture (RM11, RM15) ne peut plus être rejointe. |
| RM3 | Seules les chasses publiées sont visibles des autres utilisateurs Un brouillon n'est visible que de son Organisateur. |
| RM4 | Une chasse ne peut être publiée que si elle compte au moins 1 étape (3 pour la démo) et un titre non vide. |
| RM5 | Les étapes se valident dans l'ordre : l'étape suivante n'est visible qu'après validation de la courante. |
| RM6 | La validation se fait côté serveur. La réponse attendue n'est jamais transmise au navigateur. |
| RM7 | Valider la dernière étape clôt la participation (statut « terminé »), fige le temps total et déclenche l'attribution du badge. Le temps total est le temps pendant lequel le joueur est en train de réaliser la chasse, mesuré par le serveur avec un compteur mis à jour pendant qu'il joue (ce n'est pas l'écart entre la date de début et la date de fin). |
| RM8 | Une chasse publiée ne peut plus voir ses étapes modifiées (évite d'invalider des progressions en cours, modification complète = Should hors MVP). |
| RM9 | La comparaison des réponses est insensible à la casse, aux accents et aux espaces en début ou fin de saisie. Toute suite d'espaces à l'intérieur d'une réponse compte pour un seul espace. La même normalisation est appliquée à la réponse attendue et à la saisie du joueur. |
| RM10 | Un même utilisateur peut être Organisateur de certaines chasses et Joueur d'autres. Il n'existe pas de rôle global. |
| RM11 | La suppression volontaire de son propre compte par un utilisateur est définitive. Le compte reste en base sous un identifiant non personnel, avec le statut « supprimé » : son pseudo, son e-mail et son mot de passe sont supprimés et il ne peut plus se connecter. Ses brouillons et ses propres participations en tant que Joueur sont supprimés. Ses chasses publiées ne sont plus listées publiquement (M2) ni rejoignables par de nouveaux joueurs, affichent « compte supprimé » à la place de l'Organisateur et ne sont plus suivies. Elles ne sont jamais attribuées à un Admin. Les joueurs ayant une participation en cours peuvent la terminer normalement (progression, résultat et badge conservés) et sont prévenus par e-mail de la future fermeture de la chasse. Une chasse se ferme quand sa dernière participation en cours est terminée, ou tout de suite si aucune n'est en cours. Les chasses créées par d'autres ne sont pas modifiées. |
| RM12 | Le bannissement d'un compte par un Admin est définitif. Le compte reste en base sous un identifiant non personnel, avec le statut « banni » : ses données personnelles (pseudo, e-mail, mot de passe) sont anonymisées et il ne peut plus se connecter. Ses chasses, brouillons compris, sont supprimées avec leurs étapes et toutes leurs participations, y compris celles en cours des autres joueurs, ainsi que ses propres participations en tant que Joueur. Un e-mail est envoyé à chaque joueur dont une participation en cours est supprimée. |
| RM13 | L'Organisateur d'une chasse en brouillon peut la parcourir en mode essai (aperçu des étapes et consignes) avant publication. Le mode essai ne crée pas de participation et n'enregistre aucun résultat. |
| RM14 | Une chasse peut être publiée en mode privé : elle n'apparaît pas dans la liste publique (M2) mais reste accessible par lien direct ou par code d'invitation. Le code d'invitation compte 6 caractères : des lettres majuscules et des chiffres. |
| RM15 | L'Organisateur peut fixer, à la publication ou tant que la chasse n'est pas fermée, une date de fermeture optionnelle. Passé cette date, la chasse n'est plus proposée aux nouveaux joueurs, mais les participations déjà en cours peuvent être terminées normalement. Elle entre donc en fermeture, comme pour une suppression volontaire (RM11), sans e-mail aux joueurs en cours puisque la date était connue à l'avance. La date est saisie et interprétée en heure de Paris. |

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
| 9 | Compte A | Supprime son compte | Sa chasse disparaît de la liste publique, n'est plus rejoignable et affiche « compte supprimé » comme organisateur. A ne peut plus se connecter. Si le compte B avait déjà une participation en cours, il est prévenu par e-mail et peut toujours la terminer, après quoi la chasse se ferme |

Ce scénario sert de test de bout en bout automatisé et de démonstration enregistrée (vidéo). Un jeu de données de démonstration (compte Organisateur de test, chasse d'exemple) sera fourni avec le prototype.

## 4. Spécifications fonctionnelles

Chaque module correspond à une étape du scénario et à un lot Must. Les critères d'acceptation servent directement de base aux tests automatisés.

### M1 - Comptes, authentification et rôles

| ID | User story | Critères d'acceptation |
| --- | --- | --- |
| US-1.1 | En tant que visiteur, je crée un compte | Champs : pseudo, e-mail, mot de passe (aucun rôle à choisir, le type de compte Admin n'est jamais proposé à l'inscription). E-mail unique. Mot de passe de 8 caractères minimum avec chiffre et caractère spécial, jamais stocké ni affiché en clair. Possibilité de s'inscrire ou de se connecter via Google : le compte est alors créé sans mot de passe. Erreurs explicites par champ, sauf pour l'e-mail : que l'adresse soit déjà utilisée ou non, le même message « un e-mail est envoyé » s'affiche, sans aucune indication sur les comptes existants. |
| US-1.2 | En tant qu'utilisateur, je me connecte et me déconnecte | Connexion par e-mail et mot de passe, ou via Google. Identifiants invalides : message générique, sans révéler si l'e-mail existe. Un compte supprimé ou banni ne peut pas se connecter. Session sécurisée, qui expire. Limitation des tentatives de connexion. Déconnexion invalide la session. |
| US-1.3 | En tant qu'utilisateur connecté, j'accède à mes deux espaces : « Jouer » et « Mes chasses » | Accueil sur la liste des chasses, accès à « Mes chasses » (celles que j'organise) et « Mes participations » (celles que je joue). Une route protégée renvoie 401 sans session, et 403 si je ne suis ni l'Organisateur ni le Joueur concerné. |
| US-1.4 | En tant qu'utilisateur connecté, je supprime mon compte | Confirmation explicite, avec un avertissement clair sur ce qui sera perdu (RM11). Mes participations aux chasses des autres sont supprimées avec ma progression, mes résultats et mes badges. Mes brouillons sont supprimés. Mes chasses publiées ne sont plus listées publiquement ni rejoignables et affichent « compte supprimé » à la place de mon nom. Les joueurs ayant déjà une participation en cours sont prévenus par e-mail de la future fermeture et peuvent la terminer, puis la chasse se ferme. Mes données personnelles sont supprimées. Les chasses des autres ne sont pas modifiées. Ma session est fermée et je ne peux plus me connecter avec ces identifiants. L'opération est tout ou rien : jamais de suppression partielle. |
| US-1.5 | En tant que visiteur, je confirme mon e-mail après l'inscription | Un lien de confirmation à usage unique et à durée limitée est envoyé par e-mail. Le compte reste utilisable avant confirmation mais un rappel est affiché. Lien expiré ou déjà utilisé : message explicite et possibilité de le renvoyer. |
| US-1.6 | En tant qu'utilisateur, je réinitialise mon mot de passe oublié | Demande par e-mail, lien à usage unique et à durée limitée, aucune confirmation de l'existence du compte dans la réponse (comme US-1.2). Le nouveau mot de passe suit les mêmes règles que US-1.1. Toutes les sessions actives sont invalidées après réinitialisation. |

### M2 - Liste des chasses publiées

| ID | User story | Critères d'acceptation |
| --- | --- | --- |
| US-2.1 | En tant qu'utilisateur connecté, je consulte les chasses publiées | Affiche titre, description courte, nombre d'étapes, organisateur. Aucune chasse brouillon, aucune chasse privée (US-3.6), aucune chasse en fermeture ou fermée, qu'elle y soit entrée par suppression de son organisateur (RM11) ou par sa date de fermeture dépassée (RM15). Liste paginée (20 par page). État vide explicite. |
| US-2.2 | En tant qu'utilisateur connecté, j'ouvre le détail d'une chasse | Affiche description et nombre d'étapes, jamais le contenu des étapes ni les réponses. Bouton « Rejoindre », « Reprendre » ou « Voir mon résultat » selon l'état de ma participation (une chasse terminée ne se rejoue pas), et aucun bouton si j'en suis l'Organisateur. Pour une chasse en fermeture par suppression de son organisateur (RM11), un message explique qu'elle n'accepte plus de nouveaux joueurs et l'organisateur est affiché « compte supprimé ». Pour une chasse en fermeture par date dépassée (RM15), le même message s'affiche, sans mention de compte supprimé puisque l'organisateur reste actif. Dans les deux cas, seul un joueur dont la participation est en cours voit « Reprendre ». |

### M3 - Création et publication d'une chasse (Organisateur)

| ID | User story | Critères d'acceptation |
| --- | --- | --- |
| US-3.1 | En tant qu'utilisateur connecté, je crée une chasse en brouillon | Titre (3 à 100 caractères) et description (jusqu'à 1 000 caractères) validés côté serveur. La chasse m'appartient : j'en deviens l'Organisateur. |
| US-3.2 | J'ajoute des étapes ordonnées | Chaque étape : titre, consigne (indice ou énigme), réponse attendue (relisible par l'Organisateur tant que la chasse est en brouillon, jamais visible d'un joueur), position. Ordre modifiable par réordonnancement. Suppression d'une étape tant que la chasse est en brouillon. |
| US-3.3 | Je publie ma chasse | Refusée sans étape ou sans titre (RM4). Statut passe de brouillon à publiée et la chasse apparaît dans la liste (sauf si privée, US-3.6). |
| US-3.4 | Je vois la liste de mes chasses | Seules les miennes, avec statut et nombre de participants. |
| US-3.5 | Je teste ma chasse en mode essai avant de la publier | Disponible uniquement sur une chasse en brouillon dont je suis l'Organisateur (RM13). Parcours identique à celui d'un Joueur (consignes, saisie de réponse, RM9) mais aucune participation ni résultat n'est enregistré. |
| US-3.6 | Je choisis de publier ma chasse en privé | Une chasse privée n'apparaît pas dans la liste publique (US-2.1) mais reste accessible par un lien direct ou un code d'invitation de 6 caractères (lettres majuscules et chiffres) que je peux partager (RM14). |
| US-3.7 | Je fixe une date de fermeture optionnelle à ma chasse | Tant que la chasse n'est pas fermée, je peux fixer ou modifier cette date, en heure de Paris. Passée cette date, ma chasse entre en fermeture. Elle n'est donc plus proposée aux nouveaux joueurs mais reste visible dans ma vue de suivi (M6), les participations en cours peuvent être terminées, et la chasse se ferme complètement quand la dernière se termine (RM15). |

Parcours conçu pour que la création d'une chasse de 3 étapes prenne moins de 5 minutes pour un utilisateur novice (cible à vérifier lors de l'essai avec un tiers).

### M4 - Participation, progression et validation

| ID | User story | Critères d'acceptation |
| --- | --- | --- |
| US-4.1 | En tant qu'utilisateur connecté, je rejoins une chasse publiée dont je ne suis pas l'Organisateur | Création d'une participation (statut « en cours », étape 1, horodatage de début). Une seule participation par chasse et par joueur : un second essai renvoie la participation en cours ou 409, et un joueur qui a terminé la chasse ne peut pas la rejouer (409). Rejoindre sa propre chasse renvoie 403. Une chasse privée (RM14) se rejoint uniquement via son lien ou son code. Une chasse dont la date de fermeture (RM15) est dépassée ne peut plus être rejointe (403), de même qu'une chasse en fermeture (RM11). Je deviens le Joueur de cette chasse. |
| US-4.2 | Je vois l'étape courante | Seule l'étape courante est renvoyée. Accès à une étape future refusé (403). |
| US-4.3 | Je valide une étape en saisissant ma réponse | Comparaison côté serveur selon RM9. Bonne réponse : progression enregistrée immédiatement et étape suivante renvoyée. Mauvaise réponse : message d'erreur clair, aucun changement d'état, nombre d'essais enregistré. |
| US-4.4 | Je reprends ma chasse après déconnexion | À la reconnexion, je retrouve l'étape courante exacte. L'état est conservé côté serveur, jamais déduit du navigateur. |
| US-4.5 | Je suis bloqué sur une étape | La consigne reste affichée et lisible ; les erreurs ne verrouillent pas le joueur. (Les indices sont un Should hors MVP.) |
| US-4.6 | Mon temps de jeu est mesuré | Le serveur tient un compteur de temps de jeu sur ma participation et le met à jour pendant que je joue. Le temps où je ne suis pas connecté à la chasse n'est pas compté (RM7). L'intervalle de mise à jour et le seuil d'inactivité sont fixés en conception. |

### M5 - Résultat final

| ID | User story | Critères d'acceptation |
| --- | --- | --- |
| US-5.1 | En tant que Joueur, je termine la chasse et reçois mon résultat | La validation de la dernière étape passe la participation à « terminée », fige la date de fin et le temps total, attribue le badge de complétion. |
| US-5.2 | Je consulte mon récapitulatif | Affiche temps total (temps passé à jouer, RM7), étapes franchies, nombre d'essais, badge. Consultable à nouveau plus tard. Une participation terminée ne peut plus être modifiée. |

### M6 - Vue de suivi Organisateur

| ID | User story | Critères d'acceptation |
| --- | --- | --- |
| US-6.1 | En tant qu'Organisateur, je vois les participants de ma chasse | Liste : pseudo, étape atteinte (X sur N), statut (en cours ou terminé), date de début, temps total si terminé. Uniquement pour mes chasses 403 sinon. |
| US-6.2 | Je filtre par statut | Filtre « en cours » et « terminé » ; compteurs agrégés (nombre de participants, nombre de terminés). |

### M7 - Signalement et modération (Admin)

| ID | User story | Critères d'acceptation |
| --- | --- | --- |
| US-7.1 | En tant qu'utilisateur connecté, je signale une chasse ou un organisateur | Motif obligatoire. Aucune action automatique sur la chasse ou le compte signalé : le traitement est manuel par un Admin. |
| US-7.2 | En tant qu'Admin, je consulte la liste des signalements | Liste : chasse ou compte signalé, motif, auteur du signalement, date. 403 pour un compte qui n'est pas de type Admin. |
| US-7.3 | En tant qu'Admin, je bannis un compte | Confirmation explicite. Applique RM12 : le compte est conservé avec le statut « banni » et ses données personnelles sont anonymisées. Ses chasses sont supprimées avec leurs étapes et toutes leurs participations (y compris en cours), ainsi que ses propres participations. Un e-mail est envoyé à chaque joueur dont une participation en cours est supprimée. |

### Transverse - Gestion des erreurs

| ID | Exigence | Critères d'acceptation |
| --- | --- | --- |
| TR-1 | Gestion des erreurs | Messages d'erreur clairs, aucune information technique exposée à l'utilisateur. |

## 5. Exigences non fonctionnelles

Ces exigences décrivent le niveau attendu, pas la façon de l'obtenir : les moyens techniques seront choisis au jalon 2.

### 5.1 Sécurité

- Les mots de passe ne sont jamais stockés ni affichés en clair.
- Les droits sont contrôlés côté serveur à chaque action (masquer un bouton ne suffit pas)
- La réponse attendue d'une étape n'est jamais transmise au navigateur : aucune réponse de l'API ne la contient, quel que soit le point d'accès, ce qu'un test vérifie.
- Toutes les saisies sont validées côté serveur.
- Aucun secret (mot de passe, clé) ne figure dans le dépôt de code.
- Un logging applicatif classique (framework retenu par la stack) trace les événements techniques et les erreurs, sans jamais inclure de mot de passe ni de réponse attendue.
- Les messages d'erreur ne révèlent ni information technique ni l'existence d'un compte, y compris à l'inscription (US-1.1).
- Un limiteur de débit protège les actions sensibles (connexion, validation de réponse, envoi d'e-mails). Ses valeurs seront fixées avant la construction.
- Les liens envoyés par e-mail (confirmation, mot de passe oublié) sont à usage unique et de courte durée, car le fournisseur d'envoi a accès au contenu des e-mails.
- La clé de l'API d'envoi d'e-mails est stockée dans une variable d'environnement ou un gestionnaire de secrets, jamais dans le code ni côté navigateur. Elle a des permissions minimales (envoi uniquement) et peut être remplacée. Le suivi des clics et des ouvertures est désactivé sur les e-mails transactionnels, et le compte du fournisseur est protégé par une authentification à deux facteurs.

### 5.2 Accessibilité et UX

- Niveau **WCAG 2.1 AA** sur les écrans du scénario : navigation au clavier, contrastes suffisants, champs étiquetés, messages d'erreur explicites, cibles tactiles adaptées, information jamais portée par la seule couleur.
- Score **Lighthouse accessibilité d'au moins 90** sur chaque écran du scénario, complété par des tests manuels.
- Parcours complet utilisable sur mobile et sur ordinateur.
- Retour visible à chaque action (chargement, succès, erreur) et aucune perte de saisie sur erreur de validation.

### 5.3 Performance et sobriété

- Parcours fluide sur mobile comme sur ordinateur : pages légères, listes paginées.
- Pas de service externe payant dans le MVP. Deux services externes gratuits sont retenus et justifiés ci-dessous. Tout autre service ajouté est justifié au préalable (coût, limites, solution de remplacement).
  - **Google (connexion)** : gratuit. Aucune solution de remplacement n'est nécessaire, la connexion par e-mail et mot de passe reste disponible.
  - **Mailjet (envoi des e-mails)** : offre gratuite limitée à 200 e-mails par jour et 6 000 par mois. Au-delà de 200 par jour, les messages sont retenus et envoyés le lendemain, puis supprimés au bout de trois jours (documentation Mailjet consultée le 26/10/2026, à revérifier avant la démonstration). L'équipe accepte ce risque de quota pour le MVP. Solution de remplacement : une autre offre gratuite d'envoi d'e-mails, à nommer par l'équipe avant la fin du jalon 2.

### 5.4 Données personnelles (RGPD)

- Données collectées limitées au strict nécessaire : e-mail, pseudo, mot de passe (absent pour un compte Google), identifiant Google, historique de participation, temps de jeu.
- Sous-traitants : Mailjet reçoit les adresses e-mail et le contenu des e-mails transactionnels (hébergé dans l'UE selon l'équipe, à vérifier), Google fournit la connexion. Ils sont à inscrire dans le registre des traitements.
- Aucune géolocalisation.
- Information claire à l'inscription, finalités et durées de conservation documentées.
- Suppression de compte à tout moment (US-1.4) : les données personnelles de l'utilisateur sont supprimées et le compte, conservé sous un identifiant non personnel, ne peut plus se connecter. Ses propres participations et ses brouillons sont supprimés. Ses chasses publiées ne restent ouvertes qu'aux joueurs ayant déjà une participation en cours, puis se ferment, sans donnée personnelle rattachée (RM11).
- Bannissement par un Admin (US-7.3) : les données personnelles du compte sont anonymisées, ses chasses et leurs participations sont supprimées. Seul reste un identifiant non personnel (RM12).
- Comptes et chasses fictifs en démonstration.

### 5.5 Maintenabilité et reproductibilité

- Un tiers installe et lance le prototype depuis zéro en moins de 15 minutes avec le seul README, en une commande `docker compose up`.
- Architecture, API et choix techniques documentés. L'API REST est décrite par une documentation Swagger (OpenAPI). Les règles métier vivent dans des services côté serveur, un service par règle, pour qu'un tiers retrouve où modifier une règle de progression.
- Les choix techniques importants sont consignés dans le journal des décisions.
- Un jeu de données de démonstration est fourni.
- L'usage de l'IA sur le projet suit la [politique d'usage de l'IA](politique-IA.md) : responsabilité humaine, compréhension obligatoire de ce qui est livré, moindre accès et transparence.

## 6. Critères de réussite

La qualité et la sécurité doivent être prouvées avec une preuve pour chaque critère.

| Axe | Critère | Preuve |
| --- | --- | --- |
| Fonctionnel | Les 6 étapes du scénario s'exécutent de bout en bout, sans toucher à la base de données | Démonstration enregistrée, test de bout en bout |
| Qualité | Authentification, contrôle des droits, validation d'une étape et attribution du résultat couverts par des tests automatisés, tous verts en intégration continue | Rapport de tests, couverture d'au moins 70 % sur ces modules |
| Sécurité | Un utilisateur ne peut ni modifier ni publier une chasse dont il n'est pas l'Organisateur, ni rejoindre la sienne. La réponse attendue n'est jamais envoyée au navigateur. Mots de passe protégés, entrées validées, aucun secret dans le dépôt | Tests d'autorisation, revue du dépôt |
| Reproductibilité | Une personne extérieure installe et lance le prototype depuis zéro en moins de 15 minutes, avec le seul README et `docker compose up` | Essai chronométré avec un tiers |
| Maintenabilité | Architecture, API et choix techniques documentés, un tiers retrouve où modifier une règle de progression | Relecture par un tiers |
| UX et accessibilité | Parcours complet utilisable sur mobile et ordinateur, score Lighthouse d'accessibilité d'au moins 90 sur les écrans du scénario | Audit Lighthouse, tests manuels |

## 7. Planification

Le séquencement des cinq jalons est fixé par le client. Le MVP correspond au cœur du scénario exécutable (tous les Must) à l'issue du jalon 3, puis consolidé au jalon 4.

### 7.1 Jalons

Voir le [rétroplanning](retroplanning.md#1-jalons).

### 7.2 Règles de pilotage

Voir le [rétroplanning](retroplanning.md#2-règles-de-pilotage).

### 7.3 Backlog initial

Le backlog unique reprend les user stories de la section 4, avec pour chacune : responsable, priorité MoSCoW, état et lien vers sa revue. Le benchmark de trois offres existantes prévus avant la fin du jalon 2 alimentent et réordonnent ce backlog.

### 7.4 Responsabilités

Voir le [RACI](raci.md).

### 7.5 Definition of Ready

Une user story peut entrer en développement lorsque :

- ses critères d'acceptation sont rédigés et compris par celui qui va l'implémenter
- elle est rattachée à un module et à une priorité MoSCoW (section 1.2)
- les règles métier et permissions concernées sont identifiées (sections 2.1 et 3.2)
- sa dépendance à une autre user story, si elle existe, est levée ou planifiée avant elle
- son référent de domaine (section 7.4) l'a revue et ne voit pas de point bloquant.

### 7.6 Definition of Done

Une user story est terminée lorsque :

- ses critères d'acceptation sont vérifiés par des tests automatisés qui passent
- elle est relue et approuvée par le référent du domaine, via une revue nominative
- les saisies sont validées et les contrôles d'accès côté serveur sont testés
- l'écran concerné est utilisable sur mobile et ordinateur, au clavier, sans erreur d'accessibilité bloquante
- la documentation est à jour
- l'installation depuis zéro fonctionne toujours avec le README.

## 8. Risques, contraintes et questions

### 8.1 Risques

Voir l'[analyse des risques et plans B](analyse-des-risques.md).

### 8.2 Contraintes
- **Temps** : cinq jalons aux dates fixées par le client. La capacité tient compte des périodes de cours et d'entreprise et est recalculée à chaque itération. En cas de dérive, la règle de coupe s'applique.
- **Budget** : aucun budget alloué. Solutions locales, libres ou avec un niveau gratuit suffisant. Tout service payant ou limité par quota est documenté (coût, limites, solution de remplacement) avant d'être intégré. Les services retenus (Google, Mailjet) sont justifiés en 5.3.
- **Technique** : aucune technologie imposée par le client. Stack retenue par l'équipe au jalon 2 : React, Node.js et TypeScript, API REST avec Express, PostgreSQL, Docker, application web progressive (PWA) pour le mobile. La cible est un service web responsive dont le code et l'architecture peuvent être repris par une autre équipe. Hébergement : solution gratuite ou locale de type Docker, déployable n'importe où.
- **Réglementaire et qualité** : respect du RGPD (données minimales, aucune géolocalisation), accessibilité WCAG 2.1 AA sur les écrans du scénario, qualité et sécurité prouvées par des tests et des revues.
- **Équipe** : cinq personnes, un référent et un suppléant par domaine, contributions nominatives (tickets, commits, revues).

### 8.3 Questions tranchées

Les questions de la version 0.2 ont été tranchées en équipe et intégrées dans ce document, puis celles du jalon 2 (version 1.2). Le détail des décisions D-005 à D-012 (contexte, options, raison, conséquences, condition de réexamen) figure dans le journal des décisions. Les décisions du jalon 2 sont reprises dans la [synthèse des réponses](../conception/synthese-reponses-jalon-2.md) en attendant leur entrée au journal, à rédiger par l'équipe :

- **Tester sa propre chasse** : oui, en mode essai (RM13, US-3.5).
- **Modération** : signalement par tout utilisateur, traité par un Admin qui peut bannir un compte (M7, RM12).
- **Groupes de joueurs** : chasses par équipe confirmées hors périmètre du MVP.
- **Mot de passe oublié et confirmation d'e-mail** : intégrés au MVP (US-1.5, US-1.6).
- **Langue de l'interface** : français seul pour le MVP.
- **Réponses tolérantes** : point non traité pour le MVP, une seule réponse attendue par étape reste la règle (RM9).
- **Joueurs d'une chasse supprimée** : suppression volontaire par l'Organisateur, la chasse reste ouverte jusqu'à la fin des participations en cours et les joueurs sont prévenus par e-mail (RM11) ; bannissement par un Admin, chasses et participations supprimées et e-mail aux joueurs concernés (RM12).
- **Chasses privées** : oui, accessibles par lien ou code d'invitation (RM14, US-3.6).
- **Services externes** : connexion Google et envoi d'e-mails par Mailjet, avec leurs limites et leurs solutions de remplacement (5.3).
- **Rejeu d'une chasse** : non, une seule participation par joueur et par chasse (RM2).
- **Code d'erreur sur la ressource d'autrui** : 403 (matrice 2.1).
- **Inscription avec une adresse déjà utilisée** : aucune erreur, message neutre (US-1.1).
- **Temps total** : temps passé à jouer, mesuré par le serveur (RM7, US-4.6).
- **Fuseau, code d'invitation, normalisation des réponses** : heure de Paris (RM15), 6 caractères (RM14), normalisation classique (RM9).
- **Stack technique et hébergement** : voir 8.2.
- **Journal des actions sensibles** : retiré du MVP, remplacé par du logging applicatif classique (D-013).

Questions encore ouvertes :

- Connexion Google avec une adresse déjà utilisée par un compte e-mail et mot de passe : fusion ou refus, et un compte Google est-il considéré comme confirmé (US-1.1) ?
- Pseudo unique ou non (US-1.1) ? Un pseudo unique ferait réapparaître une erreur explicite à l'inscription.
- Contenu de l'e-mail envoyé quand l'adresse d'inscription est déjà utilisée (US-1.1).
- Chasse en fermeture : durée maximale avant une fermeture forcée et contenu de l'e-mail de prévenance (RM11).
- E-mail aux joueurs lors d'un bannissement : maintenu (RM12), à confirmer. La personne bannie peut se réinscrire avec la même adresse, puisque celle-ci n'est plus conservée.
- Hébergement de l'instance de démonstration pour l'évaluateur (8.2).
- Compteur de temps de jeu : intervalle de mise à jour et seuil d'inactivité (US-4.6).
- Valeurs du limiteur de débit (5.1).
- Nom de la solution de remplacement de Mailjet (5.3).
