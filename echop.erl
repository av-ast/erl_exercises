-module(echop).

-export([init/0, ping/1]).

init() ->
  register(echop, spawn(fun loop/0)).

ping(Message) ->
  echop ! {message, self(), Message},

  receive
    {reply, Reply} ->
      Reply
  end.

loop() ->
  receive
    {message, From, Message} ->
      From ! {reply, Message},
      loop()
  end.

