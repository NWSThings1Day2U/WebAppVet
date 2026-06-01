<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div class="row g-0 h-100">
    <div class="col-md-5 d-none d-md-block">
        <img src="${pageContext.request.contextPath}/recursos/ga4.JPG" class="img-fluid rounded-start h-100" 
             alt="gallitorecuperar" 
             style="object-fit: cover; object-position: center; width: 100%;">
    </div>
    <div class="col-md-7">
        <div class="card-body p-6">
            <h2 class="card-title " style="text-align: center; margin: 30px; color: #09752F; font-weight: 600; font-size: 1.8rem;">
                Recuperar Acceso
            </h2>
            
            <div class="card-text p-6">
                <div class="container-fluid px-4">
                    <!-- WIZARD -->
                    <div class="step-container px-3" style=" font-size: 0.5rem !important;">

                        <div class="step-line" > <div id="line-progress" class="step-line-bar"></div></div>
                        <div class="step-item" ><div id="step-1" class="step-circle step-active"><i class="fa-solid fa-lock"></i></div><span id="text-1" class="step-text fw-bold">Recuperar</span></div>
                        <div class="step-item"><div id="step-2" class="step-circle step-pending"><i class="fa-solid fa-key"></i></div><span id="text-2" class="step-text text-muted">Restablecer</span></div>
                        <div class="step-item" ><div id="step-3" class="step-circle step-pending"><i class="fa-solid fa-circle-check"></i></div><span id="text-3" class="step-text text-muted">Completado</span></div>
                    </div>
                    <form action="controladorsena" id="formRecuperar" method="POST" class="needs-validation" novalidate>
                        <input type="hidden" name="accion" value="recuperar">
                        <!-- PASO 1: EMAIL -->
                        <div id="content-step-1">
                            <p class="card-text mt-3">
                                <small class="text-body-secondary">
                                    Recuerda ingresar el correo electrónico con el cual fue creado la cuenta del sistema 
                                    y te enviaremos un código.

                                </small>
                            </p>

                            <div class="row mb-4">
                                <div class="col-md-12">

                                    <label class="form-label" for="mail">Correo Electrónico: </label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fa-solid fa-at"></i></span>
                                        <input type="email" class="form-control" name="mail" required id="mail"
                                               placeholder="Ingrese tu correo">
                                        <div class="invalid-feedback">Correo no válido.</div>
                                    </div>

                                </div>

                            </div>
                                <button type="button" class="btn btn-primary w-100 mt-3 mb-3" onclick="irAlPaso(2)"> Enviar   <span style="margin-left: 5px"><i class="fa-solid fa-paper-plane"></i></span></button>

                        </div> 
                        
                        <!-- CONTENIDO PASO 2 -->
                        <div id="content-step-2" style="display: none;">

                            <div class="row mb-4">
                                <div class="col-md-12">

                                    <label class="form-label" for="codigo">Código recibido: </label>
                                    <div class="input-group">
                                        <div class="d-flex justify-content-center gap-2" id="codigo">
                                            <input type="text" class="form-control text-center otp-input" maxlength="1" required>
                                            <input type="text" class="form-control text-center otp-input" maxlength="1" required>
                                            <input type="text" class="form-control text-center otp-input" maxlength="1" required>
                                            <input type="text" class="form-control text-center otp-input" maxlength="1" required>
                                            <input type="text" class="form-control text-center otp-input" maxlength="1" required>
                                            <input type="text" class="form-control text-center otp-input" maxlength="1" required>
                                            <button class="btn btn-success"><i class="fa-solid fa-check"></i></button>
                                            <button class="btn btn-success"><i class="fa-solid fa-arrows-rotate"></i></button>

                                        </div>
                                        <div class="invalid-feedback">Código no válido.</div>
                                    </div>
                                    
                                </div>
                                

                            </div>
                            <div class="row mb-4">
                                        <div class="col-md-6">
                                            <label class="form-label" for="reg_pass">Nueva Contraseña: </label>
                                            <div class="input-group">
                                                <input type="password" class="form-control editable" name="contrasena" id="reg_pass" 
                                                       minlength="6"  ${not empty sessionScope.error ? '' : 'disabled'}>
                                                <span class="input-group-text" id="togglePassword1" style="border-left: none; cursor: pointer;">
                                                    <i class="fa-regular fa-eye" id="eyeIcon1"></i>
                                                </span>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label" for="reg_pass_conf">Confirmar Contraseña: </label>
                                            <div class="input-group">
                                                <input type="password" class="form-control editable" name="confirmar_contrasena" id="reg_pass_conf" 
                                                   minlength="6"  ${not empty sessionScope.error ? '' : 'disabled'}>
                                                <span class="input-group-text" id="togglePassword2" style="border-left: none; cursor: pointer;">
                                                    <i class="fa-regular fa-eye" id="eyeIcon2"></i>
                                                </span>
                                            </div>
                                        </div>
                                    </div>
