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
                if(carrito == null || carrito.isEmpty()){

                    request.getSession().setAttribute(
                            "mensajeError",
                            "Debe agregar al menos un producto."
                    );

                    response.sendRedirect(
                            "controladorseccion?seccion=ventas"
                    );

                    return;
                }
                System.out.println(detalleJson);
                ventas v = new ventas();
                System.out.println("txtIdCliente = " + request.getParameter("txtIdCliente"));
                String idClienteStr = request.getParameter("txtIdCliente");

                if(idClienteStr == null  || idClienteStr.trim().isEmpty()){

                    request.getSession().setAttribute(
                            "mensajeError",
                            "Debe seleccionar un cliente."
                    );

                    response.sendRedirect(
                            "controladorseccion?seccion=ventas"
                    );

                    return;
                }

                int idCliente =
                        Integer.parseInt(idClienteStr);

                if(idCliente <= 0){

                    request.getSession().setAttribute(
                            "mensajeError",
                            "Cliente inválido."
                    );

                    response.sendRedirect(
                            "controladorseccion?seccion=ventas"
                    );

                    return;
                }

                v.setIdCliente(idCliente);
                System.out.println("metodoPago = " + request.getParameter("metodoPago"));
                String metodoPago = request.getParameter("metodoPago");

                if(metodoPago == null
                        || metodoPago.trim().isEmpty()){

                    request.getSession().setAttribute(
                            "mensajeError",
                            "Seleccione un método de pago."
                    );

                    response.sendRedirect(
                            "controladorseccion?seccion=ventas"
                    );

                    return;
                }
                
                if( !metodoPago.equals("Efectivo") && !metodoPago.equals("Tarjeta") &&  !metodoPago.equals("Yape")
                    && !metodoPago.equals("Plin")
                ){
                    request.getSession().setAttribute(
                            "mensajeError",
                            "Método de pago inválido."
                    );

                    response.sendRedirect(
                            "controladorseccion?seccion=ventas"
                    );

                    return;
                }

                v.setMetodoPago(metodoPago);
                double subtotal = 0;
                for(ItemCarrito item : carrito){
                    if(item.getIdProducto() <= 0){

                        request.getSession().setAttribute(
                                "mensajeError",
                                "Producto inválido."
                        );

                        response.sendRedirect(
                                "controladorseccion?seccion=ventas"
                        );

                        return;
                    }

                    if(item.getCantidad() <= 0){

                        request.getSession().setAttribute(
                                "mensajeError",
                                "Cantidad inválida."
                        );

                        response.sendRedirect(
                                "controladorseccion?seccion=ventas"
                        );

                        return;
                    }

                    if(item.getPrecio() <= 0){

                        request.getSession().setAttribute(
                                "mensajeError",
                                "Precio inválido."
                        );

                        response.sendRedirect(
                                "controladorseccion?seccion=ventas"
                        );

                        return;
                    }
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
