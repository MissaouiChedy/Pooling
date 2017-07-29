# Pooling

A small sample application that demonstrates *worker process contention* and how to address it with *worker pooling* as discussed in the [genserver contention and what to do about it](http://blog.techdominator.com/article/genserver-contention-and-what-to-do-about-it.html) article.


Given the number of cores in the machine `n`, this application measures the time it takes for the following operations:
 - `n` Tasks calling simultaneously the same `Pooling.Server` GenServer instance that performs a CPU bound computation: calculating primes on a given range, which can be expensive when the range is large
 - `n` Tasks which simultaneous calls are dispatched to `n` pooled `Pooling.Server` GenServer instances that performs the same previous computation

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

Obviously, it will not be interesting to run the example on a single core machine.
