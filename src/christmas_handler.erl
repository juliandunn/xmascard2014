-module(christmas_handler).
-behaviour(cowboy_http_handler).

-export([init/3]).
-export([handle/2]).
-export([terminate/3]).

-record(state, {}).

init(_, Req, _Opts) ->
    {ok, Req, #state{}}.

handle(Req, State=#state{}) ->
    {Date, Req2} = cowboy_req:header(<<"date">>,
                                     Req,
                                     <<"Thu, 01 Jan 1970 00:00:00 GMT">>),
    ReqDate = httpd_util:convert_request_date(binary_to_list(Date)),
    {DaysTillXmas, _} = calendar:time_difference(ReqDate,
                                                 {{2014,12,25},{0,0,0}}),
    Message = if DaysTillXmas > 0 -> "Not Erlangmas yet!";
                 DaysTillXmas == 0 -> "Happy Erlangmas!";
                 DaysTillXmas < 0 -> "Oh no, you missed Erlangmas!"
              end,
	{ok, Req3} = cowboy_req:reply(200,
                                  [{<<"content-type">>, <<"text/plain">>}],
                                  Message,
                                  Req2),
	{ok, Req3, State}.

terminate(_Reason, _Req, _State) ->
	ok.
