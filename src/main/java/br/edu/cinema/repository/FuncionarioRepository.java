package br.edu.cinema.repository;

import br.edu.cinema.model.UsuarioAutenticado;
import br.edu.cinema.security.PasswordHasher;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public class FuncionarioRepository {
    private final JdbcTemplate jdbc;

    public FuncionarioRepository(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    public Optional<UsuarioAutenticado> autenticar(String login, String senha) {
        var encontrados = jdbc.query("""
                SELECT id_funcionario, nome, cargo, perfil_acesso, senha_hash
                FROM funcionario WHERE login = ? AND ativo = 1
                """, (rs, row) -> {
            String hash = rs.getString("senha_hash");
            if (hash == null || !PasswordHasher.verify(senha, hash)) return null;
            return new UsuarioAutenticado(rs.getInt("id_funcionario"), rs.getString("nome"),
                    rs.getString("cargo"), rs.getString("perfil_acesso"));
        }, login);
        return encontrados.stream().filter(java.util.Objects::nonNull).findFirst();
    }
}
