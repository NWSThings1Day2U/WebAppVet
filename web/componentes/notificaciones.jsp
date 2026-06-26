<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div class="list-group list-group-flush">
     <!-- Cantidad: ${notificaciones.size()} -->
    <c:choose>
        <c:when test="${not empty notificaciones}">
            <c:forEach var="n"
                       items="${notificaciones}">
                <div class="list-group-item py-3">
                    <div class="d-flex justify-content-between">
                        <h6 class="fw-bold mb-1">
                            ${n.titulo}
                        </h6>
                        <small class="text-muted">
                            ${n.fecha}
                        </small>
                    </div>
                    <p class="mb-0 small">
                        ${n.mensaje}
                    </p>
                </div>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <div class="text-center py-5">
                <i class="fa-solid fa-bell-slash fs-2 text-muted"></i>
                <p class="mt-3 text-muted">
                    No tienes notificaciones.
                </p>
            </div>
        </c:otherwise>
    </c:choose>
</div>
