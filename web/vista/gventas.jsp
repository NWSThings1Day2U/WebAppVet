<%@page import="modelo.ventas"%>
<%@page import="dao.ventasdao"%>
<%@page import="java.util.List"%>
<%@page import="dao.clientedao"%>
<%@page import="modelo.clientes"%>
<%@page import="dao.productodao"%>
<%@page import="modelo.*"%>

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
        
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
        <!-- Icon -->
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

                            <a href="${pageContext.request.contextPath}/exportarventas" class="btn btn-outline-success"   onclick="alertify.success('Exportando archivo Excel...')">
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
                                <%  if (lista != null && !lista.isEmpty()) {
                                        for (ventas v : lista) {%>
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
                                       <div class="d-flex align-items-center justify-content-center gap-2">
                                            <a href="${pageContext.request.contextPath}/detalleventa?id=<%= v.getIdVenta()%>" class="text-decoration-none">        
                                                <button class="btn btn-sm fw-bold d-flex align-items-center justify-content-center" 
                                                        style="color: #105341; border: 2px solid #2CA587; background-color: #E6F6F3; border-radius: 6px; width: 36px; height: 36px; padding: 0;" 
                                                        title="Ver detalle venta">
                                                    <i class="fa-solid fa-eye"></i>
                                                </button>
                                            </a>

                                            <button class="btn btn-danger btn-sm"
                                                    title="Anular Venta"
                                                    data-bs-toggle="modal"
                                                    data-bs-target="#modalEliminar<%= v.getIdVenta() %>">
                                                <i class="fa-solid fa-trash"></i>
                                            </button>
                                        </div>
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
                                                ¿Deseas anular la venta?
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
                            <% 
                                        }
                                    } else { 
                                %>
                                <tr>
                                    <td colspan="7" class="text-center text-muted">No se encontraron ventas cargadas. .</td>
                                </tr>
                                
                                
                                <% } %>
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
                    <form action="${pageContext.request.contextPath}/controladorventas"  method="POST">
                        <div class="modal-body">
                            <input type="hidden" name="accion" value="guardar">
                            <input type="hidden" id="detalleJson" name="detalleJson">
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
                                            >
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
                                           >
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
                                <div class="row col" >
                                <div class="col-md-4 mb-3 d-flex align-items-end">
                                    <button type="button"
                                            class="btn btn-outline-primary w-100"
                                            onclick="agregarCarrito()">
                                        <i class="fa-solid fa-cart-plus"></i>
                                        Agregar al carrito
                                    </button>
                                </div> 
                                <div class="col-md-4 mb-3 d-flex align-items-end">
                                    <button type="button"
                                        class="btn btn-outline-success w-100 position-relative"
                                        onclick="mostrarCarrito()">
                                        <i class="fa-solid fa-eye"></i>
                                        
                                        Mostrar carrito
                                        <span id="badgeCarrito"
                                                class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                                              0
                                          </span>
                                    </button>
                                </div> 
                                <div class="col-md-4 mb-3 d-flex align-items-end">
                                    <button type="button"
                                            class="btn btn-outline-danger w-100"
                                             onclick="vaciarCarrito()">
                                        <i class="fa-solid fa-bucket"></i>
                                        Vaciar carrito
                                    </button>
                                </div>
                                </div>
                                <div id="contenedorCarrito" style="display:none;">

                                    <hr>

                                    <h5 class="fw-bold">
                                        <i class="fa-solid fa-cart-shopping"></i>
                                        Carrito
                                    </h5>

                                    <table class="table table-bordered table-hover">

                                        <thead>
                                            <tr>
                                                <th>Producto</th>
                                                <th>Precio</th>
                                                <th>Cantidad</th>
                                                <th>Subtotal</th>
                                                <th>Acciones</th>
                                            </tr>
                                        </thead>

                                        <tbody id="tbodyCarrito">
                                        </tbody>

                                    </table>

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
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="//cdn.jsdelivr.net/npm/alertifyjs@1.13.1/build/alertify.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <jsp:include page="/componentes/mensajes.jsp" />
        <jsp:include page="/componentes/pie.jsp"/>
        <%
    String mensajeExito = (String) session.getAttribute("mensajeExito");
    String mensajeError = (String) session.getAttribute("mensajeError");
        %>

        <script>
        window.onload = function() {
            <% if (mensajeExito != null) { %>
                alertify.success("<%= mensajeExito %>");
            <% } %>

            <% if (mensajeError != null) { %>
                alertify.error("<%= mensajeError %>");
            <% } %>
        };
        </script>

        <%
        session.removeAttribute("mensajeExito");
        session.removeAttribute("mensajeError");
        %>
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
            
            function calcularTotalCarrito(){

    let subtotalGeneral = 0;

    carrito.forEach(item => {

        subtotalGeneral += item.precio * item.cantidad;

    });

    let descuento = subtotalGeneral * 0.05;

    let total = subtotalGeneral - descuento;

    document.getElementById("total").value =
        total.toFixed(2);
}
        </script>

        <script>
            let carrito = [];

                function agregarCarrito(){

                let select = document.getElementById("producto");

                if(select.selectedIndex <= 0){

                    alertify.error("Seleccione un producto");

                    return;
                }

                let cantidad =
                    parseInt(document.getElementById("cantidad").value);

                if(isNaN(cantidad) || cantidad <= 0){

                    alertify.error("Ingrese una cantidad válida");

                    return;
                }

                let stock =
                    parseInt(document.getElementById("stock").value);

                if(cantidad > stock){

                    alertify.error("La cantidad supera el stock disponible");

                    return;
                }

                let opcion =
                    select.options[select.selectedIndex];

                let item = {

                    idProducto: parseInt(select.value),

                    nombre: opcion.text,

                    precio: parseFloat(
                        document.getElementById("precio").value
                    ),

                    cantidad: cantidad
                };
                let existe = carrito.find(p => p.idProducto == item.idProducto);

                if(existe){

                    existe.cantidad += item.cantidad;

                    actualizarTablaCarrito();

                    actualizarBadge();
                    calcularTotalCarrito();
                    limpiarCampos();

                    alertify.success(
                        "Cantidad actualizada en el carrito"
                    );

                    return;
                }
                carrito.push(item);

                actualizarTablaCarrito();

                actualizarBadge();
                calcularTotalCarrito();
                limpiarCampos();

                alertify.success("Producto agregado");
            }
            function actualizarTablaCarrito(){

    let html = "";

    carrito.forEach((p,index)=>{

        let subtotal = p.precio * p.cantidad;

        console.log("Producto:", p);

        html += `
<tr>
    <td>\${p.nombre}</td>
    <td>S/ \${Number(p.precio).toFixed(2)}</td>
    <td>\${p.cantidad}</td>
    <td>S/ \${subtotal.toFixed(2)}</td>

    <td>
        <button
            type="button"
            class="btn btn-success btn-sm"
            onclick="editarItem(\${index})">
            <i class="fa fa-pen"></i>
        </button>

        <button
            type="button"
            class="btn btn-danger btn-sm"
            onclick="eliminarItem(\${index})">
            <i class="fa fa-trash"></i>
        </button>
    </td>
</tr>
`;
    });

    console.log(html);

    document.getElementById("tbodyCarrito").innerHTML = html;
}

