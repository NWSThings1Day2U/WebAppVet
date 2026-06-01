<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div class="row g-0 h-100">
    <div class="col-md-5 d-none d-md-block">
        <img src="${pageContext.request.contextPath}/recursos/ga4.JPG" class="img-fluid rounded-start h-100" 
             alt="gallitoingreso" 
             style="object-fit: cover; object-position: center; width: 100%;">
    </div>
    <div class="col-md-7">
        <div class="card-body p-6">
            <h2 class="card-title" style="text-align: center; margin: 30px; color: #09752F; font-weight: 600; font-size: 1.8rem;">
                Restablecer Contraseña
            </h2>
            <div class="card-text p-6">
                <div class="container-fluid px-4">
                    <form action="controladorusuario" id="formRegistro" method="POST" class="needs-validation" novalidate>
                        <input type="hidden" name="accion" value="registro">

                        

                        <div class="row mb-4">
                            <div class="col-md-12">
                                <label class="form-label" for="mail">Correo Electrónico: </label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fa-solid fa-at"></i></span>
                                    <input type="email" class="form-control" name="mail" required id="mail"
                                           placeholder="Ingrese tu usuario o correo">
                                    <div class="invalid-feedback">Correo no válido.</div>
                                </div>
                                <p class="card-text mt-3">
                                    <small class="text-body-secondary">
                                        Recuerda ingresar el correo electrónico con el cual fue creado la cuenta del sistema 
                                        y te enviaremos instrucciones para restablecer tu contraseña.
                    
                                    </small>
                                </p>
                            </div>
                            
                        </div>
                       <!-- comment
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
 -->
                        <button type="submit" class="btn btn-primary w-100 mb-2"> Enviar   <span style="margin-left: 5px"><i class="fa-solid fa-paper-plane"></i></span></button>
                    </form>
                </div>                            
            </div>
            <p class="card-text text-center mt-3 mb-3">
                <small class="text-body-secondary">¿Volver al inicio? 
                    <a href="index.jsp?modo=login" class="link-vet-card">Inicia Sesión</a>
                </small>
            </p>
        </div>
    </div>
</div>
