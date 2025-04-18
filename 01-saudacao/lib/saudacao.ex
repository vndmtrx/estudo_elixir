defmodule Saudacao do
  @moduledoc """
  Documentação para o módulo `Saudacao`
  - Módulo responsável por gerar saudações personalizadas
  """

  @doc """
  Retorna uma saudação com o nome informado

  ## Exemplos

      iex> Saudacao.ola("Dudu")
      "Olá, Dudu!"

  """
  def ola(nome) when is_binary(nome) do
    "Olá, #{nome}!"
  end
end
