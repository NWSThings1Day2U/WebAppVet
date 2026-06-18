package controlador;

import dao.citadao;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.time.LocalDate;
import java.util.List;
import modelo.citas;

/**
 *
 * @author USUARIO
 */
@WebServlet(name = "controladorpagina", urlPatterns = {"/controladorpagina"})
public class controladorpagina extends HttpServlet {

    private final String paglogin = "/index.jsp";
    private final String paginicio = "/vista/inicio.jsp";
    private final String pagagendarcitas = "/vista/agendarcitas.jsp";
    private final String pagmiscitas = "/vista/miscitas.jsp";
    private final String pagpmiperfil = "/vista/miperfil.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String pagina = request.getParameter("pagina");
        if (pagina == null) {
            pagina = "login";
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
                request.getRequestDispatcher("controladorperfil").forward(request, response);
                break;
            default:
                throw new AssertionError();
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
/*modif caledar med 15-06-26*/
    private void inicio(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("paginaActual", "inicio");
        HttpSession session = request.getSession();
        Integer idUsuario
                = (Integer) session.getAttribute("id");
        citadao dao = new citadao();
        citas proxima
                = dao.obtenerProximaCitaCliente(idUsuario);
        request.setAttribute(
                "proximaCita",
                proxima
        );
        dao.mascotadao daoMascota
                = new dao.mascotadao();

        java.util.List<modelo.mascotas> listaMascotas
                = daoMascota.listarMascotasPorCliente(idUsuario);
        request.setAttribute(
                "misMascotas",
                listaMascotas
        );
        // CALENDARIO
        String fechaHoy
                = java.time.LocalDate.now().toString();
        request.setAttribute(
                "horasDisponibles",
                dao.obtenerHorasDisponibles(fechaHoy)
        );
        request.setAttribute(
                "horasOcupadas",
                dao.obtenerHorasOcupadas(fechaHoy)
        );
        // SEMANA
        LocalDate hoy = LocalDate.now();
        String semanaParam = request.getParameter("semana");
        LocalDate inicioSemana;
        if (semanaParam != null) {
            inicioSemana = LocalDate.parse(semanaParam);
        } else {
            inicioSemana = hoy.with(
                    java.time.DayOfWeek.MONDAY
            );
        }
        LocalDate finSemana
                = inicioSemana.plusDays(6);
        request.setAttribute(
                "inicioSemana",
                inicioSemana
        );
        request.setAttribute(
                "finSemana",
                finSemana
        );
        
        List<citas> agendaSemana
                = dao.obtenerCitasSemana(
                        inicioSemana.toString(),
                        finSemana.toString()
                );
        request.setAttribute(
                "agendaSemana",
                agendaSemana
        );
        // FORWARD
        request.getRequestDispatcher(
                paginicio
        ).forward(request, response);
    }

    private void agendarcitas(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
         request.getRequestDispatcher("/controladorcitas?accion=agendarcitasCliente").forward(request, response);
         
    }

    private void miscitas(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/controladorcitas?accion=listarcitasCliente").forward(request, response);
    }

    private void perfil(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setAttribute("paginaActual", "miperfil");

        request.getRequestDispatcher(pagpmiperfil).forward(request, response);
    }

    private void login(HttpServletRequest request, HttpServletResponse response)  throws ServletException, IOException {
        request.setAttribute("paginaActual", "login");

        request.getRequestDispatcher(paglogin).forward(request, response);    
    }

    

}
