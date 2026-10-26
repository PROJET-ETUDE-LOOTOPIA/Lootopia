# Maquettes des écrans - Lootopia

| | |
| --- | --- |
| **Document** | Maquettes des écrans essentiels, Lootopia (MVP) |
| **Version** | 0.1 (brouillon) |
| **Date** | 26/10/2026 |
| **Statut** | Proposition à valider par le référent UX (Alexis C.) |
| **Documents liés** | [Synthèse des réponses du jalon 2](synthese-reponses-jalon-2.md), [Cahier des charges](../cadrage/cahier-des-charges.md) |

Ce document accompagne les maquettes des écrans du scénario de référence. Les maquettes elles-mêmes sont une planche de dix artboards, avec l'écran de jeu en mobile d'abord (390 par 844) et les écrans de l'Organisateur et de l'Admin en version ordinateur. Pour les ajouter au dépôt, exporter la planche en PDF ou en images dans `docs/conception/maquettes/`.

Déclaration d'usage de l'IA : maquettes et textes d'interface générés avec l'aide de Claude (Anthropic). Selon la politique d'usage de l'IA, les écrans retenus sont validés par le référent UX et respectent WCAG 2.1 AA. Les maquettes sont des propositions : un écran n'est retenu qu'après validation de l'équipe.

## 1. Inventaire des écrans

Les quinze écrans du scénario sont couverts. Les états d'erreur et les cas limites sont montrés sur la même planche que leur écran.

| Artboard | Écrans et états | Acteur | Exigences |
| --- | --- | --- | --- |
| Visiteur | Connexion avec identifiants invalides, inscription, message après inscription, mot de passe oublié après envoi et lien expiré | Visiteur | US-1.1, US-1.2, US-1.5, US-1.6, Q1, Q8 |
| Liste des chasses | Liste paginée de 20, saisie d'un code d'invitation, liste vide, code incorrect | Utilisateur connecté | US-2.1, US-1.3, RM14, Q18 |
| Détail d'une chasse | Jamais jouée (Rejoindre), déjà terminée (Voir mon résultat), chasse en fermeture vue par un joueur en cours et par un autre utilisateur | Utilisateur connecté | US-2.2, US-4.1, RM11, RM15, Q4, Q5 |
| Écran de jeu et mode essai | Étape courante, mauvaise réponse, trop de tentatives, mode essai | Joueur, Organisateur | US-4.2, US-4.3, US-4.5, US-3.5, RM9, RM13, Q16 |
| Résultat et mes participations | Récapitulatif avec badge, liste de mes participations | Joueur | US-5.1, US-5.2, US-1.3 |
| Signalement et suppression de compte | Formulaire de signalement avec erreur, confirmation de suppression de compte avec chasses laissées ouvertes jusqu'à la fin des parties en cours | Utilisateur connecté | US-7.1, US-1.4, RM11 |
| Mes chasses | Liste de mes chasses avec statut, accès, participants | Organisateur | US-3.4, RM8 |
| Édition d'une chasse | Informations, visibilité et code, date de fermeture, étapes ordonnées, erreurs de validation | Organisateur | US-3.1, US-3.2, US-3.3, US-3.6, US-3.7, RM4, RM14, RM15 |
| Suivi des participants | Compteurs, filtre par statut, tableau des participants | Organisateur | US-6.1, US-6.2 |
| Signalements et bannissement | Liste des signalements, confirmation de bannissement | Admin | US-7.2, US-7.3, RM12, Q6 |

## 2. Catalogue des messages d'erreur proposés

À relire par l'équipe. Les messages ne révèlent aucune information technique et, pour la connexion, l'inscription et le mot de passe oublié, aucune information sur l'existence d'un compte (5.1, Q8).

| Contexte | Message proposé | Règle |
| --- | --- | --- |
| Connexion, identifiants invalides | E-mail ou mot de passe incorrect. | US-1.2 |
| Inscription, quelle que soit l'adresse | Un e-mail vient de vous être envoyé. Ouvrez-le pour continuer. | Q8 |
| Mot de passe oublié, quelle que soit l'adresse | Si un compte existe pour cette adresse, un e-mail vient d'être envoyé. | US-1.6 |
| Lien de confirmation ou de réinitialisation périmé | Ce lien a expiré ou a déjà été utilisé. Demandez-en un nouveau. | US-1.5, US-1.6 |
| Mauvaise réponse à une étape | Ce n'est pas la bonne réponse. Relisez la consigne et réessayez. | US-4.3 |
| Trop de tentatives | Trop de tentatives. Réessayez dans quelques instants. | Q16 |
| Code d'invitation incorrect | Code d'invitation incorrect. | RM14 |
| Chasse en fermeture, vue d'un joueur qui a une participation en cours | Cette chasse va fermer : son organisateur a supprimé son compte. Vous pouvez la terminer, mais elle n'accepte plus de nouveaux joueurs. | Q5 |
| Chasse en fermeture ou fermée, vue d'un autre utilisateur | Cette chasse n'accepte plus de nouveaux joueurs : son organisateur a supprimé son compte. | Q5 |
| Chasse déjà terminée | Vous avez déjà terminé cette chasse. Une chasse ne se joue qu'une seule fois. | Q4 |
| Publication refusée | Corrigez les erreurs signalées ci-dessous. Une chasse doit avoir un titre et au moins une étape complète. | RM4 |
| Titre invalide | Le titre doit contenir entre 3 et 100 caractères. | US-3.1 |
| Réponse attendue manquante | La réponse attendue est obligatoire. | US-3.2 |
| Signalement sans motif | Le motif est obligatoire. | US-7.1 |
| Accès refusé (403) | Vous n'avez pas accès à cette page. | Q7, matrice 2.1 |
| Session expirée | Votre session a expiré. Reconnectez-vous pour continuer. | US-1.2 |

