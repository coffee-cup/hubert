import Plotly from 'plotly.js/lib/core';

const sensorGraphParent = sensor =>
  document.querySelector(`#${sensor.slug}-graph`);

const sensorGraph = sensor => sensorGraphParent(sensor).querySelector('.graph');

const sensorValueParent = sensor =>
  document.querySelector(`#${sensor.slug}-value`);

const sensorValue = sensor => sensorValueParent(sensor).querySelector('.value');

const lineColour = '#4d3ae2';

const createGraph = sensor => {
  const x = sensor.points.map(p => p.date);
  const y = sensor.points.map(p => p.value);
  const data = [
    {
      x,
      y,
      type: 'scatter',
      line: {
        color: lineColour,
        dash: 'solid',
        shape: 'spline',
        smoothing: 0.1
      },
      marker: {
        symbol: 'circle',
        size: 6,
        color: lineColour
      }
    }
  ];

  const yRange = sensor.units === 'Percent' ? [0, 100] : null;
  const layout = {
    title: sensor.name,
    autosize: true,
    titlefont: {
      size: 24
    },
    xaxis: {
      title: '',
      titlefont: {
        size: 18
      }
    },
    yaxis: {
      range: yRange,
      title: sensor.units,
      titlefont: { size: 18 }
    },
    margin: {
      l: 60,
      r: 40,
      t: 100,
      b: 50,
      pad: 0,
      autoexpand: true
    },
    hoverdistance: 50
  };

  Plotly.newPlot(sensorGraph(sensor), data, layout);
};

const sensorUpdate = (sensor, val) => {
  // Update the graph
  const update = {
    x: [[val.date]],
    y: [[val.value]]
  };

  Plotly.extendTraces(sensorGraph(sensor), update, [0]);

  // Update the value
  sensorValue(sensor).innerText = `${val.value} ${sensor.symbol}`;
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
