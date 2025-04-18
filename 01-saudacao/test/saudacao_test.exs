defmodule SaudacaoTest do
  use ExUnit.Case, async: true
  doctest Saudacao

    test "retorna uma saudação personalizada" do
      assert Saudacao.ola("Dudu") == "Olá, Dudu!"
    end

    test "retorna corretamente com nomes diferentes" do
      assert Saudacao.ola("Leitor") == "Olá, Leitor!"
    end
end
