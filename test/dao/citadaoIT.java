package dao;

import java.util.List;
import modelo.citas;
import modelo.clientes;
import modelo.mascotas;
import org.junit.Test;
import static org.junit.Assert.*;

public class citadaoIT {

    private final citadao dao = new citadao();

    // PI-01
    @Test
    public void testRegistrarClienteMascotaCita() {

        clientes cliente = new clientes();
        cliente.setNombreCompleto("Cliente Integracion");
        cliente.setDni("98765431");
        cliente.setCorreo("integracion@junit.com");
        cliente.setTelefono("999888777");
        cliente.setIdClienteResponsable(2);

        mascotas mascota = new mascotas();
        mascota.setNombre("FirulaisJUnit");
        mascota.setEspecie("Perro");
        mascota.setRaza("Labrador");
        mascota.setPeso(12.5);
        mascota.setFechaNacimiento("2023-01-10");
        mascota.setSexo("M");

        citas cita = new citas();
        cita.setIdTipo(1);
        cita.setFecha("2026-12-20"); // fecha futura
        cita.setHora("09:00");
        cita.setMotivo("Prueba Integración");

        boolean resultado = dao.registrarClienteMascotaCita(cliente, mascota, cita);

        assertTrue(resultado);
    }

    // PI-02
    @Test
    public void testMascotaPerteneceCliente() {

        int idMascota = 1;
        int idCliente = 2;

        boolean resultado = dao.mascotaPerteneceCliente(idMascota, idCliente);

        assertTrue(resultado);
    }

    // PI-03
    @Test
    public void testListarCitas() {

        List<citas> lista = dao.listarCitas();

        assertNotNull(lista);
    }

    // PI-04
    @Test
    public void testObtenerCitaCompleta() {

        int idCita = 2;

        citas cita = dao.obtenerCitaCompleta(idCita);

        assertNotNull(cita);
    }

    // PI-05
    @Test
    public void testObtenerHistorialInicio() {

        int idUsuario = 2;

        List<citas> historial = dao.obtenerHistorialInicio(idUsuario);

        assertNotNull(historial);
    }

}