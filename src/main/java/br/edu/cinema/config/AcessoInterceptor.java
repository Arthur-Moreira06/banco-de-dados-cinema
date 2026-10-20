package br.edu.cinema.config;

import br.edu.cinema.model.UsuarioAutenticado;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

@Component
public class AcessoInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {
        String path = request.getRequestURI();
        if (path.equals("/login") || path.startsWith("/css/") || path.startsWith("/js/")
                || path.equals("/favicon.ico") || path.equals("/error")) return true;
        HttpSession session = request.getSession(false);
        UsuarioAutenticado usuario = session == null ? null : (UsuarioAutenticado) session.getAttribute("usuario");
        if (usuario == null) {
            response.sendRedirect("/login");
            return false;
        }
        if (path.startsWith("/gerente") && !usuario.gerente()) {
            response.sendRedirect("/funcionario");
            return false;
        }
        if (path.startsWith("/funcionario") && usuario.gerente()) {
            response.sendRedirect("/gerente");
            return false;
        }
        return true;
    }
}
