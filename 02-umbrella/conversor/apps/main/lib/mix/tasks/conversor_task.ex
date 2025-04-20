defmodule Mix.Tasks.ConversorTask do
  use Mix.Task

  @shortdoc "Executa a aplicação interativa do conversor"
  def run(_args) do
    # Garante que os apps do umbrella estão carregados
    Mix.Task.run("app.start")

    # Chama a função interativa
    Main.main()
  end
end
