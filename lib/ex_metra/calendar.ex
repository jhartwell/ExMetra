defmodule ExMetra.Calendar do
  @behaviour Result
  @moduledoc """
  Represents a response from the calendar API call
  """

  alias ExMetra.Utilities

  @type t :: %ExMetra.Calendar{
          service_id: String.t(),
          monday: boolean,
          tuesday: boolean,
          wednesday: boolean,
          thursday: boolean,
          friday: boolean,
          saturday: boolean,
          sunday: boolean,
          start_date: Date.t(),
          end_date: Date.t()
        }

  defstruct [
    :service_id,
    :monday,
    :tuesday,
    :wednesday,
    :thursday,
    :friday,
    :saturday,
    :sunday,
    :start_date,
    :end_date
  ]

  @doc "The specific part of the url that will call the calendar API"
  @spec url() :: String.t()
  def url, do: "/gtfs/schedule/calendar"

  @doc "Converts a map that was provided by the Poison library, which represents a JSON object and turns it into a Calendar struct"
  @spec from_json(map) :: ExMetra.Calendar.t()
  def from_json(json) when is_map(json) do
    %ExMetra.Calendar{
      service_id: Map.get(json, "service_id"),
      monday: Map.get(json, "monday") |> Utilities.to_boolean!(),
      tuesday: Map.get(json, "tuesday") |> Utilities.to_boolean!(),
      wednesday: Map.get(json, "wednesday") |> Utilities.to_boolean!(),
      thursday: Map.get(json, "thursday") |> Utilities.to_boolean!(),
      friday: Map.get(json, "friday") |> Utilities.to_boolean!(),
      saturday: Map.get(json, "saturday") |> Utilities.to_boolean!(),
      sunday: Map.get(json, "sunday") |> Utilities.to_boolean!(),
      start_date: Map.get(json, "start_date") |> Date.from_iso8601!(),
      end_date: Map.get(json, "end_date") |> Date.from_iso8601!()
    }
  end
end
