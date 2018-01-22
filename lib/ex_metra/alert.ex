defmodule ExMetra.Alert do

  require Logger
  @type t :: %ExMetra.Alert{id: integer, is_deleted: boolean, trip_update: String.t, vehicle: String.t, alert_start: DateTime.t,
    alert_end: DateTime.t, route_id: String.t, stop_id: String.t, trip: String.t, header: String.t, description: String.t}
  defstruct [:id, :is_deleted, :trip_update, :vehicle, :alert_start, :alert_end, :route_id, :stop_id, :trip, :header, :description]
  
  def from_json(json) do
    {start_time, end_time} = get_times(json)
    {route_id, stop_id, trip} = get_informed_entity(json)
    %ExMetra.Alert{
      id: Map.get(json, :id),
      is_deleted: Map.get(json, :is_deleted),
      trip_update: Map.get(json, :trip_update),
      vehicle: Map.get(json, :vehicle),
      alert_start: start_time |> ExMetra.Utilities.to_time!,
      alert_end: end_time |> ExMetra.Utilities.to_time!,
      route_id: route_id,
      stop_id: stop_id,
      trip: trip,
      header: Map.get(json, :header_text, %{}) |> Map.get(:translation, %{}) |> Map.get(:text),
      description: Map.get(json, :description_text, %{}) |> Map.get(:translation, %{}) |> Map.get(:text)
    }
  end

  defp get_informed_entity(json) do
    informed_entity = Map.get(json, :informed_entity, %{})
    {Map.get(informed_entity, :route_id), Map.get(informed_entity, :stop_id), Map.get(informed_entity, :trip)}
  end

  defp get_times(json) do
    active_periods = Map.get(json, :alert, %{}) |> Map.get(:active_period, %{})
    active_periods |> inspect |> Logger.info 
    start_time = active_periods |> Map.get(:start, %{}) |> Map.get(:low)
    end_time = active_periods |> Map.get(:end, %{}) |> Map.get(:low)
    {start_time, end_time}
  end
end
