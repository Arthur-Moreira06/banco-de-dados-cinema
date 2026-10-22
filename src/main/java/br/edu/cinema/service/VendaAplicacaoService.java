package br.edu.cinema.service;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.PreparedStatement;
import java.sql.Statement;
import java.util.List;
import java.util.Map;

@Service
public class VendaAplicacaoService {
    private final JdbcTemplate jdbc;
    public VendaAplicacaoService(JdbcTemplate jdbc) { this.jdbc = jdbc; }

    @Transactional
    public void venderProduto(int produtoId, int quantidade, Integer clienteId, int funcionarioId, String pagamento) {
        if (quantidade < 1) throw new IllegalArgumentException("A quantidade deve ser maior que zero.");
        Map<String,Object> produto = jdbc.queryForMap("SELECT preco_unitario_atual,estoque_atual FROM produto WHERE id_produto=? FOR UPDATE", produtoId);
        BigDecimal preco = (BigDecimal) produto.get("preco_unitario_atual");
        int estoque = ((Number)produto.get("estoque_atual")).intValue();
        if (estoque < quantidade) throw new IllegalArgumentException("Estoque insuficiente.");
        if (jdbc.update("UPDATE produto SET estoque_atual=estoque_atual-? WHERE id_produto=? AND estoque_atual>=?", quantidade, produtoId, quantidade) != 1)
            throw new IllegalArgumentException("Estoque insuficiente.");
        BigDecimal total = preco.multiply(BigDecimal.valueOf(quantidade));
        int vendaId = inserirId("INSERT INTO venda(id_cliente,id_funcionario,valor_total) VALUES(?,?,?)", clienteId, funcionarioId, total);
        jdbc.update("INSERT INTO venda_produto(id_venda,id_produto,quantidade,preco_unitario_venda) VALUES(?,?,?,?)", vendaId, produtoId, quantidade, preco);
        jdbc.update("INSERT INTO pagamento(id_venda,valor,forma_pagamento) VALUES(?,?,?)", vendaId, total, pagamento);
        if (clienteId != null) inserirPontos(clienteId, vendaId, total);
    }

