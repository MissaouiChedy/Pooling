defmodule Pooling.Core do
  def calc count do
    Enum.zip(0..count, 0..count)
      |> Enum.map(fn({l, r}) -> l*r end)
      |> Enum.reduce(0, fn(elem, acc) -> elem + acc end)
    end
end
