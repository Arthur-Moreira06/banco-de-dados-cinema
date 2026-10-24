-- Script: 02_carga.sql
-- Popula o banco "cinema" com dados de teste, respeitando a ordem de
-- dependencia entre tabelas. Nomes, CPFs e e-mails sao ficticios.
-- O bloco inicial preserva casos de setembro/2026; o lote adicional cria sessoes futuras a partir de novembro/2026.
USE cinema;

INSERT INTO filme (titulo_original, sinopse, duracao_minutos, genero_principal, classificacao_indicativa, id_filme_relacionado, tipo_relacao) VALUES
('Alem da Fronteira', 'Uma tripulacao espacial descobre um sinal que pode reescrever a historia da humanidade.', 128, 'Ficcao Cientifica', '14', NULL, NULL);

INSERT INTO filme (titulo_original, sinopse, duracao_minutos, genero_principal, classificacao_indicativa, id_filme_relacionado, tipo_relacao) VALUES
('Alem da Fronteira 2: O Retorno', 'A tripulacao volta a Terra e enfrenta as consequencias do primeiro contato.', 135, 'Ficcao Cientifica', '14', 1, 'Sequencia');

INSERT INTO filme (titulo_original, sinopse, duracao_minutos, genero_principal, classificacao_indicativa, id_filme_relacionado, tipo_relacao) VALUES
('Risadas em Familia', 'Uma familia desastrada tenta organizar a festa de aniversario dos avos.', 95, 'Comedia', 'L', NULL, NULL);

-- sinopse ainda nao cadastrada (atributo opcional em branco)
INSERT INTO filme (titulo_original, sinopse, duracao_minutos, genero_principal, classificacao_indicativa, id_filme_relacionado, tipo_relacao) VALUES
('Noite Sem Fim', NULL, 102, 'Terror', '18', NULL, NULL);

INSERT INTO filme (titulo_original, sinopse, duracao_minutos, genero_principal, classificacao_indicativa, id_filme_relacionado, tipo_relacao) VALUES
('Pequenos Herois', 'Um grupo de criancas descobre poderes magicos escondidos no quintal de casa.', 88, 'Animacao', 'L', NULL, NULL);

INSERT INTO sala (numero, capacidade, tipo_projecao) VALUES
('1', 10, '2D'),
('2', 10, '3D'),
('3', 8, 'IMAX');

INSERT INTO assento (id_sala, fileira, numero, tipo) VALUES
(1,'A',1,'Padrao'),(1,'A',2,'Padrao'),(1,'A',3,'Padrao'),(1,'A',4,'PCD'),(1,'A',5,'Padrao'),
(1,'B',1,'Padrao'),(1,'B',2,'Padrao'),(1,'B',3,'VIP'),(1,'B',4,'VIP'),(1,'B',5,'Padrao');

INSERT INTO assento (id_sala, fileira, numero, tipo) VALUES
(2,'A',1,'Padrao'),(2,'A',2,'Padrao'),(2,'A',3,'Padrao'),(2,'A',4,'Padrao'),(2,'A',5,'PCD'),
(2,'B',1,'Namorados'),(2,'B',2,'Namorados'),(2,'B',3,'Padrao'),(2,'B',4,'Padrao'),(2,'B',5,'Padrao');

INSERT INTO assento (id_sala, fileira, numero, tipo) VALUES
(3,'A',1,'Padrao'),(3,'A',2,'Padrao'),(3,'A',3,'PCD'),(3,'A',4,'Padrao'),
(3,'B',1,'VIP'),(3,'B',2,'VIP'),(3,'B',3,'Padrao'),(3,'B',4,'Padrao');

INSERT INTO funcionario (nome, cpf, telefone, cargo, login, senha_hash, perfil_acesso, data_admissao, ativo) VALUES
('Mariana Duarte Costa', '11111111111', '(61) 99811-2233', 'Atendente', 'mariana.costa', '$pbkdf2-sha256$210000$b3fkkCU-yE9Lp6VK92iI2g$yE5NpaHc_T7A0Fc7TIBPmqp3J5FmmOz5PB8Ss7l3wvU', 'Operacional', '2024-02-01', 1),
('Bruno Ferreira Lima',  '22222222222', '(61) 99822-3344', 'Atendente', 'bruno.lima',   '$pbkdf2-sha256$210000$DqJE5dJt83bsTGO__2uGWw$QpqcA6mUqPrLBEU-74YAS_4xQTQqYFRuzX28IsFAhdk', 'Operacional', '2024-05-15', 1),
('Carla Nogueira Alves', '33333333333', '(61) 99833-4455', 'Gerente',   'carla.alves',  '$pbkdf2-sha256$210000$hKgC8eWfhl2ayG28A7aKZQ$3PRcSrnqPsuLVVn4JvcCE2YV_vHiy_rDjowaHL8WKUs', 'Administrativo', '2021-03-10', 1),
('Diego Martins Souza',  '44444444444', '(61) 99844-5566', 'Projecionista', 'diego.souza', '$pbkdf2-sha256$210000$QDFYP_MiWJMzipDgR3pYsA$bDmuUqCzT9a__4dTdCM3bIIYibPwtau343qUiCbPFpU', 'Operacional', '2023-07-20', 1),
-- funcionario recem-contratado, ainda sem sala/certificado atribuidos
('Eduardo Pires Rocha',  '55555555555', NULL,               'Projecionista', 'eduardo.rocha', '$pbkdf2-sha256$210000$PIwDW3-j8vtl2x4rzzxjpQ$BXfhuYt4itEAwqZXyLyYbnAUWg-fz-xFdv_mjPKjlXk', 'Operacional', '2026-09-01', 1);

INSERT INTO atendente (id_funcionario, numero_guiche, turno, vendas_dia) VALUES
(1, 1, 'Vespertino', 0),
(2, 2, 'Noturno', 0);

INSERT INTO gerente (id_funcionario, sala_escritorio, nivel_acesso, gratificacao_cargo) VALUES
(3, 'ESC-01', 5, 850.00);

INSERT INTO projecionista (id_funcionario, id_sala_responsavel, id_gerente, certificado_tec) VALUES
(4, 1, 3, 'Certificado Tecnico em Projecao Digital - 2023'),
(5, NULL, 3, NULL);

