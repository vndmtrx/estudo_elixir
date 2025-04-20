defmodule Conversor.Temperatura do
  @moduledoc """
  Conversão entre Celsius e Fahrenheit.
  """

  @doc """
  Converte Celsius para Fahrenheit.

      iex> Conversor.Temperatura.c_para_f(0)
      32.0
  """
  def c_para_f(c) when is_number(c), do: (c * 1.8) + 32

  @doc """
  Converte Fahrenheit para Celsius.

      iex> Conversor.Temperatura.f_para_c(212)
      100.0
  """
  def f_para_c(f) when is_number(f), do: (f - 32) / 1.8
end