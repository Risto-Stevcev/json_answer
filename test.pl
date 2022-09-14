:- use_module(json_answer).

friend(mary, john).
friend(steve, bob).
friend(alex, luke).
friend(donna, eric).
friend(donna, mary).

run :-
  query("friend(donna, MyFriend).").

%% ?- run.
%% [ {"myFriend":"eric"},  {"myFriend":"mary"} ]
%% true.
