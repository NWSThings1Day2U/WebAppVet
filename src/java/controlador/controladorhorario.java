/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import dao.horariodao;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.PrintWriter;
import java.util.List;
import modelo.citas;
import modelo.horarios;

/**
 *
 * @author USUARIO
 */
@WebServlet(name = "controladorhorario", urlPatterns = {"/controladorhorario"})
public class controladorhorario extends HttpServlet {

    private final horariodao dao = new horariodao();
    private final String pagHorarios = "/vista/ghorarios.jsp";

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

            case "actualizar":
                actualizar(request, response);
                break;
            case "editar":
                editar(request, response);
                break;
                
            default:
                listar(request, response);
        }
    }

    // 1. Listar horarios
    private void listar(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        List<horarios> lista = dao.listarHorarios();

        request.setAttribute("listaHorarios", lista);

        request.getRequestDispatcher(pagHorarios)
                .forward(request, response);
    }

    private void actualizar(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {

            horarios h = new horarios();

            h.setIdHorario(
                    Integer.parseInt(
                            request.getParameter("idHorario"))
            );

            h.setHoraInicio(
                    request.getParameter("horaInicio")
            );

            h.setHoraFin(
                    request.getParameter("horaFin")
            );

            h.setDuracionMinutos(
                    Integer.parseInt(
                            request.getParameter("duracion"))
            );

            h.setCuposMaximos(
                    Integer.parseInt(
                            request.getParameter("cupos"))
            );

            h.setActivo(
                    Integer.parseInt(
                            request.getParameter("activo"))
            );

            boolean exito = dao.actualizarHorario(h);

            if (exito) {

                request.getSession().setAttribute(
                        "mensajeExito",
                        "Horario actualizado correctamente"
                );

            }

        } catch (Exception e) {

            request.getSession().setAttribute(
                    "mensajeError",
                    e.getMessage()
            );

        }

        response.sendRedirect(
                request.getContextPath()
                + "/controladorhorario?accion=listar"
        );
    }

    private void editar(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {

            horarios h = new horarios();

            h.setIdHorario(
                    Integer.parseInt(
                            request.getParameter("txtIdHorario")));

            h.setHoraInicio(
                    request.getParameter("txtHoraInicio"));

            h.setHoraFin(
                    request.getParameter("txtHoraFin"));

            h.setDuracionMinutos(
                    Integer.parseInt(
                            request.getParameter("txtDuracion")));

            h.setCuposMaximos(
                    Integer.parseInt(
                            request.getParameter("txtCupos")));

            h.setActivo(
                    Integer.parseInt(
                            request.getParameter("txtActivo")));

            dao.actualizarHorario(h);

            request.getSession()
                    .setAttribute("mensajeExito",
                            "Horario actualizado correctamente");

        } catch (Exception e) {

            request.getSession()
                    .setAttribute("mensajeError",
                            e.getMessage());

        }

        response.sendRedirect(
                request.getContextPath()
                + "/controladorhorario?accion=listar");
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

}
