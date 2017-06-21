defmodule Pooling.Core do
  def calc count do
    Enum.zip(0..count, 0..count)
      |> Enum.map(fn({l, r}) -> l*r end)
      |> Enum.reduce(0, fn(elem, acc) -> elem + acc end)
  end

  def primes n do
    Enum.filter(1..(n-1), fn num -> is_prime?(num) end)
  end

  def is_prime? 1 do
    true
  end

  def is_prime?(n) when (n > 1) do
    is_prime?(n, n-1)
  end

  defp is_prime? _n, 1 do
    true
  end

  defp is_prime?(n, d) when rem(n,d) == 0 do
    false
  end
  
  defp is_prime?(n, d) do
    is_prime?(n, d-1)
  end
end
