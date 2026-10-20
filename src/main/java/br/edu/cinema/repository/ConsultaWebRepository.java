package br.edu.cinema.repository;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.sql.Date;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@Repository
public class ConsultaWebRepository {
    private final JdbcTemplate jdbc;
    public ConsultaWebRepository(JdbcTemplate jdbc) { this.jdbc = jdbc; }

    public List<Map<String,Object>> sessoes(String inicio, String fim, String filme) {
        Date dataInicial = Date.valueOf(LocalDate.parse(inicio));
        Date dataFinal = Date.valueOf(LocalDate.parse(fim));
        return jdbc.queryForList("""
                SELECT s.id_sessao AS id, s.data_sessao AS data, s.horario_inicio AS horario,
                       f.titulo_original AS filme, COUNT(i.id_ingresso) AS ingressos,
                       COALESCE(SUM(i.preco_pago),0) AS receita
                FROM ingresso i
                JOIN sessao s ON s.id_sessao=i.id_sessao
                JOIN filme f ON f.id_filme=s.id_filme
                WHERE DATE(i.data_compra) BETWEEN ? AND ?
                  AND (?='' OR s.id_filme=?)
                  AND COALESCE((
                      SELECT h.status
                      FROM ingresso_status_historico h
                      WHERE h.id_ingresso=i.id_ingresso
                      ORDER BY h.data_hora DESC,h.id_status_hist DESC
                      LIMIT 1
                  ), 'Reservado') IN ('Pago','Utilizado')
                GROUP BY s.id_sessao,s.data_sessao,s.horario_inicio,f.titulo_original
                ORDER BY s.data_sessao,s.horario_inicio
                """, dataInicial, dataFinal, filme, filme.isBlank() ? null : Integer.valueOf(filme));
    }

    public List<Map<String,Object>> produtos(String inicio, String fim, String categoria) {
        Date dataInicial = Date.valueOf(LocalDate.parse(inicio));
        Date dataFinal = Date.valueOf(LocalDate.parse(fim));
        return jdbc.queryForList("""
                SELECT p.id_produto AS id,p.nome,p.categoria,
                       SUM(vp.quantidade) AS unidades,
                       SUM(vp.quantidade*vp.preco_unitario_venda) AS faturamento
                FROM venda v
                JOIN pagamento pg ON pg.id_venda=v.id_venda
                JOIN venda_produto vp ON vp.id_venda=v.id_venda
                JOIN produto p ON p.id_produto=vp.id_produto
                WHERE DATE(pg.data_pagamento) BETWEEN ? AND ?
                  AND (?='Todas' OR p.categoria=?)
                GROUP BY p.id_produto,p.nome,p.categoria ORDER BY faturamento DESC
                """, dataInicial, dataFinal, categoria, categoria);
    }

    public List<Map<String,Object>> graficoVendasGerais(String inicio, String fim) {
        Date dataInicial = Date.valueOf(LocalDate.parse(inicio));
        Date dataFinal = Date.valueOf(LocalDate.parse(fim));
        return jdbc.queryForList("""
                SELECT 'Ingresso' AS tipo, f.titulo_original AS nome,
                       COUNT(i.id_ingresso) AS unidades, COALESCE(SUM(i.preco_pago),0) AS faturamento
                FROM ingresso i
                JOIN sessao s ON s.id_sessao=i.id_sessao
                JOIN filme f ON f.id_filme=s.id_filme
                WHERE DATE(i.data_compra) BETWEEN ? AND ?
                  AND COALESCE((SELECT h.status FROM ingresso_status_historico h
                                WHERE h.id_ingresso=i.id_ingresso
                                ORDER BY h.data_hora DESC,h.id_status_hist DESC LIMIT 1), 'Reservado') IN ('Pago','Utilizado')
                GROUP BY f.id_filme,f.titulo_original
                UNION ALL
                SELECT CONCAT('Produto · ',p.categoria) AS tipo, p.nome,
                       SUM(vp.quantidade) AS unidades,
                       SUM(vp.quantidade*vp.preco_unitario_venda) AS faturamento
                FROM venda v
                JOIN pagamento pg ON pg.id_venda=v.id_venda
                JOIN venda_produto vp ON vp.id_venda=v.id_venda
                JOIN produto p ON p.id_produto=vp.id_produto
                WHERE DATE(pg.data_pagamento) BETWEEN ? AND ?
                GROUP BY p.id_produto,p.nome,p.categoria
                ORDER BY faturamento DESC,nome
                """, dataInicial, dataFinal, dataInicial, dataFinal);
    }

