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
    //Calcular ventas
    public double totalVentasHoy() {
        double total = 0;
        try {
            cn = conexionvet_bd.probarConexion();
            String sql
                    = "SELECT IFNULL(SUM(total),0) total "
                    + "FROM ventas "
                    + "WHERE DATE(fecha)=CURDATE()";
            PreparedStatement ps
                    = cn.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) {
                total = rs.getDouble("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return total;
    }
    // TOTAL DE VENTAS REGISTRADAS
    public int contarVentas() {
        int total = 0;
        try {
            cn = conexionvet_bd.probarConexion();
            String sql
                    = "SELECT COUNT(*) total FROM ventas";
            PreparedStatement ps
                    = cn.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) {
                total = rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return total;
    }
    
    public double ingresosTotales() {

        double total = 0;

        try {

            String sql
                    = "SELECT IFNULL(SUM(total),0) total FROM ventas";

            PreparedStatement ps
                    = cn.prepareStatement(sql);

            ResultSet rs
                    = ps.executeQuery();

            if (rs.next()) {
                total = rs.getDouble("total");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return total;
    }
    //ventas semanales
    public double[] ventasSemana() {
        double datos[] = new double[7];
        try {
            cn = conexionvet_bd.probarConexion();
            String sql
                    = "SELECT DAYOFWEEK(fecha) dia, "
                    + "SUM(total) total "
                    + "FROM ventas "
                    + "WHERE fecha >= DATE_SUB(CURDATE(), INTERVAL 7 DAY) "
                    + "GROUP BY DAYOFWEEK(fecha)";
            PreparedStatement ps
                    = cn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                int dia
                        = rs.getInt("dia");
                datos[dia - 1]
                        = rs.getDouble("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return datos;
    }
    //ultimas ventas - 04-06-26
    public List<ventas> ultimasVentas() {
        List<ventas> lista = new ArrayList<>();
        try {
            cn = conexionvet_bd.probarConexion();
            String sql
                    = "SELECT v.*, "
                    + "IFNULL(c.nombre_completo,'PUBLICO GENERAL') cliente "
                    + "FROM ventas v "
                    + "LEFT JOIN clientes c ON v.id_cliente=c.id_cliente "
                    + "ORDER BY v.id_venta DESC "
                    + "LIMIT 5";
            PreparedStatement ps
                    = cn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                ventas v = new ventas();
                v.setIdVenta(
                        rs.getInt("id_venta"));
                v.setCliente(
                        rs.getString("cliente"));
                v.setFecha(
                        rs.getString("fecha"));
                v.setTotal(
                        rs.getDouble("total"));
                lista.add(v);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return lista;
    }
    
    //ingresos del mes
    public double ingresosMes() {
        double total = 0;
        try {
            cn = conexionvet_bd.probarConexion();
            String sql
                    = "SELECT IFNULL(SUM(total),0) total "
                    + "FROM ventas "
                    + "WHERE MONTH(fecha)=MONTH(CURDATE()) "
                    + "AND YEAR(fecha)=YEAR(CURDATE())";
            PreparedStatement ps
                    = cn.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) {
                total
                        = rs.getDouble("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return total;
    }
    //INGRESOS ULTIM 12 MESES - 04-06-26
    public double[] ingresosUltimos12Meses() {
        double datos[] = new double[12];
        try {
            cn = conexionvet_bd.probarConexion();
            String sql
                    = "SELECT MONTH(fecha) mes, "
                    + "SUM(total) total "
                    + "FROM ventas "
                    + "WHERE YEAR(fecha)=YEAR(CURDATE()) "
                    + "GROUP BY MONTH(fecha)";
            PreparedStatement ps
                    = cn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                int mes = rs.getInt("mes");
                datos[mes - 1]
                        = rs.getDouble("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return datos;
    }
    //KPI CRECIM MENSUAL - 04-06-26
    public double crecimientoMensual() {
        double actual = 0;
        double anterior = 0;
        try {
            cn = conexionvet_bd.probarConexion();
            String sql1
                    = "SELECT IFNULL(SUM(total),0) total "
                    + "FROM ventas "
                    + "WHERE MONTH(fecha)=MONTH(CURDATE())";
            PreparedStatement ps1
                    = cn.prepareStatement(sql1);
            rs = ps1.executeQuery();
            if (rs.next()) {
                actual = rs.getDouble("total");
            }
            rs.close();
            String sql2
                    = "SELECT IFNULL(SUM(total),0) total "
                    + "FROM ventas "
                    + "WHERE MONTH(fecha)=MONTH(CURDATE())-1";
            PreparedStatement ps2
                    = cn.prepareStatement(sql2);
            rs = ps2.executeQuery();
            if (rs.next()) {
                anterior = rs.getDouble("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        if (anterior == 0) {
            return 100;
        }
        return ((actual - anterior) / anterior) * 100;
    }
    
    
    public int productosVendidosMes() {
        int total = 0;
        try {
            cn = conexionvet_bd.probarConexion();
            String sql
                    = "SELECT IFNULL(SUM(cantidad),0) total "
                    + "FROM detalle_venta dv "
                    + "INNER JOIN ventas v ON dv.id_venta=v.id_venta "
                    + "WHERE MONTH(v.fecha)=MONTH(CURDATE()) "
                    + "AND YEAR(v.fecha)=YEAR(CURDATE())";
            PreparedStatement ps
                    = cn.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) {
                total = rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return total;
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