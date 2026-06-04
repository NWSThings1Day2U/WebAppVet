package dao;

import conexion.conexionvet_bd;
import modelo.horarios;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class horariodao {

    private Connection cn;
    private CallableStatement cs;
    private ResultSet rs;

    public List<horarios> listarHorarios() {

        List<horarios> lista = new ArrayList<>();

        try {

            cn = conexionvet_bd.probarConexion();

            cs = cn.prepareCall("{call sp_listar_horarios()}");

            rs = cs.executeQuery();

            while (rs.next()) {

                horarios h = new horarios();

                h.setIdHorario(rs.getInt("id_horario"));
                h.setDiaSemana(rs.getString("dia_semana"));
                h.setHoraInicio(rs.getString("hora_inicio"));
                h.setHoraFin(rs.getString("hora_fin"));
                h.setDuracionMinutos(rs.getInt("duracion_minutos"));
                h.setCuposMaximos(rs.getInt("cupos_maximos"));
                h.setActivo(rs.getInt("activo"));

                lista.add(h);
            }

        } catch (Exception e) {

            System.out.println("Error listarHorarios: " + e.getMessage());

        } finally {

            closeResources();

        }

        return lista;
    }

    public boolean actualizarHorario(horarios h) {

        try {

            cn = conexionvet_bd.probarConexion();

            cs = cn.prepareCall(
                    "{call sp_actualizar_horario(?,?,?,?,?,?)}"
            );

            cs.setInt(1, h.getIdHorario());
            cs.setString(2, h.getHoraInicio());
            cs.setString(3, h.getHoraFin());
            cs.setInt(4, h.getDuracionMinutos());
            cs.setInt(5, h.getCuposMaximos());
            cs.setInt(6, h.getActivo());

            cs.executeUpdate();

            return true;

        } catch (Exception e) {

            System.out.println("Error actualizarHorario: " + e.getMessage());

            return false;

        } finally {

            closeResources();

        }
    }

    public horarios obtenerHorarioDia(String dia) {

        horarios h = null;

        try {

            cn = conexionvet_bd.probarConexion();
            System.out.println("DIA RECIBIDO = " + dia);
            cs = cn.prepareCall("{call sp_obtener_horario_dia(?)}");

            cs.setString(1, dia);

            rs = cs.executeQuery();

            if (rs.next()) {

                h = new horarios();

                h.setHoraInicio(rs.getString("hora_inicio"));
                h.setHoraFin(rs.getString("hora_fin"));
                h.setDuracionMinutos(
                        rs.getInt("duracion_minutos")
                );

            }
            System.out.println(
                    rs.getString("hora_inicio")
                    + " "
                    + rs.getString("hora_fin")
            );
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }

        return h;
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
