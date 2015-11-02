defmodule PlugMicroserviceTest do
  use ExUnit.Case, async: false
  use Plug.Test

  doctest PlugMicroservice

  import Mock

  @weather_api_url Application.get_env(:plug_microservice, :open_weather_map_api_url)

  #
  # Tests
  # 
  test "should retrieve wind data for Chicago" do

    uri = "/wind/chicago"

    mocks = [
      search_by_city: "/search_by_city/chicago.json"
    ]

    test_success_with_weather_mocks(uri, "chicago", mocks)
  end

  test "should retrieve temperature data for Chicago" do

    uri = "/temperature/chicago"

    mocks = [
      search_by_city: "/search_by_city/chicago.json"
    ]

    test_success_with_weather_mocks(uri, "chicago", mocks)
  end

  #
  # Mock helper functions
  #
  defp build_httpoison_mocks(search_term, mocks) do
    {:ok, expected_json} = File.read(Enum.join(["test/open_weather_map_api_data", mocks[:search_by_city]]))

    weather_uri = [@weather_api_url, "/weather"] |> Enum.join()

  	fn (uri) ->
  		uri_parts = URI.parse(uri) |> Map.from_struct

  		%{ query: query } = uri_parts

  		query_params = URI.query_decoder(query) |> Enum.map(&(&1)) |> Enum.into(%{})

  		cond do
        	String.starts_with?(uri, weather_uri) and query_params["q"] == search_term -> 
        		{:ok, %HTTPoison.Response{status_code: 200, body: expected_json}}
        	true -> 
        		{:error, %HTTPoison.Response{status_code: 500, body: "Mock not defined"}}
  		end
  	end
  end

  defp test_success_with_weather_mocks(uri, search_term, mocks) do
  	httpoison_mocks = build_httpoison_mocks(search_term, mocks)

    with_mock HTTPoison, [start: fn () -> nil end, get: httpoison_mocks] do
			conn = conn(:get, uri)
				|> PlugMicroservice.Router.call []

			assert conn.status == 200

			expected_json_filename = ["test/expected_json", uri, ".json"] |> Enum.join()
			{:ok, expected_json} = File.read(expected_json_filename)

			assert Poison.decode!(conn.resp_body) == Poison.decode!(expected_json)
    end
  end
end