INSERT INTO cliente (nome, cpf, telefone, email, data_nascimento) VALUES
('Ana Beatriz Fernandes', '66611122233', '(61) 98111-0001', 'ana.fernandes@exemplo.com', '1990-05-14'),
-- telefone em branco (atributo opcional)
('Carlos Eduardo Matos',  '66622233344', NULL,               'carlos.matos@exemplo.com', '2010-08-01'),
('Juliana Ramos Vieira',  '66633344455', '(61) 98111-0003', 'juliana.vieira@exemplo.com', '1985-12-20'),
('Pedro Henrique Silva',  '66644455566', '(61) 98111-0004', 'pedro.silva@exemplo.com', '2015-03-10'),
('Fernanda Costa Lima',   '66655566677', '(61) 98111-0005', 'fernanda.lima@exemplo.com', '1960-07-07');

INSERT INTO documento_meia_entrada (id_cliente, tipo_documento, numero_documento, validade) VALUES
(3, 'Estudante', 'CE-2026-004521', '2026-12-20'),
(5, 'Idoso', 'RG-IDOSO-778899', NULL),
(1, 'Deficiencia', 'PCD-2026-000001', NULL);

-- sessao ocorrida em outubro, com status "Utilizado" apos a exibicao
INSERT INTO sessao (id_filme, id_sala, data_sessao, horario_inicio, idioma, tipo) VALUES
(1, 1, '2026-10-10', '14:00:00', 'Dublado', '2D');
INSERT INTO sessao (id_filme, id_sala, data_sessao, horario_inicio, idioma, tipo) VALUES
(1, 1, '2026-11-25', '14:00:00', 'Dublado', '2D');
-- sessao futura ainda sem ingresso pago (situacao em aberto)
INSERT INTO sessao (id_filme, id_sala, data_sessao, horario_inicio, idioma, tipo) VALUES
(3, 1, '2026-11-26', '10:00:00', 'Legendado', '2D');
INSERT INTO sessao (id_filme, id_sala, data_sessao, horario_inicio, idioma, tipo) VALUES
(2, 2, '2026-11-25', '18:00:00', 'Dublado', '3D');
INSERT INTO sessao (id_filme, id_sala, data_sessao, horario_inicio, idioma, tipo) VALUES
(4, 3, '2026-11-25', '21:00:00', 'Legendado', 'IMAX');
INSERT INTO sessao (id_filme, id_sala, data_sessao, horario_inicio, idioma, tipo) VALUES
(5, 2, '2026-11-26', '15:00:00', 'Dublado', '3D');
INSERT INTO sessao (id_filme, id_sala, data_sessao, horario_inicio, idioma, tipo) VALUES
(1, 3, '2026-11-27', '20:00:00', 'Original', 'IMAX');

INSERT INTO sessao_preco_historico (id_sessao, preco_base, vigencia_inicio) VALUES
(1, 26.00, '2026-08-15 00:00:00'),
(1, 28.00, '2026-09-01 00:00:00'),
(2, 28.00, '2026-09-01 00:00:00'),
(2, 30.00, '2026-09-15 00:00:00'),
(3, 24.00, '2026-09-01 00:00:00'),
(4, 40.00, '2026-09-01 00:00:00'),
(5, 45.00, '2026-09-01 00:00:00'),
(5, 48.00, '2026-09-10 00:00:00'),
(6, 22.00, '2026-09-01 00:00:00'),
(7, 32.00, '2026-09-01 00:00:00');

-- T1: sessao ja ocorrida, cliente adulto, ingresso inteiro, ciclo completo ate Utilizado
INSERT INTO ingresso (id_sessao, id_assento, id_cliente, id_documento, tipo, preco_pago, data_compra) VALUES
(1, 1, 1, NULL, 'Inteira', 28.00, '2026-10-09 18:00:00');
INSERT INTO ingresso_status_historico (id_ingresso, status, data_hora, id_funcionario) VALUES
(1, 'Reservado', '2026-10-09 18:00:00', 1),
(1, 'Pago',      '2026-10-09 18:05:00', 1),
(1, 'Utilizado', '2026-10-10 14:10:00', NULL);

-- T2: sessao ja ocorrida, meia-entrada (idoso), ciclo completo ate Utilizado
INSERT INTO ingresso (id_sessao, id_assento, id_cliente, id_documento, tipo, preco_pago, data_compra) VALUES
(1, 2, 5, 2, 'Meia-entrada', 14.00, '2026-10-09 18:00:00');
INSERT INTO ingresso_status_historico (id_ingresso, status, data_hora, id_funcionario) VALUES
(2, 'Reservado', '2026-10-09 18:00:00', 2),
(2, 'Pago',      '2026-10-09 18:05:00', 2),
(2, 'Utilizado', '2026-10-10 14:10:00', NULL);

-- T3: sessao futura, cliente adolescente (16 anos, classificacao 14 ok), APENAS reservado (situacao em aberto)
INSERT INTO ingresso (id_sessao, id_assento, id_cliente, id_documento, tipo, preco_pago, data_compra) VALUES
(2, 6, 2, NULL, 'Inteira', 30.00, '2026-10-17 10:00:00');
INSERT INTO ingresso_status_historico (id_ingresso, status, data_hora, id_funcionario) VALUES
(3, 'Reservado', '2026-10-17 10:00:00', 1);

-- T4: sessao futura, meia-entrada (estudante), paga
INSERT INTO ingresso (id_sessao, id_assento, id_cliente, id_documento, tipo, preco_pago, data_compra) VALUES
(2, 7, 3, 1, 'Meia-entrada', 15.00, '2026-10-16 10:00:00');
INSERT INTO ingresso_status_historico (id_ingresso, status, data_hora, id_funcionario) VALUES
(4, 'Reservado', '2026-10-16 10:00:00', 2),
(4, 'Pago',      '2026-10-16 10:10:00', 2);

-- T5: sequencia (Filme 2), inteira, paga
INSERT INTO ingresso (id_sessao, id_assento, id_cliente, id_documento, tipo, preco_pago, data_compra) VALUES
(4, 11, 1, NULL, 'Inteira', 40.00, '2026-10-16 08:55:00');
INSERT INTO ingresso_status_historico (id_ingresso, status, data_hora, id_funcionario) VALUES
(5, 'Reservado', '2026-10-16 08:55:00', 3),
(5, 'Pago',      '2026-10-16 09:00:00', 3);

