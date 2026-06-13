

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Perfil</title>
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

        <link rel="stylesheet" href="${pageContext.request.contextPath}/estilos/contenidoadmin.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/estilos/esadmin.css">
    </head>
    <body>
        <%
            request.setAttribute("paginaActual", "perfil");
        %>
        <jsp:include page="../componentes/encabezado.jsp" />
        <main class="container mt-5 pt-4 contenido-admin" style="margin-top: 180px; margin-bottom: 150px;"> 
            <div class="container-fluid">
                <div class="card-bienvenida mb-4">
                        <div class="row align-items-center">
                            <div class="col-lg-8">
                                <h1 class="fw-bold mb-2">
                                    Perfil de
                                    <span class="text-success">
                                        Administrador
                                    </span>
                                </h1>
                                <p class="text-muted mb-0">
                                    Maneja tu cuenta y preferencias.
                                </p>
                            </div>
                        <!-- fecha -->
                        <div class="col-lg-4 text-lg-end mt-3 mt-lg-0">
                            <div class="fecha-box">
                                <i class="fa-solid fa-user-gear"></i>
                                <span id="fechaHora"></span>
                            </div>
                        </div>
                    </div>
                 </div>
                
                <div class="perfil-card">
                <div class="row g-0 h-100">
                    <!-- img perfil 11-06-26 -->
                    <div class="col-md-5 d-flex flex-column justify-content-center align-items-center">
                            <img id="previewImagen"
                                 src="${pageContext.request.contextPath}/recursos/${sessionScope.imagen}"
                                 alt="Foto Perfil"
                                 class="shadow"
                                 style="
                                    width:320px;
                                    height:320px;
                                    object-fit:cover;
                                    object-position:center;
                                    border-radius:50%;
                                    border:5px solid #f1f1f1;
                                                     ">
                            <div id="contenedorImagen"
                                 class="text-center mt-3"
                                 style="display:none;">
                                <label class="form-label fw-bold">
                                    Cambiar foto de perfil
                                </label>
                                <input type="file"
                                       id="imagenPerfil"
                                       name="imagenPerfil"
                                       form="formPerfil">
                            </div>
                        </div>                 
                             
                    <div class="col-md-7">
                        <div class="card-body p-4 m-4">
                            
                            <form action="controladorperfil"
                                  method="POST"
                                  enctype="multipart/form-data"
                                  id="formPerfil">
                            
                            <div class="row mb-4 align-items-center">
                                <div class="col-auto">
                                    <div class="d-flex align-items-center justify-content-center icon-perfil-vet" >
                                        <i class="fa-solid fa-user fs-5"></i>
                                    </div>
                                </div>

                                <div class="col">
                                    <h4 class="m-0 subtitulo-vet">
                                        Información Personal
                                    </h4>
                                </div>
                            </div>                                                

                                <div class="row mb-4">
                                    <div class="col-md-6">
                                        <label class="form-label">Nombre de Usuario: </label>
                                        <input type="text" class="form-control " name="nombreUsuario" 
                                               value="${datosUsuario.nombreusuario}" readonly ${not empty sessionScope.error ? '' : 'disabled'}>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">ID: </label>
                                        <input type="number" class="form-control " value="${datosUsuario.idUsuario}" readonly disabled>
                                    </div>
                                </div>

                                <div class="row mb-4">
                                    <div class="col-md-6">
                                        <label class="form-label">Nombre completo: </label>
                                        <input type="text" class="form-control  editable" name="nombreCompleto"  pattern="^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$"
                                               value="${datosUsuario.nombrecompleto}" required 
                                               ${not empty sessionScope.error ? '' : 'disabled'}>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">DNI: </label>
                                        <input type="text" class="form-control " maxlength="8" pattern="\d{8}" value="${datosUsuario.dni}" readonly disabled>
                                    </div>
                                </div>

                                <div class="row mb-4">
                                    <div class="col-md-6">
                                        <label class="form-label">Nro. Telefónico: </label>
                                        <input type="text" class="form-control editable" name="telefono" 
                                               value="${datosUsuario.telefono}" required 
                                               ${not empty sessionScope.error ? '' : 'disabled'} pattern="9\d{8}" maxlength="9" 
                                               title="El teléfono debe empezar con 9 y tener 9 dígitos numéricos.">
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">Correo Electrónico: </label>
                                        <input type="email" class="form-control editable" name="correo" 
                                               value="${datosUsuario.correo}" required 
                                               ${not empty sessionScope.error ? '' : 'disabled'} pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$"
                                               title="Ingrese un correo electrónico válido (ejemplo@dominio.com)">
                                    </div>
                                </div>

                                <div id="seccionPassword" style="display: ${not empty sessionScope.error ? 'block' : 'none'};">
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
                                </div>
                                        <!-- INPUT PARA SUBIR IMAGEN DE
                                        <div class="input-group mb-3">
  <label class="input-group-text" for="inputGroupFile01">Upload</label>
  <input type="file" class="form-control" id="inputGroupFile01">
