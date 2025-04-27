defmodule ShuntingYard.Formatador do
  @moduledoc false

  ## Pós-fixa

  def ast_para_posfixo({:ok, ast}), do: ast_para_posfixo(ast)
  def ast_para_posfixo({:error, motivo}), do: {:error, motivo}
  def ast_para_posfixo({:num, valor}), do: valor

  def ast_para_posfixo({:op, op, esq, dir}) do
    esq_str = ast_para_posfixo(esq)
    dir_str = ast_para_posfixo(dir)
    [esq_str, dir_str, op] |> Enum.join(" ")
  end

  ## Pré-fixa

  def ast_para_prefixo({:ok, ast}), do: ast_para_prefixo(ast)
  def ast_para_prefixo({:error, motivo}), do: {:error, motivo}
  def ast_para_prefixo({:num, valor}), do: valor

  def ast_para_prefixo({:op, op, esq, dir}) do
    esq_str = ast_para_prefixo(esq)
    dir_str = ast_para_prefixo(dir)
    [op, esq_str, dir_str] |> Enum.join(" ")
  end
end
