defmodule ExMetra.Agency do
  @behaviour Result

  @moduledoc """
  Represents a response from the agency API call
  """
  @type t :: %ExMetra.Agency {
    agency_id: String.t,
    agency_name: String.t,
    agency_url: String.t,
    agency_timezone: String.t,
    agency_lang: String.t,
    agency_phone: String.t,
    agency_fare_url: String.t
  }
  defstruct [:agency_id, :agency_name, :agency_url, :agency_timezone, :agency_lang, :agency_phone, :agency_fare_url]

  @doc "The specific part of the url that will call the agency API"
  @spec url() :: String.t
  def url, do: "/gtfs/schedule/agency"

  @doc "Converts a map that was provided by the Poison library, which represents a JSON object and turns it into an Agency struct"
  @spec from_json(map) :: ExMetra.Agency.t
  def from_json(json) when is_map(json) do
    %ExMetra.Agency {
      agency_id: Map.get(json, "agency_id"),
      agency_name: Map.get(json, "agency_name"),
      agency_url: Map.get(json, "agency_url"), 
      agency_timezone: Map.get(json, "agency_timezone"),
      agency_lang: Map.get(json, "agency_lang"),
      agency_phone: Map.get(json, "agency_phone"),
      agency_fare_url: Map.get(json, "agency_fare_url")
    }
  end
end