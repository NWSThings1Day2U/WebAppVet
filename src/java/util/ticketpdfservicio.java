package util;

import com.lowagie.text.Document;
import com.lowagie.text.DocumentException;
import com.lowagie.text.Font;
import com.lowagie.text.FontFactory;
import com.lowagie.text.Paragraph;
import com.lowagie.text.Element;
import com.lowagie.text.Chunk;
import com.lowagie.text.Image;
import com.lowagie.text.pdf.PdfWriter;
import com.lowagie.text.pdf.draw.DottedLineSeparator;
import java.io.OutputStream;
import java.awt.Color;
import java.io.IOException;
import jakarta.servlet.ServletContext; 
import modelo.citas;

public class ticketpdfservicio {

    public static boolean generarTicketCita(citas cita, OutputStream out, ServletContext context) throws DocumentException, IOException {
        try {
                // 1. Crear el documento PDF
            Document documento = new Document();
            PdfWriter.getInstance(documento, out);

            // 2. Abrir documento para escribir contenido
            documento.open();
            //paleta de colores
            Color verde = new Color(27, 94, 32);     
            Color naranjaPrimario = new Color(204, 70, 7);       
            Color grisOscuro = new Color(50, 50, 50);
            Color grisDetalle = new Color(108, 117, 125);       
            Color separadorColor = new Color(224, 224, 224);

            // Estilos de fuentes
            Font fuenteTitulo = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 14, naranjaPrimario);
            Font fuenteSubtitulo = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 11, verde);
            Font fuenteEtiqueta = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10, grisOscuro);
            Font fuenteValor = FontFactory.getFont(FontFactory.HELVETICA, 10, grisDetalle);
            Font fuentePie = FontFactory.getFont(FontFactory.HELVETICA_OBLIQUE, 9, verde);

            Font fuenteEstado;
            if (cita.getFechaRegistro() != null && !cita.getFechaRegistro().equalsIgnoreCase("PENDIENTE")) {
                fuenteEstado = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10, verde);
            } else {
                fuenteEstado = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10, naranjaPrimario);
            }

            try {
                String rutaLogo = context.getRealPath("/recursos/logoveet.png");
                if (rutaLogo != null) {
                    Image logo = Image.getInstance(rutaLogo);
                    logo.scaleToFit(60, 60); 
                    logo.setAlignment(Element.ALIGN_CENTER);
                    logo.setSpacingAfter(10);
                    documento.add(logo);
                }
            } catch (Exception e) {
                System.out.println("No se pudo cargar el logo en el PDF: " + e.getMessage());
            }

            // encabezado del pdf
            Paragraph clinicaNombre = new Paragraph("CLÍNICA VETERINARIA \"GALLITO DE LAS ROCAS\"", fuenteSubtitulo);
            clinicaNombre.setAlignment(Element.ALIGN_CENTER);
            documento.add(clinicaNombre);

            Paragraph titulo = new Paragraph("COMPROBANTE DE RESERVA DE CITA", fuenteTitulo);
            titulo.setAlignment(Element.ALIGN_CENTER);
            titulo.setSpacingAfter(10);
            documento.add(titulo);

            DottedLineSeparator lineaPuntos = new DottedLineSeparator();
            lineaPuntos.setLineColor(separadorColor);
            lineaPuntos.setGap(3f);
            documento.add(lineaPuntos);

            Paragraph espacio = new Paragraph(" ");
            espacio.setSpacingAfter(5);
            documento.add(espacio);

            // info de la cita
            agregarFila(documento, "Código de Cita: ", "#" + cita.getIdCita(), fuenteEtiqueta, fuenteValor);
            agregarFila(documento, "Cliente: ", cita.getCliente() != null ? cita.getCliente() : "No disponible", fuenteEtiqueta, fuenteValor);
            agregarFila(documento, "Mascota: ", cita.getMascota() != null ? cita.getMascota() : "No disponible", fuenteEtiqueta, fuenteValor);
            agregarFila(documento, "Fecha de Atención: ", cita.getFecha() != null ? cita.getFecha() : "No especificada", fuenteEtiqueta, fuenteValor);
            agregarFila(documento, "Hora Reservada: ", cita.getHora() != null ? cita.getHora() : "No especificada", fuenteEtiqueta, fuenteValor);
            agregarFila(documento, "Tipo de Servicio: ", cita.getTipoAtencion() != null ? cita.getTipoAtencion() : "No disponible", fuenteEtiqueta, fuenteValor);
            agregarFila(documento, "Motivo: ", cita.getMotivo() != null ? cita.getMotivo() : "No especificado", fuenteEtiqueta, fuenteValor);
            agregarFila(documento, "Fecha de Registro: ", cita.getFechaRegistro() != null ? cita.getFechaRegistro() : "No registrado", fuenteEtiqueta, fuenteEstado);

            // pie de pdf
            documento.add(espacio);
            documento.add(lineaPuntos);
            documento.add(espacio);

            Paragraph pie = new Paragraph("¡Gracias por confiar en nosotros el cuidado de tu mascota!", fuentePie);
            pie.setAlignment(Element.ALIGN_CENTER);
            documento.add(pie);

            // 3. Cerrar el documento
            documento.close();
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

    private static void agregarFila(Document doc, String etiqueta, String valor, Font fEtiqueta, Font fValor) throws DocumentException {
        Paragraph p = new Paragraph();
        p.add(new Chunk(etiqueta, fEtiqueta));
        p.add(new Chunk(valor, fValor));
        p.setSpacingAfter(6);
        doc.add(p);
    }
}