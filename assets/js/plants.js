import { Socket } from './phoenix.js';
import { handleSensor } from './sensor.js';

const socket = new Socket('/socket', { params: { token: 'test' } });

socket.connect();

console.log(window.sensors);
window.sensors.forEach(sensor => {
  handleSensor(socket, sensor);
});
