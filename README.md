# Hubert

Home automation system written with [Elixir Phoenix](http://www.phoenixframework.org/).

So far the only systems are

- [Plant monitoring station](https://github.com/coffee-cup/plant-station)
  + Soil moisture
  + Air temperature
  + Sunlight

## Development ✨

1. Clone repo
1. `mix deps.get`
1. `mix ecto.create && mix ecto.migrate`
1. `yarn install`
1. `cp env.example .env`
1. `mix phoenix.server`

Visit [`localhost:4000`](http://localhost:4000) in your browser.

Test with `mix test`.

### Build

The frontend is built with [Webpack](https://webpack.js.org/). This is taken care of for you when starting phoenix.

Phoenix uses the PostgreSQL database. I recommend using the [docker container](https://hub.docker.com/_/postgres/). It must be running before you run the command `mix ecto.create`.
