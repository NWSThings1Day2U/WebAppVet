<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Agendar Citas</title>
        <!-- Bootstrap -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font de google -->
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Vollkorn:ital,wght@0,400..900;1,400..900&display=swap" rel="stylesheet">     <!-- Iconos -->

        <!-- Iconos -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
        <link rel="stylesheet" href="https://cloudflare.com">
        <!-- Alertify -->
        <link rel="stylesheet" href="//cdn.jsdelivr.net/npm/alertifyjs@1.13.1/build/css/alertify.min.css"/>
        <link rel="stylesheet" href="//cdn.jsdelivr.net/npm/alertifyjs@1.13.1/build/css/themes/default.min.css"/>
        <!-- Icono -->
        <link rel="icon" href="${pageContext.request.contextPath}/recursos/logoveet.png">

        <!-- CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/estilos/escliente.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/estilos/contenidocliente.css">
    </head>
    <body>
        <%
            request.setAttribute("paginaActual", "agendarcitas");
        %>
        <jsp:include page="../componentes/encabezado.jsp" />
        <main class="container mt-5 pt-4 contenido-cli" style="margin-top: 180px; margin-bottom: 150px;">
            <div class="container-fluid">
                <div class="bien-mensaje-vet">
                    <h2 class="text-center titulo-vet">Agendar Nueva Cita</h2>
                    <p class="text-center p-vet">Completa los datos del formulario para la reservación.</p>
                </div>
                <div class="tabla-agendar">
                    <div class="filtros-vet row mb-4 align-items-center">
                        <div class="col-12">
                            <div class="d-flex gap-3 justify-content-start">
                                <button class="btn btn-cliente active" id="antiguo" type="button">Cliente Antiguo</button>
                                <button class="btn btn-cliente" id="nuevo" type="button">Cliente Nuevo</button>
                            </div>


                            <!-- Si es antiguo -->
                            <div class="con-cliente mt-4" id="content-antiguo">
                                <div class="container">
                                    <h3 class="mt-3 mb-5">Registro de Cita: <span class="text-success">Cliente Antiguo</span></h3>
                                    <form action="${pageContext.request.contextPath}/controladorcitas" method="POST">
                                        <input type="hidden" name="accion" value="guardar">
                                        <div class="mb-4">
                                            <div class="row">
                                                <div class="col-md-4 mb-3">
                                                    <label class="form-label">Lista de Clientes</label>
                                                    <select name="txtIdCliente" class="form-select" id="txtIdCliente" required>
                                                        <option value="">Seleccione Cliente</option>
                                                        <% if (listaClientes != null) { 
                                                for(clientes cl : listaClientes) { %>
                                                        <option value="<%= cl.getIdCliente() %>">ID: <%= cl.getIdCliente() %> - <%= cl.getNombreCompleto() %></option>
                                                        <%  } 
                                            } %>
                                                    </select>
                                                </div>
                                                <div class="col-md-4 mb-3">
                                                    <label class="form-label">Lista de Mascotas</label>
                                                    <select name="txtIdMascota" id="txtIdMascota" class="form-select" required disabled>
                                                        <option value="">Seleccione Mascota</option>

                                                        <% if (listaMascotas != null) {
                                                for(mascotas m : listaMascotas) { %>

                                                        <option value="<%= m.getIdMascota() %>"
                                                                data-cliente="<%= m.getIdCliente() %>">
                                                            <%= m.getNombre() %> (Dueño: <%= m.getNombreCliente() %>)
                                                        </option>

                                                        <% }
                                             } %>
                                                    </select>
                                                </div>
                                                <div class="col-md-4 mb-3">
                                                    <label class="form-label">Tipo de Atención</label>
                                                    <select name="txtIdTipo" class="form-select" required>
                                                        <option value="">Seleccione tipo de atencion</option>
                                                        <option value="1">1. Vacunación</option>
                                                        <option value="2">2. Cirugía</option>
                                                        <option value="3">3. Consulta</option>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-md-6 mb-3">
                                                    <label class="form-label">Fecha</label>
                                                    <input type="date" name="txtFecha"  id="txtFecha" class="form-control"  min="<%= java.time.LocalDate.now() %>" required>
                                                </div>
                                                <div class="col-md-6 mb-3">
                                                    <label class="form-label">Hora</label>
                                                    <select name="txtHora"  id="txtHora" class="form-select" required>
                                                        <option value="">
                                                            Seleccione hora
                                                        </option>

                                                    </select>
                                                </div>
                                            </div>
                                            <div class="mb-3">
                                                <label class="form-label">Motivo de la Visita</label>
                                                <textarea name="txtMotivo" class="form-control" rows="2"></textarea>
                                            </div>
                                        </div>
                                    </form>
                                    <div class="cliente-antiguo-info">
                                        <p>
                                            <strong> <i class="fa-solid fa-circle-exclamation me-1"></i> Nota: </strong> 
                                            Recibirás una confirmación por correo electrónico. Por favor, llega 15 minutos antes de tu cita.
                                        </p>
                                    </div>
                                </div> 
                              <div class="col-12 mt-4">
                                  <div class="d-flex gap-2 justify-content-md-start justify-content-center" style="margin-left: 10px">
        <button type="button" class="btn btn-vet-secundario1 px-4 py-2">Cancelar</button>
        <button type="submit" class="btn btn-vet-principal px-4 py-2">
            Enviar <i class="fa-solid fa-paper-plane ms-1"></i>
        </button>
    </div>
                              </div></div>

                            <!-- Si es nuevo  -->
                            <div class="con-cliente mt-4 d-none" id="content-nuevo">
                                
                                <div class="container">
                                    <h3 class="mt-3 mb-5">Registro de Cita: <span class="text-success">Cliente Nuevo</span></h3>
                                    <div class="stepper stepper-vertical" id="myStepper" data-coreui-toggle="stepper">
                                        <ol class="stepper-steps">

                                            <li class="stepper-step active" data-coreui-target="#step-1">
                                                <button type="button" class="stepper-step-button" data-coreui-toggle="step">
                                                    <span class="stepper-step-indicator">1</span>
                                                    <span class="stepper-step-label">Datos del Dueño</span>
                                                </button>
                                                <div class="stepper-step-content" id="step-1">
                                                    <div class="py-3">
                                                        <form class="row g-3 mb-4">
                                                            <div class="col-md-6">
                                                                <label class="form-label" for="nombrecompleto">Nombre Completo: </label>
                                                                <input type="text" class="form-control" name="nombre" required id="nombrecompleto"
                                                                       pattern="^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$" placeholder="Ingresa tu nombre completo">
                                                                <div class="invalid-feedback">Solo letras.</div>
                                                            </div>
                                                            <div class="col-md-6">
                                                                <label class="form-label" for="correo">Correo Electrónico: </label> 
                                                                <input type="email" class="form-control" name="correo" required id="correo"
                                                                       placeholder="Ingresa tu correo">
                                                                <div class="invalid-feedback">Correo no válido.</div> 
                                                            </div>
                                                            <div class="col-md-6">
                                                                <label class="form-label" for="documentodeidentidad">Dni: </label>
                                                                <input type="text" class="form-control val-numero" name="dni" required  id="documentodeidentidad"
                                                                       maxlength="8" pattern="\d{8}" placeholder="Ingresa tu Dni">
                                                                <div class="invalid-feedback">Deben ser 8 dígitos.</div>
                                                            </div>
                                                            <div class="col-md-6">
                                                                <label class="form-label" for="nrotelefono">Teléfono: </label>
                                                                <input type="text" class="form-control val-numero" name="telefono" required  id="nrotelefono"
                                                                       maxlength="9" pattern="9\d{8}" placeholder="Ingresa tu nro telefonico">
                                                                <div class="invalid-feedback">Debe empezar con 9 y tener 9 dígitos.</div>
                                                            </div>
                                                        </form>
                                                        <button class="btn btn-vet-principal w-30 mb-2 btn-next" type="button">Siguiente</button>
                                                    </div>
                                                </div>
                                            </li>

                                            <li class="stepper-step" data-coreui-target="#step-2">
                                                <button type="button" class="stepper-step-button" data-coreui-toggle="step">
                                                    <span class="stepper-step-indicator">2</span>
                                                    <span class="stepper-step-label">Datos de la Mascota</span>
                                                </button>
                                                <div class="stepper-step-content" id="step-2">
                                                    <div class="py-3">
                                                        <form class="row g-3 mb-4">
                                                            <div class="col-md-6">
                                                                <label class="form-label" for="nombremascota">Nombre de Mascota: </label>
                                                                <input type="text" class="form-control" name="mascota" required id="nombremascota"
                                                                       pattern="^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$" placeholder="Ingresa nombre de mascota">
                                                                <div class="invalid-feedback">Solo letras.</div>
                                                            </div>
                                                            <div class="col-md-6">
                                                                <label class="form-label">Especie</label>
                                                                <input type="text" name="txtEspecie" class="form-control" placeholder="Ingresa especie" required>
                                                            </div>
                                                            <div class="col-md-6">
                                                                <label class="form-label">Raza</label>
                                                                <input type="text" name="txtRaza" class="form-control" placeholder="Ingresa raza" required>
                                                            </div>
                                                            <div class="col-md-6">
                                                                <label class="form-label">Peso (kg)</label>
                                                                <input type="number" step="0.01" name="txtPeso" class="form-control" placeholder="Ingresa peso" min="0" required>
                                                            </div>
                                                            <div class="col-md-6">
                                                                <label class="form-label">Fecha de nacimiento</label>
                                                                <input type="date" name="txtFechaNac" class="form-control" required>
                                                            </div>
                                                            <div class="col-md-6">
                                                                <label class="form-label">Sexo</label>
                                                                <select name="txtSexo" class="form-select" required>
                                                                    <option value="" selected disabled>Selecciona sexo</option>
                                                                    <option value="F">Hembra</option>
                                                                    <option value="M">Macho</option>
                                                                </select>
                                                            </div>
                                                        </form>
                                                        <div class="col-md-2 mt-3 mt-md-0 text-md-end text-center">
                                                            <div class="d-flex gap-2 justify-content-center" style="margin-left: 50px">
        <button class="btn btn-vet-secundario1 btn-prev flex-fill" type="button">Anterior</button>
        <button class="btn btn-vet-principal btn-next flex-fill" type="button">Siguiente</button>
    </div>
