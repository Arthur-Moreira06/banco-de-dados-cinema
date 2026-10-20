package br.edu.cinema.repository;

import br.edu.cinema.catalogo.CadastroDefinicao;
import br.edu.cinema.catalogo.CampoFormulario;
import br.edu.cinema.security.PasswordHasher;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Time;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Repository
public class CadastroRepository {
    private final JdbcTemplate jdbc;
    public CadastroRepository(JdbcTemplate jdbc) { this.jdbc = jdbc; }

    public List<Map<String, Object>> listar(CadastroDefinicao d) { return jdbc.queryForList(d.consultaLista()); }

    public Map<String, Object> buscar(CadastroDefinicao d, int id) {
        String sql;
        if (d.tipo().equals("sessoes")) {
            sql = "SELECT id_sessao, id_filme, id_sala, data_sessao, horario_inicio, idioma, tipo, " +
                    "(SELECT preco_base FROM sessao_preco_historico WHERE id_sessao=sessao.id_sessao ORDER BY vigencia_inicio DESC,id_preco DESC LIMIT 1) AS preco " +
                    "FROM sessao WHERE id_sessao=?";
        } else {
            sql = "SELECT * FROM " + d.tabela() + " WHERE " + d.colunaId() + "=?";
        }
        return jdbc.queryForObject(sql, rowMap(), id);
    }

    @Transactional
    public void salvar(CadastroDefinicao d, Integer id, Map<String, String> valores) {
        if (d.tipo().equals("funcionarios")) { salvarFuncionario(d, id, valores); return; }
        if (d.tipo().equals("sessoes")) { salvarSessao(id, valores); return; }
        List<String> colunas = d.colunas();
        Object[] args = colunas.stream().map(col -> converter(d, col, valores.get(col))).toArray();
        if (id == null) {
            String nomes = String.join(",", colunas);
            String pontos = String.join(",", java.util.Collections.nCopies(colunas.size(), "?"));
            jdbc.update("INSERT INTO " + d.tabela() + " (" + nomes + ") VALUES (" + pontos + ")", args);
        } else {
            String sets = String.join(",", colunas.stream().map(c -> c + "=?").toList());
            Object[] comId = java.util.Arrays.copyOf(args, args.length + 1);
            comId[args.length] = id;
            jdbc.update("UPDATE " + d.tabela() + " SET " + sets + " WHERE " + d.colunaId() + "=?", comId);
        }
    }

    private void salvarFuncionario(CadastroDefinicao d, Integer id, Map<String, String> v) {
        String senha = v.get("senha");
        if (id == null && (senha == null || senha.isBlank())) throw new IllegalArgumentException("Defina uma senha para o funcionário.");
        if (id == null) {
            jdbc.update("INSERT INTO funcionario (nome,CPF,telefone,cargo,login,senha_hash,perfil_acesso,data_admissao,ativo) VALUES (?,?,?,?,?,?,?,?,?)",
                    v.get("nome"), v.get("CPF"), blankNull(v.get("telefone")), v.get("cargo"), v.get("login"),
                    PasswordHasher.hash(senha), v.get("perfil_acesso"), Date.valueOf(v.get("data_admissao")), Integer.parseInt(v.get("ativo")));
        } else if (senha == null || senha.isBlank()) {
            jdbc.update("UPDATE funcionario SET nome=?,CPF=?,telefone=?,cargo=?,login=?,perfil_acesso=?,data_admissao=?,ativo=? WHERE id_funcionario=?",
                    v.get("nome"), v.get("CPF"), blankNull(v.get("telefone")), v.get("cargo"), v.get("login"),
                    v.get("perfil_acesso"), Date.valueOf(v.get("data_admissao")), Integer.parseInt(v.get("ativo")), id);
        } else {
            jdbc.update("UPDATE funcionario SET nome=?,CPF=?,telefone=?,cargo=?,login=?,senha_hash=?,perfil_acesso=?,data_admissao=?,ativo=? WHERE id_funcionario=?",
                    v.get("nome"), v.get("CPF"), blankNull(v.get("telefone")), v.get("cargo"), v.get("login"),
                    PasswordHasher.hash(senha), v.get("perfil_acesso"), Date.valueOf(v.get("data_admissao")), Integer.parseInt(v.get("ativo")), id);
        }
    }

