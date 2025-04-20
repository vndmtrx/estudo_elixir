defmodule Conversor.Distancia do
  @moduledoc """
  Conversão entre metros e pés.
  """

  @doc """
  Converte metros para pés.

      iex> Conversor.Distancia.m_para_ft(1) |> Float.round(4)
      3.2808
  """
  def m_para_ft(m) when is_number(m), do: m * 3.28084

  @doc """
  Converte pés para metros.

      iex> Conversor.Distancia.ft_para_m(1) |> Float.round(4)
      0.3048
  """
  def ft_para_m(ft) when is_number(ft), do: ft / 3.28084
end