</div>

                                                    </div>
                                                </div>
                                            </li>

                                            <li class="stepper-step" data-coreui-target="#step-3">
                                                <button type="button" class="stepper-step-button" data-coreui-toggle="step">
                                                    <span class="stepper-step-indicator">3</span>
                                                    <span class="stepper-step-label">Datos de la Cita</span>
                                                </button>
                                                <div class="stepper-step-content" id="step-3">
                                                    <div class="pt-3">
                                                        <form class="row g-3 mb-4">
                                                            <div class="col-md-4 mb-3">
                                                    <label class="form-label">Fecha</label>
                                                    <input type="date" name="txtFecha"  id="txtFecha" class="form-control"  min="<%= java.time.LocalDate.now() %>" required>
                                                </div>
                                                <div class="col-md-4 mb-3">
                                                    <label class="form-label">Hora</label>
                                                    <select name="txtHora"  id="txtHora" class="form-select" required>
                                                        <option value="">
                                                            Selecciona hora
                                                        </option>

                                                    </select>
                                                </div>
                                                <div class="col-md-4 mb-3">
                                                    <label class="form-label">Tipo de Atención</label>
                                                    <select name="txtIdTipo" class="form-select" required>
                                                        <option value="">Selecciona tipo de atencion</option>
                                                        <option value="1">1. Vacunación</option>
                                                        <option value="2">2. Cirugía</option>
                                                        <option value="3">3. Consulta</option>
                                                    </select>
                                                </div>
                                                <div class="mb-3">
                                                <label class="form-label">Motivo de la Visita</label>
                                                <textarea name="txtMotivo" class="form-control" rows="2"></textarea>
                                            </div>
                                                            <div class="col-12">
                                                                <div class="form-check">
                                                                    <input class="form-check-input" type="checkbox" id="checkTerms">
                                                                    <label class="form-check-label" for="checkTerms">Acepto los términos y condiciones</label>
                                                                </div>
                                                            </div>
                                                <div class="cliente-antiguo-info">
                                        <p>
                                            <strong> <i class="fa-solid fa-circle-exclamation me-1"></i> Nota: </strong> 
                                            Recibirás una confirmación por correo electrónico. Por favor, llega 15 minutos antes de tu cita.
                                        </p>
                                    </div>
                                                        </form>
                                                        <div class="col-md-2 mt-3 mt-md-0 text-md-end text-center">
                                                            <div class="d-flex gap-2 justify-content-center" style="margin-left: 50px">
        <button class="btn btn-vet-secundario1 btn-prev flex-fill" type="button">Anterior</button>
        <button class="btn btn-vet-principal btn-next flex-fill" id="btn-finish" type="button">Completar</button>
    </div>
