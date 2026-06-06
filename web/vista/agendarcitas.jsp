<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Agendar Citas</title>
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
            request.setAttribute("paginaActual", "agendarcitas");
        %>
        <jsp:include page="../componentes/encabezado.jsp" />
        <main class="container mt-5 pt-4 contenido-cli" style="margin-top: 180px; margin-bottom: 150px;">
            <div class="container-fluid">
                <div class="bien-mensaje-vet">
                    <h2 class="text-center titulo-vet">Agendar Nueva Cita</h2>
                    <p class="text-center p-vet">Completa los datos del formulario para la reservación.</p>
                </div>
                <div class="tabla-agendar">
                    <div class="filtros-vet row mb-4 align-items-center">
                        <div class="col-12">
                            <div class="d-flex gap-3 justify-content-start">
                                <button class="btn btn-cliente active" id="antiguo" type="button">Cliente Antiguo</button>
                                <button class="btn btn-cliente" id="nuevo" type="button">Cliente Nuevo</button>
                            </div>


                            <!-- Si es antiguo -->
                            <div class="con-cliente mt-4" id="content-antiguo">
                                <jsp:include page="forantiguocliente.jsp"/>
                            </div>

                            <!-- Si es nuevo  -->
                            <div class="con-cliente mt-4 d-none" id="content-nuevo">

                                 <jsp:include page="fornuevocliente.jsp"/>
                            </div>

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
        <script>
            const btnAntiguo = document.getElementById('antiguo');
            const btnNuevo = document.getElementById('nuevo');

            const contentAntiguo = document.getElementById('content-antiguo');
            const contentNuevo = document.getElementById('content-nuevo');

            btnAntiguo.addEventListener('click', () => {
                btnAntiguo.classList.add('active');
                btnNuevo.classList.remove('active');

                contentAntiguo.classList.remove('d-none');
                contentNuevo.classList.add('d-none');
            });

            btnNuevo.addEventListener('click', () => {
                btnNuevo.classList.add('active');
                btnAntiguo.classList.remove('active');

                contentNuevo.classList.remove('d-none');
                contentAntiguo.classList.add('d-none');
            });
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
