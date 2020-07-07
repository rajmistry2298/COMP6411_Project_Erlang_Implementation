%% @author rajmistry
%% @doc @todo Add description to calling.

-module(calling).

%% ====================================================================
%% API functions
%% ====================================================================
-export([send_Intro/2,message_Passing/4]).


%% ====================================================================
%% Internal functions
%% ====================================================================

send_Intro(Contact,Sender)->
	whereis(Contact)!{Sender,intro,element(3,now())}.

%%Method Which Will Be Called to Send Intro Message & Sending Response To Master For Printing Result. 
message_Passing(Sender,ContactList,MasterId,"start")->
			timer:sleep(round(timer:seconds(rand:uniform()))),
			[send_Intro(Contact,Sender) || Contact <- ContactList],
			message_Passing(Sender,ContactList,MasterId,"end");

message_Passing(Sender,ContactList,MasterId,"end")->		
				timer:sleep(50),
   	            receive
		                {CurrentProcess,intro,Timestamp} -> 
							MasterId!{introMessage,Sender,CurrentProcess,Timestamp},
		                    whereis(CurrentProcess)!{Sender,reply,Timestamp},
		                    message_Passing(Sender,ContactList,MasterId,"end");
		
		                {CurrentProcess,reply,Timestamp} ->  
							MasterId!{replyMessage,Sender,CurrentProcess,Timestamp},
		                    message_Passing(Sender,ContactList,MasterId,"end")
	            after
	                5000->
						io:fwrite("\nProcess ~w has received no calls for 5 second, ending...\n",[Sender])
				end.