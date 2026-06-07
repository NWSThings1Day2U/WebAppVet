<%@page import="modelo.citas"%>
<%@page import="modelo.clientes"%>
<%@page import="modelo.mascotas"%>
<%@page import="dao.citadao"%>
<%@page import="java.util.List"%>
<%
    List<citas> lista = (List<citas>) request.getAttribute("listaCitas");
    List<clientes> listaClientes = (List<clientes>) request.getAttribute("listaClientes");
    List<mascotas> listaMascotas = (List<mascotas>) request.getAttribute("listaMascotas");
    
%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Mi perfil</title>
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
        <link rel="stylesheet" href="estilos/escliente.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/estilos/contenidocliente.css">
    </head>
    <body>

        <%
            request.setAttribute("paginaActual", "miperfil");
        %>
        <!-- header -->
        <jsp:include page="../componentes/encabezado.jsp" />
        <main class="container mt-5 pt-4" style="margin-top: 180px; margin-bottom: 150px;"> 
            <div class="bien-mensaje-vet">
                <h2 class="text-center titulo-vet">Mi Perfil</h2>
                <p class="text-center p-vet">Administra tu información personal y mascotas</p>
            </div>
            <div class="perfil-card ">
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
                                            <label class="form-label" for="reg_pass">Nueva Contraseña: </label>
                                            <div class="input-group">
                                                <input type="password" class="form-control editable" name="contrasena"  id="reg_pass" 
                                                       minlength="6"  ${not empty sessionScope.error ? '' : 'disabled'}>
                                                <span class="input-group-text" id="togglePassword1" style="border-left: none; cursor: pointer;">
                                                    <i class="fa-regular fa-eye" id="eyeIcon1"></i>
                                                </span>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label" for="reg_pass_conf" >Confirmar Contraseña: </label>
                                            <div class="input-group">
                                                <input type="password" class="form-control editable" name="confirmar_contrasena"  id="reg_pass_conf" 
                                                       minlength="6"  ${not empty sessionScope.error ? '' : 'disabled'}>
                                                <span class="input-group-text" id="togglePassword2" style="border-left: none; cursor: pointer;">
                                                    <i class="fa-regular fa-eye" id="eyeIcon2"></i>
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                </div>

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
            <div class="perfil-card p-5">
                <div class="row g-0 h-100"> 

                    <div class="d-flex align-items-center justify-content-between w-100 gap-3 mb-4">

                        <div class="d-flex align-items-center gap-2 ">
                            <div class="d-flex align-items-center justify-content-center icon-perfil-vet me-3">
                                <i class="fa-solid fa-dog"></i>
                            </div>
                            <h4 class="m-0 subtitulo-vet">
                                Mis Mascotas Registradas
                            </h4>
                        </div>

                        <div class="d-flex align-items-center gap-2">
                            <button class="btn btn-vet-principal text-nowrap" data-bs-toggle="modal" data-bs-target="#modalNuevaMascota">
                                <i class="fa-solid fa-plus me-2"></i>Agregar mascota
                            </button>

                            <div class="combo-cliente-container">
                                <select id="clienteFiltro" class="form-select select-custom-vet">

                                    <option value="">Seleccione Dueño</option>

                                    <% if (listaClientes != null) {
                                        for(clientes cl : listaClientes){ %>

                                        <option value="<%= cl.getIdCliente() %>">
                                            <%= cl.getNombreCompleto() %>
                                        </option>

                                    <% }
                                    } %>

                                </select>                        
                            </div>
                        </div>

                    </div>


                    <div id="contenedorMascotas"  class="d-flex flex-column gap-4">

                        <%
                        if(listaMascotas != null &&
                           !listaMascotas.isEmpty()){

                            for(mascotas m : listaMascotas){
                        %>

                        <div class="card car-vet shadow-sm m-0">

                            <h5 class="card-header sub1-vet">
                                <%= m.getNombre() %>
                            </h5>

                            <div class="card-body">

                                <strong>Especie:</strong>
                                <%= m.getEspecie() %>
                                <br>

                                <strong>Raza:</strong>
                                <%= m.getRaza() %>
                                <br>

                                <strong>Sexo:</strong>
                                <%
                                    String sexo;
                                    if (m.getSexo().equals("M")) {
                                        sexo = "Macho";
                                    } else {
                                        sexo = "Hembra";
                                    }
                                %>
                                <%= sexo %>
                                
                                <br>

                                <strong>Peso:</strong>
                                <%= m.getPeso() %> kg

                            </div>

                        </div>

                        <%
                            }
                        }else{
                        %>

                        <div class="alert alert-info">
                            Seleccione un cliente para visualizar sus mascotas.
                        </div>

                        <%
                        }
                        %>
                    </div>
                    
                    <div class="modal fade" id="modalNuevaMascota" data-bs-backdrop="static" tabindex="-1" aria-labelledby="modalNuevaMascotaLabel" aria-hidden="true">
                        <div class="modal-dialog modal-lg modal-dialog-centered">
                            <div class="modal-content" style="border-radius: 20px; border: none; overflow: hidden;">

                                <div class="modal-header border-0 bg-light" style="border-top-left-radius: 20px; border-top-right-radius: 20px; padding: 1.5rem;">
                                    <h5 class="modal-title fw-bold text-dark font-vollkorn d-flex align-items-center">
                                        <i class="fa-solid fa-paw shadow-sm p-2 rounded-3 bg-white text-success me-2" style="color: #00796B !important;"></i> 
                                        Registrar Nueva Mascota
                                    </h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>

                                <form action="controladormascota?accion=guardar" method="POST">
                                    <input type="hidden" name="origen" value="perfil">

                                    <div class="modal-body p-4">

                                        <div class="row g-3 mb-3">
                                            <div class="col-md-4">
                                                <label class="form-label text-muted small fw-bold">NOMBRE</label>
                                                <input type="text" name="txtNombre" class="form-control py-2" placeholder="Ej. Max, Luna..." style="border-radius: 10px;" required>
                                            </div>
                                            <div class="col-md-4">
                                                <label class="form-label text-muted small fw-bold">ESPECIE</label>
                                                <input type="text" name="txtEspecie" class="form-control py-2" placeholder="Ej. Canino, Felino..." style="border-radius: 10px;" required>
                                            </div>
                                            <div class="col-md-4">
                                                <label class="form-label text-muted small fw-bold">RAZA</label>
                                                <input type="text" name="txtRaza" class="form-control py-2" placeholder="Ej. Schnauzer, Persa..." style="border-radius: 10px;" required>
                                            </div>
                                        </div>

                                        <div class="row g-3 mb-3">
                                            <div class="col-md-6">
                                                <label class="form-label text-muted small fw-bold">NOMBRE DE CLIENTE (DUEÑO)</label>
                                                <select name="txtIdCliente" id="modalTxtIdCliente" class="form-select py-2" style="border-radius: 10px;" required>
                                                    <option value="" selected disabled>Selecciona dueño</option>
                                                    <% if (listaClientes != null) {
                                                        for(clientes c : listaClientes) { %>
                                                    <option value="<%= c.getIdCliente() %>">(ID: <%= c.getIdCliente() %>) - <%= c.getNombreCompleto() %></option>
                                                    <%   }
                                                     } %>
                                                </select>
                                            </div>
                                            <div class="col-md-6">
                                                <label class="form-label text-muted small fw-bold">SEXO</label>
                                                <select name="txtSexo" class="form-select py-2" style="border-radius: 10px;" required>
                                                    <option value="" selected disabled>Selecciona sexo</option>
                                                    <option value="F">Hembra</option>
                                                    <option value="M">Macho</option>
                                                </select>
                                            </div>
                                        </div>

                                        <div class="row g-3">
                                            <div class="col-md-6">
                                                <label class="form-label text-muted small fw-bold">PESO (KG)</label>
                                                <input type="number" step="0.01" name="txtPeso" class="form-control py-2" placeholder="0.00" min="0" style="border-radius: 10px;" required>
                                            </div>
                                            <div class="col-md-6">
                                                <label class="form-label text-muted small fw-bold">FECHA DE NACIMIENTO</label>
                                                <input type="date" name="txtFechaNac" class="form-control py-2" max="<%= java.time.LocalDate.now() %>" style="border-radius: 10px;" required>
                                            </div>
                                        </div>

                                    </div>

                                    <div class="modal-footer border-0 p-3 bg-light" style="border-bottom-left-radius: 20px; border-bottom-right-radius: 20px;">
                                        <button type="button" class="btn btn-secondary px-4 py-2" style="border-radius: 12px;" data-bs-dismiss="modal">Cancelar</button>
                                        <button type="submit" class="btn text-white px-4 py-2 fw-bold" style="background-color: #00796B; border-radius: 12px;">
                                            <i class="fa-solid fa-floppy-disk me-1"></i> Guardar Mascota
                                        </button>
                                    </div>

                                </form>
                            </div>
                        </div>
                    </div>
                </div> 
            </div>
        </main>
        <!-- Bootstrap y alertify -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="//cdn.jsdelivr.net/npm/alertifyjs@1.13.1/build/alertify.min.js"></script>        
        <jsp:include page="/componentes/mensajes.jsp" />
        <% if(session.getAttribute("mensajeExito") != null) { %>
            <script>alertify.success('<%= session.getAttribute("mensajeExito") %>');</script>
        <% session.removeAttribute("mensajeExito"); } %>

        <% if(session.getAttribute("mensajeError") != null) { %>
            <script>alertify.error('<%= session.getAttribute("mensajeError") %>');</script>
        <% session.removeAttribute("mensajeError"); } %>
        <script>
            document.getElementById("clienteFiltro").addEventListener("change", function() {
                console.log("Filtrando para el idCliente: " + this.value); 

                fetch("controladorperfil?accion=filtrarMascotas&idCliente=" + this.value)
                .then(response => response.text())
                .then(html => {
                    document.getElementById("contenedorMascotas").innerHTML = html;
                })
                .catch(error => console.error("Error al filtrar las mascotas:", error));
            });
            
            document.getElementById('modalNuevaMascota').addEventListener('show.bs.modal', function () {
                const filtroClienteValue = document.getElementById('clienteFiltro').value;
                const modalSelectCliente = document.getElementById('modalTxtIdCliente');

                if (filtroClienteValue) {
                    modalSelectCliente.value = filtroClienteValue;
                } else {
                    modalSelectCliente.value = ""; 
                }
            });
        </script>
    </body>
</html>
