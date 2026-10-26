import java.io.*;
import java.util.Scanner;

public class Main {
    static boolean avaliar(String entrada) {
        try {
            int r = new Calc(new StringReader(entrada)).Input();
            System.out.println("[OK]   " + entrada.trim() + " = " + r);
            return true;
        } catch (ParseException | TokenMgrError e) {
            System.out.println("[ERRO] " + entrada.trim() + " -> " + e.getMessage().split("\n")[0]);
            return false;
        }
    }

    public static void main(String[] args) {
        // "-" lê da entrada padrão; com argumentos avalia a expressão; sem nada roda os testes
        if (args.length > 0 && args[0].equals("-")) {
            try (Scanner sc = new Scanner(System.in)) {
                while (sc.hasNextLine()) avaliar(sc.nextLine());
            }
            return;
        }
        if (args.length > 0) {
            System.exit(avaliar(String.join(" ", args)) ? 0 : 1);
        }

        String[] validos = { "1 + 2 * 3", "(1 + 2) * 3", "10 - 2 - 3", "2 * (3 + 4) * 5" };
        String[] invalidos = { "1 +", "2 * (3", "4 / 2", "a + 1", "-4 + 1" };
        boolean ok = true;
        for (String s : validos) ok &= avaliar(s);
        for (String s : invalidos) ok &= !avaliar(s);
        System.out.println(ok ? "\nTodos os testes passaram." : "\nFALHA em algum teste.");
        System.exit(ok ? 0 : 1);
    }
}
