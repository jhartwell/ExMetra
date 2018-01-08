defmodule ExMetra.Macros do
  def modules do
    [
      ExMetra.Agency,
      ExMetra.Calendar,
      ExMetra.CalendarDate,
      ExMetra.Route,
      ExMetra.Shape,
      ExMetra.StopTime,
      ExMetra.Stop,
      ExMetra.Trip
    ]
  end

  
  @doc "Takes a value and then checks to see if it is a struct. If it is a struct it then checks to see if the struct module name is part of the included modules to be considered."
  @spec process_map(map) :: boolean
  def process_map(values) do
    case is_map(values) do
      true -> Map.has_key?(values, :__struct__) and (Enum.find(ExMetra.Macros.modules(), fn x -> Map.get(values, :__struct__) == x end) != nil)
      false -> false
    end
  end

  @doc "Takes a value and checks to see if it is a list and if it is it checks each item to see if it is included in the given modules"
  @spec process_list(list) :: boolean
  def process_list(values) do
    case is_list(values) and Enum.all?(values, &is_map/1) do
      true -> Enum.map(values, &process_map/1) |> Enum.all?(fn x -> x == true end)
      false -> false
    end
  end

  defmacro is_ex_metra(values) do
    quote do
      process_list(unquote(values)) or process_map(unquote(values))
    end
  end
end