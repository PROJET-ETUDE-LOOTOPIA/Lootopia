# Lootopia – Règles de l'étape « QCM »

## 1. Principe

Une étape de chasse prend la forme d'un QCM de 5 à 10 questions. Chaque question propose de 2 à 4 réponses. Le joueur répond aux questions les unes après les autres. À la fin, il découvre un bilan qui indique son nombre de bonnes réponses, puis l'écran de fin d'étape.

## 2. Règles générales de l'étape

### Questions et réponses

Une étape contient au minimum 5 questions et au maximum 10. Chaque question propose entre 2 et 4 réponses. L'ordre des réponses est toujours mélangé à chaque partie.

### Tentatives et progression

Le joueur dispose d'une seule tentative par question. Dès qu'il a répondu, la bonne réponse est révélée et il passe à la question suivante. La progression est linéaire, le joueur ne peut donc pas revenir à une question déjà traitée.

### Points

Le créateur fixe le nombre de points par question, de 0 à 100, avec une valeur par défaut de 20. Les points de l'étape correspondent au nombre de bonnes réponses multiplié par les points par question. Le total maximal d'une étape est donc de 1 000 points, soit 10 questions à 100 points.

### Absence de blocage

Aucune étape ne bloque le joueur. Une mauvaise réponse ou un temps écoulé rapporte 0 point, mais le joueur continue normalement.

## 3. Ce que renseigne le créateur

### 3.1 Les champs de l'étape

- La liste des questions est obligatoire et compte de 5 à 10 questions.
- Les points par question sont obligatoires, avec 20 points par défaut.
- Le chronomètre par question

### 3.2 Comportement de l'éditeur

Le créateur peut ajouter une question tant que l'étape en compte moins de 10. À 10 questions, le bouton d'ajout est désactivé et affiche le message « 10 questions : maximum atteint ».

Il peut réordonner les questions en les faisant glisser, et modifier une question en touchant sa ligne.

Si l'étape compte moins de 5 questions, le compteur passe en rouge et un message précise ce qu'il manque, par exemple « Il manque 1 question… ». Le bouton « Enregistrer l'étape » reste alors désactivé.

## 4. Chronomètre

La durée est identique pour toutes les questions de l'étape. Le créateur peut choisir 15 secondes, 30 secondes, 1 minute, ou une durée personnalisée comprise entre 10 secondes et 2 minutes.

Le décompte démarre à l'affichage de la question. Le serveur fait foi pour le temps, et le décompte affiché à l'écran n'est qu'une représentation. Quitter l'application ou perdre le réseau ne met donc pas le chronomètre en pause. La barre de temps et le décompte passent au rouge pendant les 5 dernières secondes.

Quand le temps est écoulé, la question rapporte 0 point, la bonne réponse est révélée et le joueur passe à la suite.

Le temps de l'étape, affiché en fin d'étape, correspond à la durée écoulée entre l'affichage de la première question et la validation de la dernière.
