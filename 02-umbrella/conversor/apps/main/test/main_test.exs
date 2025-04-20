defmodule MainTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  test "main/0 realiza interação com o usuário" do
    output =
      capture_io("100\n10\n", fn ->
        Main.main()
      end)

    assert output =~ "Digite uma temperatura em Celsius:"
    assert output =~ "Em Fahrenheit: 212.0"
    assert output =~ "Digite uma distância em metros:"
    assert output =~ "Em pés: 32.8084"
  end
end
