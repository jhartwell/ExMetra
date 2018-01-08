# ExMetra

ExMetra is a library for interacting with the Metra JSON API. Metra is the commuter rail for the Chicago-land area. You can visit https://www.metrarail.com for their main website or if you want to know more about their API you can visit https://metrarail.com/developers/metra-gtfs-api. At this point only the static data is available

## Installation

The package can be installed by adding `ex_metra` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_metra, "~> 0.1.0"}
  ]
end
```

## Usage

ExMetra uses behaviours and protocols in order to make accessing the Metra JSON API as simple as possible. For example, if you want to get a list of all routes that Metra has you can make do the following:

```elixir
ExMetra.get(%ExMetra.Route{})
```

Or if you prefer no error checking then you can do the following:

```elixir
ExMetra.get!(%ExMetra.Route{})
```

The ExMetra protocol is strict on what can be used in order to be passed in to the get functions. In order for the calls to work you must pass in a struct that is provided in this library that also uses the Result behaviour or you can pass in a string. If you pass in a string it will append that string to the Metra API base url, which is current https://gtfsapi.metrarail.com/