</div> -->       
                                <button type="button" id="btnEditar" class="btn btn-vet-principal w-100 mb-2" 
                                        style="display: ${not empty sessionScope.error ? 'none' : 'block'};">
                                    <i class="fa-solid fa-pencil me-2"></i> Editar información
                                </button>

                                <button type="submit" id="btnGuardar" class="btn btn-vet-principal w-100 mb-2" 
                                        style="display: ${not empty sessionScope.error ? 'block' : 'none'};">
                                    <i class="fa-solid fa-floppy-disk me-2"></i> Guardar cambios
                                </button>
                                    
                                <button type="button" id="btnCancelar" class="btn btn-outline-secondary w-100 mb-2"
                                        style="display:none;">
                                    <i class="fa-solid fa-xmark me-2"></i> Cancelar
                                </button>
                                    
                            </form>
                            <script>
                                document.getElementById('btnEditar').addEventListener('click', function () {
                                    
                                    document.querySelectorAll('.editable').forEach(campo => {
                                        campo.disabled = false;
                                    });
                                    document.getElementsByName('nombreUsuario')[0].disabled = false;

                                    document.getElementById('seccionPassword').style.display = 'block';

                                    document.getElementById('contenedorImagen').style.display = 'block';

                                    document.getElementById('btnGuardar').style.display = 'block';

                                    document.getElementById('btnCancelar').style.display = 'block';

                                    document.getElementById('btnEditar').style.display = 'none';
                                });
                                
                                document.getElementById('btnCancelar').addEventListener('click', function () {
                                    location.reload();
                                });
                                
                                document.getElementById('imagenPerfil').addEventListener('change', function (e) {
                                    const archivo = e.target.files[0];
                                    if (!archivo) return;
                                    const lector = new FileReader();
                                    lector.onload = function (ev) {
                                        document.getElementById('previewImagen').src =
                                                ev.target.result;
                                    };
                                    lector.readAsDataURL(archivo);
                                });
                                
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
                        </div>
                    </div>
                </div>
            </div>
            </div>
        </main>
        <!-- Bootstrap y alertify -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="//cdn.jsdelivr.net/npm/alertifyjs@1.13.1/build/alertify.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <jsp:include page="/componentes/mensajes.jsp" />
        <script>
            function actualizarFecha() {
                const fecha = new Date();
                const opciones = {
                    weekday: 'long',
                    year: 'numeric',
                    month: 'long',
                    day: 'numeric'
                };
                document.getElementById("fechaHora").innerHTML =
                    fecha.toLocaleDateString('es-ES', opciones)
                    + " | " +
                    fecha.toLocaleTimeString();
            }  
            actualizarFecha();
            setInterval(actualizarFecha, 1000);
        </script>
    </body>
</html>
