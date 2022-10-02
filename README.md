# prolog-json-answer

Convenience module to convert a prolog query into a JSON answer for IPC.

This is useful for interop with prolog and another language.


## Usage

```sh
$ swipl -f prolog/json_answer.pl \
  -g 'assert(foo(bar, baz))' -g 'assert(foo(bar, qux))' \
  -g 'term_to_dict_list(foo(bar,_), D), json:json_write_dict(current_output, D)' \
  -g halt
[ {"foo": ["bar", "baz" ]},  {"foo": ["bar", "qux" ]} ]
```


## License

See LICENSE
