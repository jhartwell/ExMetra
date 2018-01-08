defmodule ExMetra.Stop do
  @behaviour Result
  @moduledoc """
  Represents a response from the stop API call
  """
  @type t :: %ExMetra.Stop{
                stop_id: String.t, 
                stop_name: String.t,
                stop_desc: String.t,
                stop_lat: number,
                stop_lon: number, 
                zone_id: String.t,
                stop_url: String.t,
                wheelchair_boarding: boolean
            }
  defstruct [:stop_id, :stop_name, :stop_desc, :stop_lat, :stop_lon, :zone_id, :stop_url, :wheelchair_boarding]
  
  @doc "The specific part of the url that will call the stop API"
  @spec url() :: String.t
  def url(), do: "/gtfs/schedule/stops"
  
  @doc "Converts a map that was provided by the Poison library, which represents a JSON object and turns it into a Stop struct"
  @spec from_json(map) :: ExMetra.Stop.t
  def from_json(json) when is_map(json) do
    %ExMetra.Stop {
      stop_id: Map.get(json, :stop_id),
      stop_name: Map.get(json, :stop_name),
      stop_desc: Map.get(json, :stop_desc),
      stop_lat: Map.get(json, :stop_lat),
      stop_lon: Map.get(json, :stop_lon),
      zone_id: Map.get(json, :zone_id),
      stop_url: Map.get(json, :stop_url),
      wheelchair_boarding: Map.get(json, :wheelchair_boarding)
    }
  end
end