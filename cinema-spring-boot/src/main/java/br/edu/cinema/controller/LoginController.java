package br.edu.cinema.controller;

import br.edu.cinema.dto.LoginFormulario;
import br.edu.cinema.model.UsuarioAutenticado;
import br.edu.cinema.service.LoginService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
public class LoginController {
    private final LoginService loginService;

    public LoginController(LoginService loginService) {
        this.loginService = loginService;
    }

    @GetMapping("/")
    public String inicio(HttpSession session) {
        UsuarioAutenticado usuario = (UsuarioAutenticado) session.getAttribute("usuario");
        if (usuario == null) return "redirect:/login";
        return usuario.gerente() ? "redirect:/gerente" : "redirect:/funcionario";
    }

    @GetMapping("/login")
    public String login(Model model) {
        model.addAttribute("formulario", new LoginFormulario("", ""));
        return "login";
    }

    @PostMapping("/login")
    public String entrar(@Valid LoginFormulario formulario, BindingResult erros,
                         HttpServletRequest request, Model model) {
        if (erros.hasErrors()) {
            model.addAttribute("mensagem", "Preencha login e senha.");
            return "login";
        }
        try {
            UsuarioAutenticado usuario = loginService.autenticar(formulario.login(), formulario.senha());
            HttpSession session = request.getSession(true);
            request.changeSessionId();
            session.setAttribute("usuario", usuario);
            session.setMaxInactiveInterval(30 * 60);
            return usuario.gerente() ? "redirect:/gerente" : "redirect:/funcionario";
        } catch (IllegalArgumentException e) {
            model.addAttribute("mensagem", e.getMessage());
            return "login";
        }
    }

    @PostMapping("/sair")
    public String sair(HttpSession session) {
        session.invalidate();
        return "redirect:/login?logout";
    }
}

