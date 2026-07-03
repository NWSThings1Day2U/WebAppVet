package dao;

import conexion.conexionvet_bd;
import modelo.usuarios;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import util.encriptar;

public class usuariodao {

    public usuarios validar(String user, String passEscrita) {
        usuarios us = null;
        String sql = "{call sp_validar_usuario(?)}";

        try (Connection cn = conexionvet_bd.probarConexion();
             CallableStatement cs = cn.prepareCall(sql)) {

            cs.setString(1, user);

            try (ResultSet rs = cs.executeQuery()) {
                if (rs.next()) {
                    if (encriptar.verificar(passEscrita, rs.getString("contrasena"))) {
                        us = new usuarios();
                        us.setIdUsuario(rs.getInt("id_usuario"));
                        us.setNombreusuario(rs.getString("nombreusuario"));
                        us.setRol(rs.getString("rol"));
                        us.setImagen(rs.getString("imagen"));
                        us.setCorreo(rs.getString("correo"));
                        us.setDni(rs.getString("dni"));
                        us.setNombrecompleto(rs.getString("nombre_completo"));
                        us.setTelefono(rs.getString("telefono"));
                        us.setIdCliente(rs.getInt("id_cliente"));
                        us.setFechaRegistro(rs.getString("fecha_registro"));
                        us.setEstadoCliente(rs.getInt("estado_cliente"));
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return us;
    }

    public boolean registrar(String user, String pass, String nombre, String dni, String correo, String telefono) {
        String sql = "{call sp_registrar_cliente_web(?,?,?,?,?,?,?)}";

        try (Connection cn = conexionvet_bd.probarConexion();
             CallableStatement cs = cn.prepareCall(sql)) {

            cs.setString(1, user);
            cs.setString(2, encriptar.encriptar(pass));
            cs.setString(3, nombre);
            cs.setString(4, dni);
            cs.setString(5, correo);
            cs.setString(6, telefono);
            cs.registerOutParameter(7, Types.INTEGER);

            cs.executeUpdate();
            return cs.getInt(7) == 1;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<usuarios> listarUsuarios() {
        List<usuarios> lista = new ArrayList<>();
        String sql = "{call sp_listar_usuarios_registrados()}";

        try (Connection cn = conexionvet_bd.probarConexion();
             CallableStatement cs = cn.prepareCall(sql);
             ResultSet rs = cs.executeQuery()) {

            while (rs.next()) {
                usuarios us = new usuarios();
                us.setIdUsuario(rs.getInt("id_usuario"));
                us.setNombreusuario(rs.getString("nombreusuario"));
                us.setRol(rs.getString("rol"));
                us.setNombrecompleto(rs.getString("nombre_completo"));
                us.setDni(rs.getString("dni"));
                us.setCorreo(rs.getString("correo"));
                us.setTelefono(rs.getString("telefono"));
                us.setEstadoCliente(rs.getInt("estado_cuenta"));
                lista.add(us);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return lista;
    }

    public boolean editarUsuarioCompleto(usuarios u, int nuevoIdRol) {
        String sqlEditar = "{call sp_admin_editar_usuario(?,?,?,?,?,?)}";
        String sqlRol = "{call sp_cambiar_rol_usuario(?,?)}";

        try (Connection cn = conexionvet_bd.probarConexion()) {

            try (CallableStatement cs1 = cn.prepareCall(sqlEditar)) {
                cs1.setInt(1, u.getIdUsuario());
                cs1.setString(2, u.getNombreusuario());
                cs1.setString(3, u.getNombrecompleto());
                cs1.setString(4, u.getDni());
                cs1.setString(5, u.getCorreo());
                cs1.setString(6, u.getTelefono());
                cs1.executeUpdate();
            }

            try (CallableStatement cs2 = cn.prepareCall(sqlRol)) {
                cs2.setInt(1, u.getIdUsuario());
                cs2.setInt(2, nuevoIdRol);
                cs2.executeUpdate();
            }

            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean cambiarEstadoUsuario(int idUsuario, int nuevoEstado) {
        String sql = "{call sp_eliminar_usuario_logico(?,?)}";

        try (Connection cn = conexionvet_bd.probarConexion();
             CallableStatement cs = cn.prepareCall(sql)) {

            cs.setInt(1, idUsuario);
            cs.setInt(2, nuevoEstado);
            cs.executeUpdate();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public int iniciarRecuperacion(String correo, String codigo) {
        int idUsuario = 0;
        String sql = "{call sp_iniciar_recuperacion_universal(?, ?, ?)}";

        try (Connection cn = conexionvet_bd.probarConexion();
             CallableStatement cs = cn.prepareCall(sql)) {

            cs.setString(1, correo);
            cs.setString(2, codigo);
            cs.registerOutParameter(3, Types.INTEGER);
            cs.execute();

            idUsuario = cs.getInt(3);

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return idUsuario;
    }

    public boolean verificarYActualizar(int idUsuario, String codigo, String nuevaPass) {
        boolean resultado = false;
        String sql = "{call sp_verificar_y_actualizar(?,?,?,?)}";

        try (Connection cn = conexionvet_bd.probarConexion();
             CallableStatement cs = cn.prepareCall(sql)) {

            cs.setInt(1, idUsuario);
            cs.setString(2, codigo);
            cs.setString(3, encriptar.encriptar(nuevaPass));
            cs.registerOutParameter(4, Types.INTEGER);

            cs.execute();
            resultado = cs.getInt(4) == 1;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return resultado;
    }
}