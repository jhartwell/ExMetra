defmodule ExMetra.StopTime do
  alias ExMetra.Utilities

  @moduledoc """
  Represents a response from the stop_time API call
  """
  
  @type t :: %ExMetra.StopTime {
    trip_id: String.t,
    arrival_time: Time.t,
    departure_time: Time.t,
    stop_id: String.t,
    stop_sequence: integer,
    pickup_type: integer,
    drop_off_type: integer,
    center_boarding: boolean,
    south_boarding: boolean,
    bikes_allowed: boolean,
    notice: boolean
  }

  defstruct [:trip_id, :arrival_time, :departure_time, :stop_id, :stop_sequence, :pickup_type, :drop_off_type,
    :center_boarding, :south_boarding, :bikes_allowed, :notice]

  @doc "The specific part of the url that will call the stop time API"    
  @spec url() :: String.t
  def url, do: "/gtfs/schedule/stop_times"

  @doc "Converts a map that was provided by the Poison library, which represents a JSON object and turns it into a StopTime struct"
  @spec from_json(map) :: ExMetra.StopTime.t
  def from_json(json) when is_map(json) do
        %ExMetra.StopTime {
          trip_id: Map.get(json, "trip_id"),
          arrival_time: Map.get(json, "arrival_time") |> Utilities.to_time!,
          departure_time: Map.get(json, "departure_time") |> Utilities.to_time!,
          stop_id: Map.get(json, "stop_id"),
          stop_sequence: Map.get(json, "stop_sequence"),
          pickup_type: Map.get(json, "pickup_type"),
          drop_off_type: Map.get(json, "drop_off_type"), 
          center_boarding: Map.get(json, "center_boarding") |> Utilities.to_boolean!,
          south_boarding: Map.get(json, "south_boarding") |> Utilities.to_boolean!,
          bikes_allowed: Map.get(json, "bikes_allowed") |> Utilities.to_boolean!,
          notice: Map.get(json, "notice") |> Utilities.to_boolean!
        }
  end
end