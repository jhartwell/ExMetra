defmodule ExMetra.CalendarDateTest do
  use ExUnit.Case
  alias ExMetra.CalendarDate

  @service_id "D1"
  @date "2017-12-29"
  @exception_type 1

  @json %{
    "service_id" => @service_id,
    "date" => @date,
    "exception_type" => @exception_type
  }

  test "parse valid json" do
    calendar_date = CalendarDate.from_json(@json)

    assert calendar_date.service_id == @service_id
    assert calendar_date.date == Date.from_iso8601!(@date)
    assert calendar_date.exception_type == @exception_type
  end

  test "parse invalid json" do
    assert_raise FunctionClauseError, fn ->
      CalendarDate.from_json([])
    end
  end
end
