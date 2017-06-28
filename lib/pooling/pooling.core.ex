defmodule Pooling.Core do
  @doc ~S"""
    Given an integer n, returns all the prime numbers in the range [1..n[
  """
  def primes n do
    Enum.filter(1..(n-1), 
      fn num -> is_prime?(num) end)
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
