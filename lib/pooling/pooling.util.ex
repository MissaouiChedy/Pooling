defmodule Pooling.Util do
  def measure(module, func, arg) do
        :timer.tc(module, func, arg)
        |> elem(0)
        |> Kernel./(1_000_000)
  end
end
