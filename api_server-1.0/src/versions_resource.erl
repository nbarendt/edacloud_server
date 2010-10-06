%% @author author <author@example.com>
%% @copyright YYYY author.
%% @doc Example webmachine_resource.

-module(versions_resource).
-export([init/1, to_json/2, content_types_provided/2]).

-include_lib("webmachine/include/webmachine.hrl").

init([]) -> {ok, undefined}.

content_types_provided(ReqData, State) ->
    {[{"application/json", to_json}], ReqData, State}.

to_json(ReqData, State) ->
    VersionList = ["/api/v2010-06-28"],
    VersionsStruct = {array, VersionList},
    Links = {struct, [{versions, VersionsStruct}]},
    Versions = {struct, [{links, Links}]}, 
    EncodedVersions = mochijson:encode(Versions),
    {EncodedVersions, ReqData, State}.

