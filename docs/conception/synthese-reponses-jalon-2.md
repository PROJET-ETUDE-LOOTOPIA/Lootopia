# Synthèse des réponses du jalon 2 - Lootopia

| | |
| --- | --- |
| **Document** | Synthèse des réponses aux questions du jalon 2, Lootopia (MVP) |
| **Version** | 0.1 (brouillon) |
| **Date** | 26/10/2026 |
| **Statut** | À relire et valider par l'équipe |
| **Source** | Réponses collectives de l'équipe du 26/10/2026 à la liste de questions du jalon 2 |
| **Documents liés** | [Cahier des charges](../cadrage/cahier-des-charges.md), [Journal des décisions](../cadrage/journal-des-decisions.md), [Analyse des risques](../cadrage/analyse-des-risques.md), [Politique d'usage de l'IA](../cadrage/politique-IA.md), [Modèle de données](modele-de-donnees.md), [Maquettes](maquettes.md) |

Ce document reprend les réponses de l'équipe, dans l'ordre des questions (Q1 à Q26), et signale ce qu'elles changent dans le cahier des charges v1.1. Il distingue ce que l'équipe a décidé de ce que Claude a proposé pour compléter. Rien ici n'est une décision tant que l'équipe ne l'a pas validée.

Mise à jour de 15h55 le 26/10/2026 : l'équipe a répondu aux points P1 à P5. Leurs réponses sont intégrées ci-dessous (Q5, Q6, Q15, Q21 et section 2). Le cahier des charges a ensuite été mis à jour en version 1.2 (proposition rédigée avec Claude, à relire par l'équipe). La section 4 liste ce qui reste à reporter dans les autres documents : analyse des risques et journal des décisions.

Déclaration d'usage de l'IA (politique d'usage de l'IA, principe 5) : synthèse rédigée avec l'aide de Claude (Anthropic) à partir des réponses de l'équipe. Ce document n'est pas le journal des décisions : la gestion de projet et le journal sont tenus par l'équipe seule. Les sections 1 et 2 fournissent la matière, chaque entrée du journal (à partir de D-013) est à rédiger par l'équipe.

## 1. Décisions de l'équipe

### 1.1 Services externes et hébergement

| Q | Question | Décision | Raison donnée | À reporter |
| --- | --- | --- | --- | --- |
| Q1 | Connexion Google | **Oui.** | Aucune raison consignée. | Service externe à justifier en 5.3 et 8.2 du cahier. Aucune solution de remplacement nécessaire : la connexion par e-mail et mot de passe reste disponible. Mise à jour de R8. Les identifiants OAuth Google ne sont jamais fournis à l'IA (politique IA, section 3). |
| Q2 | Envoi des e-mails (confirmation, mot de passe oublié, prévenance de fermeture, bannissement) | **Mailjet** (mailjet.com). | Solution gratuite qui fournit un service déjà hébergé, contrairement à une solution locale. Selon l'équipe, la solution gère la sécurité de l'envoi et est hébergée dans l'UE. Le fournisseur voit le contenu des e-mails, donc les jetons (liens de confirmation et de réinitialisation) doivent être à usage unique et de courte durée. | Voir les conditions de mise en oeuvre ci-dessous. Mise à jour de 5.3, 8.2 et R8. D'autres solutions gratuites existent selon l'équipe : en nommer une comme solution de remplacement dans la justification. |
| Q3 | Hébergement | **Solution gratuite ou locale de type Docker**, facile à déployer n'importe où, dans le cadre du MVP. | Facilité de déploiement. | À consigner au journal. L'hébergeur éventuel de l'instance de démonstration n'est pas désigné. |

Conditions de mise en oeuvre de Mailjet retenues par l'équipe :

