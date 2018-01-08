defmodule ExMetra.MacrosTest do
  use ExUnit.Case
  import ExMetra.Macros
  require Logger

  @agency %ExMetra.Agency{}
  @calendar %ExMetra.Calendar{}
  @calendar_date %ExMetra.CalendarDate{}
  @route %ExMetra.Route{}
  @shape %ExMetra.Shape{}
  @stop_time %ExMetra.StopTime{}
  @stop %ExMetra.Stop{}
  @trip %ExMetra.Trip{}

  @list [@agency, @calendar, @calendar_date, @route, @shape, @stop_time, @stop, @trip]

  test "ExMetra struct is shown valid" do
    assert is_ex_metra(@agency) == true
    assert is_ex_metra(@calendar) == true
    assert is_ex_metra(@calendar_date) == true
    assert is_ex_metra(@route) == true
    assert is_ex_metra(@shape) == true
    assert is_ex_metra(@stop_time) == true
    assert is_ex_metra(@stop) == true
    assert is_ex_metra(@trip) == true
  end
    
  test "ExMetra list of structs" do
    assert is_ex_metra(@list) == true
  end
  
end