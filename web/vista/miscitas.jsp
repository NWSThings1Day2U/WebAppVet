<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

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
                <div class="filtros-vet row mb-4 align-items-center">
                    <!-- Contenedor de los botones de filtro -->
                    <div class="d-flex flex-wrap align-items-center justify-content-between gap-2 w-100">
    <!-- Grupo de botones de filtro -->
    <div class="d-flex flex-wrap gap-2">
        <button class="btn btn-filtro active" type="button">Todas</button>
        <button class="btn btn-filtro" type="button">Pendientes</button>
        <button class="btn btn-filtro" type="button">Confirmadas</button>
        <button class="btn btn-filtro" type="button">Completadas</button>
        <button class="btn btn-filtro" type="button">Canceladas</button>
    </div>

    <!-- Selector Combobox a la derecha -->
    <div class="combo-cliente-container">
        <select class="form-select select-custom-vet" style="font-size: 13px !important;">
            <option selected disabled>Selecciona cliente</option>
            <option value="1">Cliente A</option>
            <option value="2">Cliente B</option>
        </select>
    </div>
</div>

                </div>
            </div>
        </main>
        <!-- Bootstrap y alertify -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="//cdn.jsdelivr.net/npm/alertifyjs@1.13.1/build/alertify.min.js"></script>
        <jsp:include page="/componentes/mensajes.jsp" /> 
    </body>
</html>
