# Pooling

A small sample application that demonstrates *worker process contention* and how to address it with *worker pooling*.

This application measures the time it takes for the following operations:
 - 4 Tasks calling simultaneously the same genserver instance that performs CPU bound computation: calculating primes on given range, which can be expensive when the range is large
 - 4 Tasks which calls are dispatched to 4 pooled genserver instances that performs the same previous computation

The computation is defined under the `Pooling.Core.primes/1` function.


# Running the sample

Given that you have a elixir development environment installed:

- run `mix deps.get` to set up the project dependencies
- run `iex -S mix` to open an elixir shell session loaded with the Pooling application
- run `Pooling.run/1` in the iex session to run the sample(you can specify a range size, default is `20000`)

Here is a sample output:

```
iex(1)> Pooling.main
4 processes on single GenServer:
----------------------------------------------
0 ==> 0.765437s
1 ==> 1.408635s
2 ==> 2.0486s
3 ==> 2.695952s
==============================================
4 processes on pooled GenServers:
----------------------------------------------
0 ==> 1.280687s
1 ==> 1.137374s
2 ==> 1.222655s
3 ==> 1.240436s
==============================================

```
