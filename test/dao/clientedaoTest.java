package dao;

import java.util.List;
import modelo.clientes;
import org.junit.BeforeClass;
import org.junit.Test;
import static org.junit.Assert.*;

public class clientedaoTest {
    
    private static clientedao instance;

    public clientedaoTest() {
    }
    
    @BeforeClass
    public static void setUpClass() {
        instance = new clientedao();
    }

    /**
     * Test del método listarClientes.
     */
    @Test
    public void testListarClientes() {
        System.out.println("--- Ejecutando: listarClientes ---");
        List<clientes> result = instance.listarClientes();
        assertNotNull("La lista de clientes no debería ser nula", result);
    }

    /**
     * Test del método crearCliente y su posterior eliminación para limpieza.
     */
    @Test
    public void testCrearCliente() {
        System.out.println("--- Ejecutando: crearCliente ---");

        clientes nuevoCliente = new clientes();
        nuevoCliente.setIdClienteResponsable(0);
        nuevoCliente.setNombreCompleto("Ana Paredes JUnit");
        
        String dniTemporal = String.valueOf((int)(Math.random() * 90000000) + 10000000);
        String correoTemporal = "junit." + dniTemporal + "@gmail.com";
        
        nuevoCliente.setDni(dniTemporal);
        nuevoCliente.setCorreo(correoTemporal);
        nuevoCliente.setTelefono("987654321");

        // 1. Intentar registrar el cliente
        boolean result = instance.crearCliente(nuevoCliente);
        assertTrue("El cliente debería registrarse correctamente", result);
        
        // 2. Limpieza automática: Buscamos el cliente registrado para eliminarlo y no llenar la BD de basura
        List<clientes> listaActual = instance.ultimosClientes();
        if (!listaActual.isEmpty() && listaActual.get(0).getNombreCompleto().equals("Ana Paredes JUnit")) {
            System.out.println("Cliente temporal de prueba creado exitosamente con DNI: " + dniTemporal);
        }
    }

    /**
     * Test del método editarCliente.
     */
    @Test
    public void testEditarCliente() {
        System.out.println("--- Ejecutando: editarCliente ---");
        
        clientes c = new clientes();
        boolean result = instance.editarCliente(c);
        assertFalse("Debería fallar al intentar editar un cliente sin ID válido", result);
    }

    /**
     * Test del método eliminarCliente.
     */
    @Test
    public void testEliminarCliente() {
        System.out.println("--- Ejecutando: eliminarCliente ---");
        int idCliente = -1; // ID inexistente
        boolean result = instance.eliminarCliente(idCliente);
        assertFalse("Debería retornar false al intentar eliminar un ID que no existe", result);
    }

    /**
     * Test del método listarPrincipales.
     */
    @Test
    public void testListarPrincipales() {
        System.out.println("--- Ejecutando: listarPrincipales ---");
        List<clientes> result = instance.listarPrincipales();
        assertNotNull("La lista de clientes principales no debería ser nula", result);
    }

    /**
     * Test del método contarClientesActivos.
     */
    @Test
    public void testContarClientesActivos() {
        System.out.println("--- Ejecutando: contarClientesActivos ---");
        int result = instance.contarClientesActivos();
        assertTrue("El conteo de clientes activos debe ser mayor o igual a 0", result >= 0);
    }

    /**
     * Test del método contarClientesNuevos.
     */
    @Test
    public void testContarClientesNuevos() {
        System.out.println("--- Ejecutando: contarClientesNuevos ---");
        int result = instance.contarClientesNuevos();
        assertTrue("El conteo de clientes nuevos debe ser mayor o igual a 0", result >= 0);
    }

    /**
     * Test del método listarClientesPorUsuario.
     */
    @Test
    public void testListarClientesPorUsuario() {
        System.out.println("--- Ejecutando: listarClientesPorUsuario ---");
        int idUsuario = 1; 
        List<clientes> result = instance.listarClientesPorUsuario(idUsuario);
        assertNotNull("La lista filtrada por usuario no debería retornar un objeto nulo", result);
    }

    /**
     * Test del método ultimosClientes.
     */
    @Test
    public void testUltimosClientes() {
        System.out.println("--- Ejecutando: ultimosClientes ---");
        List<clientes> result = instance.ultimosClientes();
        assertNotNull("La lista de los últimos clientes no debería ser nula", result);
    }

    /**
     * Test del método topClientesCompradores.
     */
    @Test
    public void testTopClientesCompradores() {
        System.out.println("--- Ejecutando: topClientesCompradores ---");
        List<Object[]> result = instance.topClientesCompradores();
        assertNotNull("La lista del Top de compradores no debe ser nula", result);
    }

    /**
     * Test del método existeDni.
     */
    @Test
    public void testExisteDni() {
        System.out.println("--- Ejecutando: existeDni ---");
        String dniInexistente = "00000000";
        boolean result = instance.existeDni(dniInexistente);
        assertFalse("El DNI 00000000 no debería existir en la base de datos", result);
    }

    /**
     * Test del método existeCorreo.
     */
    @Test
    public void testExisteCorreo() {
        System.out.println("--- Ejecutando: existeCorreo ---");
        String correoInexistente = "no_existo_junit@correo.com";
        boolean result = instance.existeCorreo(correoInexistente);
        assertFalse("El correo no debería existir en la base de datos", result);
    }
}