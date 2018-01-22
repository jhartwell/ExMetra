defmodule ExMetra.Query do
  @moduledoc """
  Contains a unified query syntax for querying against the Metra API. This does not replace the `ExMetra.get` calls but builds upon it. This module can provide everything that you need to query without having to resort to `ExMetra.get`.
  """

  @type parameter_value :: Any
  @predicate :: function

  @doc "Makes a call to the Metra API and returns all the results. This is the same as calling `ExMetra.get!(struct) but is presented here to make a unified query language so that you can perform all tasks with just one module"
  @spec get(struct) :: [struct]
  defmacro get(struct) do
    quote do
      value = struct(unquote(struct))

      case ExMetra.Utilities.implements_protocol?(ExMetra, value.__struct__) do
        true -> value |> ExMetra.get!()
        _ -> raise "#{value.__struct__} does not implement the ExMetra protocol"
      end
    end
  end

  @doc """
  Makes a web call for the given struct and then filters the results based on the function passed in

  ### Example

  ~~~
    alias ExMetra.Agency
    where Agency, x, x == "METRA"
  ~~~

  The second parameter of the call is what determines what variables you are using in the predicate (3rd parameter of where). In this example, we use 'x' as the second parameter which will give us access to x in our predicate. If the two values do not match there will be issues
  """
  @spec where(struct, parameter_value, predicate) :: [struct]
  defmacro where(struct, parameter, where_clause) do
    quote do
      value = Kernel.struct(unquote(struct))

      case ExMetra.Utilities.implements_protocol?(ExMetra, value.__struct__) do
        true ->
          value |> ExMetra.get!()
          |> Enum.filter(fn unquote(parameter) -> unquote(where_clause) end)

        _ ->
          raise "#{unquote(struct)} does not implement the ExMetra protocol"
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
      left_struct = Kernel.struct(unquote(left))
      right_struct = Kernel.struct(unquote(right))
      timeout = 60000

      left_implements_protocol =
        ExMetra.Utilities.implements_protocol?(ExMetra, left_struct.__struct__)

      right_implements_protocol =
        ExMetra.Utilities.implements_protocol?(ExMetra, right_struct.__struct__)

      case {left_implements_protocol, right_implements_protocol} do
        {true, true} ->
          left_task = Task.async(fn -> ExMetra.get!(left_struct) end)
          right_task = Task.async(fn -> ExMetra.get!(right_struct) end)
          lefts = Task.await(left_task, timeout)
          rights = Task.await(right_task, timeout)

          Enum.reduce(lefts, [], fn l, acc ->
            [
              {l,
               Enum.filter(rights, fn r ->
                 Map.get(r, unquote(right_value)) == Map.get(l, unquote(left_value))
               end)}
              | acc
            ]
          end)

        _ ->
          :error
      end
    end
  end
end
