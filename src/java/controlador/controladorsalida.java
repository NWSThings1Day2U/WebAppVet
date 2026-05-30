
package controlador;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author USUARIO
 */
@WebServlet(name = "controladorsalida", urlPatterns = {"/controladorsalida"})
public class controladorsalida extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession sesion = request.getSession(false);
        String nombreUsuario = "";

        if (sesion != null) {
            nombreUsuario = (String) sesion.getAttribute("usuario");
            sesion.invalidate(); 
        }

        HttpSession nuevaSesion = request.getSession(true);
        nuevaSesion.setAttribute("success", "Sesión cerrada. ¡Vuelve pronto, " + (nombreUsuario != null ? nombreUsuario : "") + "!");

        response.sendRedirect("index.jsp");
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
    

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
   

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
