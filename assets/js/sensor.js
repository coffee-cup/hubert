import Plotly from 'plotly.js/lib/core';

const sensorGraphParent = sensor =>
  document.querySelector(`#${sensor.slug}-graph`);
const sensorGraph = sensor => sensorGraphParent(sensor).querySelector('.graph');

const createGraph = sensor => {
  const x = sensor.points.map(p => p.date);
  const y = sensor.points.map(p => p.value);
  const data = [{ x, y, type: 'scatter' }];

  const m = 4;
  const layout = {
    autosize: true,
    yaxis: { range: [0, 100] }
  };

  Plotly.newPlot(sensorGraph(sensor), data, layout);
};

const sensorUpdate = (sensor, val) => {
  console.log(`${sensor.name}`);
  console.log(val);

  // const points = sensorGraphParent(sensor).querySelector('.points');
  // const newPoint = document.createElement('p');
  // newPoint.innerHTML = JSON.stringify(val);
  // points.insertBefore(newPoint, points.firstChild);

  const update = {
    x: [[val.date]],
    y: [[val.value]]
  };
  console.log(update);

  Plotly.extendTraces(sensorGraph(sensor), update, [0]);
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

  // setTimeout(() => createGraph(sensor), 2000);
  createGraph(sensor);
};
