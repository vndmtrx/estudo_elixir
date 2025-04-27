defmodule ShuntingYard.Analisador.Infixo do
  @moduledoc false

  require Logger

  @ops %{
    "+" => %{prec: 1, assoc: :esq},
    "-" => %{prec: 1, assoc: :esq},
    "*" => %{prec: 2, assoc: :esq},
    "/" => %{prec: 2, assoc: :esq},
    "%" => %{prec: 2, assoc: :esq},
    "^" => %{prec: 3, assoc: :dir}
  }

  # Verifica se é número
  defp num?(token) do
    String.to_charlist(token)
    |> Enum.all?(&(&1 in ?0..?9))
  end

  # Verifica se é operador
  defp op?(token), do: Map.has_key?(@ops, token)

  # Retorna precedência do operador
  defp prec(op), do: @ops[op][:prec]

  # Retorna associatividade do operador
  defp assoc(op), do: @ops[op][:assoc]

  # Testa se a precedência e associatividade do op exigem que a pilha seja desempilhada
  defp desempilha_op?(op, [op_pilha | _]) do
    case {op?(op_pilha), prec(op), prec(op_pilha), assoc(op)} do
      {false, _, _, _} -> false
      {true, o1, o2, _} when o1 < o2 -> true
      {true, o1, o2, :esq} when o1 == o2 -> true
      _ -> false
    end
  end

  # Monta a AST parcial para um número
  defp monta_ast({:num, num}, ast) do
    {:ok, [{:num, num} | ast]}
  end

  # Monta a AST parcial para um operador
  defp monta_ast({:op, op}, [dir, esq | resto]) do
    {:ok, [{:op, op, esq, dir} | resto]}
  end

  # Dispara erro se não têm operandos suficientes
  defp monta_ast({:op, _op}, _ast) do
    {:error, :faltam_operandos}
  end

  # Valida a árvore AST final
  defp valida_ast([arvore]), do: {:ok, arvore}
  defp valida_ast(_), do: {:error, :ast_invalido}

  # Função pública principal
  def parse(tokens) do
    case parse(tokens, [], []) do
      {:ok, ast} -> valida_ast(ast)
      {:error, motivo} -> {:error, motivo}
    end
  end

  # Parse final sem mais tokens
  defp parse([], [], arvore), do: {:ok, arvore}
  defp parse([], ["(" | _], _arvore), do: {:error, :falta_par_dir}

  defp parse([], [op | pilha], arvore) do
    case monta_ast({:op, op}, arvore) do
      {:ok, nova_arvore} -> parse([], pilha, nova_arvore)
      {:error, motivo} -> {:error, motivo}
    end
  end

  # Parse enquanto houver tokens
  defp parse([token | resto], pilha, arvore) do
    cond do
      num?(token) ->
        case monta_ast({:num, token}, arvore) do
          {:ok, nova_arvore} -> parse(resto, pilha, nova_arvore)
        end

      op?(token) ->
        {nova_arvore, nova_pilha} = desempilha_ops(token, arvore, pilha)
        parse(resto, [token | nova_pilha], nova_arvore)

      token == "(" ->
        parse(resto, ["(" | pilha], arvore)

      token == ")" ->
        case desempilha_ate_par(arvore, pilha) do
          {:ok, nova_arvore, nova_pilha} -> parse(resto, nova_pilha, nova_arvore)
          {:error, motivo} -> {:error, motivo}
        end

      true ->
        {:error, :token_invalido}
    end
  end

  # Desempilha operadores enquanto necessário
  defp desempilha_ops(_op, arvore, []), do: {arvore, []}

  defp desempilha_ops(op, arvore, [op_pilha | resto_pilha]) do
    if desempilha_op?(op, [op_pilha]) do
      case monta_ast({:op, op_pilha}, arvore) do
        {:ok, nova_arvore} -> desempilha_ops(op, nova_arvore, resto_pilha)
        {:error, motivo} -> {:error, motivo}
      end
    else
      {arvore, [op_pilha | resto_pilha]}
    end
  end

  # Desempilha até encontrar parêntese "("
  defp desempilha_ate_par(arvore, ["(" | resto_pilha]), do: {:ok, arvore, resto_pilha}

  defp desempilha_ate_par(arvore, [op | resto_pilha]) do
    case monta_ast({:op, op}, arvore) do
      {:ok, nova_arvore} -> desempilha_ate_par(nova_arvore, resto_pilha)
      {:error, motivo} -> {:error, motivo}
    end
  end

  defp desempilha_ate_par(_, []), do: {:error, :falta_par_esq}
end
