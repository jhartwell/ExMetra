defprotocol ExMetra do
  @doc "Gets a value from a given module while checking for errors"
  def get(value)
  @doc "Gets a value from a given module without checking for errors"
  def get!(value)
end

alias ExMetra.Agency
alias ExMetra.Calendar
alias ExMetra.CalendarDate
alias ExMetra.Route
alias ExMetra.Shape
alias ExMetra.Stop
alias ExMetra.StopTime
alias ExMetra.Trip

defimpl ExMetra, for: [Agency, Calendar, CalendarDate, Route, Shape, Stop, StopTime, Trip] do
  @doc """
    Uses ExMetra.Web to make a get call to the Metra API with no error checking. The given module must implement the Result behaviour so that there is a guarentee that the url and from_json functions are implemented.

    Usage:
      ExMetra.get!(%ExMetra.Agency{})
  """
  @spec get!(Any) :: [Any]
  def get!(_struct) do
    ExMetra.Web.get!(@for.url()).body
    |> Poison.Parser.parse!
    |> Enum.map(&@for.from_json/1)
  end

  @doc """
    Uses ExMetra.Web to make a get call to the Metra API with error checking. The given module must implement the Result behaviour so that there is a guarentee that the url and from_json functions are implemented.

    Usage:
      ExMetra.get(%ExMetra.Agency{})
  """
  @spec get(Any) :: map | {:error, String.t}
  def get(_struct) do
    resp = ExMetra.Web.get(@for.url())
    |> process_web
    |> process_resp
    |> process_json

    case resp do
      {:error, msg} -> {:error, msg}
      json -> Enum.map(&@for.from_json/1)
    end
  end

  @spec process_web({atom, String.t}) :: {:error, String.t}
  defp process_web({:error, msg}), do: {:error, msg}

  @spec process_web({atom, HTTPoison.Response.t}) :: map | {:error, String.t}
  defp process_web({:ok, resp}), do: process_resp(resp.body)

  @spec process_resp({atom, String.t}) :: {:error, String.t}
  defp process_resp({:error, msg}), do: {:error, msg}

  @spec process_resp(String.t) :: map | {:error, String.t}
  defp process_resp(body), do: Poison.Parser.parse(body) |> process_json

  @spec process_json({atom, String.t}) :: {:error, String.t}
  defp process_json({:error, msg}), do: {:error, msg}

  @spec process_json({atom, map}) :: map
  defp process_json({:ok, json}), do: json
  end
end

defimpl ExMetra, for: String do
  @doc "Gets a URL from the Metra API with the provided string appended to the root URL. There is no error checking and no post-processing done. This function returns the raw body of the web call."
  @spec get!(String.t) :: String.t
  def get!(url) do
    ExMetra.Web.get!(url).body
  end

  @doc "Gets a URL from the Metra API with the provided string appended to the root URL. There is error checking but there is no post-processing done. This function returns the raw body of the web call."
  @spec get(String.t) :: String.t
  def get(url) do
    case ExMetra.Web.get(url) do
      {:ok, resp} -> resp.body
      error -> error
    end
  end
end