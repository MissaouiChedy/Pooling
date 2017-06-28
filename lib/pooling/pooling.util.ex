defmodule Pooling.Util do
  def measure_execution_time(module, func, arg) do
        :timer.tc(module, func, arg)
        |> elem(0)
        |> Kernel./(1_000_000)
  end
end
