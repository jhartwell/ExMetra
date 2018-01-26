defmodule ExMetra.Alert do
  @behaviour Result

  @type t :: %ExMetra.Alert {
          id: integer, 
          is_deleted: boolean, 
          trip_update: String.t, 
          vehicle: String.t, alert_start: DateTime.t,
          alert_end: DateTime.t, 
          route_id: String.t, 
          stop_id: String.t, 
          trip: String.t, 
          header: String.t, 
          description: String.t
        }
  defstruct [:id, :is_deleted, :trip_update, :vehicle, :alert_start, :alert_end, :route_id, :stop_id, :trip, :header, :description]
  
  @doc "The specific part of the url that will call the alert API"
  @spec url() :: String.t()
  def url, do: "/gtfs/alerts"
  
  @doc "Create an alert from the given JSON map"
  @spec from_json(Map.t) :: ExMetra.Alert.t
  def from_json(json) do
    
    alert = Map.get(json, "alert", %{})
    {start_time, end_time} = get_times(alert)
    {route_id, stop_id, trip} = get_informed_entity(alert)
    %ExMetra.Alert{
      id: Map.get(json, "id"),
      is_deleted: Map.get(json, "is_deleted") |> ExMetra.Utilities.to_boolean!, 
      trip_update: Map.get(json, "trip_update"),
      vehicle: Map.get(json, "vehicle"),
      alert_start: start_time,
      alert_end: end_time,
      route_id: route_id,
      stop_id: stop_id,
      trip: trip,
      header: get_text(alert, "header_text"),
      description: get_text(alert, "description_text")
    }
  end

  defp get_text(json,key) do
    [translation]  = Map.get(json, key, %{}) |> Map.get("translation")
    Map.get(translation, "text")
  end

  defp get_informed_entity(json) do
    [informed_entity] = Map.get(json, "informed_entity", %{})
    {Map.get(informed_entity, "route_id"), Map.get(informed_entity, "stop_id"), Map.get(informed_entity, "trip")}
  end

  defp get_times(json) do
    [active_periods] = Map.get(json, "active_period", %{})
    start_time = active_periods |> Map.get("start", %{}) |> Map.get("low")
    start_time = case String.ends_with?(start_time, ".000Z") do
                  true -> ExMetra.Utilities.to_datetime!(start_time)
                  _ -> "#{start_time}.000Z" |> ExMetra.Utilities.to_datetime!
                end 
    end_time = active_periods |> Map.get("end", %{}) |> Map.get("low")  
    end_time = case String.ends_with?(end_time, ".000Z") do
                true -> ExMetra.Utilities.to_datetime!(end_time)
                _ -> "#{end_time}.000Z" |> ExMetra.Utilities.to_datetime!
              end
    {start_time, end_time}
  end
end
