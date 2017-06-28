defmodule Pooling do
  
  def one_minute_timeout, do: 60000 
  
  @doc ~S"""
	Returns the number of cores in the machine that runs this function
  """
  def core_count, do: :erlang.system_info(:schedulers_online)
  
  @doc ~S"""
	Runs the benchmark
	   `range_size` is the range maximum bound of the range
	   for which primes will be calculated
  """
  def run range_size \\ 20000 do
    IO.puts "#{core_count()} processes on single GenServer:"
    IO.puts "----------------------------------------------"
    run_on_single_genserver core_count(), range_size
    IO.puts "=============================================="
    IO.puts "#{core_count()} processes on pooled GenServers:"
    IO.puts "----------------------------------------------"
    run_on_pool_of_genservers core_count(), range_size
    IO.puts "=============================================="
  end
  
  @doc ~S"""
	Runs the operation on a single Pooling.Server instance
	(named CalcServer)
  """
  def run_on_single_genserver run_count, range_size do  
    Enum.map(1..run_count, fn _ -> CalcServer end)
    |> run_with_workers(range_size)
  end

  @doc ~S"""
	Runs the operation on a pool of Pooling.Server instance
	(named CalcServer)
		`run_count` represents the number of Pooling.Server instances
		that the pool will contain
  """
  def run_on_pool_of_genservers run_count, range_size do
    workers = Enum.map(1..run_count, fn _ -> :poolboy.checkout(:calc_pool) end)
    run_with_workers(workers, range_size)
    
    Enum.each(workers, fn w -> :poolboy.checkin(:calc_pool, w) end)
  end


  
  #  Launches a calculation time measure for each given worker
  #	    `worker_pids` is a list of pids or names representing 
  #	       a Pooling.Server instance
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

  
#	Launches an asynchronous task that runs and times a primes calculation
#		`worker_pid` represents the pid or name of the Pooling.Server instance
#		`ident` is a number that identifies the ran task
#		`range_size` is the range maximum bound of the range
#	   		for which primes will be calculated
  
  defp get_calculation_execution_time worker_pid, ident, range_size do
    Task.async(fn ->
      {:ok, 
        ident, 
        Pooling.Util.measure_execution_time(Pooling.Client, :calculate, [worker_pid, range_size])}
    end)
  end

end