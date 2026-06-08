<%-- 
    Document   : detallecita
    Created on : 7 jun. 2026, 10:38:09 p. m.
    Author     : USUARIO
--%>

<%@page import="java.util.List"%>
<%@page import="modelo.citas"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    citas c = (citas) request.getAttribute("detalles");
    int idCita = (Integer) request.getAttribute("idCita");
%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Detalle de Cita | Gallito de las Rocas</title>
        <link class="rounded-circle" rel="icon" href="recursos/logoveet.png">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/estilos/detallepag.css"/>
    </head>
    <body>
        <div class="container my-5">
            <div class="row justify-content-center">
                <div class="col-md-10 col-lg-8">
                    
                    <div class="card card-custom card-verde shadow-lg">
                        
                        <div class="card-header-custom d-flex align-items-center justify-content-between">
                            <div class="d-flex align-items-center">
                                <img src="recursos/logovet.png" alt="Logo" style="height: 52px; width: auto; margin-right: 15px;" onerror="this.style.display='none'">
                                <div>
                                    <h5 class="m-0 text-uppercase tracking-wide fw-bold" style="font-size: 0.85rem; letter-spacing: 0.5px;">Gallito de las Rocas</h5>
                                    <h3 class="m-0 fw-bold">Detalle de Cita #<%= idCita %></h3>
                                </div>
                            </div>
                            <span class="fs-4" style="color: var(--ojito-texto);"><i class="fa-solid fa-eye"></i></span>
                        </div>

                        <div class="card-body p-4 bg-white">
                            <% if (c != null) { %>
                                <div class="row g-2">
                                    
                                    <div class="col-sm-6 detail-item">
                                        <div class="label-title">
                                            <i class="fa-solid fa-hashtag"></i> Código de Cita:
                                        </div>
                                        <div class="value-text mt-1 fw-bold text-dark">#<%= c.getIdCita() %></div>
                                    </div>

                                    <div class="col-sm-6 detail-item">
                                        <div class="label-title">
                                            <i class="fa-solid fa-user"></i> Cliente:
                                        </div>
                                        <div class="value-text mt-1"><%= c.getCliente() != null ? c.getCliente() : "No disponible" %></div>
                                    </div>

                                    <div class="col-sm-6 detail-item">
                                        <div class="label-title">
                                            <i class="fa-solid fa-paw"></i> Mascota:
                                        </div>
                                        <div class="value-text mt-1 fw-bold" style="color:#E65100;"><%= c.getMascota() != null ? c.getMascota() : "No disponible" %></div>
                                    </div>

                                    <div class="col-sm-6 detail-item">
                                        <div class="label-title">
                                            <i class="fa-solid fa-stethoscope"></i> Tipo de Servicio:
                                        </div>
                                        <div class="value-text mt-1"><%= c.getTipoAtencion() != null ? c.getTipoAtencion() : "No disponible" %></div>
                                    </div>

                                    <div class="col-sm-6 detail-item">
                                        <div class="label-title">
                                            <i class="fa-solid fa-calendar-day"></i> Fecha de Atención:
                                        </div>
                                        <div class="value-text mt-1"><%= c.getFecha() != null ? c.getFecha() : "No especificada" %></div>
                                    </div>

                                    <div class="col-sm-6 detail-item">
                                        <div class="label-title">
                                            <i class="fa-solid fa-clock"></i> Hora Reservada:
                                        </div>
                                        <div class="value-text mt-1"><%= c.getHora() != null ? c.getHora() : "No especificada" %></div>
                                    </div>

                                    <div class="col-12 detail-item">
                                        <div class="label-title">
                                            <i class="fa-solid fa-notes-medical"></i> Motivo de Consulta:
                                        </div>
                                        <div class="value-text mt-1 bg-light p-2 rounded border-start border-3" style="border-color: var(--naranja-primario) !important;">
                                            <%= c.getMotivo() != null ? c.getMotivo() : "No especificado" %>
                                        </div>
                                    </div>

                                    <div class="col-12 detail-item d-flex align-items-center justify-content-between mt-3 bg-light p-3 rounded">
                                        <div class="label-title m-0">
                                            <i class="fa-solid fa-clipboard-check"></i> Fecha del Registro:
                                        </div>
                                        <div>
                                                <span class="badge bg-success badge-estado text-white">
                                                    <i class="fa-solid fa-circle-check me-1"></i> <%= c.getFechaRegistro() !=null? c.getFechaRegistro() : "No registrado"%>
                                                </span>
                                        </div>
                                    </div>

                                </div>
                            <% } else { %>
                                <div class="text-center py-5">
                                    <i class="fa-solid fa-circle-xmark text-danger display-3 mb-3"></i>
                                    <h4 class="text-muted">No se encontraron detalles para esta cita.</h4>
                                    <p class="text-secondary small">Por favor, regrese a la lista e intente de nuevo.</p>
                                </div>
                            <% } %>

                            <div class="d-flex justify-content-end mt-4">
                                <a href="controladorcitas?accion=listar" class="btn btn-volver d-inline-flex align-items-center gap-2">
                                    <i class="fa-solid fa-arrow-left"></i> Volver
                                </a>
                            </div>

                        </div>
                        
                        

                    </div>
                    
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>