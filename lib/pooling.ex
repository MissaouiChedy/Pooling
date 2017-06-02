defmodule Pooling do
  
  def range_size, do: 1200000
  def one_minute_timeout, do: 60000 
  def core_count, do: 4
  
  def main do
    IO.puts "#{core_count()} processes on single GenServer:"
    IO.puts "----------------------------------------------"
    run_on_single_instance()
    IO.puts "=============================================="
    IO.puts "#{core_count()} processes on pooled GenServers:"
    IO.puts "----------------------------------------------"
    run_on_pooled()
    IO.puts "=============================================="
  end
  def run_on_single_instance do
    Pooling.Client.run_serial core_count()
  end

  def run_on_pooled do
    Pooling.Client.run_pooled core_count()
  end

end
