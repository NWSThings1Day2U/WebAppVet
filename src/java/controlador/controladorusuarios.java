package controlador;

import dao.usuariodao;
import modelo.usuarios;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "controladorusuarios", urlPatterns = {"/controladorusuarios"})
public class controladorusuarios extends HttpServlet {

    private usuariodao dao = new usuariodao();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");
        if (accion == null) {
            accion = "listar";
        }

        switch (accion) {
            case "listar":
                List<usuarios> lista = dao.listarUsuarios();
                request.setAttribute("listaUsuarios", lista);
                request.getRequestDispatcher("vista/gusuarios.jsp").forward(request, response);
                break;

            case "registrar":
                String userReg = request.getParameter("txtUser");
                String passReg = request.getParameter("txtPass");
                String nomReg = request.getParameter("txtNombre");
                String dniReg = request.getParameter("txtDni");
                String correoReg = request.getParameter("txtCorreo");
                String telReg = request.getParameter("txtTelefono");

                boolean regOk = dao.registrar(userReg, passReg, nomReg, dniReg, correoReg, telReg);
                if (regOk) {
                    request.getSession().setAttribute("msgSuccess", "¡Usuario registrado correctamente!");
                } else {
                    request.getSession().setAttribute("msgError", "Error al registrar el usuario. El nombre de usuario o DNI ya pueden existir.");
                }
                response.sendRedirect("controladorseccion?seccion=usuarios");
                break;

            case "editar":
                int idUserEdit = Integer.parseInt(request.getParameter("txtIdUsuario"));
                String userEdit = request.getParameter("txtUser");
                String nomEdit = request.getParameter("txtNombre");
                String dniEdit = request.getParameter("txtDni");
                String correoEdit = request.getParameter("txtCorreo");
                String telEdit = request.getParameter("txtTelefono");
                int nuevoRol = Integer.parseInt(request.getParameter("txtNuevoRol"));

                usuarios uEdit = new usuarios();
                uEdit.setIdUsuario(idUserEdit);
                uEdit.setNombreusuario(userEdit);
                uEdit.setNombrecompleto(nomEdit);
                uEdit.setDni(dniEdit);
                uEdit.setCorreo(correoEdit);
                uEdit.setTelefono(telEdit);

                boolean editOk = dao.editarUsuarioCompleto(uEdit, nuevoRol);
                if (editOk) {
                    request.getSession().setAttribute("msgSuccess", "Datos de usuario y rol actualizados correctamente.");
                } else {
                    request.getSession().setAttribute("msgError", "Ocurrió un error al intentar editar el usuario.");
                }
                response.sendRedirect("controladorseccion?seccion=usuarios");
                break;

            case "cambiarEstado":
                int idUserEst = Integer.parseInt(request.getParameter("id"));
                int estadoActual = Integer.parseInt(request.getParameter("estado"));
                // Si el estado actual es 1 (Activo), lo cambiamos a 0 (Dar de Baja). Si es 0, lo reactivamos a 1.
                int nuevoEstado = (estadoActual == 1) ? 0 : 1;

                boolean estOk = dao.cambiarEstadoUsuario(idUserEst, nuevoEstado);
                if (estOk) {
                    String mensaje = (nuevoEstado == 1) ? "Cuenta reactivada con éxito." : "Cuenta dada de baja correctamente.";
                    request.getSession().setAttribute("msgSuccess", mensaje);
                } else {
                    request.getSession().setAttribute("msgError", "No se pudo cambiar el estado de la cuenta.");
                }
                response.sendRedirect("controladorseccion?seccion=usuarios");
                break;
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}