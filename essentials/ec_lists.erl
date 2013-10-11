-module(ec_lists).
-export([print_each/1, twomult/1, yourmap/2]).

print_each(List) ->
  print_each(lists:reverse(List), 1).
print_each([], _N) ->
  ok;
print_each([H|T], N) ->
  io:format("~p is a ~p~n", [N, H]),
  print_each(T, N+1).


twomult(List) ->
  twomult(lists:reverse(List), []).
twomult([], _Acc) ->
  ok;
twomult([Head|Tail], Acc) ->
  List = [(Head * 2)] ++ Acc,
  twomult(Tail, List).


yourmap(Fun, List) ->
  yourmap(Fun, List, []).
yourmap(_Fun, [], Acc) ->
  Acc;
yourmap(Fun, [Head|Tail], Acc) ->
  New = [Fun(Head)] ++ Acc,
  yourmap(Fun, Tail, New).
