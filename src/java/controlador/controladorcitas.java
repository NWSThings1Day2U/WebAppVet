package controlador;

import com.google.gson.Gson;
import dao.citadao;
import dao.clientedao;
import dao.mascotadao;
import dao.Notificacionesdao;
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
import util.emailservicio;
import util.ticketpdfservicio;

@WebServlet(name = "controladorcitas", urlPatterns = {"/controladorcitas"})
public class controladorcitas extends HttpServlet {

    private final citadao dao = new citadao();
    private final clientedao clienteDao = new clientedao();
    private final mascotadao mascotaDao = new mascotadao();
    private final String pagCitas = "/vista/gcitas.jsp";
    private final String pagagendarcitas = "/vista/agendarcitas.jsp";
    private final String pagmiscitas = "/vista/miscitas.jsp";
    private Notificacionesdao daoNot = new Notificacionesdao();
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");
        if (accion == null) {
            accion = "listar";
        }

        if ("descargarTicket".equals(accion)) {
            descargarTicketPDF(request, response);
            return; 
        }
        response.setContentType("text/html;charset=UTF-8");

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
            case "reprogramarCita":
                reprogramarCita(request, response);
                break;
            default:
                listar(request, response);
        }
    }

    private void descargarTicketPDF(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String rol = (String) session.getAttribute("rol");

        try {
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.isEmpty()) {
                session.setAttribute("mensajeError", "ID de cita no válido.");
                redireccionarSegunRol(request, response, rol);
                return;
            }

            int idCita = Integer.parseInt(idParam);
            citas cita = dao.obtenerCitaCompleta(idCita);

            if (cita == null) {
                session.setAttribute("mensajeError", "No se encontró la cita solicitada para el ticket.");
                redireccionarSegunRol(request, response, rol);
                return;
            }

            response.reset();
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=Ticket_Cita_" + idCita + ".pdf");

            java.io.OutputStream outCliente = response.getOutputStream();
            jakarta.servlet.http.Cookie downloadCookie = new jakarta.servlet.http.Cookie("pdf_download_status", "success");
            downloadCookie.setPath(request.getContextPath().isEmpty() ? "/" : request.getContextPath());
            downloadCookie.setMaxAge(60);
            downloadCookie.setHttpOnly(false);
            response.addCookie(downloadCookie);
            boolean exito = ticketpdfservicio.generarTicketCita(cita, outCliente, getServletContext());
             
            outCliente.flush();
            outCliente.close();
            return;

        } catch (Exception e) {
            System.err.println("--- ERROR CRÍTICO EN DESCARGA PDF ---");
            e.printStackTrace();

            if (!response.isCommitted()) {
                response.reset();
                String errorReal = (e.getMessage() != null) ? e.getMessage() : e.toString();
                session.setAttribute("mensajeError", "Error al procesar el PDF: " + errorReal);
                redireccionarSegunRol(request, response, rol);
            }
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
            if (idCliente <= 0) {

                request.getSession().setAttribute(
                        "mensajeError",
                        "Cliente inválido."
                );

                response.sendRedirect(
                        request.getContextPath()
                        + "/controladorcitas?accion=listar"
                );

                return;
            }
            int idMascota = Integer.parseInt(request.getParameter("txtIdMascota"));
            if (idMascota <= 0) {

                request.getSession().setAttribute(
                        "mensajeError",
                        "Mascota inválida."
                );

                response.sendRedirect(
                        request.getContextPath()
                        + "/controladorcitas?accion=listar"
                );

                return;
            }
            boolean pertenece = dao.mascotaPerteneceCliente(idMascota, idCliente);

            if (!pertenece) {
                request.getSession().setAttribute("mensajeError", "La mascota seleccionada no pertenece al cliente.");

                response.sendRedirect(
                        request.getContextPath() + "/controladorcitas?accion=listar"
                );
                return;
            }
            int idTipo = Integer.parseInt(request.getParameter("txtIdTipo"));
            if (idTipo < 1 || idTipo > 3) {

                request.getSession().setAttribute(
                        "mensajeError",
                        "Tipo de atención inválido."
                );

                response.sendRedirect(
                        request.getContextPath()
                        + "/controladorcitas?accion=listar"
                );

                return;
            }
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
            if (motivo == null) {

                request.getSession().setAttribute(
                        "mensajeError",
                        "Debe ingresar un motivo."
                );

                response.sendRedirect(
                        request.getContextPath()
                        + "/controladorcitas?accion=listar"
                );

                return;
            }

            motivo = motivo.trim();

            if (motivo.length() < 10) {

                request.getSession().setAttribute(
                        "mensajeError",
                        "El motivo debe tener mínimo 10 caracteres."
                );

                response.sendRedirect(
                        request.getContextPath()
                        + "/controladorcitas?accion=listar"
                );

                return;
            }

            if (motivo.length() > 300) {

                request.getSession().setAttribute(
                        "mensajeError",
                        "El motivo no puede superar los 300 caracteres."
                );

                response.sendRedirect(
                        request.getContextPath()
                        + "/controladorcitas?accion=listar"
                );

                return;
            }

            if (!motivo.matches(
                    "^[a-zA-ZáéíóúÁÉÍÓÚñÑ0-9\\s.,()\\-]+$")) {

                request.getSession().setAttribute(
                        "mensajeError",
                        "El motivo contiene caracteres inválidos."
                );

                response.sendRedirect(
                        request.getContextPath()
                        + "/controladorcitas?accion=listar"
                );

                return;
            }
            citas c = new citas();
            c.setIdCliente(idCliente);
            c.setIdMascota(idMascota);
            c.setIdTipo(idTipo);
            c.setFecha(fecha);
            c.setHora(hora);
            c.setMotivo(motivo);
            System.out.println("Fecha: " + fecha);
            System.out.println("Hora: " + hora);
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
             /*añadido de notis admin*/
            if (exito) {
                Notificacionesdao daoNot = new Notificacionesdao();
                int idAdmin
                        = daoNot.obtenerAdministradorPrincipal();
                String cliente  = dao.obtenerNombreCliente(idCliente);
                String mascota  = dao.obtenerNombreMascota(idMascota);
                daoNot.registrarNotificacion(
                        idAdmin,
                        "Nueva cita pendiente",
                        cliente + " registró una cita para "
                        + mascota
                        + " el "
                        + fecha
                        + " a las "
                        + hora,
                        "CITA",
                        0
                );
            }
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

    // 3. editar
    private void editar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int idCita = Integer.parseInt(request.getParameter("txtIdCita"));
            int idMascota = Integer.parseInt(request.getParameter("txtIdMascota"));
            if (idMascota <= 0) {

                request.getSession().setAttribute("mensajeError","Mascota inválida."
                );

                response.sendRedirect( request.getContextPath() + "/controladorcitas?accion=listar"
                );

                return;
            }
            int idTipo = Integer.parseInt(request.getParameter("txtIdTipo"));
            if (idTipo < 1 || idTipo > 3) {

                request.getSession().setAttribute(
                        "mensajeError",
                        "Tipo de atención inválido."
                );

                response.sendRedirect(
                        request.getContextPath()
                        + "/controladorcitas?accion=listar"
                );

                return;
            }
            String fecha = request.getParameter("txtFecha");
            String hora = request.getParameter("txtHora");
            String motivo = request.getParameter("txtMotivo");
            if (motivo == null) {

                request.getSession().setAttribute(
                        "mensajeError",
                        "Debe ingresar un motivo."
                );

                response.sendRedirect(
                        request.getContextPath()
                        + "/controladorcitas?accion=listar"
                );

                return;
            }

            motivo = motivo.trim();

            if (motivo.length() < 10) {

                request.getSession().setAttribute(
                        "mensajeError",
                        "El motivo debe tener mínimo 10 caracteres."
                );

                response.sendRedirect(
                        request.getContextPath()
                        + "/controladorcitas?accion=listar"
                );

                return;
            }

            if (motivo.length() > 300) {

                request.getSession().setAttribute(
                        "mensajeError",
                        "El motivo no puede superar los 300 caracteres."
                );

                response.sendRedirect(
                        request.getContextPath()
                        + "/controladorcitas?accion=listar"
                );

                return;
            }

            if (!motivo.matches(
                    "^[a-zA-ZáéíóúÁÉÍÓÚñÑ0-9\\s.,()\\-]+$")) {

                request.getSession().setAttribute(
                        "mensajeError",
                        "El motivo contiene caracteres inválidos."
                );

                response.sendRedirect(
                        request.getContextPath()
                        + "/controladorcitas?accion=listar"
                );

                return;
            }
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
    //reprogramar para vista cliente
    private void reprogramarCita(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        String rol = (String) session.getAttribute("rol");
        try {
            int idCita = Integer.parseInt(request.getParameter("txtIdCita"));
            String fecha = request.getParameter("txtFecha");
            String hora = request.getParameter("txtHora");

            LocalDate fechaSeleccionada = LocalDate.parse(fecha);

            // Validación: No permitir fechas pasadas
            if (fechaSeleccionada.isBefore(LocalDate.now())) {
                session.setAttribute("mensajeError", "No puede reprogramar citas a fechas pasadas.");
                redireccionarSegunRol(request, response, rol);
                return;
            }

            // Validación: Si es hoy, verificar que la hora no haya pasado
            if (fechaSeleccionada.equals(LocalDate.now())) {
                LocalTime horaSeleccionada = LocalTime.parse(hora);
                if (horaSeleccionada.isBefore(LocalTime.now())) {
                    session.setAttribute("mensajeError", "No puede reprogramar una cita a una hora ya transcurrida.");
                    redireccionarSegunRol(request, response, rol);
                    return;
                }
            }

            boolean disponible = dao.horaDisponibleEditar(idCita, fecha, hora);
            if (!disponible) {
                session.setAttribute("mensajeError", "La nueva hora seleccionada ya se encuentra reservada.");
                redireccionarSegunRol(request, response, rol);
                return;
            }

            citas c = new citas();
            c.setIdCita(idCita);
            c.setFecha(fecha);
            c.setHora(hora);

            boolean exito = dao.reprogramarCita(c);

            if (exito) {
                session.setAttribute("mensajeExito", "Cita reprogramada correctamente de manera exitosa.");
            } else {
                session.setAttribute("mensajeError", "No se pudo reprogramar la cita. Verifique el estado actual.");
            }

        } catch (Exception e) {
            session.setAttribute("mensajeError", "Error al reprogramar: " + e.getMessage());
        }

        redireccionarSegunRol(request, response, rol);
    }
    // 4. cambiar estado
    private void actualizarEstado(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int idCita = Integer.parseInt(request.getParameter("id"));
            String nuevoEstado = request.getParameter("estado");
            HttpSession session = request.getSession();
        
            boolean exito = dao.actualizarEstado(idCita, nuevoEstado);

            if (exito) {

                switch (nuevoEstado) {

                    case "CONFIRMADA":

                    citas cita = dao.obtenerCitaCompleta(idCita);
                    //registro notis 22-06-26
                        int idUsuario
                                = daoNot.obtenerUsuarioPorCliente(
                                        cita.getIdCliente()
                                );

                        System.out.println("ID Cliente: " + cita.getIdCliente());
                        System.out.println("ID Usuario encontrado: " + idUsuario);
                        
                        if (idUsuario > 0) {

                            daoNot.registrarNotificacion(
                                    idUsuario,
                                    "Cita Confirmada",
                                    "Tu cita para "
                                    + cita.getMascota()
                                    + " fue confirmada para el "
                                    + cita.getFecha()
                                    + " a las "
                                    + cita.getHora(),
                                    "CITA",
                                    cita.getIdCita()
                            );

                        } else {

                            System.out.println(
                                    "No se encontró usuario para el cliente "
                                    + cita.getIdCliente()
                            );
                        }
                    boolean correoEnviado = emailservicio.enviarConfirmacionCita(
                                    cita.getCorreoCliente(),
                                    cita.getCliente(),
                                    cita.getMascota(),
                                    cita.getFecha(),
                                    cita.getHora(),
                                    cita.getTipoAtencion()
                            );

                    if (correoEnviado) {

                        request.getSession().setAttribute("mensajeEstado", "La cita fue confirmada y se notificó al cliente por correo." );

                    } else {

                        request.getSession().setAttribute("mensajeEstado","La cita fue confirmada, pero ocurrió un problema al enviar el correo.");

                        request.getSession().setAttribute("tipoEstado", "warning");
                    }

                    request.getSession().setAttribute(
                            "tituloEstado",
                            "Cita Confirmada"
                    );

                    request.getSession().setAttribute(
                            "tipoEstado",
                            "success"
                    );

                    break;

                    case "ATENDIDA":
                        request.getSession().setAttribute("mensajeEstado",
                                "La cita ya ha sido atendida correctamente.");
                        request.getSession().setAttribute("tituloEstado",
                                "Atención Completada");
                        request.getSession().setAttribute("tipoEstado",
                                "success");
                        break;

                    case "CANCELADA":
                        request.getSession().setAttribute("mensajeEstado",
                                "La cita fue cancelada.");
                        request.getSession().setAttribute("tituloEstado",
                                "Cita Cancelada");
                        request.getSession().setAttribute("tipoEstado",
                                "warning");
                        break;

                    case "PENDIENTE":
                        request.getSession().setAttribute("mensajeEstado",
                                "La cita quedó pendiente de atención.");
                        request.getSession().setAttribute("tituloEstado",
                                "Cita Pendiente");
                        request.getSession().setAttribute("tipoEstado",
                                "info");
                        break;
                    default:
                        request.getSession().setAttribute("tipoAlerta", "success");
                        request.getSession().setAttribute("tituloAlerta", "Estado Actualizado");
                        request.getSession().setAttribute(
                            "mensajeExito",
                            "El estado de la cita fue actualizado."
                        );
                }

            } else {

                request.getSession().setAttribute("tipoAlerta", "error");
                request.getSession().setAttribute("tituloAlerta", "Error");
                request.getSession().setAttribute(
                    "mensajeError",
                    "No se pudo actualizar el estado de la cita."
                );
            }
        } catch (Exception e) {
            request.getSession().setAttribute("mensajeError", "Error de parámetros: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/controladorcitas?accion=listar");
    }

    // 5. cancelar cita
    private void eliminar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String rol = (String) session.getAttribute("rol");
        try {
            int idCita = Integer.parseInt(request.getParameter("id"));

            boolean exito = dao.eliminarCita(idCita);

            if (exito) {
                request.getSession().setAttribute("mensajeExito", "Cita cancelada correctamente del sistema.");
            } else {
                request.getSession().setAttribute("mensajeError", "No se puede cancelar la cita (puede tener registros vinculados).");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("mensajeError", "Error de parámetros al cancelar: " + e.getMessage());
        }
        redireccionarSegunRol(request, response, rol);
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
            
            String nombre = request.getParameter("nombre");
            String dni = request.getParameter("dni");
            String correo = request.getParameter("correo");
            String telefono = request.getParameter("telefono");
            
            if(nombre == null || !nombre.matches("^[a-zA-ZáéíóúÁÉÍÓÚñÑ ]{3,100}$")){
            session.setAttribute("mensajeError", "Nombre inválido.");
            redireccionarSegunRol(request, response, rol);
            return;
            }

            if(dni == null || !dni.matches("\\d{8}")){
                session.setAttribute("mensajeError", "DNI inválido.");
                redireccionarSegunRol(request, response, rol);
                return;
            }

            if(telefono == null || !telefono.matches("9\\d{8}")){
                session.setAttribute("mensajeError", "Teléfono inválido.");
                redireccionarSegunRol(request, response, rol);
                return;
            }

            if(correo == null || !correo.trim().matches("^[A-Za-z0-9+_.-]+@(.+)$")){ // Mejorado con regex básico
                session.setAttribute("mensajeError", "Correo inválido.");
                redireccionarSegunRol(request, response, rol);
                return;
            }
            
            clientes cli = new clientes();
            cli.setNombreCompleto(nombre);
            cli.setDni(dni);
            cli.setCorreo(correo);
            cli.setTelefono(telefono);
            
            if (idUsuarioSession != null) {
                cli.setIdClienteResponsable(idUsuarioSession);
            }
            
            String nombreMascota = request.getParameter("mascota");
            String especie = request.getParameter("txtEspecie");
            String raza = request.getParameter("txtRaza");
            String pesoStr = request.getParameter("txtPeso");
            String fechaNacimiento = request.getParameter("txtFechaNac");
            String sexo = request.getParameter("txtSexo");
            
            if(nombreMascota == null || !nombreMascota.matches("^[a-zA-ZáéíóúÁÉÍÓÚñÑ0-9 ]{2,50}$")){

                 session.setAttribute(
                     "mensajeError",
                     "Nombre de mascota inválido."
                 );

                 redireccionarSegunRol(request,response,rol);
                 return;
             }
            if(especie == null ||
                !especie.matches("^[a-zA-ZáéíóúÁÉÍÓÚñÑ ]{3,50}$")){

                 session.setAttribute(
                     "mensajeError",
                     "La especie ingresada es inválida."
                 );

                 redireccionarSegunRol(request,response,rol);
                 return;
             }
            
            if(raza == null || !raza.matches("^[a-zA-ZáéíóúÁÉÍÓÚñÑ0-9 ]{2,50}$")){

                 session.setAttribute(
                     "mensajeError",
                     "La raza ingresada es inválida."
                 );

                 redireccionarSegunRol(request,response,rol);
                 return;
             }
            
            double peso;

            try {

                peso = Double.parseDouble(pesoStr);

                if(peso < 0.1 || peso > 150){

                    session.setAttribute(
                        "mensajeError",
                        "Peso fuera del rango permitido."
                    );

                    redireccionarSegunRol(request,response,rol);
                    return;
                }

            } catch(Exception e){

                session.setAttribute(
                    "mensajeError",
                    "Peso inválido."
                );

                redireccionarSegunRol(request,response,rol);
                return;
            }
            
            if(fechaNacimiento == null || fechaNacimiento.isEmpty()){

                session.setAttribute(
                    "mensajeError",
                    "Debe seleccionar una fecha de nacimiento."
                );

                redireccionarSegunRol(request,response,rol);
                return;
            }

            LocalDate fechaNac = LocalDate.parse(fechaNacimiento);

            if(fechaNac.isAfter(LocalDate.now())){

                session.setAttribute(
                    "mensajeError",
                    "La fecha de nacimiento no puede ser futura."
                );

                redireccionarSegunRol(request,response,rol);
                return;
            }
            
            if(!"M".equals(sexo) && !"F".equals(sexo)){

                session.setAttribute(
                    "mensajeError",
                    "Sexo inválido."
                );

                redireccionarSegunRol(request,response,rol);
                return;
            }
            
            mascotas mas = new mascotas();

            mas.setNombre(nombreMascota);
            mas.setEspecie(especie);
            mas.setRaza(raza);
            mas.setPeso(peso);
            mas.setFechaNacimiento(fechaNacimiento);
            mas.setSexo(sexo);
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
