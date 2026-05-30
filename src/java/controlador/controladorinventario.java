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
            p.setNombre(request.getParameter("nombre"));
            p.setIdCategoria(Integer.parseInt(request.getParameter("id_categoria")));
            p.setStock(Integer.parseInt(request.getParameter("stock")));
            p.setStockMinimo(Integer.parseInt(request.getParameter("stock_minimo")));
            p.setPrecio(Double.parseDouble(request.getParameter("precio")));
            p.setFechaIngreso(request.getParameter("fecha_ingreso"));
            p.setFechaVencimiento(request.getParameter("fecha_vencimiento"));
            p.setProveedor(request.getParameter("proveedor"));

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
            p.setNombre(request.getParameter("nombre"));
            p.setIdCategoria(Integer.parseInt(request.getParameter("id_categoria")));
            p.setStock(Integer.parseInt(request.getParameter("stock")));
            p.setStockMinimo(Integer.parseInt(request.getParameter("stock_minimo")));
            p.setPrecio(Double.parseDouble(request.getParameter("precio")));
            p.setFechaIngreso(request.getParameter("fecha_ingreso"));
            p.setFechaVencimiento(request.getParameter("fecha_vencimiento"));
            p.setProveedor(request.getParameter("proveedor"));

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
                request.getSession().setAttribute("mensajeExito", "Producto dado de baja correctamente.");
            } else {
                request.getSession().setAttribute("mensajeError", "No se pudo eliminar el producto.");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("mensajeError", "Error al eliminar: " + e.getMessage());
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