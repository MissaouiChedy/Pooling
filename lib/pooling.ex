defmodule Pooling do
  
  def range_size, do: 20000
  def one_minute_timeout, do: 60000 
  def core_count, do: 4
  
  def main do
    IO.puts "#{core_count()} processes on single GenServer:"
    IO.puts "----------------------------------------------"
    Pooling.Client.run_on_single_genserver core_count()
    IO.puts "=============================================="
    IO.puts "#{core_count()} processes on pooled GenServers:"
    IO.puts "----------------------------------------------"
    Pooling.Client.run_on_pool_of_genservers core_count()
    IO.puts "=============================================="
  end
  
end