-- T6: sequencia (Filme 2), meia-entrada (idoso), paga e depois cancelada dentro do prazo do RN18
INSERT INTO ingresso (id_sessao, id_assento, id_cliente, id_documento, tipo, preco_pago, data_compra) VALUES
(4, 12, 5, 2, 'Meia-entrada', 20.00, '2026-10-16 09:10:00');
INSERT INTO ingresso_status_historico (id_ingresso, status, data_hora, id_funcionario) VALUES
(6, 'Reservado', '2026-10-16 09:10:00', 2),
(6, 'Pago',      '2026-10-16 09:15:00', 2),
(6, 'Cancelado', '2026-10-18 09:00:00', 2);

-- T7: sessao 18+, cliente adulto, inteira, paga
INSERT INTO ingresso (id_sessao, id_assento, id_cliente, id_documento, tipo, preco_pago, data_compra) VALUES
(5, 21, 1, NULL, 'Inteira', 48.00, '2026-10-17 07:55:00');
INSERT INTO ingresso_status_historico (id_ingresso, status, data_hora, id_funcionario) VALUES
(7, 'Reservado', '2026-10-17 07:55:00', 2),
(7, 'Pago',      '2026-10-17 08:00:00', 2);

-- T8: sessao livre, crianca de 11 anos, APENAS reservado (situacao em aberto)
INSERT INTO ingresso (id_sessao, id_assento, id_cliente, id_documento, tipo, preco_pago, data_compra) VALUES
(6, 16, 4, NULL, 'Inteira', 22.00, '2026-10-17 09:00:00');
INSERT INTO ingresso_status_historico (id_ingresso, status, data_hora, id_funcionario) VALUES
(8, 'Reservado', '2026-10-17 09:00:00', 1);

-- T9: sessao IMAX, meia-entrada (estudante), paga
INSERT INTO ingresso (id_sessao, id_assento, id_cliente, id_documento, tipo, preco_pago, data_compra) VALUES
(7, 25, 3, 1, 'Meia-entrada', 16.00, '2026-10-17 09:25:00');
INSERT INTO ingresso_status_historico (id_ingresso, status, data_hora, id_funcionario) VALUES
(9, 'Reservado', '2026-10-17 09:25:00', 1),
(9, 'Pago',      '2026-10-17 09:30:00', 1);

INSERT INTO produto (nome, categoria, preco_unitario_atual, estoque_atual, estoque_minimo) VALUES
('Pipoca Grande', 'Pipoca', 18.00, 40, 10),
('Refrigerante 500ml', 'Bebida', 8.00, 60, 15),
('Combo Casal (Pipoca + 2 Refrigerantes)', 'Combo', 35.00, 20, 5),
-- estoque atual abaixo do minimo (alerta de reposicao em aberto)
('Chocolate M&Ms', 'Doce', 9.00, 3, 5),
('Agua Mineral', 'Bebida', 6.00, 50, 10);

-- Venda antiga (2025), avulsa, usada para demonstrar pontos de fidelidade
-- ja expirados convivendo com pontos ainda validos do mesmo cliente
INSERT INTO venda (id_cliente, id_funcionario, data_venda, valor_total) VALUES
(1, 1, '2025-06-01 12:00:00', 35.00);
INSERT INTO venda_produto (id_venda, id_produto, quantidade, preco_unitario_venda) VALUES
(1, 3, 1, 35.00);
INSERT INTO pagamento (id_venda, data_pagamento, valor, forma_pagamento) VALUES
(1, '2025-06-01 12:05:00', 35.00, 'Dinheiro');

-- Venda do ingresso T1 + pipoca
INSERT INTO venda (id_cliente, id_funcionario, data_venda, valor_total) VALUES
(1, 1, '2026-10-09 18:05:00', 46.00);
INSERT INTO venda_ingresso (id_venda, id_ingresso) VALUES (2, 1);
INSERT INTO venda_produto (id_venda, id_produto, quantidade, preco_unitario_venda) VALUES
(2, 1, 1, 18.00);
INSERT INTO pagamento (id_venda, data_pagamento, valor, forma_pagamento) VALUES
(2, '2026-10-09 18:06:00', 46.00, 'Cartao_Credito');

-- Venda do ingresso T2 + refrigerante
INSERT INTO venda (id_cliente, id_funcionario, data_venda, valor_total) VALUES
(5, 2, '2026-10-09 18:05:00', 22.00);
INSERT INTO venda_ingresso (id_venda, id_ingresso) VALUES (3, 2);
INSERT INTO venda_produto (id_venda, id_produto, quantidade, preco_unitario_venda) VALUES
(3, 2, 1, 8.00);
INSERT INTO pagamento (id_venda, data_pagamento, valor, forma_pagamento) VALUES
(3, '2026-10-09 18:07:00', 22.00, 'Pix');

-- Venda avulsa de bomboniere, sem cliente identificado
INSERT INTO venda (id_cliente, id_funcionario, data_venda, valor_total) VALUES
(NULL, 1, '2026-10-17 12:00:00', 21.00);
INSERT INTO venda_produto (id_venda, id_produto, quantidade, preco_unitario_venda) VALUES
(4, 5, 2, 6.00),
(4, 4, 1, 9.00);
INSERT INTO pagamento (id_venda, data_pagamento, valor, forma_pagamento) VALUES
(4, '2026-10-17 12:01:00', 21.00, 'Dinheiro');

-- Venda do ingresso T4
INSERT INTO venda (id_cliente, id_funcionario, data_venda, valor_total) VALUES
(3, 2, '2026-10-16 10:10:00', 15.00);
INSERT INTO venda_ingresso (id_venda, id_ingresso) VALUES (5, 4);
INSERT INTO pagamento (id_venda, data_pagamento, valor, forma_pagamento) VALUES
(5, '2026-10-16 10:11:00', 15.00, 'Pix');

-- Venda do ingresso T5
INSERT INTO venda (id_cliente, id_funcionario, data_venda, valor_total) VALUES
(1, 3, '2026-10-16 09:00:00', 40.00);
INSERT INTO venda_ingresso (id_venda, id_ingresso) VALUES (6, 5);
INSERT INTO pagamento (id_venda, data_pagamento, valor, forma_pagamento) VALUES
(6, '2026-10-16 09:01:00', 40.00, 'Cartao_Debito');

-- Venda do ingresso T6 (posteriormente cancelado — venda/pagamento originais preservados)
INSERT INTO venda (id_cliente, id_funcionario, data_venda, valor_total) VALUES
(5, 2, '2026-10-16 09:15:00', 20.00);
INSERT INTO venda_ingresso (id_venda, id_ingresso) VALUES (7, 6);
INSERT INTO pagamento (id_venda, data_pagamento, valor, forma_pagamento) VALUES
(7, '2026-10-16 09:16:00', 20.00, 'Pix');

