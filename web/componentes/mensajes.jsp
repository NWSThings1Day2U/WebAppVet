<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script>    
    alertify.set('notifier', 'position', 'bottom-right');
</script>

<c:if test="${not empty sessionScope.error || not empty sessionScope.expirado}">
    <script>
        const textoExpirado = "${sessionScope.expirado}";
        const textoError = "${sessionScope.error}";
        
        if (textoExpirado !== "") {
            alertify.warning(textoExpirado);
        } else {
            alertify.error(textoError); 
        }
        
        const esFiltro = (textoExpirado !== "") || textoError.includes("restringido");
        
        const loginForm = document.getElementById('formLogin');
        if (loginForm && !esFiltro) {
            const inputs = loginForm.querySelectorAll('.form-control');
            inputs.forEach(input => {
                input.classList.add('is-invalid'); 
            });
            loginForm.addEventListener('input', function(e) {
                if (e.target.classList.contains('form-control')) {
                    e.target.classList.remove('is-invalid');
                }
            });
        }

        const perfilForm = document.getElementById('formPerfil');
        if (perfilForm) {
            const inputsPerfil = perfilForm.querySelectorAll('.editable');
            inputsPerfil.forEach(input => {
                input.classList.add('is-invalid');
            });
            perfilForm.addEventListener('input', function(e) {
                if (e.target.classList.contains('form-control')) {
                    e.target.classList.remove('is-invalid');
                }
            });
        }
    </script>
    <c:remove var="error" scope="session"/>
    <c:remove var="expirado" scope="session"/>
    <c:remove var="editando" scope="session"/>
</c:if>

<c:if test="${not empty sessionScope.success}">
    <script>
        alertify.success('${sessionScope.success}');
    </script>
    <c:remove var="success" scope="session"/>
</c:if>
