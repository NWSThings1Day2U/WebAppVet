<%-- 
    Document   : ghorarios
    Created on : 2 jun. 2026, 11:03:48 p. m.
    Author     : USUARIO
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.horarios"%>
<%@page import="java.util.List"%>

<%
    List<horarios> lista = (List<horarios>) request.getAttribute("listaHorarios");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Horarios</title>
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
           request.setAttribute("paginaActual", "horario");
        %>
        <jsp:include page="../componentes/encabezado.jsp" />
        <main class="container mt-5 pt-4 contenido-admin" style="margin-top: 180px; margin-bottom: 150px;"> 
            <div class="container-fluid">
                <div class="card-bienvenida mb-4">
                    <div class="row align-items-center">
                        <div class="col-lg-8">
                            <h1 class="fw-bold mb-2">
                                Lista de <span class="text-success">Horarios Disponibles</span>
                            </h1>
                            <p class="text-muted mb-0">
                                Administra la información de los horarios en la clínica veterinaria.
                            </p>
                        </div>
                        <div class="col-lg-4 text-lg-end mt-3 mt-lg-0">
                            <div class="fecha-box">
                                <i class="fa-solid fa-clock"></i>
                                <span id="fechaHora"></span>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="tabla-panel">
                    <div class="d-flex justify-content-between align-items-center flex-wrap gap-3 mb-4">
                        <div>
                            <h3 class="fw-bold mb-1">Horario</h3>
                            <p class="text-muted mb-0">Visualiza y administra todos los horarios disponibles.</p>
                        </div>
                    </div>

                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>Día</th>
                                    <th>Inicio</th>
                                    <th>Fin</th>
                                    <th>Duración</th>
                                    <th>Cupos</th>
                                    <th>Activo</th>
                                    <th class="text-center">Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    if (lista != null && !lista.isEmpty()) {
                                        for (horarios h : lista) {
                                %>

                                <tr>
                                    <td><%= h.getDiaSemana() %></td>

                                    <td><%= h.getHoraInicio() %></td>

                                    <td><%= h.getHoraFin() %></td>

                                    <td><%= h.getDuracionMinutos() %> min</td>

                                    <td><%= h.getCuposMaximos() %></td>

                                    <td>
                                        <% if(h.getActivo() == 1){ %>
                                        <span class="badge bg-success">Activo</span>
                                        <% } else { %>
                                        <span class="badge bg-danger">Inactivo</span>
                                        <% } %>
                                    </td>

                                    <td class="text-center">
                                        <button class="btn btn-warning btn-sm"
                                                data-bs-toggle="modal"
                                                data-bs-target="#modalEditar<%= h.getIdHorario() %>">
                                            <i class="fa-solid fa-pen"></i>
                                        </button>
                                    </td>
                                </tr>
                            <div class="modal fade"
                                 id="modalEditar<%= h.getIdHorario() %>"
                                 tabindex="-1">

                                <div class="modal-dialog">
                                    <div class="modal-content">

                                        <div class="modal-header bg-warning-light">
                                            <h5 class="modal-title">
                                                <i class="fa-solid fa-pen-to-square me-2"></i>Editar horario de <%= h.getDiaSemana() %>
                                            </h5>
                                            <button type="button"
                                                    class="btn-close"
                                                    data-bs-dismiss="modal">
                                            </button>
                                        </div>

                                        <div class="modal-body">

                                            <form action="${pageContext.request.contextPath}/controladorhorario"
                                                  method="POST">

                                                <input type="hidden"
                                                       name="accion"
                                                       value="editar">

                                                <input type="hidden"
                                                       name="txtIdHorario"
                                                       value="<%= h.getIdHorario() %>">

                                                <div class="mb-3">
                                                    <label>Hora Inicio</label>
                                                    <input type="time"
                                                           name="txtHoraInicio"
                                                           class="form-control"
                                                           value="<%= h.getHoraInicio() %>"
                                                           required>
                                                </div>

                                                <div class="mb-3">
                                                    <label>Hora Fin</label>
                                                    <input type="time"
                                                           name="txtHoraFin"
                                                           class="form-control"
                                                           value="<%= h.getHoraFin() %>"
                                                           required>
                                                </div>

                                                <div class="mb-3">
                                                    <label>Duración (minutos)</label>
                                                    <input type="number"
                                                           name="txtDuracion"
                                                           class="form-control"
                                                           value="<%= h.getDuracionMinutos() %>"
                                                           required>
                                                </div>

                                                <div class="mb-3">
                                                    <label>Cupos máximos</label>
                                                    <input type="number"
                                                           name="txtCupos"
                                                           class="form-control"
                                                           value="<%= h.getCuposMaximos() %>"
                                                           required>
                                                </div>

                                                <div class="mb-3">
                                                    <label>Estado</label>

                                                    <select name="txtActivo"
                                                            class="form-select">

                                                        <option value="1"
                                                                <%= h.getActivo()==1 ? "selected" : "" %>>
                                                            Activo
                                                        </option>

                                                        <option value="0"
                                                                <%= h.getActivo()==0 ? "selected" : "" %>>
                                                            Inactivo
                                                        </option>

                                                    </select>
                                                </div>

                                                <div class="modal-footer">

                                                    <button type="button"
                                                            class="btn btn-secondary"
                                                            data-bs-dismiss="modal">
                                                        Cancelar
                                                    </button>

                                                    <button type="submit"
                                                            class="btn btn-warning">
                                                        Guardar cambios
                                                    </button>

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
                                <td colspan="7" class="text-center">
                                    No existen horarios registrados.
                                </td>
                            </tr>

                            <%
                                }
                            %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </main>

        <!-- Bootstrap -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="//cdn.jsdelivr.net/npm/alertifyjs@1.13.1/build/alertify.min.js"></script>
        <jsp:include page="/componentes/pie.jsp"/>
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
