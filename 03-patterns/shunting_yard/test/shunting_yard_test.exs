defmodule ShuntingYardTest do
  use ExUnit.Case
  doctest ShuntingYard

  describe "tokenize/1" do
    test "expressão simples" do
      assert ShuntingYard.tokenize("1+2*3") == ["1", "+", "2", "*", "3"]
    end

    test "expressão com parênteses" do
      assert ShuntingYard.tokenize("(1+2)*3") == ["(", "1", "+", "2", ")", "*", "3"]
    end

    test "ignora caracter inválido" do
      assert ShuntingYard.tokenize("(1+A)*3") == ["(", "1", "+", ")", "*", "3"]
    end

    test "expressão vazia" do
      assert ShuntingYard.tokenize("") == []
    end
  end

  describe "parse/2 - infixo" do
    test "parse de expressão infixa correta" do
      assert {:ok, _ast} =
               "1+2*3"
               |> ShuntingYard.tokenize()
               |> ShuntingYard.parse(:infixo)
    end

    test "erro - parêntese a mais" do
      assert {:error, :falta_par_esq} =
               "2*(3+4))"
               |> ShuntingYard.tokenize()
               |> ShuntingYard.parse(:infixo)
    end

    test "erro - parêntese faltando" do
      assert {:error, :falta_par_dir} =
               "(1+2*3"
               |> ShuntingYard.tokenize()
               |> ShuntingYard.parse(:infixo)
    end

    test "erro - operador sobrando" do
      assert {:error, :faltam_operandos} =
               "1++2"
               |> ShuntingYard.tokenize()
               |> ShuntingYard.parse(:infixo)
    end

    test "erro - faltam operandos" do
      assert {:error, :faltam_operandos} =
               ["(", "+", "1", ")"]
               |> ShuntingYard.parse(:infixo)
    end

    test "erro - token inválido" do
      assert {:error, :token_invalido} ==
               ["1", "+", "2", "-", "@"]
               |> ShuntingYard.parse(:infixo)
    end

    test "erro - árvore inválida" do
      assert {:error, :ast_invalido} =
               ["1", "2", "3"]
               |> ShuntingYard.parse(:infixo)
    end
  end

  describe "parse/2 - prefixo" do
    test "parse de expressão prefixa correta" do
      assert {:ok, _ast} =
               "+ 1 * 2 3"
               |> ShuntingYard.tokenize()
               |> ShuntingYard.parse(:prefixo)
    end

    test "erro - operandos a mais" do
      assert {:error, :ast_invalido} =
               "+ 1 2 3"
               |> ShuntingYard.tokenize()
               |> ShuntingYard.parse(:prefixo)
    end

    test "erro - operandos faltando" do
      assert {:error, :faltam_operandos} =
               "+ 1"
               |> ShuntingYard.tokenize()
               |> ShuntingYard.parse(:prefixo)
    end

    test "erro - token inválido" do
      assert {:error, :token_invalido} ==
               ["+", "@", "1"]
               |> ShuntingYard.parse(:prefixo)
    end

    test "erro - árvore inválida" do
      assert {:error, :ast_invalido} =
               ["1", "2", "3"]
               |> ShuntingYard.parse(:prefixo)
    end
  end

  describe "parse/2 - posfixo" do
    test "parse de expressão posfixa correta" do
      assert {:ok, _ast} =
               "1 2 3 * +"
               |> ShuntingYard.tokenize()
               |> ShuntingYard.parse(:posfixo)
    end

    test "erro - operadores a mais" do
      assert {:error, :faltam_operandos} =
               "1 2 3 + + +"
               |> ShuntingYard.tokenize()
               |> ShuntingYard.parse(:posfixo)
    end

    test "erro - operandos faltando" do
      assert {:error, :faltam_operandos} =
               "1 2 + +"
               |> ShuntingYard.tokenize()
               |> ShuntingYard.parse(:posfixo)
    end

    test "erro - token inválido" do
      assert {:error, :token_invalido} ==
               ["1", "@", "+"]
               |> ShuntingYard.parse(:posfixo)
    end

    test "erro - árvore inválida" do
      assert {:error, :ast_invalido} =
               ["1", "2", "3"]
               |> ShuntingYard.parse(:posfixo)
    end
  end

  describe "parse/2 - notação invalida" do
    test "erro - opção invalida" do
      assert {:error, :notacao_invalida} =
               "1 2 3 * +"
               |> ShuntingYard.tokenize()
               |> ShuntingYard.parse(:invalido)
    end
  end

  describe "formatadores" do
    test "ast_para_posfixo/1 converte corretamente" do
      assert "1 2 3 * +" =
               "1+2*3"
               |> ShuntingYard.tokenize()
               |> ShuntingYard.parse(:infixo)
               |> ShuntingYard.ast_para_posfixo()
    end

    test "ast_para_prefixo/1 converte corretamente" do
      assert "+ 1 * 2 3" =
               "1+2*3"
               |> ShuntingYard.tokenize()
               |> ShuntingYard.parse(:infixo)
               |> ShuntingYard.ast_para_prefixo()
    end

    test "propaga erro em ast_para_posfixo/1" do
      assert {:error, :qualquer} = ShuntingYard.ast_para_posfixo({:error, :qualquer})
    end

    test "propaga erro em ast_para_prefixo/1" do
      assert {:error, :qualquer} = ShuntingYard.ast_para_prefixo({:error, :qualquer})
    end
  end

  describe "eval/1" do
    test "avalia corretamente expressão infixa" do
      assert 7 =
               "1+2*3"
               |> ShuntingYard.tokenize()
               |> ShuntingYard.parse(:infixo)
               |> ShuntingYard.eval()
    end

    test "avalia corretamente expressão prefixa" do
      assert 7 =
               "+ 1 * 2 3"
               |> ShuntingYard.tokenize()
               |> ShuntingYard.parse(:prefixo)
               |> ShuntingYard.eval()
    end

    test "avalia corretamente expressão posfixa" do
      assert 7 =
               "1 2 3 * +"
               |> ShuntingYard.tokenize()
               |> ShuntingYard.parse(:posfixo)
               |> ShuntingYard.eval()
    end

    test "avalia todos os operandos" do
      assert 84 =
               "8+9*2^3-9/2+11%3*4"
               |> ShuntingYard.tokenize()
               |> ShuntingYard.parse(:infixo)
               |> ShuntingYard.eval()
    end

    test "propaga erro na avaliação" do
      assert {:error, :qualquer} = ShuntingYard.eval({:error, :qualquer})
    end
  end
end
