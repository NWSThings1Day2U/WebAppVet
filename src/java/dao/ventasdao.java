package dao;

import conexion.conexionvet_bd;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import modelo.ventas;
import modelo.ventas.Detalle;

public class ventasdao {

    private Connection cn = null;
    private CallableStatement cs = null;
    private ResultSet rs = null;

    // 1. LISTAR TODAS LAS VENTAS
    public List<ventas> listarVentas() {
        List<ventas> lista = new ArrayList<>();
        try {
            cn = conexionvet_bd.probarConexion();
            cs = cn.prepareCall("{call sp_listar_ventas()}");
            rs = cs.executeQuery();

            while (rs.next()) {
                ventas v = new ventas();
                v.setIdVenta(rs.getInt("id_venta"));
                v.setIdCliente(rs.getInt("id_cliente"));
                v.setCliente(rs.getString("nombre_cliente") != null ? rs.getString("nombre_cliente") : "PÚBLICO GENERAL");
                v.setFecha(rs.getString("fecha"));
                v.setMetodoPago(rs.getString("metodo_pago"));
                v.setDescuento(rs.getDouble("descuento"));
                v.setTotal(rs.getDouble("total"));
                lista.add(v);
            }
        } catch (Exception e) {
            System.out.println("Error en listarVentas: " + e.getMessage());
        } finally {
            closeResources();
        }
        return lista;
    }

    // 2. VER DETALLE DE UNA VENTA ESPECÍFICA
    public List<Detalle> verDetalleVenta(int idVenta) {
        List<Detalle> listaDetalles = new ArrayList<>();
        try {
            cn = conexionvet_bd.probarConexion();
            cs = cn.prepareCall("{call sp_ver_detalle_venta(?)}");
            cs.setInt(1, idVenta);
            rs = cs.executeQuery();

            while (rs.next()) {
                Detalle d = new Detalle();
                d.setIdDetalle(rs.getInt("id_detalle"));
                d.setIdProducto(rs.getInt("id_producto"));
                d.setNombreProducto(rs.getString("nombre_producto"));
                d.setCantidad(rs.getInt("cantidad"));
                d.setPrecioUnitario(rs.getDouble("precio_unitario"));
                d.setSubtotal(rs.getDouble("subtotal"));
                listaDetalles.add(d);
            }
        } catch (Exception e) {
            System.out.println("Error en verDetalleVenta: " + e.getMessage());
        } finally {
            closeResources();
        }
        return listaDetalles;
    }

    public boolean registrarVentaCompleta(ventas v) {
        try {
            cn = conexionvet_bd.probarConexion();
            
            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call sp_crear_venta_cabecera(?, ?, ?, ?, ?)}");
            cs.setInt(1, v.getIdCliente());
            cs.setString(2, v.getMetodoPago());
            cs.setDouble(3, v.getDescuento());
            cs.setDouble(4, v.getTotal());
            cs.registerOutParameter(5, Types.INTEGER); 
            cs.executeUpdate();

            int idVentaGenerado = cs.getInt(5);
            cs.close(); 
            cs = cn.prepareCall("{call sp_crear_venta_detalle(?, ?, ?, ?)}");
            for (Detalle d : v.getDetalles()) {
                cs.setInt(1, idVentaGenerado);
                cs.setInt(2, d.getIdProducto());
                cs.setInt(3, d.getCantidad());
                cs.setDouble(4, d.getPrecioUnitario());
                cs.addBatch(); 
            }
            
            cs.executeBatch(); 
            cn.commit();      
            return true;

        } catch (Exception e) {
            System.out.println("Error en registrarVentaCompleta. Aplicando Rollback...: " + e.getMessage());
            try {
                if (cn != null) cn.rollback(); 
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            return false;
        } finally {
            closeResources();
        }
    }

    // 4. ANULAR VENTA COMPLETA
    public boolean anularVenta(int idVenta) {
        try {
            cn = conexionvet_bd.probarConexion();
            cs = cn.prepareCall("{call sp_anular_venta(?)}");
            cs.setInt(1, idVenta);
            int filasAfectadas = cs.executeUpdate();
            return true; 
        } catch (Exception e) {
            System.out.println("Error al anular venta: " + e.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    private void closeResources() {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (cs != null) cs.close(); } catch (Exception e) {}
        try { if (cn != null) {
            cn.setAutoCommit(true); 
            cn.close(); 
        }} catch (Exception e) {}
    }
}