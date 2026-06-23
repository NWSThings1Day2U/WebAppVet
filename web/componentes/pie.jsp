
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<style>
    /* ================= FOOTER ================= */

.footer-publico,
.footer-cliente {
    background: #09752F;
    color: white;
    padding: 50px 0 20px;
    margin-top: 60px;
}

.footer-publico h4,
.footer-publico h5,
.footer-cliente h5 {
    font-weight: 700;
    margin-bottom: 15px;
}

.footer-publico a,
.footer-cliente a {
    display: block;
    color: #ffcc99;
    text-decoration: none;
    margin-bottom: 8px;
    transition: .3s;
}

.footer-publico a:hover,
.footer-cliente a:hover {
    color: white;
    padding-left: 4px;
}

.footer-logo {
    width: 45px;
    margin-right: 10px;
}

.footer-redes {
    display: flex;
    gap: 12px;
}

.footer-redes a {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    background: rgba(255,255,255,.15);
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
}

.footer-redes a:hover {
    background: #CC4607;
    color: white;
}

.footer-copy {
    text-align: center;
    font-size: .9rem;
    color: rgba(255,255,255,.8);
}

/* ================= ADMIN ================= */

.footer-admin {
    background: #ffffff;
    border-top: 2px solid #09752F;
    padding: 20px;
    margin-top: 40px;
}

