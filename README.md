Plug Microservice Example
==========================

Version: 0.0.1

Example microservice using the Elixir [Plug](https://github.com/elixir-lang/plug) framework

### Main libraries
* [Plug](https://github.com/elixir-lang/plug) - API Router, controllers
* [Poison](https://github.com/devinus/poison) - JSON Encoding/Decoding
* [HTTPoison](https://github.com/edgurgel/httpoison) - HTTP client request/response

### Test libraries
* [ExUnit](http://elixir-lang.org/docs/v1.1/ex_unit/ExUnit.html) - Unit testing framework (built-in)
* [Mock](https://github.com/jjh42/mock) - Mock testing framework
* [Coverex](https://github.com/alfert/coverex) - Code coverage report

### Deployment libraries
* [exrm](https://github.com/bitwalker/exrm) - Release packaging

## Create an API key

* Go to [OpenWeatherMap.org](http://openweathermap.org/api), sign up and copy the api key
* Uncomment the following line in config/config.exs

```
#config :plug_microservice, open_weather_map_app_id: "put-your-api-key-here"
```

* Replace the "put-your-api-key-here" with the api key from your OpenWeatherMap account

## Install dependencies and start the microservice

```
$ mix do deps.get, deps.compile
$ mix run --no-halt
```

## Run in interactive mode
```
$ iex -S mix
```

## Run unit tests
```
$ mix test
```

## Run unit tests (with coverage report generated in "cover" folder)
```
$ mix test --cover
```

## Build a release

```
$ mix release
```

## Start a packaged application

```
$ rel/plug_microservice/bin/plug_microservice start
```

## Stop a packaged application

```
$ rel/plug_microservice/bin/plug_microservice stop
```

## Run a packaged application in interactive mode

```
$ rel/plug_microservice/bin/plug_microservice console
```

## Tips

For easier Elixir file editing, use Sublime Text Package Control to install the [Elixir bundle](https://github.com/elixir-lang/elixir-tmbundle)
