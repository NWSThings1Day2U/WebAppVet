package controlador;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

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

    private void inicio(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("paginaActual", "inicio");

        request.getRequestDispatcher(paginicio).forward(request, response);
    }

    private void agendarcitas(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("paginaActual", "agendarcitas");

        request.getRequestDispatcher(pagagendarcitas).forward(request, response);    
    }

    private void miscitas(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("paginaActual", "miscitas");

        request.getRequestDispatcher(pagmiscitas).forward(request, response);
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
