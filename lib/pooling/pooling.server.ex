#
#  GenServer that provides a handl_call operation for calculating primes
#
defmodule Pooling.Server do
  use GenServer
  
  @doc ~S"""
    Starts a GenServer instance named 'CalcServer'
    which is the 'single instance' used to demonstrate contention
  """
  def start_link :named do
    GenServer.start_link(__MODULE__, [], name: CalcServer)
  end
  
  @doc ~S"""
    Starts a GenServer instance this is used by the pool to
    create Pooling.Server instances
  """
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

#
#  Small client module for the Pooling.Server GenServer
#
defmodule Pooling.Client do
  def calculate CalcServer, count do
    GenServer.call(CalcServer, {:calculate, count}, Pooling.one_minute_timeout)
  end
  
  def calculate worker_pid, count do
    GenServer.call(worker_pid, {:calculate, count}, Pooling.one_minute_timeout)
  end
  
end