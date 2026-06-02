package dao;

import conexion.conexionvet_bd;
import modelo.citas;

import java.sql.*;
import java.util.*;

public class citadao {
    private Connection cn;
    private CallableStatement cs; 
    private ResultSet rs;

    // Lista todas las citas
    public List<citas> listarCitas() {
        List<citas> lista = new ArrayList<>();
        try {
            cn = conexionvet_bd.probarConexion();
            cs = cn.prepareCall("{call sp_listar_citas()}");
            rs = cs.executeQuery();
            while(rs.next()){
                citas c = new citas();
                c.setIdCita(rs.getInt("id_cita"));
                c.setIdCliente(rs.getInt("id_cliente"));
                c.setCliente(rs.getString("nombre_cliente")); 
                c.setIdMascota(rs.getInt("id_mascota"));
                c.setMascota(rs.getString("nombre_mascota")); 
                c.setIdTipo(rs.getInt("id_tipo"));
                c.setFecha(rs.getString("fecha"));
                c.setHora(rs.getString("hora"));
                c.setMotivo(rs.getString("motivo"));
                c.setEstado(rs.getString("estado"));
                lista.add(c);
            }
        } catch(Exception e){
            System.out.println("Error en listarCitas: " + e.getMessage());
        } finally {
            closeResources();
        }
        return lista;
    }

    // Lista citas segun cliente
    public List<citas> listarCitasPorCliente(int idUsuario) {
        List<citas> lista = new ArrayList<>();
        try {
            cn = conexionvet_bd.probarConexion();
            cs = cn.prepareCall("{call sp_listar_citas_por_cliente(?)}");
            cs.setInt(1, idUsuario);
            rs = cs.executeQuery();
            while(rs.next()){
                citas c = new citas();
                c.setIdCita(rs.getInt("id_cita"));
                c.setIdCliente(rs.getInt("id_cliente"));
                c.setCliente(rs.getString("nombre_cliente"));
                c.setIdMascota(rs.getInt("id_mascota"));
                c.setMascota(rs.getString("nombre_mascota")); 
                c.setIdTipo(rs.getInt("id_tipo"));
                c.setFecha(rs.getString("fecha"));
                c.setHora(rs.getString("hora"));
                c.setMotivo(rs.getString("motivo"));
                c.setEstado(rs.getString("estado"));
                lista.add(c);
            }
        } catch(Exception e){
            System.out.println("Error en listarCitasPorCliente: " + e.getMessage());
        } finally {
            closeResources();
        }
        return lista;
    }

    // crear cita
    public boolean insertarCita(citas c){
        try{
            cn = conexionvet_bd.probarConexion();
            cs = cn.prepareCall("{call sp_crear_cita(?,?,?,?,?,?)}"); 
            cs.setInt(1, c.getIdCliente());
            cs.setInt(2, c.getIdMascota());
            cs.setInt(3, c.getIdTipo());
            cs.setString(4, c.getFecha());
            cs.setString(5, c.getHora());
            cs.setString(6, c.getMotivo());
            cs.executeUpdate();
            return true;
        }catch(Exception e){
            System.out.println("Error en insertarCita: " + e.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    // editar todos los datos de cita
    public boolean editarCita(citas c) {
        try {
            cn = conexionvet_bd.probarConexion();
            cs = cn.prepareCall("{call sp_editar_cita(?,?,?,?,?,?,?)}");
            cs.setInt(1, c.getIdCita());
            cs.setInt(2, c.getIdMascota());
            cs.setInt(3, c.getIdTipo());
            cs.setString(4, c.getFecha());
            cs.setString(5, c.getHora());
            cs.setString(6, c.getMotivo());
            cs.setString(7, c.getEstado());
            cs.executeUpdate();
            return true;
        } catch (Exception e) {
            System.out.println("Error en editarCita: " + e.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    // reprograma citas
    public boolean reprogramarCita(citas c) {
        try {
            cn = conexionvet_bd.probarConexion();
            cs = cn.prepareCall("{call sp_reprogramar_cita(?,?,?)}"); 
            cs.setInt(1, c.getIdCita());
            cs.setString(2, c.getFecha());
            cs.setString(3, c.getHora());
            cs.executeUpdate();
            return true;
        } catch (Exception e) {
            System.out.println("Error en reprogramarCita: " + e.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    // cambia automaticamente el estado
    public boolean actualizarEstado(int id, String estado){
        try{
            cn = conexionvet_bd.probarConexion();
            cs = cn.prepareCall("{call sp_cambiar_estado_cita(?,?)}"); 
            cs.setInt(1, id);
            cs.setString(2, estado);
            cs.executeUpdate();
            return true;
        }catch(Exception e){
            System.out.println("Error en actualizarEstado: " + e.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    // Elimina cita
    public boolean eliminarCita(int id){
        try{
            cn = conexionvet_bd.probarConexion();
            cs = cn.prepareCall("{call sp_eliminar_cita(?)}");
            cs.setInt(1, id);
            cs.executeUpdate();
            return true;
        }catch(Exception e){
            System.out.println("Error en eliminarCita: " + e.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }
     //6. Validar mascota para seleccion
    public boolean mascotaPerteneceCliente(int idMascota, int idCliente) {

        try {

            cn = conexionvet_bd.probarConexion();

            cs = cn.prepareCall("{call sp_validar_mascota_cliente(?,?)}");

            cs.setInt(1, idMascota);
            cs.setInt(2, idCliente);

            rs = cs.executeQuery();

            if (rs.next()) {
                return rs.getInt("existe") > 0;
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }

        return false;
    }
    private void closeResources() {
        try {
            if (rs != null) rs.close();
            if (cs != null) cs.close();
            if (cn != null) cn.close();
        } catch (Exception e) {
            System.out.println("Error al cerrar recursos: " + e.getMessage());
        }
    }
}