:- module(json_answer, [query/1, query/2, term_to_dict/2, term_to_dict_list/2]).
:- use_module(library(http/json)).

/** <module> Parse prolog compound terms into json
 */

%! lowercase_atom(+Atom, -Atom)
%
% Lowers only the first character, so that a var name can be camel-cased
lowercase_atom(Atom, Atom2) :-
    atom_string(Atom, String),
    string_to_list(String, [C|Ls]),
    to_upper(C2, C),
    string_to_list(String2, [C2|Ls]),
    atom_string(Atom2, String2).

%! lower_var(+VarEq, -VarEqLower) is semidet
%
% Lowers the variable name of a ['X'=_A, 'Y'=_B] -esque value
%
% @see lowercase_atom/2
lower_var(VarEq, VarEqLower) :-
    VarEq =.. [=, Key, Val],
    lowercase_atom(Key, Key2),
    VarEqLower =.. [=, Key2, Val].

%! query(+Term, +Stream) is semidet
%
% Writes the JSON to the given stream
%
% @deprecated term_to_dict_list/2
query(Qs, OutputStream) :-
    open_string(Qs, S),
    read_term(S, T, [variable_names(Vars)]),
    maplist(lower_var, Vars, Vars2),
    dict_create(Dict, _, Vars2),
    bagof(Dict, T, Res),
    atom_json_dict(Json, Res, []),
    write(OutputStream, Json).

%! query(+Term) is semidet
%
% Outputs JSON to current_output
%
% @deprecated term_to_dict_list/2
query(Qs) :-
    query(Qs, current_output).

%! term_to_dict(+Term, -Dict) is semidet
%
% Converts a compound term to a dict
term_to_dict(Term, Dict) :-
    (compound(Term), not(is_list(Term)) ->
         Term =.. [Key,Value|Values],
         (member(_, Values) ->
              maplist(term_to_dict, [Value|Values], DictValue) ;
              term_to_dict(Value, DictValue)
         ),
         dict_create(Dict, _, [Key-DictValue]) ;
     (is_list(Term) ->
          maplist(term_to_dict, Term, Dict) ;
          Dict = Term)
    ).

%! term_to_dict_list(+Term, -DictList) is semidet
%
% Converts a compound term to a list of dicts
%
% ==
% ?- assert(friend(alex, luke)),
%    assert(friend(donna, eric)),
%    assert(friend(donna, mary)).
% true
% ?- term_to_dict_list(friend(donna, _), DictList),
%    json:json_write_dict(current_output, DictList).
% [ {"friend": ["donna", "eric" ]},  {"friend": ["donna", "mary" ]} ]
% DictList = [_{friend:[donna, eric]}, _{friend:[donna, mary]}].
% ==
term_to_dict_list(Term, DictList) :-
    callable(Term),
    findall(Dict, (call(Term), term_to_dict(Term, Dict)), DictList).
