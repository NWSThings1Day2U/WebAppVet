
package conexion;

import java.sql.Connection;
import java.sql.DriverManager;

/**
 *
 * @author USUARIO
 */
public class conexionvet_bd {
    static String db = "vet_bd";
    static String url = "jdbc:mysql://127.0.0.1:3306/"+db;
    static String user = "root";
    static String pass = "sandy200509";
    
    public static Connection probarConexion() {
        Connection con = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            con = DriverManager.getConnection(url, user, pass);
            System.out.println("Conexion establecida con "+db);

        } catch (Exception e) {
            e.getMessage();
        }
        return con;
    }
}
