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
        <title>Mis citas</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Vollkorn:ital,wght@0,400..900;1,400..900&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
        <link rel="stylesheet" href="//cdn.jsdelivr.net/npm/alertifyjs@1.13.1/build/css/alertify.min.css"/>
        <link rel="stylesheet" href="//cdn.jsdelivr.net/npm/alertifyjs@1.13.1/build/css/themes/default.min.css"/>
        <link rel="icon" href="${pageContext.request.contextPath}/recursos/logoveet.png">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/estilos/escliente.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/estilos/contenidocliente.css">
    </head>
    <body>
        <%
            request.setAttribute("paginaActual", "miscitas");
        %>
        <jsp:include page="../componentes/encabezado.jsp" />

        <main class="container mt-5 pt-4 contenido-cli" style="margin-top: 180px; margin-bottom: 150px;">
            <div class="container-fluid">
                <div class="bien-mensaje-vet">
                    <h2 class="text-center titulo-vet">Mis Citas</h2>
                    <p class="text-center p-vet">Administra las citas de tus mascotas</p>
                </div>

                <div class="filtros-vet row mb-4 gy-3 align-items-center">
                    <div class="col-12 col-md-auto me-auto">
                        <div class="d-flex flex-wrap gap-2">
                            <button class="btn btn-filtro active" id="todas" type="button">Todas</button>
                            <button class="btn btn-filtro" id="pendiente" type="button">Pendientes</button>
                            <button class="btn btn-filtro" id="confirmada" type="button">Confirmadas</button>
                            <button class="btn btn-filtro" id="atendida" type="button">Completadas</button>
                            <button class="btn btn-filtro" id="cancelada" type="button">Canceladas</button>
                        </div>
                    </div>

                    <div class="col-12 col-md-4 col-lg-3">
                        <div class="combo-cliente-container">
                            <select id="clienteFiltro" class="form-select select-custom-vet">
                                <option value="">Seleccione Dueño</option>
                                <% 
                                    if (listaClientes != null) { 
                                        int i = 1;
                                        for(clientes cl : listaClientes) { %>
                                <option value="<%= cl.getIdCliente() %>"><%=i%>. <%= cl.getNombreCompleto() %></option>
                                <% i++;
                                        } 
                                    } %>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="container pt-2 mb-4 px-0">
                    <div id="contenedor-citas" class="d-flex flex-column gap-4">
                        <% 
                            if (lista != null && !lista.isEmpty()) {
                                for(citas c : lista) {
                                    String estado = c.getEstado().toLowerCase(); 
                                    
                                    String borderColor = "";
                                    String badgeColor = "";
                                    String iconBgColor = "";
                                    String textoEstado = "";

                                    if (estado.equals("completada")) {
                                        estado = "atendida";
                                    }

                                    if (estado.equals("pendiente")) {
                                        borderColor = "#EBB12C";
                                        badgeColor = "#FCEFCE"; 
                                        iconBgColor = "#EBB12C";
                                        textoEstado = "Pendiente";
                                    } else if (estado.equals("confirmada")) {
                                        borderColor = "#91C3F0";
                                        badgeColor = "#E1EFFB";
                                        iconBgColor = "#A4CBEF";
                                        textoEstado = "Confirmada";
                                    } else if (estado.equals("atendida")) {
                                        borderColor = "#71C87B";
                                        badgeColor = "#E2F4E4";
                                        iconBgColor = "#71C87B";
                                        textoEstado = "Atendida";
                                    } else if (estado.equals("cancelada")) {
                                        borderColor = "#A0A0A0";
                                        badgeColor = "#EAEAEA";
                                        iconBgColor = "#A0A0A0";
                                        textoEstado = "Cancelada";
                                    }
                                    String nombreMascota = "Desconocida";
                                    if (listaMascotas != null) {
                                        for (mascotas m : listaMascotas) {
                                            if (m.getIdMascota() == c.getIdMascota()) {
                                                nombreMascota = m.getNombre();
                                                break;
                                            }
                                        }
                                    }
                        %>
                        <div class="card card-cita p-3 shadow-sm" style="border: 2px solid <%= borderColor %>; border-radius: 20px; background-color: #fff;" data-estado="<%= estado %>" data-cliente="<%= c.getIdCliente() %>">
                            <div class="row align-items-center gy-3">

                                <div class="col-12 col-md-3 d-flex align-items-center gap-3">
                                    <div class="d-flex align-items-center justify-content-center" style="background-color: <%= iconBgColor %>; height: 80px; width: 80px; border-radius: 18px; flex-shrink: 0;">
                                        <img src="${pageContext.request.contextPath}/recursos/icon.png" style="height: 65px; width: 65px; object-fit: contain;" alt="Mascota"/>
                                    </div>
                                    <div class="text-truncate">
                                        <h4 class="mb-1 fw-bold font-vollkorn" style="color: #0F5132;"><%= nombreMascota %></h4>
                                        <span class="badge px-3 py-2 rounded-pill" style="color: <%= borderColor %>; background-color: <%= badgeColor %>; font-weight: 600; font-size: 0.85rem;">
                                            <%= textoEstado %>
                                        </span>
                                    </div>
                                </div>

                                <div class="col-12 col-md-5">
                                    <div class="d-flex flex-column gap-2">
                                        <div class="row g-2">
                                            <div class="col-6">
                                                <div class="bg-custom-light px-2 py-1 rounded-3 d-flex align-items-center justify-content-center gap-2 border border-light">
                                                    <i class="fa-regular fa-calendar-days" style="color: <%= borderColor %>; font-size: 1.1rem;"></i>
                                                    <div class="text-center">
                                                        <small class="text-muted d-block" style="font-size: 0.7rem; text-transform: uppercase; letter-spacing: 0.5px;">Fecha</small>
                                                        <strong class="font-vollkorn" style="color: #212529;"><%= c.getFecha() %></strong>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-6">
                                                <div class="bg-custom-light px-2 py-1 rounded-3 d-flex align-items-center justify-content-center gap-2 border border-light">
                                                    <i class="fa-regular fa-clock" style="color: <%= borderColor %>; font-size: 1.1rem;"></i>
                                                    <div class="text-center">
                                                        <small class="text-muted d-block" style="font-size: 0.7rem; text-transform: uppercase; letter-spacing: 0.5px;">Hora</small>
                                                        <strong class="font-vollkorn" style="color: #212529;"><%= c.getHora() %></strong>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="bg-custom-light px-3 py-2 rounded-3 border border-light">
                                            <div class="text-muted text-center" style="font-size: 0.85rem;">
                                                Motivo: <strong class="text-dark font-vollkorn"><%= c.getMotivo() %></strong>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-12 col-md-4">
                                    <div class="d-flex flex-column flex-sm-row gap-3 justify-content-md-end align-items-center">
                                        <% if (estado.equals("pendiente")) { %>
                                        <button class="btn py-2.5 w-100 text-white fw-bold" style="background-color: #00796B; border-radius: 12px; font-size: 0.95rem;"
                                                data-bs-toggle="modal" data-bs-target="#modalReprogramar<%= c.getIdCita() %>">
                                            <i class="fa-solid fa-pen-to-square me-1"></i> Reprogramar
                                        </button>
                                        <button class="btn py-2.5 w-100 text-white fw-bold" style="background-color: #D32F2F; border-radius: 12px; font-size: 0.95rem;"
                                                onclick="confirmarCancelar(<%= c.getIdCita() %>)">
                                            <i class="fa-solid fa-xmark me-1"></i> Cancelar
                                        </button>
                                        <% } else if (estado.equals("confirmada")) { %>
                                        <button class="btn py-2.5 w-100 text-white fw-bold" style="background-color: #0088FF; border-radius: 12px; font-size: 0.95rem;">
                                            Ticket <i class="fa-solid fa-download ms-1"></i>
                                        </button>
                                        <button class="btn py-2.5 w-100 text-white fw-bold" style="background-color: #D32F2F; border-radius: 12px; font-size: 0.95rem;"
                                                onclick="confirmarCancelar(<%= c.getIdCita() %>)">
                                            <i class="fa-solid fa-xmark me-1"></i> Cancelar
                                        </button>
                                        <% } else if (estado.equals("atendida")) { %>
                                        <button class="btn py-2.5 w-100 fw-bold border-2" style="color: #2E7D32; border: 2px solid #71C87B; background-color: #E2F4E4; border-radius: 12px; font-size: 0.95rem;">
                                            <i class="fa-solid fa-eye me-1"></i> Revisar Detalles
                                        </button>
                                        <% } else { %>
                                        <button class="btn py-2.5 w-100 text-muted fw-bold bg-light border-0" disabled style="border-radius: 12px; font-size: 0.95rem;">
                                            Sin acciones disponibles
                                        </button>
                                        <% } %>
                                    </div>
                                </div>
                                    
                            </div>
                        </div>
                                    
                        <div class="modal fade" id="modalReprogramar<%= c.getIdCita() %>" data-bs-backdrop="static" tabindex="-1" aria-labelledby="modalReprogramarLabel" aria-hidden="true">
                            <div class="modal-dialog modal-dialog-centered">
                                <div class="modal-content" style="border-radius: 20px;">
                                    <div class="modal-header border-0 bg-light" style="border-top-left-radius: 20px; border-top-right-radius: 20px;">
                                        <h5 class="modal-title fw-bold text-dark font-vollkorn">
                                            <i class="fa-solid fa-clock shadow-sm p-2 rounded-3 bg-white text-success me-2"></i> Reprogramar Cita: <%= nombreMascota %>
                                        </h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <form action="${pageContext.request.contextPath}/controladorcitas" method="POST">
                                        <input type="hidden" name="accion" value="reprogramarCita">
                                        <input type="hidden" name="txtIdCita" value="<%= c.getIdCita() %>">
                                        
                                        <div class="modal-body p-4">
                                            <div class="mb-3">
                                                <label class="form-label text-muted small fw-bold">NUEVA FECHA</label>
                                                <input type="date" class="form-control py-2" name="txtFecha" id="txtFechaEdit<%= c.getIdCita() %>" required min="<%= java.time.LocalDate.now() %> "value="<%= c.getFecha() %>">
                                            </div>
                                            <div class="mb-3">
                                                <label class="form-label text-muted small fw-bold">NUEVA HORA DISPONIBLE</label>
                                                <select class="form-select py-2" name="txtHora" id="txtHoraEdit<%= c.getIdCita() %>" required>
                                                    <option value="<%= c.getHora() %>" selected><%= c.getHora() %> (Hora Actual)</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="modal-footer border-0 p-3 bg-light" style="border-bottom-left-radius: 20px; border-bottom-right-radius: 20px;">
                                            <button type="button" class="btn btn-secondary px-4 py-2" style="border-radius: 12px;" data-bs-dismiss="modal">Cerrar</button>
                                            <button type="submit" class="btn text-white px-4 py-2 fw-bold" style="background-color: #00796B; border-radius: 12px;">
                                                <i class="fa-solid fa-floppy-disk me-1"></i> Guardar Cambios
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>             
                        <% 
                                }
                            } else { 
                        %>
                        <div class="alert alert-info text-center rounded-3">No hay citas registradas en este momento.</div>
                        <% } %>
                    </div>
                </div>
            </div>
        </main>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="//cdn.jsdelivr.net/npm/alertifyjs@1.13.1/build/alertify.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <jsp:include page="/componentes/mensajes.jsp" /> 

        <script>
            document.addEventListener("DOMContentLoaded", () => {
                const botonesFiltro = document.querySelectorAll(".btn-filtro");
                const selectCliente = document.getElementById("clienteFiltro");
                const tarjetasCitas = document.querySelectorAll(".card-cita");

                function aplicarFiltros() {
                    const botonActivo = document.querySelector(".btn-filtro.active");
                    const filtroEstado = botonActivo ? botonActivo.id : "todas";
                    const filtroCliente = selectCliente.value;

                    tarjetasCitas.forEach(tarjeta => {
                        const estadoTarjeta = tarjeta.getAttribute("data-estado");
                        const clienteTarjeta = tarjeta.getAttribute("data-cliente");

                        const cumpleEstado = (filtroEstado === "todas" || estadoTarjeta === filtroEstado);
                        const cumpleCliente = (filtroCliente === "" || clienteTarjeta === filtroCliente);

                        if (cumpleEstado && cumpleCliente) {
                            tarjeta.classList.remove("d-none");
                        } else {
                            tarjeta.classList.add("d-none");
                        }
                    });
                }

                botonesFiltro.forEach(boton => {
                    boton.addEventListener("click", () => {
                        botonesFiltro.forEach(b => b.classList.remove("active"));
                        boton.classList.add("active");
                        aplicarFiltros();
                    });
                });

                if (selectCliente) {
                    selectCliente.addEventListener("change", () => {
                        aplicarFiltros();
                    });
                }
            });
            
            
            function confirmarCancelar(idCita) {
                Swal.fire({
                    title: '¿Estás seguro de cancelar tu cita?',
                    text: "Esta acción no se puede deshacer y el horario quedará liberado.",
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#D32F2F',
                    cancelButtonColor: '#6C757D',
                    confirmButtonText: 'Sí, cancelar cita',
                    cancelButtonText: 'Mantener cita',
                    reverseButtons: true
                }).then((result) => {
                    if (result.isConfirmed) {
                        window.location.href = "${pageContext.request.contextPath}/controladorcitas?accion=eliminar&id=" + idCita;
                    }
                });
            }
            document.addEventListener("DOMContentLoaded", function() {

                        <% for(citas c : lista){ %>

            document.getElementById("txtFechaEdit<%= c.getIdCita() %>")
            .addEventListener("change", function () {

                let fecha = this.value;

                fetch("${pageContext.request.contextPath}/controladorcitas?accion=horasDisponiblesEditar&fecha=" + fecha + "&idCita=<%= c.getIdCita() %>")
                .then(response => response.json())
                .then(data => {

                    let combo = document.getElementById("txtHoraEdit<%= c.getIdCita() %>");

                    combo.innerHTML = '<option value="">Seleccione hora</option>';

                    data.forEach(function(hora){

                        let option = document.createElement("option");

                        option.value = hora;
                        option.textContent = hora;

                        combo.appendChild(option);
                    });

                })
                .catch(error => console.error(error));

            });

                                    <% } %>

            });
        </script>

        <c:if test="${not empty sessionScope.mensajeExito}">
            <script>
                Swal.fire({icon: 'success', title: 'Éxito', text: '${sessionScope.mensajeExito}'});
            </script>
            <c:remove var="mensajeExito" scope="session"/>
        </c:if>

        <c:if test="${not empty sessionScope.mensajeError}">
            <script>
                Swal.fire({icon: 'error', title: 'Error', text: '${sessionScope.mensajeError}'});
            </script>
            <c:remove var="mensajeError" scope="session"/>
        </c:if>
    </body>
</html>