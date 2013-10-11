%% @doc adds two numbers together
-module(ec_add).
-export([add/2]).

-spec add(number(), number()) -> number().
add(A, B) ->
  A + B.
