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

@WebFilter(urlPatterns = {"/vista/*", "/componentes/*"})
public class filtroseguridad implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession sesion = req.getSession(false);

        boolean logueado = (sesion != null && sesion.getAttribute("usuario") != null);

        if (logueado) {
            chain.doFilter(request, response);
        } else {
            req.getSession(true).setAttribute("error", "Acceso restringido. Por favor, inicia sesión.");
            res.sendRedirect(req.getContextPath() + "/index.jsp");
        }
    }

    @Override public void init(FilterConfig filterConfig) throws ServletException {}
    @Override public void destroy() {}
}
