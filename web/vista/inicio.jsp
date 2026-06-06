
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Inicio</title>
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
            request.setAttribute("paginaActual", "inicio");
        %>
        <jsp:include page="../componentes/encabezado.jsp" />
        <main class="container mt-5 pt-4 contenido-cli" style="margin-top: 180px; margin-bottom: 150px;">
            <div class="container-fluid">
                <div class="bien-mensaje-vet">
                    <h1 class="text-start titulo-vet fs-2 mb-2" style="color: #333;">¡Hola, 
                        <span style="color: #336600;">${sessionScope.nombrecompleto}</span>! 
                        <span><i class="fa-solid fa-hand mano-animada"></i></span>
                    </h1>
                    <p class="text-muted mb-4">¿Cómo podemos ayudar a tu mascota hoy?</p>
                </div>
                <div class="buscarmas-vet">
                    <form class="d-flex mb-4" action="controladorbuscar" method="GET" >
                        <input type="hidden" name="buscar" value="lupa">
                        <div class="input-group">
                            <button class="input-group-text border-end-0" style="background: #ffffff !important; color: rgb(210, 213, 217);" type="submit">
                                <i class="fa-solid fa-magnifying-glass"></i>
                            </button>
                            <input class="form-control border-start-0" name="termino" type="search" placeholder="Buscar mascota...">

                        </div>
                    </form>
                </div>

                <div class="tarjetas-servicio-vet mt-5 ">
                    <h2 class="text-start titulo-vet fs-3 mb-4" style="color: #333 !important;">Servicios Veterinarios:</h2>
                    <div class="tarjeta mb-5">
                        <div class="row row-cols-1 row-cols-md-3 g-4">

                            <!-- SERVICIO 1: VACUNACIÓN -->
                            <div class="col">
                                <div class="card card-servicio h-100">
                                    <div class="row g-0 h-100">
                                        <div class="col-md-6">
                                            <img src="https://laverdad.com/wp-content/uploads/2024/06/vacunas-para-perros-768x512-1.jpg" class="img-fluid rounded-start h-100" style="object-fit: cover; width: 100%; min-height: 120px; object-position: right;" alt="imagenreferencialvacunacion">
                                        </div>
                                        <div class="col-md-6 d-flex align-items-center">
                                            <div class="card-body">
                                                <h5 class="card-title subtitulo-vet2">Vacunación</h5>
                                                <p class="card-text text-muted">Vacunas para todas las especies de animales.</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- SERVICIO 2: CIRUGÍA -->
                            <div class="col">
                                <div class="card card-servicio h-100">
                                    <div class="row g-0 h-100">
                                        <div class="col-md-6">
                                            <img src="https://img.magnific.com/fotos-premium/primer-plano-perro-tendido-mesa-operaciones_1112411-6235.jpg" class="img-fluid rounded-start h-100" style="object-fit: cover; width: 100%; min-height: 120px; object-position: center;" alt="imagenreferencialcirugia">
                                        </div>
                                        <div class="col-md-6 d-flex align-items-center">
                                            <div class="card-body">
                                                <h5 class="card-title subtitulo-vet2">Cirugía</h5>
                                                <p class="card-text text-muted">Cirugías inmediatas en caso de emergencias.</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- SERVICIO 3: CONSULTAS -->
                            <div class="col">
                                <div class="card card-servicio h-100">
                                    <div class="row g-0 h-100">
                                        <div class="col-md-6">
                                            <img src="https://img.magnific.com/foto-gratis/acercamiento-al-medico-veterinario-cuidando-mascota_23-2149267934.jpg?semt=ais_hybrid&w=740&q=80" class="img-fluid rounded-start h-100" style="object-fit: cover; width: 100%; min-height: 120px; object-position: center;" alt="imagenreferencialconsulta">
                                        </div>
                                        <div class="col-md-6 d-flex align-items-center">
                                            <div class="card-body">
                                                <h5 class="card-title subtitulo-vet2">Consultas</h5>
                                                <p class="card-text text-muted">Revisión general sin costo para todas las mascotas.</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>

                <div class="tarjetas-opciones-vet mt-5">
                    <h2 class="text-start titulo-vet fs-3 mb-4" style="color: #333 !important;">Módulos Principales:</h2>
                    <div class="tarjeta mb-5">
                        <div class="row row-cols-1 row-cols-md-3 g-4">

                            <!-- TARJETA 1: AGENDAR CITA -->
                            <div class="col">
                                <a href="controladorpagina?pagina=agendarcitas" class="card-modulo-link">
                                    <div class="card card-modulo h-100">
                                        <div class="card-body d-flex flex-column align-items-center text-center">
                                            <div class="icono-contenedor icono-naranja">
                                                <i class="fa-solid fa-calendar-plus"></i>
                                            </div>
                                            <h5 class="card-title subtitulo-vet1">Agendar Cita</h5>
                                            <p class="card-text text-muted">Programa una visita para tu mascota.</p>
                                        </div>
                                    </div>
                                </a>
                            </div>

                            <!-- TARJETA 2: MIS CITAS -->
                            <div class="col">
                                <a href="controladorpagina?pagina=miscitas" class="card-modulo-link">
                                    <div class="card card-modulo h-100">
                                        <div class="card-body d-flex flex-column align-items-center text-center">
                                            <div class="icono-contenedor icono-verde">
                                                <i class="fa-solid fa-calendar-days"></i>
                                            </div>
                                            <h5 class="card-title subtitulo-vet1">Mis Citas</h5>
                                            <p class="card-text text-muted">Ver tu historial y citas próximas.</p>
                                        </div>
                                    </div>
                                </a>
                            </div>

                            <!-- TARJETA 3: MI PERFIL -->
                            <div class="col">
                                <a href="controladorpagina?pagina=miperfil" class="card-modulo-link">
                                    <div class="card card-modulo h-100">
                                        <div class="card-body d-flex flex-column align-items-center text-center">
                                            <div class="icono-contenedor icono-dorado">
                                                <i class="fa-solid fa-user"></i>
                                            </div>
                                            <h5 class="card-title subtitulo-vet1">Mi Perfil</h5>
                                            <p class="card-text text-muted">Gestiona la información de tu perfil</p>
                                        </div>
                                    </div>
                                </a>
                            </div>

                        </div>
                    </div>
                </div>
                <div class="tarjeta-horario-vet mt-5">
                    <h2 class="text-start titulo-vet fs-3 mb-4" style="color: #333 !important;">Agenda del Médico Veterinario:</h2>
                </div>    
                        
                <div class="tarjeta-final-vet mt-5 mb-5">
                    <div class="card border-0 rounded-4 shadow-sm p-4" style="background-color: #FFFFFF; border-radius: 25px !important;">
                        <div class="row align-items-center justify-content-between g-3">
                            
                            <div class="col-12 col-md-3 d-flex align-items-center justify-content-center justify-content-md-start border-end-md">
                                <div class="me-3 fs-1" style="color: #c0392b;">
                                    <i class="fa-regular fa-calendar-check"></i>
                                </div>
                                <div>
                                    <h6 class="mb-1 fw-bold" style="color: #1e7e34;">Cita próxima:</h6>
                                    <p class="mb-0 fw-bold text-dark">12/05 - 10:00 A</p>
                                </div>
                            </div>

                            <div class="col-12 col-md-1 d-flex justify-content-center">
                                <span class="fs-2" style="color: #d35400;">
                                    <i class="fa-regular fa-heart"></i>
                                </span>
                            </div>

                            <div class="col-12 col-md-4">
                                <h6 class="mb-2 fw-bold text-center text-md-start" style="color: #1e7e34;">Horario habitual:</h6>
                                <p class="mb-1 small fw-bold text-dark text-center text-md-start">
                                    Lunes a Sabado de 9:00 a.m. - 17:00 p.m.
                                </p>
                                <p class="mb-0 small fw-bold text-dark text-center text-md-start">
                                    Domingo de 9:00 a.m. - 14:00 p.m.
                                </p>
                            </div>

                            <div class="col-12 col-md-4 border-start-md ps-md-4">
                                <h6 class="mb-1 fw-bold text-center text-md-start" style="color: #1e7e34;">Nota:</h6>
                                <p class="mb-0 small text-dark text-center text-md-start" style="line-height: 1.3;">
                                    Estimad@ <span class="fw-bold" style="color: #d35400;">${sessionScope.nombrecompleto}</span>, recuerde asistir con puntualidad a sus citas
                                </p>
                            </div>

                        </div>
                    </div>
                </div>        

            </div>        

        </main>
        <!-- Bootstrap y alertify -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="//cdn.jsdelivr.net/npm/alertifyjs@1.13.1/build/alertify.min.js"></script>
        <jsp:include page="/componentes/mensajes.jsp" /> 
        <jsp:include page="/componentes/personalizar.jsp" /> 

    </body>
</html>
