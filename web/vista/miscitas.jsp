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
    
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Mis citas</title>
        <!-- Bootstrap -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font de google -->
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Vollkorn:ital,wght@0,400..900;1,400..900&display=swap" rel="stylesheet">     <!-- Iconos -->

        <!-- Iconos -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
        <link rel="stylesheet" href="https://cloudflare.com">
        <!-- Alertify -->
        <link rel="stylesheet" href="//cdn.jsdelivr.net/npm/alertifyjs@1.13.1/build/css/alertify.min.css"/>
        <link rel="stylesheet" href="//cdn.jsdelivr.net/npm/alertifyjs@1.13.1/build/css/themes/default.min.css"/>
        <!-- Icono -->
        <link rel="icon" href="${pageContext.request.contextPath}/recursos/logoveet.png">

        <!-- CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/estilos/escliente.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/estilos/contenidocliente.css">
    </head>
    <body>
        <%
            request.setAttribute("paginaActual", "miscitas");
        %>
        <jsp:include page="../componentes/encabezado.jsp" />
        <main class="container mt-5 pt-4 contenido-cli" style="margin-top: 180px; margin-bottom: 150px;">
            <div class="container-fluid">
                <div class="bien-mensaje-vet">
                    <h2 class="text-center titulo-vet">Mis Citas</h2>
                    <p class="text-center p-vet">Administra las citas de tus mascotas</p>
                </div>
                <div class="filtros-vet row mb-4 gy-3 align-items-center">
                    <div class="col-12 col-md-auto me-auto">
                        <div class="d-flex flex-wrap gap-2">
                            <button class="btn btn-filtro active" type="button">Todas</button>
                            <button class="btn btn-filtro" type="button">Pendientes</button>
                            <button class="btn btn-filtro" type="button">Confirmadas</button>
                            <button class="btn btn-filtro" type="button">Completadas</button>
                            <button class="btn btn-filtro" type="button">Canceladas</button>
                        </div>
                    </div>

                    <div class="col-12 col-md-4 col-lg-3">
                        <div class="combo-cliente-container">
                            <select class="form-select select-custom-vet">
                                <option value="">Seleccione Cliente</option>
                                <% 
                                    if (listaClientes != null) { 
                                        int i = 1;
                                        for(clientes cl : listaClientes) { %>
                                <option value="<%= cl.getIdCliente() %>"><%=i%>. <%= cl.getNombreCompleto() %></option>
                                <% i++;
                                } 
                                } %>
                            </select>
                        </div>
                    </div>
                </div>
            </div>
        </main>
        <!-- Bootstrap y alertify -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="//cdn.jsdelivr.net/npm/alertifyjs@1.13.1/build/alertify.min.js"></script>
        <!-- SweetAlert -->
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <jsp:include page="/componentes/mensajes.jsp" /> 

        <c:if test="${not empty sessionScope.mensajeExito}">
            <script>
                Swal.fire({
                    icon: 'success',
                    title: 'Éxito',
                    text: '${sessionScope.mensajeExito}'
                });
            </script>
            <c:remove var="mensajeExito" scope="session"/>
        </c:if>

        <c:if test="${not empty sessionScope.mensajeError}">
            <script>
                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: '${sessionScope.mensajeError}'
                });
            </script>
            <c:remove var="mensajeError" scope="session"/>
        </c:if>
    </body>
</html>
