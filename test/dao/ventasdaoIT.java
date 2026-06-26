package dao;

import java.util.ArrayList;
import java.util.List;
import modelo.ventas;
import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import static org.junit.Assert.*;

public class ventasdaoIT {

    public ventasdaoIT() {
    }

    @BeforeClass
    public static void setUpClass() {
    }

    @AfterClass
    public static void tearDownClass() {
    }

    @Before
    public void setUp() {
    }

    @After
    public void tearDown() {
    }

    /**
     * Prueba de integración:
     * Registrar una venta completa (cabecera + detalle).
     */
    @Test
    public void testRegistrarVentaCompleta() {

        ventasdao dao = new ventasdao();

        ventas venta = new ventas();
        venta.setIdCliente(2);
        venta.setMetodoPago("EFECTIVO");
        venta.setDescuento(0);
        venta.setTotal(20.00);

        List<ventas.Detalle> detalles = new ArrayList<>();

        ventas.Detalle detalle = new ventas.Detalle();
        detalle.setIdProducto(1);
        detalle.setCantidad(1);
        detalle.setPrecioUnitario(20.00);

        detalles.add(detalle);
        venta.setDetalles(detalles);

        boolean resultado = dao.registrarVentaCompleta(venta);

        assertTrue(resultado);
    }

    /**
     * Prueba de integración:
     * Consultar el detalle de una venta.
     */
    @Test
    public void testVerDetalleVenta() {

        ventasdao dao = new ventasdao();

        List<ventas.Detalle> lista = dao.verDetalleVenta(1);

        assertNotNull(lista);
    }

    /**
     * Prueba de integración:
     * Listar todas las ventas registradas.
     */
    @Test
    public void testListarVentas() {

        ventasdao dao = new ventasdao();

        List<ventas> lista = dao.listarVentas();

        assertNotNull(lista);
    }

    /**
     * Prueba de integración:
     * Contar ventas registradas.
     */
    @Test
    public void testContarVentas() {

        ventasdao dao = new ventasdao();

        int total = dao.contarVentas();

        assertTrue(total >= 0);
    }

    /**
     * Prueba de integración:
     * Anular una venta existente.
     */
    @Test
    public void testAnularVenta() {

        ventasdao dao = new ventasdao();

        boolean resultado = dao.anularVenta(1);

        assertTrue(resultado);
    }

}