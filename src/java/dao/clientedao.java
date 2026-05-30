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

                lista.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); if (cs != null) cs.close(); } catch (Exception e) {}
        }
        return lista;
    }

    // 2. METODO CREAR CLIENTE
    public boolean crearCliente(clientes c) {
        String sql = "{call sp_crear_cliente(?, ?, ?, ?)}";
        try {
            cn = conexionvet_bd.probarConexion();
            cs = cn.prepareCall(sql);
            cs.setString(1, c.getNombreCompleto());
            cs.setString(2, c.getDni());
            cs.setString(3, c.getCorreo());
            cs.setString(4, c.getTelefono());
            
            return cs.executeUpdate() > 0; 
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            try { if (cs != null) cs.close(); } catch (Exception e) {}
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
            try { if (cs != null) cs.close(); } catch (Exception e) {}
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
            try { if (cs != null) cs.close(); } catch (Exception e) {}
        }
    }
}