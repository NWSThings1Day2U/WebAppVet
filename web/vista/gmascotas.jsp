<%@page import="modelo.mascotas"%>
<%@page import="modelo.clientes"%>
<%@page import="java.util.List"%>
<%@page import="java.time.*"%>
<%@page import="java.time.format.*"%>
<%
    List<mascotas> lista = (List<mascotas>) request.getAttribute("listaMascotas");
    List<clientes> listaClientes = (List<clientes>) request.getAttribute("listaClientes");
    // Inicializar contadores en 0
    int totalPerros = 0;
    int totalGatos = 0;
    int totalNuevas = 0;

    if (lista != null) {
        for (mascotas m : lista) {
            String especie = (m.getEspecie() != null) ? m.getEspecie().trim().toLowerCase() : "";
            
            if (especie.equals("perro") || especie.equals("perra") || especie.equals("can")) {
                totalPerros++;
            } 
            else if (especie.equals("gato") || especie.equals("gata") || especie.equals("felino")) {
                totalGatos++;
            }

            if (m.getFechaNacimiento() != null) {
                try {
                    java.time.format.DateTimeFormatter fmt = java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd");
                    java.time.LocalDate fechaNac = java.time.LocalDate.parse(m.getFechaNacimiento(), fmt);
                    java.time.LocalDate fechaActual = java.time.LocalDate.now();
                    
                    if (java.time.temporal.ChronoUnit.DAYS.between(fechaNac, fechaActual) <= 90) {
                        totalNuevas++;
                    }
                } catch(Exception e) {
                    e.printStackTrace();
                }
            }
        }
    }
