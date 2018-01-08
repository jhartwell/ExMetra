defmodule ExMetra.StopTimeTest do
  use ExUnit.Case
  require Logger
  alias ExMetra.StopTime
  alias ExMetra.Utilities

  @trip_id "BNSF_BN1200_V1_A"
  @arrival_time "04:30:00"
  @departure_time "04:30:00"
  @stop_id "AURORA"
  @stop_sequence 1
  @pickup_type 0
  @drop_off_type 0
  @center_boarding 0
  @south_boarding 0
  @bikes_allowed 1
  @notice 0

  @json %{
    trip_id: @trip_id,
    arrival_time: @arrival_time, 
    departure_time: @departure_time,
    stop_id: @stop_id,
    stop_sequence: @stop_sequence,
    pickup_type: @pickup_type,
    drop_off_type: @drop_off_type,
    center_boarding: @center_boarding,
    south_boarding: @south_boarding,
    bikes_allowed: @bikes_allowed,
    notice: @notice
  }

  test "parsing valid json" do
    stop_time = StopTime.from_json @json  


    assert stop_time.trip_id == "BNSF_BN1200_V1_A"
    assert stop_time.arrival_time == Time.from_iso8601!(@arrival_time)
    assert stop_time.departure_time == Time.from_iso8601!(@departure_time)
    assert stop_time.stop_id == @stop_id
    assert stop_time.stop_sequence == @stop_sequence
    assert stop_time.pickup_type == @pickup_type
    assert stop_time.drop_off_type == @drop_off_type
    assert stop_time.center_boarding == Utilities.to_boolean(@center_boarding)
    assert stop_time.south_boarding == Utilities.to_boolean(@south_boarding)
    assert stop_time.bikes_allowed == Utilities.to_boolean(@bikes_allowed)
    assert stop_time.notice == Utilities.to_boolean(@notice)
  end

  test "parsing invalid json" do
    assert_raise FunctionClauseError, fn ->
      StopTime.from_json []
    end
  end
end