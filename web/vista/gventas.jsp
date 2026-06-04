<%@page import="modelo.ventas"%>
<%@page import="dao.ventasdao"%>
<%@page import="java.util.List"%>
<%@page import="dao.clientedao"%>
<%@page import="modelo.clientes"%>
<%@page import="dao.productodao"%>
<%@page import="modelo.productos"%>

<%
    clientedao clienteDao = new clientedao();
    List<clientes> listaClientes = clienteDao.listarClientes();
%>
<% 
    productodao pdao = new productodao();
    List<productos> listaProductos = pdao.listarProductos();
%>
<%
    ventasdao dao = new ventasdao();
    List<ventas> lista = dao.listarVentas();
    double ventasHoy = dao.totalVentasHoy();
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
                                <h1>S/ <%= ventasHoy %></h1>
                            </div>
                            <i class="fa-solid fa-sack-dollar icon-card text-warning"></i>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card-dashboard">
                            <div>
                                <h5>Clientes</h5>
                                <h1><%= listaClientes.size() %></h1> 
                            </div>
                            <i class="fa-solid fa-users icon-card text-primary"></i>
                        </div>
                    </div>
                </div>
                <!-- tabla -->
                <div class="tabla-panel">
                    <div class="d-flex justify-content-between align-items-center flex-wrap gap-3 mb-4">

                        <div>
                            <h3 class="fw-bold mb-1">
                                Historial de Ventas
                            </h3>
                            <p class="text-muted mb-0">
                                Visualiza todas las ventas registradas.
                            </p>
                        </div>

                        <div class="d-flex gap-2">
                            <button class="btn btn-success"
                                    data-bs-toggle="modal"
                                    data-bs-target="#modalNuevaVenta">
                                <i class="fa-solid fa-plus"></i>
                                Nueva Venta
                            </button>

                            <a href="${pageContext.request.contextPath}/exportarventas"
                               class="btn btn-outline-success">
                                <i class="fa-solid fa-file-excel"></i>
                                Exportar Excel
                            </a>
                        </div>

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
                                        <a href="${pageContext.request.contextPath}/detalleventa?id=<%= v.getIdVenta()%>"
                                           class="btn btn-primary btn-sm">
                                            <i class="fa-solid fa-eye"></i>
                                        </a>
                                        <button class="btn btn-danger btn-sm"
                                                title="Anular Venta"
                                                data-bs-toggle="modal"
                                                data-bs-target="#modalEliminar<%= v.getIdVenta() %>">
                                            <i class="fa-solid fa-trash"></i>
                                        </button>
                                    </td>

                                </tr>

                            <div class="modal fade"
                                 id="modalEliminar<%= v.getIdVenta() %>"
                                 tabindex="-1"
                                 aria-hidden="true">

                                <div class="modal-dialog">
                                    <div class="modal-content">

                                        <div class="modal-header bg-danger text-white">
                                            <h5 class="modal-title fw-bold">
                                                <i class="fa-solid fa-triangle-exclamation"></i>
                                                ¿Confirmar Anulación?
                                            </h5>

                                            <button type="button"
                                                    class="btn-close btn-close-white"
                                                    data-bs-dismiss="modal">
                                            </button>
                                        </div>

                                        <div class="modal-body">
                                            <p>
                                                ¿Estás completamente seguro de que deseas anular la venta
                                                <strong>#<%= v.getIdVenta() %></strong>?
                                            </p>

                                            <p class="mb-0">
                                                Cliente:
                                                <strong><%= v.getCliente() %></strong>
                                            </p>

                                            <p class="mb-0">
                                                Total:
                                                <strong>S/ <%= v.getTotal() %></strong>
                                            </p>
                                        </div>

                                        <div class="modal-footer">
                                            <button type="button"
                                                    class="btn btn-secondary"
                                                    data-bs-dismiss="modal">
                                                Cancelar
                                            </button>

                                            <a href="${pageContext.request.contextPath}/anularventa?id=<%= v.getIdVenta() %>"
                                               class="btn btn-danger fw-semibold">
                                                Anular Venta
                                            </a>
                                        </div>

                                    </div>
                                </div>
                            </div>
                            <% }%>

                            <!-- js carrito demo -->                                   

                            <!-- js carrito demo -->

                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </main>

        <div class="modal fade"  id="modalNuevaVenta">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header bg-success text-white">
                        <h5 class="modal-title">
                            Registrar Venta
                        </h5>
                        <button type="button"
                                class="btn-close btn-close-white"
                                data-bs-dismiss="modal">
                        </button>
                    </div>
                    <form action="${pageContext.request.contextPath}/controladorventas"
                          method="POST">
                        <div class="modal-body">
                            <input type="hidden"
                                   name="accion"
                                   value="guardar">
                            <div class="row">
                                <div class="col-md-5 mb-3">
                                    <label class="form-label">Nombre de cliente</label>
                                    <select name="txtIdCliente" class="form-select" required>
                                        <option value="" selected disabled>Seleccionar cliente</option>
                                        <% if (listaClientes != null) {
                                                    for (clientes c : listaClientes) {%>
                                        <option value="<%= c.getIdCliente()%>">(ID: <%= c.getIdCliente()%>) - <%= c.getNombreCompleto()%></option>
                                        <%   }
                                                }%>
                                    </select>
                                </div>
                                <div class="col-md-5 mb-3">
                                    <label class="form-label">
                                        Método Pago</label>
                                    <select name="metodoPago"
                                            class="form-select">
                                        <option>Efectivo</option>
                                        <option>Tarjeta</option>
                                        <option>Yape</option>
                                        <option>Plin</option>
                                    </select>
                                </div>
                            </div>
                            <hr>
                            <div class="row">
                                <div class="col-md-5 mb-3">
                                    <label class="form-label">
                                        Producto
                                    </label>
                                    <select id="producto"
                                            name="IdProducto"
                                            class="form-select"
                                            required>
                                        <option value=""
                                                selected
                                                disabled>
                                            Seleccionar producto
                                        </option>
                                        <% for (productos p : listaProductos) {%>
                                        <option
                                            value="<%= p.getIdProducto()%>"
                                            data-precio="<%= p.getPrecio()%>"
                                            data-stock="<%= p.getStock()%>">
                                            (ID: <%= p.getIdProducto()%>)
                                            -
                                            <%= p.getNombre()%>
                                            -
                                            Stock: <%= p.getStock()%>
                                        </option>
                                        <% }%>
                                    </select>
                                </div>                                    

                                <!-- totales d carrito -->

                                <div class="col-md-2 mb-3">
                                    <label class="form-label">
                                        Stock</label> 
                                    <input type="number"
                                           id="stock"
                                           class="form-control"
                                           readonly>
                                </div>

                                <div class="col-md-2 mb-3">
                                    <label class="form-label">
                                        Cantidad</label>
                                    <input type="number"
                                           id="cantidad"
                                           name="cantidad"
                                           class="form-control"
                                           min="1"
                                           required>
                                </div>
                                <!-- btn agregar
                                <div class="col-md-2 mb-3 d-flex align-items-end">
                                    <button type="button"
                                            class="btn btn-primary w-100"
                                            onclick="agregarCarrito()">
                                        <i class="fa-solid fa-cart-plus"></i>
                                        Agregar
                                    </button>
                                </div> -->

                                <div class="col-md-3 mb-3">
                                    <label class="form-label">
                                        Precio</label>
                                    <input type="number"
                                           step="0.01"
                                           id="precio"
                                           name="precio"
                                           class="form-control"
                                           readonly>
                                </div>                                   
                                <div class="col-md-3 mb-3">                                    
                                    <label class="form-label">
                                        Subtotal</label>
                                    <input type="text"
                                           id="subtotalProducto"
                                           class="form-control"
                                           readonly>
                                </div>

                                <!-- inic tbl temporal de carrito -->
                                <hr>

                                <!-- cierre tbl temporal de carrito -->

                                <div class="col-md-3 mb-3">
                                    <label class="form-label">
                                        Descuento Aplicado</label>
                                    <input type="text"
                                           class="form-control text-success fw-bold"
                                           value="5 %"
                                           readonly>
                                    <input type="hidden"
                                           name="descuento"
                                           value="5">
                                </div>

                                <div class="col-md-3 mb-3"> 
                                    <label class="form-label">
                                        Total</label>
                                    <input type="text"
                                           id="total"
                                           class="form-control fw-bold text-success"
                                           readonly>
                                </div>
                            </div>                                                                     

                        </div>               
                        <div class="modal-footer">
                            <button type="submit"
                                    class="btn btn-success">
                                Registrar Venta
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <!-- Bootstrap y alertify -->

        <script>
            function calcularVenta() {
                let precio =
                        parseFloat(
                                document.getElementById("precio").value
                                ) || 0;
                let cantidad =
                        parseInt(
                                document.getElementById("cantidad").value
                                ) || 0;
                let subtotal =
                        precio * cantidad;
                let descuento =
                        subtotal * 0.05;
                let total =
                        subtotal - descuento;
                document.getElementById("subtotalProducto")
                        .value = subtotal.toFixed(2);
                document.getElementById("total")
                        .value = total.toFixed(2);
            }
            document
                    .getElementById("producto")
                    .addEventListener("change", function () {
                        let opcion =
                                this.options[this.selectedIndex];
                        let precio =
                                opcion.getAttribute("data-precio");
                        let stock =
                                opcion.getAttribute("data-stock");
                        document.getElementById("precio")
                                .value = precio;
                        document.getElementById("stock")
                                .value = stock;
                        calcularVenta();
                    });
            document
                    .getElementById("cantidad")
                    .addEventListener("input", calcularVenta);
        </script>



        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="//cdn.jsdelivr.net/npm/alertifyjs@1.13.1/build/alertify.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    </body>
</html>
