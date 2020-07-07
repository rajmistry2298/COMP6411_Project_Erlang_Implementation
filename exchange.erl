%% @author rajmistry
%% @doc @todo Add description to exchange.

-module(exchange).

%% ====================================================================
%% API functions
%% ====================================================================

-export([print_And_Create_Process/1,display_Messages/0, start/0]).


%% ====================================================================
%% Internal functions
%% ====================================================================

%%Method To Print Calls To Be Made & Creating Process For Each Person
print_And_Create_Process(Tuple)->
						   {Sender,ContactList} = Tuple,
						   io:fwrite("~w: ~w \n",[Sender,ContactList]),
						   ProcessId = spawn(calling,message_Passing,[Sender,ContactList,self(),"start"]),
						   register(Sender,ProcessId).

%%Entry Point for exchange.erl (Master Process) 
start() ->
   	FileData = file:consult("calls.txt"),
	TupleList = element(2,FileData),
	io:fwrite("\n ** Calls To Be Made ** \n"),							
	[print_And_Create_Process(Tuple) || Tuple <- TupleList],
	io:fwrite("\n"),
	display_Messages().


%%Method For Displaying Responses From Processes About Receiving Message(Intro/Reply) From Other Process
display_Messages()->
    receive
		{introMessage,Sender,Receiver,Timestamp} ->
            io:fwrite("~w received intro message from ~w [~w]\n",[Sender,Receiver,Timestamp]),
            display_Messages();
		{replyMessage,Sender,Receiver,Timestamp} ->
            io:fwrite("~w received reply message from ~w [~w]\n",[Sender,Receiver,Timestamp]),
            display_Messages()
    after
        10000->
            io:fwrite("\nMaster has received no replies for 10 seconds, ending...\n")
    end.