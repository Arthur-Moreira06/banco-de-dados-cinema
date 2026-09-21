-- Script: 03_consultas.sql
-- 15 consultas de verificacao, cada uma com a pergunta que responde.
USE cinema;

-- 1) Pergunta: quais produtos a bomboniere vende, do mais caro para o
--    mais barato?
SELECT nome, categoria, preco_unitario_atual
FROM produto
ORDER BY preco_unitario_atual DESC;

-- 2) Pergunta: quais sessões começam no horário de pico, entre 18h e
--    22h?
SELECT id_sessao, data_sessao, horario_inicio, tipo
FROM sessao
WHERE horario_inicio BETWEEN '18:00:00' AND '22:00:00'
ORDER BY data_sessao, horario_inicio;

-- 3) Pergunta: quais clientes têm "Costa" em algum trecho do nome?
SELECT id_cliente, nome, email
FROM cliente
WHERE nome LIKE '%Costa%';

-- 4) Pergunta: quais funcionários ocupam cargos de liderança (Gerente
--    ou Projecionista)?
SELECT nome, cargo, data_admissao
FROM funcionario
WHERE cargo IN ('Gerente', 'Projecionista')
ORDER BY nome;

-- 5) Pergunta: quais projecionistas ainda estão sem sala de
--    responsabilidade cadastrada?
SELECT id_funcionario, id_gerente, certificado_tec
FROM projecionista
WHERE id_sala_responsavel IS NULL;

-- 6) Pergunta: qual filme está sendo exibido, em qual sala e a que
--    horário, em cada sessão programada?
SELECT s.id_sessao, f.titulo_original, sa.numero AS sala,
       s.data_sessao, s.horario_inicio
FROM sessao s
JOIN filme f ON f.id_filme = s.id_filme
JOIN sala sa ON sa.id_sala = s.id_sala
ORDER BY s.data_sessao, s.horario_inicio;

-- 7) Pergunta: quantas unidades de cada produto já foram vendidas,
--    incluindo produtos que eventualmente não tiveram nenhuma saída
--    (assim nenhum produto some da lista por falta de vendas)?
SELECT p.nome, p.categoria, COALESCE(SUM(vp.quantidade), 0) AS unidades_vendidas
FROM produto p
LEFT JOIN venda_produto vp ON vp.id_produto = p.id_produto
GROUP BY p.id_produto, p.nome, p.categoria
ORDER BY unidades_vendidas ASC;

-- 8) Pergunta: quais clientes já gastaram mais de R$ 40,00 no total,
--    somando ingressos e bomboniere?
SELECT c.nome, SUM(v.valor_total) AS total_gasto
FROM cliente c
JOIN venda v ON v.id_cliente = c.id_cliente
GROUP BY c.id_cliente, c.nome
HAVING SUM(v.valor_total) > 40
ORDER BY total_gasto DESC;

-- 9) Pergunta: qual o total vendido e a quantidade de vendas
--    processadas por cada funcionário?
SELECT f.nome, COUNT(v.id_venda) AS qtd_vendas, SUM(v.valor_total) AS total_vendido
FROM funcionario f
JOIN venda v ON v.id_funcionario = f.id_funcionario
GROUP BY f.id_funcionario, f.nome
ORDER BY total_vendido DESC;

-- 10) Pergunta: quem comprou ingresso, para qual filme, sessão e
--     assento?
SELECT c.nome AS cliente, fi.titulo_original AS filme,
       s.data_sessao, s.horario_inicio,
       a.fileira, a.numero AS assento_numero
FROM ingresso i
JOIN cliente c ON c.id_cliente = i.id_cliente
JOIN sessao s ON s.id_sessao = i.id_sessao
JOIN filme fi ON fi.id_filme = s.id_filme
JOIN assento a ON a.id_assento = i.id_assento
ORDER BY s.data_sessao, s.horario_inicio;

-- 11) Pergunta: quais filmes têm duração maior que a média de duração
--     dos filmes do mesmo gênero?
SELECT f1.titulo_original, f1.genero_principal, f1.duracao_minutos
FROM filme f1
WHERE f1.duracao_minutos > (
    SELECT AVG(f2.duracao_minutos)
    FROM filme f2
    WHERE f2.genero_principal = f1.genero_principal
);

-- 12) Pergunta: quais clientes já compraram pelo menos um ingresso de
--     meia-entrada?
SELECT c.nome
FROM cliente c
WHERE EXISTS (
    SELECT 1
    FROM ingresso i
    WHERE i.id_cliente = c.id_cliente
      AND i.tipo = 'Meia-entrada'
);

-- 13) Pergunta: quais assentos da sala 1 ainda estão livres para a
--     sessão 2 (Além da Fronteira, 25/09), considerando apenas
--     ingressos cujo status mais recente não é "Cancelado"?
SELECT a.id_assento, a.fileira, a.numero
FROM assento a
WHERE a.id_sala = 1
  AND NOT EXISTS (
      SELECT 1
      FROM ingresso i
      WHERE i.id_sessao = 2
        AND i.id_assento = a.id_assento
        AND (
            SELECT h.status
            FROM ingresso_status_historico h
            WHERE h.id_ingresso = i.id_ingresso
            ORDER BY h.data_hora DESC, h.id_status_hist DESC
            LIMIT 1
        ) <> 'Cancelado'
  )
ORDER BY a.fileira, a.numero;

-- 14) Pergunta: qual a taxa de ocupação (percentual de assentos
--     vendidos, desconsiderando ingressos cancelados) de cada sessão
--     programada?
WITH ingressos_ativos AS (
    SELECT i.id_sessao, COUNT(*) AS qtd
    FROM ingresso i
    WHERE (
        SELECT h.status
        FROM ingresso_status_historico h
        WHERE h.id_ingresso = i.id_ingresso
        ORDER BY h.data_hora DESC, h.id_status_hist DESC
        LIMIT 1
    ) <> 'Cancelado'
    GROUP BY i.id_sessao
)
SELECT s.id_sessao, f.titulo_original, sa.capacidade,
       COALESCE(ia.qtd, 0) AS ingressos_ativos,
       ROUND(COALESCE(ia.qtd, 0) * 100.0 / sa.capacidade, 1) AS taxa_ocupacao_pct
FROM sessao s
JOIN filme f ON f.id_filme = s.id_filme
JOIN sala sa ON sa.id_sala = s.id_sala
LEFT JOIN ingressos_ativos ia ON ia.id_sessao = s.id_sessao
ORDER BY taxa_ocupacao_pct DESC;

-- 15) Pergunta: quantos pontos de fidelidade cada cliente tem
--     efetivamente disponíveis hoje, descontando os que já expiraram?
SELECT c.nome, COALESCE(SUM(fp.pontos), 0) AS pontos_validos
FROM cliente c
LEFT JOIN fidelidade_pontos fp
    ON fp.id_cliente = c.id_cliente
   AND fp.data_expiracao > NOW()
GROUP BY c.id_cliente, c.nome
ORDER BY pontos_validos DESC;
