:- use_module(prolog/json_answer).
:- use_module(library(with_memory_file)).
:- use_module(library(yall)).

friend(mary, john).
friend(steve, bob).
friend(alex, luke).
friend(donna, eric).
friend(donna, mary).

foo(bar([1,2,3]), baz(qux)).
foo(bar([1,2,3,4,5]), baz(norf)).
foo(bar(true), baz(worble)).


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

test(term_to_dict) :-
    term_to_dict(foo(bar, baz(123)), _{ foo: [bar, _{baz: 123}] }).

test(term_to_dict_list) :-
    term_to_dict_list(foo(bar([1,2|_]), baz(_)), DictList),
    DictList = [_{foo:[_{bar:[1,2,3]},_{baz:qux}]},_{foo:[_{bar:[1,2,3,4,5]},_{baz:norf}]}].

test(term_to_dict_list) :-
    term_to_dict_list(foo(_, baz(_)), DictList),
    DictList = [
        _{foo:[_{bar:[1,2,3]},_{baz:qux}]},
        _{foo:[_{bar:[1,2,3,4,5]},_{baz:norf}]},
        _{foo:[_{bar:true},_{baz:worble}]}
    ],
    with_output_to(atom(Json), json:json_write_dict(current_output, DictList)),
    Json = '[
  {"foo": [ {"bar": [1, 2, 3 ]},  {"baz":"qux"} ]},
  {"foo": [ {"bar": [1, 2, 3, 4, 5 ]},  {"baz":"norf"} ]},
  {"foo": [ {"bar":true},  {"baz":"worble"} ]}
]'.

:- end_tests(query).
