package modelo;

import java.util.ArrayList;
import java.util.List;

public class ventas {
    //atributos
    private int idVenta;
    private int idCliente;
    private String cliente;
    private String fecha;
    private String metodoPago;
    private double descuento;
    private double total;
    
    private List<Detalle> detalles = new ArrayList<>();

    public int getIdVenta() { return idVenta; }
    public void setIdVenta(int idVenta) { this.idVenta = idVenta; }

    public int getIdCliente() { return idCliente; }
    public void setIdCliente(int idCliente) { this.idCliente = idCliente; }

    public String getCliente() { return cliente; }
    public void setCliente(String cliente) { this.cliente = cliente; }

    public String getFecha() { return fecha; }
    public void setFecha(String fecha) { this.fecha = fecha; }

    public String getMetodoPago() { return metodoPago; }
    public void setMetodoPago(String metodoPago) { this.metodoPago = metodoPago; }

    public double getDescuento() { return descuento; }
    public void setDescuento(double descuento) { this.descuento = descuento; }

    public double getTotal() { return total; }
    public void setTotal(double total) { this.total = total; }

    public List<Detalle> getDetalles() { return detalles; }
    public void setDetalles(List<Detalle> detalles) { this.detalles = detalles; }
    
    public void añadirDetalle(int idProducto, String nombreProducto, int cantidad, double precioUnitario) {
        this.detalles.add(new Detalle(idProducto, nombreProducto, cantidad, precioUnitario));
    }

    // Subclase interna para mapear la tabla detalle_venta y los SP correspondientes
    public static class Detalle {
        private int idDetalle;
        private int idProducto;
        private String nombreProducto;
        private int cantidad;
        private double precioUnitario;
        private double subtotal;

        public Detalle() {}

        public Detalle(int idProducto, String nombreProducto, int cantidad, double precioUnitario) {
            this.idProducto = idProducto;
            this.nombreProducto = nombreProducto;
            this.cantidad = cantidad;
            this.precioUnitario = precioUnitario;
            this.subtotal = cantidad * precioUnitario;
        }

        public int getIdDetalle() { return idDetalle; }
        public void setIdDetalle(int idDetalle) { this.idDetalle = idDetalle; }

        public int getIdProducto() { return idProducto; }
        public void setIdProducto(int idProducto) { this.idProducto = idProducto; }

        public String getNombreProducto() { return nombreProducto; }
        public void setNombreProducto(String nombreProducto) { this.nombreProducto = nombreProducto; }

        public int getCantidad() { return cantidad; }
        public void setCantidad(int cantidad) { this.cantidad = cantidad; }

        public double getPrecioUnitario() { return precioUnitario; }
        public void setPrecioUnitario(double precioUnitario) { this.precioUnitario = precioUnitario; }

        public double getSubtotal() { return subtotal; }
        public void setSubtotal(double subtotal) { this.subtotal = subtotal; }
    }
}