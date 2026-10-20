package br.edu.cinema.catalogo;

import org.springframework.stereotype.Component;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Component
public class CatalogoCadastros {
    private final Map<String, CadastroDefinicao> cadastros = new LinkedHashMap<>();

    public CatalogoCadastros() {
        adicionar(new CadastroDefinicao("clientes", "Clientes", "cliente", "id_cliente",
                "SELECT id_cliente AS id, nome, CPF AS cpf, telefone, email, data_nascimento FROM cliente ORDER BY nome",
                List.of("nome", "CPF", "telefone", "email", "data_nascimento"), List.of(
                c("nome", "Nome", "text", true), c("CPF", "CPF (11 dígitos)", "text", true),
                c("telefone", "Telefone", "text", false), c("email", "E-mail", "email", true),
                c("data_nascimento", "Nascimento", "date", true))));
        adicionar(new CadastroDefinicao("funcionarios", "Funcionários", "funcionario", "id_funcionario",
                "SELECT id_funcionario AS id, nome, CPF AS cpf, telefone, cargo, login, perfil_acesso, data_admissao, ativo FROM funcionario ORDER BY nome",
                List.of("nome", "CPF", "telefone", "cargo", "login", "senha_hash", "perfil_acesso", "data_admissao", "ativo"), List.of(
                c("nome", "Nome", "text", true), c("CPF", "CPF (11 dígitos)", "text", true),
                c("telefone", "Telefone", "text", false), s("cargo", "Cargo", true, "Atendente", "Gerente", "Projecionista"),
                c("login", "Login", "text", true), c("senha", "Senha (deixe vazia para manter ao editar)", "password", false),
                s("perfil_acesso", "Perfil de acesso", true, "Operacional", "Administrativo"),
                c("data_admissao", "Admissão", "date", true), s("ativo", "Ativo", true, "1", "0"))));
        adicionar(new CadastroDefinicao("filmes", "Filmes", "filme", "id_filme",
                "SELECT f.id_filme AS id, f.titulo_original AS titulo, f.duracao_minutos AS duracao, f.genero_principal AS genero, f.classificacao_indicativa AS classificacao, f.id_filme_relacionado AS relacionado, f.tipo_relacao AS relacao FROM filme f ORDER BY f.titulo_original",
                List.of("titulo_original", "sinopse", "duracao_minutos", "genero_principal", "classificacao_indicativa", "id_filme_relacionado", "tipo_relacao"), List.of(
                c("titulo_original", "Título", "text", true), c("sinopse", "Sinopse", "textarea", false),
                c("duracao_minutos", "Duração (minutos)", "number", true), c("genero_principal", "Gênero", "text", true),
                s("classificacao_indicativa", "Classificação", true, "L", "10", "12", "14", "16", "18"),
                c("id_filme_relacionado", "ID do filme relacionado (opcional)", "number", false),
                s("tipo_relacao", "Tipo de relação (opcional)", false, "Sequencia", "Preludio"))));
        adicionar(new CadastroDefinicao("salas", "Salas", "sala", "id_sala",
                "SELECT id_sala AS id, numero, capacidade, tipo_projecao FROM sala ORDER BY numero",
                List.of("numero", "capacidade", "tipo_projecao"), List.of(
                c("numero", "Número/nome", "text", true), c("capacidade", "Capacidade", "number", true),
                s("tipo_projecao", "Projeção", true, "2D", "3D", "IMAX"))));
        adicionar(new CadastroDefinicao("produtos", "Produtos", "produto", "id_produto",
                "SELECT id_produto AS id, nome, categoria, preco_unitario_atual AS preco, estoque_atual AS estoque, estoque_minimo AS minimo FROM produto ORDER BY nome",
                List.of("nome", "categoria", "preco_unitario_atual", "estoque_atual", "estoque_minimo"), List.of(
                c("nome", "Nome", "text", true), s("categoria", "Categoria", true, "Pipoca", "Bebida", "Doce", "Combo", "Outro"),
                c("preco_unitario_atual", "Preço unitário", "decimal", true), c("estoque_atual", "Estoque", "number", true),
                c("estoque_minimo", "Estoque mínimo", "number", true))));
        adicionar(new CadastroDefinicao("sessoes", "Sessões", "sessao", "id_sessao",
                "SELECT s.id_sessao AS id, f.titulo_original AS filme, sa.numero AS sala, s.data_sessao AS data, s.horario_inicio AS inicio, s.idioma, s.tipo, p.preco_base AS preco FROM sessao s JOIN filme f ON f.id_filme=s.id_filme JOIN sala sa ON sa.id_sala=s.id_sala LEFT JOIN sessao_preco_historico p ON p.id_preco=(SELECT p2.id_preco FROM sessao_preco_historico p2 WHERE p2.id_sessao=s.id_sessao ORDER BY p2.vigencia_inicio DESC, p2.id_preco DESC LIMIT 1) ORDER BY s.data_sessao,s.horario_inicio",
                List.of("id_filme", "id_sala", "data_sessao", "horario_inicio", "idioma", "tipo"), List.of(
                c("id_filme", "ID do filme", "number", true), c("id_sala", "ID da sala", "number", true),
                c("data_sessao", "Data", "date", true), c("horario_inicio", "Horário", "time", true),
                s("idioma", "Idioma", true, "Dublado", "Legendado", "Original"),
                s("tipo", "Projeção", true, "2D", "3D", "IMAX"), c("preco", "Preço base", "decimal", true))));
    }

    private static CampoFormulario c(String n, String r, String t, boolean req) { return new CampoFormulario(n, r, t, req); }
    private static CampoFormulario s(String n, String r, boolean req, String... options) { return new CampoFormulario(n, r, "select", req, List.of(options)); }
    private void adicionar(CadastroDefinicao d) { cadastros.put(d.tipo(), d); }
    public CadastroDefinicao obter(String tipo) {
        CadastroDefinicao cadastro = cadastros.get(tipo);
        if (cadastro == null) throw new IllegalArgumentException("Cadastro não encontrado.");
        return cadastro;
    }
    public List<CadastroDefinicao> todos() { return List.copyOf(cadastros.values()); }
}
