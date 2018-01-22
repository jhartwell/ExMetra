defmodule ExMetra.ShapeTest do
  use ExUnit.Case
  alias ExMetra.Shape

  @shape_id "BNSF_IB_1"
  @shape_pt_lat 41.75945392475
  @shape_pt_lon -88.30906426603
  @shape_pt_sequence 2

  @json %{
    "shape_id" => @shape_id,
    "shape_pt_lat" => @shape_pt_lat,
    "shape_pt_lon" => @shape_pt_lon,
    "shape_pt_sequence" => @shape_pt_sequence
  }

  test "parsing valid json" do
    shape = Shape.from_json(@json)

    assert shape.shape_id == @shape_id
    assert shape.shape_pt_lat == @shape_pt_lat
    assert shape.shape_pt_lon == @shape_pt_lon
    assert shape.shape_pt_sequence == @shape_pt_sequence
  end

  test "parsing invalid parameter" do
    assert_raise FunctionClauseError, fn ->
      Shape.from_json([])
    end
  end
end
