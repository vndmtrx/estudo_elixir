defmodule Conversor.TemperaturaTest do
  use ExUnit.Case, async: true
  doctest Conversor.Temperatura

  describe "Teste do Conversor de Temperaturas" do
    test "c_para_f/1 com inteiro aleatório" do
      valor = :rand.uniform(100) - 50
      esperado = (valor * 1.8) + 32
      assert_in_delta Conversor.Temperatura.c_para_f(valor), esperado, 0.0001
    end

    test "f_para_c/1 com inteiro aleatório" do
      valor = :rand.uniform(212)
      esperado = (valor - 32) / 1.8
      assert_in_delta Conversor.Temperatura.f_para_c(valor), esperado, 0.0001
    end
  end
end
