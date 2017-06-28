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

  defp get_calculation_execution_time worker_pid, ident, count do
    Task.async(fn ->
      {:ok, 
        ident, 
        Pooling.Util.measure_execution_time(Pooling.Client, :calculate, [worker_pid, count])}
    end)
  end

  #
  # Launches a calculation time measure for each given worker
  defp run_with_workers worker_pids, range_size do
    calc_tasks = Enum.map(Enum.with_index(worker_pids), 
      fn {worker, index} ->
        get_calculation_execution_time(worker, index, range_size)
      end)
    
    Enum.each(calc_tasks, fn t -> 
      {:ok, ident, duration} = Task.await(t, Pooling.one_minute_timeout)
      IO.puts "#{ident} ==> #{duration}s"
    end)
  end

  def run_on_single_genserver run_count, range_size do  
    Enum.map(1..run_count, fn _ -> CalcServer end)
    |> run_with_workers(range_size)
  end

  def run_on_pool_of_genservers run_count, range_size do
    workers = Enum.map(1..run_count, fn _ -> :poolboy.checkout(:calc_pool) end)
    run_with_workers(workers, range_size)
    
    Enum.each(workers, fn w -> :poolboy.checkin(:calc_pool, w) end)
  end
end
