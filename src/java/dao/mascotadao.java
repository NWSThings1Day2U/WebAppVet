package dao;

import conexion.conexionvet_bd;
import modelo.mascotas;

import java.sql.*;
import java.util.*;

public class mascotadao {

    private Connection cn = null;
    private CallableStatement cs = null;
    private ResultSet rs = null;

    // 1. LISTAR TODAS LAS MASCOTAS
    public List<mascotas> listarMascotas() {
        List<mascotas> lista = new ArrayList<>();
        try {
            cn = conexionvet_bd.probarConexion();
            cs = cn.prepareCall("{call sp_listar_mascotas()}");
            rs = cs.executeQuery();

            while (rs.next()) {
                mascotas m = new mascotas();
                m.setIdMascota(rs.getInt("id_mascota"));
                m.setIdCliente(rs.getInt("id_cliente"));
                m.setNombreCliente(rs.getString("nombre_cliente"));
                m.setNombre(rs.getString("nombre"));
                m.setEspecie(rs.getString("especie"));
                m.setRaza(rs.getString("raza"));
                m.setPeso(rs.getDouble("peso"));
                m.setFechaNacimiento(rs.getString("fecha_nacimiento"));
                m.setSexo(rs.getString("sexo"));
                m.setEstado(rs.getString("estado"));

                lista.add(m);
            }
        } catch (Exception e) {
            System.out.println("Error en listarMascotas: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return lista;
    }

    // 2. LISTAR MASCOTAS POR CLIENTE LOGUEADO
    public List<mascotas> listarMascotasPorCliente(int idUsuario) {
        List<mascotas> lista = new ArrayList<>();
        try {
            cn = conexionvet_bd.probarConexion();
            cs = cn.prepareCall("{call sp_listar_mascotas_por_cliente(?)}");
            cs.setInt(1, idUsuario);
            rs = cs.executeQuery();

            while (rs.next()) {
                mascotas m = new mascotas();
                m.setIdMascota(rs.getInt("id_mascota"));
                m.setNombre(rs.getString("nombre"));
                m.setEspecie(rs.getString("especie"));
                m.setRaza(rs.getString("raza"));
                m.setPeso(rs.getDouble("peso"));
                m.setFechaNacimiento(rs.getString("fecha_nacimiento"));
                m.setSexo(rs.getString("sexo"));
                m.setEstado(rs.getString("estado"));

                lista.add(m);
            }
        } catch (Exception e) {
            System.out.println("Error en listarMascotasPorCliente: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return lista;
    }

    // 3. REGISTRAR NUEVA MASCOTA
    public boolean crearMascota(mascotas m) {
        try {
            cn = conexionvet_bd.probarConexion();
            cs = cn.prepareCall("{call sp_crear_mascota(?, ?, ?, ?, ?, ?, ?)}");

            cs.setInt(1, m.getIdCliente());
            cs.setString(2, m.getNombre());
            cs.setString(3, m.getEspecie());
            cs.setString(4, m.getRaza());
            cs.setDouble(5, m.getPeso());
            cs.setString(6, m.getFechaNacimiento());
            cs.setString(7, m.getSexo());

            int filasAfectadas = cs.executeUpdate();
            return filasAfectadas > 0;
        } catch (Exception e) {
            System.out.println("Error en crearMascota: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResources();
        }
    }

    // 4. EDITAR DATOS DE MASCOTA
    public boolean editarMascota(mascotas m) {
        try {
            cn = conexionvet_bd.probarConexion();
            cs = cn.prepareCall("{call sp_editar_mascota(?, ?, ?, ?, ?, ?, ?, ?, ?)}");

            cs.setInt(1, m.getIdMascota());
            cs.setInt(2, m.getIdCliente());
            cs.setString(3, m.getNombre());
            cs.setString(4, m.getEspecie());
            cs.setString(5, m.getRaza());
            cs.setDouble(6, m.getPeso());
            cs.setString(7, m.getFechaNacimiento());
            cs.setString(8, m.getSexo());
            cs.setString(9, m.getEstado());

            int filasAfectadas = cs.executeUpdate();
            return filasAfectadas > 0;
        } catch (Exception e) {
            System.out.println("Error en editarMascota: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResources();
        }
    }

    // 5. ELIMINAR MASCOTA
    public boolean eliminarMascota(int idMascota) {
        try {
            cn = conexionvet_bd.probarConexion();
            cs = cn.prepareCall("{call sp_eliminar_mascota(?)}");
            cs.setInt(1, idMascota);

            int filasAfectadas = cs.executeUpdate();
            return filasAfectadas > 0;
        } catch (Exception e) {
            System.out.println("Error en eliminarMascota: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResources();
        }
    }
    
    //6. Contar mascotas activas
    
    public int contarMascotas() {
        int total = 0;

        try {
            cn = conexionvet_bd.probarConexion();
            cs = cn.prepareCall("{call sp_contar_mascotas()}");
            rs = cs.executeQuery();

            if (rs.next()) {
                total = rs.getInt("total_mascotas");
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }

        return total;
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
