defmodule ExMetra.UtilitiesTest do
  use ExUnit.Case
  alias ExMetra.Utilities
  
  @time "04:30:00"
  @time_list [
    "01:30:43",
    "03:24:13"
  ]

  test "valid time conversion" do
    assert {:ok, Utilities.to_time!(@time)} == Time.new(4,30,0)
  end

  test "valid list time conversion" do
    times = Utilities.to_time! @time_list

    [actual_first | [actual_second]] = times
    [expected_first | [expected_second]] = @time_list

    assert {:ok, actual_first} == Time.from_iso8601(expected_first)
    assert {:ok, actual_second} == Time.from_iso8601(expected_second)
  end

  test "invalid list time conversion" do
    assert_raise ArgumentError, fn -> 
      Utilities.to_time!(["abc"])
    end
  end

  test "invalid time conversion" do
    assert_raise ArgumentError, fn ->
      Utilities.to_time!(["4:30:1"]) == 1
    end
  end

  test "valid boolean conversion true" do
    assert Utilities.to_boolean!(1) == true
  end

  test "valid boolean conversion false" do
    assert Utilities.to_boolean!(0) == false
    assert Utilities.to_boolean!(100) == false
    assert Utilities.to_boolean!(-1) == false
  end

  test "invalid boolean conversion" do
    assert_raise MatchError, fn ->
      Utilities.to_boolean! "a"
    end
  end

  test "parsing integer with valid integer" do
    assert Utilities.to_integer!("10") == 10
    assert Utilities.to_integer!("134") == 134
    assert Utilities.to_integer!("-23") == -23
  end

  test "parsing integer with invalid parameter" do
    assert_raise MatchError, fn ->
      Utilities.to_integer!("abc")
    end
  end

end