defmodule ExMetra.StopTests do
  use ExUnit.Case

  alias ExMetra.Stop
  alias ExMetra.Utilities
  
  @stop_id "GENEVA"
  @stop_name "Geneva"
  @stop_desc ""
  @stop_lat 41.8816667
  @stop_lon -88.31
  @zone_id "H"
  @stop_url "https://metrarail.com/maps-schedules/train-lines/UP-W/stations/GENEVA"
  @wheelchair_boarding 1

  @json %{
    "stop_id" => @stop_id,
    "stop_name" => @stop_name,
    "stop_desc" => @stop_desc,
    "stop_lat" => @stop_lat,
    "stop_lon" => @stop_lon,
    "zone_id" => @zone_id,
    "stop_url" => @stop_url,
    "wheelchair_boarding" => @wheelchair_boarding
  }

  test "parsing from valid json" do
    stop = Stop.from_json(@json)
    
    assert stop.stop_id == @stop_id
    assert stop.stop_name == @stop_name
    assert stop.stop_lat == @stop_lat
    assert stop.stop_lon ==  @stop_lon
    assert stop.zone_id == @zone_id
    assert stop.stop_url == @stop_url
    assert stop.wheelchair_boarding == Utilities.to_boolean!(@wheelchair_boarding)
  end


  test "parsing from invalid json" do
    assert_raise FunctionClauseError, fn ->
      Stop.from_json []
    end
  end
end