DAY ONE
-------

    =     ...  bound once, matched next
    ''    ...  can be used for atoms
    ""    ...  for strings
    BIFs  ...  Built-In Functions (not actually written in erlang)
               Used in guard scope (they're so close to the VM)
               Cannot call just any function in a guard clause (well, NIFs...)


clever usage of periods can keep some functions "private"

a good practice is not going beyond two levels of indentation (cases, etc.)

monitoring proccess and applications

    pman:start(). ... for processes
    appmon:start(). ... for applications

erlang/otp handles releases and management of distributed systems right out of the box (but you knew that already)

otp gives you so much good stuff for free

"building large systems with erlang" ... the book that has yet to be written

sasl, lager

run otp app
`erl -pa ebin --env ERL_LIBs deps`


DAY TWO
-------

## It's a shell of a time.


Message passing fun

```
19> Shell = self().
<0.32.0>
20> Pid = spawn(fun() -> Shell ! self() end end).
* 1: syntax error before: 'end'
20> Pid = spawn(fun() -> Shell ! self() end).
<0.54.0>
21> Pid2 = spawn(fun() -> Shell ! self() end).
<0.56.0>
22> receive Pid -> Pid after 0 -> nope end.
<0.54.0>
23> receive Pid -> Pid after 0 -> nope end.
nope
24> receive Pid2 -> Pid2 after 0 -> nope end.
<0.56.0>
25> receive Pid2 -> Pid2 after 0 -> nope end.
nope
26> Pid3 = spawn(fun() -> Shell ! self(), Shell ! self(), Shell ! self() end).
<0.62.0>
27> receive Pid3 -> Pid3 after 0 -> nope end.
<0.62.0>
28> receive Pid3 -> Pid3 after 0 -> nope end.
<0.62.0>
29> receive Pid3 -> Pid3 after 0 -> nope end.
<0.62.0>
30> receive Pid3 -> Pid3 after 0 -> nope end.
nope
```

```
31> PidF = spawn(fun() -> receive Shell -> self() after 0 -> nope end end).
<0.69.0>
32> PidF ! Shell.
<0.32.0>
```
* Probably should tag the messages, though (i.e. `receive whats_your_number -> {my_number, self() }`).


```
36> Fun =
36>   fun() ->
36>   receive From -> From ! self() end
36> end.
#Fun<erl_eval.20.17052888>
37> Pid1 = spawn(Fun).
<0.76.0>
38> Pid2 = spawn(Fun).
** exception error: no match of right hand side value <0.78.0>
39> f([Pid2, Pid3]).
** exception error: no function clause matching call to f/1
40> f(Pid2, Pid3).
** exception error: undefined shell command f/2
41> f(Pid2).
ok
42> f(Pid3).
ok
43> f(Pid4).
ok
44> Pid2 = spawn(Fun).
<0.88.0>
45> Pid3 = spawn(Fun).
<0.90.0>
46> Pid1 ! Pid2 ! Pid3 ! self().
<0.83.0>
47> Pid1 ! Pid2 ! Pid3 ! self().
<0.83.0>
48> receive Msg1 -> Msg1 after 0 -> nope end.
<0.90.0>
49> receive Msg2 -> Msg2 after 0 -> nope end.
<0.88.0>
50> receive Msg3 -> Msg3 after 0 -> nope end.
<0.76.0>
```
* The cascading bang messaging syntax works bc of return values.

```
erl -name (domain name)
    -sname (shortn ame)
    -setcookie (for setting up network topology; not for security)

net_adm:ping(shortname)
auth:get_cookie()
```
epmd (erlang port mapper daemon; port 4369)

### Location transparency
ping adds node to list of known nodes (to self and recipient)

    node().     ... get name of this node (in form of `shortname@network`).
    nodes().    ... return list of known nodes.
    register(). ... give a pid a name.


    Pid::pid()
    Name::atom()
    NamedNode::{Name, node()}

```
(aleph@vagabond)3> register(shell, self()).
```

local registration
```
(aleph@vagabond)1> register(shell, self()).
(aleph@vagabond)2> shell ! hello.
(aleph@vagabond)3> hello
```

global registration
```
(karsh@vagabond)1> register(shell, self()).
(aleph@vagabond)4> {shell, 'karsh@vagabond'} ! {from, node()}.
(karsh@vagabond)2> receive Msg2 -> Msg2 after 0 -> error end.
{from,aleph@vagabond}
```

other nodes
```
Pid = spawn(fun() ->
  register(blah, self()),
  receive
    From -> From ! {from, node()}
    after 0 -> nope
  end
end).
```

main node
```
[{blah, Node} ! self() || Node <- nodes()].  % broadcast via a list comprehension against nodes().
```

remote shell via `crtl-g` --> `r` (list jobs with `j`, connect with `c [job_number]`)

remember
* processes are cheap
* architect truly concurrent systems
* erlang saves you from having to implement so much

fallacies of distributed computing (lol so true)
* network is reliable
* latency is zero
* bandwidth is infinite
* topology does not change
* there is one admin
* transport cost is zero
* network is homogeneous

healthy properties of a distributed system
* peer based: no leaders, masters, special nodes or central services (otp supervisor bridge)
* asynchronous: resilient, expect failure, simple, loosely coupled
* easy to debug: easy to interrogate, easy to determine state

sick systems
* not peer based
* 
* 
* 
