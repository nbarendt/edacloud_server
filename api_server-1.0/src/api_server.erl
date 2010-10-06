%% @author author <author@example.com>
%% @copyright YYYY author.

%% @doc api_server startup code

-module(api_server).
-author('author <author@example.com>').
-export([start/0, start_link/0, stop/0]).

ensure_started(App) ->
    case application:start(App) of
        ok ->
            ok;
        {error, {already_started, App}} ->
            ok
    end.

%% @spec start_link() -> {ok,Pid::pid()}
%% @doc Starts the app for inclusion in a supervisor tree
start_link() ->
    ensure_started(crypto),
    ensure_started(mochiweb),
    application:set_env(webmachine, webmachine_logger_module, 
                        webmachine_logger),
    ensure_started(webmachine),
    api_server_sup:start_link().

%% @spec start() -> ok
%% @doc Start the api_server server.
start() ->
    ensure_started(crypto),
    ensure_started(mochiweb),
    application:set_env(webmachine, webmachine_logger_module, 
                        webmachine_logger),
    ensure_started(webmachine),
    application:start(api_server).

%% @spec stop() -> ok
%% @doc Stop the api_server server.
stop() ->
    Res = application:stop(api_server),
    application:stop(webmachine),
    application:stop(mochiweb),
    application:stop(crypto),
    Res.
