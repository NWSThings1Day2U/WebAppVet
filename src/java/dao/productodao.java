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
            System.out.println(
                    "Error buscarPorId: "
                    + e.getMessage());
        }
        return p;
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