tftp-elixir
======

A thin layer of Elixir poured atop `tftp-hpa`.

### To use:

Add this repository as a dependency to your mix.exs, run `mix do deps.get deps.compile`, and then
```elixir
iex> TFTP.get "theirfile", "theirtftpserver"
:ok

iex> TFTP.put "myfile", "theirtftpserver"
:ok
```

For now, this assumes you (1) have a tftp client installed, (2) can execute said tftp client by entering `tftp` at a shell prompt, and (3) can pass arguments `-m` (for transfer mode) and `-c` (for command) to it.

