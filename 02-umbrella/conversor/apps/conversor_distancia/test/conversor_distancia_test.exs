defmodule Conversor.DistanciaTest do
  use ExUnit.Case, async: true
  doctest Conversor.Distancia

  describe "Teste do Conversor de Distâncias" do
    test "m_para_ft/1 com inteiro aleatório" do
      valor = :rand.uniform(100)
      esperado = valor * 3.28084
      assert_in_delta Conversor.Distancia.m_para_ft(valor), esperado, 0.0001
    end

    test "ft_para_m/1 com inteiro aleatório" do
      valor = :rand.uniform(100)
      esperado = valor / 3.28084
      assert_in_delta Conversor.Distancia.ft_para_m(valor), esperado, 0.0001
    end
  end
end
