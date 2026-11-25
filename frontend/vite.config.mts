import react from '@vitejs/plugin-react';
import { defineConfig } from 'vite';

// Configuration de Vite pour l'application React.
// Extension .mts : Vite est un module ESM, alors que le package est en CommonJS pour Jest.
export default defineConfig({
  plugins: [react()],
});
