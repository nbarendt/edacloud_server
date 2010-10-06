-module(api_server_SUITE).

-compile(export_all).

-include("ct.hrl").

% Common Test Callbacks
all() -> 
    [
    test_verify_api_server_started,
    test_client_can_ping_api_server].

init_per_suite(Config) ->
	Config.

end_per_suite(Config) ->
	Config.

init_per_testcase(TestCase, Config) ->
    ok = api_server:start(),
    ok = application:start(cli_driver),
    Config.

end_per_testcase(TestCase, Config) ->
    ok = application:stop(cli_driver),
    ok = api_server:stop(),
	Config.

test_verify_api_server_started(Config) ->
    {error, {already_started, api_server}} = application:start(api_server).

test_client_can_ping_api_server(Config) ->
    "OK (localhost:8000)\n" = cli_driver:sendto("ping\n"),
	ok.
