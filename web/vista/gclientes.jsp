<%-- 
    Document   : gclientes
    Created on : 20 may. 2026, 2:18:40 p. m.
    Author     : USUARIO
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="modelo.clientes"%>

<%
    List<clientes> lista =
            (List<clientes>) request.getAttribute("listaClientes");

    List<clientes> listaResponsables =
            (List<clientes>) request.getAttribute("listaResponsables");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Clientes</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Vollkorn:ital,wght@0,400..900;1,400..900&display=swap" rel="stylesheet">     
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
        <link rel="icon" href="${pageContext.request.contextPath}/recursos/logoveet.png">
        <link rel="stylesheet" href="//cdn.jsdelivr.net/npm/alertifyjs@1.13.1/build/css/alertify.min.css"/>
        <link rel="stylesheet" href="//cdn.jsdelivr.net/npm/alertifyjs@1.13.1/build/css/themes/default.min.css"/>

        <link rel="stylesheet" href="${pageContext.request.contextPath}/estilos/contenidoadmin.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/estilos/esadmin.css">
    </head>
    <body>
        <%
            request.setAttribute("paginaActual", "clientes");
        %>
        <jsp:include page="../componentes/encabezado.jsp" />
        
        <main class="container mt-5 pt-4 contenido-admin" style="margin-top: 180px; margin-bottom: 150px;"> 
            <div class="container-fluid">
                <div class="card-bienvenida mb-4">
                    <div class="row align-items-center">
                        <div class="col-lg-8">
                            <h1 class="fw-bold mb-2">
                                Lista de <span class="text-success">Clientes</span>
                            </h1>
                            <p class="text-muted mb-0">
                                Administra la información y datos de los clientes registrados y terceros.
                            </p>
                        </div>
                        <div class="col-lg-4 text-lg-end mt-3 mt-lg-0">
                            <div class="fecha-box">
                                <i class="fa-solid fa-people-group"></i>
                                <span id="fechaHora"></span>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="row g-4 mb-4">
                    <div class="col-xl-3 col-md-6">
                        <div class="card-dashboard">
                            <div>
                                <h5>Total Clientes</h5>
                                <h1>
                                    ${totalClientes}
                                </h1>
                            </div>
                            <i class="fa-solid fa-users text-primary icon-card"></i>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6">
                        <div class="card-dashboard">
                            <div>
                                <h5>C. Nuevos (7d)</h5>
                                <h1>${clientesNuevos} </h1>
                            </div>
                            <i class="fa-solid fa-user-plus text-success icon-card"></i>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6">
                        <div class="card-dashboard">
                            <div>
                                <h5>Clientes Activos</h5>
                                <h1>${clientesActivos}</h1>
                            </div>
                            <i class="fa-solid fa-user-check text-warning icon-card"></i>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6">
                        <div class="card-dashboard">
                            <div>
                                <h5>Mascotas Registradas</h5>
                                <h1>${mascotasRegistradas}</h1>
                            </div>
                            <i class="fa-solid fa-paw text-danger icon-card"></i>
                        </div>
                    </div>
                </div>
                
                <div class="tabla-panel">
                    <div class="d-flex justify-content-between align-items-center flex-wrap gap-3 mb-4">
                        <div>
                            <h3 class="fw-bold mb-1">Lista de Clientes</h3>
                            <p class="text-muted mb-0">Visualiza y administra todos los clientes registrados.</p>
                        </div>
                        <div class="d-flex gap-2 flex-wrap">
                            <input type="text" class="form-control" placeholder="Buscar cliente..." style="width:230px;">
                            <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#modalNuevoCliente">
                                <i class="fa-solid fa-user-plus"></i> Nuevo Cliente
                            </button>
                        </div>
                    </div>
                    
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Nombre Completo</th>
                                    <th>Responsable</th>
                                    <th>DNI</th>
                                    <th>Correo</th>
                                    <th>Teléfono</th>
                                    <th>Estado</th>
                                    <th class="text-center">Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% 
                                    if (lista != null && !lista.isEmpty()) {
                                        for (clientes c : lista) {
                                %>
                                <tr>
                                    <td>#<%= c.getIdCliente()%></td>
                                    <td><strong><%= c.getNombreCompleto()%></strong></td>
                                    <td>
                                        <%= c.getNombreResponsable() != null
                                                ? c.getNombreResponsable()
                                                : "Cliente Principal" %>
                                    </td>

                                    <td><%= c.getDni()%></td>
                                    <td><%= c.getCorreo()%></td>
                                    <td><%= c.getTelefono()%></td>
                                    <td>
                                        <% if(c.getEstado() == 1) { %>
                                            <span class="badge bg-success">Activo</span>
                                        <% } else { %>
                                            <span class="badge bg-danger">Inactivo</span>
                                        <% } %>
                                    </td>
                                    <td class="text-center">
                                        <div class="d-flex justify-content-center gap-2">
                                            <button class="btn btn-warning btn-sm" title="Editar" data-bs-toggle="modal" data-bs-target="#modalEditar<%= c.getIdCliente() %>">
                                                <i class="fa-solid fa-pen"></i>
                                            </button>
                                            <button class="btn btn-danger btn-sm" title="Eliminar" data-bs-toggle="modal" data-bs-target="#modalEliminar<%= c.getIdCliente() %>">
                                                <i class="fa-solid fa-trash"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>

                                <div class="modal fade" id="modalEditar<%= c.getIdCliente() %>" tabindex="-1" aria-hidden="true">
                                    <div class="modal-dialog modal-lg">
                                        <div class="modal-content">
                                            <div class="modal-header bg-warning text-dark">
                                                <h5 class="modal-title fw-bold">
                                                    <i class="fa-solid fa-pen-to-square"></i> Modificar Datos del Cliente #<%= c.getIdCliente() %>
                                                </h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                            </div>
                                            <div class="modal-body">
                                                <form action="${pageContext.request.contextPath}/controladorcliente?accion=editar" method="POST">
                                                    <input type="hidden" name="txtId" value="<%= c.getIdCliente() %>">
                                                    
                                                    <div class="row">
                                                        <div class="col-md-6 mb-3">
                                                            <label class="form-label fw-semibold">Nombre Completo</label>
                                                            <input type="text" name="txtNombre" class="form-control" value="<%= c.getNombreCompleto() %>" pattern="^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$" required>
                                                        </div>
                                                        <div class="col-md-6 mb-3">
                                                            <label class="form-label fw-semibold">DNI</label>
                                                            <input type="text" name="txtDni" class="form-control" value="<%= c.getDni() %>"  maxlength="8" pattern="\d{8}" placeholder="Ingresa Dni (Ej. 913191312)" required>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="col-md-6 mb-3">
                                                            <label class="form-label fw-semibold">Correo Electrónico</label>
                                                            <input type="email" name="txtCorreo" class="form-control" value="<%= c.getCorreo() %>" required>
                                                        </div>
                                                        <div class="col-md-6 mb-3">
                                                            <label class="form-label fw-semibold">Teléfono</label>
                                                            <input type="text" name="txtTelefono" class="form-control" value="<%= c.getTelefono() != null ? c.getTelefono() : "" %>"  maxlength="9" pattern="9\d{8}">
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="col-md-6 mb-3">
                                                            <label class="form-label fw-semibold">Estado de la cuenta</label>
                                                            <select name="txtEstado" class="form-select">
                                                                <option value="1" <%= c.getEstado() == 1 ? "selected" : "" %>>Activo</option>
                                                                <option value="0" <%= c.getEstado() == 0 ? "selected" : "" %>>Inactivo</option>
                                                            </select>
                                                        </div>
                                                    </div>
                                                    <div class="modal-footer px-0 pb-0 mt-3">
                                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                                                        <button type="submit" class="btn btn-warning fw-semibold">Guardar Cambios</button>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="modal fade" id="modalEliminar<%= c.getIdCliente() %>" tabindex="-1" aria-hidden="true">
                                    <div class="modal-dialog">
                                        <div class="modal-content">
                                            <div class="modal-header bg-danger text-white">
                                                <h5 class="modal-title fw-bold"><i class="fa-solid fa-triangle-exclamation"></i> ¿Confirmar Eliminación?</h5>
                                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                            </div>
                                            <div class="modal-body">
                                                <p>¿Estás completamente seguro de que deseas eliminar al cliente <strong><%= c.getNombreCompleto() %></strong> del sistema web?</p>
                                                <p class="text-danger small mb-0"><i class="fa-solid fa-circle-info"></i> Nota: Esta acción podría fallar si el cliente ya tiene registros de mascotas o citas médicas en la veterinaria.</p>
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                                                <a href="${pageContext.request.contextPath}/controladorcliente?accion=eliminar&id=<%= c.getIdCliente() %>" class="btn btn-danger fw-semibold">Eliminar Permanentemente</a>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <% 
                                        }
                                    } else { 
                                %>
                                <tr>
                                    <td colspan="7" class="text-center text-muted py-4">No se encontraron clientes registrados en la clínica veterinaria.</td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            
            <div class="modal fade" id="modalNuevoCliente" tabindex="-1">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header bg-success text-white">
                            <h5 class="modal-title fw-bold">
                                <i class="fa-solid fa-user-plus"></i> Registrar Nuevo Cliente
                            </h5>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <form action="${pageContext.request.contextPath}/controladorcliente?accion=guardar" method="POST">
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label fw-semibold">Nombre Completo</label>
                                        <input type="text" name="txtNombre" class="form-control" placeholder="Ingrese nombre y apellido" required>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label fw-semibold">DNI</label>
                                        <input type="text" name="txtDni" class="form-control" placeholder="Ingrese número de documento" required>
                                    </div>
                                </div> 
                                <div class="row"><div class="col-md-12 mb-3">

                                        <label class="form-label fw-semibold">
                                            Cliente Responsable
                                        </label>

                                        <select name="idClienteResponsable" class="form-select">

                                            <option value="">
                                                Cliente Principal
                                            </option>

                                            <% if(listaResponsables != null){
                                                for(clientes cli : listaResponsables){ %>

                                            <option value="<%= cli.getIdCliente() %>">
                                                <%= cli.getNombreCompleto() %> - DNI: <%= cli.getDni() %>
                                            </option>

                                            <% }} %>

                                        </select>

                                    </div></div>
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label fw-semibold">Correo Electrónico</label>
                                        <input type="email" name="txtCorreo" class="form-control" placeholder="ejemplo@correo.com" required>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label fw-semibold">Teléfono / Celular</label>
                                        <input type="text" name="txtTelefono" class="form-control" placeholder="Ingrese teléfono de contacto">
                                    </div>
                                </div>
                                <div class="modal-footer px-0 pb-0 mt-3">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                                    <button type="submit" class="btn btn-success fw-semibold">Guardar Cliente</button>
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
                const opciones = {
                    weekday: 'long',
                    year: 'numeric',
                    month: 'long',
                    day: 'numeric'
                };
                document.getElementById("fechaHora").innerHTML =
                        fecha.toLocaleDateString('es-ES', opciones) + " | " + fecha.toLocaleTimeString();
            }
            setInterval(actualizarFecha, 1000);
            actualizarFecha();
        </script>
    </body>
</html>