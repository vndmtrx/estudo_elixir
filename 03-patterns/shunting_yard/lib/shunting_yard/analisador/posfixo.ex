defmodule ShuntingYard.Analisador.Posfixo do
  @moduledoc false

  # Verifica se é número
  defp num?(token) do
    String.to_charlist(token)
    |> Enum.all?(&(&1 in ?0..?9))
  end

  # Verifica se é operador
  defp op?(token), do: token in ["+", "-", "*", "/", "%", "^"]

  # Monta para número
  defp monta_ast({:num, num}, ast) do
    {:ok, [{:num, num} | ast]}
  end

  # Monta para operador
  defp monta_ast({:op, op}, [dir, esq | resto]) do
    {:ok, [{:op, op, esq, dir} | resto]}
  end

  # Erro se não tiver operandos suficientes
  defp monta_ast({:op, _op}, _ast) do
    {:error, :faltam_operandos}
  end

  # Valida a árvore final
  defp valida_ast([arvore]), do: {:ok, arvore}
  defp valida_ast(_), do: {:error, :ast_invalido}

  # Função pública principal
  def parse(tokens) do
    case parse(tokens, []) do
      {:ok, ast} -> valida_ast(ast)
      {:error, motivo} -> {:error, motivo}
    end
  end

  # Parse principal pós-fixo
  defp parse([], pilha), do: {:ok, pilha}

  defp parse([token | resto], pilha) do
    cond do
      num?(token) ->
        case monta_ast({:num, token}, pilha) do
          {:ok, nova_pilha} ->
            parse(resto, nova_pilha)
            # {:error, motivo} -> {:error, motivo}
        end

      op?(token) ->
        case monta_ast({:op, token}, pilha) do
          {:ok, nova_pilha} -> parse(resto, nova_pilha)
          {:error, motivo} -> {:error, motivo}
        end

      true ->
        {:error, :token_invalido}
    end
  end
end