</div>
                                                    </div>
                                                </div>
                                            </li>

                                        </ol>
                                    </div>
                                </div>
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
        <script>
            const btnAntiguo = document.getElementById('antiguo');
            const btnNuevo = document.getElementById('nuevo');

            const contentAntiguo = document.getElementById('content-antiguo');
            const contentNuevo = document.getElementById('content-nuevo');

            btnAntiguo.addEventListener('click', () => {
                // Intercambio de estado en botones
                btnAntiguo.classList.add('active');
                btnNuevo.classList.remove('active');

                // Mostrar Antiguo, Ocultar Nuevo
                contentAntiguo.classList.remove('d-none');
                contentNuevo.classList.add('d-none');
            });

            btnNuevo.addEventListener('click', () => {
                // Intercambio de estado en botones
                btnNuevo.classList.add('active');
                btnAntiguo.classList.remove('active');

                // Mostrar Nuevo, Ocultar Antiguo
                contentNuevo.classList.remove('d-none');
                contentAntiguo.classList.add('d-none');
            });
        </script>

        <script>
            document.addEventListener('DOMContentLoaded', () => {
                const stepperElement = document.getElementById('myStepper');
                const steps = stepperElement.querySelectorAll('.stepper-step');
                let currentStepIndex = 0;

                // Función para actualizar visualmente los pasos basados en el índice activo
                function updateStepper(targetIndex) {
                    steps.forEach((step, index) => {
                        if (index < targetIndex) {
                            step.classList.remove('active');
                            step.classList.add('completed');
                        } else if (index === targetIndex) {
                            step.classList.add('active');
                            step.classList.remove('completed');
                        } else {
                            step.classList.remove('active', 'completed');
                        }
                    });
                    currentStepIndex = targetIndex;
                }

                // Eventos para botones "Next" (Siguiente)
                stepperElement.querySelectorAll('.btn-next').forEach(button => {
                    button.addEventListener('click', () => {
                        if (currentStepIndex < steps.length - 1) {
                            updateStepper(currentStepIndex + 1);
                        }
                    });
                });

                // Eventos para botones "Previous" (Anterior)
                stepperElement.querySelectorAll('.btn-prev').forEach(button => {
                    button.addEventListener('click', () => {
                        if (currentStepIndex > 0) {
                            updateStepper(currentStepIndex - 1);
                        }
                    });
                });

                // Permitir hacer clic directo en los encabezados de los pasos
                steps.forEach((step, index) => {
                    const button = step.querySelector('.stepper-step-button');
                    button.addEventListener('click', (e) => {
                        e.preventDefault();
                        updateStepper(index);
                    });
                });

                // Evento de finalización
                document.getElementById('btn-finish').addEventListener('click', (e) => {
                    e.preventDefault();
                    alert('¡Formulario enviado con éxito!');
                });
            });
        </script>
