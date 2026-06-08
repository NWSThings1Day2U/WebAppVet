<%-- 
    Document   : detalleventa
    Created on : 3 jun 2026, 10:31:13 p.m.
    Author     : Jhan
--%>

<%@page import="java.util.List"%>
<%@page import="modelo.ventas.Detalle"%>

<%
    List<Detalle> detalles =  (List<Detalle>) request.getAttribute("detalles");
    int idVenta =  (Integer)  request.getAttribute("idVenta");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Detalle Venta #<%= idVenta %> | Gallito de las Rocas</title>
    <link rel="icon" href="${pageContext.request.contextPath}/recursos/logoveet.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/estilos/detallepag.css">
</head>

<body>

<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-lg-10">
            
            <div class="card card-custom card-celeste shadow-lg">
                
                <div class="card-header-custom d-flex align-items-center justify-content-between">
                    <div class="d-flex align-items-center">
                        <img src="recursos/logovet.png" alt="Logo" style="height: 52px; width: auto; margin-right: 15px;" onerror="this.style.display='none'">
                        <div>
                            <h5 class="m-0 text-uppercase tracking-wide">Gallito de las Rocas</h5>
                            <h3 class="m-0">Detalle Venta #<%= idVenta %></h3>
                        </div>
                    </div>
                    <span class="fs-4" style="color: var(--ojito-aqua-texto);"><i class="fa-solid fa-receipt"></i></span>
                </div>

                <div class="card-body p-4 bg-white">
                    
                    <div class="table-responsive">
                        <table class="table table-custom table-hover align-middle">
                            <thead style="background-color: #f2f9f8;">
                                <tr>
                                    <th class="py-3">ID Producto</th>
                                    <th class="py-3">Producto</th>
                                    <th class="py-3 text-center">Cantidad</th>
                                    <th class="py-3 text-end">Precio Unitario</th>
                                    <th class="py-3 text-end">Subtotal</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    double total = 0;
                                    if (detalles != null && !detalles.isEmpty()) {
                                        for(Detalle d : detalles){
                                            total += d.getSubtotal();
                                %>
                                    <tr>
                                        <td class="fw-bold text-dark">#<%= d.getIdProducto() %></td>
                                        <td class="value-text"><%= d.getNombreProducto() %></td>
                                        <td class="text-center fw-bold text-dark"><%= d.getCantidad() %></td>
                                        <td class="text-end value-text">S/ <%= String.format("%.2f", d.getPrecioUnitario()) %></td>
                                        <td class="text-end fw-bold text-dark">S/ <%= String.format("%.2f", d.getSubtotal()) %></td>
                                    </tr>
                                <%
                                        }
                                    } else {
                                %>
                                    <tr>
                                        <td colspan="5" class="text-center py-4 text-muted">
                                            No se encontraron productos en el detalle.
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>

                    <div class="row justify-content-end mt-4">
                        <div class="col-md-5">
                            <div class="p-3 rounded-3" style="background-color: var(--ojito-aqua-bg); border: 1px solid var(--ojito-aqua-borde);">
                                <div class="d-flex justify-content-between align-items-center">
                                    <span class="fw-bold text-uppercase fs-6" style="color: var(--ojito-aqua-texto);">Total General:</span>
                                    <span class="fs-4 fw-bold" style="color: var(--naranja-primario);">
                                        S/ <%= String.format("%.2f", total) %>
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="d-flex justify-content-end mt-4">
                        <a href="controladorseccion?seccion=ventas" class="btn btn-volver d-inline-flex align-items-center gap-2 py-2 px-4">
                            <i class="fa-solid fa-arrow-left"></i> Volver a Ventas
                        </a>
                    </div>

                </div>
                

            </div>
            
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>