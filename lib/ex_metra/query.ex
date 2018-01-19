defmodule ExMetra.Query do
  @moduledoc """
  Contains the macros needed to perform the filtering and querying of the data once it has been pulled from the Metra API. It will also provide a simple wrapper around the other calls so that there can be one unified source, if wanted. This will NOT replace the ExMetra module so you can still make the "raw" web calls using that. 
  """  
  
  defmacro __using__(_) do
    quote do
      import ExMetra.Query
    end
  end

  
  defmacro get(struct) do
    quote do
      value = struct(unquote(struct))
      case Enum.find(@modules, fn x -> struct(x) == value end) do
        nil -> raise "#{unquote(struct)} is not in the list of valid values in @modules"
        _ -> value |> ExMetra.get!
      end
    end
  end

  @doc "Performs a where query on the result of the web call. This will check"
  defmacro where(struct, parameter, where_clause) do
    quote do
      value = Kernel.struct(unquote(struct))
      case ExMetra.Utilities.implements_protocol?(ExMetra, value.__struct__) do
        true -> value |> ExMetra.get! |> Enum.filter(fn unquote(parameter) -> unquote(where_clause) end)
        _ -> raise "#{unquote(struct)} does not implement the ExMetra protocol"
      end
    end
  end

  @doc """
  Makes a web call for both left and right values passed in and then will join them based on the criteria given in the tuple. Do note, that depending on which calls you are making this could take awhile to execute.
  
  ### Example
  ~~~
    alias ExMetra.Stop
    alias ExMetra.StopTime
    join Stop, StopTime, {:stop_id, :stop_id}
  ~~~

  This will return a tuple value with the first position being the value from the left hand side of the join (Stop in this example) and then the second position is a list of right hand side values (StopTime in this example)
  """

  @spec join(struct, struct, {:atom, :atom}) :: [tuple]
  defmacro join(left, right, {left_value, right_value}) do
    quote do
      left_struct  = Kernel.struct(unquote(left))
      right_struct = Kernel.struct(unquote(right))
      timeout = 60000
      left_implements_protocol  = ExMetra.Utilities.implements_protocol?(ExMetra, left_struct.__struct__)
      right_implements_protocol = ExMetra.Utilities.implements_protocol?(ExMetra, right_struct.__struct__)

      case {left_implements_protocol, right_implements_protocol} do
        {true, true} ->
           left_task = Task.async(fn -> ExMetra.get!(left_struct) end)
           right_task = Task.async(fn -> ExMetra.get!(right_struct) end)
           lefts = Task.await(left_task, timeout)
           rights = Task.await(right_task, timeout)
           Enum.reduce(lefts, [], 
              fn l, acc -> [{l,Enum.filter(rights, fn r -> Map.get(r, unquote(right_value)) == Map.get(l, unquote(left_value)) end)}| acc] end)
        _ -> :error
      end
    end
  end
end