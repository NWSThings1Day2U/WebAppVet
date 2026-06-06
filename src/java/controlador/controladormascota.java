package controlador;

import modelo.mascotas;
import modelo.clientes; 
import dao.mascotadao;
import dao.clientedao; 
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "controladormascota", urlPatterns = {"/controladormascota"})
public class controladormascota extends HttpServlet {

    private final mascotadao dao = new mascotadao();
    private final clientedao cDao = new clientedao(); 
    private final String pagMascotas = "/vista/gmascotas.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String accion = request.getParameter("accion");
        if (accion == null) accion = "listar";

        switch (accion) {
            case "listar": listar(request, response); break;
            case "guardar": guardar(request, response); break;
            case "editar": editar(request, response); break;
            case "eliminar": eliminar(request, response); break;
            default: listar(request, response);
        }
    }

    private void listar(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        List<mascotas> listaMascotas;
        
        Integer idUsuarioLogueado = (Integer) session.getAttribute("id");
        String rolUsuario = (String) session.getAttribute("rol"); // Ejemplo: "ADMIN" o "CLIENTE"
        
        if (rolUsuario != null && rolUsuario.equals("cliente") && idUsuarioLogueado != null) {
            listaMascotas = dao.listarMascotasPorCliente(idUsuarioLogueado);
        } else {
            listaMascotas = dao.listarMascotas();
        }

        @SuppressWarnings("unchecked")
        List<clientes> listaClientes = (List<clientes>) cDao.listarClientes();
        
        request.setAttribute("listaMascotas", listaMascotas);
        request.setAttribute("listaClientes", listaClientes); 
        
        request.getRequestDispatcher(pagMascotas).forward(request, response);
    }

    private void guardar(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            mascotas m = new mascotas();
            m.setIdCliente(Integer.parseInt(request.getParameter("txtIdCliente")));
            m.setNombre(request.getParameter("txtNombre"));
            m.setEspecie(request.getParameter("txtEspecie"));
            m.setRaza(request.getParameter("txtRaza"));
            m.setPeso(Double.parseDouble(request.getParameter("txtPeso")));
            m.setFechaNacimiento(request.getParameter("txtFechaNac")); 
            m.setSexo(request.getParameter("txtSexo")); 

            if (dao.crearMascota(m)) {
                request.getSession().setAttribute("mensajeExito", "Mascota registrada correctamente.");
            } else {
                request.getSession().setAttribute("mensajeError", "Error al registrar la mascota en la base de datos.");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("mensajeError", "Datos inválidos: " + e.getMessage());
        }
        String origen = request.getParameter("origen");
            if ("perfil".equals(origen)) {
                response.sendRedirect("controladorperfil?accion=listar");
            } else {
                response.sendRedirect("controladormascota?accion=listar");
            }
        }

    private void editar(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            mascotas m = new mascotas();
            m.setIdMascota(Integer.parseInt(request.getParameter("txtId")));
            m.setIdCliente(Integer.parseInt(request.getParameter("txtIdCliente")));
            m.setNombre(request.getParameter("txtNombre"));
            m.setEspecie(request.getParameter("txtEspecie"));
            m.setRaza(request.getParameter("txtRaza"));
            m.setPeso(Double.parseDouble(request.getParameter("txtPeso")));
            m.setFechaNacimiento(request.getParameter("txtFechaNac"));
            m.setSexo(request.getParameter("txtSexo"));
            m.setEstado(request.getParameter("txtEstado")); 

            if (dao.editarMascota(m)) {
                request.getSession().setAttribute("mensajeExito", "Mascota actualizada exitosamente.");
            } else {
                request.getSession().setAttribute("mensajeError", "No se pudo actualizar la mascota.");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("mensajeError", "Error al procesar la edición: " + e.getMessage());
        }
        response.sendRedirect("controladormascota?accion=listar");
    }

    private void eliminar(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            if (dao.eliminarMascota(id)) {
                request.getSession().setAttribute("mensajeExito", "Mascota dada de baja correctamente.");
            } else {
                request.getSession().setAttribute("mensajeError", "No se pudo eliminar la mascota.");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("mensajeError", "Error al eliminar: " + e.getMessage());
        }
        response.sendRedirect("controladormascota?accion=listar");
    }
    
    @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException { processRequest(req, resp); }
    @Override protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException { processRequest(req, resp); }
}