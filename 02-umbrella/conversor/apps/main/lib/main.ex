defmodule Main do
  def main do
    IO.puts("Digite uma temperatura em Celsius:")
    celsius = get_float_input()
    fahrenheit = Conversor.Temperatura.c_para_f(celsius)
    IO.puts("Em Fahrenheit: #{fahrenheit}")

    IO.puts("Digite uma distância em metros:")
    metros = get_float_input()
    ft = Conversor.Distancia.m_para_ft(metros)
    IO.puts("Em pés: #{Float.round(ft, 4)}")
  end

  defp get_float_input do
    input = IO.gets("> ") |> String.trim()
    case Float.parse(input) do
      {valor, ""} -> valor
      _ ->
        IO.puts("Entrada inválida, tente novamente.")
        get_float_input()
    end
  end
end
