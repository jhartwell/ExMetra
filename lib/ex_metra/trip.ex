defmodule ExMetra.Trip do
  @behaviour Result

  require Logger

  @moduledoc """
  Represents a response from the trip API call
  """
  @type direction :: integer

  @type t :: %ExMetra.Trip{
          route_id: String.t(),
          service_id: String.t(),
          trip_id: String.t(),
          trip_headsign: String.t(),
          block_id: String.t(),
          shape_id: String.t(),
          direction_id: direction
        }

  defstruct [
    :route_id,
    :service_id,
    :trip_id,
    :trip_headsign,
    :block_id,
    :shape_id,
    :direction_id
  ]

  @doc "The specific part of the url that will call the trip API"
  @spec url() :: String.t()
  def url, do: "/gtfs/schedule/trips"

  @doc "Converts a map that was provided by the Poison library, which represents a JSON object and turns it into a Trip struct"
  @spec from_json(map) :: ExMetra.Trip.t()
  def from_json(json) when is_map(json) do
    %ExMetra.Trip{
      route_id: Map.get(json, "route_id"),
      service_id: Map.get(json, "service_id"),
      trip_id: Map.get(json, "trip_id"),
      trip_headsign: Map.get(json, "trip_headsign"),
      block_id: Map.get(json, "block_id"),
      shape_id: Map.get(json, "shape_id"),
      direction_id: Map.get(json, "direction_id")
    }
  end
end
