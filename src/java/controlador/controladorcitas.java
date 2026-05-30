package controlador;

import dao.citadao;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession; // Importante para manejar la sesión
import modelo.citas;

@WebServlet(name = "controladorcitas", urlPatterns = {"/controladorcitas"})
public class controladorcitas extends HttpServlet {

    private final citadao dao = new citadao();
    private final String pagCitas = "/vista/gcitas.jsp";

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
            case "actualizarEstado":
                actualizarEstado(request, response);
                break;
            case "eliminar":
                eliminar(request, response);
                break;
            
            default:
                listar(request, response);
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

    // 1. LISTAR CITAS (ADMINISTRADOR VE TODO / CLIENTE VE SOLO LAS SUYAS)
    private void listar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException { 
        
        HttpSession session = request.getSession();
        
        String rol = (String) session.getAttribute("rol");
        Integer idUsuario = (Integer) session.getAttribute("idUsuario"); 

        List<citas> listaCitas;

        // VALIDACIÓN DE ROL
        if (rol != null && rol.equalsIgnoreCase("CLIENTE")  && idUsuario != null) {
            listaCitas = dao.listarCitasPorCliente(idUsuario);
            request.setAttribute("paginaActual", "miscitas"); // Flag útil para vistas
        } else {
            listaCitas = dao.listarCitas();
            request.setAttribute("paginaActual", "citas");
        }
        
        request.setAttribute("listaCitas", listaCitas);
        dao.clientedao clienteDao = new dao.clientedao();
        dao.mascotadao mascotaDao = new dao.mascotadao();

        request.setAttribute("listaClientes", clienteDao.listarClientes());
        request.setAttribute("listaMascotas", mascotaDao.listarMascotas());
        request.getRequestDispatcher(pagCitas).forward(request, response);
    }

    // 2. REGISTRAR NUEVA CITA (ADMIN O CLIENTE)
    private void guardar(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException { 
        try {
            HttpSession session = request.getSession();
            String rol = (String) session.getAttribute("rol");
            
            int idCliente;
            
            // Si es cliente, asignamos su ID de sesión obligatoriamente para evitar fraudes
            if (rol != null && rol.equalsIgnoreCase("CLIENTE")) {
                idCliente = (Integer) session.getAttribute("idUsuario");
            } else {
                // Si es admin, lo lee del formulario/select donde eligió al cliente
                idCliente = Integer.parseInt(request.getParameter("txtIdCliente"));
            }
            
            int idMascota = Integer.parseInt(request.getParameter("txtIdMascota"));
            int idTipo = Integer.parseInt(request.getParameter("txtIdTipo"));
            String fecha = request.getParameter("txtFecha");
            String hora = request.getParameter("txtHora");
            String motivo = request.getParameter("txtMotivo");

            citas c = new citas();
            c.setIdCliente(idCliente);
            c.setIdMascota(idMascota);
            c.setIdTipo(idTipo);
            c.setFecha(fecha);
            c.setHora(hora);
            c.setMotivo(motivo);

            boolean exito = dao.insertarCita(c);

            if (exito) {
                request.getSession().setAttribute("mensajeExito", "Cita registrada correctamente.");
            } else {
                request.getSession().setAttribute("mensajeError", "Error en la base de datos al registrar la cita.");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("mensajeError", "Error en los datos enviados: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/controladorcitas?accion=listar");
    }

    // 3. EDITAR / REPROGRAMAR CITA COMPLETA
    private void editar(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException { 
        try {
            int idCita = Integer.parseInt(request.getParameter("txtIdCita"));
            int idMascota = Integer.parseInt(request.getParameter("txtIdMascota"));
            int idTipo = Integer.parseInt(request.getParameter("txtIdTipo"));
            String fecha = request.getParameter("txtFecha");
            String hora = request.getParameter("txtHora");
            String motivo = request.getParameter("txtMotivo");
            String estado = request.getParameter("txtEstado"); 

            citas c = new citas();
            c.setIdCita(idCita);
            c.setIdMascota(idMascota);
            c.setIdTipo(idTipo);
            c.setFecha(fecha);
            c.setHora(hora);
            c.setMotivo(motivo);
            c.setEstado(estado);

            boolean exito = dao.editarCita(c);

            if (exito) {
                request.getSession().setAttribute("mensajeExito", "Cita actualizada correctamente.");
            } else {
                request.getSession().setAttribute("mensajeError", "No se pudo actualizar la cita.");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("mensajeError", "Error de parámetros al editar: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/controladorcitas?accion=listar");
    }

    // 4. CAMBIAR EL ESTADO RÁPIDAMENTE
    private void actualizarEstado(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int idCita = Integer.parseInt(request.getParameter("id"));
            String nuevoEstado = request.getParameter("estado");

            boolean exito = dao.actualizarEstado(idCita, nuevoEstado);

            if (exito) {
                request.getSession().setAttribute("mensajeExito", "Estado de la cita actualizado a " + nuevoEstado + ".");
            } else {
                request.getSession().setAttribute("mensajeError", "No se pudo cambiar el estado de la cita.");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("mensajeError", "Error de parámetros: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/controladorcitas?accion=listar");
    }

    // 5. ELIMINAR CITA FISICAMENTE
    private void eliminar(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException { 
        try {
            int idCita = Integer.parseInt(request.getParameter("id"));
            
            boolean exito = dao.eliminarCita(idCita);

            if (exito) {
                request.getSession().setAttribute("mensajeExito", "Cita eliminada correctamente del sistema.");
            } else {
                request.getSession().setAttribute("mensajeError", "No se puede eliminar la cita (puede tener registros vinculados).");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("mensajeError", "Error de parámetros al eliminar: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/controladorcitas?accion=listar");
    }

    @Override
    public String getServletInfo() {
        return "Controlador encargado de la persistencia del flujo de citas.";
    }
}