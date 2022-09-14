:- module(json_answer, [query/1]).
:- use_module(library(http/json)).


% Lowers only the first character, so that a var name can be camel-cased
lowercase_atom(Atom, Atom2) :-
    atom_string(Atom, String),
    string_to_list(String, [C|Ls]),
    to_upper(C2, C),
    string_to_list(String2, [C2|Ls]),
    atom_string(Atom2, String2).


% Lowers the variable name of a ['X'=_A, 'Y'=_B] -esque value
lower_var(VarEq, VarEqLower) :-
    VarEq =.. [=, Key, Val],
    lowercase_atom(Key, Key2),
    VarEqLower =.. [=, Key2, Val].


query(Qs) :-
    open_string(Qs, S),
    read_term(S, T, [variable_names(Vars)]),
    maplist(lower_var, Vars, Vars2),
    dict_create(Dict, _, Vars2),
    bagof(Dict, T, Res),
    atom_json_dict(Json, Res, []),
    write(Json).
