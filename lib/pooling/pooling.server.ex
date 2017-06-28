defmodule Pooling.Server do
  use GenServer
  
  def start_link :named do
    GenServer.start_link(__MODULE__, [], name: CalcServer)
  end
  
  def start_link _ do
    GenServer.start_link(__MODULE__, [])
  end

  def init state do
    {:ok, state}
  end

  def handle_call {:calculate, count}, _from, state do
    {:reply, Pooling.Core.primes(count), state}
  end
end

defmodule Pooling.Client do
  def calculate CalcServer, count do
    GenServer.call(CalcServer, {:calculate, count}, Pooling.one_minute_timeout)
  end
  
  def calculate worker_pid, count do
    GenServer.call(worker_pid, {:calculate, count}, Pooling.one_minute_timeout)
  end
  
end