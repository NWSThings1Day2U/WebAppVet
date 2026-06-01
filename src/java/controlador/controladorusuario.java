package controlador;

import dao.usuariodao;
import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import modelo.usuarios;

/**
 *
 * @author USUARIO
 */
@WebServlet(name = "controladorusuario", urlPatterns = {"/controladorusuario"})
public class controladorusuario extends HttpServlet {

    private usuariodao us = new usuariodao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String accion = request.getParameter("accion");

        if ("login".equals(accion)) {
            handleLogin(request, response);
        } else if ("registro".equals(accion)) {
            handleRegistro(request, response);
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String nombreusu = request.getParameter("usuario");
        String contra = request.getParameter("contrasena");
        String recordar = request.getParameter("recordar");

        usuarios usu = us.validar(nombreusu, contra);

        if (usu != null) {
            Cookie cUsuario = new Cookie("user_vet", nombreusu);
            cUsuario.setPath("/");
            if (recordar != null && recordar.equals("on")) {
                cUsuario.setMaxAge(60 * 60 * 24 * 30);
            } else {
                cUsuario.setMaxAge(0); 
            }
            response.addCookie(cUsuario);
            String fotoPerfil = (usu.getImagen() != null && !usu.getImagen().isEmpty()) 
                        ? usu.getImagen() 
                        : "gaa2.jpg";
            
            HttpSession sesion = request.getSession();
            sesion.setAttribute("usuario", usu.getNombreusuario());
            sesion.setAttribute("rol", usu.getRol());
            sesion.setAttribute("id", usu.getIdUsuario());
            sesion.setAttribute("imagen", fotoPerfil);
            sesion.setAttribute("dni", usu.getDni());
            sesion.setAttribute("nombrecompleto", usu.getNombrecompleto());
            sesion.setAttribute("telefono", usu.getTelefono());
            sesion.setAttribute("correo", usu.getCorreo());
            sesion.setAttribute("success", "Bienvenido " + usu.getNombreusuario());
            sesion.setAttribute("fecha", usu.getFechaRegistro());
            if ("admin".equals(usu.getRol())) {
                response.sendRedirect("controladorseccion?seccion=inicio");
            } else {
                response.sendRedirect("controladorpagina?pagina=inicio");
            }
        } else {
            request.getSession().setAttribute("error", "Datos incorrectos, intente de nuevo!");
            response.sendRedirect("index.jsp");
        }
    }

    private void handleRegistro(HttpServletRequest request, HttpServletResponse response) 
        throws IOException {
        String nombre = request.getParameter("nombre");
        String dni = request.getParameter("dni");
        String correo = request.getParameter("correo");
        String telefono = request.getParameter("telefono");
        String pass = request.getParameter("contrasena");

        String nombreForm = nombre.trim();
        String primerNombre = nombreForm.split(" ")[0].toLowerCase();
        String userDefecto = primerNombre + (System.currentTimeMillis() % 1000);

        if (us.registrar(userDefecto, pass, nombre, dni, correo, telefono)) {
            request.getSession().setAttribute("success", "¡Cuenta creada! Tu usuario es: " + userDefecto);
            response.sendRedirect("index.jsp");
        } else {
            request.getSession().setAttribute("error", "Error al registrar. El DNI o Correo ya existen.");
            response.sendRedirect("index.jsp?modo=registro");
        }
    }


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("index.jsp");
    }
}
