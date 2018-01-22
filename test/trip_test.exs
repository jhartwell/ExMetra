defmodule ExMetra.TripTest do
  use ExUnit.Case
  alias ExMetra.Trip

  @route_id "BNSF"
  @service_id "A1"
  @trip_id "BNSF_BN1200_V1_A"
  @trip_headsign "Chicago Union Station"
  @block_id ""
  @shape_id "BNSF_IB_1"
  @direction_id 1

  @json %{
    "route_id" => @route_id,
    "service_id" => @service_id,
    "trip_id" => @trip_id,
    "trip_headsign" => @trip_headsign,
    "block_id" => @block_id,
    "shape_id" => @shape_id,
    "direction_id" => @direction_id
  }

  test "parse valid json" do
    trip = Trip.from_json(@json)

    assert trip.route_id == @route_id
    assert trip.service_id == @service_id
    assert trip.trip_id == @trip_id
    assert trip.trip_headsign == @trip_headsign
    assert trip.block_id == @block_id
    assert trip.shape_id == @shape_id
    assert trip.direction_id == @direction_id
  end

  test "parse invalid json" do
    assert_raise FunctionClauseError, fn ->
      Trip.from_json([])
    end
  end
end