    public List<Map<String,Object>> filmesComSessoes() {
        return jdbc.queryForList("""
                SELECT f.id_filme AS id, f.titulo_original AS titulo, f.sinopse,
                       f.genero_principal AS genero, f.classificacao_indicativa AS classificacao,
                       s.id_sessao AS sessao_id, s.data_sessao AS data, s.horario_inicio AS horario,
                       s.idioma, s.tipo, sa.numero AS sala,
                       (SELECT ph.preco_base FROM sessao_preco_historico ph
                        WHERE ph.id_sessao=s.id_sessao AND ph.vigencia_inicio<=NOW()
                        ORDER BY ph.vigencia_inicio DESC,ph.id_preco DESC LIMIT 1) AS preco
                FROM filme f
                LEFT JOIN sessao s ON s.id_filme=f.id_filme
                LEFT JOIN sala sa ON sa.id_sala=s.id_sala
                ORDER BY f.titulo_original,s.data_sessao,s.horario_inicio
                """);
    }

    public Map<String,Object> detalhesSessao(int sessaoId) {
        return jdbc.queryForMap("""
                SELECT f.titulo_original AS titulo, f.sinopse,
                       f.genero_principal AS genero, f.classificacao_indicativa AS classificacao,
                       s.data_sessao AS data, s.horario_inicio AS horario, s.idioma, s.tipo, sa.numero AS sala
                FROM sessao s JOIN filme f ON f.id_filme=s.id_filme
                JOIN sala sa ON sa.id_sala=s.id_sala
                WHERE s.id_sessao=?
                """, sessaoId);
    }

    public List<Map<String,Object>> relatorio() {
        return jdbc.queryForList("""
                WITH status_recente AS (
                    SELECT h.id_ingresso, h.status,
                           ROW_NUMBER() OVER (
                               PARTITION BY h.id_ingresso
                               ORDER BY h.data_hora DESC, h.id_status_hist DESC
                           ) AS ordem
                    FROM ingresso_status_historico h
                ), vendas_sessao AS (
                    SELECT i.id_sessao,
                           SUM(CASE WHEN COALESCE(sr.status, 'Reservado') <> 'Cancelado' THEN 1 ELSE 0 END) AS ingressos,
                           SUM(CASE WHEN COALESCE(sr.status, 'Reservado') IN ('Pago', 'Utilizado') THEN i.preco_pago ELSE 0 END) AS receita
                    FROM ingresso i
                    LEFT JOIN status_recente sr
                        ON sr.id_ingresso = i.id_ingresso AND sr.ordem = 1
                    GROUP BY i.id_sessao
                )
                SELECT s.id_sessao AS id,
                       s.data_sessao AS data,
                       s.horario_inicio AS horario,
                       f.titulo_original AS filme,
                       sa.capacidade,
                       COALESCE(vs.ingressos, 0) AS ingressos,
                       ROUND(COALESCE(vs.ingressos, 0) * 100.0 / NULLIF(sa.capacidade, 0), 1) AS ocupacao_percentual,
                       COALESCE(vs.receita, 0) AS receita
                FROM sessao s
                JOIN filme f ON f.id_filme = s.id_filme
                JOIN sala sa ON sa.id_sala = s.id_sala
                LEFT JOIN vendas_sessao vs ON vs.id_sessao = s.id_sessao
                ORDER BY s.data_sessao, s.horario_inicio
                """);
    }
    public List<Map<String,Object>> filmes() { return jdbc.queryForList("SELECT id_filme AS id,titulo_original AS titulo FROM filme ORDER BY titulo_original"); }
}