    private void salvarSessao(Integer id, Map<String, String> v) {
        int filme = Integer.parseInt(v.get("id_filme")), sala = Integer.parseInt(v.get("id_sala"));
        Date data = Date.valueOf(v.get("data_sessao"));
        Time horario = Time.valueOf(v.get("horario_inicio").length() == 5 ? v.get("horario_inicio") + ":00" : v.get("horario_inicio"));
        if (id == null) {
            jdbc.update("INSERT INTO sessao (id_filme,id_sala,data_sessao,horario_inicio,idioma,tipo) VALUES (?,?,?,?,?,?)", filme, sala, data, horario, v.get("idioma"), v.get("tipo"));
            Integer novoId = jdbc.queryForObject("SELECT LAST_INSERT_ID()", Integer.class);
            jdbc.update("INSERT INTO sessao_preco_historico (id_sessao,preco_base,vigencia_inicio) VALUES (?,?,NOW())", novoId, new BigDecimal(v.get("preco")));
        } else {
            jdbc.update("UPDATE sessao SET id_filme=?,id_sala=?,data_sessao=?,horario_inicio=?,idioma=?,tipo=? WHERE id_sessao=?", filme, sala, data, horario, v.get("idioma"), v.get("tipo"), id);
            jdbc.update("INSERT INTO sessao_preco_historico (id_sessao,preco_base,vigencia_inicio) VALUES (?,?,GREATEST(NOW(),TIMESTAMPADD(SECOND,1,COALESCE((SELECT MAX(vigencia_inicio) FROM sessao_preco_historico WHERE id_sessao=?),NOW()))))", id, new BigDecimal(v.get("preco")), id);
        }
    }

    @Transactional
    public void excluir(CadastroDefinicao d, int id) { jdbc.update("DELETE FROM " + d.tabela() + " WHERE " + d.colunaId() + "=?", id); }

    public Map<String, String> valoresFormulario(CadastroDefinicao d, int id) {
        Map<String, Object> row = buscar(d, id);
        Map<String, String> values = new LinkedHashMap<>();
        for (CampoFormulario c : d.campos()) {
            Object value = row.get(c.nome().toLowerCase());
            if (value == null && c.nome().equals("preco")) value = row.get("preco");
            String text = value == null ? "" : value.toString();
            if (value != null && c.tipo().equals("time") && text.length() >= 5) text = text.substring(0, 5);
            values.put(c.nome(), text);
        }
        if (d.tipo().equals("funcionarios")) values.put("senha", "");
        return values;
    }

    private Object converter(CadastroDefinicao d, String column, String value) {
        if ((value == null || value.isBlank()) && (column.equals("telefone") || column.equals("sinopse") || column.equals("id_filme_relacionado") || column.equals("tipo_relacao"))) return null;
        if (column.equals("id_filme_relacionado")) return Integer.valueOf(value);
        CampoFormulario field = d.campos().stream().filter(c -> c.nome().equals(column)).findFirst().orElse(null);
        if (field == null || value == null || value.isBlank()) return value;
        return switch (field.tipo()) {
            case "number" -> Integer.valueOf(value);
            case "decimal" -> new BigDecimal(value.replace(',', '.'));
            case "date" -> Date.valueOf(value);
            case "time" -> Time.valueOf(value.length() == 5 ? value + ":00" : value);
            default -> value;
        };
    }
    private static String blankNull(String value) { return value == null || value.isBlank() ? null : value; }
    private static RowMapper<Map<String, Object>> rowMap() { return (rs, n) -> {
        var meta = rs.getMetaData(); var row = new LinkedHashMap<String, Object>();
        for (int i=1;i<=meta.getColumnCount();i++) row.put(meta.getColumnLabel(i).toLowerCase(), rs.getObject(i));
        return row;
    }; }
}


