package modelo;

public class clientes {

    private int idCliente;
    private String nombreCompleto;
    private String dni;
    private String correo;
    private String telefono;
    private int estado;

    public clientes() {
    }

    public clientes(int idCliente, String nombreCompleto, String dni, String correo, String telefono, int estado) {
        this.idCliente = idCliente;
        this.nombreCompleto = nombreCompleto;
        this.dni = dni;
        this.correo = correo;
        this.telefono = telefono;
        this.estado = estado;
    }
    //GETTERS Y SETTERS
    public int getIdCliente() {
        return idCliente;
    }

    public void setIdCliente(int idCliente) {
        this.idCliente = idCliente;
    }

    public String getNombreCompleto() {
        return nombreCompleto;
    }

    public void setNombreCompleto(String nombreCompleto) {
        this.nombreCompleto = nombreCompleto;
    }

    public String getDni() {
        return dni;
    }

    public void setDni(String dni) {
        this.dni = dni;
    }

    public String getCorreo() {
        return correo;
    }

    public void setCorreo(String correo) {
        this.correo = correo;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public int getEstado() {
        return estado;
    }

    public void setEstado(int estado) {
        this.estado = estado;
    }

   
}

