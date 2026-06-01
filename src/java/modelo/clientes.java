package modelo;

import java.util.Date;

public class clientes {

    private int idCliente;
    private String nombreCompleto;
    private String dni;
    private String correo;
    private String telefono;
    private int estado;
    private int idClienteResponsable;
    private String nombreResponsable;
    private Date fechaRegistro;
    public clientes() {
    }

    public clientes(int idCliente, String nombreCompleto, String dni, String correo, String telefono, int estado, int idClienteResponsable, String nombreResponsable, Date fechaRegistro) {
        this.idCliente = idCliente;
        this.nombreCompleto = nombreCompleto;
        this.dni = dni;
        this.correo = correo;
        this.telefono = telefono;
        this.estado = estado;
        this.idClienteResponsable = idClienteResponsable;
        this.nombreResponsable = nombreResponsable;
        this.fechaRegistro = fechaRegistro;
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

    public int getIdClienteResponsable() {
        return idClienteResponsable;
    }

    public void setIdClienteResponsable(int idClienteResponsable) {
        this.idClienteResponsable = idClienteResponsable;
    }

    public String getNombreResponsable() {
        return nombreResponsable;
    }

    public void setNombreResponsable(String nombreResponsable) {
        this.nombreResponsable = nombreResponsable;
    }

    public Date getFechaRegistro() {
        return fechaRegistro;
    }

    public void setFechaRegistro(Date fechaRegistro) {
        this.fechaRegistro = fechaRegistro;
    }
    

   
}

