import Plotly from 'plotly.js/lib/core';
import moment from 'moment-timezone';

const rangeButtons = [
  {
    el: document.querySelector('#range-all'),
    startFn: (sensor, now) => {
      if (sensor.points.length === 0) {
        return now;
      }

      return moment.utc(sensor.points[0].date).local();
    }
  },
  {
    el: document.querySelector('#range-day'),
    startFn: (sensor, now) => {
      return now.subtract(1, 'd');
    }
  },
  {
    el: document.querySelector('#range-week'),
    startFn: (sensor, now) => {
      return now.subtract(7, 'd');
    }
  }
];

const rangeIndex = localStorage.getItem('range') || 0;
let range = rangeButtons[rangeIndex];
range.el.classList.add('active');

const sensorGraphParent = sensor =>
  document.querySelector(`#${sensor.slug}-graph`);
const sensorGraph = sensor => sensorGraphParent(sensor).querySelector('.graph');
const sensorValueParent = sensor =>
  document.querySelector(`#${sensor.slug}-value`);
const sensorValue = sensor => sensorValueParent(sensor).querySelector('.value');

const convertDateTime = date =>
  moment
    .utc(date)
    .local()
    .toISOString(true);

const setRange = sensor => {
  Plotly.relayout(sensorGraph(sensor), 'xaxis.range', [
    range.startFn(sensor, moment()).toISOString(true),
    moment().toISOString(true)
  ]);
};

const lineColour = '#4d3ae2';

const createGraph = sensor => {
  const x = sensor.points.map(p => convertDateTime(p.date));
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

  const fontFamily = '"Montserrat", verdana, arial, san-serif';

  const yRange = sensor.units === 'Percent' ? [0, 100] : null;
  const layout = {
    title: sensor.name,
    autosize: true,
    titlefont: {
      size: 24,
      family: fontFamily
    },
    yaxis: {
      range: yRange,
      title: sensor.units,
      titlefont: {
        size: 18,
        family: fontFamily
      }
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
  setRange(sensor);
};

const sensorUpdate = (sensor, val) => {
  // Update the graph
  const update = {
    x: [[convertDateTime(val.date)]],
    y: [[val.value]]
  };

  Plotly.extendTraces(sensorGraph(sensor), update, [0]);
  setRange(sensor);

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

const subscribeToRangeChanges = sensor => {
  const updateActiveButton = btn => {
    document.querySelector('.range-buttons .active').classList.remove('active');
    btn.classList.add('active');
  };

  rangeButtons.forEach((btn, index) => {
    btn.el.addEventListener('click', () => {
      updateActiveButton(btn.el);
      range = btn;
      localStorage.setItem('range', index);
      setRange(sensor);
    });
  });
};

export const handleSensor = (socket, sensor) => {
  registerChannelUpdates(socket, sensor);
  subscribeToRangeChanges(sensor);
  createGraph(sensor);
};
