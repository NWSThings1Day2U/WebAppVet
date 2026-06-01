package controlador;

import dao.clientedao;
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

        request.setAttribute("paginaActual", "clientes");

        request.getRequestDispatcher(pagClientes).forward(request, response);
    }

    private void guardar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String nombre = request.getParameter("txtNombre");
        String dni = request.getParameter("txtDni");
        String correo = request.getParameter("txtCorreo");
        String telefono = request.getParameter("txtTelefono");

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

        boolean insertado = dao.crearCliente(c);
        
        // Redireccionamos mediante controladorseccion para limpiar la petición POST y refrescar la tabla limpia
        response.sendRedirect(request.getContextPath() + "/controladorseccion?seccion=clientes");
    }

    private void editar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("txtId"));
        String nombre = request.getParameter("txtNombre");
        String dni = request.getParameter("txtDni");
        String correo = request.getParameter("txtCorreo");
        String telefono = request.getParameter("txtTelefono");
        int estado = Integer.parseInt(request.getParameter("txtEstado"));

        clientes c = new clientes();
        c.setIdCliente(id);
        c.setNombreCompleto(nombre);
        c.setDni(dni);
        c.setCorreo(correo);
        c.setTelefono(telefono);
        c.setEstado(estado);

        boolean editado = dao.editarCliente(c);

        response.sendRedirect(request.getContextPath() + "/controladorseccion?seccion=clientes");
    }

    private void eliminar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        
        boolean eliminado = dao.eliminarCliente(id);

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