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

    public List<Map<String,Object>> relatorio() {
        return jdbc.queryForList("SELECT * FROM vw_relatorio_sessao ORDER BY data_sessao,horario_inicio");
    }
    public List<Map<String,Object>> filmes() { return jdbc.queryForList("SELECT id_filme AS id,titulo_original AS titulo FROM filme ORDER BY titulo_original"); }
}


