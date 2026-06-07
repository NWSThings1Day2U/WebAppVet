package controlador;

import com.google.gson.Gson;
import dao.citadao;
import dao.clientedao;
import dao.mascotadao;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.time.LocalTime;
import modelo.citas;
import modelo.clientes;
import modelo.mascotas;
import modelo.usuarios;

@WebServlet(name = "controladorcitas", urlPatterns = {"/controladorcitas"})
public class controladorcitas extends HttpServlet {

    private final citadao dao = new citadao();
    private final clientedao clienteDao = new clientedao();
    private final mascotadao mascotaDao = new mascotadao();
    private final String pagCitas = "/vista/gcitas.jsp";
    private final String pagagendarcitas = "/vista/agendarcitas.jsp";
    private final String pagmiscitas = "/vista/miscitas.jsp";

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
            case "horasDisponibles":
                cargarHorasDisponibles(request, response);
                break;
            case "horasDisponiblesEditar":
                cargarHorasDisponiblesEditar(request, response);
                break;
            case "agendarcitasCliente":
                agendarcitasCliente(request, response);
                break;
            case "registrarcitaClienteNuevo":
                registrarcitaClienteNuevo(request,response);
                break;
            case "listarcitasCliente":
                listarcitasCliente(request, response);
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

    // 1. Listar clientes
    private void listar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        String rol = (String) session.getAttribute("rol");
        Integer id = (Integer) session.getAttribute("id");

        List<citas> listaCitas;

        // Validar rol
        if (rol != null && rol.equalsIgnoreCase("cliente") && id != null) {
            listaCitas = dao.listarCitasPorCliente(id);
            request.setAttribute("paginaActual", "listarcitasCliente");
        } else {
            listaCitas = dao.listarCitas();
            request.setAttribute("paginaActual", "citas");
        }

