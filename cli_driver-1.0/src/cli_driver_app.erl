-module(cli_driver_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    PrivDir = code:priv_dir(cli_driver),
    {ok, ExtProg} = application:get_env(cli_driver, extprog),
    {ok, MaxLine} = application:get_env(cli_driver, maxline),
    {ok, Prompt}  = application:get_env(cli_driver, prompt),
    cli_driver_sup:start_link({filename:join([PrivDir, ExtProg]), MaxLine, Prompt}).

stop(_State) ->
    ok.
