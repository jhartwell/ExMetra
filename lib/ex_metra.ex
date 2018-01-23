defprotocol ExMetra do
  @doc "Gets a value from a given module while checking for errors"
  def get(value)
  @doc "Gets a value from a given module without checking for errors"
  def get!(value)
end

require Logger
alias ExMetra.Agency
alias ExMetra.Alert
alias ExMetra.Calendar
alias ExMetra.CalendarDate
alias ExMetra.Route
alias ExMetra.Shape
alias ExMetra.Stop
alias ExMetra.StopTime
alias ExMetra.Trip
alias ExMetra.Web

defimpl ExMetra, for: [Agency, Alert, Calendar, CalendarDate, Route, Shape, Stop, StopTime, Trip] do
  @doc """
    Uses ExMetra.Web to make a get call to the Metra API with no error checking. The given module must implement the Result behaviour so that there is a guarentee that the url and from_json functions are implemented.

    Usage:
      ExMetra.get!(%ExMetra.Agency{})
  """
  @spec get!(Any) :: [Any]
  def get!(_struct) do
    ExMetra.Web.get!(@for.url()).body
    |> Poison.Parser.parse!()
    |> Enum.map(&@for.from_json/1)
  end

  @doc """
    Uses ExMetra.Web to make a get call to the Metra API with error checking. The given module must implement the Result behaviour so that there is a guarentee that the url and from_json functions are implemented.

    Usage:
      ExMetra.get(%ExMetra.Agency{})
  """
  @spec get(Any) :: map | {:error, String.t()}
  def get(_struct) do
    resp = Web.get(@for.url())

    json =
      case resp do
        {:ok, response} -> parse_response(response)
        error -> error
      end

    case json do
      {:ok, json_result} -> {:ok, Enum.map(json_result, &@for.from_json/1)}
      error -> error
    end
  end

  @doc "Determines if the HTTPoison request was successful based on status code. If it is successful it tries to parse the JSON, if it isn't then an error will be returned"
  @spec parse_response(HTTPoison.Response.t()) :: map | {:error, String.t()}
  defp parse_response(response) do
    case response.status_code do
      200 -> Poison.Parser.parse(response.body)
      _ -> {:error, "API call failed due to status code #{response.status_code}"}
    end
  end
end

defimpl ExMetra, for: String do
  @doc "Gets a URL from the Metra API with the provided string appended to the root URL. There is no error checking and no post-processing done. This function returns the raw body of the web call."
  @spec get!(String.t()) :: String.t()
  def get!(url) do
    ExMetra.Web.get!(url).body
  end

  @doc "Gets a URL from the Metra API with the provided string appended to the root URL. There is error checking but there is no post-processing done. This function returns the raw body of the web call."
  @spec get(String.t()) :: String.t()
  def get(url) do
    case ExMetra.Web.get(url) do
      {:ok, resp} -> resp.body
      error -> error
    end
  end
end
