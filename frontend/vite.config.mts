import react from '@vitejs/plugin-react';
import { defineConfig } from 'vite';

// Réglages de Vite, l'outil qui fait tourner le site pendant le développement
// et qui prépare la version finale du site (npm run build).
// Extension .mts : Vite fonctionne en module ESM, alors que le reste du dossier est en CommonJS pour Jest.

// Adresse du serveur (backend) sur la machine du développeur.
// Elle peut être changée avec la variable API_PROXY_TARGET, par exemple si le serveur utilise un autre port.
const apiTarget = process.env.API_PROXY_TARGET ?? 'http://localhost:3000';

export default defineConfig({
  plugins: [react()],
  server: {
    // Pendant le développement, toute demande du site vers une adresse commençant par /api
    // est transmise au serveur. Le site peut donc toujours appeler "/api/...", sans connaître
    // l'adresse exacte du serveur : en production, c'est le serveur web qui fera ce relais.
    proxy: {
      '/api': apiTarget,
    },
  },
});