- Clé API stockée dans une variable d'environnement ou un gestionnaire de secrets, jamais dans le code ni côté front. Prévoir sa rotation et des permissions minimales (envoi uniquement).
- Suivi des clics et des ouvertures désactivé sur les e-mails transactionnels. Sinon les liens passent par un domaine de redirection du fournisseur, ce qui expose le jeton dans ses journaux et peut casser le lien ou le faire classer comme suspect.
- Authentification à deux facteurs activée sur le compte Mailjet, restriction par adresse IP si possible.
- Jetons à usage unique et à durée de vie limitée, pour réduire l'impact du fait que le fournisseur voit les e-mails.

Limites de l'offre gratuite, à inscrire dans la justification exigée par le cahier (5.3 et 8.2) : 200 e-mails par jour et 6 000 par mois. Au-delà de 200 par jour, les messages sont retenus et envoyés le lendemain, puis supprimés au bout de trois jours (source : [documentation Mailjet](https://documentation.mailjet.com/hc/en-us/articles/360043048393-What-is-this-200-emails-per-day-limit-on-free-accounts), consultée le 26/10/2026). Ces valeurs sont à revérifier avant la démonstration.

### 1.2 Règles métier

| Q | Question | Décision | Raison donnée | À reporter |
| --- | --- | --- | --- | --- |
| Q4 | Rejouer une chasse terminée | **Non.** Une chasse ne peut être jouée qu'une seule fois par un même joueur. | Aucune raison consignée. | RM2 et US-4.1 : contrainte d'unicité sur le couple (chasse, joueur), quel que soit le statut de la participation. |
| Q5 | Chasse d'un compte supprimé (RM11) | Réponse de 15h55 : la chasse est **gardée et reste ouverte jusqu'à ce que tous les joueurs en cours l'aient terminée**, puis elle se ferme. Elle affiche « compte supprimé » à la place de l'organisateur, n'est plus suivie et n'est pas rattachée à un Admin. Les joueurs concernés sont **prévenus par e-mail** de sa future fermeture. | Le rôle d'un Admin n'est pas de reprendre une chasse. Choix assumé. | RM11, US-1.4, étape 9 de la démonstration, 5.4. Nouvel e-mail transactionnel envoyé via Mailjet. Voir P9. |
| Q6 | Contenu de l'entrée de journal au bannissement | Format de ligne : **horodatage, acteur, action, ressource, résultat**. Pour un bannissement, l'**identifiant du compte concerné** est visible. Réponse de 15h55 : le compte est conservé avec un statut « banni », ses **données personnelles sont anonymisées**, ses **chasses et toutes leurs participations disparaissent**, ainsi que ses propres participations. | Aucune raison consignée. | RM12, US-7.3, TR-3, D-008. Le journal garde les entrées du compte banni, avec son identifiant non personnel. |
| Q8 | E-mail déjà utilisé à l'inscription | **Aucune erreur affichée**, seulement le message « un mail est envoyé ». | Ne donne aucune indication sur les e-mails existants. | US-1.1 (le critère « erreurs explicites par champ » ne s'applique plus à l'e-mail), 5.1. Voir le point à lever P4. |
| Q14 | Normalisation des réponses (RM9) | L'équipe n'a pas d'avis : **choisir une normalisation classique**. | Aucune. | Voir la proposition de Claude en section 3. |
| Q15 | Temps total | Le serveur mesure **le temps pendant lequel le joueur est en train de réaliser la chasse**, avec un compteur mis à jour pendant qu'il joue. | Aucune raison consignée. | RM7, US-5.2. L'intervalle de mise à jour et le seuil d'inactivité restent à choisir (technique). |
| Q16 | Limitation des essais de réponse | **Limiteur de débit en place**, valeurs décidées plus tard. | Aucune. | Valeurs à fixer avant la construction. |
| Q17 | Fuseau horaire de la date de fermeture | **Paris, UTC+1.** | Aucune raison consignée. | RM15, US-3.7. Voir la précision en section 3. |
| Q18 | Format du code d'invitation | **6 caractères en majuscules, chiffres et lettres.** | Aucune raison consignée. | RM14, US-3.6. |

### 1.3 Accès et erreurs

