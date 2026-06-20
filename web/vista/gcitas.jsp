<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="modelo.citas"%>
<%@page import="modelo.clientes"%>
<%@page import="modelo.mascotas"%>
<%@page import="dao.citadao"%>
<%@page import="java.util.List"%>

<%
    List<citas> lista = (List<citas>) request.getAttribute("listaCitas");
    List<clientes> listaClientes = (List<clientes>) request.getAttribute("listaClientes");
    List<mascotas> listaMascotas = (List<mascotas>) request.getAttribute("listaMascotas");
    int totalCitas = 0;
    int totalHoy = 0; 
    int totalPendientes = 0;
    int totalCanceladas = 0;
    
    if (lista != null) {
        totalCitas = lista.size();
        java.time.LocalDate hoy = java.time.LocalDate.now();
        
        for (citas c : lista) {
            if ("PENDIENTE".equalsIgnoreCase(c.getEstado())) {
                totalPendientes++;
            }
            if ("CANCELADA".equalsIgnoreCase(c.getEstado())) {
                totalCanceladas++;
            }
            if (c.getFecha() != null && c.getFecha().toString().equals(hoy.toString())) {
                totalHoy++;
            }
        }
    }
%>


<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Citas</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Vollkorn:ital,wght@0,400..900;1,400..900&display=swap" rel="stylesheet">      
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
        <link rel="icon" href="recursos/logoveet.png">
        <link rel="stylesheet" href="//cdn.jsdelivr.net/npm/alertifyjs@1.13.1/build/css/alertify.min.css"/>
        <link rel="stylesheet" href="//cdn.jsdelivr.net/npm/alertifyjs@1.13.1/build/css/themes/default.min.css"/>

        <link rel="stylesheet" href="${pageContext.request.contextPath}/estilos/contenidoadmin.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/estilos/esadmin.css">
        <style>
            .resaltado-busqueda{
                background-color: #6B8E23 !important;
                color: white !important;
                font-weight: bold;
                transition: all .2s ease;
            }
        </style>
    </head>
    <body>
        <%
           request.setAttribute("paginaActual", "citas");
        %>

        <jsp:include page="../componentes/encabezado.jsp" />

        <main class="container mt-5 pt-4 contenido-admin" style="margin-top: 180px; margin-bottom: 150px;"> 
            <div class="container-fluid">
                <div class="card-bienvenida mb-4">
                    <div class="row align-items-center">
                        <div class="col-lg-8">
                            <h1 class="fw-bold mb-2">
                                Gestión de
                                <span class="text-success">Citas</span>
                            </h1>
                            <p class="text-muted mb-0">Administra la reservación de citas médicas.</p>
                        </div>
                        <div class="col-lg-4 text-lg-end mt-3 mt-lg-0">
                            <div class="fecha-box">
                                <i class="fa-solid fa-calendar-days"></i>
                                <span id="fechaHora"></span>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row g-4 mb-4">
                    <div class="col-xl-3 col-md-6">
                        <div class="card-dashboard">
                            <div>
                                <h5>Total Citas</h5>
                                <h1><%= totalCitas %></h1>
                            </div>
                            <i class="fa-solid fa-calendar-check text-success icon-card"></i>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6">
                        <div class="card-dashboard">
                            <div>
                                <h5>Citas Hoy</h5>
                                <h1><%= totalHoy %></h1>
                            </div>
                            <i class="fa-solid fa-clock text-primary icon-card"></i>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6">
                        <div class="card-dashboard">
                            <div>
                                <h5>Pendientes</h5>
                                <h1><%= totalPendientes %></h1>
                            </div>
                            <i class="fa-solid fa-hourglass-half text-danger icon-card"></i>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6">
                        <div class="card-dashboard">
                            <div>
                                <h5>Canceladas</h5>
                                <h1><%= totalCanceladas %></h1>
                            </div>
                            <i class="fa-solid fa-circle-xmark text-secondary icon-card"></i>
                        </div>
                    </div>
                </div>

                <div class="tabla-panel">
                    <div class="d-flex justify-content-between align-items-center flex-wrap gap-3 mb-4">
                        <div>
                            <h3 class="fw-bold mb-1">Lista de Citas</h3>
                            <p class="text-muted mb-0">Visualiza y administra las citas registradas.</p>
                        </div>
                        <div class="d-flex gap-2 flex-wrap">
                            <input type="text" id="txtBuscarCita" class="form-control"  placeholder="Buscar cliente o mascota..." style="width:230px;">
                            <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#modalNuevaCita">
                                <i class="fa-solid fa-calendar-plus"></i> Nueva Cita
                            </button>
                        </div>
                    </div>

                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Cliente</th>
                                    <th>Mascota</th>
                                    <th>Fecha</th>
                                    <th>Hora</th>
                                    <th>Estado</th>
                                    <th class="text-center">Acción</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% 
                                    if (lista != null && !lista.isEmpty()) {
                                        for (citas c : lista) {
                                %>
                                <tr class="fila-cita" data-id="<%= c.getIdCita() %>" data-cliente="<%= c.getCliente().toLowerCase() %>" data-mascota="<%= c.getMascota().toLowerCase() %>">
                                    <td>#<%= c.getIdCita()%></td>
                                    <td><strong><%= c.getCliente()%></strong></td>
                                    <td>
                                        <i class="fa-solid fa-paw text-warning"></i> <%= c.getMascota()%>
                                    </td>
                                    <td><%= c.getFecha()%></td>
                                    <td><%= c.getHora()%></td>
                                    <td>
                                        <form action="${pageContext.request.contextPath}/controladorcitas" method="POST" class="d-flex gap-2 align-items-center" onsubmit="return validarEnvioCorreo(this)">
                                            <input type="hidden" name="accion" value="actualizarEstado">
                                            <input type="hidden" name="id" value="<%= c.getIdCita()%>">
                                            <select name="estado" 
                                                    class="form-select form-select-sm" 
                                                    onchange="cambiarColorEstado(this)"
                                                    data-estado="<%= c.getEstado() %>"
                                                    style=" font-weight: bold;">

                                                <option value="PENDIENTE" <%= c.getEstado().equals("PENDIENTE") ? "selected" : ""%>>PENDIENTE</option>
                                                <option value="CONFIRMADA" <%= c.getEstado().equals("CONFIRMADA") ? "selected" : ""%>>CONFIRMADA</option>
                                                <option value="ATENDIDA" <%= c.getEstado().equals("ATENDIDA") ? "selected" : ""%>>ATENDIDA</option>
                                                <option value="CANCELADA" <%= c.getEstado().equals("CANCELADA") ? "selected" : ""%>>CANCELADA</option>
                                            </select>
                                            <button type="submit" class="btn btn-primary btn-sm">
                                                <i class="fa-solid fa-floppy-disk"></i>
                                            </button>
                                        </form>
                                    </td>
                                    <td>

                                        <% if (c.getEstado().equals("CANCELADA")) { %>

                                            <span class="badge bg-secondary px-3 py-2">
                                                Sin acciones disponibles
                                            </span>

                                        <% } else if (c.getEstado().equals("ATENDIDA")) { %>

                                            <div class="d-flex justify-content-center align-items-center">
                                                <a href="${pageContext.request.contextPath}/detallecita?id=<%= c.getIdCita()%>" class="text-decoration-none">
                                                    <button class="btn btn-sm fw-bold d-flex align-items-center justify-content-center"
                                                            style="color: #2E7D32; border: 2px solid #71C87B; background-color: #E2F4E4; border-radius: 6px; width: 36px; height: 36px; padding: 0;"
                                                            title="Ver detalle cita">
                                                        <i class="fa-solid fa-eye"></i>
                                                    </button>
                                                </a>
                                            </div>

                                        <% } else { %>

                                            <div class="d-flex justify-content-center align-items-center gap-2">

                                                <div class="d-flex justify-content-center align-items-center" style="width: 36px; height: 36px;">

                                                    <% if (c.getEstado().equals("CONFIRMADA")) { %>

                                                        <a href="${pageContext.request.contextPath}/controladorcitas?accion=descargarTicket&id=<%= c.getIdCita() %>"
                                                           class="text-decoration-none"
                                                           onclick="validarDescargaPDF(event)">

                                                            <button class="btn btn-sm text-white fw-bold d-flex align-items-center justify-content-center"
                                                                    style="background-color: #0088FF; border-radius: 6px; width: 36px; height: 36px; padding: 0;"
                                                                    title="Descargar PDF">
                                                                <i class="fa-solid fa-download"></i>
                                                            </button>

                                                        </a>

                                                    <% } %>

                                                </div>

                                                <button class="btn btn-warning btn-sm d-flex align-items-center justify-content-center"
                                                        data-bs-toggle="modal"
                                                        data-bs-target="#modalEditarCita<%= c.getIdCita() %>"
                                                        onclick="cargarHorasEditar(<%= c.getIdCita() %>, '<%= c.getHora() %>')"
                                                        style="width: 36px; height: 36px; padding: 0; border-radius: 6px;">
                                                    <i class="fa-solid fa-pencil"></i>
                                                </button>

                                                <button class="btn btn-danger btn-sm d-flex align-items-center justify-content-center"
                                                        title="Eliminar"
                                                        data-bs-toggle="modal"
                                                        data-bs-target="#modalEliminar<%= c.getIdCita()%>"
                                                        style="width: 36px; height: 36px; padding: 0; border-radius: 6px;">
                                                    <i class="fa-solid fa-calendar-xmark"></i>
                                                </button>

                                            </div>

                                        <% } %>

                                    </td>


                                </tr>

                            <div class="modal fade" id="modalEliminar<%= c.getIdCita() %>" tabindex="-1" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-header bg-danger text-white">
                                            <h5 class="modal-title fw-bold"><i class="fa-solid fa-triangle-exclamation"></i> ¿Deseas cancelar la cita?</h5>
                                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                        </div>
                                        <div class="modal-body">
                                            <p>¿Estás completamente seguro de que deseas cancelar la cita Nro. <strong><%= c.getIdCita() %></strong> del cliente <strong><%= c.getCliente() %></strong>?</p>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                                            <a href="${pageContext.request.contextPath}/controladorcitas?accion=eliminar&id=<%= c.getIdCita() %>" class="btn btn-danger fw-semibold">Cancelar Cita</a>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="modal fade" id="modalEditarCita<%= c.getIdCita() %>" tabindex="-1">
                                <div class="modal-dialog modal-lg">
                                    <div class="modal-content">
                                        <div class="modal-header bg-warning-light text-white">
                                            <h5 class="modal-title"><i class="fa-solid fa-pen-to-square me-2"></i> Editar / Reprogramar Cita #<%= c.getIdCita() %></h5>
                                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                                        </div>
                                        <div class="modal-body">
                                            <form action="${pageContext.request.contextPath}/controladorcitas" method="POST">
                                                <input type="hidden" name="accion" value="editar">
                                                <input type="hidden" name="txtIdCita" value="<%= c.getIdCita() %>">
                                                <div class="row">
                                                    <div class="col-md-6 mb-3">
                                                        <label class="form-label">Mascota</label>
                                                        <select name="txtIdMascota" class="form-select" required>
                                                            <% if (listaMascotas != null) { 
                                                                     for(mascotas m : listaMascotas) { %>
                                                            <option value="<%= m.getIdMascota() %>" <%= m.getIdMascota() == c.getIdMascota() ? "selected" : "" %>>
                                                                <%= m.getNombre() %> (Dueño: <%= m.getNombreCliente() %>)
                                                            </option>
                                                            <%  } 
                                                                  } %>
                                                        </select>
                                                    </div>
                                                    <div class="col-md-6 mb-3">
                                                        <label class="form-label">Tipo Atención</label>
                                                        <select name="txtIdTipo" class="form-select" required>
                                                            <option value="1" <%= c.getIdTipo() == 1 ? "selected" : "" %>>1. Vacunación</option>
                                                            <option value="2" <%= c.getIdTipo() == 2 ? "selected" : "" %>>2. Cirugía</option>
                                                            <option value="3" <%= c.getIdTipo() == 3 ? "selected" : "" %>>3. Consulta</option>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="col-md-6 mb-3">
                                                        <label class="form-label">Fecha</label>
                                                        <input type="date" name="txtFecha" id="txtFechaEdit<%= c.getIdCita() %>" class="form-control" value="<%= c.getFecha() %>" min="<%= java.time.LocalDate.now() %>" required>
                                                    </div>
                                                    <div class="col-md-6 mb-3">
                                                        <label class="form-label">Hora</label>
                                                        <select name="txtHora" id="txtHoraEdit<%= c.getIdCita() %>" class="form-select" required>
                                                            <option value="<%=c.getHora()%>" selected><%= c.getHora() %></option>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label">Motivo</label>
                                                    <textarea name="txtMotivo" class="form-control" rows="2"><%= c.getMotivo() %></textarea>
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label">Estado General</label>
                                                    <select name="txtEstado" class="form-select">
                                                        <option value="PENDIENTE" <%= c.getEstado().equals("PENDIENTE") ? "selected" : ""%>>PENDIENTE</option>
                                                        <option value="CONFIRMADA" <%= c.getEstado().equals("CONFIRMADA") ? "selected" : ""%>>CONFIRMADA</option>
                                                        <option value="ATENDIDA" <%= c.getEstado().equals("ATENDIDA") ? "selected" : ""%>>ATENDIDA</option>
                                                        <option value="CANCELADA" <%= c.getEstado().equals("CANCELADA") ? "selected" : ""%>>CANCELADA</option>
                                                    </select>
                                                </div>
                                                <div class="modal-footer">
                                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                                                    <button type="submit" class="btn btn-warning">Guardar Cambios</button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <% 
                                    }
                                } else { 
                            %>
                            <tr>
                                <td colspan="7" class="text-center text-muted py-4">No se encontraron citas registradas.</td>
                            </tr>
                            <% } %>
                            
                            </tbody>
                            <tr id="filaSinResultados" style="display:none;">
                                <td colspan="7" class="text-center py-4 text-muted fw-bold">
                                    <i class="fa-solid fa-magnifying-glass"></i>
                                    No se encontraron resultados.
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>                
            </div>

            <div class="modal fade" id="modalNuevaCita" tabindex="-1">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header bg-success text-white">
                            <h5 class="modal-title"><i class="fa-solid fa-calendar-plus"></i> Registrar Nueva Cita</h5>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <form action="${pageContext.request.contextPath}/controladorcitas" method="POST">
                                <input type="hidden" name="accion" value="guardar">
                                <div class="row">
                                    <div class="col-md-4 mb-3">
                                        <label class="form-label">Cliente</label>
                                        <select name="txtIdCliente" class="form-select" id="txtIdCliente" required>
                                            <option value="">Seleccione Cliente</option>
                                            <% if (listaClientes != null) { 
                                                for(clientes cl : listaClientes) { %>
                                            <option value="<%= cl.getIdCliente() %>">ID: <%= cl.getIdCliente() %> - <%= cl.getNombreCompleto() %></option>
                                            <%  } 
                                            } %>
                                        </select>
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label class="form-label">Mascota</label>
                                        <select name="txtIdMascota" id="txtIdMascota" class="form-select" required disabled>
                                            <option value="">Seleccione Mascota</option>
                                            <% if (listaMascotas != null) {
                                                for(mascotas m : listaMascotas) { %>
                                            <option value="<%= m.getIdMascota() %>" data-cliente="<%= m.getIdCliente() %>">
                                                <%= m.getNombre() %> (Dueño: <%= m.getNombreCliente() %>)
                                            </option>
                                            <% }
                                             } %>
                                        </select>
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label class="form-label">Tipo Atención</label>
                                        <select name="txtIdTipo" class="form-select" required>
                                            <option value="">Seleccione tipo de atencion</option>
                                            <option value="1">1. Vacunación</option>
                                            <option value="2">2. Cirugía</option>
                                            <option value="3">3. Consulta</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Fecha</label>
                                        <input type="date" name="txtFecha" id="txtFecha" class="form-control" min="<%= java.time.LocalDate.now() %>" required>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Hora</label>
                                        <select name="txtHora" id="txtHora" class="form-select" required>
                                            <option value="">Seleccione hora</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Motivo</label>
                                    <textarea name="txtMotivo" class="form-control" rows="2"></textarea>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                                    <button type="submit" class="btn btn-success">Guardar Cita</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>                  
        </main>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="//cdn.jsdelivr.net/npm/alertifyjs@1.13.1/build/alertify.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script>
            function actualizarFecha() {
                const fecha = new Date();
                const opciones = {weekday: 'long', year: 'numeric', month: 'long', day: 'numeric'};
                document.getElementById("fechaHora").innerHTML = fecha.toLocaleDateString('es-ES', opciones) + " | " + fecha.toLocaleTimeString();
                }
                actualizarFecha();
                setInterval(actualizarFecha, 1000);
        </script>

        <%
            String mensajeExito = (String) request.getSession().getAttribute("mensajeExito");
            String mensajeError = (String) request.getSession().getAttribute("mensajeError");
            
            
            if (mensajeExito != null) {
        %>
        <script>
            alertify.success("<%= mensajeExito %>");
        </script>
        <%
                request.getSession().removeAttribute("mensajeExito");
            }
            if (mensajeError != null) {
        %>
        <script>
            alertify.error("<%= mensajeError %>");
        </script>
        <%
                request.getSession().removeAttribute("mensajeError");
            }
        %>

        <script>
            document.addEventListener("DOMContentLoaded", function () {

                const clienteSelect = document.getElementById("txtIdCliente");
                const mascotaSelect = document.getElementById("txtIdMascota");
                const todasOpciones = Array.from(mascotaSelect.options);

                clienteSelect.addEventListener("change", function () {
                    const idCliente = this.value;
                    mascotaSelect.innerHTML = "";

                    const opcionInicial = document.createElement("option");
                    opcionInicial.value = "";
                    opcionInicial.textContent = "Seleccione Mascota";
                    mascotaSelect.appendChild(opcionInicial);

                    if (!idCliente) {
                        mascotaSelect.disabled = true;
                        return;
                    }

                    mascotaSelect.disabled = false;
                    todasOpciones.forEach(op => {
                        if (op.value === "")
                            return;
                        if (op.dataset.cliente === idCliente) {
                            mascotaSelect.appendChild(op.cloneNode(true));
                        }
                    });
                });

                document.getElementById("txtFecha").addEventListener("change", function () {
                    let fecha = this.value;
                    fetch("${pageContext.request.contextPath}/controladorcitas?accion=horasDisponibles&fecha=" + fecha)
                            .then(response => response.json())
                            .then(data => {
                                let combo = document.getElementById("txtHora");
                                combo.innerHTML = '<option value="">Seleccione hora</option>';
                                data.forEach(function (hora) {
                                    let option = document.createElement("option");
                                    option.value = hora;
                                    option.textContent = hora;
                                    combo.appendChild(option);
                                });
                            })
                            .catch(error => console.error("ERROR:", error));
                });

            <% if (lista != null) { 
                    for(citas c : lista){ %>
                document.getElementById("txtFechaEdit<%= c.getIdCita() %>")
                        .addEventListener("change", function () {
                            let fecha = this.value;
                            fetch("${pageContext.request.contextPath}/controladorcitas?accion=horasDisponiblesEditar&fecha=" + fecha + "&idCita=<%= c.getIdCita() %>")
                                    .then(response => response.json())
                                    .then(data => {
                                        let combo = document.getElementById("txtHoraEdit<%= c.getIdCita() %>");
                                        combo.innerHTML = '<option value="">Seleccione hora</option>';
                                        data.forEach(function (hora) {
                                            let option = document.createElement("option");
                                            option.value = hora;
                                            option.textContent = hora;
                                            combo.appendChild(option);
                                        });
                                    });
                        });
            <%  } 
               } %>
            });

            function cargarHorasEditar(idCita, horaActual) {
                let combo = document.getElementById("txtHoraEdit" + idCita);
                combo.innerHTML = "";

                let option = document.createElement("option");
                option.value = horaActual;
                option.textContent = horaActual;
                option.selected = true;
                combo.appendChild(option);
            }
        </script>

        <%
        String mensajeEstado = (String) session.getAttribute("mensajeEstado");
        String tituloEstado = (String) session.getAttribute("tituloEstado");
        String tipoEstado = (String) session.getAttribute("tipoEstado");

        if (mensajeEstado != null) {
        %>

        <script>
            Swal.fire({
                icon: '<%= tipoEstado %>',
                title: '<%= tituloEstado %>',
                text: '<%= mensajeEstado %>',
                confirmButtonText: 'Aceptar',
                confirmButtonColor: '#198754'
            });
        </script>

        <%
            session.removeAttribute("mensajeEstado");
            session.removeAttribute("tituloEstado");
            session.removeAttribute("tipoEstado");
        }
        %>
        <script>
            function validarEnvioCorreo(form) {

                const estado = form.querySelector("select[name='estado']").value;

                if (estado === "CONFIRMADA") {
                    Swal.fire({
                        title: 'Enviando correo...',
                        html: 'Se esta notificando al cliente sobre la confirmacion de su cita.',
                        allowOutsideClick: false,
                        allowEscapeKey: false,
                        didOpen: () => {
                            Swal.showLoading();
                        }
                    });
                }

                return true;
            }
       function validarDescargaPDF(event) {
            event.preventDefault();
            const urlDescarga = event.currentTarget.href;

            const pathApp = window.location.pathname.substring(0, window.location.pathname.indexOf('/', 1)) || "/";
            document.cookie = "pdf_download_status=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=" + pathApp + ";";

            Swal.fire({
                title: 'Descargando PDF...',
                html: 'Se está procesando y descargando el comprobante de la reserva.',
                allowOutsideClick: false,
                allowEscapeKey: false,
                didOpen: () => {
                    Swal.showLoading();
                }
            });

            window.location.href = urlDescarga;

            let tiempoTranscurrido = 0;

            const timerCookie = setInterval(function() {
                tiempoTranscurrido += 500;

                const cookieExiste = document.cookie.split(';').some(item => item.trim().startsWith('pdf_download_status=success'));

                if (cookieExiste) {
                    clearInterval(timerCookie);

                    document.cookie = "pdf_download_status=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=" + pathApp + ";";

                    Swal.fire({
                        icon: 'success',
                        title: '¡Descarga Exitosa!',
                        text: 'El comprobante de reservación de cita se descargó correctamente.',
                        timer: 2000,
                        showConfirmButton: false
                    });
                } 
                else if (tiempoTranscurrido >= 10000) {
                    clearInterval(timerCookie);
                    Swal.fire({
                        icon: 'info',
                        title: 'Descarga finalizada',
                        text: 'Verifique su carpeta de descargas locales.',
                        confirmButtonText: 'Entendido',
                        confirmButtonColor: '#0088FF'
                    });
                }
            }, 500);
        }
        
        function cambiarColorEstado(selectElement) {
            selectElement.classList.remove('select-pendiente', 'select-confirmada', 'select-atendida', 'select-cancelada');

            const valor = selectElement.value;

            if (valor === 'PENDIENTE') {
                selectElement.classList.add('select-pendiente');
            } else if (valor === 'CONFIRMADA') {
                selectElement.classList.add('select-confirmada');
            } else if (valor === 'ATENDIDA') {
                selectElement.classList.add('select-atendida');
            } else if (valor === 'CANCELADA') {
                selectElement.classList.add('select-cancelada');
            }
        }

        document.addEventListener("DOMContentLoaded", function () {
            const selectsEstado = document.querySelectorAll("select[name='estado']");
            selectsEstado.forEach(select => {
                cambiarColorEstado(select);
            });
        });
        </script>
        <script>
document.addEventListener("DOMContentLoaded", function () {

    const txtBuscar = document.getElementById("txtBuscarCita");
    const filaSinResultados = document.getElementById("filaSinResultados");

    txtBuscar.addEventListener("input", function () {

        const texto = this.value.toLowerCase().trim();

        const filas = document.querySelectorAll(".fila-cita");

        let encontrados = 0;

        filas.forEach(fila => {

            fila.classList.remove("resaltado-busqueda");

            const id = fila.dataset.id.toLowerCase();
            const cliente = fila.dataset.cliente;
            const mascota = fila.dataset.mascota;

            const coincide =
                    id.includes(texto) ||
                    cliente.includes(texto) ||
                    mascota.includes(texto);

            if (coincide) {
                fila.style.display = "";
                encontrados++;

                if (texto !== "") {
                    fila.classList.add("resaltado-busqueda");
                }

            } else {
                fila.style.display = "none";
            }

        });

        filaSinResultados.style.display =
                encontrados === 0 ? "" : "none";

    });

});
</script>
    </body>
</html>