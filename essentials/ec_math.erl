-module(ec_math).
-export([op/3]).

-spec op(add | sub, number(), number()) -> number() | error.
op(add, A, B) ->
  A + B;
op(sub, A, B) when A < B ->
  error;
op(sub, A, B) ->
  A - B.
