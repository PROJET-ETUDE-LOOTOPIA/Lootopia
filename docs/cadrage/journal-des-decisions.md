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
- [UX et Front](#ux-et-front)
- [Back et API](#back-et-api)
- [Données et sécurité](#données-et-sécurité)
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
  - 1:  Rôle par compte, choisi à l'inscription
  - 2: Rôle par chasse, le créateur en est l'Organisateur et celui qui la rejoint en est Joueur
  - 3: Compte unique avec un mode Organisateur à activer.
- **Décision** : Option 2
- **Raison** : L'option 2 permet à tout le monde de créer et de rejoindre des chasses.
- **Conséquences** : pas de rôle global, les droits se déduisent de qui a créé la chasse et de qui la joue.  Tout utilisateur peut publier sans modération.
- **Revoir si** : un besoin de modération ou de rôle Partenaire apparaît, ou si un contrôle par rôle global s'avère nécessaire.

### D-003 · Un Organisateur ne peut pas rejoindre sa propre chasse

- **Contexte** : avec le rôle par chasse, un Organisateur pourrait aussi jouer sa chasse et la terminer.
- **Options** :
  - 1: L'interdire
  - L'autoriser sans distinction
  - L'autoriser en mode essai, sans résultat enregistré.
- **Décision** : option (a) pour le MVP, par simplicité et pour garder des résultats fiables. À valider en équipe.
- **Conséquences** : la tentative est refusée (scénario de démonstration, étape 8). L'Organisateur ne peut pas tester sa chasse avant publication, ce qui reste une question ouverte.
- **Revoir si** : les organisateurs ont besoin de tester leur chasse (option c).

### D-004 · Suppression de compte en cascade, classée Must (06/10/2026)

- **Contexte** : la note de cadrage ne prévoit pas de suppression de compte (seule la « gestion du profil » y figure, en Should). Or un compte est lié à des chasses créées et à des participations, et le droit à l'effacement (RGPD) est attendu.
- **Options** : (a) pas de suppression dans le MVP, documentée comme limite ; (b) suppression du compte seul, en conservant ou en anonymisant ses chasses et participations ; (c) suppression en cascade : les chasses créées et les participations sont supprimées avec le compte.
- **Décision** : option (c), classée Must. Choisie lors de la rédaction du cahier des charges ; à confirmer en équipe.
- **Conséquences** : une user story (US-1.4) et une règle métier (RM11) de plus, et une étape de plus dans la démonstration. Effet à connaître : les joueurs d'une chasse perdent leur progression et leur badge si son Organisateur supprime son compte. Ajouter un Must augmente la charge du jalon 3 (risque R1) : c'est un changement de périmètre par rapport à la note v1.0, à reporter dans la v1.1.
- **Revoir si** : la perte des résultats des joueurs est jugée inacceptable (option b, avec anonymisation), ou si le périmètre devient trop lourd (retour en Should).

## UX et Front

**Référent** : Alexis C. · **Suppléant** : Arthur. Parcours, écrans, accessibilité.

Aucune décision enregistrée pour l'instant.

## Back et API

**Référent** : Alexis B. · **Suppléant** : Alexis C. Règles métier et API.

Aucune décision enregistrée pour l'instant.

## Données et sécurité

**Référent** : Arthur · **Suppléant** : Alexis B. Droits d'accès et données personnelles (RGPD).

Aucune décision enregistrée pour l'instant.

## Qualité, CI/CD et documentation

**Référent** : Mathéo · **Suppléant** : Elias. Tests, intégration continue, reproductibilité, documentation.

Aucune décision enregistrée pour l'instant.
