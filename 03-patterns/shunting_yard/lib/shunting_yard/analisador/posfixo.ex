defmodule ShuntingYard.Analisador.Posfixo do
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
  defp valida_ast({:ok, [ast]}), do: {:ok, ast}
  defp valida_ast({:ok, _}), do: {:error, :ast_invalido}
  defp valida_ast({:error, motivo}), do: {:error, motivo}

  # Função pública principal
  def parse(tokens) do
    tokens
    |> parse([])
    |> valida_ast()
  end

  # Parse principal pós-fixo
  defp parse([], pilha), do: {:ok, pilha}

  defp parse([token | resto], pilha) do
    cond do
      num?(token) ->
        case monta_ast({:num, token}) do
          {:ok, num} ->
            parse(resto, [num | pilha])
            # {:error, motivo} -> {:error, motivo}
        end

      op?(token) ->
        case pilha do
          [dir, esq | resto_pilha] ->
            case monta_ast({:op, token, esq, dir}) do
              {:ok, op} ->
                parse(resto, [op | resto_pilha])
                # {:error, motivo} -> {:error, motivo}
            end

          _ ->
            {:error, :faltam_operandos}
        end

      true ->
        {:error, :token_invalido}
    end
  end
end