<%
            String mensajeExito = (String) request.getSession().getAttribute("mensajeExito");
            String mensajeError = (String) request.getSession().getAttribute("mensajeError");
            
            if (mensajeExito != null) {
        %>
        <script>
            alertify.success("<%= mensajeExito %>");
        </script>
        <%
                request.getSession().removeAttribute("mensajeExito");
            }
            if (mensajeError != null) {
        %>
        <script>
            alertify.error("<%= mensajeError %>");
        </script>
        <%
                request.getSession().removeAttribute("mensajeError");
            }
        %>
        <script>
            document.addEventListener("DOMContentLoaded", function () {

                const clienteSelect = document.getElementById("txtIdCliente");
                const mascotaSelect = document.getElementById("txtIdMascota");

                const todasOpciones = Array.from(mascotaSelect.options);

                clienteSelect.addEventListener("change", function () {

                    const idCliente = this.value;

                    mascotaSelect.innerHTML = "";

                    const opcionInicial = document.createElement("option");
                    opcionInicial.value = "";
                    opcionInicial.textContent = "Seleccione Mascota";
                    mascotaSelect.appendChild(opcionInicial);

                    if (!idCliente) {
                        mascotaSelect.disabled = true;
                        return;
                    }

                    mascotaSelect.disabled = false;

                    todasOpciones.forEach(op => {

                        if (op.value === "")
                            return;

                        if (op.dataset.cliente === idCliente) {
                            mascotaSelect.appendChild(op.cloneNode(true));
                        }

                    });

                });

            });
        </script>
        
    </body>
</html>
