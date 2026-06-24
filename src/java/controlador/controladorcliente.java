package controlador;

import dao.clientedao;
import dao.mascotadao;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import modelo.clientes;

@WebServlet(name = "controladorcliente", urlPatterns = {"/controladorcliente"})
public class controladorcliente extends HttpServlet {

    private final clientedao dao = new clientedao();
    private final String pagClientes = "/vista/gclientes.jsp"; 
    private final mascotadao mDao = new mascotadao();
    
    private String validarCliente(String nombre, String dni, String correo, String telefono){

        if(nombre == null || nombre.trim().isEmpty() || !nombre.trim().matches("^[A-Za-zÁÉÍÓÚáéíóúÑñ ]{3,100}$")){
             return "Nombre inválido.";
         }

        if(dni == null || !dni.matches("^[0-9]{8}$")){
            return "DNI inválido.";
        }

        if(correo == null || !correo.matches("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$")){
            return "Correo inválido.";
        }

        if(telefono != null && !telefono.isEmpty() && !telefono.matches("^9\\d{8}$")){
            return "Teléfono inválido.";
        }

        return null;
    }
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        String accion = request.getParameter("accion");
        if (accion == null) {
            accion = "listar";
        }

        switch (accion) {
            case "listar":
                listar(request, response);
                break;
            case "guardar":
                guardar(request, response);
                break;
            case "editar":
                editar(request, response);
                break;
            case "eliminar":
                eliminar(request, response);
                break;
            default:
                listar(request, response);
        }
    }

    private void listar(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        List<clientes> lista = dao.listarClientes();
        List<clientes> listaResponsables = dao.listarPrincipales();

        request.setAttribute("listaClientes", lista);
        request.setAttribute("listaResponsables", listaResponsables);
        // DASHBOARD
        request.setAttribute("totalClientes", lista.size());
        request.setAttribute("listaClientes", lista);

        request.setAttribute("clientesActivos", dao.contarClientesActivos());

        request.setAttribute("clientesNuevos",dao.contarClientesNuevos());

        request.setAttribute("mascotasRegistradas", mDao.contarMascotas());
        request.setAttribute("paginaActual", "clientes");

        request.getRequestDispatcher(pagClientes).forward(request, response);
    }

    private void guardar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
        String nombre = request.getParameter("txtNombre");
        String dni = request.getParameter("txtDni");
        String correo = request.getParameter("txtCorreo");
        String telefono = request.getParameter("txtTelefono");
        String error = validarCliente(nombre, dni, correo, telefono);

        if(error != null){
            request.getSession().setAttribute("mensajeError", error);
            response.sendRedirect(request.getContextPath() + "/controladorseccion?seccion=clientes");
            return;
        }
        if (dao.existeDni(dni)) {
            request.getSession().setAttribute("mensajeError", "El DNI ya está registrado.");
            response.sendRedirect(request.getContextPath() + "/controladorseccion?seccion=clientes");
            return;
        }

        if (dao.existeCorreo(correo)) {
            request.getSession().setAttribute("mensajeError", "El correo ya está registrado.");
            response.sendRedirect(request.getContextPath() + "/controladorseccion?seccion=clientes");
            return;
        }
        clientes c = new clientes();
        String responsable = request.getParameter("idClienteResponsable");

        if(responsable != null && !responsable.isEmpty()){
            c.setIdClienteResponsable(
                Integer.parseInt(responsable)
            );
        }
        c.setNombreCompleto(nombre);
        c.setDni(dni);
        c.setCorreo(correo);
        c.setTelefono(telefono);

        boolean exito = dao.crearCliente(c);
        if (exito) {
                request.getSession().setAttribute("mensajeExito", "Cliente registrado correctamente.");
            } else {
                request.getSession().setAttribute("mensajeError", "Error en la base de datos al registrar el cliente.");
            }
        }catch (Exception e) {
            request.getSession().setAttribute("mensajeError", "Error en los datos enviados: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/controladorseccion?seccion=clientes");
    }

    private void editar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("txtId"));
            String nombre = request.getParameter("txtNombre");
            String dni = request.getParameter("txtDni");
            String correo = request.getParameter("txtCorreo");
            String telefono = request.getParameter("txtTelefono");
            int estado = Integer.parseInt(request.getParameter("txtEstado"));
            String error = validarCliente(nombre, dni, correo, telefono);

            if(error != null){
                request.getSession().setAttribute("mensajeError", error);
                response.sendRedirect(request.getContextPath() + "/controladorseccion?seccion=clientes");
                return;
            }
            clientes c = new clientes();
            c.setIdCliente(id);
            c.setNombreCompleto(nombre);
            c.setDni(dni);
            c.setCorreo(correo);
            c.setTelefono(telefono);
            c.setEstado(estado);

            boolean editado = dao.editarCliente(c);
            if (editado) {
                request.getSession().setAttribute("mensajeExito", "Cliente actualizado correctamente.");
            } else {
                request.getSession().setAttribute("mensajeError", "No se pudo actualizar el cliente.");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("mensajeError", "Error de parámetros al editar: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/controladorseccion?seccion=clientes");
    }
    //eliminar logico (desactivar cuenta)
    private void eliminar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));

            boolean eliminado = dao.eliminarCliente(id);
            if (eliminado) {
                request.getSession().setAttribute("mensajeExito", "Cliente desactivado correctamente.");
            } else {
                request.getSession().setAttribute("mensajeError", "No se puede desactivar el cliente.");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("mensajeError", "Error de parámetros al desactivar: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/controladorseccion?seccion=clientes");
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