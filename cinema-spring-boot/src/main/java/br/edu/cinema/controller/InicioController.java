package br.edu.cinema.controller;

import br.edu.cinema.model.UsuarioAutenticado;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class InicioController {
    @GetMapping("/gerente")
    public String gerente(Model model, jakarta.servlet.http.HttpSession session) {
        model.addAttribute("usuario", session.getAttribute("usuario"));
        return "gerente";
    }

    @GetMapping("/funcionario")
    public String funcionario(Model model, jakarta.servlet.http.HttpSession session) {
        model.addAttribute("usuario", session.getAttribute("usuario"));
        return "funcionario";
    }
}
