%% @author author <author@example.com>
%% @copyright YYYY author.

%% @doc Callbacks for the api_server application.

-module(api_server_app).
-author('author <author@example.com>').

-behaviour(application).
-export([start/2,stop/1]).


%% @spec start(_Type, _StartArgs) -> ServerRet
%% @doc application start callback for api_server.
start(_Type, _StartArgs) ->
    api_server_sup:start_link().

%% @spec stop(_State) -> ServerRet
%% @doc application stop callback for api_server.
stop(_State) ->
    ok.