| Q | Question | Décision | Raison donnée | À reporter |
| --- | --- | --- | --- | --- |
| Q7 | 403 ou 404 sur la ressource d'autrui | **403.** | C'est ce que signifie l'erreur « Forbidden ». | Matrice 2.1 (la mention « 404 ou 403 » devient « 403 »), lignes de test d'autorisation. |

Conséquence à connaître : un brouillon appartenant à un autre utilisateur répond 403, donc son existence est révélée à qui en connaît l'identifiant. Des identifiants non devinables (UUID) limitent cet effet, c'est le choix fait dans le [modèle de données](modele-de-donnees.md).

### 1.4 Stack et architecture

| Q | Question | Décision | Raison donnée | À reporter |
| --- | --- | --- | --- | --- |
| Q9 | Stack | **React, Node, TypeScript, API Express, PostgreSQL, Docker.** Pour le mobile : **PWA**. | Aucune raison consignée. | Journal des décisions. Contrainte 8.2 (« technique »). |
| Q10 | API REST | **Oui**, API REST avec Express, **documentée par Swagger** (OpenAPI). | Aucune raison consignée. | 5.5 (documentation de l'API). |
| Q11 | Où vivent les règles métier | Dans des **services côté serveur : une règle métier, un service.** | Aucune raison consignée. | 5.5 (un tiers retrouve où modifier une règle de progression). |
| Q12 | Lancement par `docker compose up` en moins de 15 minutes | **Oui**, partout. | Aucune raison consignée. | Critère de réussite « Reproductibilité » (section 6). |

Non encore décidé dans la stack : outil d'accès à la base et de migrations, session côté serveur ou jeton, bibliothèque de validation des entrées, outils de test. Ces choix sont à faire avant de lancer la construction.

### 1.5 Conception

| Q | Question | Décision | À reporter |
| --- | --- | --- | --- |
| Q13 | Diagrammes d'états de la chasse et de la participation | **Validés.** Ils ont été mis à jour pour tenir compte de Q5, Q6 et Q21 (voir [modèle de données](modele-de-donnees.md), section 4) : à revalider par l'équipe. | Documentation de conception. |
| Q19 | Coquilles du cahier | **Corrigées.** Vérifié sur la branche `develop` à la version 1.1 : tableau 1.2 (M2 et M3), renvoi RM12 de la ligne notifications, lien de `home.md`. | Aucun. |
| Q20 | Les neuf entités du modèle de données | **Acceptées pour l'instant.** Demande de générer le schéma de base de données. | Fait : voir [modele-de-donnees.md](modele-de-donnees.md) et [schema.sql](schema.sql). |
| Q21 | Deux services distincts pour la suppression volontaire et le bannissement | **On ne supprime pas un compte banni** : il reste en base avec un statut et des données anonymisées (voir Q6). Les deux services restent distincts, car leurs effets diffèrent. | RM12, US-7.3, TR-3. Voir le [modèle de données](modele-de-donnees.md), section 5. |
| Q23 | Aucune réponse d'API ne contient la réponse attendue d'une étape | **Oui.** | RM6, 5.1. Un test parcourt toutes les réponses de l'API. |
| Q24 à Q26 | Parcours, maquettes de l'écran de jeu en mobile d'abord, messages d'erreur | **Délégués à Claude** pour la génération des maquettes. | Fait : voir [maquettes.md](maquettes.md). Les maquettes sont des propositions : le référent UX les valide (politique IA, section 2). |

Q22 (liste des routes de l'API) : à voir plus tard.

## 2. Points à lever

Les réponses de l'équipe contredisaient ou laissaient ouverts plusieurs points du cahier v1.1. Les points P1 à P5 ont reçu une réponse à 15h55. L'équipe compte mettre ensuite le cahier à jour. Restent ouverts P6 à P9 et quelques précisions.

| Réf. | Point | Statut | Décision ou reste à faire |
| --- | --- | --- | --- |
| P1 | Contenu du bannissement | Levé | Identifiant du compte conservé dans le journal, chasses et participations supprimées, données personnelles anonymisées. Reste : l'e-mail aux joueurs dont la participation en cours est supprimée, prévu par RM12 et non repris dans la réponse, est maintenu dans le modèle sauf avis contraire. Conséquence à connaître : l'adresse n'étant plus conservée, la personne bannie peut se réinscrire avec la même. |
| P2 | Chasse après suppression du compte | Levé | Chasse gardée, ouverte jusqu'à ce que tous les joueurs en cours aient terminé, e-mail de prévenance. Hypothèse retenue, à confirmer : elle n'accepte pas de nouveaux joueurs pendant ce temps (RM11). Reste : voir P9. |
| P3 | Services externes et plan B | Levé | Google et Mailjet confirmés. Google : aucun plan B nécessaire, la connexion par e-mail et mot de passe existe. Mailjet : d'autres solutions gratuites existent, à nommer. Reste à réécrire 5.3, 8.2 et R8 dans le cahier et l'analyse des risques. |
| P4 | Inscription avec un e-mail existant | Accepté pour le MVP | Chaque tentative envoie un e-mail et l'offre gratuite de Mailjet est limitée à 200 e-mails par jour. L'équipe accepte ce risque pour le MVP. La limitation de débit (Q16) reste le moyen de le réduire. |
| P5 | Temps connecté à la chasse | Levé | Compteur mis à jour par le serveur pendant que le joueur joue. Reste : intervalle de mise à jour et seuil d'inactivité. |
| P6 | Connexion Google et compte existant | Ouvert | US-1.1 ne dit pas ce qui arrive si l'adresse Google correspond à un compte créé par mot de passe. Fusionner ou refuser ? Un compte Google est-il considéré comme confirmé ? |
| P7 | Pseudo | Ouvert | Le cahier ne dit pas si le pseudo est unique. Avec Q8, un pseudo unique réintroduirait une erreur explicite. Pseudo unique ou non ? |
| P8 | Hébergement de la démonstration | Ouvert | Q3 retient Docker, mais pas où l'instance de démonstration tourne pour l'évaluateur. À consigner avant la fin du jalon 2, l'hébergement faisant partie de sa sortie. |
| P9 | Durée d'une chasse en fermeture | Nouveau, ouvert | « Ouverte jusqu'à ce que tous les joueurs aient terminé » n'a pas de limite : un joueur qui ne revient jamais garde la chasse ouverte indéfiniment. Faut-il une durée maximale ? Que dit l'e-mail de prévenance (date de fermeture, ou simple avertissement) ? |

Coquilles restantes relevées dans `docs/cadrage/raci.md` : « nécessairements » et « disposinibiltés ».

## 3. Propositions de Claude à valider

Ces points n'ont pas été décidés par l'équipe. Ils comblent un vide laissé par une réponse et sont à valider ou à remplacer.

- **Normalisation RM9 (Q14)** : décomposition Unicode (NFD), retrait des signes diacritiques, passage en minuscules, suppression des espaces en début et fin, remplacement des suites d'espaces par un seul espace. La réponse normalisée est calculée à l'écriture de l'étape, la réponse saisie est normalisée de la même façon avant comparaison.
- **Fuseau (Q17)** : stocker toutes les dates en UTC et interpréter la date de fermeture dans le fuseau `Europe/Paris`. Paris n'est en UTC+1 que l'hiver (UTC+2 l'été), donc « UTC+1 » seul décalerait la fermeture d'une heure du dernier dimanche de mars au dernier dimanche d'octobre.
- **Code d'invitation (Q18)** : exclure les caractères ambigus (0 et O, 1 et I) est possible sans changer le format. Un limiteur de débit sur la saisie des codes est nécessaire, puisque 6 caractères alphanumériques se devinent plus vite qu'un identifiant.
- **E-mails en développement et en CI** : un serveur SMTP de test local dans le `docker compose`, pour ne jamais envoyer de vrai e-mail ni utiliser la clé Mailjet hors démonstration. C'est aussi un plan B candidat pour P3.
- **Modèle de données** : aucune suppression physique des comptes. Un compte supprimé ou banni reste en base avec un statut, un identifiant non personnel et plus aucune donnée personnelle. Les chasses d'un compte supprimé restent attachées à ce compte, ce qui permet d'afficher « compte supprimé » (Q5). Détails dans [modele-de-donnees.md](modele-de-donnees.md).
- **Chasse en fermeture (Q5)** : un statut `closing` entre `published` et `closed`. La chasse passe à `closed` quand sa dernière participation en cours se termine ou est supprimée, ou tout de suite s'il n'y en a aucune. Les brouillons d'un compte supprimé sont supprimés avec lui, personne d'autre ne les voyant.
- **E-mail de prévenance** : envoyé une seule fois par joueur concerné (date d'envoi stockée), après la suppression du compte. Texte proposé dans [maquettes.md](maquettes.md).
- **Maquettes** : voir le dossier des maquettes, à valider par le référent UX et à contrôler en accessibilité (WCAG 2.1 AA).

## 4. Modifications à reporter dans les autres documents

À faire par l'équipe, après validation de cette synthèse.

| Document | Passage | Modification |
| --- | --- | --- |
| Cahier des charges | US-1.1 | Message neutre à l'inscription (Q8). Connexion Google confirmée (Q1), cas du compte existant à préciser (P6). |
| Cahier des charges | RM2, US-4.1 | Une chasse ne se joue qu'une fois par joueur (Q4). |
| Cahier des charges | RM11, US-1.4, étape 9 de la démonstration, 5.4 | Chasse gardée ouverte jusqu'à la fin des participations en cours, puis fermée, avec libellé « compte supprimé » et e-mail de prévenance (Q5, P2, P9). |
| Cahier des charges | RM12, US-7.3, TR-3, 5.4 | Statut « banni » et données anonymisées, chasses et participations supprimées, entrées du journal conservées avec l'identifiant du compte (Q6, Q21). Le cahier dit aujourd'hui qu'aucune donnée n'est conservée, journal compris. |
| Cahier des charges | Matrice 2.1 | Un seul code d'erreur, 403 (Q7). |
| Cahier des charges | RM7, US-5.2 | Temps total : temps passé à réaliser la chasse, compteur mis à jour par le serveur (Q15, P5). |
| Cahier des charges | RM9, RM14, RM15 | Normalisation (Q14), format du code (Q18), fuseau (Q17). |
| Cahier des charges | 5.3, 8.2 | Justification de Mailjet et de Google : coût, limites, solution de remplacement (Q1, Q2, P3). Google : pas de remplacement, la connexion par mot de passe existe. |
| Cahier des charges | 5.4 | Mailjet reçoit des adresses e-mail : à lister comme sous-traitant dans le registre RGPD. |
| Analyse des risques | R8 | Réécriture, puisque le MVP utilise deux services externes. Plan B de Mailjet : une autre solution gratuite à nommer. Risque de quota accepté pour le MVP (P4). |
| Journal des décisions | D-013 et suivants, et D-008 | Une entrée par décision significative : services externes, hébergement, rejeu, chasse en fermeture progressive à la suppression, bannissement par anonymisation, code 403, e-mail neutre, stack, API REST et Swagger, services métier, temps de jeu, fuseau, code d'invitation. D-008 est à réviser, puisque le bannissement ne supprime plus tout. À rédiger par l'équipe. |

## 5. Reste à traiter

Ces points de la liste du jalon 2 n'ont pas encore de réponse :

- Priorité 4 : liste des routes et format d'erreur commun (Q22), dont une route de mise à jour du compteur de temps de jeu (Q15).
- Priorité 5 : modélisation des parcours et validation des maquettes par le référent UX.
- Priorité 6 : backlog, benchmark de trois offres, vérification de la Definition of Ready.
- Priorité 7 : analyse de risques d'une page, registre RGPD (Mailjet y figure comme sous-traitant), création du compte Admin.
- Priorité 8 : modules critiques pour le seuil de couverture de 70 %, outils de test, matrice 2.1 en tests paramétrés, jeu de données de démonstration.
- Priorité 9 : journal à jour, cahier à jour, relecture par un tiers.
