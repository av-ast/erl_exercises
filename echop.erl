-module(echop).

-export([start/0, print/1, stop/0]).

start() ->
  register(echop, spawn(fun loop/0)).

print(Term) ->
  case whereis(echop) of
    undefined ->
      error(not_registered);
    Pid ->
      Pid ! {message, self(), Term},
      receive
        {reply, Reply} ->
          Reply
      end
  end.

stop() ->
  echop ! stop.

loop() ->
  receive
    {message, From, Message} ->
      From ! {reply, Message},
      loop();
    stop ->
      exit(self(), normal)
  end.

