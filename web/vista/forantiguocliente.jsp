<%-- 
    Document   : forantiguocliente
    Created on : 5 jun. 2026, 10:04:44 a. m.
    Author     : USUARIO
--%>
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
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div class="container">
    <h3 class="mt-3 mb-5">Registro de Cita: <span class="text-success">Cliente Antiguo</span></h3>
    <form id="formClienteAntiguo" action="${pageContext.request.contextPath}/controladorcitas" method="POST">
        <input type="hidden" name="accion" value="guardar">
        <div class="mb-4">
            <div class="row">
                <div class="col-md-4 mb-3">
                    <label class="form-label">Lista de Clientes</label>
                    <select name="txtIdCliente" class="form-select" id="txtIdCliente" required>
                        <option value="">Seleccione Cliente</option>
                        <% if (listaClientes != null) { 
                                                for(clientes cl : listaClientes) { %>
                        <option value="<%= cl.getIdCliente() %>"><%= cl.getNombreCompleto() %></option>
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
                <textarea id="txtMotivo" name="txtMotivo" class="form-control" minlength="10" maxlength="300" rows="2" required></textarea>
                <div class="invalid-feedback">
                    El motivo debe tener entre 10 y 300 caracteres.
                </div>
            </div>
            <div class="col-12">
                <div class="form-check">
                    <input class="form-check-input" type="checkbox" id="checkTerms" required>
                    <label class="form-check-label" for="checkTerms">Acepto los términos y condiciones</label>
                </div>
            </div>
        </div><div class="cliente-antiguo-info">
            <p>
                <strong> <i class="fa-solid fa-circle-exclamation me-1"></i> Nota: </strong> 
                Tu solicitud será evaluada por el médico. Recibirás un correo electrónico una vez que la cita sea confirmada. Por favor, llega 15 minutos antes de la hora programada.
            </p>
        </div>

        <div class="col-12 mt-4">
            <div class="d-flex gap-2 justify-content-md-start justify-content-center" style="margin-left: 10px">

                <button type="submit" class="btn btn-vet-principal px-4 py-2">
                    Enviar <i class="fa-solid fa-paper-plane ms-1"></i>
                </button>
            </div>
        </div>        
    </form>
</div> 

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
<script>

    document.getElementById("txtFecha").addEventListener("change", function () {

                let fecha = this.value;
                console.log("Fecha seleccionada:", fecha);
                fetch("${pageContext.request.contextPath}/controladorcitas?accion=horasDisponibles&fecha="+ fecha)
                        .then(response => response.json())
                        .then(data => {

                            console.log(data);

                            let combo = document.getElementById("txtHora");

                            combo.innerHTML = '<option value="">Seleccione hora</option>';

                            data.forEach(function (hora) {

                                let option = document.createElement("option");

                                option.value = hora;
                                option.textContent = hora;

                                combo.appendChild(option);

                            });

                        })
                        .catch(error => {
                            console.error("ERROR:", error);
                        });

            });

</script>

<script>
document.addEventListener("DOMContentLoaded", () => {

    const form = document.getElementById("formClienteAntiguo");

    form.addEventListener("submit", function(e){

        const cliente = document.getElementById("txtIdCliente").value;
        const mascota = document.getElementById("txtIdMascota").value;
        const fecha = document.getElementById("txtFecha").value;
        const hora = document.getElementById("txtHora").value;
        const motivo = document.getElementById("txtMotivo").value.trim();
        const check = document.getElementById("checkTerms").checked;

        if(cliente === ""){
            e.preventDefault();

            Swal.fire({
                icon:'warning',
                title:'Cliente requerido',
                text:'Seleccione un cliente.'
            });

            return;
        }

        if(mascota === ""){
            e.preventDefault();

            Swal.fire({
                icon:'warning',
                title:'Mascota requerida',
                text:'Seleccione una mascota.'
            });

            return;
        }

        if(fecha === ""){
            e.preventDefault();

            Swal.fire({
                icon:'warning',
                title:'Fecha requerida',
                text:'Seleccione una fecha.'
            });

            return;
        }

        if(hora === ""){
            e.preventDefault();

            Swal.fire({
                icon:'warning',
                title:'Hora requerida',
                text:'Seleccione una hora.'
            });

            return;
        }

        if(motivo.length < 10){
            e.preventDefault();

            Swal.fire({
                icon:'warning',
                title:'Motivo inválido',
                text:'El motivo debe tener al menos 10 caracteres.'
            });

            return;
        }

        if(!check){
            e.preventDefault();

            Swal.fire({
                icon:'warning',
                title:'Términos y condiciones',
                text:'Debe aceptar los términos y condiciones.'
            });

            return;
        }
    });

});
</script>

<c:if test="${not empty sessionScope.mensajeExito}">
    <script>
        Swal.fire({
            icon: 'success',
            title: 'Éxito',
            text: '${sessionScope.mensajeExito}'
        });
    </script>
    <c:remove var="mensajeExito" scope="session"/>
</c:if>

<c:if test="${not empty sessionScope.mensajeError}">
    <script>
        Swal.fire({
            icon: 'error',
            title: 'Error',
            text: '${sessionScope.mensajeError}'
        });
    </script>
    <c:remove var="mensajeError" scope="session"/>
</c:if>
