-module(cli_driver).

-export([sendto/1]).

-export([start_link/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
	terminate/2, code_change/3]).


-behavior(gen_server).

-record(state, {port, prompt}).

sendto(Msg) ->
	gen_server:call(?MODULE, {sendto, Msg}, 1000).

start_link({ExtProg, MaxLine, Prompt}) ->
	gen_server:start_link({local, ?MODULE}, cli_driver, {ExtProg, MaxLine, Prompt}, []).

init({ExtProg, MaxLine, Prompt}) ->
	process_flag(trap_exit, true),
	Port = open_port( {spawn, ExtProg}, [stream, {line, MaxLine}]),
	{ok, #state{port=Port, prompt=Prompt}}.

handle_call( {sendto, Msg}, _From, #state{port=Port, prompt=Prompt}=State) ->
	port_command(Port, Msg),
	case collect_response(Port, Prompt) of
		timeout ->
			{stop, port_timeout, State};
		Response ->
			{reply, Response, State}
	end.

collect_response(Port, Prompt) ->
	Result = lists:flatten(collect_response(Port, 1000, [], [])),
	lists:subtract(Result, Prompt).

collect_response(Port, Timeout, RespAcc, LineAcc) ->
	receive
		{Port, {data, {eol, "OK"}}} ->
			lists:reverse(RespAcc);
		{Port, {data, {eol, Result}}} ->
			Result1 = [Result | "\n"],
			Line = lists:reverse([Result1 | LineAcc]),
			collect_response(Port, Timeout, [Line | RespAcc], []);
		{Port, {data, {noeol, PartialLine}}} ->
			collect_response(Port, Timeout, RespAcc, [PartialLine | LineAcc])
	after Timeout ->
		timeout
	end.

handle_info( {'EXIT', Port, Reason}, #state{port=Port}=State) ->
	{stop, {port_terminated, Reason}, State}.

terminate({port_terminated, _Reason}, _State) ->
	ok;
terminate(_Reason, #state{port=Port}=_State) ->
	port_close(Port).

handle_cast(_Msg, State) ->
	{noreply, State}.

code_change(_OldVsn, State, _Extra) ->
	{ok, State}.

