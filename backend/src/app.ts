// Assemblage de l'API : une application Express avec, pour l'instant, une seule adresse
// Les vraies adresses de l'API seront ajoutées ici plus tard.

import express, { type Express } from "express";

/**
 * Crée l'application Express.
 * @returns L'application prête à recevoir des demandes.
 */
export function createApp(): Express {
  const app = express();

  // Adresse de contrôle : répond "ok" pour vérifier que le serveur est allumé.
  app.get("/api/health", (_request, response) => {
    response.json({ status: "ok" });
  });

  return app;
}
