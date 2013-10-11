-module(ec_multiply).
-export([mult/3]).

-spec mult(number(), number(), number()) -> number().
mult(A, B, C) ->
  A * B * C.