    @Transactional
    public void venderIngresso(int sessaoId, int assentoId, int clienteId, Integer documentoId,
                               String tipo, int funcionarioId, String pagamento, Map<Integer,Integer> produtosSelecionados) {
        if (!List.of("Inteira", "Meia-entrada").contains(tipo)) throw new IllegalArgumentException("Selecione o tipo de ingresso.");
        if (tipo.equals("Meia-entrada") && documentoId == null) throw new IllegalArgumentException("Meia-entrada exige documento comprobatório.");
        Integer salaId = jdbc.queryForObject("SELECT id_sala FROM sessao WHERE id_sessao=? FOR UPDATE", Integer.class, sessaoId);
        if (salaId == null) throw new IllegalArgumentException("Sessão não encontrada.");
        BigDecimal base = jdbc.query("SELECT preco_base FROM sessao_preco_historico WHERE id_sessao=? AND vigencia_inicio<=NOW() ORDER BY vigencia_inicio DESC,id_preco DESC LIMIT 1",
                rs -> rs.next() ? rs.getBigDecimal(1) : null, sessaoId);
        if (base == null) throw new IllegalArgumentException("A sessão não possui preço vigente.");
        Integer assentoValido = jdbc.queryForObject("SELECT COUNT(*) FROM assento WHERE id_assento=? AND id_sala=?", Integer.class, assentoId, salaId);
        if (assentoValido == null || assentoValido == 0) throw new IllegalArgumentException("O assento não pertence à sala dessa sessão.");
        if (documentoId != null) {
            Integer documentoValido = jdbc.queryForObject("SELECT COUNT(*) FROM documento_meia_entrada d JOIN cliente c ON c.id_cliente=d.id_cliente WHERE d.id_documento=? AND d.id_cliente=? AND (d.validade IS NULL OR d.validade>=CURDATE()) AND (d.tipo_documento<>'Idoso' OR c.data_nascimento<=DATE_SUB(CURDATE(),INTERVAL 60 YEAR))", Integer.class, documentoId, clienteId);
            if (documentoValido == null || documentoValido == 0) throw new IllegalArgumentException("Documento inválido, vencido, de outro cliente ou sem critério para meia-entrada.");
        }
        BigDecimal valor = tipo.equals("Meia-entrada") ? base.divide(BigDecimal.valueOf(2), 2, RoundingMode.HALF_UP) : base;
        Map<Integer,Map<String,Object>> produtos = new java.util.LinkedHashMap<>();
        BigDecimal totalProdutos = BigDecimal.ZERO;
        for (Map.Entry<Integer,Integer> item : produtosSelecionados.entrySet()) {
            int quantidade = item.getValue();
            if (quantidade < 1) continue;
            Map<String,Object> produto = jdbc.queryForMap(
                    "SELECT nome,preco_unitario_atual,estoque_atual FROM produto WHERE id_produto=? FOR UPDATE", item.getKey());
            int estoque = ((Number) produto.get("estoque_atual")).intValue();
            if (estoque < quantidade) throw new IllegalArgumentException("Estoque insuficiente para " + produto.get("nome") + ".");
            BigDecimal preco = (BigDecimal) produto.get("preco_unitario_atual");
            if (jdbc.update("UPDATE produto SET estoque_atual=estoque_atual-? WHERE id_produto=? AND estoque_atual>=?",
                    quantidade, item.getKey(), quantidade) != 1) {
                throw new IllegalArgumentException("Estoque insuficiente para " + produto.get("nome") + ".");
            }
            produto.put("quantidade", quantidade);
            produtos.put(item.getKey(), produto);
            totalProdutos = totalProdutos.add(preco.multiply(BigDecimal.valueOf(quantidade)));
        }
        BigDecimal totalPedido = valor.add(totalProdutos);
        int ingressoId = inserirId("INSERT INTO ingresso(id_sessao,id_assento,id_cliente,id_documento,tipo,preco_pago) VALUES(?,?,?,?,?,?)",
                sessaoId, assentoId, clienteId, documentoId, tipo, valor);
        jdbc.update("INSERT INTO ingresso_status_historico(id_ingresso,status,id_funcionario) VALUES(?,'Reservado',?)", ingressoId, funcionarioId);
        jdbc.update("INSERT INTO ingresso_status_historico(id_ingresso,status,id_funcionario) VALUES(?,'Pago',?)", ingressoId, funcionarioId);
        int vendaId = inserirId("INSERT INTO venda(id_cliente,id_funcionario,valor_total) VALUES(?,?,?)", clienteId, funcionarioId, totalPedido);
        jdbc.update("INSERT INTO venda_ingresso(id_venda,id_ingresso) VALUES(?,?)", vendaId, ingressoId);
        for (Map.Entry<Integer,Map<String,Object>> item : produtos.entrySet()) {
            Map<String,Object> produto = item.getValue();
            jdbc.update("INSERT INTO venda_produto(id_venda,id_produto,quantidade,preco_unitario_venda) VALUES(?,?,?,?)",
                    vendaId, item.getKey(), produto.get("quantidade"), produto.get("preco_unitario_atual"));
        }
        jdbc.update("INSERT INTO pagamento(id_venda,valor,forma_pagamento) VALUES(?,?,?)", vendaId, totalPedido, pagamento);
        inserirPontos(clienteId, vendaId, totalPedido);
    }

    private void inserirPontos(int clienteId, int vendaId, BigDecimal total) {
        int pontos = Math.max(1, total.setScale(0, RoundingMode.FLOOR).intValue());
        jdbc.update("INSERT INTO fidelidade_pontos(id_cliente,id_venda,pontos,data_credito,data_expiracao) VALUES(?,?,?,NOW(),DATE_ADD(NOW(),INTERVAL 12 MONTH))", clienteId, vendaId, pontos);
    }

    private int inserirId(String sql, Object... values) {
        KeyHolder keys = new GeneratedKeyHolder();
        jdbc.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            for (int i=0;i<values.length;i++) ps.setObject(i+1, values[i]);
            return ps;
        }, keys);
        Number key = keys.getKey();
        if (key == null) throw new IllegalStateException("O banco não retornou o identificador gerado.");
        return key.intValue();
    }
}
