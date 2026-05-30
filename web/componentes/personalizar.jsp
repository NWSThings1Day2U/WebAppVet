<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<div class="modal fade custom-modal-vet" id="modalPersonalizar" data-bs-backdrop="static" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg" style="border-radius: 12px; overflow: hidden;">
            
            <%-- Header --%>
            <div class="modal-header border-0 p-4">
                <h5 class="modal-title fw-bold">
                    <i class="fa-solid fa-circle-info me-2"></i> Información de Usuario
                </h5>
            </div>

            <%-- Body --%>
            <div class="modal-body text-center p-4">
                <div class="avatar-circle-formal shadow-sm">
                    <i class="fa-solid fa-user-tie fa-2x" style="color: #CC4607;"></i>
                </div>

                <h4 class="fw-bold text-dark mb-3">
                    ¡Bienvenido/a <span class="user-badge">${sessionScope.usuario}</span> a la plataforma!
                </h4>
                
                <p class="text-secondary">
                    Desde este portal podrá gestionar las citas médicas de sus mascotas.
                </p>

                <p class="text-muted small mt-4 border-top pt-3">
                    ¿Desea completar la personalización de su perfil?
                </p>
                
                <div class="d-flex justify-content-center mt-3">
                    <div class="form-check p-2 px-4 rounded border bg-light d-flex align-items-center" style="cursor: pointer;">
                        <input class="form-check-input me-2 mt-0" type="checkbox" id="checkNoMostrar" style="cursor: pointer; margin-left: 1px;">
                        <label class="form-check-label small text-muted mb-0" for="checkNoMostrar" style="cursor: pointer;">
                            No volver a mostrar este mensaje
                        </label>
                    </div>
                </div>
            </div>

            <%-- Footer --%>
            <div class="modal-footer border-0 p-4 justify-content-center bg-light">
                <button type="button" class="btn btn-vet-secundario rounded-pill px-4" data-bs-dismiss="modal">
                    Omitir por ahora
                </button>
                <a href="controladorpagina?pagina=miperfil" class="btn btn-vet-principal rounded-pill px-4 fw-bold">
                    Configurar Perfil
                </a>
            </div>
        </div>
    </div>
</div>

<script>
/* Mantén el mismo script de JavaScript que ya tienes, funciona perfecto */
(function() {
    function iniciarModal() {
        const modalEl = document.getElementById('modalPersonalizar');
        if (!modalEl) return;
        const bloqueado = localStorage.getItem("bloquearModalPersonalizar");
        if (bloqueado === "true") return;
        try {
            if (typeof bootstrap !== 'undefined') {
                const myModal = new bootstrap.Modal(modalEl);
                myModal.show();
                modalEl.addEventListener('hide.bs.modal', function () {
                    const check = document.getElementById('checkNoMostrar');
                    if (check && check.checked) {
                        localStorage.setItem("bloquearModalPersonalizar", "true");
                    }
                });
            }
        } catch (e) {}
    }
    if (document.readyState === "loading") {
        document.addEventListener("DOMContentLoaded", iniciarModal);
    } else {
        iniciarModal();
    }
})();
</script>