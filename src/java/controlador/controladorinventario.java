package controlador;

import dao.productodao;
import modelo.productos;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "controladorinventario", urlPatterns = {"/controladorinventario"})
public class controladorinventario extends HttpServlet {

    private final productodao dao = new productodao();
    private final String pagInventario = "/vista/ginventario.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String accion = request.getParameter("accion");
        if (accion == null) accion = "listar";

        switch (accion) {
            case "listar": listar(request, response); break;
            case "guardar": guardar(request, response); break;
            case "editar": editar(request, response); break;
            case "eliminar": eliminar(request, response); break;
            case "reactivar":reactivar(request,response);break;
            default: listar(request, response);
        }
    }

    private void listar(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<productos> lista = dao.listarProductos();
        request.setAttribute("listaProductos", lista);
        request.getRequestDispatcher(pagInventario).forward(request, response);
    }

    private void guardar(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            productos p = new productos();
            String nombre = request.getParameter("nombre");

            if(nombre == null || nombre.trim().length() < 3){

                request.getSession().setAttribute(
                        "mensajeError",
                        "Nombre inválido."
                );

                response.sendRedirect(
                        "controladorinventario?accion=listar"
                );

                return;
            }
            if(dao.existeProducto(nombre)){

                request.getSession().setAttribute(
                        "mensajeError",
                        "Ya existe un producto con ese nombre."
                );

                response.sendRedirect(
                        "controladorinventario?accion=listar"
                );

                return;
            }
            nombre = nombre.trim();
            p.setNombre(nombre);
            
            int categoria = Integer.parseInt(request.getParameter("id_categoria"));

            if(categoria < 1 || categoria > 3){

                request.getSession().setAttribute(
                        "mensajeError",
                        "Categoría inválida."
                );

                response.sendRedirect(
                        "controladorinventario?accion=listar"
                );

                return;
            }
            
            p.setIdCategoria(categoria);
            int stock =Integer.parseInt(request.getParameter("stock"));

            if(stock < 0){

                request.getSession().setAttribute(
                        "mensajeError",
                        "Stock inválido."
                );

                response.sendRedirect(
                        "controladorinventario?accion=listar"
                );

                return;
            }
            p.setStock(stock);
            int stockMinimo = Integer.parseInt(request.getParameter("stock_minimo"));

            if(stockMinimo < 0){

                request.getSession().setAttribute(
                        "mensajeError",
                        "Stock mínimo inválido."
                );

                response.sendRedirect(
                        "controladorinventario?accion=listar"
                );

                return;
            }
            p.setStockMinimo(stockMinimo);
            double precio = Double.parseDouble(request.getParameter("precio"));

            if(precio <= 0){

                request.getSession().setAttribute(
                        "mensajeError",
                        "Precio inválido."
                );

                response.sendRedirect(
                        "controladorinventario?accion=listar"
                );

                return;
            }
            p.setPrecio(precio);
            String fechaIngreso = request.getParameter("fecha_ingreso");

            String fechaVencimiento = request.getParameter("fecha_vencimiento");

            if(
                    fechaIngreso != null
                    &&
                    !fechaIngreso.isEmpty()
                    &&
                    fechaVencimiento != null
                    &&
                    !fechaVencimiento.isEmpty()
                    &&
                    fechaVencimiento.compareTo(
                            fechaIngreso
                    ) < 0
                    ){

                request.getSession().setAttribute(
                        "mensajeError",
                        "La fecha de vencimiento no puede ser menor a la fecha de ingreso."
                );

                response.sendRedirect(
                        "controladorinventario?accion=listar"
                );

                return;
            }
            p.setFechaIngreso(fechaIngreso);
            p.setFechaVencimiento(fechaVencimiento);
            String proveedor = request.getParameter("proveedor");

            if(
                    proveedor != null
                    &&
                    !proveedor.trim().isEmpty()
                    &&
                    !proveedor.matches(
                            "^[a-zA-ZáéíóúÁÉÍÓÚñÑ0-9\\s\\-.,]+$"
                    )
                    ){

                request.getSession().setAttribute(
                        "mensajeError",
                        "Proveedor inválido."
                );

                response.sendRedirect(
                        "controladorinventario?accion=listar"
                );

                return;
            }
            p.setProveedor(proveedor);

            if (dao.insertarProducto(p)) {
                request.getSession().setAttribute("mensajeExito", "Producto registrado correctamente.");
            } else {
                request.getSession().setAttribute("mensajeError", "Error al registrar el producto.");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("mensajeError", "Datos inválidos: " + e.getMessage());
        }
        response.sendRedirect("controladorinventario?accion=listar");
    }

    private void editar(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            productos p = new productos();
            p.setIdProducto(Integer.parseInt(request.getParameter("id_producto")));
            String nombre = request.getParameter("nombre");

            if (nombre == null|| nombre.trim().length() < 3) {

                request.getSession().setAttribute(
                        "mensajeError",
                        "Nombre inválido."
                );

                response.sendRedirect(
                        "controladorinventario?accion=listar");

                return;
            }

            nombre = nombre.trim();

            if (!nombre.matches(
                    "^[a-zA-ZáéíóúÁÉÍÓÚñÑ0-9\\s\\-.,]+$")) {

                request.getSession().setAttribute(
                        "mensajeError",
                        "Nombre con caracteres inválidos."
                );

                response.sendRedirect(
                        "controladorinventario?accion=listar");

                return;
            }

            p.setNombre(nombre);

            int categoria = Integer.parseInt(   request.getParameter("id_categoria"));

            if (categoria < 1 || categoria > 3) {

                request.getSession().setAttribute(
                        "mensajeError",
                        "Categoría inválida."
                );

                response.sendRedirect(
                        "controladorinventario?accion=listar");

                return;
            }

            p.setIdCategoria(categoria);

            int stock = Integer.parseInt(
                            request.getParameter("stock"));

            if (stock < 0) {

                request.getSession().setAttribute(
                        "mensajeError",
                        "Stock inválido."
                );

                response.sendRedirect(
                        "controladorinventario?accion=listar");

                return;
            }

            p.setStock(stock);

            int stockMinimo = Integer.parseInt(request.getParameter("stock_minimo"));

            if (stockMinimo < 0) {

                request.getSession().setAttribute(
                        "mensajeError",
                        "Stock mínimo inválido."
                );

                response.sendRedirect(
                        "controladorinventario?accion=listar");

                return;
            }

            p.setStockMinimo(stockMinimo);

            double precio =  Double.parseDouble(request.getParameter( "precio"));

            if (precio <= 0) {

                request.getSession().setAttribute(
                        "mensajeError",
                        "Precio inválido."
                );

                response.sendRedirect(
                        "controladorinventario?accion=listar");

                return;
            }

            p.setPrecio(precio);

            String fechaIngreso = request.getParameter(
                            "fecha_ingreso");

            String fechaVencimiento = request.getParameter(
                            "fecha_vencimiento");

            if (fechaIngreso != null
                    && !fechaIngreso.isEmpty()
                    && fechaVencimiento != null
                    && !fechaVencimiento.isEmpty()
                    && fechaVencimiento.compareTo(
                            fechaIngreso) < 0) {

                request.getSession().setAttribute(
                        "mensajeError",
                        "La fecha de vencimiento no puede ser menor a la fecha de ingreso."
                );

                response.sendRedirect(
                        "controladorinventario?accion=listar");

                return;
            }

            p.setFechaIngreso(fechaIngreso);
            p.setFechaVencimiento(fechaVencimiento);

            String proveedor = request.getParameter("proveedor");

            if (proveedor != null
                    && !proveedor.trim().isEmpty()
                    && !proveedor.matches(
                            "^[a-zA-ZáéíóúÁÉÍÓÚñÑ0-9\\s\\-.,]+$")) {

                request.getSession().setAttribute(
                        "mensajeError",
                        "Proveedor inválido."
                );

                response.sendRedirect(
                        "controladorinventario?accion=listar");

                return;
            }

            p.setProveedor(proveedor);

            if (dao.actualizarProducto(p)) {
                request.getSession().setAttribute("mensajeExito", "Producto actualizado exitosamente.");
            } else {
                request.getSession().setAttribute("mensajeError", "No se pudo actualizar el producto.");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("mensajeError", "Error al procesar la edición.");
        }
        response.sendRedirect("controladorinventario?accion=listar");
    }

    private void eliminar(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            if (dao.eliminarProducto(id)) {
                request.getSession().setAttribute("mensajeExito", "Producto desactivado correctamente.");
            } else {
                request.getSession().setAttribute("mensajeError", "No se pudo desactivar el producto.");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("mensajeError", "Error al desactivar: " + e.getMessage());
        }
        response.sendRedirect("controladorinventario?accion=listar");
    }
    private void reactivar(HttpServletRequest request,
            HttpServletResponse response) throws IOException {

        try {

            int id = Integer.parseInt(
                    request.getParameter("id"));

            if (dao.reactivarProducto(id)) {

                request.getSession().setAttribute("mensajeExito","Producto reactivado correctamente");

            } else {

                request.getSession().setAttribute("mensajeError","No se pudo reactivar");

            }

        } catch (Exception e) {

            request.getSession().setAttribute("mensajeError",e.getMessage());

        }

        response.sendRedirect("controladorinventario?accion=listar");
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }
}