defmodule ExMetra.RouteTest do
  use ExUnit.Case
  alias ExMetra.Route
  require Logger

  @route_id "BNSF"
  @route_short_name "BNSF"
  @route_long_name "BNSF Railway" 
  @route_desc "" 
  @agency_id "METRA"
  @route_type 2 
  @route_color "29C233"
  @route_text_color 0
  @route_url "https://metrarail.com/maps-schedules/train-lines/BNSF"

  @json %{
    "route_id" => @route_id,
    "route_short_name" => @route_short_name,
    "route_long_name" => @route_long_name,
    "route_desc" => @route_desc,
    "agency_id" => @agency_id,
    "route_type" => @route_type,
    "route_color" => @route_color,
    "route_text_color" => @route_text_color,
    "route_url" => @route_url
  }

  test "parsing valid json" do
   route = Route.from_json @json

   assert route.route_id == @route_id
   assert route.route_short_name == @route_short_name
   assert route.route_long_name == @route_long_name
   assert route.route_desc == @route_desc
   assert route.agency_id == @agency_id
   assert route.route_color == @route_color
   assert route.route_text_color == @route_text_color
   assert route.route_url == @route_url
  end

  test "parsing invalid json" do
    assert_raise FunctionClauseError, fn ->
      Route.from_json []
    end
  end
end