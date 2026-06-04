package controlador;

import dao.ventasdao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import modelo.ventas;

@WebServlet({"/detalleventa"})
public class detalleventa extends HttpServlet {
   ventasdao dao = new ventasdao();

   public detalleventa() {
   }

   protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      int idVenta = Integer.parseInt(request.getParameter("id"));
      List<ventas.Detalle> detalles = this.dao.verDetalleVenta(idVenta);
      request.setAttribute("idVenta", idVenta);
      request.setAttribute("detalles", detalles);
      request.getRequestDispatcher("/vista/detalleventa.jsp").forward(request, response);
   }
}
