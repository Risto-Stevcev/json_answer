:- use_module(json_answer).
:- use_module(library(with_memory_file)).
:- use_module(library(yall)).

friend(mary, john).
friend(steve, bob).
friend(alex, luke).
friend(donna, eric).
friend(donna, mary).

:- begin_tests(query).

test('query/2') :-
    with_memory_file(
        string(String),
        write,
        [OutputStream]>>query('friend(donna, MyFriend).', OutputStream)
    ),
    String = "[ {\"myFriend\":\"eric\"},  {\"myFriend\":\"mary\"} ]".

test('query/1') :-
    with_output_to(string(String), query('friend(donna, MyFriend).')),
    String = "[ {\"myFriend\":\"eric\"},  {\"myFriend\":\"mary\"} ]".

:- end_tests(query).
