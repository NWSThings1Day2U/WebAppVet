package controlador;

import dao.citadao;
import dao.clientedao;
import dao.mascotadao;
import dao.Notificacionesdao;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.time.LocalDate;
import java.util.List;
import java.util.Set;
import modelo.citas;

@WebServlet(name = "controladorpagina", urlPatterns = {"/controladorpagina"})
public class controladorpagina extends HttpServlet {

    private final String paglogin = "/index.jsp";
    private final String paginicio = "/vista/inicio.jsp";
    private final String pagagendarcitas = "/vista/agendarcitas.jsp";
    private final String pagmiscitas = "/vista/miscitas.jsp";
    private final String pagpmiperfil = "/vista/miperfil.jsp";

    // Lista blanca de páginas permitidas
    private static final Set<String> PAGINAS_PERMITIDAS = Set.of(
            "login",
            "inicio",
            "agendarcitas",
            "miscitas",
            "miperfil"
    );

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        String pagina = request.getParameter("pagina");

        // Valor por defecto
        if (pagina == null || pagina.isBlank()) {
            pagina = "login";
        }

        // Validación por lista blanca
        if (!PAGINAS_PERMITIDAS.contains(pagina)) {
            System.out.println("Intento de acceso a página no permitida: " + pagina);
            response.sendRedirect(request.getContextPath() + "/controladorpagina?pagina=login");
            return;
        }

        switch (pagina) {
            case "login":
                login(request, response);
                break;
            case "inicio":
                inicio(request, response);
                break;
            case "agendarcitas":
                agendarcitas(request, response);
                break;
            case "miscitas":
                miscitas(request, response);
                break;
            case "miperfil":
                perfil(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/controladorpagina?pagina=login");
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

    @Override
    public String getServletInfo() {
        return "Controlador de navegación segura";
    }

    private void inicio(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("paginaActual", "inicio");
        cargarNotificaciones(request);

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("id") == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        Integer idUsuario = (Integer) session.getAttribute("id");

        citadao dao = new citadao();
        citas proxima = dao.obtenerProximaCitaCliente(idUsuario);
        request.setAttribute("proximaCita", proxima);

        mascotadao daoMascota = new mascotadao();
        List<modelo.mascotas> listaMascotas = daoMascota.listarMascotasPorCliente(idUsuario);
        request.setAttribute("misMascotas", listaMascotas);

        String fechaHoy = LocalDate.now().toString();
        request.setAttribute("horasDisponibles", dao.obtenerHorasDisponibles(fechaHoy));
        request.setAttribute("horasOcupadas", dao.obtenerHorasOcupadas(fechaHoy));

        LocalDate hoy = LocalDate.now();
        String semanaParam = request.getParameter("semana");
        LocalDate inicioSemana;

        try {
            if (semanaParam != null && !semanaParam.isBlank()) {
                inicioSemana = LocalDate.parse(semanaParam);
            } else {
                inicioSemana = hoy.with(java.time.DayOfWeek.MONDAY);
            }
        } catch (Exception e) {
            inicioSemana = hoy.with(java.time.DayOfWeek.MONDAY);
        }

        LocalDate finSemana = inicioSemana.plusDays(6);
        request.setAttribute("inicioSemana", inicioSemana);
        request.setAttribute("finSemana", finSemana);

        List<citas> agendaSemana = dao.obtenerCitasSemana(
                inicioSemana.toString(),
                finSemana.toString()
        );
        request.setAttribute("agendaSemana", agendaSemana);

        request.setAttribute("listaClientes", new clientedao().listarClientesPorUsuario(idUsuario));
        request.setAttribute("listaMascotas", new mascotadao().listarMascotas());
        request.setAttribute("listaCitas", dao.listarCitasPorCliente(idUsuario));

        List<citas> historial = dao.obtenerHistorialInicio(idUsuario);
        request.setAttribute("historialCitas", historial);

        int totalSemana = agendaSemana.size();
        int totalConfirmadas = 0;
        int totalPendientes = 0;
        int totalAtendidas = 0;

        for (citas c : agendaSemana) {
            if ("CONFIRMADA".equals(c.getEstado())) totalConfirmadas++;
            if ("PENDIENTE".equals(c.getEstado())) totalPendientes++;
            if ("ATENDIDA".equals(c.getEstado())) totalAtendidas++;
        }

        request.setAttribute("totalSemana", totalSemana);
        request.setAttribute("totalConfirmadas", totalConfirmadas);
        request.setAttribute("totalPendientes", totalPendientes);
        request.setAttribute("totalAtendidas", totalAtendidas);

        request.getRequestDispatcher(paginicio).forward(request, response);
    }

    private void agendarcitas(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        cargarNotificaciones(request);
        request.getRequestDispatcher("/controladorcitas?accion=agendarcitasCliente").forward(request, response);
    }

    private void miscitas(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        cargarNotificaciones(request);
        request.getRequestDispatcher("/controladorcitas?accion=listarcitasCliente").forward(request, response);
    }

    private void perfil(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("paginaActual", "miperfil");
        cargarNotificaciones(request);
                request.getRequestDispatcher("controladorperfil").forward(request, response);
    }

    private void login(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("paginaActual", "login");
        request.getRequestDispatcher(paglogin).forward(request, response);
    }

    private void cargarNotificaciones(HttpServletRequest request) {
        try {
            HttpSession session = request.getSession(false);
            if (session == null) return;

            Integer idUsuario = (Integer) session.getAttribute("id");
            if (idUsuario != null) {
                Notificacionesdao daoNot = new Notificacionesdao();
                request.setAttribute("notificaciones", daoNot.listarPorUsuario(idUsuario));
                request.setAttribute("totalNoLeidas", daoNot.contarNoLeidas(idUsuario));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}