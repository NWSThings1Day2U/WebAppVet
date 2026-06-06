package dao;

import conexion.conexionvet_bd;
import modelo.citas;

import java.sql.*;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.*;
import modelo.clientes;
import modelo.horarios;
import modelo.mascotas;

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

    // Lista citas segun cliente logurado
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
    public boolean horaDisponibleEditar(int idCita,String fecha,String hora) {

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
 
    public List<String> obtenerHorasOcupadasEditar(String fecha,int idCita) {

        List<String> ocupadas = new ArrayList<>();

        try {

            cn = conexionvet_bd.probarConexion();

            cs = cn.prepareCall("{call sp_horas_ocupadas_fecha_editar(?,?)}");

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

    public List<String> obtenerHorasDisponiblesEditar( String fecha,int idCita) {

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

        }finally {

            closeResources();

        }
        System.out.println("OCUPADAS = " + ocupadas);
        System.out.println("DISPONIBLES = " + disponibles);
        return disponibles;
    }

    // Metodo para crear cliente, mascota y cita a su vez 
    public boolean registrarClienteMascotaCita(clientes c, mascotas m, citas cita) {
        boolean resultado = false;
        try {
            cn = conexionvet_bd.probarConexion();
            CallableStatement cs = cn.prepareCall(
                    "{CALL sp_registrar_cita_cliente_nuevo(?,?,?,?,?,?,?,?,?,?,?,?,?,?)}"
            );

            cs.setString(1, c.getNombreCompleto());
            cs.setString(2, c.getDni());
            cs.setString(3, c.getCorreo());
            cs.setString(4, c.getTelefono());

            cs.setString(5, m.getNombre());
            cs.setString(6, m.getEspecie());
            cs.setString(7, m.getRaza());
            cs.setDouble(8, m.getPeso());

            if (m.getFechaNacimiento() != null && !m.getFechaNacimiento().trim().isEmpty()) {
                cs.setDate(9, java.sql.Date.valueOf(m.getFechaNacimiento()));
            } else {
                cs.setNull(9, java.sql.Types.DATE); 
            }
            cs.setString(10, m.getSexo());

            cs.setInt(11, cita.getIdTipo());

            if (cita.getFecha() != null && !cita.getFecha().trim().isEmpty()) {
                cs.setDate(12, java.sql.Date.valueOf(cita.getFecha()));
            } else {
                cs.setNull(12, java.sql.Types.DATE);
            }

            String horaFormateada = cita.getHora();
            if (horaFormateada != null && horaFormateada.trim().length() == 5) {
                horaFormateada += ":00"; 
            }

            if (horaFormateada != null && !horaFormateada.trim().isEmpty()) {
                cs.setTime(13, java.sql.Time.valueOf(horaFormateada));
            } else {
                cs.setNull(13, java.sql.Types.TIME);
            }

            cs.setString(14, cita.getMotivo());

            cs.execute();
            resultado = true;

        } catch (Exception e) {
            System.out.println("Error registrar cita de cliente nuevo de forma explícita:");
            e.printStackTrace(); 
        } finally {
            closeResources();
        }
        return resultado;
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
    
    
    //Citas proximas
    public List<citas> listarProximasCitas() {
        List<citas> lista = new ArrayList<>();
        try {
            cn = conexionvet_bd.probarConexion();
            String sql
                    = "SELECT c.*, "
                    + "cl.nombre_completo nombre_cliente, "
                    + "m.nombre nombre_mascota "
                    + "FROM citas c "
                    + "INNER JOIN clientes cl ON c.id_cliente=cl.id_cliente "
                    + "INNER JOIN mascotas m ON c.id_mascota=m.id_mascota "
                    + "WHERE c.fecha >= CURDATE() "
                    + "ORDER BY c.fecha ASC, c.hora ASC "
                    + "LIMIT 5";
            PreparedStatement ps
                    = cn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                citas c = new citas();
                c.setCliente(
                        rs.getString("nombre_cliente"));
                c.setMascota(
                        rs.getString("nombre_mascota"));
                c.setFecha(
                        rs.getString("fecha"));
                c.setHora(
                        rs.getString("hora"));
                c.setEstado(
                        rs.getString("estado"));
                lista.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return lista;
    }
    //Citas por semana
    public int[] citasSemana() {
        int datos[] = new int[7];
        try {
            cn = conexionvet_bd.probarConexion();
            String sql
                    = "SELECT DAYOFWEEK(fecha) dia, COUNT(*) total "
                    + "FROM citas "
                    + "WHERE fecha >= DATE_SUB(CURDATE(), INTERVAL 7 DAY) "
                    + "GROUP BY DAYOFWEEK(fecha)";
            PreparedStatement ps
                    = cn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                int dia
                        = rs.getInt("dia");
                datos[dia - 1]
                        = rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return datos;
    }
    // CONTAR CITAS
    public int contarCitas() {
        int total = 0;
        try {
            String sql
                    = "SELECT COUNT(*) total FROM citas";
            PreparedStatement ps
                    = cn.prepareStatement(sql);
            ResultSet rs
                    = ps.executeQuery();
            if (rs.next()) {
                total = rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return total;
    }

    //Citas por mes
    public int totalCitas() {
        int total = 0;
        try {
            cn = conexionvet_bd.probarConexion();
            String sql
                    = "SELECT COUNT(*) total "
                    + "FROM citas "
                    + "WHERE MONTH(fecha)=MONTH(CURDATE()) "
                    + "AND YEAR(fecha)=YEAR(CURDATE())";
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
    //Citas mas solicitadas - 04-06-26
    public List<Object[]> serviciosMasSolicitados() {
        List<Object[]> lista
                = new ArrayList<>();
        try {
            cn = conexionvet_bd.probarConexion();
            String sql
                    = "SELECT tc.nombre, "
                    + "COUNT(*) total "
                    + "FROM citas c "
                    + "INNER JOIN tipo_atencion tc "
                    + "ON c.id_tipo=tc.id_tipo "
                    + "GROUP BY tc.nombre "
                    + "ORDER BY total DESC";
            PreparedStatement ps
                    = cn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Object fila[] = new Object[2];
                fila[0]
                        = rs.getString("nombre");
                fila[1]
                        = rs.getInt("total");
                lista.add(fila);
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
            if (ps != null) {
                ps.close();
            }
        } catch (Exception e) {
            System.out.println("Error al cerrar recursos: " + e.getMessage());
        }
    }

    
}
