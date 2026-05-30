<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String paginaActual = (String) request.getAttribute("paginaActual");
%>
<c:choose>

    <c:when test="${sessionScope.rol == 'admin'}">
        <header>
            <nav class="navbar bg-body-tertiary fixed-top">
                <div class="container-fluid px-4"> 
                    <div class="d-flex align-items-center gap-3"> 
                        <button class="navbar-toggler custom-toggler" type="button" data-bs-toggle="offcanvas" data-bs-target="#offcanvasNavbar">
                            <i class="fa-solid fa-bars custom-toggler-orange"></i> 
                        </button>
                        <a class="navbar-brand d-flex align-items-center me-1" href="controladorseccion?seccion=inicio">
                            <img src="${pageContext.request.contextPath}/recursos/logoveet.png" alt="logovet" class="logo-animado" style="width: 50px;">

                        </a>
                        <div class="admin-welcome-text" >
                            <h2 class="m-0 admin-title"><span>Clínica Veterinaria 'Gallito de las Rocas'</span></h2>
                            <p class="m-0 text-muted small">¡Bienvenido a la plataforma, ${sessionScope.usuario}!</p>
                        </div>
                    </div>

                    <div class="nav-right d-flex align-items-center gap-3">

                        <div class="btn-notificaciones" data-bs-toggle="offcanvas" data-bs-target="#panelNotificaciones">
                            <span class="position-relative">
                                <i class="fa-solid fa-bell"></i>
                                <span class="position-absolute top-0 start-100 translate-middle p-1 bg-danger border border-light rounded-circle"></span>
                            </span>
                        </div>

                        <a href="${pageContext.request.contextPath}/controladorseccion?seccion=perfil" class="text-decoration-none">
                            <div class="nav-card-admin">
                                <div class="row g-0 h-100 w-100"> 
                                    <div class="col-5 h-100">
                                        <img src="${pageContext.request.contextPath}/recursos/${sessionScope.imagen}" 
                                         class="profile-img-split" 
                                         alt="Perfil">                                    
                                    </div>
                                    <div class="col-7 d-flex flex-column justify-content-center ps-2">
                                        <h5 class="card-title-admin m-0">${sessionScope.usuario} <i class="fa-solid fa-user-check"></i></h5>
                                        <p class="card-email-admin m-0">${sessionScope.correo != null ? sessionScope.correo : 'Sin correo'}</p>                                    </div>
                                </div>
                            </div>
                        </a>

                        <a href="${pageContext.request.contextPath}/controladorsalida" class="btn btn-danger d-flex align-items-center gap-2 shadow-sm">
                            <span>Salir</span>
                            <i class="fa-solid fa-arrow-right-from-bracket"></i>
                        </a>
                    </div>
                </div>
            </nav>
            <div class="offcanvas offcanvas-start" tabindex="-1" id="offcanvasNavbar" aria-labelledby="offcanvasNavbarLabel">
                <div class="offcanvas-header">
                    <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"></button>


                </div>
                <div class="offcanvas-body">
                    <a class="navbar-brand logo ms-1 me-2" href="controladorseccion?seccion=inicio">
                        <img src="${pageContext.request.contextPath}/recursos/logoveet.png" style="margin: 10px;" alt="logovet">                    
                        <h5 class="offcanvas-title" id="offcanvasNavbarLabel"> Clinica Veterinaria <br>
                            “Gallito de las Rocas”</h5>
                        <span class="text-body-secondary">
                            <p>Panel Administrador</p>
                        </span>



                    </a>
                    <ul class="navbar-nav justify-content-end flex-grow-1 pe-3">
                        <li class="nav-item">
                            <a class="nav-link ${paginaActual == 'inicio' ? 'active' : ''}"  href="${pageContext.request.contextPath}/controladorseccion?seccion=inicio"><span style="margin-right: 5px;"><i class="fa-solid fa-house-chimney"></i></span>Inicio</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link ${paginaActual == 'citas' ? 'active' : ''}" href="${pageContext.request.contextPath}/controladorseccion?seccion=citas"><span style="margin-right: 5px;"><i class="fa-solid fa-calendar-day"></i></span>Citas</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link ${paginaActual == 'inventario' ? 'active' : ''}" href="${pageContext.request.contextPath}/controladorseccion?seccion=inventario"><span style="margin-right: 5px;"><i class="fa-solid fa-boxes-stacked"></i></span>Inventario</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link ${paginaActual == 'ventas' ? 'active' : ''}" href="${pageContext.request.contextPath}/controladorseccion?seccion=ventas"><span style="margin-right: 5px;"><i class="fa-solid fa-tags"></i></span>Ventas</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link ${paginaActual == 'clientes' ? 'active' : ''}" href="${pageContext.request.contextPath}/controladorseccion?seccion=clientes"><span style="margin-right: 5px;"><i class="fa-solid fa-people-group"></i></span>Clientes</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link ${paginaActual == 'mascotas' ? 'active' : ''}" href="${pageContext.request.contextPath}/controladorseccion?seccion=mascotas"><span style="margin-right: 5px;"><i class="fa-solid fa-paw"></i></span>Mascotas</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link ${paginaActual == 'usuarios' ? 'active' : ''}" href="${pageContext.request.contextPath}/controladorseccion?seccion=usuarios"><span style="margin-right: 5px;"><i class="fa-solid fa-users"></i></span>Usuarios</a>
                        </li>

                        <li class="nav-item">
                            <a class="nav-link ${paginaActual == 'perfil' ? 'active' : ''}" href="${pageContext.request.contextPath}/controladorseccion?seccion=perfil"><span style="margin-right: 5px;"><i class="fa-solid fa-circle-user"></i></span>Perfil</a>
                        </li>
                    </ul>

                    <div class="d-flex align-items-center gap-3" style="margin-top: 20px;">
                        <a href="${pageContext.request.contextPath}/controladorsalida" class="btn btn-danger d-flex align-items-center gap-2 shadow-sm">
                            <span>Salir</span>
                            <i class="fa-solid fa-arrow-right-from-bracket"></i>
                        </a>
                    </div>

                </div>
            </div>                        
            <div class="offcanvas offcanvas-end offcanvas-notificaciones" tabindex="-1" id="panelNotificaciones">
                <div class="offcanvas-header shadow-sm">
                    <h5 class="offcanvas-title fw-bold">
                        Mis Avisos
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="offcanvas"></button>
                </div>
                <div class="offcanvas-body p-0">
                    <jsp:include page="/componentes/notificaciones.jsp" />
                </div>
            </div>
        </header>
    </c:when>    

    <c:when test="${sessionScope.rol == 'cliente'}">
        <header>
            <nav class="navbar navbar-expand-lg fixed-top shadow-sm nav-cliente-custom">
                <div class="container-fluid" style="padding: 5px 20px;">

                    <div class="btn-notificaciones ms-2 me-4" data-bs-toggle="offcanvas" data-bs-target="#panelNotificaciones">
                        <span class="position-relative">
                            <i class="fa-solid fa-bell"></i>
                            <span class="position-absolute top-0 start-100 translate-middle p-1 bg-danger border border-light rounded-circle"></span>
                        </span>
                    </div>

                    <a class="navbar-brand d-flex align-items-center gap-2 me-5" href="controladorpagina?pagina=inicio">
                        <img src="${pageContext.request.contextPath}/recursos/logoveet.png" alt="logovet" class="logo-animado" style="width: 60px;">
                        <div class="titulo-moderno">
                            <span class="txt-verde">Clínica Veterinaria <br></span>
                            <span class="txt-destello" style="font-size: 1.3rem;">“Gallito de las Rocas”</span>
                        </div>
                    </a>

                    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarCliente">
                        <span class="navbar-toggler-icon"></span>
                    </button>

                    <div class="collapse navbar-collapse" id="navbarCliente">
                        <ul class="navbar-nav me-auto mb-2 mb-lg-0 gap-4">
                            <li class="nav-item text-center">
                                <a href="controladorpagina?pagina=inicio" class="nav-link nav-link-veterinaria ${paginaActual == 'inicio' ? 'active' : ''}">
                                    <span style="margin-right: 5px;"><i class="fa-solid fa-house-chimney"></i></span>Inicio
                                </a>
                            </li>
                            <li class="nav-item text-center">
                                <a href="controladorpagina?pagina=agendarcitas" class="nav-link nav-link-veterinaria ${paginaActual == 'agendarcitas' ? 'active' : ''}">
                                    <span style="margin-right: 5px;"><i class="fa-solid fa-calendar-plus"></i></span>Agendar citas
                                </a>
                            </li>
                            <li class="nav-item text-center">
                                <a href="controladorpagina?pagina=miscitas" class="nav-link nav-link-veterinaria ${paginaActual == 'miscitas' ? 'active' : ''}">
                                    <span style="margin-right: 5px;"><i class="fa-solid fa-calendar-day"></i></span> Mis citas
                                </a>
                            </li>
                        </ul>

                        <div class="d-flex align-items-center gap-3">
                            <a href="controladorpagina?pagina=miperfil" class="btn btn-outline-success border-2 fw-bold rounded-pill px-3 btn-perfil ${paginaActual == 'miperfil' ? 'active' : ''}">
                                <i class="fa-solid fa-user-check" ></i> ¡Hola, ${sessionScope.usuario}!
                            </a>
                            <a href="controladorsalida" class="btn-salir-limpio">
                                <i class="fa-solid fa-door-open"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </nav>

            <div class="offcanvas offcanvas-start offcanvas-notificaciones" tabindex="-1" id="panelNotificaciones">
                <div class="offcanvas-header shadow-sm">
                    <h5 class="offcanvas-title fw-bold">
                        Mis Avisos
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="offcanvas"></button>
                </div>
                <div class="offcanvas-body p-0">
                    <jsp:include page="/componentes/notificaciones.jsp" />
                </div>
            </div>
        </header>
    </c:when>



    <c:otherwise>
        <header>
            <nav class="navbar fixed-top nav-veterinaria">
                <div class="container-fluid d-flex justify-content-center">
                    <a class="navbar-brand brand-centrado" href="controladorpagina?pagina=login">
                        <img src="recursos/logoveet.png" alt="Logo" class="logo-animado" style="width: 70px;">
                        <h1 class="titulo-moderno">
                            <span class="txt-verde">Sistema Web de Clínica Veterinaria</span>
                            <span class="txt-destello">“GALLITO DE LAS ROCAS”</span>
                        </h1>
                    </a>


                </div>
            </nav>
        </header>

    </c:otherwise>

</c:choose>