        request.setAttribute("listaCitas", listaCitas);
        request.setAttribute("listaClientes", clienteDao.listarClientes());
        request.setAttribute("listaMascotas", mascotaDao.listarMascotas());
        request.getRequestDispatcher(pagCitas).forward(request, response);
    }

    // 2. Registrar nueva cita admin o cliente
    private void guardar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String rol = (String) session.getAttribute("rol");
        try {

            int idCliente = Integer.parseInt(request.getParameter("txtIdCliente"));
            int idMascota = Integer.parseInt(request.getParameter("txtIdMascota"));

            boolean pertenece = dao.mascotaPerteneceCliente(idMascota, idCliente);

            if (!pertenece) {
                request.getSession().setAttribute("mensajeError", "La mascota seleccionada no pertenece al cliente.");

                response.sendRedirect(
                        request.getContextPath() + "/controladorcitas?accion=listar"
                );
                return;
            }
            int idTipo = Integer.parseInt(request.getParameter("txtIdTipo"));
            String fecha = request.getParameter("txtFecha");
            LocalDate fechaSeleccionada = LocalDate.parse(request.getParameter("txtFecha"));

            if (fechaSeleccionada.isBefore(LocalDate.now())) {

                request.getSession().setAttribute("mensajeError", "No puede registrar citas en fechas pasadas.");

                response.sendRedirect(request.getContextPath() + "/controladorcitas?accion=listar");

                return;
            }
            String hora = request.getParameter("txtHora");
            if (fechaSeleccionada.equals(LocalDate.now())) {

                java.time.LocalTime horaSeleccionada
                        = java.time.LocalTime.parse(hora);

                if (horaSeleccionada.isBefore(
                        java.time.LocalTime.now())) {

                    request.getSession().setAttribute("mensajeError", "No puede registrar una cita en una hora ya transcurrida.");

                    response.sendRedirect(request.getContextPath() + "/controladorcitas?accion=listar");

                    return;
                }
            }
            String motivo = request.getParameter("txtMotivo");

            citas c = new citas();
            c.setIdCliente(idCliente);
            c.setIdMascota(idMascota);
            c.setIdTipo(idTipo);
            c.setFecha(fecha);
            c.setHora(hora);
            c.setMotivo(motivo);
            boolean disponible = dao.horaDisponible(fecha, hora);

            if (!disponible) {

                request.getSession().setAttribute("mensajeError", "La hora ya fue reservada.");

                response.sendRedirect(request.getContextPath() + "/controladorcitas?accion=listar");

                return;
            }

            if (dao.obtenerHorasDisponibles(fecha).isEmpty()) {

                request.getSession().setAttribute("mensajeError", "No hay atención para esa fecha.");

                response.sendRedirect(request.getContextPath() + "/controladorcitas?accion=listar");

                return;
            }
            boolean exito = dao.insertarCita(c);

            if (exito) {
                request.getSession().setAttribute("mensajeExito", "Cita registrada correctamente.");
            } else {
                request.getSession().setAttribute("mensajeError", "Error en la base de datos al registrar la cita.");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("mensajeError", "Error en los datos enviados: " + e.getMessage());
        }
        if ("cliente".equalsIgnoreCase(rol)) {

            response.sendRedirect(request.getContextPath()+ "/controladorcitas?accion=listarcitasCliente");

        } else {

            response.sendRedirect(request.getContextPath()+ "/controladorcitas?accion=listar");
        }
    }

    // 3. editar/programar cita
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
            LocalDate fechaSeleccionada
                    = LocalDate.parse(fecha);

            if (fechaSeleccionada.isBefore(LocalDate.now())) {

                request.getSession().setAttribute("mensajeError", "No puede asignar fechas pasadas.");

                response.sendRedirect(
                        request.getContextPath()
                        + "/controladorcitas?accion=listar"
                );

                return;
            }
            if (fechaSeleccionada.equals(LocalDate.now())) {

                java.time.LocalTime horaSeleccionada
                        = java.time.LocalTime.parse(hora);

                if (horaSeleccionada.isBefore(
                        java.time.LocalTime.now())) {

                    request.getSession().setAttribute("mensajeError", "No puede asignar una hora ya transcurrida.");

                    response.sendRedirect(request.getContextPath() + "/controladorcitas?accion=listar");

                    return;
                }
            }
            boolean disponible = dao.horaDisponibleEditar(idCita, fecha, hora);

            if (!disponible) {

                request.getSession().setAttribute("mensajeError", "La hora seleccionada ya se encuentra reservada.");

                response.sendRedirect(request.getContextPath() + "/controladorcitas?accion=listar");

                return;
            }
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

    // 4. cambiar estado
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

    // 5. eliminar cita fisico
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

    //Obtener horarios disponibles
    private void cargarHorasDisponibles(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {

            String fecha = request.getParameter("fecha");

            System.out.println("Fecha recibida: " + fecha);

            List<String> horas = dao.obtenerHorasDisponibles(fecha);

            System.out.println("Horas encontradas: " + horas);

            response.setContentType("application/json");

            PrintWriter out = response.getWriter();

            out.print(new Gson().toJson(horas));

        } catch (Exception e) {

            e.printStackTrace();

        }

    }

    //obtener horarios disponibles para editar
    private void cargarHorasDisponiblesEditar(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        try {

            String fecha = request.getParameter("fecha");
            System.out.println("Fecha recibida: " + fecha);
            int idCita = Integer.parseInt(request.getParameter("idCita"));

            List<String> horas = dao.obtenerHorasDisponiblesEditar(fecha,idCita);
            System.out.println("Horas encontradas: " + horas);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();

            out.print(new Gson().toJson(horas));
            out.flush();

        } catch (Exception e) {

            e.printStackTrace();

        }
    }

    @Override
    public String getServletInfo() {
        return "Controlador encargado de la persistencia del flujo de citas.";
    }

    //agendar citas para vista cliente
    private void agendarcitasCliente(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer id = (Integer) session.getAttribute("id");
        String rol = (String) session.getAttribute("rol");

        request.setAttribute("listaClientes",new clientedao().listarClientesPorUsuario(id));

        request.setAttribute("listaMascotas",new mascotadao().listarMascotas());

        request.getRequestDispatcher(pagagendarcitas).forward(request, response);
    }
    

    //listar citas para vista cliente
    private void listarcitasCliente(HttpServletRequest request,HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer id = (Integer) session.getAttribute("id");
        String rol = (String) session.getAttribute("rol");
        request.setAttribute("listaClientes",new clientedao().listarClientesPorUsuario(id));

        request.setAttribute("listaMascotas",new mascotadao().listarMascotas());
        request.setAttribute("listaCitas", dao.listarCitasPorCliente(id));

        request.getRequestDispatcher(pagmiscitas).forward(request, response);
    }
    //registrar cliente, mascota y citas
    private void registrarcitaClienteNuevo(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {
        HttpSession session = request.getSession();
        String rol = (String) session.getAttribute("rol");
        Integer idUsuarioSession = (Integer) session.getAttribute("id");
        try {
            String fecha = request.getParameter("txtFecha");
            String hora = request.getParameter("txtHora");
            LocalDate fechaSeleccionada = LocalDate.parse(fecha);

            if (fechaSeleccionada.isBefore(LocalDate.now())) {
                session.setAttribute("mensajeError", "No puede registrar citas en fechas pasadas.");
                redireccionarSegunRol(request, response, rol);
                return;
            }

            if (fechaSeleccionada.equals(LocalDate.now())) {
                LocalTime horaSeleccionada = LocalTime.parse(hora);
                if (horaSeleccionada.isBefore(LocalTime.now())) {
                    session.setAttribute("mensajeError", "No puede registrar una cita en una hora ya transcurrida.");
                    redireccionarSegunRol(request, response, rol);
                    return;
                }
            }

            if (!dao.horaDisponible(fecha, hora)) {
                session.setAttribute("mensajeError", "La hora seleccionada ya no se encuentra disponible.");
                redireccionarSegunRol(request, response, rol);
                return;
            }

            clientes cli = new clientes();
            cli.setNombreCompleto(request.getParameter("nombre"));
            cli.setDni(request.getParameter("dni"));
            cli.setCorreo(request.getParameter("correo"));
            cli.setTelefono(request.getParameter("telefono"));
            
            if (idUsuarioSession != null) {
                cli.setIdClienteResponsable(idUsuarioSession);
            }
            mascotas mas = new mascotas();
            mas.setNombre(request.getParameter("mascota"));
            mas.setEspecie(request.getParameter("txtEspecie"));
            mas.setRaza(request.getParameter("txtRaza"));
            String pesoStr = request.getParameter("txtPeso");
            double peso = (pesoStr != null && !pesoStr.isEmpty()) ? Double.parseDouble(pesoStr) : 0.0;
            mas.setPeso(peso);
            mas.setFechaNacimiento(request.getParameter("txtFechaNac"));
            mas.setSexo(request.getParameter("txtSexo"));

            citas cita = new citas();
            cita.setIdTipo(Integer.parseInt(request.getParameter("txtIdTipo")));
            cita.setFecha(fecha);
            cita.setHora(hora);
            cita.setMotivo(request.getParameter("txtMotivo"));

            boolean ok = dao.registrarClienteMascotaCita(cli, mas, cita);

            if (ok) {
                session.setAttribute("mensajeExito", "Cliente, mascota y cita registrados de manera exitosa.");
            } else {
                session.setAttribute("mensajeError", "Ocurrió un error interno en la base de datos.");
            }

        } catch (Exception e) {
            e.printStackTrace(); 
            session.setAttribute("mensajeError", "Error en el procesamiento de datos: " + e.getMessage());
        }
        
        redireccionarSegunRol(request, response, rol);
    }
    
    private void redireccionarSegunRol(HttpServletRequest request, HttpServletResponse response, String rol) throws IOException {
        if ("cliente".equalsIgnoreCase(rol)) {
            response.sendRedirect(request.getContextPath() + "/controladorcitas?accion=listarcitasCliente");
        } else {
            response.sendRedirect(request.getContextPath() + "/controladorcitas?accion=listar");
        }
    }
}
