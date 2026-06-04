package controlador;

import dao.ventasdao;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet({"/anularventa"})
public class anularventa extends HttpServlet {
   ventasdao dao = new ventasdao();

   public anularventa() {
   }

   protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
      int idVenta = Integer.parseInt(request.getParameter("id"));
      this.dao.anularVenta(idVenta);
      response.sendRedirect("controladorseccion?seccion=ventas");
   }
}