-- Venda do ingresso T7
INSERT INTO venda (id_cliente, id_funcionario, data_venda, valor_total) VALUES
(1, 2, '2026-10-17 08:00:00', 48.00);
INSERT INTO venda_ingresso (id_venda, id_ingresso) VALUES (8, 7);
INSERT INTO pagamento (id_venda, data_pagamento, valor, forma_pagamento) VALUES
(8, '2026-10-17 08:01:00', 48.00, 'Cartao_Credito');

-- Venda do ingresso T9
INSERT INTO venda (id_cliente, id_funcionario, data_venda, valor_total) VALUES
(3, 1, '2026-10-17 09:30:00', 16.00);
INSERT INTO venda_ingresso (id_venda, id_ingresso) VALUES (9, 9);
INSERT INTO pagamento (id_venda, data_pagamento, valor, forma_pagamento) VALUES
(9, '2026-10-17 09:31:00', 16.00, 'Dinheiro');

-- Vendas antecipadas para que as sessoes iniciais tambem aparecam no relatorio de outubro.
INSERT INTO ingresso (id_sessao, id_assento, id_cliente, id_documento, tipo, preco_pago, data_compra) VALUES
(3, 3, 2, NULL, 'Inteira', 24.00, '2026-10-17 09:05:00'),
(6, 17, 4, NULL, 'Inteira', 22.00, '2026-10-17 09:10:00');
INSERT INTO ingresso_status_historico (id_ingresso, status, data_hora, id_funcionario) VALUES
(10, 'Reservado', '2026-10-17 09:05:00', 1),
(10, 'Pago',      '2026-10-17 09:10:00', 1),
(11, 'Reservado', '2026-10-17 09:10:00', 2),
(11, 'Pago',      '2026-10-17 09:15:00', 2);

-- T3 e T8 continuam apenas "Reservado"; as vendas abaixo usam outros assentos das mesmas sessoes.
INSERT INTO venda (id_cliente, id_funcionario, data_venda, valor_total) VALUES
(2, 1, '2026-10-17 09:10:00', 24.00),
(4, 2, '2026-10-17 09:15:00', 22.00);
INSERT INTO venda_ingresso (id_venda, id_ingresso) VALUES
(10, 10),
(11, 11);
INSERT INTO pagamento (id_venda, data_pagamento, valor, forma_pagamento) VALUES
(10, '2026-10-17 09:11:00', 24.00, 'Pix'),
(11, '2026-10-17 09:16:00', 22.00, 'Cartao_Debito');

-- Venda avulsa do produto de id 3 dentro do periodo padrao das consultas.
INSERT INTO venda (id_cliente, id_funcionario, data_venda, valor_total) VALUES
(1, 1, '2026-10-01 10:00:00', 35.00);
INSERT INTO venda_produto (id_venda, id_produto, quantidade, preco_unitario_venda) VALUES
(12, 3, 1, 35.00);
INSERT INTO pagamento (id_venda, data_pagamento, valor, forma_pagamento) VALUES
(12, '2026-10-01 10:01:00', 35.00, 'Dinheiro');

INSERT INTO fidelidade_pontos (id_cliente, id_venda, pontos, data_credito, data_expiracao) VALUES
-- Pontos ja expirados (creditados em 2025, expiram em 2026-06-01 — antes da data de referencia 2026-09-17)
(1, 1, 35, '2025-06-01 12:05:00', '2026-06-01 12:05:00'),
-- Pontos ainda validos do mesmo cliente (Ana), em vendas diferentes
(1, 2, 46, '2026-10-09 18:06:00', '2027-10-09 18:06:00'),
(1, 6, 40, '2026-10-16 09:01:00', '2027-10-16 09:01:00'),
(1, 8, 48, '2026-10-17 08:01:00', '2027-10-17 08:01:00'),
(5, 3, 22, '2026-10-09 18:07:00', '2027-10-09 18:07:00'),
(5, 7, 20, '2026-10-16 09:16:00', '2027-10-16 09:16:00'),
(3, 5, 15, '2026-10-16 10:11:00', '2027-10-16 10:11:00'),
(3, 9, 16, '2026-10-17 09:31:00', '2027-10-17 09:31:00'),
(2, 10, 24, '2026-10-17 09:11:00', '2027-10-17 09:11:00'),
(4, 11, 22, '2026-10-17 09:16:00', '2027-10-17 09:16:00'),
(1, 12, 35, '2026-10-01 10:01:00', '2027-10-01 10:01:00');


