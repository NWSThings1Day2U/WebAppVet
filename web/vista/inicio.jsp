
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
                        LocalDate inicioSemana
                                = (LocalDate) request.getAttribute("inicioSemana");
                        LocalDate finSemana
                                = (LocalDate) request.getAttribute("finSemana");
                        LocalDate semanaAnterior
                                = inicioSemana.minusWeeks(1);
                        LocalDate semanaSiguiente
                                = inicioSemana.plusWeeks(1);
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
                    <h2 class="text-start titulo-vet fs-3 mb-4" style="color: #333 !important;">
                        Agenda del Médico Veterinario:</h2>         
                </div>    
                    <!-- calendar vis 11-06-26 -->
                    
                    <div class="agenda-veterinario">

                        <div class="agenda-header">
                            <a class="btn-nav"
                               href="controladorpagina?pagina=inicio&semana=<%= semanaAnterior%>">
                                <i class="fa-solid fa-arrow-left"></i>
                            </a>
                            <span>
                                Semana:
                                <%= inicioSemana%>
                                al
                                <%= finSemana%>
                            </span>
                            <a class="btn-nav"
                               href="controladorpagina?pagina=inicio&semana=<%= semanaSiguiente%>">
                                <i class="fa-solid fa-arrow-right"></i>
                            </a>
                        </div>
                                
                           <div class="row g-4 mb-4">
                               <div class="col-md-3">
                                   <div class="card card-resumen">
                                       <i class="fa-solid fa-calendar-days resumen-icon"></i>
                                       <h2>${totalSemana}</h2>
                                       <span>Citas Semana</span>
                                   </div>
                               </div>
                               <div class="col-md-3">
                                   <div class="card card-resumen card-confirmada">
                                       <i class="fa-solid fa-circle-check resumen-icon"></i>
                                       <h2>${totalConfirmadas}</h2>
                                       <span>Confirmadas</span>
                                   </div>
                               </div>
                               <div class="col-md-3">
                                   <div class="card card-resumen card-pendiente">
                                       <i class="fa-solid fa-clock resumen-icon"></i>
                                       <h2>${totalPendientes}</h2>
                                       <span>Pendientes</span>
                                   </div>
                               </div>
                               <div class="col-md-3">
                                   <div class="card card-resumen card-atendida">
                                       <i class="fa-solid fa-stethoscope resumen-icon"></i>
                                       <h2>${totalAtendidas}</h2>
                                       <span>Atendidas</span>
                                   </div>
                               </div>
                           </div>

                           <div class="agenda-filtros">
                               <button class="btn-filtro active"
                                       data-estado="TODAS">
                                   Todas
                               </button>
                               <button class="btn-filtro"
                                       data-estado="PENDIENTE">
                                   Pendientes
                               </button>
                               <button class="btn-filtro"
                                       data-estado="CONFIRMADA">
                                   Confirmadas
                               </button>
                               <button class="btn-filtro"
                                       data-estado="ATENDIDA">
                                   Atendidas
                               </button>
                               <button class="btn-filtro"
                                       data-estado="CANCELADA">
                                   Canceladas
                               </button>
                           </div>                                               
                                
                           <%
                               java.util.List<String> horas = new java.util.ArrayList<>();
                               for (int h = 9; h <= 17; h++) {
                                   horas.add(String.format("%02d:00", h));
                                   if (h < 17) {
                                       horas.add(String.format("%02d:30", h));
                                   }
                               }
                               request.setAttribute("horasAgenda", horas);
                           %>                                                                                            
                           
                        <div class="agenda-scroll">   
                           
                        <table class="tabla-agenda">
                            <thead>
                                <tr>
                                    <th>Hora</th>
                                    <th>Lunes</th>
                                    <th>Martes</th>
                                    <th>Miércoles</th>
                                    <th>Jueves</th>
                                    <th>Viernes</th>
                                    <th>Sábado</th>
                                    <th>Domingo</th>
                                </tr>
                            </thead>
                            
            <tbody>
                <c:forEach var="hora" items="${horasAgenda}">
                    <tr>
                        <td>${hora}</td>
                        <%
                            for (int d = 0; d < 7; d++) {
                                java.time.LocalDate fechaColumna
                                        = lunes.plusDays(d);
                                request.setAttribute(
                                        "fechaColumna",
                                        fechaColumna.toString()
                                );
                        %>
                        <td>
                            <c:forEach var="cita" items="${agendaSemana}">
                                <c:if test="${cita.fecha eq fechaColumna
                                  && fn:startsWith(cita.hora,hora)}">
                                    <c:set var="claseEstado" value="cita-pendiente"/>
                                    <c:choose>
                                        <c:when test="${cita.estado=='PENDIENTE'}">
                                            <c:set var="claseEstado"
                                                   value="cita-pendiente"/>
                                        </c:when>
                                        <c:when test="${cita.estado=='CONFIRMADA'}">
                                            <c:set var="claseEstado"
                                                   value="cita-confirmada"/>
                                        </c:when>
                                        <c:when test="${cita.estado=='ATENDIDA'}">
                                            <c:set var="claseEstado"
                                                   value="cita-atendida"/>
                                        </c:when>
                                        <c:otherwise>
                                            <c:set var="claseEstado"
                                                   value="cita-cancelada"/>
                                        </c:otherwise>
                                    </c:choose>
                                    <div class="${claseEstado} cita-click" 
                                         data-fecha="${cita.fecha}"
                                         data-hora="${cita.hora}"
                                         data-mascota="${cita.mascota}"
                                         data-tipo="${cita.tipoAtencion}"
                                         data-estado="${cita.estado}"
                                         data-motivo="${cita.motivo}"
                                         data-estadofiltro="${cita.estado}">

                                        <strong>${cita.hora}</strong>

                                        <span class="nombre-mascota">
                                            ${cita.mascota}
                                        </span>
                                        
                                    </div>
                                </c:if>
                            </c:forEach>
                        </td>
                        <%
                            }
                        %>
                    </tr>
                </c:forEach>
                            </tbody>
                                
                            </table>
                        </div> 
                           
                   <div class="modal fade"
                        id="modalCita"
                        tabindex="-1">
                       <div class="modal-dialog">
                           <div class="modal-content">
                               <div class="modal-header">
                                   <h5 class="modal-title">
                                       Detalle de la cita
                                   </h5>
                                   <button
                                       type="button"
                                       class="btn-close"
                                       data-bs-dismiss="modal">
                                   </button>
                               </div>
                               <div class="modal-body">
                                   <p>
                                       <strong>Mascota:</strong>
                                       <span id="mMascota"></span>
                                   </p>
                                   <p>
                                       <strong>Fecha:</strong>
                                       <span id="mFecha"></span>
                                   </p>
                                   <p>
                                       <strong>Hora:</strong>
                                       <span id="mHora"></span>
                                   </p>
                                   <p>
                                       <strong>Tipo:</strong>
                                       <span id="mTipo"></span>
                                   </p>
                                   <p>
                                       <strong>Estado:</strong>
                                       <span id="mEstado"></span>
                                   </p>
                                   <p>
                                       <strong>Motivo:</strong>
                                       <span id="mMotivo"></span>
                                   </p>
                               </div>
                           </div>
                       </div>
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

        </main>
        <!-- Bootstrap y alertify -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="//cdn.jsdelivr.net/npm/alertifyjs@1.13.1/build/alertify.min.js"></script>
        
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
        
        <jsp:include page="/componentes/mensajes.jsp" /> 
        <jsp:include page="/componentes/personalizar.jsp" /> 

    </body>
</html>
