package controlador;

import dao.ventasdao;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import modelo.ventas;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

@WebServlet({"/exportarventas"})
public class exportarventas extends HttpServlet {
   ventasdao dao = new ventasdao();

   public exportarventas() {
   }

   @Override
   protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
      System.out.println("Apache POI cargado...");
      Workbook libro = new XSSFWorkbook();
      Sheet hoja = libro.createSheet("Ventas");
      Row encabezado = hoja.createRow(0);
      encabezado.createCell(0).setCellValue("ID");
      encabezado.createCell(1).setCellValue("Cliente");
      encabezado.createCell(2).setCellValue("Fecha");
      encabezado.createCell(3).setCellValue("Método");
      encabezado.createCell(4).setCellValue("Total");
      List<ventas> lista = this.dao.listarVentas();
      int fila = 1;

      for(ventas v : lista) {
         Row row = hoja.createRow(fila++);
         row.createCell(0).setCellValue((double)v.getIdVenta());
         row.createCell(1).setCellValue(v.getCliente());
         row.createCell(2).setCellValue(v.getFecha());
         row.createCell(3).setCellValue(v.getMetodoPago());
         row.createCell(4).setCellValue(v.getTotal());
      }

      response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
      response.setHeader("Content-Disposition", "attachment; filename=ventas.xlsx");
      libro.write(response.getOutputStream());
      libro.close();
   }
}
