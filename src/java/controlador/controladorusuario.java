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
import util.emailservicio;
import modelo.usuarios;

/**
 *
 * @author USUARIO
 */
@WebServlet(name = "controladorusuario", urlPatterns = {"/controladorusuario"})
public class controladorusuario extends HttpServlet {

    private usuariodao us = new usuariodao();
    
    // Constantes para el control de bloqueo
    private static final int MAX_INTENTOS = 5;
    private static final long TIEMPO_BLOQUEO_MS = 5 * 60 * 1000; // 5 minutos en milisegundos

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");

        if ("login".equals(accion)) {
            handleLogin(request, response);
        } else if ("registro".equals(accion)) {
            handleRegistro(request, response);
        } else if ("recuperar".equals(accion)) {
            handleRecuperar(request, response); // Paso 1: Enviar email
        } else if ("verificar".equals(accion)) {
            handleVerificar(request, response); // Paso 2 y 3: Validar código y cambiar pass
        } else if ("reenviar".equals(accion)) {
            handleReenviar(request, response);
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        HttpSession sesion = request.getSession();

        // 1. VERIFICACIÓN DE BLOQUEO TEMPORAL (Se mantiene intacto al inicio)
        Long horaBloqueo = (Long) sesion.getAttribute("horaBloqueo");
        if (horaBloqueo != null) {
            long tiempoTranscurrido = System.currentTimeMillis() - horaBloqueo;

            if (tiempoTranscurrido < TIEMPO_BLOQUEO_MS) {
                long minutosRestantes = ((TIEMPO_BLOQUEO_MS - tiempoTranscurrido) / 1000) / 60;
                long segundosRestantes = ((TIEMPO_BLOQUEO_MS - tiempoTranscurrido) / 1000) % 60;

                sesion.setAttribute("error", "Demasiados intentos fallidos. Su ingreso está bloqueado. Intente de nuevo en " 
                        + minutosRestantes + " min y " + segundosRestantes + " seg.");
                response.sendRedirect("index.jsp");
                return;
            } else {
                sesion.removeAttribute("horaBloqueo");
                sesion.removeAttribute("intentosFallidos");
            }
        }

        String nombreusu = request.getParameter("usuario");
        String contra = request.getParameter("contrasena");
        String recordar = request.getParameter("recordar");

        usuarios usu = us.validar(nombreusu, contra);

        if (usu != null) {
            if (usu.getEstadoCliente() != 1) { 
                sesion.setAttribute("error", "Su cuenta está inhabilitada. Contacte al administrador.");
                response.sendRedirect("index.jsp");
                return;
            }

            // Conservamos temporalmente los datos del usuario autenticado
            usuarios usuarioAutenticado = usu;

            // Invalidamos la sesión vieja que contenía los intentos fallidos
            sesion.invalidate();

            // Creamos una sesión completamente nueva y limpia con un nuevo SessionID
            HttpSession nuevaSesion = request.getSession(true);
            // ----------------------------------------

            // --- MEJORA: COOKIE SEGURA ---
            Cookie cUsuario = new Cookie("user_vet", nombreusu);
            // Define la ruta exacta de la app
            cUsuario.setPath(request.getContextPath().isEmpty() ? "/" : request.getContextPath());
            cUsuario.setHttpOnly(true); // Protege contra robos de JS

            // true en producción (HTTPS), false para pruebas en localhost (HTTP)
            cUsuario.setSecure(request.isSecure()); 

            if (recordar != null && recordar.equals("on")) {
                cUsuario.setMaxAge(60 * 60 * 24 * 30); // 30 días
            } else {
                cUsuario.setMaxAge(0); // Eliminar si no se marca
            }
            response.addCookie(cUsuario);
            // ------------------------------

            String fotoPerfil = (usuarioAutenticado.getImagen() != null && !usuarioAutenticado.getImagen().isEmpty())
                    ? usuarioAutenticado.getImagen()
                    : "gaa2.jpg";

            // Registramos los atributos en la NUEVA sesión segura
            nuevaSesion.setAttribute("usuario", usuarioAutenticado.getNombreusuario());
            nuevaSesion.setAttribute("rol", usuarioAutenticado.getRol());
            nuevaSesion.setAttribute("id", usuarioAutenticado.getIdUsuario());
            nuevaSesion.setAttribute("imagen", fotoPerfil);
            nuevaSesion.setAttribute("dni", usuarioAutenticado.getDni());
            nuevaSesion.setAttribute("nombrecompleto", usuarioAutenticado.getNombrecompleto());
            nuevaSesion.setAttribute("telefono", usuarioAutenticado.getTelefono());
            nuevaSesion.setAttribute("correo", usuarioAutenticado.getCorreo());
            nuevaSesion.setAttribute("success", "Bienvenido " + usuarioAutenticado.getNombreusuario());
            nuevaSesion.setAttribute("fecha", usuarioAutenticado.getFechaRegistro());

            if ("admin".equals(usuarioAutenticado.getRol())) {
                response.sendRedirect("controladorseccion?seccion=inicio");
            } else {
                response.sendRedirect("controladorpagina?pagina=inicio");
            }
        } else {
            // LOGIN FALLIDO: Se mantiene en la sesión actual para no perder el conteo
            Integer intentos = (Integer) sesion.getAttribute("intentosFallidos");
            if (intentos == null) {
                intentos = 0;
            }
            intentos++;
            sesion.setAttribute("intentosFallidos", intentos);

            if (intentos >= MAX_INTENTOS) {
                sesion.setAttribute("horaBloqueo", System.currentTimeMillis());
                sesion.setAttribute("error", "Has alcanzado el límite de 5 intentos fallidos. Acceso bloqueado por 5 minutos.");
            } else {
                int intentosRestantes = MAX_INTENTOS - intentos;
                sesion.setAttribute("error", "Usuario o contraseña incorrectos. Te quedan " + intentosRestantes + " intentos.");
            }

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
            request.getSession().setAttribute("registroExitoso", "¡Bienvenido(a) a la plataforma! Tu usuario es: " + userDefecto);
            response.sendRedirect("index.jsp");
        } else {
            request.getSession().setAttribute("error", "Error al registrar. El DNI o Correo ya existen.");
            response.sendRedirect("index.jsp?modo=registro");
        }
    }

