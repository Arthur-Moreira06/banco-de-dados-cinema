package br.edu.cinema.controller;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/gerente/notificacoes")
public class NotificacoesGerenteController {
    private final JdbcTemplate jdbc;

    public NotificacoesGerenteController(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    @GetMapping
    public Map<String, Object> recentes(@RequestParam(required = false) Long desdeId) {
        Long ultimoId = jdbc.queryForObject("SELECT COALESCE(MAX(id_venda),0) FROM venda", Long.class);
        int naoLidas = desdeId == null || desdeId < 0 ? 0
                : jdbc.queryForObject("SELECT COUNT(*) FROM venda WHERE id_venda>?", Integer.class, desdeId);
        List<Map<String, Object>> vendas = jdbc.queryForList("""
                SELECT v.id_venda AS id,
                       DATE_FORMAT(v.data_venda,'%Y-%m-%dT%H:%i:%s') AS dataVenda,
                       v.valor_total AS valor,
                       func.nome AS funcionario,
                       COALESCE(GROUP_CONCAT(DISTINCT CONCAT(vp.quantidade,'× ',prod.nome)
                           ORDER BY prod.nome SEPARATOR ' · '),'') AS produtos,
                       COUNT(DISTINCT vi.id_ingresso) AS quantidadeIngressos,
                       COALESCE(GROUP_CONCAT(DISTINCT CONCAT(filme.titulo_original,' — ',
                           DATE_FORMAT(sessao.data_sessao,'%d/%m/%Y'),' às ',
                           TIME_FORMAT(sessao.horario_inicio,'%H:%i'),' — Assento ',
                           assento.fileira,'-',assento.numero)
                           ORDER BY sessao.data_sessao,sessao.horario_inicio,assento.fileira,assento.numero
                           SEPARATOR ' | '),'') AS sessoes
                FROM venda v
                JOIN funcionario func ON func.id_funcionario=v.id_funcionario
                LEFT JOIN venda_produto vp ON vp.id_venda=v.id_venda
                LEFT JOIN produto prod ON prod.id_produto=vp.id_produto
                LEFT JOIN venda_ingresso vi ON vi.id_venda=v.id_venda
                LEFT JOIN ingresso ing ON ing.id_ingresso=vi.id_ingresso
                LEFT JOIN sessao ON sessao.id_sessao=ing.id_sessao
                LEFT JOIN filme ON filme.id_filme=sessao.id_filme
                LEFT JOIN assento ON assento.id_assento=ing.id_assento
                GROUP BY v.id_venda,v.data_venda,v.valor_total,func.nome
                ORDER BY v.data_venda DESC,v.id_venda DESC
                """);
        return Map.of("ultimoId", ultimoId == null ? 0L : ultimoId,
                "naoLidas", naoLidas, "vendas", vendas);
    }
}
