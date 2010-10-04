-module(api_server_SUITE).

-compile(export_all).

-include("ct.hrl").

% Common Test Callbacks
all() -> 
	[test1].

init_per_suite(Config) ->
	Config.

end_per_suite(Config) ->
	Config.

init_per_testcase(TestCase, Config) ->
    ok = application:start(cli_driver),
	Config.

end_per_testcase(TestCase, Config) ->
    ok = application:stop(cli_driver),
	Config.

test1(Config) ->
    cli_driver:sendto("Hello World!\n"),
	ok.
