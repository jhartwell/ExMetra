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

## Query Language

There is now the ability to query against the Metra API without having to actually do any filtering on the end user's part. Right now there are only 3 actions: get, where, join. It is important to note that these calls reach out to the API each time they are called so it is good to store the result.

#### Where

Where is going to pull all records of a given struct based on a predicate criteria. For instance, if we want to get all Agency items that have an agency id equal to "Metra" we would do the following:

```elixir
  where ExMetra.Agency, x, x.agency_id == "Metra"
```

The first parameter is going to be the struct that is being fetched. The second is going to be the represenation of the struct as a variable and the third parameter is going to be a predicate where you can use the binding from the second parameter.

#### Join

Join allows you to do a very limited SQL-like join on the results of the API. A join call looks as follows:

```elixir
  join ExMetra.Stop, ExMetra.StopTime, {:stop_id, :stop_id}
```

The first parameter is going to always be returned in full. In the example above, every stop is going to be returned regardless if there is a stop time associated with that particular stop. The second parameter will only have results if there is an associated record from the first parameter. In our example, if a Stop has associated StopTimes, then they will be returned but if there are StopTimes that aren't associated with any given Stop then those StopTimes will be ignored. Finally, the third parameter is a tuple that contains the two fields to be compared. The first part of the tuple is going to be the name of the field on the first parameter while the second part is going to be the name of the field on the second parameter.

The result of a call to `join` is going to look as follows:

```elixir
  [
    {%ExMetra.Stop{}, [%ExMetra.StopTime{}, %ExMetra.StopTime{}]}
  ]
```

It is a list of tuples with the first value being a populated struct that corresponds to the first parameter of `join` and the second value is a list of populated structs that correspond to the second parameter of `join`.


#### Select

`select` will pull just the specific fields that you want from the given call. If you are making a call to the agency API endpoint and only want to get the agency id you would use the following call:

```elixir
  select ExMetra.Agency, :agency_id
```

This will return a list of only the agency ids. **It is important to note that this will not do any filtering from the API call but actually does the filtering locally after getting the results from Metra's servers**.