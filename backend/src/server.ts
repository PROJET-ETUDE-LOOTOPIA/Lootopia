// Point de départ du serveur : c'est ce fichier qui est lancé par "npm run dev" ou "npm start".

import { createApp } from "./app";

const port = Number(process.env.PORT ?? 3000);

createApp().listen(port, () => {
  console.log(`API Lootopia démarrée sur http://localhost:${port}/api`);
});
