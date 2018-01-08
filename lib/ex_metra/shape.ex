defmodule ExMetra.Shape do
  @behaviour Result
  @moduledoc """
  Represents a response from the shapes API call
  """
  @type t :: %ExMetra.Shape {shape_id: String.t, shape_pt_lat: number, shape_pt_lon: number, shape_pt_sequence: integer}
  defstruct [:shape_id, :shape_pt_lat, :shape_pt_lon, :shape_pt_sequence]

  @doc "The specific part of the url that will call the shape API"
  @spec url() :: String.t
  def url, do: "/gtfs/schedule/shapes"

  @doc "Converts a map that was provided by the Poison library, which represents a JSON object and turns it into a Shape struct"  
  @spec from_json(map) :: ExMetra.Shape.t
  def from_json(json) when is_map(json) do
    %ExMetra.Shape {
      shape_id: Map.get(json, "shape_id"),
      shape_pt_lat: Map.get(json, "shape_pt_lat"),
      shape_pt_lon: Map.get(json, "shape_pt_lon"),
      shape_pt_sequence: Map.get(json, "shape_pt_sequence")
    }
  end
end