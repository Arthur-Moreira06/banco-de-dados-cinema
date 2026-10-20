USE cinema;

-- Índices compostos para os filtros mais comuns (data, filme, cliente e venda).
CREATE INDEX idx_sessao_data_filme ON sessao (data_sessao, id_filme);
CREATE INDEX idx_ingresso_cliente_sessao ON ingresso (id_cliente, id_sessao);
CREATE INDEX idx_venda_data_funcionario ON venda (data_venda, id_funcionario);

-- A edição de uma sessão precisa obedecer à mesma janela de duração + limpeza do INSERT.
DELIMITER $$
CREATE TRIGGER trg_sessao_valida_horario_update
BEFORE UPDATE ON sessao
FOR EACH ROW
BEGIN
    DECLARE v_duracao INT;
    DECLARE v_conflitos INT;
    SELECT duracao_minutos INTO v_duracao FROM filme WHERE id_filme=NEW.id_filme;
    SELECT COUNT(*) INTO v_conflitos
    FROM sessao s JOIN filme f ON f.id_filme=s.id_filme
    WHERE s.id_sala=NEW.id_sala AND s.data_sessao=NEW.data_sessao
      AND s.id_sessao<>NEW.id_sessao
      AND TIMESTAMP(s.data_sessao,s.horario_inicio) < TIMESTAMP(NEW.data_sessao,ADDTIME(NEW.horario_inicio,SEC_TO_TIME((v_duracao+30)*60)))
      AND TIMESTAMP(NEW.data_sessao,NEW.horario_inicio) < TIMESTAMP(s.data_sessao,ADDTIME(s.horario_inicio,SEC_TO_TIME((f.duracao_minutos+30)*60)));
    IF v_conflitos>0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RN06: conflito de horario na sala (sobreposicao + intervalo de limpeza de 30min).';
    END IF;
END$$
DELIMITER ;

-- Visão de leitura gerencial: consolida sessões, vendas de ingressos e lugares.
CREATE OR REPLACE VIEW vw_relatorio_sessao AS
SELECT s.id_sessao, s.data_sessao, s.horario_inicio,
       f.titulo_original, sa.numero AS sala,
       COUNT(i.id_ingresso) AS ingressos_emitidos,
       COALESCE(SUM(CASE WHEN ih.status_atual <> 'Cancelado' THEN i.preco_pago ELSE 0 END), 0) AS receita_ingressos,
       sa.capacidade,
       ROUND(100.0 * COUNT(CASE WHEN ih.status_atual <> 'Cancelado' THEN i.id_ingresso END) / NULLIF(sa.capacidade, 0), 1) AS ocupacao_percentual
FROM sessao s
JOIN filme f ON f.id_filme = s.id_filme
JOIN sala sa ON sa.id_sala = s.id_sala
LEFT JOIN ingresso i ON i.id_sessao = s.id_sessao
LEFT JOIN (
    SELECT h.id_ingresso, h.status AS status_atual
    FROM ingresso_status_historico h
    JOIN (SELECT id_ingresso, MAX(CONCAT(DATE_FORMAT(data_hora,'%Y%m%d%H%i%s'), LPAD(id_status_hist,10,'0'))) AS ultima
          FROM ingresso_status_historico GROUP BY id_ingresso) u
      ON u.id_ingresso=h.id_ingresso
     AND CONCAT(DATE_FORMAT(h.data_hora,'%Y%m%d%H%i%s'), LPAD(h.id_status_hist,10,'0'))=u.ultima
) ih ON ih.id_ingresso=i.id_ingresso
GROUP BY s.id_sessao, s.data_sessao, s.horario_inicio, f.titulo_original, sa.numero, sa.capacidade;

-- Auditoria de alterações relevantes: preço de produto e preço histórico de sessão.
CREATE TABLE IF NOT EXISTS auditoria_alteracao (
    id_auditoria BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    tabela_afetada VARCHAR(64) NOT NULL,
    chave_registro VARCHAR(100) NOT NULL,
    autor VARCHAR(288) NOT NULL,
    data_hora DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    valores_anteriores JSON NOT NULL,
    valores_posteriores JSON NOT NULL,
    PRIMARY KEY (id_auditoria),
    KEY idx_auditoria_tabela_data (tabela_afetada, data_hora)
) ENGINE=InnoDB;

DELIMITER $$
CREATE TRIGGER trg_auditoria_produto_update
AFTER UPDATE ON produto
FOR EACH ROW
BEGIN
    IF NOT (OLD.preco_unitario_atual <=> NEW.preco_unitario_atual)
       OR NOT (OLD.estoque_atual <=> NEW.estoque_atual)
       OR NOT (OLD.estoque_minimo <=> NEW.estoque_minimo) THEN
        INSERT INTO auditoria_alteracao
          (tabela_afetada, chave_registro, autor, valores_anteriores, valores_posteriores)
        VALUES ('produto', CAST(OLD.id_produto AS CHAR),
          COALESCE(@app_usuario, CURRENT_USER()),
          JSON_OBJECT('preco_unitario_atual',OLD.preco_unitario_atual,'estoque_atual',OLD.estoque_atual,'estoque_minimo',OLD.estoque_minimo),
          JSON_OBJECT('preco_unitario_atual',NEW.preco_unitario_atual,'estoque_atual',NEW.estoque_atual,'estoque_minimo',NEW.estoque_minimo));
    END IF;
