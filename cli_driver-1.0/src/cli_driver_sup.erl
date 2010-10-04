-module(cli_driver_sup).

-behaviour(supervisor).

%% API
-export([start_link/1]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

start_link({ExtProg, MaxLine, Prompt}) ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, {ExtProg, MaxLine, Prompt}).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init({ExtProg, MaxLine, Prompt}) ->
	{ok, { {one_for_one, 3, 10},
		[{cli_driver, {cli_driver, start_link, [{ExtProg, MaxLine, Prompt}]},
			permanent, 10, worker, [cli_driver]}]}}.
