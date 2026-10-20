USE cinema;

-- A: distribuição de sessões por data. Compare EXPLAIN antes/depois de idx_sessao_data_filme.
EXPLAIN SELECT s.id_sessao, s.data_sessao, f.titulo_original
FROM sessao s JOIN filme f ON f.id_filme=s.id_filme
WHERE s.data_sessao BETWEEN '2026-10-01' AND '2026-10-31' AND s.id_filme=1;

-- B: consulta por cliente/sessão. Compare antes/depois de idx_ingresso_cliente_sessao.
EXPLAIN SELECT i.id_ingresso, i.id_sessao, i.preco_pago
FROM ingresso i WHERE i.id_cliente=1 AND i.id_sessao=2;

-- C: vendas por período e funcionário. Compare antes/depois de idx_venda_data_funcionario.
EXPLAIN SELECT v.id_venda, v.data_venda, v.valor_total
FROM venda v WHERE v.data_venda BETWEEN '2026-09-01' AND '2026-10-31'
  AND v.id_funcionario=1;

-- Para obter planos verdadeiramente “antes”: rode os EXPLAIN acima ANTES de 03_etapa2.sql.
-- MySQL 8 também aceita EXPLAIN ANALYZE SELECT ... para executar e medir. Anote linhas
-- estimadas/reais e tempo em ambiente, número de linhas e índice escolhido; não invente dados.