Les deux derniers messages (403 et session expirée) sont à maquetter : ils n'ont pas d'écran dédié sur la planche.

## 3. E-mails proposés

Trois e-mails sont à rédiger. Les textes ci-dessous sont des propositions, à relire par l'équipe. Aucun ne contient de jeton : le lien de reprise ouvre la chasse après connexion. Le suivi des clics et des ouvertures reste désactivé (décision sur Mailjet).

**Prévenance de fermeture d'une chasse** (Q5), envoyé une fois à chaque joueur ayant une participation en cours quand l'organisateur supprime son compte :

- Objet : La chasse « [titre] » va fermer.
- Corps : Bonjour [pseudo], l'organisateur de la chasse « [titre] » a supprimé son compte. Vous pouvez terminer votre participation : la chasse reste ouverte pour vous, mais elle n'accepte plus de nouveaux joueurs et fermera quand tous les joueurs en cours l'auront terminée. [Date limite éventuelle : point P9.] Reprendre la chasse : [lien].

**Participation supprimée par un bannissement** (RM12, maintien à confirmer) :

- Objet : Votre participation à la chasse « [titre] » a été supprimée.
- Corps : Bonjour [pseudo], la chasse « [titre] » a été supprimée. Votre participation, votre progression et vos résultats sur cette chasse ne sont plus disponibles. Le motif du bannissement n'est pas communiqué.

**Inscription avec une adresse déjà utilisée** (Q8) : contenu à définir, par exemple une information indiquant qu'un compte existe déjà avec un lien vers la connexion et le mot de passe oublié.

## 4. Points d'accessibilité pris en compte

Niveau visé : WCAG 2.1 AA sur les écrans du scénario, Lighthouse accessibilité d'au moins 90 (5.2). Ces points sont dessinés dans les maquettes, ils restent à vérifier sur les écrans réels.

- Chaque champ a une étiquette visible reliée au champ. Les erreurs sont écrites en toutes lettres, avec le mot « Erreur » : la couleur ne porte jamais l'information seule.
- Une erreur de validation est annoncée aux lecteurs d'écran (`role="alert"`) et le champ concerné est marqué invalide. La saisie n'est pas effacée.
- Cibles tactiles d'au moins 44 pixels, boutons de 48 pixels sur l'écran de jeu.
- La progression d'une chasse est un indicateur de progression nommé (« Étape 2 sur 5 ») avec le texte en clair, pas seulement la barre.
- Les tableaux ont une légende masquée, des en-têtes de colonne et défilent horizontalement dans leur cadre sur un écran étroit.
- La navigation principale est identifiée, la page courante est signalée.
- Contrastes visés d'au moins 4,5 pour 1 sur le texte.

À contrôler lors de la construction : ordre de tabulation, gestion du focus après une erreur sur l'écran de jeu, annonces de lecteur d'écran réelles, comportement à 320 pixels de large.

## 5. Points encore ouverts dans les maquettes

Les passages entre crochets dans les maquettes renvoient à la [synthèse des réponses](synthese-reponses-jalon-2.md) :

- Chasse en fermeture : durée maximale et date éventuelle dans l'e-mail de prévenance (P9).
- Contenu de l'e-mail envoyé à une adresse déjà inscrite (Q8).
- Valeurs de la limitation des tentatives (Q16).
- Maintien de l'e-mail aux joueurs en cas de bannissement (RM12).

Autres points à décider :

- Écrans de confirmation d'e-mail (lien valide), de réinitialisation du mot de passe et de gestion du profil (Should hors MVP) : non maquettés.
- Version desktop du Joueur et version mobile de l'Organisateur : le cahier prévoit « surtout mobile » pour le Joueur et « surtout ordinateur, mobile possible » pour l'Organisateur. Les pages desktop sont fluides et s'empilent sur un écran étroit, sans maquette dédiée.
