<%-- 
    Document   : detalleventa
    Created on : 3 jun 2026, 10:31:13?p.m.
    Author     : Jhan
--%>

<%@page import="java.util.List"%>
<%@page import="modelo.ventas.Detalle"%>

<%
    List<Detalle> detalles =  (List<Detalle>) request.getAttribute("detalles");

    int idVenta =  (Integer)  request.getAttribute("idVenta");
%>

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">

    <title>Detalle Venta</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">

</head>

<body>

<div class="container mt-5">

    <div class="card shadow">

        <div class="card-header bg-success text-white">

            <h3>
                Detalle Venta #<%= idVenta %>
            </h3>

        </div>

        <div class="card-body">

            <table class="table table-bordered">

                <thead class="table-light">

                    <tr>

                        <th>ID Producto</th>
                        <th>Producto</th>
                        <th>Cantidad</th>
                        <th>Precio Unitario</th>
                        <th>Subtotal</th>

                    </tr>

                </thead>

                <tbody>

                <%
                    double total = 0;

                    for(Detalle d : detalles){
                        total += d.getSubtotal();
                %>

                    <tr>

                        <td>
                            <%= d.getIdProducto() %>
                        </td>

                        <td>
                            <%= d.getNombreProducto() %>
                        </td>

                        <td>
                            <%= d.getCantidad() %>
                        </td>

                        <td>
                            S/ <%= d.getPrecioUnitario() %>
                        </td>

                        <td>
                            S/ <%= d.getSubtotal() %>
                        </td>

                    </tr>

                <%
                    }
                %>

                </tbody>

            </table>

            <div class="text-end">

                <h4 class="text-success">

                    Total:
                    S/ <%= total %>

                </h4>

            </div>

            <a href="controladorseccion?seccion=ventas"
               class="btn btn-secondary">

                Volver

            </a>

        </div>

    </div>

</div>

</body>
</html>
