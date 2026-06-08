package util;

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

            String html= "<div style='font-family: Arial, sans-serif; max-width:600px; margin:auto; border:1px solid #ddd; border-radius:10px; overflow:hidden;'>"
                + "<div style='background:#198754; color:white; padding:20px; text-align:center;'>"
                + "<h1 style='margin:0;'>Clinica Veterinaria Gallito de las Rocas</h1>"
                + "</div>"
                + "<div style='padding:25px;'>"
                + "<h2 style='color:#198754;'>Recuperacion de contrasena</h2>"
                + "<p>Estimado(a) usuario,</p>"
                + "<p>Hemos recibido una solicitud para recuperar el acceso a su cuenta.</p>"
                + "<p>Utilice el siguiente codigo de verificacion:</p>"

                + "<div style='background:#f8f9fa; padding:20px; border-radius:8px; "
                + "border-left:5px solid #198754; text-align:center;'>"
                + "<h1 style='margin:0; color:#198754; letter-spacing:5px;'>"
                + codigo
                + "</h1>"
                + "</div>"

                + "<p style='margin-top:20px;'>Este codigo expirara en 15 minutos.</p>"
                + "<p>Si usted no solicito este proceso, ignore este mensaje.</p>"
                + "<hr>"
                + "<p style='font-size:12px; color:gray;'>"
                + "Este mensaje fue enviado automaticamente por Vet System."
                + "</p>"
                + "</div>"
                + "</div>";

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

    public static boolean enviarConfirmacionCita(
            String destinatario,
            String cliente,
            String mascota,
            String fecha,
            String hora,
            String tipoAtencion) {

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

            email.setSubject("Confirmación de cita veterinaria");

            String html
                    = "<div style='font-family: Arial, sans-serif; max-width:600px; margin:auto; border:1px solid #ddd; border-radius:10px; overflow:hidden;'>"
                    + "<div style='background:#198754; color:white; padding:20px; text-align:center;'>"
                    + "<h1 style='margin:0;'>Clinica Veterinaria 'Gallito de las Rocas'</h1>"
                    + "</div>"
                    + "<div style='padding:25px;'>"
                    + "<h2 style='color:#198754;'> Cita Confirmada</h2>"
                    + "<p>Estimado(a) <strong>" + cliente + "</strong>,</p>"
                    + "<p>Le informamos que su cita veterinaria ha sido confirmada con exito.</p>"
                    + "<div style='background:#f8f9fa; padding:15px; border-radius:8px; border-left:5px solid #198754;'>"
                    + "<p><strong> Mascota:</strong> " + mascota + "</p>"
                    + "<p><strong> Fecha:</strong> " + fecha + "</p>"
                    + "<p><strong> Hora:</strong> " + hora + "</p>"
                    + "<p><strong> Tipo de atencion:</strong> " + tipoAtencion + "</p>"
                    + "</div>"
                    + "<p style='margin-top:20px;'>Por favor, llegue unos minutos antes de la hora programada.</p>"
                    + "<p>Gracias por confiar en nosotros.</p>"
                    + "<hr>"
                    + "<p style='font-size:12px; color:gray;'>"
                    + "Este mensaje fue enviado automaticamente por Vet System."
                    + "</p>"
                    + "</div>"
                    + "</div>";

            email.setHtmlMsg(html);

            email.addTo(destinatario);

            email.send();

            return true;

        } catch (Exception e) {

            e.printStackTrace();
            return false;

        }
    }
}
