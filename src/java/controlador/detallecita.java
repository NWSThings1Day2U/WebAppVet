package controlador;

import dao.citadao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import modelo.citas;

@WebServlet({"/detallecita"})
public class detallecita extends HttpServlet {
    citadao dao = new citadao();

   public detallecita() {
   }

   protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      int idCita = Integer.parseInt(request.getParameter("id"));
        citas citadetalle = dao.obtenerCitaCompleta(idCita);
        request.setAttribute("idCita", idCita);
        request.setAttribute("detalles", citadetalle);
      request.getRequestDispatcher("/vista/detallecita.jsp").forward(request, response);
   }
}
