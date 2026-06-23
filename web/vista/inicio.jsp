
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="modelo.citas"%>

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.DayOfWeek" %>
<%
    citas proxima =(citas) request.getAttribute("proximaCita");
%>
<!-- rango d semana 15-06-26 -->
<%@ page import="java.time.LocalDate" %>

<%
    LocalDate inicioSemana = (LocalDate) request.getAttribute("inicioSemana");
    LocalDate finSemana = (LocalDate) request.getAttribute("finSemana");
    LocalDate semanaAnterior  = inicioSemana.minusWeeks(1);
    LocalDate semanaSiguiente = inicioSemana.plusWeeks(1);
%>

<%
    java.time.LocalDate lunes = inicioSemana;
%>
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
        <link rel="stylesheet" href="${pageContext.request.contextPath}/estilos/esbusqueda.css">
    </head>
    <body>       
        <%
            request.setAttribute("paginaActual", "inicio");
        %>
        <jsp:include page="../componentes/encabezado.jsp" />
        <main class="container mt-5 pt-4 contenido-cli" style="margin-top: 180px; margin-bottom: 50px;">
            <div class="container-fluid">
                <div class="bien-mensaje-vet">
                    <h1 class="text-start titulo-vet fs-2 mb-2" style="color: #333;">¡Hola, 
                        <span style="color: #336600;">${sessionScope.nombrecompleto}</span>! 
                        <span><i class="fa-solid fa-hand mano-animada"></i></span>
                    </h1>
                    <p class="text-muted mb-4">¿Cómo podemos ayudar a tu mascota hoy?</p>
                </div>
                        
                <div class="buscarmas-vet">
                    <form class="mb-4" id="formBuscarMascota">
                        <div class="input-group buscador-mascota">
                            <span class="input-group-text">
                                <i class="fa-solid fa-magnifying-glass"></i>
                            </span>

                            <input
                                class="form-control"
                                id="txtBuscarMascota"
                                type="search"
                                placeholder="Buscar mascota por nombre..."
                            >

                            <button class="btn btn-buscar-mascota" type="submit">
                                Buscar
                            </button>
                        </div>
                    </form>
                </div>
                <div id="resultados" class="tarjetas-busqueda-vet mt-5" style="display:none;">
                    <div class="row row-cols-1 row-cols-md-3 g-4" id="contenedorResultados">
                    </div>
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
                
                <div class="historialcitas-vet mt-5 mb-5">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2 class="titulo-vet fs-3 mb-0" style="color: #333 !important;">Historial de Citas Recientes:</h2>
                        <a href="controladorpagina?pagina=miscitas" class="text-decoration-none fw-bold" style="color: #336600;">
                            Ver más <i class="fa-solid fa-arrow-right ms-1"></i>
                        </a>
                    </div>

                    <div class="d-flex flex-wrap gap-4 align-items-center">
                        <!-- commentario -->
                        <c:forEach var="cita" items="${historialCitas}">
                            <div class="card shadow-sm p-3"
                            style="
                            width:190px;
                            border-radius:15px;
                            <c:choose>
                                <c:when test='${cita.estado eq "PENDIENTE"}'>
                                    border:2px solid #EBB12C;
                                </c:when>
                                <c:when test='${cita.estado eq "CONFIRMADA"}'>
                                    border:2px solid #91C3F0;
                                </c:when>
                                <c:when test='${cita.estado eq "ATENDIDA"}'>
                                    border:2px solid #71C87B;
                                </c:when>
                                <c:when test='${cita.estado eq "CANCELADA"}'>
                                    border:2px solid #A0A0A0;
                                </c:when>
                            </c:choose>">

                                <h6 class="fw-bold text-success">
                                    ${cita.mascota}
                                </h6>

                                <small class="text-muted">
                                    ${cita.fecha}
                                </small>

                                <small class="text-muted d-block">
                                    ${cita.hora}
                                </small>

                                <span class="badge mt-2 px-3 py-2"
                                    style="
                                    <c:choose>
                                        <c:when test='${cita.estado eq "PENDIENTE"}'>
                                            background:#FCEFCE;color:#EBB12C;
                                        </c:when>
                                        <c:when test='${cita.estado eq "CONFIRMADA"}'>
                                            background:#E1EFFB;color:#91C3F0;
                                        </c:when>
                                        <c:when test='${cita.estado eq "ATENDIDA"}'>
                                            background:#E2F4E4;color:#71C87B;
                                        </c:when>
                                        <c:when test='${cita.estado eq "CANCELADA"}'>
                                            background:#EAEAEA;color:#A0A0A0;
                                        </c:when>
                                        <c:otherwise>
                                            background:#F8F9FA;color:#6C757D;
                                        </c:otherwise>
                                    </c:choose>
                                    font-weight:600;border-radius:20px;">
                                  ${cita.estado}
                              </span>

                            </div>
                        </c:forEach>

                        <c:if test="${empty historialCitas}">
                            <p class="text-muted small italic m-0"><i class="fa-solid fa-info-circle me-1"></i> Aún no tienes historial de citas .</p>
                        </c:if>
                    </div>
                </div>        
                <div class="mis-mascotas-vet mt-5 mb-5">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2 class="titulo-vet fs-3 mb-0" style="color: #333 !important;">Mis Mascotas:</h2>
                        <a href="controladorpagina?pagina=miperfil" class="text-decoration-none fw-bold" style="color: #336600;">
                            Ver más <i class="fa-solid fa-arrow-right ms-1"></i>
                        </a>
                    </div>

                    <div class="d-flex flex-wrap gap-4 align-items-center">
                        <c:forEach var="mascota" items="${misMascotas}" end="6">
                            <div class="text-center" style="width: 130px;">
                                <div class="avatar-mascota mx-auto shadow-sm">
                                    <img src="${pageContext.request.contextPath}/recursos/icon.png" class="img-avatar-mascota" alt="Mascota"/>
                                </div>
                                <p class="mt-2 mb-0 fw-bold text-dark text-truncate text-capitalize">${mascota.nombre}</p>
                            </div>
                        </c:forEach>

                        <c:if test="${empty misMascotas}">
                            <p class="text-muted small italic m-0"><i class="fa-solid fa-info-circle me-1"></i> Aún no tienes mascotas registradas en tu perfil.</p>
                        </c:if>
                    </div>
                </div>
                <div class="tarjeta-final-vet mt-5 mb-5">
                    <h2 class="text-start titulo-vet fs-3 mb-4" style="color: #333 !important;">Recuerde:</h2>
                    <div class="card border-0 rounded-4 shadow-sm p-4" style="background-color: #FFFFFF; border-radius: 25px !important;">
                        <div class="row align-items-center justify-content-between g-3">
                            
                            <div class="col-12 col-md-3 d-flex align-items-center justify-content-center justify-content-md-start border-end-md">
                                <div class="me-3 fs-1" style="color: #c0392b;">
                                    <i class="fa-regular fa-calendar-check"></i>
                                </div>
                                <div>
                                    <h6 class="mb-1 fw-bold" style="color: #1e7e34;">Cita próxima:</h6>
                                    <p class="mb-0 fw-bold text-dark"><%
                                        if(proxima != null){
                                        %>

                                        <%= proxima.getMascota() %><br>
                                        <%= proxima.getFecha() %> - <%= proxima.getHora() %>

                                        <%
                                        }else{
                                        %>

                                        No tiene citas programadas

                                        <%
                                        }
                                        %>
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
            <div id="datosMascotas" style="display:none;">
                <c:forEach var="mascota" items="${misMascotas}">
                    <div class="mascota-data"
                         data-id="${mascota.idMascota}"
                         data-nombre="${mascota.nombre}"
                         data-especie="${mascota.especie}"
                         data-raza="${mascota.raza}"
                         data-sexo="${mascota.sexo}">
                    </div>
                </c:forEach>
            </div>  
                                
        </main>
        <!-- Bootstrap y alertify -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="//cdn.jsdelivr.net/npm/alertifyjs@1.13.1/build/alertify.min.js"></script>
        <jsp:include page="/componentes/pie.jsp"/>
        <script>
            document.addEventListener("DOMContentLoaded",()=>{
            document.querySelectorAll(".cita-click")
            .forEach(cita=>{
            cita.addEventListener("click",()=>{
                document.getElementById("mMascota")
                        .innerText=
                        cita.dataset.mascota;
                document.getElementById("mFecha")
                        .innerText=
                        cita.dataset.fecha;
                document.getElementById("mHora")
                        .innerText=
                        cita.dataset.hora;
                document.getElementById("mTipo")
                        .innerText=
                        cita.dataset.tipo;
                document.getElementById("mEstado")
                        .innerText=
                        cita.dataset.estado;
                document.getElementById("mMotivo")
                        .innerText=
                        cita.dataset.motivo;
                new bootstrap.Modal(
                    document.getElementById("modalCita")
                ).show();
            });
            });
            });
        </script>
        
        <script>
            document.addEventListener("DOMContentLoaded", () => {
                const botones = document.querySelectorAll(".btn-filtro");
                botones.forEach(btn => {
                    btn.addEventListener("click", () => {
                        // Quitar activo de todos
                        botones.forEach(b =>
                            b.classList.remove("active")
                        );
                        // Activar botón seleccionado
                        btn.classList.add("active");
                        const estado = btn.dataset.estado;
                        document
                            .querySelectorAll(".cita-click")
                            .forEach(cita => {
                                if (
                                    estado === "TODAS" ||
                                    cita.dataset.estadofiltro === estado
                                ) {
                                    cita.style.display = "flex";
                                } else {
                                    cita.style.display = "none";
                                }
                            });
                    });
                });
            });
        </script>
        <script>
        document.addEventListener("DOMContentLoaded", () => {

            const form = document.getElementById("formBuscarMascota");
            const txtBuscar = document.getElementById("txtBuscarMascota");
            const contenedor = document.getElementById("contenedorResultados");
            const resultados = document.getElementById("resultados");

            form.addEventListener("submit", function(e) {

                e.preventDefault();

                const termino = txtBuscar.value.trim().toLowerCase();

                contenedor.innerHTML = "";

                if (termino === "") {
                    resultados.style.display = "none";
                    return;
                }

                const mascotas = document.querySelectorAll(".mascota-data");

                let encontrados = 0;

                mascotas.forEach(m => {

                    const nombre = (m.dataset.nombre || "").toLowerCase();

                    if (nombre.includes(termino)) {

                        encontrados++;

                        const sexoTexto =
                            m.dataset.sexo === "M"
                                ? "Macho"
                                : m.dataset.sexo === "F"
                                    ? "Hembra"
                                    : m.dataset.sexo;

                        contenedor.innerHTML +=
                            '<div class="col">' +
                                '<div class="card tarjeta-mascota-buscada border-0">' +

                                    '<div class="card-body">' +

                                        '<div class="d-flex align-items-center mb-3">' +

                                            '<div class="avatar-busqueda">' +
                                                '<i class="fa-solid fa-paw"></i>' +
                                            '</div>' +

                                            '<div class="ms-3">' +
                                                '<h5 class="mb-0 mascota-nombre">' +
                                                    m.dataset.nombre +
                                                '</h5>' +

                                                '<small class="text-muted">' +
                                                    'Mascota registrada' +
                                                '</small>' +
                                            '</div>' +

                                        '</div>' +

                                        '<div class="datos-mascota">' +

                                            '<p>' +
                                                '<i class="fa-solid fa-dog"></i>' +
                                                '<strong> Especie:</strong> ' +
                                                (m.dataset.especie || 'No registrada') +
                                            '</p>' +

                                            '<p>' +
                                                '<i class="fa-solid fa-paw"></i>' +
                                                '<strong> Raza:</strong> ' +
                                                (m.dataset.raza || 'No registrada') +
                                            '</p>' +

                                            '<p>' +
                                                '<i class="fa-solid fa-venus-mars"></i>' +
                                                '<strong> Sexo:</strong> ' +
                                                sexoTexto +
                                            '</p>' +

                                        '</div>' +

                                        '<a href="controladorpagina?pagina=miperfil" ' +
                                           'class="btn btn-ver-mascota">' +
                                            'Ver más ' +
                                            '<i class="fa-solid fa-arrow-right ms-1"></i>' +
                                        '</a>' +

                                    '</div>' +

                                '</div>' +
                            '</div>';
                    }
                });

                if (encontrados === 0) {

                    contenedor.innerHTML =
                        '<div class="col-12">' +
                            '<div class="alert alert-warning text-center">' +
                                '<i class="fa-solid fa-circle-exclamation"></i> ' +
                                'No se encontró ninguna mascota con ese nombre.' +
                            '</div>' +
                        '</div>';
                }

                resultados.style.display = "block";
            });

        });
        </script>
        <jsp:include page="/componentes/mensajes.jsp" /> 
        <jsp:include page="/componentes/personalizar.jsp" /> 

    </body>
</html>
