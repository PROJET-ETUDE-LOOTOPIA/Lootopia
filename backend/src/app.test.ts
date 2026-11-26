// Test automatique : vérifie que l'API répond sur son adresse de contrôle.

import request from "supertest";
import { createApp } from "./app";

test("GET /api/health répond que le serveur fonctionne", async () => {
  const response = await request(createApp()).get("/api/health");
  expect(response.status).toBe(200);
  expect(response.body).toEqual({ status: "ok" });
});
