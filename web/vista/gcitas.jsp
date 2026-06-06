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

<%@page contentType="text/html" pageEncoding="UTF-8"%>
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

                <!-- tarjetas -->

                <div class="row g-4 mb-4">

                    <!-- ttal -->

                    <div class="col-xl-3 col-md-6">

                        <div class="card-dashboard">

                            <div>

                                <h5>Total Citas</h5>

                                <h1>

                                    <%= (lista != null) ? lista.size() : 0 %>

                                </h1>

                            </div>

                            <i class="fa-solid fa-calendar-check

                               text-success

                               icon-card"></i>

                        </div>

                    </div>

                    <!-- hoy -->

                    <div class="col-xl-3 col-md-6">

                        <div class="card-dashboard">

                            <div>

                                <h5>Citas Hoy</h5>

                                <h1><%= totalHoy %></h1>

                            </div>

                            <i class="fa-solid fa-clock

                               text-primary

                               icon-card"></i>

                        </div>

                    </div>

                    <!-- veterinarios -->

                    <div class="col-xl-3 col-md-6">

                        <div class="card-dashboard">

                            <div>

                                <h5>Pendientes</h5>

                                <h1><%= totalPendientes %></h1>

                            </div>

                            <i class="fa-solid fa-hourglass-half text-danger icon-card"></i>

                        </div>

                    </div>

                    <!-- pendientes -->

                    <div class="col-xl-3 col-md-6">

                        <div class="card-dashboard">

                            <div>

                                <h5>Canceladas</h5>

                                <h1><%= totalCanceladas %></h1>

                            </div>

                            <i class="fa-solid fa-circle-xmark text-secondary

                               icon-card"></i>

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
                            <input type="text" class="form-control" placeholder="Buscar cita..." style="width:230px;">
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
                                <tr>
                                    <td>#<%= c.getIdCita()%></td>
                                    <td><strong><%= c.getCliente()%></strong></td>
                                    <td>
                                        <i class="fa-solid fa-paw text-warning"></i> <%= c.getMascota()%>
                                    </td>
                                    <td><%= c.getFecha()%></td>
                                    <td><%= c.getHora()%></td>
                                    <td>
                                        <div class="d-flex gap-2 flex-wrap">
                                            <form action="${pageContext.request.contextPath}/controladorcitas" method="POST" class="d-flex gap-2 align-items-center">
                                                <input type="hidden" name="accion" value="actualizarEstado">
                                                <input type="hidden" name="id" value="<%= c.getIdCita()%>">
                                                <select name="estado" class="form-select form-select-sm">
                                                    <option value="PENDIENTE" <%= c.getEstado().equals("PENDIENTE") ? "selected" : ""%>>PENDIENTE</option>
                                                    <option value="CONFIRMADA" <%= c.getEstado().equals("CONFIRMADA") ? "selected" : ""%>>CONFIRMADA</option>
                                                    <option value="ATENDIDA" <%= c.getEstado().equals("ATENDIDA") ? "selected" : ""%>>ATENDIDA</option>
                                                    <option value="CANCELADA" <%= c.getEstado().equals("CANCELADA") ? "selected" : ""%>>CANCELADA</option>
                                                </select>
                                                <button type="submit" class="btn btn-primary btn-sm">
                                                    <i class="fa-solid fa-floppy-disk"></i>
                                                </button>
                                            </form>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="d-flex justify-content-center align-items-center gap-2 flex-wrap">


                                            <button class="btn btn-warning btn-sm" data-bs-toggle="modal" data-bs-target="#modalEditarCita<%= c.getIdCita() %>" onclick="cargarHorasEditar(
                                                    <%= c.getIdCita() %>,
                                                            document.getElementById('txtFechaEdit<%= c.getIdCita() %>').value,
                                                            '<%= c.getHora() %>'
                                                            )">
                                                <i class="fa-solid fa-pencil"></i>
                                            </button>

                                            <button class="btn btn-danger btn-sm" title="Eliminar" data-bs-toggle="modal" data-bs-target="#modalEliminar<%= c.getIdCita()%>">
                                                <i class="fa-solid fa-trash"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            <div class="modal fade" id="modalEliminar<%= c.getIdCita() %>" tabindex="-1" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-header bg-danger text-white">
                                            <h5 class="modal-title fw-bold"><i class="fa-solid fa-triangle-exclamation"></i> ¿Confirmar Eliminación?</h5>
                                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                        </div>
                                        <div class="modal-body">
                                            <p>¿Estás completamente seguro de que deseas eliminar cita Nro. <strong><%= c.getIdCita() %></strong> del cliente <strong><%= c.getCliente() %></strong> ?</p>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                                            <a href="${pageContext.request.contextPath}/controladorcitas?accion=eliminar&id=<%= c.getIdCita() %>" class="btn btn-danger fw-semibold">Eliminar Permanentemente</a>                                            </div>
                                    </div>
                                </div>
                            </div>
                            <div class="modal fade" id="modalEditarCita<%= c.getIdCita() %>" tabindex="-1">
                                <div class="modal-dialog modal-lg">
                                    <div class="modal-content">
                                        <div class="modal-header bg-warning text-white">
                                            <h5 class="modal-title"><i class="fa-solid fa-pen-to-square"></i> Editar / Reprogramar Cita #<%= c.getIdCita() %></h5>
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
                                                        <input type="date"  name="txtFecha"  id="txtFechaEdit<%= c.getIdCita() %>"   class="form-control"  value="<%= c.getFecha() %>"   min="<%= java.time.LocalDate.now() %>"  required>
                                                    </div>
                                                    <div class="col-md-6 mb-3">
                                                        <label class="form-label">Hora</label>
                                                        <select name="txtHora" id="txtHoraEdit<%= c.getIdCita() %>"  class="form-select" required>

                                                            <option value="<%= c.getHora() %>" selected>
                                                                <%= c.getHora() %>
                                                            </option>

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

                                            <option value="<%= m.getIdMascota() %>"
                                                    data-cliente="<%= m.getIdCliente() %>">
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
                                        <input type="date" name="txtFecha"  id="txtFecha" class="form-control"  min="<%= java.time.LocalDate.now() %>" required>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Hora</label>
                                        <select name="txtHora"  id="txtHora" class="form-select" required>
                                            <option value="">
                                                Seleccione hora
                                            </option>

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

            });
        </script>
        <script>

            document.getElementById("txtFecha")
                    .addEventListener("change", function () {

                        let fecha = this.value;
                        console.log("Fecha seleccionada:", fecha);
                        fetch(
                                "${pageContext.request.contextPath}/controladorcitas?accion=horasDisponibles&fecha="
                                + fecha
                                )
                                .then(response => response.json())
                                .then(data => {

                                    console.log(data);

                                    let combo = document.getElementById("txtHora");

                                    combo.innerHTML = '<option value="">Seleccione hora</option>';

                                    data.forEach(function (hora) {

                                        let option = document.createElement("option");

                                        option.value = hora;
                                        option.textContent = hora;

                                        combo.appendChild(option);

                                    });

                                })
                                .catch(error => {
                                    console.error("ERROR:", error);
                                });

                    });

        </script>
        <script>

            document.addEventListener("DOMContentLoaded", function () {

            <% for(citas c : lista){ %>

                document.getElementById("txtFechaEdit<%= c.getIdCita() %>")
                        .addEventListener("change", function () {

                            let fecha = this.value;

                            fetch(
                                    "${pageContext.request.contextPath}/controladorcitas?accion=horasDisponiblesEditar&fecha=" + fecha
                                    + "&idCita=<%= c.getIdCita() %>"
                                    )
                                    .then(response => response.json())
                                    .then(data => {

                                        let combo =
                                                document.getElementById("txtHoraEdit<%= c.getIdCita() %>");

                                        combo.innerHTML =
                                                '<option value="">Seleccione hora</option>';

                                        data.forEach(function (hora) {

                                            let option = document.createElement("option");

                                            option.value = hora;
                                            option.textContent = hora;

                                            combo.appendChild(option);

                                        });

                                    });

                        });

            <% } %>

            });


            function cargarHorasEditar(idCita, fecha, horaActual) {

                fetch(
                        "${pageContext.request.contextPath}/controladorcitas?accion=horasDisponiblesEditar"
                        + "&fecha=" + fecha
                        + "&idCita=" + idCita
                        )
                        .then(response => response.json())
                        .then(data => {

                            let combo = document.getElementById("txtHoraEdit" + idCita);

                            combo.innerHTML = "";

                            data.forEach(function (hora) {

                                let option = document.createElement("option");

                                option.value = hora;
                                option.textContent = hora;

                                if (hora === horaActual) {
                                    option.selected = true;
                                }

                                combo.appendChild(option);
                            });

                        });
            }

        </script>
    </body>
</html>