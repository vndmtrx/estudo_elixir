defmodule ShuntingYard.Tokenizador do
  @moduledoc false

  @especiais ["+", "-", "*", "/", "%", "^", "(", ")"]
  @digitos Enum.to_list(?0..?9)

  # Função pública para iniciar a tokenização
  def tokenize(expressao), do: tokenize(expressao, [], "")

  # Fim da expressão
  defp tokenize(<<>>, acc, numero) do
    case numero do
      "" -> Enum.reverse(acc)
      _ -> Enum.reverse([numero | acc])
    end
  end

  # Caractere é dígito
  defp tokenize(<<c, resto::binary>>, acc, numero) when c in @digitos do
    tokenize(resto, acc, numero <> <<c>>)
  end

  # Caractere é operador
  defp tokenize(<<c, resto::binary>>, acc, numero) when <<c>> in @especiais do
    case numero do
      "" -> tokenize(resto, [<<c>> | acc], "")
      _ -> tokenize(resto, [<<c>> | [numero | acc]], "")
    end
  end

  # Espaço
  defp tokenize(<<" ", resto::binary>>, acc, numero) do
    case numero do
      "" -> tokenize(resto, acc, "")
      _ -> tokenize(resto, [numero | acc], "")
    end
  end

  # Caractere inválido: ignora
  defp tokenize(<<_c, resto::binary>>, acc, numero), do: tokenize(resto, acc, numero)
end
