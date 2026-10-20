package br.edu.cinema.service;

import br.edu.cinema.model.UsuarioAutenticado;
import br.edu.cinema.repository.FuncionarioRepository;
import org.springframework.stereotype.Service;

@Service
public class LoginService {
    private final FuncionarioRepository funcionarios;

    public LoginService(FuncionarioRepository funcionarios) {
        this.funcionarios = funcionarios;
    }

    public UsuarioAutenticado autenticar(String login, String senha) {
        return funcionarios.autenticar(login, senha)
                .orElseThrow(() -> new IllegalArgumentException("Login ou senha inválidos."));
    }
}
