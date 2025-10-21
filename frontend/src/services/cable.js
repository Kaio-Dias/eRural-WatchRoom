import { createConsumer } from '@rails/actioncable';

// Resolve a URL padrão adequada para produção e desenvolvimento
const defaultUrl = `${location.protocol === 'https:' ? 'wss' : 'ws'}://${location.host}/cable`;
const url = process.env.VUE_APP_CABLE_URL || defaultUrl;
const cable = createConsumer(url);

export default cable;
