defmodule ExMetra.CalendarTest do
  use ExUnit.Case

  alias ExMetra.Calendar
  alias ExMetra.Utilities

  @service_id "A1"
  @monday 1
  @tuesday 1
  @wednesday 1
  @thursday 1
  @friday 1
  @saturday 0
  @sunday 0
  @start_date "2017-01-01"
  @end_date "2017-12-17"

  @json %{
    service_id: @service_id,
    monday: @monday,
    tuesday: @tuesday,
    wednesday: @wednesday,
    thursday: @thursday,
    friday: @friday,
    saturday: @saturday,
    sunday: @sunday,
    start_date: @start_date,
    end_date: @end_date
  }

  test "parse from valid json" do
    calendar = Calendar.from_json(@json)

    assert calendar.service_id == @service_id
    assert calendar.monday == Utilities.to_boolean!(@monday)
    assert calendar.tuesday == Utilities.to_boolean!(@tuesday)
    assert calendar.wednesday == Utilities.to_boolean!(@wednesday)
    assert calendar.thursday == Utilities.to_boolean!(@thursday)
    assert calendar.friday == Utilities.to_boolean!(@friday)
    assert calendar.saturday == Utilities.to_boolean!(@saturday)
    assert calendar.sunday == Utilities.to_boolean!(@sunday)
    assert calendar.start_date == Date.from_iso8601!(@start_date)
    assert calendar.end_date == Date.from_iso8601!(@end_date)
  end

  test "parse from invalid json" do
    assert_raise FunctionClauseError, fn ->
      Calendar.from_json []
    end
  end
end