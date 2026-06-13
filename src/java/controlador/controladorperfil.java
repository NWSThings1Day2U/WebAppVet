package controlador;

import dao.citadao;
import dao.clientedao;
import dao.mascotadao;
import dao.perfildao;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import modelo.clientes;
import modelo.mascotas;
import modelo.usuarios;

@MultipartConfig
@WebServlet(name = "controladorperfil", urlPatterns = {"/controladorperfil"})
public class controladorperfil extends HttpServlet {

    private perfildao dao = new perfildao();
    private final citadao cdao = new citadao();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        String accion = request.getParameter("accion");
        if (accion == null) {
            accion = "listar";
        }

        switch (accion) {
            case "listar":
                listarmascotas(request, response);
                break;
            case "filtrarMascotas":
                filtrarMascotas(request, response);
                break;
            default:
                listarmascotas(request, response);
        }
    }

    private void listarmascotas(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer idUsuario = (Integer) session.getAttribute("id");
        String rol = (String) session.getAttribute("rol");

        request.setAttribute("paginaActual", "perfil");

        if ("cliente".equals(rol)) {
            clientedao clientedao = new clientedao();
            mascotadao mdao = new mascotadao();

            List<clientes> listaClientes = clientedao.listarClientesPorUsuario(idUsuario);
            request.setAttribute("listaClientes", listaClientes);

            List<mascotas> listaMascotas = mdao.listarTodasLasMascotasDelGrupo(listaClientes);
            request.setAttribute("listaMascotas", listaMascotas);
        }

        
        if ("admin".equals(rol)) {
            request.getRequestDispatcher("/vista/gperfil.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/vista/miperfil.jsp").forward(request, response);
        }
    }

    private void filtrarMascotas(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String idClienteParam = request.getParameter("idCliente");
        mascotadao mdao = new mascotadao();
        List<mascotas> lista = new ArrayList<>();

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        if (idClienteParam == null || idClienteParam.trim().isEmpty()) {
            HttpSession session = request.getSession();
            Integer idUsuario = (Integer) session.getAttribute("id");
            clientedao clientedao = new clientedao();
            List<clientes> listaClientes = clientedao.listarClientesPorUsuario(idUsuario);
            lista = mdao.listarTodasLasMascotasDelGrupo(listaClientes);
        } else {
            int idCliente = Integer.parseInt(idClienteParam);
            lista = mdao.listarMascotasxCliente(idCliente);
        }

        if (lista != null && !lista.isEmpty()) {
            for (mascotas m : lista) {
                String sexo = m.getSexo().equals("M") ? "Macho" : "Hembra";
                
                out.println("<div class='card car-vet shadow-sm m-0'>");
                out.println("  <h5 class='card-header sub1-vet'>" + m.getNombre() + "</h5>");
                out.println("  <div class='card-body'>");
                out.println("    <strong>Especie:</strong> " + m.getEspecie() + "<br>");
                out.println("    <strong>Raza:</strong> " + m.getRaza() + "<br>");
                out.println("    <strong>Sexo:</strong> " + sexo + "<br>");
                out.println("    <strong>Peso:</strong> " + m.getPeso() + " kg");
                out.println("  </div>");
                out.println("</div>");
            }
        } else {
            out.println("<div class='alert alert-info'>No se encontraron mascotas registradas para este cliente específico.</div>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer id = (Integer) session.getAttribute("id");

        if (id == null) {
            response.sendRedirect("controladorpagina?pagina=login");
            return;
        }

        usuarios usu = dao.obtenerPerfil(id);
        request.setAttribute("datosUsuario", usu);

        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer id = (Integer) session.getAttribute("id");

        if (id != null) {
            String nomUsu = request.getParameter("nombreUsuario");
            String nombre = request.getParameter("nombreCompleto");
            String correo = request.getParameter("correo");
            String tel = request.getParameter("telefono");
            String pass = request.getParameter("contrasena");
            String confirmPass = request.getParameter("confirmar_contrasena");
            String imagenActual = (String) session.getAttribute("imagen");        

            /*nuev img act 11-06-26*/
            Part archivo = request.getPart("imagenPerfil");
            System.out.println("Archivo recibido: " + archivo);
            if (archivo != null) {
                System.out.println("Nombre archivo: " + archivo.getSubmittedFileName());
                System.out.println("Tamaño: " + archivo.getSize());
            }
            String nuevaImagen = imagenActual;
            if (archivo != null && archivo.getSize() > 0) {
                String nombreArchivo
                        = System.currentTimeMillis() + "_"
                        + Paths.get(
                                archivo.getSubmittedFileName()
                        ).getFileName().toString();
                String ruta
                        = getServletContext()
                                .getRealPath("/recursos");
                File carpeta = new File(ruta);
                if (!carpeta.exists()) {
                    carpeta.mkdirs();
                }
                archivo.write(
                        ruta + File.separator + nombreArchivo
                );
                
                File archivoGuardado
                        = new File(ruta + File.separator + nombreArchivo);
                System.out.println("Existe: " + archivoGuardado.exists());
                System.out.println("Ruta completa: " + archivoGuardado.getAbsolutePath());
                System.out.println("Ruta recursos: " + ruta);
                nuevaImagen = nombreArchivo;
            }
            
            String msgError = null;

            if (tel != null && !tel.matches("\\d{9}")) {
                msgError = "El teléfono debe tener 9 dígitos numéricos.";
            } else if (correo != null && !correo.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
                msgError = "El formato del correo electrónico no es válido.";
            } else if (nombre == null || nombre.trim().isEmpty()) {
                msgError = "El nombre completo es obligatorio.";
            } else if (pass != null && !pass.isEmpty()) {
                if (pass.length() < 6) {
                    msgError = "La nueva contraseña debe tener al menos 6 caracteres.";
                } else if (!pass.equals(confirmPass)) {
                    msgError = "Las contraseñas no coinciden.";
                }
            }

            if (msgError != null) {
                session.setAttribute("error", msgError);
                session.setAttribute("editando", true);
                response.sendRedirect("controladorperfil");
                return;
            }

            if (nomUsu == null) {
                nomUsu = (String) session.getAttribute("usuario");
            }
            
            System.out.println("Imagen a guardar BD: " + nuevaImagen);
            boolean ok = dao.actualizarPerfil(id, nomUsu, nombre, correo, tel, pass, nuevaImagen);

            if (ok) {
                session.setAttribute("usuario", nomUsu);
                session.setAttribute("success", "¡Perfil actualizado con éxito!");
                session.setAttribute("imagen",nuevaImagen);
            } else {
                session.setAttribute("error", "Error al guardar: El correo ya podría estar en uso.");
            }

            response.sendRedirect("controladorperfil");
        } else {
            response.sendRedirect("controladorpagina?pagina=miperfil");
        }        
        
    }
}