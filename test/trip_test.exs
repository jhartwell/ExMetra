defmodule ExMetra.TripTest do
  use ExUnit.Case
  alias ExMetra.Trip

  @json %{
    route_id: "BNSF",
    service_id: "A1",
    trip_id: "BNSF_BN1200_V1_A",
    trip_headsign: "Chicago Union Station",
    block_id: "",
    shape_id: "BNSF_IB_1",
    direction_id: 1
  }

  test "parse valid json" do
    trip = Trip.from_json(@json)

    assert trip.route_id == "BNSF"
    assert trip.service_id == "A1"
    assert trip.trip_id == "BNSF_BN1200_V1_A"
    assert trip.trip_headsign == "Chicago Union Station"
    assert trip.block_id == ""
    assert trip.shape_id == "BNSF_IB_1"
    assert trip.direction_id == 1
  end

  test "parse invalid json" do
    assert_raise FunctionClauseError, fn ->
      Trip.from_json []
    end
  end
end