    private void handleRecuperar(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String correo = request.getParameter("mail");
        String codigo = String.format("%06d", new java.util.Random().nextInt(1000000));

        int idUsuario = us.iniciarRecuperacion(correo, codigo);

        if (idUsuario > 0) {
            boolean enviado  = emailservicio.enviarCodigo(correo, codigo);

            if (!enviado) {
                request.getSession().setAttribute( "error",  "No fue posible enviar el correo."
                );

                response.sendRedirect("index.jsp?modo=olvido");

                return;
            }
            request.getSession().setAttribute("idRecuperacion", idUsuario);
            request.getSession().setAttribute("correoRecuperacion",correo);
            String correoOculto = correo.replaceAll("(?<=.{2}).(?=[^@]*?@)", "*");

            request.getSession().setAttribute(
                    "correoOculto",
                    correoOculto
            );
            request.getSession().setAttribute("success", "Código enviado a tu correo.");
            response.sendRedirect("index.jsp?modo=olvido&paso=2");
        } else {
            request.getSession().setAttribute("error", "Correo no encontrado.");
            response.sendRedirect("index.jsp?modo=olvido");
        }
    }

    private void handleVerificar(HttpServletRequest request, HttpServletResponse response) throws IOException {

        Integer id = (Integer) request.getSession().getAttribute("idRecuperacion");
        HttpSession session = request.getSession();

        if (id == null) {

            response.sendRedirect("index.jsp?modo=olvido");
            return;
        }
        String c1 = request.getParameter("c1");
        String c2 = request.getParameter("c2");
        String c3 = request.getParameter("c3");
        String c4 = request.getParameter("c4");
        String c5 = request.getParameter("c5");
        String c6 = request.getParameter("c6");

        if (c1 == null || c2 == null || c3 == null
                || c4 == null || c5 == null || c6 == null
                || c1.isBlank() || c2.isBlank() || c3.isBlank()
                || c4.isBlank() || c5.isBlank() || c6.isBlank()) {

            request.getSession().setAttribute(
                    "error",
                    "Ingrese el código completo."
            );

            response.sendRedirect("index.jsp?modo=olvido&paso=2");
            return;
        }
        String codigo = c1 + c2 + c3 + c4 + c5 + c6;

        String nuevaPass = request.getParameter("contrasena");
        String confirmarPass = request.getParameter("confirmar_contrasena");

        if (nuevaPass == null
                || confirmarPass == null
                || !nuevaPass.equals(confirmarPass)) {

            request.getSession().setAttribute(
                    "error",
                    "Las contraseñas no coinciden."
            );

            response.sendRedirect("index.jsp?modo=olvido&paso=2");
            return;
        }
        if (nuevaPass.length() < 6) {

            request.getSession().setAttribute(
                    "error",
                    "La contraseña debe tener al menos 6 caracteres."
            );

            response.sendRedirect("index.jsp?modo=olvido&paso=2");
            return;
        }

        if (us.verificarYActualizar(id, codigo, nuevaPass)) {

            session.removeAttribute("idRecuperacion");
            session.removeAttribute("correoRecuperacion");
            session.removeAttribute("ultimoEnvioCodigo");

            session.setAttribute(
                    "success",
                    "La contraseña fue actualizada correctamente. Inicie sesión con sus nuevas credenciales."
            );

            response.sendRedirect(
                    "index.jsp?modo=login"
            );
        } else {
            request.getSession().setAttribute("error", "Código inválido o expirado.");
            response.sendRedirect("index.jsp?modo=olvido&paso=2");
        }
    }

    private void handleReenviar(HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession();

        Long ultimo = (Long) session.getAttribute(
                "ultimoEnvioCodigo");

        if (ultimo != null
                && System.currentTimeMillis() - ultimo < 60000) {

            session.setAttribute(
                    "error",
                    "Espere 1 minuto para reenviar.");

            response.sendRedirect(
                    "index.jsp?modo=olvido&paso=2");

            return;
        }

        String correo = (String) session.getAttribute(
                "correoRecuperacion");

        if (correo == null) {
            response.sendRedirect(
                    "index.jsp?modo=olvido");
            return;
        }

        String codigo = String.format(
                "%06d",
                new java.util.Random().nextInt(1000000));

        int idUsuario = us.iniciarRecuperacion(
                correo,
                codigo);

        if (idUsuario > 0 && emailservicio.enviarCodigo(  correo, codigo)) {

            session.setAttribute(  "success",  "Nuevo código enviado.");

            session.setAttribute(  "ultimoEnvioCodigo", System.currentTimeMillis());

        } else {

            session.setAttribute( "error", "No fue posible reenviar el código.");
        }

        response.sendRedirect( "index.jsp?modo=olvido&paso=2");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("index.jsp");
    }
}