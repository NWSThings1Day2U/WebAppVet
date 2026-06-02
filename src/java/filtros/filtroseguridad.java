package filtros;

import java.io.IOException;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebFilter(urlPatterns = {"/vista/*", "/componentes/*", "/controladorseccion", "/controladorpagina"})
public class filtroseguridad implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        // 1. OBTENER RUTA PARA EXCLUIR RECURSOS ESTÁTICOS
        String uri = req.getRequestURI();
        
        // Si es un recurso estático (CSS, JS, Imágenes), dejar pasar sin filtrar
        if (uri.contains("/estilos/") || uri.contains("/recursos/")) {
            chain.doFilter(request, response);
            return;
        }

        // 2. CONFIGURAR CABECERAS PARA EVITAR CACHÉ (evita que se "desequilibre")
        res.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        res.setHeader("Pragma", "no-cache");
        res.setDateHeader("Expires", 0);

        // 3. LÓGICA DE SESIÓN
        HttpSession sesion = req.getSession(false);
        boolean logueado = (sesion != null && sesion.getAttribute("usuario") != null);

        if (logueado) {
            chain.doFilter(request, response);
        } else {
            // 4. DETECCIÓN DE INACTIVIDAD
            boolean esPorInactividad = false;
            if (sesion != null) {
                try {
                    long ultimaVez = sesion.getLastAccessedTime();
                    long ahora = System.currentTimeMillis();
                    int maximoInactivoSegundos = sesion.getMaxInactiveInterval();

                    if ((ahora - ultimaVez) >= (maximoInactivoSegundos * 1000L)) {
                        esPorInactividad = true;
                    }
                } catch (IllegalStateException e) {
                    esPorInactividad = true;
                }
            } else if (req.getRequestedSessionId() != null) {
                esPorInactividad = true;
            }

            // 5. ASIGNAR MENSAJE Y REDIRIGIR
            HttpSession sesionNueva = req.getSession(true);
            if (esPorInactividad) {
                sesionNueva.setAttribute("error", "Su sesión ha expirado por inactividad. Por favor, ingrese de nuevo.");
            } else {
                sesionNueva.setAttribute("error", "Acceso restringido. Por favor, inicia sesión.");
            }

            res.sendRedirect(req.getContextPath() + "/index.jsp");
        }
    }

    @Override public void init(FilterConfig filterConfig) throws ServletException {}
    @Override public void destroy() {}
}