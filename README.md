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

Para criar o seu compilador, edite `src/Calc.jj` e `src/Main.java`.
