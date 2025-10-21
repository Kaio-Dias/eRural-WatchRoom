import { createConsumer } from '@rails/actioncable';

// [AI Generated] Data: 21/10/2025
// Descrição: Conecta no backend Rails na porta 3000.
// Gerado por: Cursor AI
// AI_GENERATED_CODE_START
const url = process.env.VUE_APP_CABLE_URL || 'ws://localhost:3000/cable';
const cable = createConsumer(url);
// AI_GENERATED_CODE_END

export default cable;