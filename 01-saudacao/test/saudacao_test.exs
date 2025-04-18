defmodule SaudacaoTest do
  use ExUnit.Case, async: true
  doctest Saudacao

  describe "ola/1" do
    test "retorna uma saudação personalizada" do
      assert Saudacao.ola("Dudu") == "Olá, Dudu!"
    end

    test "retorna corretamente com nomes diferentes" do
      assert Saudacao.ola("Leitor") == "Olá, Leitor!"
  end
end