
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" >
        <%
            String titulo;
            String modo = request.getParameter("modo");
            if (modo == null) {
                modo = "login"; 
            }
            switch (modo) {
            case "registro":
                titulo ="Registrar Cuenta";
                break;
            case "login":
                titulo ="Inicio de Sesión";
                break;
            case "olvido":
                titulo ="Recuperar Contraseña";
                break;
            
            default:
                titulo = "Inicio de Sesión";
            }
        %>
        <title><%=titulo%></title>
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
        <link rel="stylesheet" href="${pageContext.request.contextPath}/estilos/estilos.css">
    </head>
    <body>
        <%
            request.setAttribute("paginaActual", "login");
        %>
        <!-- header -->
        <jsp:include page="componentes/encabezado.jsp" />
        <main class="contenedor-principal-login">
            
            <div class="card shadow-lg login-card">
                <%
                    if (modo != null && modo.equals("registro")) {
                %>
                <jsp:include page="vista/registro.jsp" />
                <%
                    } else {
                        if (modo != null && modo.equals("olvido")){
                %>
                          <jsp:include page="vista/olvido.jsp" />
                <%
                        } else{
                %>
                            <jsp:include page="vista/login.jsp" />
                <%
                        }
                    }
                %>
            </div>
        </main>



        

        <!-- Bootstrap y alertify -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="//cdn.jsdelivr.net/npm/alertifyjs@1.13.1/build/alertify.min.js"></script>
        <!-- SweetAlert -->
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <jsp:include page="/componentes/mensajes.jsp" /> 
        <%
            String msgError = (String) session.getAttribute("error");
            if (msgError != null) {
        %>
            <div class="alert alert-danger">
                <%= msgError %>
            </div>
        <% 
                session.removeAttribute("error"); 
            }
        %>
    </body>
</html>
