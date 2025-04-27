defmodule ShuntingYard do
  @moduledoc """
  Interface principal para tokenizar, parsear, formatar e avaliar expressões infixas, prefixas e posfixas.
  """

  @doc """
  Tokeniza uma expressão.

  ## Exemplos

      iex> ShuntingYard.tokenize("1+2*3")
      ["1", "+", "2", "*", "3"]

      iex> ShuntingYard.tokenize("(1+2)*3")
      ["(", "1", "+", "2", ")", "*", "3"]

      iex> ShuntingYard.tokenize("1++2")
      ["1", "+", "+", "2"]
  """
  def tokenize(expressao), do: ShuntingYard.Tokenizador.tokenize(expressao)

  @doc """
  Constrói uma AST a partir de uma lista de tokens, de acordo com a notação especificada.

  A notação pode ser:
  - `:infixo` — Expressão normal (ex: `"1 + 2 * 3"`)
  - `:prefixo` — Operadores antes dos operandos (ex: `"+ 1 * 2 3"`)
  - `:posfixo` — Operadores depois dos operandos (ex: `"1 2 3 * +"`)

  ## Exemplos

  ### Infixa

      iex> "1+2*3"
      ...> |> ShuntingYard.tokenize()
      ...> |> ShuntingYard.parse(:infixo)
      {:ok, {:op, "+", {:num, "1"}, {:op, "*", {:num, "2"}, {:num, "3"}}}}

      iex> "(1+2)*3"
      ...> |> ShuntingYard.tokenize()
      ...> |> ShuntingYard.parse(:infixo)
      {:ok, {:op, "*", {:op, "+", {:num, "1"}, {:num, "2"}}, {:num, "3"}}}

      iex> "1++2"
      ...> |> ShuntingYard.tokenize()
      ...> |> ShuntingYard.parse(:infixo)
      {:error, :faltam_operandos}

  ### Prefixa

      iex> "+ 1 * 2 3"
      ...> |> ShuntingYard.tokenize()
      ...> |> ShuntingYard.parse(:prefixo)
      {:ok, {:op, "+", {:num, "1"}, {:op, "*", {:num, "2"}, {:num, "3"}}}}

      iex> "+ 1 2 3"
      ...> |> ShuntingYard.tokenize()
      ...> |> ShuntingYard.parse(:prefixo)
      {:error, :ast_invalido}

      iex> "+ 1"
      ...> |> ShuntingYard.tokenize()
      ...> |> ShuntingYard.parse(:prefixo)
      {:error, :faltam_operandos}

  ### Posfixa

      iex> "1 2 3 * +"
      ...> |> ShuntingYard.tokenize()
      ...> |> ShuntingYard.parse(:posfixo)
      {:ok, {:op, "+", {:num, "1"}, {:op, "*", {:num, "2"}, {:num, "3"}}}}

      iex> "1 2 3 + + +"
      ...> |> ShuntingYard.tokenize()
      ...> |> ShuntingYard.parse(:posfixo)
      {:error, :faltam_operandos}

      iex> "1 2 + +"
      ...> |> ShuntingYard.tokenize()
      ...> |> ShuntingYard.parse(:posfixo)
      {:error, :faltam_operandos}
  """
  def parse(tokens, tipo) do
    case tipo do
      :infixo -> ShuntingYard.Analisador.Infixo.parse(tokens)
      :prefixo -> ShuntingYard.Analisador.Prefixo.parse(tokens)
      :posfixo -> ShuntingYard.Analisador.Posfixo.parse(tokens)
      _ -> {:error, :notacao_invalida}
    end
  end

  @doc """
  Converte uma AST para uma expressão pós-fixa (string).

  ## Exemplos

      iex> "1+2*3"
      ...> |> ShuntingYard.tokenize()
      ...> |> ShuntingYard.parse(:infixo)
      ...> |> ShuntingYard.ast_para_posfixo()
      "1 2 3 * +"
  """
  def ast_para_posfixo(ast), do: ShuntingYard.Formatador.ast_para_posfixo(ast)

  @doc """
  Converte uma AST para uma expressão pré-fixa (string).

  ## Exemplos

      iex> "(1+2)*3"
      ...> |> ShuntingYard.tokenize()
      ...> |> ShuntingYard.parse(:infixo)
      ...> |> ShuntingYard.ast_para_prefixo()
      "* + 1 2 3"
  """
  def ast_para_prefixo(ast), do: ShuntingYard.Formatador.ast_para_prefixo(ast)

  @doc """
  Avalia uma AST e retorna o resultado.

  ## Exemplos

      iex> "1+2*3"
      ...> |> ShuntingYard.tokenize()
      ...> |> ShuntingYard.parse(:infixo)
      ...> |> ShuntingYard.eval()
      7

      iex> "(1+2)*3"
      ...> |> ShuntingYard.tokenize()
      ...> |> ShuntingYard.parse(:infixo)
      ...> |> ShuntingYard.eval()
      9
  """
  def eval(ast), do: ShuntingYard.Interpretador.eval(ast)
end
