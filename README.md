# Compilador-base (JavaCC) – Início rápido

Projeto autocontido para Windows: o JDK 17 portável (`jdk/`) e o JavaCC (`lib/javacc.jar`) já estão incluídos.
Não é necessário instalar ferramentas de compilação nem ter permissão de administrador.

1. **Clone o repositório do GitHub** para uma pasta onde você tenha permissão de escrita. Com o Git instalado, use `git clone <URL-do-repositorio>`; também é possível clonar pelo GitHub Desktop ou pela opção **Code > Download ZIP**.
2. **Abra a pasta clonada** no VS Code (*Arquivo > Abrir Pasta*). Na primeira abertura, o VS Code pode oferecer as extensões recomendadas em `.vscode/extensions.json` (Java e suporte a JavaCC). A instalação é opcional para compilar e executar e precisa ser confirmada no VS Code.
3. Pressione **Ctrl+Shift+B** (Build & Run) para gerar o parser com o JavaCC incluído, compilar usando o JDK portável e executar os testes.
4. Ao final, o terminal exibe "Todos os testes passaram."

Depois de clonar e abrir o projeto — e de instalar as extensões, se desejado — basta usar **Ctrl+Shift+B**. O VS Code não instala extensões automaticamente por configuração de projeto; elas são instaladas no perfil do VS Code, não dentro da pasta do projeto.

Teste manual (terminal do VS Code, cmd):
- `scripts\build.bat executar "2 + 3 * 4"`
- Entrada padrão: `scripts\build.bat executar -`

## Testar uma entrada diferente dos testes pré-programados

No terminal do VS Code (cmd), depois de rodar o build ao menos uma vez com **Ctrl+Shift+B**:

- **Uma expressão:** `scripts\build.bat executar "2 * (3 + 4)"`
  Mostra `[OK] ... = resultado` ou `[ERRO] ...` com a mensagem do parser. O código de saída é 0 se a expressão for válida e 1 se não for.
- **Várias expressões:** `scripts\build.bat executar -` e digite uma expressão por linha. Para encerrar, use Ctrl+Z e Enter.
- **Alterar os testes automáticos:** edite as listas `validos` e `invalidos` em `src/Main.java`. Depois, rode o Ctrl+Shift+B.

## Como modificar o projeto

| Arquivo | O que define |
|---|---|
| `src/Calc.jj` | Gramática: tokens (analisador léxico) e regras (analisador sintático) com as ações semânticas |
| `src/Main.java` | Programa principal e testes |
| `build/` | Gerado automaticamente; não edite (está no `.gitignore`) |

Sempre que mudar `src/Calc.jj`, rode **Ctrl+Shift+B**. Ele regenera o parser em `build/gen`, recompila e executa os testes.

### Exemplo: implementar a divisão (`/`)

Hoje `4 / 2` é tratado como entrada **inválida**, porque o `/` não existe na gramática. Para suportá-lo:

**1. Declare o token em `src/Calc.jj`.** Acrescente `<DIV: "/">` ao bloco `TOKEN`:

```
TOKEN : {
  <PLUS: "+"> | <MINUS: "-"> | <TIMES: "*"> | <DIV: "/">
| <LP: "("> | <RP: ")">
| <NUM: (["0"-"9"])+>
}
```

**2. Adicione a regra.** A divisão tem a mesma precedência da multiplicação, então vai na regra `Termo`:

```
int Termo() : { int v, r; }
{
  v = Fator() ( <TIMES> r = Fator() { v *= r; }
              | <DIV>   r = Fator() { v /= r; } )*
  { return v; }
}
```

Atualize também o comentário da EBNF no topo do arquivo: `termo -> fator ( ("*" | "/") fator )*`.

**3. Trate a divisão por zero em `src/Main.java`.** `v /= r` lança `ArithmeticException` se `r` for 0, e o `catch` atual não a captura. Altere-o para:

```java
} catch (ParseException | TokenMgrError | ArithmeticException e) {
```

**4. Atualize os testes em `src/Main.java`.** Mova `"4 / 2"` de `invalidos` para `validos` e inclua casos novos:

```java
String[] validos = { "1 + 2 * 3", "(1 + 2) * 3", "10 - 2 - 3", "2 * (3 + 4) * 5",
                     "4 / 2", "20 / 5 / 2", "2 + 6 / 3" };
String[] invalidos = { "1 +", "2 * (3", "a + 1", "-4 + 1", "4 /", "1 / 0" };
```

**5. Teste.**

- Pressione **Ctrl+Shift+B**; deve aparecer "Todos os testes passaram."
- Teste manualmente: `scripts\build.bat executar "20 / 5 / 2"` deve mostrar `= 2`, e `scripts\build.bat executar "1 / 0"` deve mostrar `[ERRO] ... / by zero`.

A divisão é inteira (`7 / 2 = 3`), porque a gramática usa `int`. Para resultados decimais, troque os tipos `int` por `double` nas regras e use `Double.parseDouble` em `Fator`.

Para criar o seu compilador, edite `src/Calc.jj` e `src/Main.java`.
