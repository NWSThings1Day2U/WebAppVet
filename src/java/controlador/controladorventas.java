package controlador;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import java.lang.reflect.Type;
import dao.productodao;
import dao.ventasdao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import modelo.ItemCarrito;
import modelo.productos;
import modelo.ventas;

@WebServlet({"/controladorventas"})
public class controladorventas extends HttpServlet {

    ventasdao dao = new ventasdao();

    public controladorventas() {
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String accion = request.getParameter("accion");
        try {
            
            
            if ("guardar".equals(accion)) {
                String detalleJson = request.getParameter("detalleJson");

                Type tipo = new TypeToken<List<ItemCarrito>>(){}.getType();

                List<ItemCarrito> carrito =  new Gson().fromJson(
                        detalleJson,
                        tipo
                    );

                System.out.println(detalleJson);
                ventas v = new ventas();
                System.out.println("txtIdCliente = " + request.getParameter("txtIdCliente"));
                v.setIdCliente(Integer.parseInt(request.getParameter("txtIdCliente")));
                System.out.println("metodoPago = " + request.getParameter("metodoPago"));
                v.setMetodoPago(request.getParameter("metodoPago"));
                //System.out.println("idProducto = " + request.getParameter("IdProducto"));
                //int idProducto = Integer.parseInt(request.getParameter("IdProducto"));
               // System.out.println("cantidad = " + request.getParameter("cantidad"));
                //int cantidad = Integer.parseInt(request.getParameter("cantidad"));
                /**productodao pdao = new productodao();
                productos prod = pdao.buscarPorId(idProducto);
                if (prod == null) {
                    response.getWriter().println("Producto no encontrado");
                    return;
                }

                if (cantidad > prod.getStock()) {
                    response.getWriter().println("Stock insuficiente");
                    return;
                }**/

                //double precio = prod.getPrecio();
                //double subtotal = (double) cantidad * precio;
                double subtotal = 0;
                //double descuento = subtotal * 0.05;
                //double total = subtotal - descuento;
                for(ItemCarrito item : carrito){

                    subtotal += item.getPrecio()
                              * item.getCantidad();

                    v.añadirDetalle(
                        item.getIdProducto(),
                        item.getNombre(),
                        item.getCantidad(),
                        item.getPrecio()
                    );
                }
                
                double descuento = subtotal * 0.05;

                double total = subtotal - descuento;

                v.setDescuento(descuento);

                v.setTotal(total);
                
                //v.añadirDetalle(idProducto, prod.getNombre(), cantidad, precio);
                boolean exito = this.dao.registrarVentaCompleta(v);
                if (exito) {
                    request.getSession().setAttribute("mensajeExito", "Venta registrada correctamente.");
                } else {
                    request.getSession().setAttribute("mensajeError", "Error en la base de datos al registrar la venta.");
                }
            }
            
            
        } catch (Exception e) {
            e.printStackTrace();

            request.getSession().setAttribute(
                    "mensajeError",
                    "Error en los datos enviados: " + e.getMessage()
            );
        }

        response.sendRedirect("controladorseccion?seccion=ventas");
    }
}
