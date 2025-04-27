defmodule ShuntingYard.Interpretador do
  @moduledoc false

  # Avalia AST (versão que aceita {:ok, ast} ou {:error, motivo})
  def eval({:ok, ast}), do: eval(ast)
  def eval({:error, motivo}), do: {:error, motivo}

  # Avalia número
  def eval({:num, valor}), do: String.to_integer(valor)

  # Avalia operador
  def eval({:op, op, esq, dir}) do
    funcao = operador(op)
    funcao.(eval(esq), eval(dir))
  end

  # Retorna a função correspondente a cada operador
  defp operador("+"), do: &Kernel.+/2
  defp operador("-"), do: &Kernel.-/2
  defp operador("*"), do: &Kernel.*/2
  defp operador("/"), do: &div/2
  defp operador("%"), do: &rem/2
  defp operador("^"), do: fn a, b -> :math.pow(a, b) |> round() end
end
