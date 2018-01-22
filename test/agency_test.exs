defmodule ExMetra.AgencyTest do
  use ExUnit.Case

  alias ExMetra.Agency

  @agency_id "METRA"
  @agency_name "Metra"
  @agency_url "http://www.metrarail.com/"
  @agency_timezone "America/Chicago"
  @agency_lang "EN"
  @agency_phone "999-999-9999"
  @agency_fare_url "https://metrarail.com/tickets"

  @json %{
    "agency_id" => @agency_id,
    "agency_name" => @agency_name,
    "agency_url" => @agency_url,
    "agency_timezone" => @agency_timezone,
    "agency_lang" => @agency_lang,
    "agency_phone" => @agency_phone,
    "agency_fare_url" => @agency_fare_url
  }

  test "parsing valid json" do
    agency = Agency.from_json(@json)

    assert agency.agency_id == @agency_id
    assert agency.agency_name == @agency_name
    assert agency.agency_url == @agency_url
    assert agency.agency_timezone == @agency_timezone
    assert agency.agency_lang == @agency_lang
    assert agency.agency_phone == @agency_phone
    assert agency.agency_fare_url == @agency_fare_url
  end

  test "parsing invalid json parameter" do
    assert_raise FunctionClauseError, fn ->
      Agency.from_json([])
    end
  end
end
