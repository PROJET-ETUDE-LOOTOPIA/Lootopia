# Lootopia
Out of Cache souhaite étudier la faisabilité de Lootopia, une plateforme numérique dédiée à la création et à la participation à des chasses au trésor. L’ambition est de proposer une expérience mêlant jeu, géolocalisation, cartographie et gamification.

Toute la documentation du projet est centralisée dans le dossier `docs/`.

## Stack technique

| Couche | Technologie | Rôle |
| --- | --- | --- |
| Front-end | React | Interface web de la plateforme |
| Mobile | PWA | Application installable depuis le navigateur, sans application native |
| Back-end | Node.js | Environnement d'exécution du serveur |
| Langage | TypeScript | Langage du front-end et du back-end |
| API | Express (API REST) | Exposition des services métier au front-end |
| Base de données | PostgreSQL | Stockage des données |
| Conteneurisation | Docker | Lancement de l'ensemble du projet avec `docker compose up` |

Les justifications de ces choix sont détaillées dans [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).