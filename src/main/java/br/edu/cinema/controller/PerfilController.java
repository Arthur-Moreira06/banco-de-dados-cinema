package br.edu.cinema.controller;

import br.edu.cinema.model.UsuarioAutenticado;
import jakarta.servlet.http.HttpSession;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class PerfilController {
    private final JdbcTemplate jdbc;

    public PerfilController(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    @GetMapping("/perfil")
    public String perfil(HttpSession session, Model model) {
        UsuarioAutenticado usuario = (UsuarioAutenticado) session.getAttribute("usuario");
        model.addAttribute("usuario", usuario);
        model.addAttribute("dados", jdbc.queryForMap("""
                SELECT id_funcionario AS id, nome, CPF AS cpf, telefone, cargo, login,
                       perfil_acesso AS perfil, data_admissao AS admissao, ativo
                FROM funcionario
                WHERE id_funcionario=?
                """, usuario.id()));
        return "perfil";
    }
}
