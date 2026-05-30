package modelo;

import org.mindrot.jbcrypt.BCrypt;

public class encriptar {
    public static String encriptar(String password) {
        return BCrypt.hashpw(password, BCrypt.gensalt());
    }

    public static boolean verificar(String passwordEscrita, String hashBD) {
        return BCrypt.checkpw(passwordEscrita, hashBD);
    }
}