<div class="d-flex justify-content-between ">
                        <button type="button" class="btn btn-outline-secondary mt-3 mb-3" onclick="irAlPaso(1)">Atrás</button>
                        <button type="button" class="btn btn-primary w-80 mt-3 mb-3" onclick="irAlPaso(3)">Guardar Cambios <span style="margin-left: 5px"><i class="fa-solid fa-check-double"></i></span></button>
                    </div>
                        </div>
                                                
                         <!-- CONTENIDO PASO 3 -->
    <div id="content-step-3" style="display: none;" class="text-center py-4">
      <h4 class="fw-bold text-dark mb-2">¡Cambios Guardados!</h4>
      <p class="text-muted small px-3 mb-4">Tu contraseña ha sido actualizada correctamente en el sistema. Ya puedes ingresar sin inconvenientes.</p>
      <div>
    </div>                       
                       
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

<script>
// --- Lógica del Wizard ---
function irAlPaso(paso) {
    // 1. Visibilidad de contenidos
    document.getElementById('content-step-1').style.display = (paso === 1) ? 'block' : 'none';
    document.getElementById('content-step-2').style.display = (paso === 2) ? 'block' : 'none';
    document.getElementById('content-step-3').style.display = (paso === 3) ? 'block' : 'none';
    
    // 2. Progreso de la línea (0%, 50%, 100%)
    const bar = document.getElementById('line-progress');
    bar.style.width = (paso === 1) ? '0%' : (paso === 2 ? '50%' : '100%');
    
    // 3. Estados de los círculos
    document.getElementById('step-1').className = (paso >= 1) ? 'step-circle step-active' : 'step-circle step-pending';
    document.getElementById('step-2').className = (paso >= 2) ? 'step-circle step-active' : 'step-circle step-pending';
    document.getElementById('step-3').className = (paso >= 3) ? 'step-circle step-active' : 'step-circle step-pending';
    
    // Actualizar texto de los pasos
    document.getElementById('text-1').className = (paso === 1) ? 'step-text fw-bold' : 'step-text text-muted';
    document.getElementById('text-2').className = (paso === 2) ? 'step-text fw-bold' : 'step-text text-muted';
    document.getElementById('text-3').className = (paso === 3) ? 'step-text fw-bold' : 'step-text text-muted';
}
// --- Lógica OTP ---
document.querySelectorAll('.otp-input').forEach((input, index, inputs) => {
    input.addEventListener('input', (e) => {
        if (e.target.value.length === 1 && index < inputs.length - 1) inputs[index + 1].focus();
        if (e.target.value.length === 0 && index > 0) inputs[index - 1].focus();
    });
});

// --- Lógica Toggles Password ---
function setupToggle(btnId, inputId, iconId) {
    const btn = document.getElementById(btnId);
    const input = document.getElementById(inputId);
    const icon = document.getElementById(iconId);
    btn.addEventListener('click', () => {
        const type = input.type === 'password' ? 'text' : 'password';
        input.type = type;
        icon.className = type === 'password' ? 'fa-regular fa-eye' : 'fa-regular fa-eye-slash';
    });
}
setupToggle('togglePassword1', 'reg_pass', 'eyeIcon1');
setupToggle('togglePassword2', 'reg_pass_conf', 'eyeIcon2');
</script>