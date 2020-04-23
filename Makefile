server:
	iex -S mix phx.server
ci:
	mix format --check-formatted
	mix credo
	mix dialyzer
	mix test
