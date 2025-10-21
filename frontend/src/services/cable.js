import { createConsumer } from '@rails/actioncable';

// Detecta automaticamente a URL baseado no ambiente atual
const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
const host = window.location.host;
const defaultUrl = `${protocol}//${host}/cable`;

const url = process.env.VUE_APP_CABLE_URL || defaultUrl;

console.log('[ActionCable] Connecting to:', url);
const cable = createConsumer(url);

export default cable;