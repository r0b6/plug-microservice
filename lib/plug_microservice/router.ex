defmodule PlugMicroservice.Router do
  use Plug.Router
  alias PlugMicroservice.OpenWeatherMapClient, as: OpenWeatherMapClient

  if Mix.env == :dev do
    use Plug.Debugger
  end

  plug :match
  plug :dispatch

  get "/status" do
    conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Poison.encode!(%{status: "ok"}))
  end

  get "/temperature/:city" do
    OpenWeatherMapClient.get_weather_by_city(city)
      |> handle_response(conn, &OpenWeatherMapClient.parse_temperature/1)
  end

  get "/wind/:city" do
    OpenWeatherMapClient.get_weather_by_city(city)
      |> handle_response(conn, &OpenWeatherMapClient.parse_wind/1)
  end

  defp parse_body(body, transform_fn) do
    handle_poison_parse = fn
      {:ok, value} -> value
                        |> transform_fn.()
                        |> Poison.encode!
      {:error, _} -> %{} 
                        |> Poison.encode!
    end

    body
      |> Poison.Parser.parse
      |> handle_poison_parse.()
  end

  defp handle_response(res, conn, transform_fn) do
      case res do
        {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
          handle_json_response = fn
            "{}" -> conn
                      |> put_resp_content_type("application/json")
                      |> send_resp(500, Poison.encode!(%{reason: "System error"}))
            json -> conn
                      |> put_resp_content_type("application/json")
                      |> send_resp(200, json)
          end

          body
            |> parse_body(transform_fn)
            |> handle_json_response.()

        {:ok, %HTTPoison.Response{status_code: 404}} ->
          conn
            |> put_resp_content_type("application/json")
            |> send_resp(404, Poison.encode!(%{reason: "Data not found"}))

        {:error, %HTTPoison.Error{reason: reason}} ->
          conn
            |> put_resp_content_type("application/json")
            |> send_resp(500, Poison.encode!(%{reason: reason}))

        _ ->
          conn
            |> put_resp_content_type("application/json")
            |> send_resp(500, Poison.encode!(%{reason: "System error"}))
      end
  end

end