defmodule ExMetra.CalendarDate do
  @behaviour Result
  @moduledoc """
  Represents a response from the calendar_dates API call
  """
  @type exception :: integer
  
  @type t :: %ExMetra.CalendarDate{ service_id: String.t, date: DateTime.t, exception_type: exception}
  defstruct [:service_id, :date, :exception_type]

  @doc "The specific part of the url that will call the calendar date API"
  @spec url() :: String.t
  def url, do: "/gtfs/schedule/calendar_dates"

  @doc "Converts a map that was provided by the Poison library, which represents a JSON object and turns it into a CalendarDate struct"  
  @spec from_json(map) :: ExMetra.CalendarDate.t
  def from_json(json) when is_map(json) do
    %ExMetra.CalendarDate {
      service_id: Map.get(json, :service_id),
      date: Map.get(json, :date) |> Date.from_iso8601!,
      exception_type: Map.get(json, :exception_type)
    }
  end
end