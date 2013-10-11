-module(ec_recur).
-export([loop/1, sum_seq/1, hr/1]).

-spec loop(integer()) -> ok.

loop(0) ->
  ok;
loop(N) ->
  loop(N-1).

-spec sum_seq(integer()) -> integer().
sum_seq(0) ->
  0;
sum_seq(N) ->
  N + sum_seq(N-1).

hr(N) ->
  hr("-", N-1).
hr(Acc, 0) ->
  Acc ++ "-";
hr(Acc, N) ->
  hr(Acc ++ "-", N-1).
