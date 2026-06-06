package dao;

import conexion.conexionvet_bd;
import modelo.productos;

import java.sql.*;
import java.util.*;

public class productodao {

    private Connection cn = null;
    private CallableStatement cs = null; 
    private ResultSet rs = null;

    // 1. LISTAR PRODUCTOS
    public List<productos> listarProductos() {
        List<productos> lista = new ArrayList<>();
        try {
            cn = conexionvet_bd.probarConexion();
            cs = cn.prepareCall("{call sp_listar_productos()}");
            rs = cs.executeQuery();

            while (rs.next()) {
                productos p = new productos();

                p.setIdProducto(rs.getInt("id_producto"));
                p.setNombre(rs.getString("nombre"));
                p.setIdCategoria(rs.getInt("id_categoria"));
                p.setNombreCategoria(rs.getString("nombre_categoria")); 
                p.setStock(rs.getInt("stock"));
                p.setStockMinimo(rs.getInt("stock_minimo"));
                p.setPrecio(rs.getDouble("precio"));
                p.setFechaIngreso(rs.getString("fecha_ingreso"));
                p.setFechaVencimiento(rs.getString("fecha_vencimiento"));
                p.setProveedor(rs.getString("proveedor"));
                p.setEstado(rs.getString("estado"));

                lista.add(p);
            }
        } catch (Exception e) {
            System.out.println("Error en listarProductos: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return lista;
    }

    // 2. INSERTAR PRODUCTO
    public boolean insertarProducto(productos p) {
        try {
            cn = conexionvet_bd.probarConexion();
            cs = cn.prepareCall("{call sp_crear_producto(?, ?, ?, ?, ?, ?, ?, ?)}");

            cs.setString(1, p.getNombre());
            cs.setInt(2, p.getIdCategoria());
            cs.setInt(3, p.getStock());
            cs.setInt(4, p.getStockMinimo());
            cs.setDouble(5, p.getPrecio());
            cs.setString(6, p.getFechaIngreso());       
            cs.setString(7, p.getFechaVencimiento()); 
            cs.setString(8, p.getProveedor());

            int filasAfectadas = cs.executeUpdate();
            return filasAfectadas > 0;
        } catch (Exception e) {
            System.out.println("Error en insertarProducto: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResources();
        }
    }

    // 3. ACTUALIZAR PRODUCTO
    public boolean actualizarProducto(productos p) {
        try {
            cn = conexionvet_bd.probarConexion();
            cs = cn.prepareCall("{call sp_editar_producto(?, ?, ?, ?, ?, ?, ?, ?, ?)}");

            cs.setInt(1, p.getIdProducto());
            cs.setString(2, p.getNombre());
            cs.setInt(3, p.getIdCategoria());
            cs.setInt(4, p.getStock());
            cs.setInt(5, p.getStockMinimo());
            cs.setDouble(6, p.getPrecio());
            cs.setString(7, p.getFechaIngreso());
            cs.setString(8, p.getFechaVencimiento());
            cs.setString(9, p.getProveedor());

            int filasAfectadas = cs.executeUpdate();
            return filasAfectadas > 0;
        } catch (Exception e) {
            System.out.println("Error en actualizarProducto: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResources();
        }
    }

    // 4. ELIMINAR PRODUCTO 
    public boolean eliminarProducto(int id) {
        try {
            cn = conexionvet_bd.probarConexion();
            cs = cn.prepareCall("{call sp_eliminar_producto(?)}");
            cs.setInt(1, id);

            int filasAfectadas = cs.executeUpdate();
            return filasAfectadas > 0;
        } catch (Exception e) {
            System.out.println("Error en eliminarProducto: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResources();
        }
    }
    //buscar x idprod

    public productos buscarPorId(int idProducto) {
        productos p = null;
        try {
            List<productos> lista
                    = listarProductos();
            for (productos prod : lista) {
                if (prod.getIdProducto() == idProducto) {
                    p = prod;
                    break;
                }
            }
        } catch (Exception e) {
            System.out.println("Error buscarPorId: "+ e.getMessage());
        }
        return p;
    }
    
    
    // CONTAR PRODUCTOS
    public int contarProductos() {
        cn = conexionvet_bd.probarConexion();
        int total = 0;

        try {
            
            cn = conexionvet_bd.probarConexion();
            String sql
                    = "SELECT COUNT(*) total FROM productos";

            PreparedStatement ps
                    = cn.prepareStatement(sql);

            ResultSet rs
                    = ps.executeQuery();

            if (rs.next()) {
                total = rs.getInt("total");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return total;
    }
    
    //productos top - 04-06-26

    public List<Object[]> topProductosVendidos() {
        List<Object[]> lista
                = new ArrayList<>();
        try {
            cn = conexionvet_bd.probarConexion();
            String sql
                    = "SELECT p.nombre, "
                    + "SUM(dv.cantidad) vendidos "
                    + "FROM detalle_venta dv "
                    + "INNER JOIN productos p "
                    + "ON dv.id_producto=p.id_producto "
                    + "GROUP BY p.nombre "
                    + "ORDER BY vendidos DESC "
                    + "LIMIT 5";
            PreparedStatement ps
                    = cn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Object fila[] = new Object[2];
                fila[0] = rs.getString("nombre");
                fila[1] = rs.getInt("vendidos");
                lista.add(fila);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return lista;
    }
    
    //productos x vencer - 04-06-26
    public List<productos> productosPorVencer() {
        List<productos> lista = new ArrayList<>();
        try {
            cn = conexionvet_bd.probarConexion();
            String sql
                    = "SELECT * "
                    + "FROM productos "
                    + "WHERE fecha_vencimiento BETWEEN CURDATE() "
                    + "AND DATE_ADD(CURDATE(),INTERVAL 30 DAY) "
                    + "ORDER BY fecha_vencimiento ASC";
            PreparedStatement ps
                    = cn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                productos p = new productos();
                p.setIdProducto(
                        rs.getInt("id_producto"));
                p.setNombre(
                        rs.getString("nombre"));
                p.setFechaVencimiento(
                        rs.getString("fecha_vencimiento"));
                lista.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return lista;
    }
    
    //productos criticos
    public List<productos> productosCriticos() {
        List<productos> lista
                = new ArrayList<>();
        try {
            cn = conexionvet_bd.probarConexion();
            String sql
                    = "SELECT * "
                    + "FROM productos "
                    + "WHERE stock <= stock_minimo "
                  /*  + "AND estado='Activo' " */
                    + "ORDER BY stock ASC";
            PreparedStatement ps
                    = cn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                productos p
                        = new productos();
                p.setIdProducto(
                        rs.getInt("id_producto"));
                p.setNombre(
                        rs.getString("nombre"));
                p.setStock(
                        rs.getInt("stock"));
                p.setStockMinimo(
                        rs.getInt("stock_minimo"));
                lista.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return lista;
    }
                    
    private void closeResources() {
        try {
            if (rs != null) rs.close();
            if (cs != null) cs.close();
            if (cn != null) cn.close();
        } catch (Exception e) {
            System.out.println("Error al cerrar recursos en productodao: " + e.getMessage());
        }
    }
}