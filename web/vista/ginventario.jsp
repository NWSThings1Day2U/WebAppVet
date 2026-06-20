<%@page import="modelo.productos"%>
<%@page import="java.util.List"%>

<%
    List<productos> lista = (List<productos>) request.getAttribute("listaProductos");
    
    int stockCritico = 0;
    int stockBajo = 0;
    int stockBien = 0;

    for (productos p : lista) {
        int actual = p.getStock();
        int minimo = p.getStockMinimo();

        if (actual < minimo) {
            stockCritico++; 
        } else if (actual == minimo || actual <= (minimo * 1.2)) { 
            stockBajo++;   
        } else {
            stockBien++;  
        }
    }
%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Inventario</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Vollkorn:ital,wght@0,400..900;1,400..900&display=swap" rel="stylesheet">     
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
        <link rel="icon" href="recursos/logoveet.png">
        <link rel="stylesheet" href="//cdn.jsdelivr.net/npm/alertifyjs@1.13.1/build/css/alertify.min.css"/>
        <link rel="stylesheet" href="//cdn.jsdelivr.net/npm/alertifyjs@1.13.1/build/css/themes/default.min.css"/>

        <link rel="stylesheet" href="${pageContext.request.contextPath}/estilos/contenidoadmin.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/estilos/esadmin.css">
        <style>
            .resaltado-busqueda{
                background-color: #DDE8C8 !important; 
                transition: all .2s ease;
            }
        </style>
    </head>
    <body>
        <%
            request.setAttribute("paginaActual", "inventario");
        %>
        <jsp:include page="../componentes/encabezado.jsp" />
        
        <main class="container mt-5 pt-4 contenido-admin" style="margin-top: 180px; margin-bottom: 150px;"> 
            <div class="container-fluid">
                <div class="card-bienvenida">
                    <div class="row align-items-center">
                        <div class="col-lg-8">
                            <h1 class="fw-bold">
                                Gestión de
                                <span class="text-success">Inventario</span>
                            </h1>
                            <p class="text-muted">
                                Control de productos, stock y medicamentos.
                            </p>
                        </div>
                        <div class="col-lg-4 text-lg-end">
                            <div class="fecha-box">
                                <i class="fa-solid fa-boxes-stacked me-2"></i>
                                Inventario actualizado
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="row g-4 mt-2 mb-4">
                    <div class="col-md-4">
                        <div class="card-dashboard">
                            <div>
                                <h5>Total Productos</h5>
                                <h1><%= (lista != null) ? lista.size() : 0 %></h1>
                            </div>
                            <i class="fa-solid fa-box icon-card text-success"></i>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="card-dashboard">
                            <div>
                                <h5>Stock Bajo</h5>
                                <h1><%= stockBajo%></h1>
                            </div>
                            <i class="fa-solid fa-triangle-exclamation icon-card text-warning"></i>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="card-dashboard">
                            <div>
                                <h5>Productos Críticos</h5>
                                <h1><%= stockCritico%></h1>
                            </div>
                            <i class="fa-solid fa-circle-xmark icon-card text-danger"></i>
                        </div>
                    </div>
                </div>

                <div class="tabla-panel">
                    <div class="d-flex justify-content-between align-items-center flex-wrap gap-3 mb-4">
                        <div>
                            <h3 class="fw-bold">Lista de Productos</h3>
                            <p class="text-muted">Gestión del inventario veterinario.</p>
                        </div>
                        <div class="d-flex gap-2 flex-wrap">
                            <input type="text" id="txtBuscarProducto" class="form-control" placeholder="Buscar por ID o nombre..."  style="width:230px;">
                            <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#modalNuevoProducto">
                                <i class="fa-solid fa-plus"></i> Nuevo Producto
                            </button>
                        </div>
                    </div>

                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Nombre</th>
                                    <th>Categoria</th>
                                    <th>Stock</th>
                                    <th>Stock Min.</th>
                                    <th>Precio</th>
                                    <th>F. Ingreso</th>
                                    <th>F. Vencimiento</th>
                                    <th>Proveedor</th>
                                    <th>Estado</th>
                                    <th>Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (lista != null && !lista.isEmpty()) {
                                    for (productos p : lista) {%>
                                <tr class="fila-producto" data-id="<%= p.getIdProducto() %>" data-nombre="<%= p.getNombre().toLowerCase() %>">
                                    <td>#<%= p.getIdProducto()%></td>
                                    <td><%= p.getNombre()%></td>
                                    <td>
                                        <%= p.getIdCategoria() == 1 ? "Medicamentos" : (p.getIdCategoria() == 2 ? "Accesorios" : "Otros") %>
                                    </td>
                                    <td><%= p.getStock()%></td>
                                    <td><%= p.getStockMinimo()%></td>
                                    <td>S/ <%= String.format("%.2f", p.getPrecio()) %></td>
                                    <td><%= p.getFechaIngreso() != null ? p.getFechaIngreso() : "-" %></td>
                                    <td><%= p.getFechaVencimiento() != null ? p.getFechaVencimiento() : "-" %></td>
                                    <td><%= p.getProveedor() != null ? p.getProveedor() : "-"%></td>
                                    <td>
                                        <%
                                            String color = "bg-success";
                                            if (p.getEstado() != null) {
                                                if (p.getEstado().equalsIgnoreCase("BAJO")) color = "bg-warning text-dark";
                                                if (p.getEstado().equalsIgnoreCase("CRITICO")) color = "bg-danger";
                                            }
                                        %>
                                        <span class="badge <%= color%>">
                                            <%= p.getEstado() != null ? p.getEstado() : "NORMAL" %>
                                        </span>
                                    </td>
                                    <td>
                                        <div class="d-flex gap-2 justify-content-center">
                                            <button class="btn btn-warning btn-sm" data-bs-toggle="modal" data-bs-target="#modalEditar<%= p.getIdProducto()%>">
                                                <i class="fa-solid fa-pen"></i>
                                            </button>
                                            <button class="btn btn-danger btn-sm" title="Eliminar" data-bs-toggle="modal" data-bs-target="#modalEliminar<%= p.getIdProducto()%>">
                                                <i class="fa-solid fa-trash"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                                <% }
                                } else { %>
                                <tr>
                                    <td colspan="11" class="text-center">No hay productos registrados en el inventario.</td>
                                </tr>
                                <% } %>
                                <tr id="filaSinResultados" style="display:none;">
                                    <td colspan="11" class="text-center py-4 text-muted fw-bold">
                                        <i class="fa-solid fa-magnifying-glass"></i>
                                        No se encontraron resultados.
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <% if (lista != null) {
                for (productos p : lista) {%>
            
            <div class="modal fade" id="modalEliminar<%= p.getIdProducto() %>" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header bg-danger text-white">
                            <h5 class="modal-title fw-bold"><i class="fa-solid fa-triangle-exclamation"></i> ¿Deseas desactivar el producto?</h5>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <p>
                                ¿Estás seguro de que deseas desactivar el producto
                                <strong><%= p.getNombre() %></strong>?
                            <p class="text-danger small mb-0"><i class="fa-solid fa-circle-info"></i> Una vez desactivado, el producto ya no aparecerá en la lista del inventario ni podrá ser utilizado en nuevas ventas.</p>
                            </p>

                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                            <a href="${pageContext.request.contextPath}/controladorinventario?accion=eliminar&id=<%= p.getIdProducto() %>" class="btn btn-danger fw-semibold">Desactivar Producto</a>
                        </div>
                    </div>
                </div>
            </div>

            <div class="modal fade" id="modalEditar<%= p.getIdProducto()%>" tabindex="-1">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header bg-warning-light text-dark">
                            <h5 class="modal-title"><i class="fa-solid fa-pen-to-square me-2"></i> Editar Producto</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <form action="${pageContext.request.contextPath}/controladorinventario" method="POST">
                                <input type="hidden" name="accion" value="editar"> <input type="hidden" name="id_producto" value="<%= p.getIdProducto()%>"> <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Nombre</label>
                                        <input type="text" name="nombre" value="<%= p.getNombre()%>" class="form-control" required>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Categoría</label>
                                        <select name="id_categoria" class="form-select" required>
                                            <option value="1" <%= p.getIdCategoria() == 1 ? "selected" : "" %>>Medicamentos</option>
                                            <option value="2" <%= p.getIdCategoria() == 2 ? "selected" : "" %>>Accesorios</option>
                                            <option value="3" <%= p.getIdCategoria() == 3 ? "selected" : "" %>>Otros</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-4 mb-3">
                                        <label class="form-label">Stock</label>
                                        <input type="number" name="stock" value="<%= p.getStock()%>" class="form-control" required>
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label class="form-label">Stock Mínimo</label>
                                        <input type="number" name="stock_minimo" value="<%= p.getStockMinimo()%>" class="form-control" required>
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label class="form-label">Precio</label>
                                        <input type="number" step="0.01" name="precio" value="<%= p.getPrecio()%>" class="form-control" required>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-4 mb-3">
                                        <label class="form-label">Fecha Ingreso</label>
                                        <input type="date" name="fecha_ingreso" value="<%= p.getFechaIngreso() != null ? p.getFechaIngreso() : "" %>" class="form-control">
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label class="form-label">Fecha Vencimiento</label>
                                        <input type="date" name="fecha_vencimiento" value="<%= p.getFechaVencimiento() != null ? p.getFechaVencimiento() : "" %>" class="form-control">
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label class="form-label">Proveedor</label>
                                        <input type="text" name="proveedor" value="<%= p.getProveedor() != null ? p.getProveedor() : "" %>" class="form-control">
                                    </div>
                                </div>
                                <div class="modal-footer pb-0 pe-0 border-0">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                                    <button type="submit" class="btn btn-warning">Guardar Cambios</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            <%  }
            } %>

            <div class="modal fade" id="modalNuevoProducto" tabindex="-1">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header bg-success text-white">
                            <h5 class="modal-title">Registrar Producto</h5>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <form action="${pageContext.request.contextPath}/controladorinventario" method="POST">
                                <input type="hidden" name="accion" value="guardar">
                                
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label>Nombre</label>
                                        <input type="text" name="nombre" class="form-control" required>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Categoría</label>
                                        <select name="id_categoria" class="form-select" required>
                                            <option value="" disabled selected>Seleccione una categoría...</option>
                                            <option value="1">Medicamentos</option>
                                            <option value="2">Accesorios</option>
                                            <option value="3">Otros</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-4 mb-3">
                                        <label>Stock</label>
                                        <input type="number" name="stock" class="form-control" required>
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label>Stock Minimo</label>
                                        <input type="number" name="stock_minimo" class="form-control" required>
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label>Precio</label>
                                        <input type="number" step="0.01" name="precio" class="form-control" required>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-4 mb-3">
                                        <label>Fecha Ingreso</label>
                                        <input type="date" name="fecha_ingreso" class="form-control">
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label>Fecha Vencimiento</label>
                                        <input type="date" name="fecha_vencimiento" class="form-control">
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label>Proveedor</label>
                                        <input type="text" name="proveedor" class="form-control">
                                    </div>
                                </div>
                                <div class="modal-footer pb-0 pe-0 border-0">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                                    <button type="submit" class="btn btn-success">Guardar Producto</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

        </main>
        
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="//cdn.jsdelivr.net/npm/alertifyjs@1.13.1/build/alertify.min.js"></script>

        <%
            String mensajeExito = (String) request.getSession().getAttribute("mensajeExito");
            String mensajeError = (String) request.getSession().getAttribute("mensajeError");
            if (mensajeExito != null) {
        %>
        <script>
            alertify.success('<%= mensajeExito %>');
        </script>
        <%
                request.getSession().removeAttribute("mensajeExito");
            }
            if (mensajeError != null) {
        %>
        <script>
            alertify.error('<%= mensajeError %>');
        </script>
        <%
                request.getSession().removeAttribute("mensajeError");
            }
        %>
        <script>
            document.addEventListener("DOMContentLoaded", function () {

                const txtBuscar = document.getElementById("txtBuscarProducto");
                const filaSinResultados = document.getElementById("filaSinResultados");

                txtBuscar.addEventListener("input", function () {

                    const texto = this.value.toLowerCase().trim();

                    const filas = document.querySelectorAll(".fila-producto");

                    let encontrados = 0;

                    filas.forEach(fila => {

                        fila.classList.remove("resaltado-busqueda");

                        const id = fila.dataset.id;
                        const nombre = fila.dataset.nombre;

                        const coincide =
                                id.includes(texto) ||
                                nombre.includes(texto);

                        if (coincide) {

                            fila.style.display = "";
                            encontrados++;

                            if (texto !== "") {
                                fila.classList.add("resaltado-busqueda");
                            }

                        } else {
                            fila.style.display = "none";
                        }

                    });

                    filaSinResultados.style.display =
                            encontrados === 0 ? "" : "none";

                });

            });
            </script>
    </body>
</html>