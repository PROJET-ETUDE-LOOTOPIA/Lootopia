# Backend Lootopia (API)

Le backend est le serveur qui fera le lien entre le site et la base de données.
Pour l'instant, c'est une base minimale qui sert seulement à vérifier que le projet se construit :
elle répond sur une unique adresse: `/api/health`.

## Lancer le serveur

1. Installer les outils dépendances : `npm install`
2. Démarrer le serveur : `npm run dev`
3. Ouvrir http://localhost:3000/api/health dans un navigateur : la page doit afficher `{"status":"ok"}`.

## Les commandes disponibles

| Commande | À quoi elle sert |
|---|---|
| `npm run dev` | Démarre le serveur pour le développement. |
| `npm run build` | Prépare la version finale du serveur dans le dossier `dist/`. |
| `npm start` | Démarre la version finale préparée par `npm run build`. |
| `npm test` | Lance les tests automatiques. |
