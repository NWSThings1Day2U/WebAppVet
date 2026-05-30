<%@page import="modelo.ventas"%>
<%@page import="dao.ventasdao"%>
<%@page import="java.util.List"%>

<%
    ventasdao dao = new ventasdao();
    List<ventas> lista = dao.listarVentas();
%>


<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Ventas</title>
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
            request.setAttribute("paginaActual", "ventas");
        %>
        <jsp:include page="../componentes/encabezado.jsp" />
        <main class="container mt-5 pt-4 contenido-admin" style="margin-top: 180px; margin-bottom: 150px;"> 
            <div class="container-fluid">
                <!-- header -->
                <div class="card-bienvenida">
                        <div class="row align-items-center">
                            <div class="col-lg-8">
                                <h1 class="fw-bold">
                                    Gestión de
                                    <span class="text-success">
                                        Ventas
                                    </span>
                                </h1>
                                <p class="text-muted">
                                    Administración de ventas
                                    y pagos realizados.
                                </p>
                            </div>
                        </div>
                </div>
                <!-- tarjetas -->
                    <div class="row g-4 mt-2 mb-4">
                        <div class="col-md-4">
                            <div class="card-dashboard">
                                <div>
                                    <h5>Total Ventas</h5>
                                    <h1><%= lista.size()%></h1>
                                </div>
                                <i class="fa-solid fa-cart-shopping icon-card text-success"></i>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card-dashboard">
                                <div>
                                    <h5>Ventas Hoy</h5>
                                    <h1>S/ 1200</h1>
                                </div>
                                <i class="fa-solid fa-sack-dollar icon-card text-warning"></i>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card-dashboard">
                                <div>
                                    <h5>Clientes</h5>
                                    <h1>18</h1>
                                </div>
                                <i class="fa-solid fa-users icon-card text-primary"></i>
                            </div>
                        </div>
                    </div>
                    <!-- tabla -->
                    <div class="tabla-panel">
                        <div class="d-flex
                             justify-content-between
                             align-items-center
                             flex-wrap
                             gap-3
                             mb-4">
                            <div>
                                <h3 class="fw-bold">
                                    Historial de Ventas
                                </h3>
                            </div>
                            <button class="btn btn-success">
                                <i class="fa-solid fa-plus"></i>
                                Nueva Venta
                            </button>
                        </div>
                        <div class="table-responsive">
                            <table class="table table-hover align-middle">
                                <thead class="table-light">
                                    <tr>
                                        <th>ID</th>
                                        <th>Cliente</th>
                                        <th>Fecha</th>
                                        <th>Método Pago</th>
                                        <th>Descuento</th>
                                        <th>Total</th>
                                        <th>Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (ventas v : lista) {%>
                                    <tr>
                                        <td>#<%= v.getIdVenta()%></td>
                                        <td>
                                            <strong>
                                                <%= v.getCliente()%>
                                            </strong>
                                        </td>
                                        <td><%= v.getFecha()%></td>
                                        <td><%= v.getMetodoPago()%></td>
                                        <td>S/ <%= v.getDescuento()%></td>
                                        <td>
                                            <strong class="text-success">
                                                S/ <%= v.getTotal()%>
                                            </strong>
                                        </td>
                                        <td>
                                            <button class="btn btn-primary btn-sm">
                                                <i class="fa-solid fa-eye"></i>
                                            </button>
                                        </td>
                                    </tr>
                                    <% }%>
                                </tbody>
                            </table>
                        </div>
                    </div>
            </div>
        </main>
        <!-- Bootstrap y alertify -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="//cdn.jsdelivr.net/npm/alertifyjs@1.13.1/build/alertify.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    </body>
</html>
