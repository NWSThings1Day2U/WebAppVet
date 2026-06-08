<%-- 
    Document   : fornuevocliente
    Created on : 5 jun. 2026, 10:04:29 a. m.
    Author     : USUARIO
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="modelo.citas"%>
<%@page import="modelo.clientes"%>
<%@page import="modelo.mascotas"%>
<%@page import="dao.citadao"%>
<%@page import="java.util.List"%>

<div class="container">
    <h3 class="mt-3 mb-5">Registro de Cita: <span class="text-success">Cliente Nuevo</span></h3>
    
    <form id="formClienteNuevo" action="${pageContext.request.contextPath}/controladorcitas" method="POST" class="needs-validation" novalidate>
        <input type="hidden" name="accion" value="registrarcitaClienteNuevo">

        <div class="stepper stepper-vertical" id="myStepper" data-coreui-toggle="stepper">
            <ol class="stepper-steps">

                <li class="stepper-step active" id="step-1-container">
                    <button type="button" class="stepper-step-button" data-coreui-toggle="step">
                        <span class="stepper-step-indicator">1</span>
                        <span class="stepper-step-label">Datos del Dueño</span>
                    </button>
                    <div class="stepper-step-content" id="step-1">
                        <div class="py-3 row g-3">
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
                                <input type="text" class="form-control val-numero" name="dni" required id="documentodeidentidad"
                                       maxlength="8" pattern="\d{8}" placeholder="Ingresa tu Dni">
                                <div class="invalid-feedback">Deben ser 8 dígitos.</div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label" for="nrotelefono">Teléfono: </label>
                                <input type="text" class="form-control val-numero" name="telefono" required id="nrotelefono"
                                       maxlength="9" pattern="9\d{8}" placeholder="Ingresa tu nro telefonico">
                                <div class="invalid-feedback">Debe empezar con 9 y tener 9 dígitos.</div>
                            </div>
                            <div class="col-12 mt-3">
                                <button class="btn btn-vet-principal w-30 btn-next-step" type="button" data-step="1">Siguiente</button>
                            </div>
                        </div>
                    </div>
                </li>

                <li class="stepper-step" id="step-2-container">
                    <button type="button" class="stepper-step-button" data-coreui-toggle="step">
                        <span class="stepper-step-indicator">2</span>
                        <span class="stepper-step-label">Datos de la Mascota</span>
                    </button>
                    <div class="stepper-step-content" id="step-2">
                        <div class="py-3 row g-3">
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
                                <input type="number" step="0.01" name="txtPeso" class="form-control" placeholder="Ingresa peso" min="0.1" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Fecha de nacimiento</label>
                                <input type="date" name="txtFechaNac" class="form-control" max="<%=java.time.LocalDate.now()%>" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Sexo</label>
                                <select name="txtSexo" class="form-select" required>
                                    <option value="" selected disabled>Selecciona sexo</option>
                                    <option value="F">Hembra</option>
                                    <option value="M">Macho</option>
                                </select>
                            </div>
                            <div class="col-12 mt-3 text-start">
                                <button class="btn btn-vet-secundario1 btn-prev-step px-4" type="button" data-step="2">Anterior</button>
                                <button class="btn btn-vet-principal btn-next-step px-4" type="button" data-step="2">Siguiente</button>
                            </div>
                        </div>
                    </div>
                </li>

                <li class="stepper-step" id="step-3-container">
                    <button type="button" class="stepper-step-button" data-coreui-toggle="step">
                        <span class="stepper-step-indicator">3</span>
                        <span class="stepper-step-label">Datos de la Cita</span>
                    </button>
                    <div class="stepper-step-content" id="step-3">
                        <div class="pt-3 row g-3">
                            <div class="col-md-4 mb-3">
                                <label class="form-label">Fecha</label>
                                <input type="date" name="txtFecha" id="txtFecha" class="form-control" min="<%=java.time.LocalDate.now()%>" required>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="form-label">Hora</label>
                                <select name="txtHora" id="txtHora" class="form-select" required>
                                    <option value="">Selecciona hora</option>
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
                            <div class="col-12 mb-3">
                                <label class="form-label">Motivo de la Visita</label>
                                <textarea name="txtMotivo" class="form-control" rows="2" required></textarea>
                            </div>
                            <div class="col-12 mb-3">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="checkTerms" required>
                                    <label class="form-check-label" for="checkTerms">Acepto los términos y condiciones</label>
                                </div>
                            </div>
                            <div class="cliente-antiguo-info col-12">
                                <p>
                                    <strong> <i class="fa-solid fa-circle-exclamation me-1"></i> Nota: </strong> 
                                    Tu solicitud será evaluada por el médico. Recibirás un correo electrónico una vez que la cita sea confirmada.
                                </p>
                            </div>
                            <div class="col-12 mt-4">
                                <button class="btn btn-vet-secundario1 btn-prev-step px-4 py-2" type="button" data-step="3">Anterior</button>
                                <button type="button" id="btnEnviarFormulario" class="btn btn-vet-principal px-4 py-2">
                                    Enviar <i class="fa-solid fa-paper-plane ms-1"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                </li>

            </ol>
        </div>
    </form>
</div>

