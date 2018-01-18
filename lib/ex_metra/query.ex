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

  defmacro join(left, right, {left_value, right_value}) do
    quote do
      left_struct  = Kernel.struct(unquote(left))
      right_struct = Kernel.struct(unquote(right))
      
      left_implements_protocol  = ExMetra.Utilities.implements_protocol?(ExMetra, left_struct.__struct__)
      right_implements_protocol = ExMetra.Utilities.implements_protocol?(ExMetra, right_struct.__struct__)

      case {left_implements_protocol, right_implements_protocol} do
        {true, true} ->
           lefts = ExMetra.get!(left_struct)
           rights = ExMetra.get!(right_struct)
           [ll] = lefts |> Enum.take(1)
           {ll, Enum.filter(rights, fn x -> Map.get(x, unquote(right_value)) == Map.get(ll, unquote(left_value)) end)}
        _ -> :error
      end
    end
  end
end