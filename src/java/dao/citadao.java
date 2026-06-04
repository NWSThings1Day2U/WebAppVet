package dao;

import conexion.conexionvet_bd;
import modelo.citas;

import java.sql.*;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.*;
import modelo.horarios;

public class citadao {

    private Connection cn;
    private CallableStatement cs;
    private ResultSet rs;
    private PreparedStatement ps;

    // Lista todas las citas
    public List<citas> listarCitas() {
        List<citas> lista = new ArrayList<>();
        try {
            cn = conexionvet_bd.probarConexion();
            cs = cn.prepareCall("{call sp_listar_citas()}");
            rs = cs.executeQuery();
            while (rs.next()) {
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
        } catch (Exception e) {
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
            while (rs.next()) {
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
        } catch (Exception e) {
            System.out.println("Error en listarCitasPorCliente: " + e.getMessage());
        } finally {
            closeResources();
        }
        return lista;
    }

    // crear cita
    public boolean insertarCita(citas c) {
        try {
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
        } catch (Exception e) {
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
    public boolean actualizarEstado(int id, String estado) {
        try {
            cn = conexionvet_bd.probarConexion();
            cs = cn.prepareCall("{call sp_cambiar_estado_cita(?,?)}");
            cs.setInt(1, id);
            cs.setString(2, estado);
            cs.executeUpdate();
            return true;
        } catch (Exception e) {
            System.out.println("Error en actualizarEstado: " + e.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    // CANCELAR CITA
    public boolean eliminarCita(int id) {
        try {
            cn = conexionvet_bd.probarConexion();
            cs = cn.prepareCall("{call sp_eliminar_cita(?)}");
            cs.setInt(1, id);
            cs.executeUpdate();
            return true;
        } catch (Exception e) {
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

    //Generar horarios 
    public List<String> obtenerHorasDisponibles(String fecha) {

        List<String> disponibles = new ArrayList<>();
        List<String> ocupadas = obtenerHorasOcupadas(fecha);
        try {
            
            LocalDate f = LocalDate.parse(fecha);
            LocalDate hoy = LocalDate.now();
            LocalTime horaActual = LocalTime.now();
            DayOfWeek day = f.getDayOfWeek();

            String dia = convertirDia(day);

            horariodao hdao = new horariodao();

            horarios horario = hdao.obtenerHorarioDia(dia);
            if (horario == null) {
                
                return disponibles;
            }

            LocalTime inicio = LocalTime.parse(horario.getHoraInicio());

            LocalTime fin = LocalTime.parse(horario.getHoraFin());

            int duracion = horario.getDuracionMinutos();

            while (inicio.isBefore(fin)) {

                String hora = inicio.toString();

                boolean horaValida = true;

                if (f.equals(hoy)) {

                    if (inicio.isBefore(horaActual)) {
                        horaValida = false;
                    }

                }

                if (horaValida && !ocupadas.contains(hora)) {

                    disponibles.add(hora);

                }

                inicio = inicio.plusMinutes(duracion);
                
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        System.out.println("Disponibles: " + disponibles);
        return disponibles;
    }

    public List<String> obtenerHorasOcupadas(String fecha) {

        List<String> ocupadas = new ArrayList<>();

        try {

            cn = conexionvet_bd.probarConexion();
            cs = cn.prepareCall("{call sp_horas_ocupadas_fecha(?)}");

            cs.setString(1, fecha);

            rs = cs.executeQuery();

            while (rs.next()) {

                ocupadas.add(
                        rs.getString("hora")
                );

            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }

        return ocupadas;
    }

    public boolean horaDisponible(
            String fecha,
            String hora) {

        try {

            cn = conexionvet_bd.probarConexion();

            ps = cn.prepareStatement(
                    "SELECT COUNT(*) total "
                    + "FROM citas "
                    + "WHERE fecha=? "
                    + "AND hora=? "
                    + "AND estado IN ('PENDIENTE','CONFIRMADA')"
            );
            ps.setString(1, fecha);
            ps.setString(2, hora);

            rs = ps.executeQuery();

            if (rs.next()) {

                return rs.getInt("total") == 0;

            }

        } catch (Exception e) {

            e.printStackTrace();

        }

        return false;
    }
    public boolean horaDisponibleEditar(
            int idCita,
            String fecha,
            String hora) {

        try {

            cn = conexionvet_bd.probarConexion();

            ps = cn.prepareStatement(
                    "SELECT COUNT(*) total "
                    + "FROM citas "
                    + "WHERE fecha=? "
                    + "AND hora=? "
                    + "AND estado IN ('PENDIENTE','CONFIRMADA') "
                    + "AND id_cita <> ?"
            );

            ps.setString(1, fecha);
            ps.setString(2, hora);
            ps.setInt(3, idCita);

            rs = ps.executeQuery();

            if (rs.next()) {

                return rs.getInt("total") == 0;

            }

        } catch (Exception e) {

            e.printStackTrace();

        } finally {

            closeResources();

        }

        return false;
    }
 
    public List<String> obtenerHorasOcupadasEditar(
            String fecha,
            int idCita) {

        List<String> ocupadas = new ArrayList<>();

        try {

            cn = conexionvet_bd.probarConexion();

            cs = cn.prepareCall(
                    "{call sp_horas_ocupadas_fecha_editar(?,?)}"
            );

            cs.setString(1, fecha);
            cs.setInt(2, idCita);

            rs = cs.executeQuery();

            while (rs.next()) {

                ocupadas.add(
                        rs.getString("hora")
                );

            }

        } catch (Exception e) {

            e.printStackTrace();

        } finally {

            closeResources();

        }

        return ocupadas;
    }

    public List<String> obtenerHorasDisponiblesEditar(
            String fecha,
            int idCita) {

        List<String> disponibles = new ArrayList<>();

        List<String> ocupadas   = obtenerHorasOcupadasEditar( fecha,  idCita   );

        try {

            LocalDate f = LocalDate.parse(fecha);

            DayOfWeek day = f.getDayOfWeek();

            String dia = convertirDia(day);

            horariodao hdao = new horariodao();

            horarios horario = hdao.obtenerHorarioDia(dia);

            System.out.println(horario.getHoraInicio());
            System.out.println(horario.getHoraFin());
            System.out.println(horario.getDuracionMinutos());
            if (horario == null) {

                return disponibles;

            }

            LocalTime inicio
                    = LocalTime.parse(
                            horario.getHoraInicio()
                    );

            LocalTime fin
                    = LocalTime.parse(
                            horario.getHoraFin()
                    );

            int duracion
                    = horario.getDuracionMinutos();

            while (inicio.isBefore(fin)) {

                String hora
                        = inicio.toString();

                if (!ocupadas.contains(hora)) {

                    disponibles.add(hora);

                }

                inicio
                        = inicio.plusMinutes(duracion);

            }

        } catch (Exception e) {

            e.printStackTrace();

        }
        System.out.println("OCUPADAS = " + ocupadas);
        System.out.println("DISPONIBLES = " + disponibles);
        return disponibles;
    }
    
    private String convertirDia(DayOfWeek day) {

        switch (day) {

            case MONDAY:
                return "LUNES";

            case TUESDAY:
                return "MARTES";

            case WEDNESDAY:
                return "MIERCOLES";

            case THURSDAY:
                return "JUEVES";

            case FRIDAY:
                return "VIERNES";

            case SATURDAY:
                return "SABADO";

            case SUNDAY:
                return "DOMINGO";

            default:
                return "";
        }
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
            if (ps != null) {
                ps.close();
            }
        } catch (Exception e) {
            System.out.println("Error al cerrar recursos: " + e.getMessage());
        }
    }

    
}
