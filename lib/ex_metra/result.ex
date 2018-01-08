defmodule Result do
  @moduledoc """
  This is a behaviour that requires two functions to be implemented: url and from_json. This is currently used for all structs that are going to be used with the ExMetra protocol as that protocol relies on the functions url/0 and from_json/1 to be implemented in order to properly execute.
  """
  @callback url() :: String.t
  @callback from_json(Map.t) :: Any
end