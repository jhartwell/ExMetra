defmodule ExMetra.Route do
  @behaviour Result

  @type t :: %ExMetra.Route{
          route_id: String.t(),
          route_short_name: String.t(),
          route_long_name: String.t(),
          route_desc: String.t(),
          agency_id: String.t(),
          route_type: integer,
          route_color: String.t(),
          route_text_color: String.t(),
          route_url: String.t()
        }
  defstruct [
    :route_id,
    :route_short_name,
    :route_long_name,
    :route_desc,
    :agency_id,
    :route_type,
    :route_color,
    :route_text_color,
    :route_url
  ]

  @doc "The specific part of the url that will call the route API"
  @spec url() :: String.t()
  def url, do: "/gtfs/schedule/routes"

  @doc "Converts a map that was provided by the Poison library, which represents a JSON object and turns it into Route struct"
  @spec from_json(map) :: ExMetra.Route.t()
  def from_json(json) when is_map(json) do
    %ExMetra.Route{
      route_id: Map.get(json, "route_id"),
      route_short_name: Map.get(json, "route_short_name"),
      route_long_name: Map.get(json, "route_long_name"),
      route_desc: Map.get(json, "route_desc"),
      agency_id: Map.get(json, "agency_id"),
      route_type: Map.get(json, "route_type"),
      route_color: Map.get(json, "route_color"),
      route_text_color: Map.get(json, "route_text_color"),
      route_url: Map.get(json, "route_url")
    }
  end
end
