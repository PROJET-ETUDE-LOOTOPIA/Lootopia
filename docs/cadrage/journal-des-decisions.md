# Journal des décisions - Lootopia

Ce journal garde la trace de chaque choix important du projet : ce qui a été décidé, pourquoi, et ce qu'on a écarté. Il permet à une autre équipe de reprendre le projet.

Seules les décisions de cadrage (périmètre, parcours, règles métier) y figurent pour l'instant. Les décisions techniques (stack, architecture, sécurité technique, tests) seront consignées à partir du jalon 2.

**Table des matières**

- [Mode d'emploi](#mode-demploi)
- [Modèle d'entrée](#modèle-dentrée)
- [Pilotage et produit](#pilotage-et-produit)
  - [D-001 : Périmètre du MVP](#d-001--périmètre-du-mvp--moscow-et-renoncements)
  - [D-002 : Rôle par chasse](#d-002--rôle-par-chasse-plutôt-que-rôle-global)
  - [D-003 : Un Organisateur ne peut pas rejoindre sa propre chasse](#d-003--un-organisateur-ne-peut-pas-rejoindre-sa-propre-chasse)
  - [D-004 : Suppression de compte en cascade](#d-004--suppression-de-compte-en-cascade-classée-must-06102026)
  - [D-005 : Mode essai pour l'Organisateur avant publication](#d-005--mode-essai-pour-lorganisateur-avant-publication)
  - [D-006 : Confirmation d'e-mail et mot de passe oublié dans le MVP](#d-006--confirmation-de-mail-et-mot-de-passe-oublié-dans-le-mvp)
  - [D-007 : Modération, rôle Admin et bannissement](#d-007--modération-rôle-admin-et-bannissement)
  - [D-009 : Chasses privées accessibles par lien ou code](#d-009--chasses-privées-accessibles-par-lien-ou-code)
  - [D-010 : Date de fermeture optionnelle d'une chasse](#d-010--date-de-fermeture-optionnelle-dune-chasse)
  - [D-011 : Langue de l'interface, français seul pour le MVP](#d-011--langue-de-linterface-français-seul-pour-le-mvp)
  - [D-012 : Chasse par équipe confirmée hors périmètre](#d-012--chasse-par-équipe-confirmée-hors-périmètre)
- [UX et Front](#ux-et-front)
- [Back et API](#back-et-api)
- [Données et sécurité](#données-et-sécurité)
  - [D-008 : Distinction suppression volontaire et bannissement](#d-008--distinction-suppression-volontaire-et-bannissement)
  - [D-013 : Retrait du journal des actions sensibles](#d-013--retrait-du-journal-des-actions-sensibles)
- [Qualité, CI/CD et documentation](#qualité-cicd-et-documentation)

## Mode d'emploi

- **Quand ajouter une entrée** : dès qu'un choix touche le périmètre, l'architecture, la sécurité, la stack ou une règle métier, ou qu'on écarte une option sérieuse.
- **Où la ranger** : sous le domaine concerné (pilotage et produit, UX et Front, Back et API, données et sécurité, qualité et CI/CD). Chaque domaine rappelle son référent et son suppléant.
- **Une décision, une entrée** : on ne réécrit pas une ancienne entrée. Si on change d'avis, on ajoute une nouvelle entrée et on indique dans l'ancienne qu'elle est remplacée, avec le numéro de la nouvelle.
- **Qui décide** : les décisions qui touchent le périmètre se prennent en équipe ; le référent du domaine approuve les décisions techniques de son domaine.

## Modèle d'entrée

Chaque entrée suit le même plan : **Contexte** (le problème), **Options** considérées avec leurs avantages et inconvénients, **Décision** (la décision prise), **Raison** (pourquoi cette décision), **Conséquences** (ce que cela change, ce que cela coûte), **Revoir si** (la condition qui rouvrirait le sujet).

## Pilotage et produit

**Référent** : Elias · **Suppléant** : Mathéo. Périmètre, parcours utilisateur et règles produit.

### D-001 · Périmètre du MVP : MoSCoW et renoncements

- **Contexte** : la vision du client (cartes, géolocalisation, réalité augmentée, partenaires, marketplace) dépasse ce que cinq personnes peuvent livrer sur l'année.
- **Options** :
  - 1 : Viser trop large et livrer peu de choses abouties
  - 2 : Viser la boucle créer, jouer, suivre, avec peu de fonctions mais testées et sécurisées puis en ajouter d'autres en fonction du temps restant
- **Décision** : Option 2.
- **Raison** : Il est plus simple d'avoir un périmètre restreint mais s'assurer du bon fonctionnement, des performances et de la sécurité plutôt qu'un large périmètre avec un fonctionnement partiel.
- **Conséquences** : Prototype sobre, sans dépendance à un service externe payant, et démonstration reproductible mais moins intéressant fonctionnellement et visuellement.
- **Revoir si** : un cas d'usage clair apparaît,  la validation sur le terrain devient prioritaire ou si tous les Must sont terminés.

### D-002 · Rôle par chasse plutôt que rôle global

- **Contexte** : la note de cadrage v1.0 prévoyait un rôle choisi à l'inscription. Cela oblige à deux comptes pour qui veut jouer et organiser, et empêche quiconque de s'inscrire sans jouer ni organiser. Le sujet du client ne parle que de « un utilisateur crée son compte et se connecte ».
- **Options** :
  - 1 : Rôle par compte, choisi à l'inscription
  - 2 : Rôle par chasse, le créateur en est l'Organisateur et celui qui la rejoint en est Joueur
  - 3 : Compte unique avec un mode Organisateur à activer.
- **Décision** : Option 2
- **Raison** : L'option 2 permet à tout le monde de créer et de rejoindre des chasses.
- **Conséquences** : pas de rôle global, les droits se déduisent de qui a créé la chasse et de qui la joue.  Tout utilisateur peut publier sans modération.
- **Revoir si** : un besoin de modération ou de rôle Partenaire apparaît, ou si un contrôle par rôle global s'avère nécessaire.

### D-003 · Un Organisateur ne peut pas rejoindre sa propre chasse

- **Contexte** : avec le rôle par chasse, un Organisateur pourrait aussi jouer sa chasse et la terminer.
- **Options** :
  - 1 : L'interdire
  - 2 : L'autoriser sans distinction
  - 3 : L'autoriser en mode essai, sans résultat enregistré.
- **Décision** : Option 1 pour le MVP, par simplicité et pour garder des résultats fiables. À valider en équipe.
- **Conséquences** : la tentative est refusée (scénario de démonstration, étape 8). L'Organisateur ne peut pas tester sa chasse avant publication, ce qui reste une question ouverte.
- **Revoir si** : les organisateurs ont besoin de tester leur chasse (option 3).

### D-004 · Suppression de compte en cascade, classée Must (06/10/2026)

- **Contexte** : la note de cadrage ne prévoit pas de suppression de compte (seule la « gestion du profil » y figure, en Should). Or un compte est lié à des chasses créées et à des participations, et le droit à l'effacement (RGPD) est attendu.
- **Options** :
  - 1 : Pas de suppression dans le MVP, documentée comme limite
  - 2 : Suppression du compte seul, en conservant ou en anonymisant ses chasses et participations
  - 3 : Suppression en cascade : les chasses créées et les participations sont supprimées avec le compte.
- **Décision** : Option 3, classée Must. Choisie lors de la rédaction du cahier des charges ; à confirmer en équipe.
- **Conséquences** : une user story (US-1.4) et une règle métier (RM11) de plus, et une étape de plus dans la démonstration. Effet à connaître : les joueurs d'une chasse perdent leur progression et leur badge si son Organisateur supprime son compte. Ajouter un Must augmente la charge du jalon 3 (risque R1) : c'est un changement de périmètre par rapport à la note v1.0, à reporter dans la v1.1.
- **Revoir si** : la perte des résultats des joueurs est jugée inacceptable (option 2, avec anonymisation), ou si le périmètre devient trop lourd (retour en Should).
- **Remplacée par** : D-008, qui distingue suppression volontaire et bannissement et assouplit la conséquence pour les joueurs engagés.

### D-005 · Mode essai pour l'Organisateur avant publication

- **Contexte** : D-003 laissait ouverte la question de savoir si l'Organisateur, ne pouvant rejoindre sa propre chasse, pouvait au moins la tester avant de la publier.
- **Options** :
  - 1 : Aucun moyen de tester avant publication
  - 2 : Mode essai sans participation ni résultat enregistré
  - 3 : Autoriser à rejoindre sa propre chasse comme un Joueur normal.
- **Décision** : Option 2.
- **Raison** : permet à l'Organisateur de vérifier sa chasse sans fausser les statistiques de participation (RM2 reste inchangée : il ne peut toujours pas devenir Joueur de sa propre chasse).
- **Conséquences** : ajout de RM13 et de la user story US-3.5.
- **Revoir si** : le besoin d'un retour plus riche (ex : partagé avec un tiers pour relecture) apparaît.

### D-006 · Confirmation d'e-mail et mot de passe oublié dans le MVP

- **Contexte** : la version 0.2 renvoyait ce point hors MVP, à confirmer.
- **Options** :
  - 1 : Hors MVP
  - 2 : Dans le MVP.
- **Décision** : Option 2.
- **Raison** : fonctions de sécurité et de récupération de compte jugées nécessaires dès le MVP.
- **Conséquences** : ajout des user stories US-1.5 et US-1.6, passage de ces fonctions en Must (M1).
- **Revoir si** : la charge du jalon 3 devient trop importante (retour en Should, risque R1).

### D-007 · Modération, rôle Admin et bannissement

- **Contexte** : la version 0.2 ne prévoyait ni signalement ni administrateur, limite assumée en D-002. Le besoin d'un minimum de modération a été confirmé.
- **Options** :
  - 1 : Aucune modération
  - 2 : Signalement journalisé, traité manuellement hors application, sans interface ni rôle dédiés
  - 3 : Signalement avec interface d'administration et rôle Admin créé en plus du rôle par chasse.
- **Décision** : Option 3.
- **Raison** : le traitement des signalements nécessite de distinguer qui peut les consulter et bannir un compte ; un simple traitement manuel hors application ne suffit pas à sécuriser cette action.
- **Conséquences** : introduction d'un type de compte (Utilisateur standard ou Admin) en plus du rôle par chasse (Organisateur ou Joueur). Nouveau module M7 (US-7.1 à US-7.3) ; nouvelles règles RM12 (bannissement). La limite assumée de D-002 sur l'absence de modération est levée pour le signalement et le bannissement, mais pas pour une administration complète (tableau de bord global), qui reste hors périmètre. Charge supplémentaire pour le jalon 3 (risque R1).
- **Revoir si** : le besoin d'une administration plus large (gestion fine des comptes, modération préalable à la publication) apparaît.

### D-009 · Chasses privées accessibles par lien ou code

- **Contexte** : la version 0.2 posait la question d'une chasse non listée publiquement, accessible seulement par lien ou code d'invitation.
- **Options** :
  - 1 : Toutes les chasses publiées sont publiques
  - 2 : L'Organisateur choisit de publier en privé, accès par lien ou code.
- **Décision** : Option 2, classée Should (après MVP).
- **Raison** : fonction utile mais non nécessaire au scénario de référence (section 3.1), qui ne mentionne que des chasses publiques.
- **Conséquences** : ajout de RM14 et de la user story US-3.6 ; US-2.1 et US-4.1 précisent l'exclusion des chasses privées de la liste publique et l'accès par lien ou code.
- **Revoir si** : le client en fait une priorité du scénario de démonstration.

### D-010 · Date de fermeture optionnelle d'une chasse

- **Contexte** : la version 0.2 posait la question d'une date de fermeture choisie par l'Organisateur.
- **Options** :
  - 1 : Aucune date de fermeture
  - 2 : Date de fermeture optionnelle, fermée aux nouveaux joueurs mais les participations en cours peuvent être terminées
  - 3 : Date de fermeture optionnelle, totalement fermée dès son passage, y compris pour les participations en cours.
- **Décision** : Option 2, classée Should (après MVP).
- **Raison** : Cohérence avec la règle retenue pour la suppression volontaire de compte (D-008) pour ne jamais couper une progression en cours.
- **Conséquences** : ajout de RM15 et de la user story US-3.7. US-2.1 et US-4.1 précisent l'exclusion des chasses fermées de la liste et des nouvelles participations.
- **Revoir si** : le besoin d'une fermeture stricte (option 3) apparaît.

### D-011 · Langue de l'interface, français seul pour le MVP

- **Contexte** : la version 0.2 posait la question de la langue de l'interface.
- **Options** :
  - 1 : Français seul
  - 2 : Interface multilingue dès le MVP.
- **Décision** : Option 1.
- **Raison** : simplicité, aucun besoin identifié d'internationalisation pour la démonstration.
- **Conséquences** : le multilinguisme est ajouté aux renoncements (section 1.3).
- **Revoir si** : un besoin international est identifié.

### D-012 · Chasse par équipe confirmée hors périmètre

- **Contexte** : la version 0.2 posait la question de chasses par équipe.
- **Options** :
  - 1 : Chasses par équipe dans le MVP
  - 2 : Hors MVP.
- **Décision** : Option 2.
- **Raison** : complexité de la progression partagée entre plusieurs joueurs, non nécessaire au scénario de référence.
- **Conséquences** : ajout aux renoncements (section 1.3), réexamen possible après le MVP.
- **Revoir si** : un besoin confirmé apparaît après le MVP.

## UX et Front

**Référent** : Alexis C. · **Suppléant** : Arthur. Parcours, écrans, accessibilité.

Aucune décision enregistrée pour l'instant.

## Back et API

**Référent** : Alexis B. · **Suppléant** : Alexis C. Règles métier et API.

Aucune décision enregistrée pour l'instant.

## Données et sécurité

**Référent** : Arthur · **Suppléant** : Alexis B. Droits d'accès et données personnelles (RGPD).

### D-008 · Distinction suppression volontaire et bannissement

- **Contexte** : D-004 traitait toute suppression de compte de la même façon (cascade complète, y compris les participations en cours des autres joueurs). Deux cas distincts sont apparus : la suppression volontaire par l'Organisateur lui-même, et le bannissement d'un compte par un Admin (voir D-007). La version 0.2 posait aussi la question de l'anonymisation du journal des actions sensibles après suppression.
- **Options pour la cascade** :
  - 1 : Traiter les deux cas de la même façon (D-004)
  - 2 : Distinguer suppression volontaire (participations en cours préservées, données personnelles supprimées, identifiant non personnel conservé sur les chasses encore jouées) et bannissement (suppression totale et immédiate, y compris des participations en cours).
- **Options pour le journal** :
  - 1 : Conserver toutes les entrées telles quelles
  - 2 : Anonymiser l'acteur dans les entrées existantes
  - 3 : Supprimer les entrées du compte concerné.
- **Décision** : cascade, option 2 - journal, option 2 (anonymisation) pour une suppression volontaire et option 3 (suppression) pour un bannissement.
- **Raison** : une suppression volontaire ne doit pas priver les autres joueurs d'une progression en cours. Un bannissement, motivé par une faute, justifie une suppression totale. Pour le journal, l'anonymisation garde une trace de l'activité (fréquence, résultats) sans donnée personnelle, sauf en cas de bannissement où rien n'est conservé.
- **Conséquences** : RM11 est réécrite, RM12 est ajoutée pour le bannissement, TR-3 est ajoutée pour le traitement du journal. US-1.4 et le scénario de démonstration (étape 9) sont mis à jour. Un e-mail est envoyé aux joueurs dont la participation en cours est supprimée par un bannissement (voir D-007).
- **Revoir si** : la conservation d'un identifiant non personnel sur les chasses d'un compte supprimé pose un problème technique ou RGPD imprévu.

### D-013 · Retrait du journal des actions sensibles

- **Contexte** : D-007 et TR-1 (v1.2) introduisaient un journal dédié pour tracer inscription, connexion, publication, inscription à une chasse, validation d'étape, refus d'autorisation, signalement et bannissement. Le journal ajoutait une table, des énumérations dédiées et une logique applicative (service d'écriture, anonymisation de l'acteur à la suppression ou au bannissement, TR-3) pour un bénéfice limité dans le cadre d'un MVP sans administration complète.
- **Options** :
  - 1 : Garder le journal tel que décrit en v1.2
  - 2 : Retirer le journal et s'appuyer sur du logging applicatif classique (fichiers ou sortie standard, via le framework retenu), sans table dédiée ni exigence métier.
- **Décision** : Option 2.
- **Raison** : le journal n'apporte pas une plus-value suffisante pour la démonstration du MVP par rapport à la complexité qu'il ajoute (table, énumérations, service dédié, anonymisation de l'acteur). Un logging applicatif classique suffit à couvrir le besoin de traçabilité en cas d'erreur.
- **Conséquences** : suppression de la table `audit_logs` et des énumérations `audit_action`, `audit_resource_type`, `audit_result` du modèle de données et de `schema.sql`. Suppression de TR-1 et TR-3 du cahier des charges. TR-2 renumérotée TR-1. Retrait des mentions de journalisation dans US-3.3, US-7.1, US-7.3, RM12, la section 5.1 est remplacée par une mention de logging classique, la section 5.4 et la Definition of Done (7.6). Le périmètre MoSCoW (1.2) perd la ligne « Journalisation des actions sensibles ». Les entrées de signalement (`reports`) et les champs d'anonymisation des comptes (`users.status`) suffisent à tracer qui a signalé quoi et qui a été banni, sans table de journal dédiée.
- **Revoir si** : un besoin d'audit métier avec preuve d'une action précise apparaît après le MVP.

## Qualité, CI/CD et documentation

**Référent** : Mathéo · **Suppléant** : Elias. Tests, intégration continue, reproductibilité, documentation.

Aucune décision enregistrée pour l'instant.
