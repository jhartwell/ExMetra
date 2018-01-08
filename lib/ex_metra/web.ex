defmodule ExMetra.Web do
    use HTTPoison.Base
    
    @moduledoc """
    This is the module that interacts with the Metra JSON API. It uses HTTPoison as the base in order to make the actual calls. It will use the same functions as HTTPoison. Because of the fact that it uses the @endpoint as the base of the url, it will only be able to be used to call the Metra API. Do not use this if you are looking to make calls to other websites or services. Do note that basic authorization will already be present in the web calls so it is not necessary to add the headers when making a request. Because Basic Authorization is already included it is important to set the necessary values in your config.exs. The following values must be present in your config.exs for any web calls to be successful:

    config :ex_metra, 
      access_key: "<access key provided by Metra>",
      secret_key: "<secret key provided by Metra>"

    Usage:
      ExMetra.Web.get(url)
    """
    @base_url "https://gtfsapi.metrarail.com/"  
  
    @access_key Application.get_env(:ex_metra, :access_key)
    @secret_key Application.get_env(:ex_metra, :secret_key)
  
    @doc "Processes the url before the actual web call. This is a callback from the HTTPoison.Base. It is used in order to prepend the base url common to all API calls"
    @spec process_url(String.t) :: String.t
    def process_url(url), do: @base_url <> url
    
    @doc "Processes the request headers before the actual web call. This is a callback from the HTTPoison.Base. It adds basic authorization into the headers so that it isn't needed to be entered in any other get calls using this module. It only adds to the headers and does not remove any extra header values so it will not affect any headers that are actually passed in"
    @spec process_request_headers(Keyword.t) :: Keyword.t
    def process_request_headers(headers) do
      enc = Base.encode64("#{@access_key}:#{@secret_key}")
      Keyword.put(headers, :Authorization, "Basic #{enc}")
    end
end