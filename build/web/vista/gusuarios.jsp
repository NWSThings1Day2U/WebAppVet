<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="modelo.usuarios"%>

<%
    List<usuarios> lista = (List<usuarios>) request.getAttribute("listaUsuarios");
    
    int totalUsuarios = (lista != null) ? lista.size() : 0;
    int totalAdmins = 0;
    int totalClientesReg = 0;
    int totalInactivos = 0;
    
    if (lista != null) {
        for (usuarios u : lista) {
            if (u.getRol().equalsIgnoreCase("admin")) {
                totalAdmins++;
            } else {
                totalClientesReg++;
            }
            if (u.getEstadoCliente() == 0) {
                totalInactivos++;
            }
        }
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Gestión de Usuarios Registrados</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Vollkorn:wght@400;700&display=swap" rel="stylesheet">     
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
        <link rel="icon" href="${pageContext.request.contextPath}/recursos/logoveet.png">
        <link rel="stylesheet" href="//cdn.jsdelivr.net/npm/alertifyjs@1.13.1/build/css/alertify.min.css"/>
        <link rel="stylesheet" href="//cdn.jsdelivr.net/npm/alertifyjs@1.13.1/build/css/themes/default.min.css"/>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/estilos/contenidoadmin.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/estilos/esadmin.css">
    </head>
    <body>
        <% request.setAttribute("paginaActual", "usuarios"); %>
        <jsp:include page="../componentes/encabezado.jsp" />
        
        <main class="container mt-5 pt-4 contenido-admin" style="margin-top: 180px; margin-bottom: 150px;"> 
            <div class="container-fluid">
                
                <div class="card-bienvenida mb-4">
                    <div class="row align-items-center">
                        <div class="col-lg-8">
                            <h1 class="fw-bold mb-2">Lista de <span class="text-success">Usuarios Registrados</span></h1>
                            <p class="text-muted mb-0">Administra las cuentas generales, accesos y asignación de roles de la veterinaria Gallito de las Rocas.</p>
                        </div>
                        <div class="col-lg-4 text-lg-end mt-3 mt-lg-0">
                            <div class="fecha-box">
                                <i class="fa-solid fa-user-shield"></i> <span id="fechaHora"></span>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="row g-4 mb-4">
                    <div class="col-xl-3 col-md-6">
                        <div class="card-dashboard">
                            <div><h5>Total Cuentas</h5><h1><%= totalUsuarios %></h1></div>
                            <i class="fa-solid fa-users text-primary icon-card"></i>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6">
                        <div class="card-dashboard">
                            <div><h5>Administradores</h5><h1><%= totalAdmins %></h1></div>
                            <i class="fa-solid fa-user-tie text-danger icon-card"></i>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6">
                        <div class="card-dashboard">
                            <div><h5>Clientes Registrados</h5><h1><%= totalClientesReg %></h1></div>
                            <i class="fa-solid fa-user-check text-info icon-card"></i>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6">
                        <div class="card-dashboard">
                            <div><h5>Cuentas Inactivas</h5><h1><%= totalInactivos %></h1></div>
                            <i class="fa-solid fa-user-slash text-secondary icon-card"></i>
                        </div>
                    </div>
                </div>
                
                <div class="tabla-panel">
                    <div class="d-flex justify-content-between align-items-center flex-wrap gap-3 mb-4">
                        <div>
                            <h3 class="fw-bold mb-1">Cuentas del Sistema</h3>
                            <p class="text-muted mb-0">Visualiza el rol, nombre de usuario y datos vinculados.</p>
                        </div>
                        <div class="d-flex gap-2 flex-wrap">
                            <input type="text" class="form-control" placeholder="Buscar usuario..." style="width:250px;">
                            <button class="btn btn-success fw-semibold" data-bs-toggle="modal" data-bs-target="#modalRegistrarUsuario">
                                <i class="fa-solid fa-user-plus me-1"></i> Nuevo Usuario
                            </button>
                        </div>
                    </div>
                    
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Usuario</th>
                                    <th>Rol</th>
                                    <th>Nombre Completo</th>
                                    <th>DNI</th>
                                    <th>Correo</th>
                                    <th>Estado Cuenta</th>
                                    <th class="text-center">Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% 
                                    if (lista != null && !lista.isEmpty()) {
                                        for (usuarios u : lista) {
                                %>
                                <tr>
                                    <td>#<%= u.getIdUsuario() %></td>
                                    <td><span class="badge bg-secondary text-white"><%= u.getNombreusuario() %></span></td>
                                    <td>
                                        <% if(u.getRol().equalsIgnoreCase("admin")) { %>
                                            <span class="badge bg-danger"><i class="fa-solid fa-user-shield me-1"></i><%= u.getRol() %></span>
                                        <% } else { %>
                                            <span class="badge bg-info text-dark"><i class="fa-solid fa-user me-1"></i><%= u.getRol() %></span>
                                        <% } %>
                                    </td>
                                    <td><strong><%= u.getNombrecompleto() %></strong></td>
                                    <td><%= u.getDni() %></td>
                                    <td><%= u.getCorreo() %></td>
                                    <td>
                                        <% if(u.getEstadoCliente() == 1) { %>
                                            <span class="badge bg-success">Activo</span>
                                        <% } else { %>
                                            <span class="badge bg-secondary">Inactivo</span>
                                        <% } %>
                                    </td>
                                   <td class="text-center">
                                        <div class="d-flex justify-content-center gap-2">
                                            <button class="btn btn-warning btn-sm fw-semibold text-dark" title="Editar Datos" data-bs-toggle="modal" data-bs-target="#modalEditar<%= u.getIdUsuario() %>">
                                                <i class="fa-solid fa-pencil"></i> 
                                            </button>

                                            <% if (u.getEstadoCliente() == 1) { %>
                                                <button type="button" 
                                                        onclick="confirmarBaja(<%= u.getIdUsuario() %>, '<%= u.getNombreusuario() %>')" 
                                                        class="btn btn-danger btn-sm fw-semibold text-white" 
                                                        title="Dar de baja cuenta">
                                                    <i class="fa-solid fa-user-xmark"></i>
                                                </button>
                                            <% } else { %>
                                                <button type="button" 
                                                        onclick="confirmarAlta(<%= u.getIdUsuario() %>, '<%= u.getNombreusuario() %>')" 
                                                        class="btn btn-success btn-sm fw-semibold text-white" 
                                                        title="Reactivar cuenta">
                                                    <i class="fa-solid fa-user-check"></i>
                                                </button>
                                            <% } %>
                                        </div>
                                    </td>
                                </tr>

                                <div class="modal fade" id="modalEditar<%= u.getIdUsuario() %>" tabindex="-1" aria-hidden="true">
                                    <div class="modal-dialog">
                                        <div class="modal-content">
                                            <div class="modal-header bg-warning text-dark">
                                                <h5 class="modal-title fw-bold"><i class="fa-solid fa-user-gear"></i> Modificar Cuenta de Usuario</h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                            </div>
                                            <div class="modal-body text-start">
                                                <form action="${pageContext.request.contextPath}/controladorusuarios?accion=editar" method="POST">
                                                    <input type="hidden" name="txtIdUsuario" value="<%= u.getIdUsuario() %>">
                                                    
                                                    <div class="mb-2">
                                                        <label class="form-label fw-semibold">Nombre de Usuario (Login):</label>
                                                        <input type="text" name="txtUser" class="form-control" value="<%= u.getNombreusuario() %>" required>
                                                    </div>
                                                    <div class="mb-2">
                                                        <label class="form-label fw-semibold">Nombre Completo:</label>
                                                        <input type="text" name="txtNombre" class="form-control" value="<%= u.getNombrecompleto() %>" required>
                                                    </div>
                                                    <div class="row">
                                                        <div class="col-md-6 mb-2">
                                                            <label class="form-label fw-semibold">DNI:</label>
                                                            <input type="text" name="txtDni" class="form-control" value="<%= u.getDni() %>" required maxlength="15">
                                                        </div>
                                                        <div class="col-md-6 mb-2">
                                                            <label class="form-label fw-semibold">Teléfono:</label>
                                                            <input type="text" name="txtTelefono" class="form-control" value="<%= u.getTelefono() %>">
                                                        </div>
                                                    </div>
                                                    <div class="mb-2">
                                                        <label class="form-label fw-semibold">Correo Electrónico:</label>
                                                        <input type="email" name="txtCorreo" class="form-control" value="<%= u.getCorreo() %>" required>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label fw-semibold text-danger">Asignación de Rol:</label>
                                                        <select name="txtNuevoRol" class="form-select" required>
                                                            <option value="1" <%= u.getRol().equalsIgnoreCase("Administrador") ? "selected" : "" %>>Administrador / Veterinario</option>
                                                            <option value="2" <%= u.getRol().equalsIgnoreCase("Cliente") ? "selected" : "" %>>Cliente Registrado Web</option>
                                                        </select>
                                                    </div>
                                                    
                                                    <div class="alert alert-info py-2 mb-0 small">
                                                        <i class="fa-solid fa-circle-info"></i> El cambio de rol migrará automáticamente los registros internos de la veterinaria resguardando el historial.
                                                    </div>
                                                    
                                                    <div class="modal-footer px-0 pb-0 mt-3">
                                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                                                        <button type="submit" class="btn btn-dark fw-semibold">Guardar Cambios</button>
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
                                    <td colspan="8" class="text-center text-muted py-4">No se encontraron usuarios registrados en la base de datos.</td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </main>

        <div class="modal fade" id="modalRegistrarUsuario" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header bg-success text-white">
                        <h5 class="modal-title fw-bold"><i class="fa-solid fa-user-plus"></i> Registrar Nuevo Usuario</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form action="${pageContext.request.contextPath}/controladorusuarios?accion=registrar" method="POST">
                            <div class="row">
                                <div class="col-md-6 mb-2">
                                    <label class="form-label fw-semibold">Usuario (Login):</label>
                                    <input type="text" name="txtUser" class="form-control" required placeholder="ej: juan99">
                                </div>
                                <div class="col-md-6 mb-2">
                                    <label class="form-label fw-semibold">Contraseña:</label>
                                    <input type="password" name="txtPass" class="form-control" required placeholder="******">
                                </div>
                            </div>
                            <div class="mb-2">
                                <label class="form-label fw-semibold">Nombre Completo:</label>
                                <input type="text" name="txtNombre" class="form-control" required placeholder="Juan Pérez Celis">
                            </div>
                            <div class="row">
                                <div class="col-md-6 mb-2">
                                    <label class="form-label fw-semibold">DNI:</label>
                                    <input type="text" name="txtDni" class="form-control" required maxlength="8">
                                </div>
                                <div class="col-md-6 mb-2">
                                    <label class="form-label fw-semibold">Teléfono:</label>
                                    <input type="text" name="txtTelefono" class="form-control" placeholder="987654321">
                                </div>
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Correo Electrónico:</label>
                                <input type="email" name="txtCorreo" class="form-control" required placeholder="juan@gmail.com">
                            </div>
                            <div class="modal-footer px-0 pb-0">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                                <button type="submit" class="btn btn-success fw-semibold">Registrar Cuenta</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="//cdn.jsdelivr.net/npm/alertifyjs@1.13.1/build/alertify.min.js"></script>
        
        <script>
            function actualizarFecha() {
                const fecha = new Date();
                const opciones = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
                document.getElementById("fechaHora").innerHTML = fecha.toLocaleDateString('es-ES', opciones) + " | " + fecha.toLocaleTimeString();
            }
            setInterval(actualizarFecha, 1000);
            actualizarFecha();


            <% String success = (String) session.getAttribute("msgSuccess");
               String error = (String) session.getAttribute("msgError");
               if(success != null) { %>
                    alertify.success('<%= success %>');
            <% session.removeAttribute("msgSuccess"); } %>
            <% if(error != null) { %>
                    alertify.error('<%= error %>');
            <% session.removeAttribute("msgError"); } %>
                
                
            
            function confirmarBaja(id, usuario) {
                alertify.confirm('Confirmar Baja Lógica', 
                    '¿Está seguro de que desea DAR DE BAJA la cuenta del usuario <strong>' + usuario + '</strong>? El usuario no podrá iniciar sesión.', 
                    function(){ 
                        window.location.href = "${pageContext.request.contextPath}/controladorusuarios?accion=cambiarEstado&id=" + id + "&estado=1";
                    }, 
                    function(){ 
                        alertify.error('Operación cancelada'); 
                    }
                ).set('labels', {ok:'Sí, dar de baja', cancel:'Cancelar'});
            }

            function confirmarAlta(id, usuario) {
                alertify.confirm('Confirmar Reactivación', 
                    '¿Desea REACTIVAR y dar de ALTA la cuenta del usuario <strong>' + usuario + '</strong> nuevamente?', 
                    function(){ 
                        window.location.href = "${pageContext.request.contextPath}/controladorusuarios?accion=cambiarEstado&id=" + id + "&estado=0";
                    }, 
                    function(){ 
                        alertify.error('Operación cancelada'); 
                    }
                ).set('labels', {ok:'Sí, activar cuenta', cancel:'Cancelar'});
            }
        </script>
    </body>
</html>