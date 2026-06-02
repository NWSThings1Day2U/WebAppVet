package modelo;

import org.apache.commons.mail2.jakarta.DefaultAuthenticator;
import org.apache.commons.mail2.jakarta.HtmlEmail;

/**
 *
 * @author USUARIO
 */
public class emailservicio {

    public static boolean enviarCodigo(
            String destinatario,
            String codigo) {

        try {

            HtmlEmail email = new HtmlEmail();
            email.setHostName("smtp.gmail.com");

            email.setSmtpPort(465);

            email.setAuthenticator(
                    new DefaultAuthenticator(
                            "reinadeldulceysabor@gmail.com",
                            "pssybfranxqgvinf"
                    )
            );
            email.setSSLOnConnect(true);

            email.setFrom(
                    "reinadeldulceysabor@gmail.com",
                    "Vet System"
            );

            email.setSubject(
                    "Recuperación de contraseña"
            );

            String html
                    = "<h3>Recuperación de contraseña</h3>"
                    + "<p>Has solicitado recuperar tu acceso.</p>"
                    + "<p>Tu código de verificación es:</p>"
                    + "<h2>" + codigo + "</h2>"
                    + "<p>Este código expirará en 15 minutos.</p>";

            email.setHtmlMsg(html);

            email.addTo(destinatario);

            email.send();

            return true;

        } catch (Exception e) {
            e.printStackTrace();

            Throwable causa = e.getCause();
            while (causa != null) {
                System.out.println("CAUSA: " + causa);
                causa = causa.getCause();
            }

            return false;
        }
    }
}
