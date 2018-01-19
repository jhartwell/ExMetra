defmodule ExMetra.Utilities do

  @moduledoc """
  A collection of functions that are used to help with conversions
  """
  @doc "Turn a list of strings into a list of Time with no error checking."
  @spec to_time!([String.t]) :: [Time.t]
  def to_time!(value) when is_list(value), do: Enum.map(value, fn x -> to_time!(x) end)
  @doc "Converts a string value into a Time value with no error checking."
  @spec to_time!(String.t) :: Time.t
  def to_time!(value) when is_binary(value) do
    updated_hour = 
      value
      |> String.slice(0..1)
      |> to_integer!
      |> check_hour
      |> to_string
      |> String.pad_leading(2, "0")

    remaining_time = String.slice(value,2,String.length(value) - 2)
    Time.from_iso8601!("#{updated_hour}#{remaining_time}")
  end

  @spec check_hour(integer) :: integer
  defp check_hour(hour) when hour >= 24, do: hour - 24
  defp check_hour(hour), do: hour


  @doc "Converts a list of string values into a list of boolean values."
  @spec to_boolean!([String.t]) :: [boolean]
  def to_boolean!(value) when is_list(value), do: Enum.map(value, &to_boolean!/1)

  @doc "Converts a string value into a boolean value by first trying to convert the string into an integer. There is no error checking so if that conversion cannot happen then the function will fail."
  @spec to_boolean!(String.t) :: boolean
  def to_boolean!(value) when is_binary(value), do: to_integer!(value) |> to_boolean!

  @doc "Converts an integer into a boolean. If the integer is equal to 1 then it is considered true. All other values are going to represent false."
  @spec to_boolean!(integer) :: boolean
  def to_boolean!(value) when is_integer(value), do: value == 1

  @doc "Converts any non-integer and not-string values into a boolean. If this is called it will always return false."
  @spec to_boolean!(Any) :: boolean
  def to_boolean!(_), do: false

  @doc "Convert a string into an integer. It does not check for errors so it will fail when passed in a non-integer string. If you need to check for errors you can use the built in function Integer.parse"
  @spec to_integer!(String.t) :: integer
  def to_integer!(value) when is_binary(value) do
    {int, _} = Integer.parse(value)
    int
  end

  @doc "Checks a given module to see if it implements the given module."
  @spec implements_protocol?(Protocol.t, Module.t) :: boolean
  def implements_protocol?(protocol, module) do
    try do
      case Protocol.assert_impl!(protocol, module) do
        :ok -> true
        _ -> false
      end
    rescue
      ArgumentError -> false
    end
  end
end
