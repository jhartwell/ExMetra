defmodule ExMetra.Query do
  @moduledoc """
  Contains the macros needed to perform the filtering and querying of the data once it has been pulled from the Metra API. It will also provide a simple wrapper around the other calls so that there can be one unified source, if wanted. This will NOT replace the ExMetra module so you can still make the "raw" web calls using that. 
  """  
  
  defmacro __using__(_) do
    quote do
      import ExMetra.Query
      alias ExMetra.Utilities
      @protocol ExMetra
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
      case ExMetra.Utilities.implements_protocol?(@protocol, value.__struct__) do
        true -> value |> ExMetra.get! |> Enum.filter(fn unquote(parameter) -> unquote(where_clause) end)
        _ -> raise "#{unquote(struct)} does not implement the #{@protocol} protocol"
      end
    end
  end
end