defmodule ShuntingYard.Analisador.Prefixo do
  @moduledoc false

  # Verifica se é número
  defp num?(token) do
    String.to_charlist(token)
    |> Enum.all?(&(&1 in ?0..?9))
  end

  # Verifica se é operador
  defp op?(token), do: token in ["+", "-", "*", "/", "%", "^"]

  # Monta a AST para número
  defp monta_ast({:num, num}), do: {:ok, {:num, num}}

  # Monta a AST para operador
  defp monta_ast({:op, op, esq, dir}), do: {:ok, {:op, op, esq, dir}}

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

  # Parse principal prefixo (interno)
  defp parse_tokens([]), do: {:error, :faltam_operandos}

  defp parse_tokens([token | resto]) do
    cond do
      num?(token) ->
        case monta_ast({:num, token}) do
          {:ok, ast} ->
            {:ok, ast, resto}
            # {:error, motivo} -> {:error, motivo}
        end

      op?(token) ->
        with {:ok, esq, resto1} <- parse_tokens(resto),
             {:ok, dir, resto2} <- parse_tokens(resto1),
             {:ok, ast} <- monta_ast({:op, token, esq, dir}) do
          {:ok, ast, resto2}
        else
          {:error, motivo} -> {:error, motivo}
        end

      true ->
        {:error, :token_invalido}
    end
  end
end
