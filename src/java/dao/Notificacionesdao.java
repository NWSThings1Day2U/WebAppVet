package dao;

import conexion.conexionvet_bd;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import modelo.Notificacion;
import modelo.Notificaciones;

public class Notificacionesdao {

    Connection cn;
    PreparedStatement ps;
    ResultSet rs;

    public boolean registrarNotificacion(
            int idUsuario,
            String titulo,
            String mensaje,
            String tipo,
            int idReferencia) {

        try {

            cn = conexionvet_bd.probarConexion();
            
            String sql
                    = "INSERT INTO notificaciones "
                    + "(id_usuario,titulo,mensaje,tipo,id_referencia) "
                    + "VALUES(?,?,?,?,?)";
            
            ps = cn.prepareStatement(sql);

            ps.setInt(1, idUsuario);
            ps.setString(2, titulo);
            ps.setString(3, mensaje);
            ps.setString(4, tipo);
            ps.setInt(5, idReferencia);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {

            e.printStackTrace();

        } finally {

            closeResources();

        }

        return false;
    }
    
    public List<Notificacion> listarPorUsuario(
            int idUsuario) {
        List<Notificacion> lista
                = new ArrayList<>();
        try {
            cn = conexionvet_bd.probarConexion();

            String sql
                    = "SELECT * "
                    + "FROM notificaciones "
                    + "WHERE id_usuario=? "
                    + "ORDER BY fecha DESC "
                    + "LIMIT 20";

            ps = cn.prepareStatement(sql);
            ps.setInt(1, idUsuario);
            rs = ps.executeQuery();

            while (rs.next()) {
                Notificacion n
                        = new Notificacion();
                n.setIdNotificacion(
                        rs.getInt("id_notificacion"));
                n.setTitulo(
                        rs.getString("titulo"));
                n.setMensaje(
                        rs.getString("mensaje"));
                n.setFecha(
                        rs.getString("fecha"));
                n.setLeido(
                        rs.getInt("leido"));
                lista.add(n);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return lista;
    }
    
    public int contarNoLeidas(int idUsuario) {

        try {
            cn = conexionvet_bd.probarConexion();
            
            String sql
                    = "SELECT COUNT(*) total "
                    + "FROM notificaciones "
                    + "WHERE id_usuario=? "
                    + "AND leido=0";

            ps = cn.prepareStatement(sql);
            ps.setInt(1, idUsuario);
            rs = ps.executeQuery();

            if (rs.next()) {

                return rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public int obtenerUsuarioPorCliente(int idCliente) {

        int idUsuario = 0;

        try {

            cn = conexionvet_bd.probarConexion();

            String sql =
            "SELECT " +
            "COALESCE(c.id_usuario, cr.id_usuario) AS id_usuario " +
            "FROM clientes c " +
            "LEFT JOIN clientes cr " +
            "ON c.id_cliente_responsable = cr.id_cliente " +
            "WHERE c.id_cliente = ?";

            ps = cn.prepareStatement(sql);

            ps.setInt(1, idCliente);

            rs = ps.executeQuery();

            if(rs.next()){
                idUsuario = rs.getInt("id_usuario");
            }

        } catch(Exception e){
            e.printStackTrace();
        } finally{
            closeResources();
        }

        return idUsuario;
    }

    public int obtenerAdministradorPrincipal() {
        int idAdmin = 0;
        try {

            cn = conexionvet_bd.probarConexion();
            String sql
                    = "SELECT u.id_usuario "
                    + "FROM usuarios u "
                    + "INNER JOIN usuario_rol ur "
                    + "ON u.id_usuario = ur.id_usuario "
                    + "WHERE ur.id_rol = 1 "
                    + "LIMIT 1";

            ps = cn.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) {

                idAdmin = rs.getInt("id_usuario");

            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return idAdmin;
    }
    
    public int contarCitasPendientes() {
        int total = 0;
        try {
            cn = conexionvet_bd.probarConexion();
            ps = cn.prepareStatement(
                    "SELECT COUNT(*) total "
                    + "FROM citas "
                    + "WHERE estado='PENDIENTE'"
            );
            rs = ps.executeQuery();
            if (rs.next()) {

                total = rs.getInt("total");

            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return total;
    }
    
    public boolean existeNotificacionPendientesHoy() {
        try {
            cn = conexionvet_bd.probarConexion();
            String sql
                    = "SELECT COUNT(*) total "
                    + "FROM notificaciones "
                    + "WHERE titulo='Citas Pendientes' "
                    + "AND DATE(fecha)=CURDATE()";
            
            ps = cn.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("total") > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    private void closeResources() {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (cn != null) cn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}