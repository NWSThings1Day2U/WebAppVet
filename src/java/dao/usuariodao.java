package dao;

import conexion.conexionvet_bd;
import modelo.usuarios;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import util.encriptar;

public class usuariodao {

    private Connection cn = null;
    private CallableStatement cs = null;
    private ResultSet rs = null;

    public usuarios validar(String user, String passEscrita) {
        usuarios us = null;
        try {
            cn = conexionvet_bd.probarConexion();
            cs = cn.prepareCall("{call sp_validar_usuario(?)}");
            cs.setString(1, user);
            rs = cs.executeQuery();

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
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return us;
    }

    //registrar los usuarios
    public boolean registrar(String user, String pass, String nombre, String dni, String correo, String telefono) {
        try {
            cn = conexionvet_bd.probarConexion();
            cs = cn.prepareCall("{call sp_registrar_cliente_web(?,?,?,?,?,?,?)}");
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
        } finally {
            closeResources();
        }
    }

    // Listar todos los usuarios
    public List<usuarios> listarUsuarios() {
        List<usuarios> lista = new ArrayList<>();
        try {
            cn = conexionvet_bd.probarConexion();
            cs = cn.prepareCall("{call sp_listar_usuarios_registrados()}");
            rs = cs.executeQuery();
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
        } finally {
            closeResources();
        }
        return lista;
    }

    // Editar datos del usuario
    public boolean editarUsuarioCompleto(usuarios u, int nuevoIdRol) {
        try {
            cn = conexionvet_bd.probarConexion();

            cs = cn.prepareCall("{call sp_admin_editar_usuario(?,?,?,?,?,?)}");
            cs.setInt(1, u.getIdUsuario());
            cs.setString(2, u.getNombreusuario());
            cs.setString(3, u.getNombrecompleto());
            cs.setString(4, u.getDni());
            cs.setString(5, u.getCorreo());
            cs.setString(6, u.getTelefono());
            cs.executeUpdate();
            cs.close();

            cs = cn.prepareCall("{call sp_cambiar_rol_usuario(?,?)}");
            cs.setInt(1, u.getIdUsuario());
            cs.setInt(2, nuevoIdRol);
            cs.executeUpdate();

            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources();
        }
    }

    // Eliminacion logica
    public boolean cambiarEstadoUsuario(int idUsuario, int nuevoEstado) {
        try {
            cn = conexionvet_bd.probarConexion();
            cs = cn.prepareCall("{call sp_eliminar_usuario_logico(?,?)}");
            cs.setInt(1, idUsuario);
            cs.setInt(2, nuevoEstado);
            cs.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources();
        }
    }

    //Recuperar contra
    public int iniciarRecuperacion(String correo, String codigo) {
        int idUsuario = 0;
        try (Connection cn = conexionvet_bd.probarConexion(); CallableStatement cs = cn.prepareCall("{call sp_iniciar_recuperacion_universal(?, ?, ?)}")) {

            cs.setString(1, correo);
            cs.setString(2, codigo);
            cs.registerOutParameter(3, java.sql.Types.INTEGER);
            cs.execute();

            idUsuario = cs.getInt(3);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return idUsuario; 
    }

    public boolean verificarYActualizar(int idUsuario, String codigo, String nuevaPass) {
        boolean resultado = false;

        try (Connection cn = conexionvet_bd.probarConexion(); CallableStatement cs = cn.prepareCall("{call sp_verificar_y_actualizar(?,?,?,?)}")) {

            cs.setInt(1, idUsuario);
            cs.setString(2, codigo);
            cs.setString(3, encriptar.encriptar(nuevaPass));
            cs.registerOutParameter(4, Types.INTEGER);

            cs.execute();

            resultado = cs.getInt(4) == 1;

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }

        return resultado;
    }

    private void closeResources() {
        try {
            if (rs != null) {
                rs.close();
            }
            if (cs != null) {
                cs.close();
            }
            if (cn != null) {
                cn.close();
            }
        } catch (Exception e) {
        }
    }
}
