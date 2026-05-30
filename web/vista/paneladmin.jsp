
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

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
                            Bienvenido,
                            <span class="text-success">
                                ${sessionScope.usuario}!
                            </span>
                        </h2>
                        <p class="text-muted mb-0">
                            ¿Qué desea hacer hoy?
                        </p>
                    </div>
                    <div class="col-lg-4 text-lg-end mt-3 mt-lg-0 mb-4">
                        <div class="fecha-box">
                            <i class="fa-solid fa-calendar-days"></i>
                            <span id="fechaHora"></span>
                        </div>
                    </div>
                </div>
            </div>
            <!-- tarjetas -->
            <div class="row g-4">
                <div class="col-xl-3 col-md-6">
                    <div class="card-dashboard">
                        <div>
                            <h6>Total Citas</h6>
                            <h2>120</h2>
                        </div>
                        <i class="fa-solid fa-calendar-check icon-card text-success"></i>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6">
                    <div class="card-dashboard">
                        <div>
                            <h6>Clientes</h6>
                            <h2>84</h2>
                        </div>
                        <i class="fa-solid fa-users icon-card text-primary"></i>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6">
                    <div class="card-dashboard">
                        <div>
                            <h6>Mascotas</h6>
                            <h2>156</h2>
                        </div>
                        <i class="fa-solid fa-dog icon-card text-warning"></i>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6">
                    <div class="card-dashboard">
                        <div>
                            <h6>Ventas</h6>
                            <h2>S/ 2400</h2>
                        </div>
                        <i class="fa-solid fa-cart-shopping icon-card text-danger"></i>
                    </div>
                </div>
            </div>
            <!-- graficos -->
            <div class="row g-4 mt-2">
                <!-- VENTAS -->
                <div class="col-xl-6">
                    <div class="tabla-panel">
                        <h5 class="fw-bold mb-4">
                            Ventas Semanales
                        </h5>
                        <div class="chart-container">
                            <canvas id="graficoVentas"></canvas>
                        </div>
                    </div>
                </div>

                <!-- citas -->
                <div class="col-xl-6">
                    <div class="tabla-panel">
                        <h5 class="fw-bold mb-4">
                            Citas por Día
                        </h5>
                        <div class="chart-container">
                            <canvas id="graficoCitas"></canvas>
                        </div>
                    </div>
                </div>
            </div>
            <!-- tablas -->
            <div class="row g-4 mt-2">
                <!-- citas -->
                <div class="col-xl-7">
                    <div class="tabla-panel h-100">
                        <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
                            <h5 class="fw-bold mb-0">
                                Citas Próximas
                            </h5>
                            <a href="CitasServlet"
                               class="btn btn-success btn-sm">
                                <i class="fa-solid fa-eye"></i>
                                Ver Todas
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
                                    <tr>
                                        <td>Juan Pérez</td>
                                        <td>Firulais</td>
                                        <td>15/05/2026</td>
                                        <td>10:30 AM</td>
                                        <td>
                                            <span class="badge bg-success">
                                                Confirmada
                                            </span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>María López</td>
                                        <td>Rocky</td>
                                        <td>15/05/2026</td>
                                        <td>11:00 AM</td>
                                        <td>
                                            <span class="badge bg-warning text-dark">
                                                Pendiente
                                            </span>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- resumen -->
                <div class="col-xl-5">
                    <div class="tabla-panel h-100">
                        <h5 class="fw-bold mb-4">
                            Resumen del Mes
                        </h5>
                        <div class="table-responsive">
                            <table class="table table-bordered">
                                <tbody>
                                    <tr>
                                        <th>Total Citas</th>
                                        <td>248</td>
                                    </tr>
                                    <tr>
                                        <th>Ingresos</th>
                                        <td>S/ 12,450</td>
                                    </tr>
                                    <tr>
                                        <th>Nuevos Clientes</th>
                                        <td>31</td>
                                    </tr>
                                    <tr>
                                        <th>Mascotas Registradas</th>
                                        <td>52</td>
                                    </tr>
                                    <tr>
                                        <th>Productos Vendidos</th>
                                        <td>412</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div> 
        </main>
        <!-- Bootstrap y alertify -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="//cdn.jsdelivr.net/npm/alertifyjs@1.13.1/build/alertify.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

        <script>
            /* graf ventas */
            const ventas = document.getElementById('graficoVentas');
            new Chart(ventas, {
                type: 'bar',
                data: {
                    labels: ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'],
                    datasets: [{
                            label: 'Ventas',
                            data: [120, 200, 180, 250, 300, 280, 400],
                            borderWidth: 1
                        }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false
                }
            });
            /* graf citas */
            const citas = document.getElementById('graficoCitas');
            new Chart(citas, {
                type: 'line',
                data: {
                    labels: ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'],
                    datasets: [{
                            label: 'Citas',
                            data: [5, 7, 4, 9, 8, 6, 10],
                            tension: 0.4,
                            fill: true
                        }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false
                }
            });

            function actualizarFechaHora() {
                const ahora = new Date();
                const opciones = {
                    weekday: 'long',
                    year: 'numeric',
                    month: 'long',
                    day: 'numeric'
                };
                const fecha = ahora.toLocaleDateString('es-ES', opciones);
                const hora = ahora.toLocaleTimeString();
                document.getElementById("fechaHora").innerHTML =
                        fecha + " | " + hora;
            }
            setInterval(actualizarFechaHora, 1000);
            actualizarFechaHora();

        </script>

        <jsp:include page="/componentes/mensajes.jsp" /> 
    </body>
</html>
