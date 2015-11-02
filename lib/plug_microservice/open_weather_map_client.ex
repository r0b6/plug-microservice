defmodule PlugMicroservice.OpenWeatherMapClient do

  @weather_api_url Application.get_env(:plug_microservice, :open_weather_map_api_url)
  @app_id Application.get_env(:plug_microservice, :open_weather_map_app_id)

  def get_weather_by_city(city) do
    if is_valid_city(city) do
      HTTPoison.start

      query_params = %{ 
            "q" => city, 
            "units" => "imperial",
            "appid" => @app_id 
      }

      query = query_params
        |> Enum.map(fn {k,v} -> Enum.join([k,v], "=") end)
        |> Enum.join("&")

      [@weather_api_url, "/weather?", query]
        |> Enum.join
        |> HTTPoison.get
    else
      {:error, %HTTPoison.Error{reason: "Not a valid city"}}
    end
  end

  def parse_temperature(body) do
    %{
      "main" =>  main
    } = body

    %{
        "temp_min" => low_temperature,
        "temp_max" => high_temperature,
        "temp" => current_temperature
    } = main

    %{
      "temperature" => %{
        "units" => "Fahrenheit",
        "current" => current_temperature,
        "low" => low_temperature,
        "high" => high_temperature
      }
    }
  end

  def parse_wind(body) do
    %{
      "wind" =>  wind
    } = body

    %{
        "speed" => wind_speed,
        "deg" => wind_direction
    } = wind

    %{
      "wind" => %{
        "speed" => %{
          "units" => "mph",
          "value" => wind_speed
        },
        "direction" => %{
          "units" => "degrees",
          "value" => wind_direction
        }
      }
    }
  end

  defp is_valid_city(city) do
    Regex.match?(~r/[a-zA-Z\-]+/, city)
  end
end