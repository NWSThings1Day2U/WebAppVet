<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div class="row g-0 h-100">
    <div class="col-md-5 d-none d-md-block">
        <img src="recursos/gaa.jpg" class="img-fluid rounded-start h-100" alt="gallitoingreso" style="object-fit: cover; object-position: left; width: 100%;">
    </div>
    <div class="col-md-7">
        <div class="card-body p-4">
            <h5 class="card-title" style="text-align: center; margin: 30px; color: #09752F; font-weight: 600; font-size: 1.8rem;">Iniciar sesión</h5>
            <div class="card-text">
                <div class="container-fluid px-4">
                    <form action="controladorusuario" id="formLogin" method="POST" class="needs-validation" novalidate>
                        <input type="hidden" name="accion" value="login">

                        <%
                            String userCookie = "";
                            Cookie[] cookies = request.getCookies();
                            if (cookies != null) {
                                for (Cookie c : cookies) {
                                    if (c.getName().equals("user_vet")) {
                                        userCookie = c.getValue();
                                    }
                                }
                            }
                        %>

                        <div class="mb-4"> 
                            <label class="form-label">Nombre de Usuario:</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fa-solid fa-user"></i></span>
                                <input type="text" class="form-control" name="usuario"   value="<%= userCookie %>"  required 
                                       minlength="4" maxlength="20" pattern="^[a-zA-Z0-9_]+$" 
                                       placeholder="Ingresa tu nombre de usuario">
                                <div class="invalid-feedback">
                                    Mínimo 4 caracteres (solo letras, números y "_").
                                </div>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label">Contraseña:</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fa-solid fa-lock"></i></span>
                                <input type="password" class="form-control" name="contrasena" id="contrasena" 
                                       required minlength="6" placeholder="Ingresa tu contraseña">
                                <span class="input-group-text" id="togglePassword" style="border-left: none; cursor: pointer;">
                                    <i class="fa-regular fa-eye" id="eyeIcon"></i>
                                </span>
                                <div class="invalid-feedback">
                                    La contraseña debe tener al menos 6 caracteres.
                                </div>
                            </div>
                        </div>

                        <div class="mb-4 form-check">
                            <input type="checkbox" class="form-check-input" id="recordar" name="recordar" <%= !userCookie.isEmpty() ? "checked" : "" %>>
                            <label class="form-check-label" for="recordar">Recuérdame</label>
                        </div>

                        <button type="submit" class="btn btn-primary w-100 mb-2">Ingresar <span style="margin-left: 5px"><i class="fa-solid fa-arrow-right-to-bracket"></i> </span></button>
                    </form>
                </div>                            
            </div>
            <p class="card-text text-center mt-3">
                <small class="text-body-secondary">¿No tienes cuenta? <a href="index.jsp?modo=registro" style="color: #CC4607; text-decoration: none; font-weight: bold;">Regístrate</a></small>
            </p>
        </div>
    </div>
</div>

<script>
    (function () {
        'use strict';
        const forms = document.querySelectorAll('.needs-validation');
        Array.from(forms).forEach(form => {
            form.addEventListener('submit', event => {
                if (!form.checkValidity()) {
                    event.preventDefault();
                    event.stopPropagation();
                }
                form.classList.add('was-validated');
            }, false);
        });
    })();

    const btnToggle = document.getElementById('togglePassword');
    if (btnToggle) {
        btnToggle.addEventListener('click', function () {
            const input = document.getElementById('contrasena');
            const icon = document.getElementById('eyeIcon');

            if (input.type === "password") {
                input.type = "text";
                icon.classList.replace('fa-eye', 'fa-eye-slash');
            } else {
                input.type = "password";
                icon.classList.replace('fa-eye-slash', 'fa-eye');
            }

            this.classList.toggle('active');
            input.classList.toggle('is-visible');
        });
    }
</script>
