<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="row g-0 h-100">
    <div class="col-md-5 d-none d-md-block">
        <img src="recursos/gaa2.jpg" class="img-fluid rounded-start h-100" 
             alt="gallitoingreso" 
             style="object-fit: cover; object-position: center; width: 100%;">
    </div>
    <div class="col-md-7">
        <div class="card-body p-6">
            <h2 class="card-title" style="text-align: center; margin: 30px; color: #09752F; font-weight: 600; font-size: 1.8rem;">
                Registrar Cuenta
            </h2>
            <div class="card-text p-6">
                <div class="container-fluid px-4">
                    <form action="controladorusuario" id="formRegistro" method="POST" class="needs-validation" novalidate>
                        <input type="hidden" name="accion" value="registro">

                        <div class="row mb-4">
                            <div class="col-md-6">
                                <label class="form-label" for="nombrecompleto">Nombre Completo: </label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fa-solid fa-user"></i></span>
                                    <input type="text" class="form-control" name="nombre" required id="nombrecompleto"
                                           pattern="^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$" placeholder="Ingresa tu nombre completo">
                                    <div class="invalid-feedback">Solo letras.</div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label" for="documentodeidentidad">Dni: </label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fa-solid fa-id-badge"></i></span>
                                    <input type="text" class="form-control val-numero" name="dni" required  id="documentodeidentidad"
                                           maxlength="8" pattern="\d{8}" placeholder="Ingresa tu Dni">
                                    <div class="invalid-feedback">Deben ser 8 dígitos.</div>
                                </div>
                            </div>
                        </div>

                        <div class="row mb-4">
                            <div class="col-md-6">
                                <label class="form-label" for="correo">Correo Electrónico: </label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fa-solid fa-envelope"></i></span>
                                    <input type="email" class="form-control" name="correo" required id="correo"
                                           placeholder="Ingresa tu correo">
                                    <div class="invalid-feedback">Correo no válido.</div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label" for="nrotelefono">Teléfono: </label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fa-solid fa-phone"></i></span>
                                    <input type="text" class="form-control val-numero" name="telefono" required  id="nrotelefono"
                                           maxlength="9" pattern="9\d{8}" placeholder="Ingresa tu nro telefonico">
                                    <div class="invalid-feedback">Debe empezar con 9 y tener 9 dígitos.</div>
                                </div>
                            </div>
                        </div>

                        <div class="row mb-4">
                            <div class="col-md-6">
                                <label class="form-label" for="reg_pass">Contraseña: </label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fa-solid fa-lock"></i></span>
                                    <input type="password" class="form-control" name="contrasena" id="reg_pass" 
                                           required minlength="6" placeholder="Ingresa tu contraseña">
                                    
                                    <span class="input-group-text" id="togglePassword1" style="border-left: none; cursor: pointer;">
                                        <i class="fa-regular fa-eye" id="eyeIcon1"></i>
                                    </span>
                                    <div class="invalid-feedback">Mínimo 6 caracteres.</div>
                                    
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label" for="reg_pass_conf">Confirmar Contraseña: </label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fa-solid fa-lock"></i></span>
                                    <input type="password" class="form-control" name="confirmar_contrasena" id="reg_pass_conf" minlength="6"
                                           required placeholder="Ingresa nuevamente tu contraseña">
                                    <span class="input-group-text" id="togglePassword2" style="border-left: none; cursor: pointer;">
                                        <i class="fa-regular fa-eye" id="eyeIcon2"></i>
                                    </span>
                                    <div class="invalid-feedback" id="pass_match_error">Las contraseñas no coinciden.</div>
                                </div>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-primary w-100 mb-2"> Registrarse   <span style="margin-left: 5px"><i class="fa-solid fa-user-plus"></i></span></button>
                    </form>
                </div>                            
            </div>
            <p class="card-text text-center mt-3 mb-3">
                <small class="text-body-secondary">¿Ya tienes cuenta? 
                    <a href="index.jsp?modo=login" class="link-vet-card">Inicia Sesión</a>
                </small>
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
                const p1 = document.getElementById('reg_pass');
                const p2 = document.getElementById('reg_pass_conf');

                if (p1 && p2 && p1.value !== p2.value) {
                    p2.setCustomValidity('Invalid');
                } else if (p2) {
                    p2.setCustomValidity('');
                }

                if (!form.checkValidity()) {
                    event.preventDefault();
                    event.stopPropagation();
                }                    
                form.classList.add('was-validated');
            }, false);
        });

        document.querySelectorAll('.val-numero').forEach(input => {
            input.addEventListener('input', function() {
                this.value = this.value.replace(/\D/g, '');
            });
        });
    })();
    
    function setupPasswordToggle(buttonId, inputId, iconId) {
        const btn = document.getElementById(buttonId);
        const input = document.getElementById(inputId);
        const icon = document.getElementById(iconId);

        if (btn && input && icon) {
            btn.addEventListener('click', function () {
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
    }

    setupPasswordToggle('togglePassword1', 'reg_pass', 'eyeIcon1');
    setupPasswordToggle('togglePassword2', 'reg_pass_conf', 'eyeIcon2');


</script>
