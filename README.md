# prolog-json-answer

Convenience module to convert a prolog query into a JSON answer for IPC.

This is useful for interop with prolog and another language.


## Usage

```sh
λ swipl -f test.pl -g 'use_module(json_answer).'  -g 'query("friend(donna, MyFriend).").' -g halt | jq
[
  {
    "myFriend": "eric"
  },
  {
    "myFriend": "mary"
  }
]
```


## License

See LICENSE
