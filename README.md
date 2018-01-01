# Twixir

[![Build Status](https://semaphoreci.com/api/v1/silbermm/twixer/branches/master/badge.svg)](https://semaphoreci.com/silbermm/twixer)

Twitter implemented in Elixir

## Running the project locally

 * Make sure you have [Elixir and Phoenix installed](https://hexdocs.pm/phoenix/installation.html)
 * Make sure you have [PostgreSQL installed](https://wiki.postgresql.org/wiki/Detailed_installation_guides)
 * Pull in all dependencies `mix deps.get`
 * Update the [dev configuration file](./config/dev.exs) with your Postgres credentials
 * Get all Javascript dependencies `cd assests && npm i && cd ..`
 * Setup the DB `mix ecto.setup`
 * Finally, start the server `mix phx.server` and browse to [http://localhost:4000](http://localhost:4000)

