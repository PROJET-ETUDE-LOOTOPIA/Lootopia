import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';
import { App } from './App';
import './index.css';

// Point d'entree de l'application : monte le composant App dans l'element #root de index.html.
const container = document.getElementById('root');
if (!container) {
  throw new Error("Element #root introuvable dans index.html");
}

createRoot(container).render(
  <StrictMode>
    <App />
  </StrictMode>,
);
