package controlador;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

/**
 *
 * @author USUARIO
 */
@WebServlet(name = "controladorseccion", urlPatterns = {"/controladorseccion"})
public class controladorseccion extends HttpServlet {

    private final String paginicio = "/vista/paneladmin.jsp";
    private final String pagcitas = "/vista/gcitas.jsp";
    private final String paginventario = "/vista/ginventario.jsp";
    private final String pagventas = "/vista/gventas.jsp";
    private final String pagclientes = "/vista/gclientes.jsp";
    private final String pagmascotas = "/vista/gmascotas.jsp";
    private final String pagusuarios = "/vista/gusuarios.jsp";
    private final String pagperfil = "/vista/gperfil.jsp";
    

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String seccion = request.getParameter("seccion");
        if (seccion == null) {
            seccion = "inicio";
        }
        switch (seccion) {
            case "inicio":
                inicio(request, response);
                break;
            case "citas":
                citas(request, response);
                break;
            case "inventario":
                inventario(request, response);
                break;
            case "ventas":
                ventas(request, response);
                break;
            case "clientes":
                clientes(request, response);
                break;
            case "mascotas":
                mascotas(request, response);
                break;
            case "usuarios":
                usuarios(request, response);
                break;
            case "perfil":
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

    private void inventario(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/controladorinventario?accion=listar").forward(request, response);
    }



    private void perfil(HttpServletRequest request, HttpServletResponse response)              
            throws ServletException, IOException {
        request.setAttribute("paginaActual", "perfil");

        request.getRequestDispatcher(pagperfil).forward(request, response);
    }

    private void citas(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/controladorcitas?accion=listar").forward(request, response);
    }

    private void ventas(HttpServletRequest request, HttpServletResponse response)  
            throws ServletException, IOException {
        request.setAttribute("paginaActual", "ventas");

        request.getRequestDispatcher(pagventas).forward(request, response);
    }

    private void clientes(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/controladorcliente?accion=listar").forward(request, response);
    }

    private void mascotas(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/controladormascota?accion=listar").forward(request, response);
    }

    private void usuarios(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/controladorusuarios?accion=listar").forward(request, response);
    }


}
