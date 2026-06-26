package dao;

import java.util.List;
import modelo.mascotas;
import org.junit.Test;
import static org.junit.Assert.*;

public class mascotadaoTest {

    private final mascotadao dao = new mascotadao();
    
    /**
     * Prueba unitaria:
     * Crear mascota con idcliente.
     */
    
    @Test
    public void testCrearMascota() {

        mascotas m = new mascotas();

        m.setIdCliente(4);

        m.setNombre("MascotaJUnit");
        m.setEspecie("Perro");
        m.setRaza("Labrador");
        m.setPeso(10.5);
        m.setFechaNacimiento("2023-01-01");
        m.setSexo("M");

        boolean resultado = dao.crearMascota(m);

        assertTrue(resultado);
    }
    /**
     * Prueba unitaria:
     * Listar todas las mascotas.
     */
    @Test
    public void testListarMascotas() {

        List<mascotas> lista = dao.listarMascotas();

        assertNotNull(lista);
    }
    /**
     * Prueba unitaria:
     * Editar informaacion de mascota.
     */
    @Test
    public void testEditarMascota() {

        List<mascotas> lista = dao.listarMascotas();

        assertFalse(lista.isEmpty());

        mascotas m = lista.get(lista.size() - 1);

        m.setNombre("MascotaEditadaJUnit");

        boolean resultado = dao.editarMascota(m);

        assertTrue(resultado);
    }
    /**
     * Prueba unitaria:
     * Contar todas las mascotas registradas.
     */
    @Test
    public void testContarMascotas() {

        int total = dao.contarMascotas();

        assertTrue(total >= 0);
    }
    /**
     * Prueba unitaria:
     * Listar todas las mascotas de un cliente especifico por id.
     */
    @Test
    public void testListarMascotasxCliente() {

        int idCliente = 2;

        List<mascotas> lista = dao.listarMascotasxCliente(idCliente);

        assertNotNull(lista);
    }

}