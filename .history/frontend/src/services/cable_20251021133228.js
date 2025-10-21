import { createConsumer } from '@rails/actioncable';

const url = process.env.VUE_APP_CABLE_URL || 'ws://localhost:3000/cable';
const cable = createConsumer(url);

export default cable;