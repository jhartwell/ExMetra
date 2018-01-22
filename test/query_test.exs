defmodule ExMetra.QueryTest do
  use ExUnit.Case
  require ExMetra.Query

  alias ExMetra.Trip

  test "where clause query" do
    trip_id = "BNSF_BN1200_V1_A"
    trips = ExMetra.Query.where(Trip, x, x.trip_id == trip_id)

    assert trips != nil
    assert Enum.count(trips) == 1

    [trip] = trips
    assert trip != nil
    assert trip.trip_id == trip_id
  end
end