<script>
    document.addEventListener('DOMContentLoaded', () => {
        const form = document.getElementById('formClienteNuevo');
        const steps = document.querySelectorAll('.stepper-step');
        let currentStepIndex = 0;

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

        // Validar campos del contenedor actual antes de pasar al siguiente
        function validarCamposDelPaso(stepIndex) {
            const contenedorPaso = document.getElementById(`step-${stepIndex + 1}`);
            const inputs = contenedorPaso.querySelectorAll('input, select, textarea');
            let pasoValido = true;

            inputs.forEach(input => {
                if (!input.checkValidity()) {
                    pasoValido = false;
                    input.classList.add('is-invalid');
                } else {
                    input.classList.remove('is-invalid');
                    input.classList.add('is-valid');
                }
            });

            return pasoValido;
        }

        // Manejo del botón Siguiente con Alerta de paso completado
        document.querySelectorAll('.btn-next-step').forEach(button => {
            button.addEventListener('click', () => {
                if (validarCamposDelPaso(currentStepIndex)) {
                    Swal.fire({
                        icon: 'success',
                        title: '¡Paso completado!',
                        text: 'Datos validados correctamente. Continuemos.',
                        timer: 1500,
                        showConfirmButton: false
                    });

                    if (currentStepIndex < steps.length - 1) {
                        updateStepper(currentStepIndex + 1);
                    }
                } else {
                    Swal.fire({
                        icon: 'warning',
                        title: 'Campos incompletos',
                        text: 'Por favor, rellena todos los campos obligatorios correctamente antes de continuar.',
                    });
                }
            });
        });

        // Manejo del botón Anterior
        document.querySelectorAll('.btn-prev-step').forEach(button => {
            button.addEventListener('click', () => {
                if (currentStepIndex > 0) {
                    updateStepper(currentStepIndex - 1);
                }
            });
        });

        // Procesar el botón final "Enviar"
        document.getElementById('btnEnviarFormulario').addEventListener('click', function(e) {
            e.preventDefault();
                let formularioValido = true;
                let pasoConError = -1;
            for (let i = 0; i < steps.length; i++) {
                if (!validarCamposDelPaso(i)) {
                    formularioValido = false;
                    if (pasoConError === -1) {
                        pasoConError = i; 
                    }
                }
            }
            if (!validarCamposDelPaso(2)) {
                Swal.fire({
                    icon: 'error',
                    title: 'Error en paso 3',
                    text: 'Por favor, selecciona una fecha, hora y acepta los términos.',
                });
                return;
            }
            if (!formularioValido) {
                    Swal.fire({
                        icon: 'error',
                        title: 'Campos incompletos o inválidos',
                        text: 'Por favor, revisa todos los pasos del formulario. Hay datos obligatorios vacíos o mal formateados.',
                    });

                    updateStepper(pasoConError);
                    return;
                }
            // Alerta de confirmación final antes del submit
            Swal.fire({
                title: '¿Confirmas el registro?',
                text: "Se guardarán los datos del nuevo dueño, su mascota y la cita programada.",
                icon: 'question',
                showCancelButton: true,
                confirmButtonColor: '#198754',
                cancelButtonColor: '#dc3545',
                confirmButtonText: 'Sí, registrar todo',
                cancelButtonText: 'Revisar datos'
            }).then((result) => {
                if (result.isConfirmed) {
                    form.submit(); 
                }
            });
        });
    });
</script>

<script>
    document.addEventListener('DOMContentLoaded', () => {
        // Buscamos los elementos estrictamente dentro del contenedor 'formClienteNuevo'
        const contenedorForm = document.getElementById('formClienteNuevo');
        if (!contenedorForm) return;

        const inputFecha = contenedorForm.querySelector("#txtFecha");
        const comboHora = contenedorForm.querySelector("#txtHora");

        if (inputFecha && comboHora) {
            ['input', 'change'].forEach(eventType => {
                inputFecha.addEventListener(eventType, function () {
                    let fecha = this.value;
                    
                    
                    if (!fecha || fecha.trim() === "" || fecha.length < 10) {
                        console.log("Fecha incompleta o vacía. No se enviará petición al servidor.");
                        comboHora.innerHTML = '<option value="">Selecciona hora</option>';
                        return;
                    }

                    console.log("Enviando fecha válida al controlador:", fecha);

                    fetch("${pageContext.request.contextPath}/controladorcitas?accion=horasDisponibles&fecha=" + fecha)
                        .then(response => {
                            if (!response.ok) {
                                throw new Error("Error en respuesta del servidor: " + response.status);
                            }
                            return response.json();
                        })
                        .then(data => {
                            console.log("Horas devueltas por el controlador:", data);
                            
                            comboHora.innerHTML = '<option value="">Selecciona hora</option>';
                            
                            if (!data || data.length === 0) {
                                let option = document.createElement("option");
                                option.value = "";
                                option.textContent = "No hay horas disponibles";
                                comboHora.appendChild(option);
                                return;
                            }

                            data.forEach(function (hora) {
                                let option = document.createElement("option");
                                option.value = hora;
                                option.textContent = hora;
                                comboHora.appendChild(option);
                            });
                        })
                        .catch(error => {
                            console.error("ERROR AJAX EN CITAS:", error);
                        });
                });
            });
        }
    });
</script>

<c:if test="${not empty sessionScope.mensajeExito}">
    <script>
        Swal.fire({
            icon: 'success',
            title: '¡Operación Exitosa!',
            text: '${sessionScope.mensajeExito}'
        });
    </script>
    <c:remove var="mensajeExito" scope="session"/>
</c:if>

<c:if test="${not empty sessionScope.mensajeError}">
    <script>
        Swal.fire({
            icon: 'error',
            title: 'Error en Registro',
            text: '${sessionScope.mensajeError}'
        });
    </script>
    <c:remove var="mensajeError" scope="session"/>
</c:if>