package dao;

import conexion.conexionvet_bd;
import modelo.clientes;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class clientedao {

    private Connection cn = null;
    private CallableStatement cs = null;
    private ResultSet rs = null;

    // 1. METODO LISTAR CLIENTES
    public List<clientes> listarClientes() {
        List<clientes> lista = new ArrayList<>();
        String sql = "{call sp_listar_clientes()}";

        try {
            cn = conexionvet_bd.probarConexion();
            cs = cn.prepareCall(sql);
            rs = cs.executeQuery();

            while (rs.next()) {
                clientes c = new clientes();
                c.setIdCliente(rs.getInt("id_cliente"));
                c.setNombreCompleto(rs.getString("nombre_completo"));
                c.setDni(rs.getString("dni"));
                c.setCorreo(rs.getString("correo"));
                c.setTelefono(rs.getString("telefono"));
                c.setEstado(rs.getInt("estado"));
                c.setFechaRegistro(rs.getDate("fecha_registro"));

                c.setIdClienteResponsable( rs.getInt("id_cliente_responsable"));

                c.setNombreResponsable(rs.getString("nombre_responsable")
                );
                lista.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return lista;
    }

    // 2. METODO CREAR CLIENTE
    public boolean crearCliente(clientes c) {

        String sql = "{call sp_crear_cliente(?, ?, ?, ?, ?)}";

        try {

            cn = conexionvet_bd.probarConexion();
            cs = cn.prepareCall(sql);

            if (c.getIdClienteResponsable() == 0) {
                cs.setNull(1, Types.INTEGER);
            } else {
                cs.setInt(1, c.getIdClienteResponsable());
            }

            cs.setString(2, c.getNombreCompleto());
            cs.setString(3, c.getDni());
            cs.setString(4, c.getCorreo());
            cs.setString(5, c.getTelefono());

            return cs.executeUpdate() > 0;

        } catch (Exception e) {

            e.printStackTrace();
            return false;

        } finally {

            closeResources();

        }
    }

    // 3. METODO EDITAR CLIENTE
    public boolean editarCliente(clientes c) {
        String sql = "{call sp_editar_cliente(?, ?, ?, ?, ?, ?)}";
        try {
            cn = conexionvet_bd.probarConexion();
            cs = cn.prepareCall(sql);
            cs.setInt(1, c.getIdCliente());
            cs.setString(2, c.getNombreCompleto());
            cs.setString(3, c.getDni());
            cs.setString(4, c.getCorreo());
            cs.setString(5, c.getTelefono());
            cs.setInt(6, c.getEstado());

            return cs.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources();
        }
    }

    // 4. METODO ELIMINAR CLIENTE
    public boolean eliminarCliente(int idCliente) {
        String sql = "{call sp_eliminar_cliente(?)}";
        try {
            cn = conexionvet_bd.probarConexion();
            cs = cn.prepareCall(sql);
            cs.setInt(1, idCliente);

            return cs.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error al eliminar cliente (posiblemente tiene mascotas/citas asociadas): " + e.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    // 5. Metodo listar clientes principales
    public List<clientes> listarPrincipales() {

        List<clientes> lista = new ArrayList<>();

        String sql = "{call sp_listar_clientes_principales()}";

        try {

            cn = conexionvet_bd.probarConexion();
            cs = cn.prepareCall(sql);
            rs = cs.executeQuery();

            while (rs.next()) {

                clientes c = new clientes();

                c.setIdCliente(rs.getInt("id_cliente"));
                c.setNombreCompleto(rs.getString("nombre_completo"));
                c.setDni(rs.getString("dni"));

                lista.add(c);
            }

        } catch (Exception e) {

            e.printStackTrace();

        } finally {

            closeResources();

        }

        return lista;
    }

    //6. contar clientes activos
    public int contarClientesActivos() {
        int total = 0;

        try {
            cn = conexionvet_bd.probarConexion();
            cs = cn.prepareCall("{call sp_contar_clientes_activos()}");
            rs = cs.executeQuery();

            if (rs.next()) {
                total = rs.getInt("total_activos");
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }

        return total;
    }

    //7. contar clientes nuevos
    public int contarClientesNuevos() {
        int total = 0;

        try {
            cn = conexionvet_bd.probarConexion();
            cs = cn.prepareCall("{call sp_contar_clientes_nuevos()}");
            rs = cs.executeQuery();

            if (rs.next()) {
                total = rs.getInt("total_nuevos");
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }

        return total;
    }
    //8. Mostrar todos los clientes de un cliente logueado
    public List<clientes> listarClientesPorUsuario(int idUsuario) {

        List<clientes> lista = new ArrayList<>();

        String sql = "{call sp_listar_clientes_por_usuario(?)}";

        try {

            cn = conexionvet_bd.probarConexion();
            cs = cn.prepareCall(sql);

            cs.setInt(1, idUsuario);

            rs = cs.executeQuery();

            while (rs.next()) {

                clientes c = new clientes();

                c.setIdCliente(rs.getInt("id_cliente"));
                c.setIdUsuario(rs.getInt("id_usuario"));
                c.setNombreCompleto(rs.getString("nombre_completo"));
                c.setDni(rs.getString("dni"));
                c.setCorreo(rs.getString("correo"));
                c.setTelefono(rs.getString("telefono"));
                c.setEstado(rs.getInt("estado"));
                c.setFechaRegistro(rs.getDate("fecha_registro"));
                c.setIdClienteResponsable(
                        rs.getInt("id_cliente_responsable")
                );

                lista.add(c);
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
            System.out.println("Error al cerrar recursos: " + e.getMessage());
        }
    }
}