.footer-admin-content {
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.footer-logo-mini {
    width: 40px;
    margin-right: 10px;
}

.footer-redes-mini {
    display: flex;
    gap: 12px;
}

.footer-redes-mini a {
    width: 35px;
    height: 35px;
    border-radius: 50%;
    background: #f1f1f1;
    display: flex;
    justify-content: center;
    align-items: center;
    color: #09752F;
    text-decoration: none;
}

.footer-redes-mini a:hover {
    background: #CC4607;
    color: white;
}
</style>
<c:choose>

    <c:when test="${sessionScope.rol == 'admin'}">

        <footer class="footer-admin">
            <div class="container">
                <div class="footer-admin-content">
                    <div>
                        <img src="${pageContext.request.contextPath}/recursos/logoveet.png"
                             alt="Logo"
                             class="footer-logo-mini">
                        <span>Clínica Veterinaria Gallito de las Rocas</span>
                    </div>

                    <div class="footer-redes-mini">
                        <a href="https://www.facebook.com/profile.php?id=100040741785245" target="_blank">
                            <i class="fa-brands fa-facebook-f"></i>
                        </a>

                        <a href="mailto:rhtelloportilla@gmail.com">
                            <i class="fa-solid fa-envelope"></i>
                        </a>

                        <a href="https://m.me/100040741785245" target="_blank">
                            <i class="fa-brands fa-facebook-messenger"></i>
                        </a>
                    </div>
                </div>

                <hr>

                <p class="footer-copy" style="color:#64748b !important;">
                    © 2026 Clínica Veterinaria Gallito de las Rocas | <span style="color: #E65100; font-weight: bold;">Sistema Administrativo</span>
                </p>
            </div>
        </footer>

    </c:when>

    <c:when test="${sessionScope.rol == 'cliente'}">

        <footer class="footer-cliente">

            <div class="container">

                <div class="row gy-4">

                    <div class="col-md-4">
                        <h5>
                            <img src="${pageContext.request.contextPath}/recursos/logoveet.png"
                                 class="footer-logo"
                                 alt="logo">
                            Gallito de las Rocas
                        </h5>

                        <p>
                            Cuidamos la salud y bienestar de tus mascotas con
                            atención profesional y especializada.
                        </p>
                    </div>

                    <div class="col-md-3">
                        <h5>Accesos rápidos</h5>

                        <a href="controladorpagina?pagina=inicio">Inicio</a>
                        <a href="controladorpagina?pagina=agendarcitas">Agendar citas</a>
                        <a href="controladorpagina?pagina=miscitas">Mis citas</a>
                        <a href="controladorpagina?pagina=miperfil">Mi perfil</a>
                    </div>

                    <div class="col-md-5">
                        <h5>Contacto</h5>

                        <p>
                            <i class="fa-solid fa-phone"></i>
                            +51 999 999 999
                        </p>

                        <p>
                            <i class="fa-solid fa-envelope"></i>
                            rhtelloportilla@gmail.com
                        </p>

                        <div class="footer-redes">
                            <a href="https://www.facebook.com/profile.php?id=100040741785245" target="_blank">
                                <i class="fa-brands fa-facebook-f"></i>
                            </a>

                            <a href="mailto:rhtelloportilla@gmail.com">
                                <i class="fa-solid fa-envelope"></i>
                            </a>

                            <a href="https://m.me/100040741785245" target="_blank">
                                <i class="fa-brands fa-facebook-messenger"></i>
                            </a>
                        </div>
                    </div>

                </div>

                <hr>

                <div class="footer-copy" >
                    © 2026 Clínica Veterinaria Gallito de las Rocas
                </div>

            </div>

        </footer>

    </c:when>

    <c:otherwise>

        <footer class="footer-publico">

            <div class="container">

                <div class="row gy-4">

                    <div class="col-lg-4">
                        <h4>
                            <img src="${pageContext.request.contextPath}/recursos/logoveet.png"
                                 class="footer-logo"
                                 alt="logo">
                            Gallito de las Rocas
                        </h4>

                        <p>
                            Clínica Veterinaria especializada en la atención
                            integral de mascotas.<br>
                            Servicios en Vacunas para todas las especies de animales entre menores y mayores, 
                            <br>medicamentos para todo tipo de agentes infecciosos y parasitarios, cirugías de <br> emergencias.

                        </p>
                    </div>

                    <div class="col-lg-3">
                        <h5>Información</h5>

                        <p>
                            <i class="fa-solid fa-clock"></i>
                            Horario
                        </p>

                        <p>
                            <strong>Lun a Sab</strong>: 09:00 a.m. - 17:00 p.m.
                            <strong>Dom</strong>: 09:00 a.m. - 14:00 p.m.
                        </p>

                        <p>
                            <i class="fa-solid fa-location-dot"></i>
                            San Luis, Lima, Perú
                        </p>
                        <p>
                            <strong>Dirección: </strong>
                            <a href="https://share.google/FNl78yj6iweaye6iZ" style="text-decoration: none; color: 
                               white" >Av. Nicolás Ayllón 1077, Lima 15004</a>
                        </p>
                    </div>

                    <div class="col-lg-2">
                        <h5>Sistema Web</h5>

                        <a href="index.jsp">Iniciar sesión</a>
                        <a href="index.jsp?modo=registro">Registrarse</a>
                        <a href="index.jsp?modo=olvido">Recuperar contraseña</a>
                    </div>

                    <div class="col-lg-3">
                        <h5>Contacto</h5>

                        <p>
                            <i class="fa-solid fa-phone"></i>
                            +51 999 999 999
                        </p>

                        <p>
                            <i class="fa-solid fa-envelope"></i>
                            rhtelloportilla@gmail.com
                        </p>

                        <div class="footer-redes">
                            <a href="https://www.facebook.com/profile.php?id=100040741785245" target="_blank">
                                <i class="fa-brands fa-facebook-f"></i>
                            </a>

                            <a href="mailto:rhtelloportilla@gmail.com">
                                <i class="fa-solid fa-envelope"></i>
                            </a>

                            <a href="https://m.me/100040741785245" target="_blank">
                                <i class="fa-brands fa-facebook-messenger"></i>
                            </a>
                            <a href="https://api.whatsapp.com/send?phone=%2B51992356569&token=eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IjEyNSJ9.eyJleHAiOjE3ODIyNzM5MTksInBob25lIjoiKzUxOTkyMzU2NTY5IiwiY29udGV4dCI6IkFmaVQ4RFkxYjhadjlHRmtZVlVKOHlya2tJU1B2QXBBb3ZoNzBoSzNxMUZkel84QjEyaHlTSXhDMW94VWtjem56YUZKaXliRHY2V1QwNWsycDY1RDI3YThVaXowN21zdTdxSHY1b0pRZVEtaFZ5MDNZTndOVkVveHlycXpmQ1Q0R3ZYLUNiWmh3Q2p3SzBObDBrakJrN3ZuV0EiLCJzb3VyY2UiOiJGQl9QYWdlIiwiYXBwIjoiZmFjZWJvb2siLCJlbnRyeV9wb2ludCI6InBhZ2VfY3RhIn0.I8L6wn26-B1_p7PYnnZVxonuunqzyjKhxwg8nRYPnK8r4gMWTipTNakhqYbD2JHeKPj7b3eGosENftHZZN9QKQ&fbclid=IwY2xjawSm6aJleHRuA2FlbQIxMABicmlkETFuaXozaENRdEtYQUZWTGVEc3J0YwZhcHBfaWQQMjIyMDM5MTc4ODIwMDg5MgABHuic3RLffHYRXwdqCCG9cR_JGgphaNDDIiU_kYHA5W5MEvaWW_QccgZnbgLX_aem_evWL1x--5-Ex0cUFk5U3sg" target="_blank">
                                <i class="fa-brands fa-whatsapp"></i>
                            </a>
                        </div>
                    </div>

                </div>

                <hr>

                <div class="footer-copy">
                    © 2026 Clínica Veterinaria Gallito de las Rocas
                </div>

            </div>

        </footer>

    </c:otherwise>

</c:choose>