-- Lote sintetico para cumprir o volume minimo do projeto.
-- Apos a carga completa: filme >=125, sala >=123, funcionario >=125,
-- cliente >=125, sessao >=127, produto >=126, ingresso >=109 e venda >=109.
-- A tabela de maior movimento, ingresso_status_historico, fica com >=219.
-- Sao dados ficticios e deterministas; o procedimento e removido ao final.
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_carga_volume_demo$$
CREATE PROCEDURE sp_carga_volume_demo()
BEGIN
    DECLARE v_i INT DEFAULT 1;
    DECLARE v_j INT DEFAULT 1;
    DECLARE v_k INT DEFAULT 1;
    DECLARE v_compra INT DEFAULT 1;
    DECLARE v_filme INT;
    DECLARE v_sala INT;
    DECLARE v_assento_inicio INT;
    DECLARE v_sessao_inicio INT DEFAULT 0;
    DECLARE v_funcionario INT;
    DECLARE v_cliente INT;
    DECLARE v_produto INT;
    DECLARE v_funcionario_inicio INT;
    DECLARE v_cliente_inicio INT;
    DECLARE v_produto_inicio INT;
    DECLARE v_numero_sala INT;
    DECLARE v_sessao INT;
    DECLARE v_assento INT;
    DECLARE v_ingresso INT;
    DECLARE v_venda INT;
    DECLARE v_categoria VARCHAR(20);
    DECLARE v_cargo VARCHAR(20);
    DECLARE v_tipo_sala VARCHAR(10);
    DECLARE v_preco DECIMAL(6,2);
    DECLARE v_ingressos_sessao INT;
    DECLARE v_preco_produto DECIMAL(6,2);
    DECLARE v_total DECIMAL(8,2);
    DECLARE v_data_compra DATETIME;
    DECLARE v_nome_filme VARCHAR(150);
    DECLARE v_nome_funcionario VARCHAR(150);
    DECLARE v_nome_cliente VARCHAR(150);
    DECLARE v_nome_produto VARCHAR(80);
    DECLARE v_relacionado INT;
    DECLARE v_tipo_relacao VARCHAR(20);
    DECLARE v_hash VARCHAR(255) DEFAULT '$pbkdf2-sha256$210000$b3fkkCU-yE9Lp6VK92iI2g$yE5NpaHc_T7A0Fc7TIBPmqp3J5FmmOz5PB8Ss7l3wvU';

    SELECT COALESCE(MAX(id_funcionario),0)+1 INTO v_funcionario_inicio FROM funcionario;
    SELECT COALESCE(MAX(id_cliente),0)+1 INTO v_cliente_inicio FROM cliente;
    SELECT COALESCE(MAX(id_produto),0)+1 INTO v_produto_inicio FROM produto;
    SELECT COALESCE(MAX(id_assento),0)+1 INTO v_assento_inicio FROM assento;
    -- Os tres registros iniciais ocupam as salas 1, 2 e 3.
    SET v_numero_sala = 4;

    WHILE v_i <= 120 DO
        SET v_nome_filme = ELT(v_i,
            'Vozes de Casa',
            'O Segredo Vento Norte Reino',
            'Entre Labirinto e Tempo Perdido',
            'Luz: Pequim',
            'A Segredo de Pássaros',
            'O Retrato Esperança',
            'Baía de Dois Irmãos',
            'Promessa de Memórias',
            'O Segredo Relógio Quase Nada',
            'Entre Labirinto e Planeta Vermelho',
            'Labirinto: Janelas',
            'A Retrato Antigo de Quase Nada',
            'O Encontro Cidade',
            'Sonho de Esperança',
            'Vento Norte de Quase Nada',
            'O Segredo Silêncio Família',
            'Entre Outra Vida e Mistério',
            'Ponte: Janelas',
            'A Última Estação de Cidade',
            'O Cidade Invisível Janelas',
            'Sombra de Lisboa',
            'Passagem de Janelas',
            'O Segredo Farol Coração',
            'Entre Aurora e Madrugada',
            'Aurora: Outono',
            'A Jardim Secreto de Outono',
            'O Promessa Cidade',
            'Vento Norte de Infância',
            'Caminho de Volta de Tempo Perdido',
            'O Segredo Travessia Cidade',
            'Entre Relógio e Pequim',
            'Travessia: Esperança',
            'A Fronteira de Janelas',
            'O Sonho Rio Claro',
            'Noite de Verão de Lisboa',
            'Casa Azul de Lado de Lá',
            'O Segredo Farol Pássaros',
            'Entre Ponte e Planeta Vermelho',
            'Vale: Tempo Perdido',
            'A Velha Fotografia de Lado de Lá',
            'O Dia Seguinte Lisboa',
            'Outra Vida de Lado de Lá',
            'Silêncio de Tempo Perdido',
            'O Segredo Peixe Voador Cidade',
            'Entre Baía e Tempo Perdido',
            'Quintal: Pássaros',
            'A Mapa de Janelas',
            'O Peixe Voador Outono',
            'Travessia de Dois Irmãos',
            'Ponte de Família',
            'O Segredo Mapa Pássaros',
            'Entre Travessia e Casa',
            'Memória: Cidade',
            'A Travessia de Rua das Flores',
            'O Aurora Infância',
            'Quintal de Segunda Chance',
            'Quintal de Planeta Vermelho',
            'O Segredo Fronteira Último Trem',
            'Entre Peixe Voador e Aventura',
            'Silêncio: Papel de Seda',
            'A Vozes de Lisboa',
            'O Mapa Pequeno Príncipe',
            'Aurora de Pequim',
            'Raízes de Lado de Lá',
            'O Segredo Travessia Rio Claro',
            'Entre Silêncio e Primeiro Amor',
            'Aurora: Pássaros',
            'A Sombra de Quase Nada',
            'O Retrato Antigo Rua das Flores',
            'Canção de Planeta Vermelho',
            'Cidade Invisível de Aventura',
            'O Segredo Ponte Lado de Lá',
            'Entre Casa Azul e Dois Irmãos',
            'Canção: Dois Irmãos',
            'A Jardim Secreto de Esperança',
            'O Quintal Quase Nada',
            'Refúgio de Cidade',
            'Canção de Cidade',
            'O Segredo Encontro Aventura',
            'Entre Mapa e Despedida',
            'Farol: Para Sempre',
            'A Cais de Marte',
            'O Promessa Reino',
            'Silêncio de Mistério',
            'Cais de Cidade',
            'O Segredo Vozes Atlântico',
            'Entre Mapa e Planeta Vermelho',
            'Outra Vida: Estrela',
            'A Aurora de Estrela',
            'O Luz Canavial',
            'Última Estação de Rio Claro',
            'Destino de Lisboa',
            'O Segredo Inverno Mistério',
            'Entre Destino e Esperança',
            'Aurora: Tempo Perdido',
            'A Passagem de Planeta Vermelho',
            'O Refúgio Planeta Vermelho',
            'Cais de Rio Claro',
            'Cais de Madrugada',
            'O Segredo Retrato Antigo Pássaros',
            'Entre Última Estação e Esperança',
            'Quintal: Cidade',
            'A Retrato de Pequeno Príncipe',
            'O Casa Azul Quarta-feira',
            'Cidade Invisível de Estrela',
            'Ponte de Aventura',
            'O Segredo Relógio Para Sempre',
            'Entre Carta Perdida e Despedida',
            'Vozes: Pássaros',
            'A Vozes de Dois Irmãos',
            'O Aurora Lisboa',
            'Ponte de Outono',
            'Carta Perdida de Primeiro Amor',
            'O Segredo Farol Madrugada',
            'Entre Sombra e Primeiro Amor',
            'Canção: Segunda Chance',
            'A Nuvem de Pássaros',
            'O Fronteira Estrela',
            'Mundo Novo de Tempo Perdido',
            'Maré Alta de Infância'
        );
        IF v_i = 1 THEN
            INSERT INTO filme (titulo_original,sinopse,duracao_minutos,genero_principal,classificacao_indicativa,id_filme_relacionado,tipo_relacao)
            VALUES (v_nome_filme, CONCAT('Uma historia de aventura e descobertas em ',v_nome_filme,'.'), 90 + MOD(v_i,70),
                ELT(1+MOD(v_i-1,5),'Drama','Comedia','Acao','Animacao','Documentario'),
                ELT(1+MOD(v_i-1,6),'L','10','12','14','16','18'), NULL, NULL);
        ELSE
            SELECT COALESCE(MAX(id_filme),0) INTO v_relacionado FROM filme;
            SET v_relacionado = v_relacionado - 1;
            INSERT INTO filme (titulo_original,sinopse,duracao_minutos,genero_principal,classificacao_indicativa,id_filme_relacionado,tipo_relacao)
            VALUES (v_nome_filme, CONCAT('Uma historia de aventura e descobertas em ',v_nome_filme,'.'), 90 + MOD(v_i,70),
                ELT(1+MOD(v_i-1,5),'Drama','Comedia','Acao','Animacao','Documentario'),
                ELT(1+MOD(v_i-1,6),'L','10','12','14','16','18'), v_relacionado, 'Sequencia');
        END IF;
        SET v_filme = LAST_INSERT_ID();

        SET v_tipo_sala = ELT(1+MOD(v_i-1,3),'2D','3D','IMAX');
        INSERT INTO sala (numero,capacidade,tipo_projecao)
        VALUES (CAST(v_numero_sala AS CHAR),10,v_tipo_sala);
        SET v_sala = LAST_INSERT_ID();
        SET v_numero_sala = v_numero_sala + 1;

        SET v_j = 1;
        WHILE v_j <= 10 DO
            INSERT INTO assento (id_sala,fileira,numero,tipo)
            VALUES (v_sala, IF(v_j<=5,'A','B'), IF(v_j<=5,v_j,v_j-5),
                    IF(MOD(v_j,5)=0,'PCD','Padrao'));
            SET v_j = v_j + 1;
        END WHILE;

        SET v_cargo = ELT(1+MOD(v_i-1,3),'Atendente','Gerente','Projecionista');
        SET v_nome_funcionario = ELT(v_i,
            'Daniel Moraes',
            'Arthur Miranda',
            'Amanda Garcia',
            'Valentina Garcia',
            'Marcelo Farias',
            'Adriana Freire',
            'Flavia Andrade',
            'Beatriz Xavier',
            'Marcelo Carvalho',
            'Diana Santos',
            'Adriana Dias',
            'Alexandre Santos',
            'Natalia Lopes',
            'Rodrigo Nascimento',
            'Igor Cavalcante',
            'Tais Coelho',
            'Flavia Farias',
            'Debora Santos',
            'Adriana Machado',
            'Marcelo Albuquerque',
            'Cecilia Machado',
            'Anderson Medeiros',
            'Mateus Barros',
            'Diana Andrade',
            'Ricardo Oliveira',
            'Diana Ferreira',
            'Angela Cunha',
            'Fabiana Batista',
            'Heitor Machado',
            'Isabela Ferreira',
            'Arthur Garcia',
            'Camila Lima',
            'Alexandre Garcia',
            'Danilo Garcia',
            'Angela Nascimento',
            'Gustavo Andrade',
            'Gustavo Neves',
            'Leticia Nascimento',
            'Brenda Carvalho',
            'Antonio Nascimento',
            'Paula Miranda',
            'Julia Garcia',
            'Larissa Carvalho',
            'Diana Lopes',
            'Samuel Santos',
            'Heitor Cunha',
            'Tais Dias',
            'Gabriela Farias',
            'Arthur Carvalho',
            'Camila Andrade',
            'Lorena Ferreira',
            'Marcelo Goncalves',
            'Adriana Goncalves',
            'Alexandre Lopes',
            'Arthur Teixeira',
            'Brenda Goncalves',
            'Fabiana Medeiros',
            'Diana Garcia',
            'Jorge Xavier',
            'Alexandre Miranda',
            'Vinicius Lopes',
            'Larissa Silva',
            'Emanuel Cardoso',
            'Cesar Barros',
            'Clara Santos',
            'Heitor Dias',
            'Jorge Cunha',
            'Amanda Machado',
            'Alexandre Carvalho',
            'Flavia Azevedo',
            'Leticia Albuquerque',
            'Amanda Cavalcante',
            'Larissa Cunha',
            'Clara Soares',
            'Otavio Cunha',
            'Marcelo Machado',
            'Angela Garcia',
            'Leonardo Ribeiro',
            'Larissa Garcia',
            'Igor Barros',
            'Mariana Moreira',
            'Daniel Teixeira',
            'Adriana Garcia',
            'Diana Goncalves',
            'Renata Garcia',
            'Anderson Lopes',
            'Adriana Andrade',
            'Fabiana Barros',
            'Emanuel Campos',
            'Fabiana Neves',
            'Antonio Xavier',
            'Vinicius Santos',
            'Beatriz Barros',
            'Cecilia Farias',
            'Julia Soares',
            'Clara Ferreira',
            'Clara Miranda',
            'Samuel Macedo',
            'Caio Garcia',
            'Valentina Lopes',
            'Antonio Goncalves',
            'Amanda Cunha',
            'Antonio Farias',
            'Gustavo Nascimento',
            'Amanda Dias',
            'Anderson Xavier',
            'Fabiana Cavalcante',
            'Leticia Miranda',
            'Danilo Xavier',
            'Diego Cunha',
            'Vinicius Barros',
            'Debora Cavalcante',
            'Anderson Ribeiro',
            'Gustavo Santos',
            'Camila Dantas',
            'Francisco Albuquerque',
            'Caio Machado',
            'Brenda Mendes',
            'Brenda Barros',
            'Fabiana Ramos'
        );
        INSERT INTO funcionario (nome,CPF,telefone,cargo,login,senha_hash,perfil_acesso,data_admissao,ativo)
        VALUES (v_nome_funcionario, LPAD(70000000000+v_i,11,'0'), NULL,
                v_cargo, LOWER(REPLACE(v_nome_funcionario,' ','.')), v_hash,
                IF(v_cargo='Gerente','Administrativo','Operacional'), '2025-01-01', 0);
        SET v_funcionario = LAST_INSERT_ID();
        IF v_cargo='Atendente' THEN
            INSERT INTO atendente (id_funcionario,numero_guiche,turno) VALUES (v_funcionario,1+MOD(v_i,20),'Matutino');
        ELSEIF v_cargo='Gerente' THEN
            INSERT INTO gerente (id_funcionario,sala_escritorio,nivel_acesso,gratificacao_cargo)
            VALUES (v_funcionario,CONCAT('Escritorio ',v_i),2,0.00);
        ELSE
            INSERT INTO projecionista (id_funcionario,id_gerente,id_sala_responsavel,certificado_tec)
            VALUES (v_funcionario,3,v_sala,CONCAT('CRT-2026-',LPAD(v_i,3,'0')));
        END IF;

        SET v_nome_cliente = ELT(v_i,
            'Rafaela Antunes',
            'Bianca Peixoto',
            'Guilherme Vilela',
            'Joana Brandao',
            'Davi Franco',
            'Fabio Cordeiro',
            'Bernardo Bandeira',
            'Eduarda Camargo',
            'Livia Moraes',
            'Bernardo Brandao',
            'Joana Carneiro',
            'Iara Vilela',
            'Fernanda Leal',
            'Andre Torres',
            'Bernardo Leal',
            'Alice Vasconcelos',
            'Aline Cruz',
            'Estela Tavares',
            'Yuri Rangel',
            'Raul Vasconcelos',
            'Joao Bandeira',
            'Estela Moraes',
            'Alice Bandeira',
            'Raul Matos',
            'Felipe Prado',
            'Livia Vasconcelos',
            'Aline Vasconcelos',
            'Marina Abreu',
            'Davi Vasconcelos',
            'Andre Vilela',
            'Guilherme Peixoto',
            'Bruno Prado',
            'Andre Carneiro',
            'Guilherme Pacheco',
            'Bruno Rangel',
            'Karen Camargo',
            'Vitor Franco',
            'Raul Prado',
            'Heloisa Rangel',
            'Alice Vilela',
            'Andre Peixoto',
            'Murilo Alves',
            'Aline Abreu',
            'Heloisa Bueno',
            'Manuela Figueiredo',
            'Andre Lemos',
            'Karen Tavares',
            'Guilherme Bueno',
            'Fernanda Abreu',
            'Davi Cordeiro',
            'Felipe Carneiro',
            'Bruno Peixoto',
            'Catarina Matos',
            'Nicolas Figueiredo',
            'Andre Cruz',
            'Isadora Prado',
            'Cintia Antunes',
            'Livia Brandao',
            'Luana Pinto',
            'Livia Bandeira',
            'Samuel Moraes',
            'Karen Pacheco',
            'Manuela Leite',
            'Elisa Tavares',
            'Eduarda Brandao',
            'Pietra Vilela',
            'Elisa Araujo',
            'Marina Cordeiro',
            'Felipe Lemos',
            'Luana Brandao',
            'Alice Camargo',
            'Guilherme Tavares',
            'Catarina Carneiro',
            'Valeria Camargo',
            'Bernardo Cruz',
            'Cintia Bandeira',
            'Bruno Vilela',
            'Joana Lemos',
            'Vitor Peixoto',
            'Rafaela Moraes',
            'Bianca Cruz',
            'Enzo Rangel',
            'Enzo Moraes',
            'Laura Tavares',
            'Felipe Figueiredo',
            'Marina Rangel',
            'Joana Araujo',
            'Joana Carmo',
            'Marcos Moraes',
            'Davi Bandeira',
            'Marcos Cruz',
            'Catarina Vilela',
            'Bianca Rangel',
            'Alice Carmo',
            'Guilherme Alves',
            'Estela Abreu',
            'Catarina Lemos',
            'Nina Alves',
            'Eduarda Matos',
            'Raul Carneiro',
            'Marcos Maia',
            'Alice Leal',
            'Bianca Prado',
            'Giovana Vasconcelos',
            'Alice Abreu',
            'Murilo Siqueira',
            'Nicolas Antunes',
            'Guilherme Figueiredo',
            'Bianca Camargo',
            'Bernardo Alves',
            'Eduarda Alves',
            'Nicolas Abreu',
            'Cintia Lemos',
            'Catarina Pacheco',
            'Felipe Rangel',
            'Rafaela Vilela',
            'Fernanda Lemos',
            'Eduarda Bandeira',
            'Nicolas Maia',
            'Joao Matos'
        );
        INSERT INTO cliente (nome,CPF,telefone,email,data_nascimento)
        VALUES (v_nome_cliente, LPAD(60000000000+v_i,11,'0'), NULL,
                CONCAT(LOWER(REPLACE(v_nome_cliente,' ','.')),'@exemplo.com'), DATE_ADD('1985-01-01',INTERVAL v_i DAY));

        SET v_categoria = ELT(1+MOD(v_i-1,5),'Pipoca','Bebida','Doce','Combo','Outro');
        SET v_nome_produto = CASE v_categoria
            WHEN 'Pipoca' THEN ELT(1+MOD(FLOOR((v_i-1)/5),24),
                'Pipoca amanteigada grande',
                'Pipoca caramelizada',
                'Pipoca com queijo',
                'Pipoca doce crocante',
                'Pipoca salgada média',
                'Pipoca com ervas',
                'Pipoca de chocolate branco',
                'Pipoca picante',
                'Pipoca família',
                'Pipoca caramelo e flor de sal',
                'Pipoca cheddar',
                'Pipoca com canela',
                'Mini pipoca salgada',
                'Pipoca trufada',
                'Pipoca barbecue',
                'Pipoca com leite condensado',
                'Pipoca lemon pepper',
                'Pipoca clássica pequena',
                'Pipoca meio amarga',
                'Pipoca parmesão',
                'Pipoca doce de canela',
                'Pipoca caramelo intenso',
                'Pipoca manteiga extra',
                'Pipoca mix da casa')
            WHEN 'Bebida' THEN ELT(1+MOD(FLOOR((v_i-1)/5),24),
                'Água mineral sem gás',
                'Refrigerante de cola',
                'Suco de laranja natural',
                'Chá gelado de pêssego',
                'Guaraná lata',
                'Água com gás',
                'Suco de uva integral',
                'Limonada da casa',
                'Cola zero',
                'Chá mate com limão',
                'Suco de maracujá',
                'Refrigerante de laranja',
                'Água de coco',
                'Soda italiana de maçã',
                'Refrigerante de limão',
                'Suco de abacaxi',
                'Chá verde gelado',
                'Água tônica',
                'Chocolate quente',
                'Café gelado',
                'Milk-shake de baunilha',
                'Milk-shake de chocolate',
                'Suco de morango',
                'Refrigerante de gengibre')
            WHEN 'Doce' THEN ELT(1+MOD(FLOOR((v_i-1)/5),24),
                'Chocolate ao leite',
                'Trufa de maracujá',
                'Bala de gelatina',
                'Brownie com nozes',
                'Barra de cereal',
                'Cookie de chocolate',
                'Goma de mascar',
                'Paçoca artesanal',
                'Chocolate amargo',
                'Bala de caramelo',
                'Alfajor argentino',
                'Pé de moleque',
                'Trufa de avelã',
                'Biscoito amanteigado',
                'Bala de frutas',
                'Doce de leite',
                'Bombom de coco',
                'Cookie de baunilha',
                'Chiclete de menta',
                'Barra de castanhas',
                'Mini bolo de cenoura',
                'Brigadeiro gourmet',
                'Chocolate com amendoim',
                'Suspiro artesanal')
            WHEN 'Combo' THEN ELT(1+MOD(FLOOR((v_i-1)/5),24),
                'Combo sessão clássica',
                'Combo pipoca e cola',
                'Combo casal especial',
                'Combo família',
                'Combo doce e bebida',
                'Combo matinê',
                'Combo noite de estreia',
                'Combo intervalo rápido',
                'Combo pipoca caramelizada',
                'Combo cinema em dobro',
                'Combo infantil',
                'Combo nachos e refrigerante',
                'Combo café e brownie',
                'Combo para amigos',
                'Combo econômico',
                'Combo grande aventura',
                'Combo sabor da casa',
                'Combo pipoca e suco',
                'Combo lançamento',
                'Combo clássico para dois',
                'Combo férias',
                'Combo chocolate quente',
                'Combo edição especial',
                'Combo sessão premium')
            ELSE ELT(1+MOD(FLOOR((v_i-1)/5),24),
                'Nachos com queijo',
                'Hot dog tradicional',
                'Sanduíche de frango',
                'Batata chips artesanal',
                'Biscoito salgado',
                'Mini pizza marguerita',
                'Pão de queijo',
                'Wrap de vegetais',
                'Pretzel salgado',
                'Torrada temperada',
                'Cachorro-quente especial',
                'Sanduíche caprese',
                'Empada de palmito',
                'Pastel assado',
                'Mix de castanhas',
                'Tiras de frango',
                'Anéis de cebola',
                'Focaccia italiana',
                'Croissant misto',
                'Esfiha de queijo',
                'Bruschetta',
                'Batata rústica',
                'Pão de alho',
                'Snack de grão-de-bico')
        END;
        INSERT INTO produto (nome,categoria,preco_unitario_atual,estoque_atual,estoque_minimo)
        VALUES (v_nome_produto,v_categoria,5.00 + MOD(v_i,20),100,10);

        INSERT INTO sessao (id_filme,id_sala,data_sessao,horario_inicio,idioma,tipo)
        VALUES (v_filme,v_sala,DATE_ADD('2026-11-15',INTERVAL v_i DAY),
                ELT(1+MOD(v_i-1,5),'10:00:00','12:30:00','15:00:00','17:30:00','20:00:00'),
                ELT(1+MOD(v_i-1,3),'Dublado','Legendado','Original'),v_tipo_sala);
        SET v_sessao = LAST_INSERT_ID();
        IF v_i=1 THEN SET v_sessao_inicio=v_sessao; END IF;
        INSERT INTO sessao_preco_historico (id_sessao,preco_base,vigencia_inicio)
        VALUES (v_sessao,24.00+MOD(v_i,20),'2026-10-01 00:00:00');
        SET v_i = v_i + 1;
    END WHILE;

    -- Cem compras distribuidas em vinte sessoes, com 3 a 7 ingressos por sessao.
    -- Cada compra registra ingresso, status, venda, item de produto, pagamento e pontos.
    WHILE v_k <= 20 DO
        SET v_sessao = v_sessao_inicio + v_k - 1;
        SET v_ingressos_sessao = 3 + MOD(v_k-1,5);
        SET v_j = 1;
        WHILE v_j <= v_ingressos_sessao DO
            SET v_assento = v_assento_inicio + (v_k-1)*10 + v_j - 1;
            SET v_cliente = v_cliente_inicio + MOD(v_compra-1,40);
            SET v_funcionario = v_funcionario_inicio + MOD(v_compra-1,40);
            SET v_produto = v_produto_inicio + MOD(v_compra-1,40);
            SET v_preco = 24.00 + MOD(v_compra,20);
            SELECT preco_unitario_atual INTO v_preco_produto FROM produto WHERE id_produto=v_produto;
            SET v_total = v_preco + v_preco_produto;
            SET v_data_compra = DATE_ADD('2026-10-01 10:00:00', INTERVAL v_compra MINUTE);

            INSERT INTO ingresso (id_sessao,id_assento,id_cliente,id_documento,tipo,preco_pago,data_compra)
            VALUES (v_sessao,v_assento,v_cliente,NULL,'Inteira',v_preco,v_data_compra);
            SET v_ingresso = LAST_INSERT_ID();
            INSERT INTO ingresso_status_historico (id_ingresso,status,data_hora,id_funcionario)
            VALUES (v_ingresso,'Reservado',v_data_compra,v_funcionario),
                   (v_ingresso,'Pago',DATE_ADD(v_data_compra,INTERVAL 5 MINUTE),v_funcionario);

            INSERT INTO venda (id_cliente,id_funcionario,data_venda,valor_total)
            VALUES (v_cliente,v_funcionario,DATE_ADD(v_data_compra,INTERVAL 5 MINUTE),v_total);
            SET v_venda = LAST_INSERT_ID();
            INSERT INTO venda_ingresso (id_venda,id_ingresso) VALUES (v_venda,v_ingresso);
            INSERT INTO venda_produto (id_venda,id_produto,quantidade,preco_unitario_venda)
            VALUES (v_venda,v_produto,1,v_preco_produto);
            UPDATE produto SET estoque_atual=estoque_atual-1 WHERE id_produto=v_produto;
            INSERT INTO pagamento (id_venda,data_pagamento,valor,forma_pagamento)
            VALUES (v_venda,DATE_ADD(v_data_compra,INTERVAL 6 MINUTE),v_total,
                    ELT(1+MOD(v_compra-1,4),'Dinheiro','Cartao_Credito','Cartao_Debito','Pix'));
            INSERT INTO fidelidade_pontos (id_cliente,id_venda,pontos,data_credito,data_expiracao)
            VALUES (v_cliente,v_venda,FLOOR(v_total),DATE_ADD(v_data_compra,INTERVAL 6 MINUTE),
                    DATE_ADD(v_data_compra,INTERVAL 12 MONTH));
            SET v_compra = v_compra + 1;
            SET v_j = v_j + 1;
        END WHILE;
        SET v_k = v_k + 1;
    END WHILE;
END$$
CALL sp_carga_volume_demo()$$
DROP PROCEDURE sp_carga_volume_demo$$
DELIMITER ;


