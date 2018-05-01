const sensorGraph = sensor => document.querySelector(`#${sensor.slug}-graph`);

const sensorUpdate = (sensor, val) => {
  console.log(`${sensor.name}`);
  console.log(val);

  const points = sensorGraph(sensor).querySelector('.points');
  const newPoint = document.createElement('p');
  newPoint.innerHTML = JSON.stringify(val);

  points.insertBefore(newPoint, points.firstChild);
};

const registerChannelUpdates = (socket, sensor) => {
  const channel = socket.channel(`sensor:${sensor.slug}`);

  channel.on('new_point', payload => sensorUpdate(sensor, payload));
  channel
    .join()
    .receive('ok', () => console.log(`${sensor.name} joined`))
    .receive('error', () => console.error(`${sensor.name} failed to join`));
};

export const handleSensor = (socket, sensor) => {
  registerChannelUpdates(socket, sensor);
};