END$$

CREATE TRIGGER trg_auditoria_preco_sessao_update
AFTER UPDATE ON sessao_preco_historico
FOR EACH ROW
BEGIN
    IF NOT (OLD.preco_base <=> NEW.preco_base)
       OR NOT (OLD.vigencia_inicio <=> NEW.vigencia_inicio) THEN
        INSERT INTO auditoria_alteracao
          (tabela_afetada, chave_registro, autor, valores_anteriores, valores_posteriores)
        VALUES ('sessao_preco_historico', CAST(OLD.id_preco AS CHAR),
          COALESCE(@app_usuario, CURRENT_USER()),
          JSON_OBJECT('id_sessao',OLD.id_sessao,'preco_base',OLD.preco_base,'vigencia_inicio',OLD.vigencia_inicio),
          JSON_OBJECT('id_sessao',NEW.id_sessao,'preco_base',NEW.preco_base,'vigencia_inicio',NEW.vigencia_inicio));
    END IF;
END$$
DELIMITER ;

-- Papéis com privilégios distintos. Contas individuais são criadas localmente;
-- nunca versionar senha em SQL ou no código.
CREATE ROLE IF NOT EXISTS 'cinema_operacional';
CREATE ROLE IF NOT EXISTS 'cinema_gerencia';
CREATE ROLE IF NOT EXISTS 'cinema_auditoria';

-- O papel operacional vende e consulta; não cadastra nem exclui cadastros.
GRANT SELECT ON cinema.cliente TO 'cinema_operacional';
GRANT SELECT ON cinema.filme TO 'cinema_operacional';
GRANT SELECT ON cinema.produto TO 'cinema_operacional';
GRANT UPDATE (estoque_atual) ON cinema.produto TO 'cinema_operacional';
GRANT SELECT (id_funcionario, nome, cpf, telefone, cargo, login, perfil_acesso, data_admissao, ativo)
  ON cinema.funcionario TO 'cinema_operacional';
GRANT SELECT (senha_hash) ON cinema.funcionario TO 'cinema_operacional';
GRANT SELECT ON cinema.sessao TO 'cinema_operacional';
GRANT SELECT ON cinema.assento TO 'cinema_operacional';
GRANT SELECT ON cinema.ingresso TO 'cinema_operacional';
GRANT INSERT ON cinema.ingresso TO 'cinema_operacional';
GRANT INSERT ON cinema.ingresso_status_historico TO 'cinema_operacional';
GRANT SELECT ON cinema.documento_meia_entrada TO 'cinema_operacional';
GRANT SELECT ON cinema.sessao_preco_historico TO 'cinema_operacional';
GRANT INSERT ON cinema.venda_ingresso TO 'cinema_operacional';
GRANT SELECT ON cinema.vw_relatorio_sessao TO 'cinema_operacional';
GRANT SELECT, INSERT, UPDATE ON cinema.venda TO 'cinema_operacional';
GRANT SELECT, INSERT, UPDATE ON cinema.venda_produto TO 'cinema_operacional';
GRANT SELECT, INSERT ON cinema.pagamento TO 'cinema_operacional';
GRANT SELECT, INSERT ON cinema.fidelidade_pontos TO 'cinema_operacional';

-- Exemplo de GRANT/REVOKE solicitado na etapa: após o REVOKE não há DELETE operacional.
GRANT DELETE ON cinema.cliente TO 'cinema_operacional';
REVOKE DELETE ON cinema.cliente FROM 'cinema_operacional';
GRANT SELECT, INSERT, UPDATE ON cinema.* TO 'cinema_gerencia';
GRANT DELETE ON cinema.cliente TO 'cinema_gerencia';
GRANT DELETE ON cinema.filme TO 'cinema_gerencia';
GRANT DELETE ON cinema.produto TO 'cinema_gerencia';
GRANT DELETE ON cinema.funcionario TO 'cinema_gerencia';
GRANT DELETE ON cinema.sala TO 'cinema_gerencia';
GRANT DELETE ON cinema.sessao TO 'cinema_gerencia';
GRANT SELECT ON cinema.vw_relatorio_sessao TO 'cinema_auditoria';
GRANT SELECT ON cinema.auditoria_alteracao TO 'cinema_auditoria';
GRANT SELECT ON cinema.sessao TO 'cinema_auditoria';
GRANT SELECT ON cinema.filme TO 'cinema_auditoria';
GRANT SELECT ON cinema.sala TO 'cinema_auditoria';


-- Exemplo administrativo (executar como DBA, substituindo os nomes e senhas localmente):
-- CREATE USER 'operador1'@'localhost' IDENTIFIED BY '<senha forte local>';
-- GRANT 'cinema_operacional' TO 'operador1'@'localhost';
-- SET DEFAULT ROLE 'cinema_operacional' TO 'operador1'@'localhost';
-- O mesmo padrão se aplica aos papéis cinema_gerencia e cinema_auditoria.



