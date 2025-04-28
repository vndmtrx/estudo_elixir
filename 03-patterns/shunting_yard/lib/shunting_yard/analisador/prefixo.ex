defmodule ShuntingYard.Analisador.Prefixo do
  @moduledoc false

  # Verifica se é número
  defp num?(token) do
    String.to_charlist(token)
    |> Enum.all?(&(&1 in ?0..?9))
  end

  # Verifica se é operador
  defp op?(token), do: token in ["+", "-", "*", "/", "%", "^"]

  # Valida a árvore final
  defp valida_ast({:ok, ast, []}), do: {:ok, ast}
  defp valida_ast({:ok, _ast, _resto}), do: {:error, :ast_invalido}
  defp valida_ast({:error, motivo}), do: {:error, motivo}

  # Função pública principal
  def parse(tokens) do
    tokens
    |> parse_tokens()
    |> valida_ast()
  end

  # Parse principal prefixo (recursivo)
  defp parse_tokens([]), do: {:error, :faltam_operandos}

  defp parse_tokens([token | resto]) do
    cond do
      num?(token) ->
        {:ok, {:num, token}, resto}

      op?(token) ->
        with {:ok, esq, resto1} <- parse_tokens(resto),
             {:ok, dir, resto2} <- parse_tokens(resto1) do
          {:ok, {:op, token, esq, dir}, resto2}
        else
          {:error, motivo} -> {:error, motivo}
        end

      true ->
        {:error, :token_invalido}
    end
  end
end
