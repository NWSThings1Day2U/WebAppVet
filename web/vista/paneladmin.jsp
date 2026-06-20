
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="modelo.citas" %>
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
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Panel Administrador</title>
        <!-- Bootstrap -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font de google -->
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Vollkorn:ital,wght@0,400..900;1,400..900&display=swap" rel="stylesheet">     <!-- Iconos -->
        <!-- Icon -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
        <link rel="icon" href="recursos/logoveet.png">
        <!-- Alertify -->
        <link rel="stylesheet" href="//cdn.jsdelivr.net/npm/alertifyjs@1.13.1/build/css/alertify.min.css"/>
        <link rel="stylesheet" href="//cdn.jsdelivr.net/npm/alertifyjs@1.13.1/build/css/themes/default.min.css"/>


        <!-- CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/estilos/contenidoadmin.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/estilos/dashboardadmin.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/estilos/esadmin.css">

    </head>
    <body>
        <%
            request.setAttribute("paginaActual", "inicio");
        %>
        <jsp:include page="../componentes/encabezado.jsp" />
        <main class="container mt-5 pt-4 contenido-admin" style="margin-top: 180px; margin-bottom: 150px;"> 
            <!-- bienvenida -->
            <div class="card-bienvenida mb-4">
                <div class="row align-items-center">
                    <div class="col-lg-8">
                        <h2 class="fw-bold">
                            Panel Administrativo

                        </h2>
                        <p class="text-muted mb-0">
                            ¡Hola,
                            <span class="text-success fw-bold">
                                ${sessionScope.usuario}!
                            </span>¿Qué deseas hacer hoy?
                        </p>
                    </div>
                    <div class="col-lg-4 text-lg-end mt-3 mt-lg-0 mb-4">
                        <div class="fecha-box">
                            <i class="fa-solid fa-chart-bar"></i>
                            <span id="fechaHora"></span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="Dashboard-vet">

                <div class="row g-4 mb-4">
                    <div class="col-xl-3 col-sm-6">
                        <div class="card-dashboard">
                            <div>
                                <h6>Total Citas - Mes</h6>
                                <h2>${totalCitas}</h2>
                            </div>
                            <i class="fa-solid fa-calendar-check icon-card text-success"></i>
                        </div>
                    </div>
                    <div class="col-xl-3 col-sm-6">
                        <div class="card-dashboard">
                            <div>
                                <h6>Clientes</h6>
                                <h2>${totalClientes}</h2>
                            </div>
                            <i class="fa-solid fa-users icon-card text-primary"></i>
                        </div>
                    </div>
                    <div class="col-xl-3 col-sm-6">
                        <div class="card-dashboard">
                            <div>
                                <h6>Mascotas</h6>
                                <h2>${totalMascotas}</h2>
                            </div>
                            <i class="fa-solid fa-dog icon-card text-warning"></i>
                        </div>
                    </div>
                    <div class="col-xl-3 col-sm-6">
                        <div class="card-dashboard">
                            <div>
                                <h6>Ventas</h6>
                                <h2>S/ ${ingresos}</h2>
                            </div>
                            <i class="fa-solid fa-cart-shopping icon-card text-danger"></i>
                        </div>
                    </div>
                </div>

                <div class="row g-4 mb-4">
                    <div class="col-xl-4 col-md-6">
                        <div class="tabla-panel">
                            <h5 class="fw-bold mb-4">Ingresos Semanales</h5>
                            <div class="chart-container">
                                <canvas id="graficoVentas"></canvas>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-4 col-md-6">
                        <div class="tabla-panel">
                            <h5 class="fw-bold mb-4">Ingresos Mensuales</h5>
                            <div class="chart-container">
                                <canvas id="graficoAnual"></canvas>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-4 col-md-12">
                        <div class="tabla-panel">
                            <h5 class="fw-bold mb-4">Citas por Día</h5>
                            <div class="chart-container">
                                <canvas id="graficoCitas"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="row g-4 mb-4">
                    <div class="col-xl-7 col-lg-12">
                        <div class="tabla-panel">
                            <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
                                <h5 class="fw-bold mb-0">Citas Próximas</h5>
                                <a href="controladorcitas?accion=listar" class="btn btn-success btn-sm">
                                    <i class="fa-solid fa-eye"></i> Ver Todas
                                </a>
                            </div>
                            <div class="table-responsive">
                                <table class="table table-hover align-middle">
                                    <thead class="table-light">
                                        <tr>
                                            <th>Cliente</th>
                                            <th>Mascota</th>
                                            <th>Fecha</th>
                                            <th>Hora</th>
                                            <th>Estado</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${proximasCitas}" var="c">
                                            <tr>
                                                <td>${c.cliente}</td>
                                                <td>${c.mascota}</td>
                                                <td>${c.fecha}</td>
                                                <td>${c.hora}</td>
                                                <td>
                                                    <c:choose>
                                                    <c:when test="${c.estado == 'PENDIENTE'}">
                                                        <span class="badge bg-warning text-dark">
                                                            Pendiente
                                                        </span>
                                                    </c:when>

                                                    <c:when test="${c.estado == 'CONFIRMADA'}">
                                                        <span class="badge bg-primary">
                                                            Confirmada
                                                        </span>
                                                    </c:when>

                                                    <c:when test="${c.estado == 'ATENDIDA'}">
                                                        <span class="badge bg-success">
                                                            Atendida
                                                        </span>
                                                    </c:when>

                                                    <c:when test="${c.estado == 'CANCELADA'}">
                                                        <span class="badge bg-danger">
                                                            Cancelada
                                                        </span>
                                                    </c:when>

                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">
                                                            ${c.estado}
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-5 col-lg-12">
                        <div class="tabla-panel">
                            <h5 class="fw-bold mb-3">Últimas Ventas</h5>
                            <div class="table-responsive">
                                <table class="table table-hover align-middle">
                                    <thead>
                                        <tr>
                                            <th>Cliente</th>
                                            <th>Fecha</th>
                                            <th>Total</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${ultimasVentas}" var="v">
                                            <tr>
                                                <td>${v.cliente}</td>
                                                <td>${v.fecha}</td>
                                                <td><span class="fw-bold text-dark">S/ ${v.total}</span></td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row g-4 mb-4">
                    <div class="col-xl-4 col-md-6">
                        <div class="tabla-panel">
                            <h5 class="fw-bold mb-3">Productos Más Vendidos</h5>
                            <table class="table table-sm align-middle">
                                <thead>
                                    <tr>
                                        <th>Producto</th>
                                        <th>Vendidos</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${topProductos}" var="p">
                                        <tr>
                                            <td>${p[0]}</td>
                                            <td><span class="badge bg-primary">${p[1]}</span></td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="col-xl-4 col-md-6">
                        <div class="tabla-panel">
                            <h5 class="fw-bold mb-3">Servicios Más Solicitados</h5>
                            <table class="table table-sm align-middle">
                                <thead>
                                    <tr>
                                        <th>Servicio</th>
                                        <th>Cantidad</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${serviciosTop}" var="s">
                                        <tr>
                                            <td>${s[0]}</td>
                                            <td><span class="badge bg-info text-dark">${s[1]}</span></td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="col-xl-4 col-md-12">
                        <div class="d-flex flex-column gap-4 h-100">
                            <div class="card-dashboard py-3">
                                <div>
                                    <h6>Crecimiento Global</h6>
                                    <h2 class="text-success">
                                        <fmt:formatNumber value="${crecimiento}" maxFractionDigits="1"/>%
                                    </h2>
                                </div>
                                <i class="fa-solid fa-chart-line icon-card text-success"></i>
                            </div>

                            <div class="tabla-panel flex-grow-1">
                                <h5 class="fw-bold mb-3">Mejores Clientes</h5>
                                <table class="table table-sm align-middle">
                                    <thead>
                                        <tr>
                                            <th>Cliente</th>
                                            <th>Compras</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${topClientes}" var="c">
                                            <tr>
                                                <td>${c[0]}</td>
                                                <td><span class="fw-bold text-success">${c[1]}</span></td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row g-4">
                    <div class="col-xl-4 col-lg-12">
                        <div class="tabla-panel">
                            <h5 class="fw-bold mb-4">Resumen del Mes</h5>
                            <div class="table-responsive">
                                <table class="table table-bordered align-middle">
                                    <tbody>
                                        <tr>
                                            <th class="table-light">Ingresos Mes</th>
                                            <td class="fw-bold text-success">S/ ${ingresosMes}</td>
                                        </tr>
                                        <tr>
                                            <th class="table-light">Clientes Nuevos</th>
                                            <td>${clientesNuevos}</td>
                                        </tr>
                                        <tr>
                                            <th class="table-light">Mascotas Registradas</th>
                                            <td>${mascotasRegistradas}</td>
                                        </tr>
                                        <tr>
                                            <th class="table-light">Ventas Totales</th>
                                            <td>${totalVentas}</td>
                                        </tr>
                                        <tr>
                                            <th class="table-light">Productos Vendidos</th>
                                            <td>${productosVendidos}</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-4 col-md-6">
                        <div class="tabla-panel">
                            <h5 class="fw-bold text-danger mb-3">
                                <i class="fa-solid fa-triangle-exclamation me-1"></i> Stock Crítico
                            </h5>
                            <table class="table table-sm align-middle">
                                <thead>
                                    <tr>
                                        <th>Producto</th>
                                        <th>Stock</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${productosCriticos}" var="p">
                                        <tr>
                                            <td>${p.nombre}</td>
                                            <td><span class="badge bg-danger">${p.stock}</span></td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="col-xl-4 col-md-6">
                        <div class="tabla-panel">
                            <h5 class="fw-bold text-warning mb-3">
                                <i class="fa-solid fa-hourglass-half me-1"></i> Próximos a Vencer
                            </h5>
                            <table class="table table-sm align-middle">
                                <thead>
                                    <tr>
                                        <th>Producto</th>
                                        <th>Vence</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${productosPorVencer}" var="p">
                                        <tr>
                                            <td>${p.nombre}</td>
                                            <td><span class="text-muted">${p.fechaVencimiento}</span></td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="row g-4 mb-2">
                                <div class="tarjeta-horario-vet mt-5">
                    <h2 class="text-start titulo-vet fs-3 mb-4 mt-5" style="color: #333 !important;">
                        Agenda del Médico Veterinario:</h2>    
                    <!-- calendar vis 11-06-26 -->
                    
                    <div class="agenda-veterinario " >

                        <div class="agenda-header">
                            <a class="btn-nav"
                               href="controladorseccion?seccion=inicio&semana=<%= semanaAnterior%>">
                                <i class="fa-solid fa-arrow-left"></i>
                            </a>
                            <span>
                                Semana:
                                <%= inicioSemana%>
                                al
                                <%= finSemana%>
                            </span>
                            <a class="btn-nav"
                               href="controladorseccion?seccion=inicio&semana=<%= semanaSiguiente%>">
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
                    
                </div>    
                    
                </div>                        
            </div> 


        </main>
        <!-- Bootstrap y alertify -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="//cdn.jsdelivr.net/npm/alertifyjs@1.13.1/build/alertify.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>       

        <script>
            const ventasSemana = ${ventasSemana};
            const citasSemana = ${citasSemana};
            const ingresosAnuales = ${ingresos12Meses};

            Chart.defaults.font.family = "'Segoe UI', 'Roboto', 'Helvetica Neue', sans-serif";
            Chart.defaults.color = '#6c757d';

            /* GRÁFICO VENTAS (Semanales) */
            const ctxVentas = document.getElementById('graficoVentas').getContext('2d');
            const gradienteVerde = ctxVentas.createLinearGradient(0, 0, 0, 300);
            gradienteVerde.addColorStop(0, 'rgba(25, 135, 84, 0.85)');
            gradienteVerde.addColorStop(1, 'rgba(25, 135, 84, 0.1)');

            new Chart(ctxVentas, {
                type: 'bar',
                data: {
                    labels: ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'],
                    datasets: [{
                            label: 'Ventas (S/.)',
                            data: ventasSemana,
                            backgroundColor: gradienteVerde,
                            borderColor: '#198754',
                            borderWidth: 2,
                            borderRadius: 6,
                            borderSkipped: false
                        }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {display: false}
                    },
                    scales: {
                        x: {grid: {display: false}},
                        y: {
                            beginAtZero: true,
                            grid: {color: 'rgba(0, 0, 0, 0.05)'}
                        }
                    }
                }
            });

            /* GRÁFICO ANUAL (Mensuales) */
            const ctxAnual = document.getElementById('graficoAnual').getContext('2d');
            const gradienteAzul = ctxAnual.createLinearGradient(0, 0, 0, 300);
            gradienteAzul.addColorStop(0, 'rgba(13, 110, 253, 0.85)');
            gradienteAzul.addColorStop(1, 'rgba(13, 110, 253, 0.1)');

            new Chart(ctxAnual, {
                type: 'bar',
                data: {
                    labels: ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'],
                    datasets: [{
                            label: 'Ingresos',
                            data: ingresosAnuales,
                            backgroundColor: gradienteAzul,
                            borderColor: '#0d6efd',
                            borderWidth: 2,
                            borderRadius: 6,
                            borderSkipped: false
                        }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {legend: {display: false}},
                    scales: {
                        x: {grid: {display: false}},
                        y: {
                            beginAtZero: true,
                            grid: {color: 'rgba(0, 0, 0, 0.05)'}
                        }
                    }
                }
            });

            /* GRÁFICO CITAS */
            const ctxCitas = document.getElementById('graficoCitas').getContext('2d');
            const gradienteCitas = ctxCitas.createLinearGradient(0, 0, 0, 300);
            gradienteCitas.addColorStop(0, 'rgba(25, 135, 84, 0.3)');
            gradienteCitas.addColorStop(1, 'rgba(25, 135, 84, 0.0)');

            new Chart(ctxCitas, {
                type: 'line',
                data: {
                    labels: ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'],
                    datasets: [{
                            label: 'Citas',
                            data: citasSemana,
                            borderColor: '#198754',
                            backgroundColor: gradienteCitas,
                            borderWidth: 3,
                            pointBackgroundColor: '#198754',
                            pointBorderColor: '#fff',
                            pointBorderWidth: 2,
                            pointRadius: 4,
                            pointHoverRadius: 6,
                            tension: 0.35,
                            fill: true
                        }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {legend: {display: false}},
                    scales: {
                        x: {grid: {display: false}},
                        y: {
                            beginAtZero: true,
                            ticks: {precision: 0},
                            grid: {color: 'rgba(0, 0, 0, 0.05)'}
                        }
                    }
                }
            });
        </script>

        <script>
            /* FECHA Y HORA */
            function actualizarFechaHora() {
                const ahora = new Date();
                const opciones = {
                    weekday: 'long',
                    year: 'numeric',
                    month: 'long',
                    day: 'numeric'
                };
                const fecha =
                        ahora.toLocaleDateString(
                                'es-ES',
                                opciones
                                );
                const hora =
                        ahora.toLocaleTimeString();
                document.getElementById(
                        "fechaHora"
                        ).innerHTML =
                        fecha + " | " + hora;
            }
            setInterval(
                    actualizarFechaHora,
                    1000
                    );
            actualizarFechaHora();
            
        </script>
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
    </body>
</html>
