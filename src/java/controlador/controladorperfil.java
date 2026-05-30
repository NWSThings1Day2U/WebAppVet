/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import dao.perfildao;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import modelo.usuarios;

/**
 *
 * @author USUARIO
 */
@WebServlet(name = "controladorperfil", urlPatterns = {"/controladorperfil"})
public class controladorperfil extends HttpServlet {

    private perfildao dao = new perfildao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer id = (Integer) session.getAttribute("id");
        String rol = (String) session.getAttribute("rol");

        if (id != null) {
            usuarios usu = dao.obtenerPerfil(id);
            request.setAttribute("datosUsuario", usu);
            request.setAttribute("paginaActual", "perfil");

            if ("admin".equals(rol)) {
                request.getRequestDispatcher("/vista/gperfil.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/vista/miperfil.jsp").forward(request, response);
            }
        } else {
            response.sendRedirect("controladorpagina?pagina=login");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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

            String msgError = null;

            if (tel != null && !tel.matches("\\d{9}")) {
                msgError = "El teléfono debe tener 9 dígitos numéricos.";
            } 
            else if (correo != null && !correo.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
                msgError = "El formato del correo electrónico no es válido.";
            } 
            else if (nombre == null || nombre.trim().isEmpty()) {
                msgError = "El nombre completo es obligatorio.";
            } 
            else if (pass != null && !pass.isEmpty()) {
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

            boolean ok = dao.actualizarPerfil(id, nomUsu, nombre, correo, tel, pass, imagenActual);

            if (ok) {
                session.setAttribute("usuario", nomUsu);
                session.setAttribute("success", "¡Perfil actualizado con éxito!");
            } else {
                session.setAttribute("error", "Error al guardar: El correo ya podría estar en uso.");
            }

            response.sendRedirect("controladorperfil");
        } else {
            response.sendRedirect("controladorpagina?pagina=miperfil");
        }
    }
}