%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Mascotas</title>
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
            request.setAttribute("paginaActual", "mascotas");
        %>
        <jsp:include page="../componentes/encabezado.jsp" />
        
        <main class="container mt-5 pt-4 contenido-admin" style="margin-top: 180px; margin-bottom: 150px;"> 
            <div class="container-fluid">
                <div class="card-bienvenida mb-4">
                    <div class="row align-items-center">
                        <div class="col-lg-8">
                            <h1 class="fw-bold mb-2">
                                Lista de <span class="text-success">Mascotas</span>
                            </h1>
                            <p class="text-muted mb-0">
                                Administra la información de mascotas registradas en la clínica veterinaria.
                            </p>
                        </div>
                        <div class="col-lg-4 text-lg-end mt-3 mt-lg-0">
                            <div class="fecha-box">
                                <i class="fa-solid fa-paw"></i>
                                <span id="fechaHora"></span>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="row g-4 mb-4">
                    <div class="col-xl-3 col-md-6">
                        <div class="card-dashboard">
                            <div>
                                <h5>Total Mascotas</h5>
                                <h1><%= (lista != null) ? lista.size() : 0 %></h1>
                            </div>
                            <i class="fa-solid fa-paw text-warning icon-card"></i>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6"><div class="card-dashboard"><div><h5>Perros</h5><h1><%= totalPerros %></h1></div><i class="fa-solid fa-dog text-success icon-card"></i></div></div>
                    <div class="col-xl-3 col-md-6"><div class="card-dashboard"><div><h5>Gatos</h5><h1><%= totalGatos %></h1></div><i class="fa-solid fa-cat text-primary icon-card"></i></div></div>
                    <div class="col-xl-3 col-md-6"><div class="card-dashboard"><div><h5>Cachorros</h5><h1><%= totalNuevas %></h1></div><i class="fa-solid fa-heart-circle-plus text-danger icon-card"></i></div></div>
                </div>
                    
                <div class="tabla-panel">
                    <div class="d-flex justify-content-between align-items-center flex-wrap gap-3 mb-4">
                        <div>
                            <h3 class="fw-bold mb-1">Lista de Mascotas</h3>
                            <p class="text-muted mb-0">Visualiza y administra todas las mascotas registradas.</p>
                        </div>
                        <div class="d-flex gap-2 flex-wrap">
                            <input type="text" class="form-control" placeholder="Buscar mascota..." style="width:230px;">
                            <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#modalNuevaMascota">
                                <i class="fa-solid fa-paw"></i> Nueva Mascota
                            </button>
                        </div>
                    </div>
                    
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Nombre</th>
                                    <th>Dueño / Cliente</th>
                                    <th>Especie</th>
                                    <th>Raza</th>
                                    <th>Sexo</th>
                                    <th>Peso</th>
                                    <th>Edad</th>
                                    <th>Estado</th>
                                    <th class="text-center">Acciones</th>
                                </tr>
                            </thead >
                            <tbody>
                                <% 
                                    if (lista != null && !lista.isEmpty()) {
                                        for (mascotas m : lista) {
                                %>
                                <tr>
                                    <td>#<%= m.getIdMascota()%></td>
                                    <td>
                                        <strong>
                                            <i class="fa-solid fa-paw text-warning"></i> <%= m.getNombre()%>
                                        </strong>
                                    </td>
                                    <td><%= (m.getNombreCliente() != null) ? m.getNombreCliente() : "No asignado" %></td>
                                    <td><%= m.getEspecie()%></td>
                                    <td><%= m.getRaza()%></td>
                                    <td>
                                        <% if ("M".equals(m.getSexo())) { %>        
                                        <span class="badge bg-info-subtle text-info-emphasis border border-info-subtle">Macho</span>
                                        <% } else { %>    
                                        <span class="badge border" style="background-color: #fde8ef; color: #d63384; border-color: #fbc7d7 !important;"
                                              ">Hembra</span>
                                        <% } %>
                                    </td>
                                    <td><%=m.getPeso()%></td>
                                    <td>
                                        <%
                                        String fechanam = m.getFechaNacimiento(); 
                                        DateTimeFormatter formateador = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    
                                        try {
                                            LocalDate fechaNacimiento = LocalDate.parse(fechanam, formateador);
                                            LocalDate fechaActual = LocalDate.now();
        
                                            Period periodo = Period.between(fechaNacimiento, fechaActual);
                                            int anos = periodo.getYears();
                                            int meses = periodo.getMonths();
        
                                        %>
                                        <span class="badge bg-warning-subtle text-warning-emphasis border border-warning-subtle">
                                            <%
                                            if (anos > 0) {
                                                out.print(anos + (anos == 1 ? " año" : " años"));
                                            } else if (meses > 0) {
                                                out.print(meses + (meses == 1 ? " mes" : " meses"));
                                            } else {
                                                int dias = periodo.getDays();
                                                out.print(dias + (dias == 1 ? " día" : " días"));
                                            }
                                            %>
                                        </span>
                                        <%
                                    } catch (DateTimeParseException e) {
                                        %>
                                        <span class="badge bg-danger-subtle text-danger border border-danger-subtle">Error de fecha</span>
                                        <%   
                                    }
                                        %>
                                    </td>

                                    <td>
                                        <% if("ACTIVO".equalsIgnoreCase(m.getEstado()) || "1".equals(m.getEstado()) || m.getEstado() == null) { %>
                                            <span class="badge bg-success">Activo</span>
                                        <% } else if("INACTIVO".equalsIgnoreCase(m.getEstado())) { %>
                                            <span class="badge bg-secondary">Inactivo</span>
                                        <% } else { %>
                                            <span class="badge bg-danger"><%= m.getEstado() %></span>
                                        <% } %>
                                    </td>
                                    <td class="text-center">
                                        <div class="d-flex justify-content-center gap-2">
                                            <button class="btn btn-warning btn-sm" title="Editar" 
                                                    data-bs-toggle="modal" 
                                                    data-bs-target="#modalEditarMascota"
                                                    data-id="<%= m.getIdMascota() %>"
                                                    data-nombre="<%= m.getNombre() %>"
                                                    data-especie="<%= m.getEspecie() %>"
                                                    data-raza="<%= m.getRaza() %>"
                                                    data-idcliente="<%= m.getIdCliente() %>"
                                                    data-sexo="<%= m.getSexo() %>"
                                                    data-peso="<%= m.getPeso() %>"
                                                    data-fechanac="<%= m.getFechaNacimiento() %>"
                                                    data-estado="<%= m.getEstado() %>"
                                                    onclick="cargarDatosFormulario(this)">
                                                <i class="fa-solid fa-pen"></i>
                                            </button>
                                                
                                            <button class="btn btn-danger btn-sm" title="Eliminar" data-bs-toggle="modal" data-bs-target="#modalEliminar<%= m.getIdMascota()%>">
                                                <i class="fa-solid fa-trash"></i>
                                            </button>    
                                        </div>
                                    </td>
                                </tr><!-- Eliminar modal -->

                            <div class="modal fade" id="modalEliminar<%= m.getIdMascota() %>" tabindex="-1" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-header bg-danger text-white">
                                            <h5 class="modal-title fw-bold"><i class="fa-solid fa-triangle-exclamation"></i> ¿Confirmar Eliminación?</h5>
                                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                        </div>
                                        <div class="modal-body">
                                            <p>¿Estás completamente seguro de que deseas eliminar <strong><%=  m.getNombre() %></strong>  ?</p>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                                            <a href="${pageContext.request.contextPath}/controladormascota?accion=eliminar&id=<%= m.getIdMascota() %>" class="btn btn-danger fw-semibold">Eliminar Permanentemente</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                                <% 
                                        }
                                    } else { 
                                %>
                                <tr>
                                    <td colspan="7" class="text-center text-muted">No se encontraron mascotas cargadas. Accede desde el controlador.</td>
                                </tr>
                                
                                
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>                
            </div>
            
            <!-- crear modal -->
            <div class="modal fade" id="modalNuevaMascota" tabindex="-1">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <form action="controladormascota?accion=guardar" method="POST">
                            <div class="modal-header bg-success text-white">
                                <h5 class="modal-title"><i class="fa-solid fa-paw"></i> Registrar Nueva Mascota</h5>
                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body">
                                <div class="row">
                                    <div class="col-md-4 mb-3">
                                        <label class="form-label">Nombre</label>
                                        <input type="text" name="txtNombre" class="form-control" placeholder="Ingrese nombre" required>
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label class="form-label">Especie</label>
                                        <input type="text" name="txtEspecie" class="form-control" placeholder="Ingrese especie" required>
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label class="form-label">Raza</label>
                                        <input type="text" name="txtRaza" class="form-control" placeholder="Ingrese raza" required>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Nombre de cliente (Dueño)</label>
                                        <select name="txtIdCliente" class="form-select" required>
                                            <option value="" selected disabled>Selecciona dueño</option>
                                            <% if (listaClientes != null) {
                                                for(clientes c : listaClientes) { %>
                                                    <option value="<%= c.getIdCliente() %>">(ID: <%= c.getIdCliente() %>) - <%= c.getNombreCompleto() %></option>
                                            <%   }
                                               } %>
                                        </select>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Sexo</label>
                                        <select name="txtSexo" class="form-select" required>
                                            <option value="" selected disabled>Selecciona sexo</option>
                                            <option value="F">Hembra</option>
                                            <option value="M">Macho</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Peso (kg)</label>
                                        <input type="number" step="0.01" name="txtPeso" class="form-control" placeholder="Ingrese peso" min="0" required>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Fecha de nacimiento</label>
                                        <input type="date" name="txtFechaNac" class="form-control" required>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                                <button type="submit" class="btn btn-success">Guardar Mascota</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <div class="modal fade" id="modalEditarMascota" tabindex="-1">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <form action="controladormascota?accion=editar" method="POST">
                            <input type="hidden" name="txtId" id="editId">
                            
                            <div class="modal-header bg-warning text-dark">
                                <h5 class="modal-title"><i class="fa-solid fa-pen"></i> Editar Mascota</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body">
                                <div class="row">
                                    <div class="col-md-4 mb-3">
                                        <label class="form-label">Nombre</label>
                                        <input type="text" name="txtNombre" id="editNombre" class="form-control" required>
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label class="form-label">Especie</label>
                                        <input type="text" name="txtEspecie" id="editEspecie" class="form-control" required>
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label class="form-label">Raza</label>
                                        <input type="text" name="txtRaza" id="editRaza" class="form-control" required>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Nombre de cliente (Dueño)</label>
                                        <select name="txtIdCliente" id="editIdCliente" class="form-select" required>
                                            <option value="" disabled>Selecciona dueño</option>
                                            <% if (listaClientes != null) {
                                                for(clientes c : listaClientes) { %>
                                                    <option value="<%= c.getIdCliente() %>">(ID: <%= c.getIdCliente() %>) - <%= c.getNombreCompleto() %></option>
                                            <%   }
                                               } %>
                                        </select>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Sexo</label>
                                        <select name="txtSexo" id="editSexo" class="form-select" required>
                                            <option value="F">Hembra</option>
                                            <option value="M">Macho</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-4 mb-3">
                                        <label class="form-label">Peso (kg)</label>
                                        <input type="number" step="0.01" name="txtPeso" id="editPeso" class="form-control" min="0" required>
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label class="form-label">Fecha de nacimiento</label>
                                        <input type="date" name="txtFechaNac" id="editFechaNac" class="form-control" required>
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label class="form-label">Estado de la Mascota</label>
                                        <select name="txtEstado" id="editEstado" class="form-select" required>
                                            <option value="ACTIVO">ACTIVO</option>
                                            <option value="INACTIVO">INACTIVO</option>
                                            <option value="BAJA">BAJA</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                                <button type="submit" class="btn btn-warning">Actualizar Cambios</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </main>
        
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="//cdn.jsdelivr.net/npm/alertifyjs@1.13.1/build/alertify.min.js"></script>
        
        <% if(session.getAttribute("mensajeExito") != null) { %>
            <script>alertify.success('<%= session.getAttribute("mensajeExito") %>');</script>
        <% session.removeAttribute("mensajeExito"); } %>

        <% if(session.getAttribute("mensajeError") != null) { %>
            <script>alertify.error('<%= session.getAttribute("mensajeError") %>');</script>
        <% session.removeAttribute("mensajeError"); } %>
        
        <script>
            function cargarDatosFormulario(boton) {
                document.getElementById('editId').value = boton.getAttribute('data-id');
                document.getElementById('editNombre').value = boton.getAttribute('data-nombre');
                document.getElementById('editEspecie').value = boton.getAttribute('data-especie');
                document.getElementById('editRaza').value = boton.getAttribute('data-raza');
                document.getElementById('editIdCliente').value = boton.getAttribute('data-idcliente');
                document.getElementById('editSexo').value = boton.getAttribute('data-sexo');
                document.getElementById('editPeso').value = boton.getAttribute('data-peso');
                document.getElementById('editFechaNac').value = boton.getAttribute('data-fechanac');
                
                let estado = boton.getAttribute('data-estado');
                if(!estado || estado === 'null' || estado === '1') {
                    estado = 'ACTIVO';
                } else {
                    estado = estado.toUpperCase();
                }
                document.getElementById('editEstado').value = estado;
            }

            function actualizarFecha() {
                const fecha = new Date();
                const opciones = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
                document.getElementById("fechaHora").innerHTML = fecha.toLocaleDateString('es-ES', opciones) + " | " + fecha.toLocaleTimeString();
            }
            setInterval(actualizarFecha, 1000);
        </script>
    </body>
</html>