function eliminarItem(index){

    carrito.splice(index,1);

    actualizarTablaCarrito();

    actualizarBadge();

    calcularTotalCarrito();
}
            function editarItem(index){

    let item = carrito[index];

    console.log(item);

    let select =
        document.getElementById("producto");

    select.value =
        String(item.idProducto);

    select.dispatchEvent(
        new Event("change")
    );

    document.getElementById("cantidad").value =
        item.cantidad;

    calcularVenta();

    carrito.splice(index,1);

    actualizarTablaCarrito();

    actualizarBadge();
    calcularTotalCarrito();
    alertify.success(
        "Producto cargado para edición"
    );
}
            function vaciarCarrito(){

    carrito = [];

    actualizarTablaCarrito();

    actualizarBadge();

    document.getElementById("total").value = "";

    document.getElementById("contenedorCarrito")
            .style.display = "none";

    alertify.success("Carrito vaciado");
}
            document.querySelector("form").addEventListener("submit", function(){

                document.getElementById("detalleJson").value =
                    JSON.stringify(carrito);

            });
            function mostrarCarrito(){

    let contenedor =
        document.getElementById("contenedorCarrito");

    if(carrito.length === 0){

        alertify.warning("El carrito está vacío");
        return;
    }

    contenedor.style.display = "block";

    contenedor.scrollIntoView({
        behavior: "smooth"
    });
}

function actualizarBadge(){

    let badge =
        document.getElementById("badgeCarrito");

    badge.textContent = carrito.length;

    badge.style.display =
        carrito.length > 0
        ? "inline-block"
        : "none";
}
function limpiarCampos(){

    document.getElementById("producto").selectedIndex = 0;

    document.getElementById("stock").value = "";

    document.getElementById("cantidad").value = "";

    document.getElementById("precio").value = "";

    document.getElementById("subtotalProducto").value = "";
}
document.querySelector("form")
.addEventListener("submit", function(e){

    if(carrito.length === 0){

        e.preventDefault();

        alertify.error(
            "Debe agregar al menos un producto"
        );

        return;
    }

    document.getElementById("detalleJson").value =
        JSON.stringify(carrito);
});

        </script>

        
    </body>
</html>
