

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
                
                <div class="card p-4 border-top-0 rounded-bottom mb-5" style="box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);">
                <div class="row g-0 h-100">
                    <div class="col-md-5 d-none d-md-block">
                        <img src="${pageContext.request.contextPath}/recursos/${sessionScope.imagen}" 
                             class="img-fluid rounded-start h-100" alt="Foto de perfil" 
                             style="object-fit: cover; width: 100%; min-height: 400px;">
                    </div>
                    <div class="col-md-7">
                        <div class="card-body p-4 m-4">
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
                            <form action="controladorperfil" id="formPerfil" method="POST" class="needs-validation" novalidate>

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
                                        <input type="text" class="form-control  editable" name="nombreCompleto" 
                                               value="${datosUsuario.nombrecompleto}" required 
                                               ${not empty sessionScope.error ? '' : 'disabled'}>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">DNI: </label>
                                        <input type="text" class="form-control " value="${datosUsuario.dni}" readonly disabled>
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
                                            <label class="form-label">Nueva Contraseña: </label>
                                            <input type="password" class="form-control editable" name="contrasena" 
                                                   minlength="6"  ${not empty sessionScope.error ? '' : 'disabled'}>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label">Confirmar Contraseña: </label>
                                            <input type="password" class="form-control editable" name="confirmar_contrasena" 
                                                   minlength="6"  ${not empty sessionScope.error ? '' : 'disabled'}>
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
                            </form>
                            <script>
                                document.getElementById('btnEditar').addEventListener('click', function () {
                                    const campos = document.querySelectorAll('.editable');
                                    campos.forEach(campo => campo.disabled = false);

                                    document.getElementsByName('nombreUsuario')[0].disabled = false;

                                    document.getElementById('seccionPassword').style.display = 'block';
                                    this.style.display = 'none';
                                    document.getElementById('btnGuardar').style.display = 'block';
                                });
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
