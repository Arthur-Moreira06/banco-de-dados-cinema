-- Script: 02_carga.sql
-- Popula o banco "cinema" com dados de teste, respeitando a ordem de
-- dependencia entre tabelas. Nomes, CPFs e e-mails sao ficticios.
-- Sessoes com data 10/09/2026 ja ocorreram; as demais sao futuras.
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
('Mariana Duarte Costa', '11111111111', '(61) 99811-2233', 'Atendente', 'mariana.costa', 'hash_fake_1', 'Operacional', '2024-02-01', 1),
('Bruno Ferreira Lima',  '22222222222', '(61) 99822-3344', 'Atendente', 'bruno.lima',   'hash_fake_2', 'Operacional', '2024-05-15', 1),
('Carla Nogueira Alves', '33333333333', '(61) 99833-4455', 'Gerente',   'carla.alves',  'hash_fake_3', 'Administrativo', '2021-03-10', 1),
('Diego Martins Souza',  '44444444444', '(61) 99844-5566', 'Projecionista', 'diego.souza', 'hash_fake_4', 'Operacional', '2023-07-20', 1),
-- funcionario recem-contratado, ainda sem sala/certificado atribuidos
('Eduardo Pires Rocha',  '55555555555', NULL,               'Projecionista', 'eduardo.rocha', 'hash_fake_5', 'Operacional', '2026-09-01', 1);

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
('Fernanda Costa Lima',   '66655566677', '(61) 98111-0005', 'fernanda.lima@exemplo.com', '1972-07-07');

INSERT INTO documento_meia_entrada (id_cliente, tipo_documento, numero_documento, validade) VALUES
(3, 'Estudante', 'CE-2026-004521', '2026-12-20'),
(5, 'Idoso', 'RG-IDOSO-778899', NULL);

-- sessao ja ocorrida (10/09), usada para demonstrar status "Utilizado"
INSERT INTO sessao (id_filme, id_sala, data_sessao, horario_inicio, idioma, tipo) VALUES
(1, 1, '2026-09-10', '14:00:00', 'Dublado', '2D');
INSERT INTO sessao (id_filme, id_sala, data_sessao, horario_inicio, idioma, tipo) VALUES
(1, 1, '2026-09-25', '14:00:00', 'Dublado', '2D');
-- sessao futura sem nenhum ingresso vendido ainda (situacao em aberto)
INSERT INTO sessao (id_filme, id_sala, data_sessao, horario_inicio, idioma, tipo) VALUES
(3, 1, '2026-09-26', '10:00:00', 'Legendado', '2D');
INSERT INTO sessao (id_filme, id_sala, data_sessao, horario_inicio, idioma, tipo) VALUES
(2, 2, '2026-09-25', '18:00:00', 'Dublado', '3D');
INSERT INTO sessao (id_filme, id_sala, data_sessao, horario_inicio, idioma, tipo) VALUES
(4, 3, '2026-09-25', '21:00:00', 'Legendado', 'IMAX');
INSERT INTO sessao (id_filme, id_sala, data_sessao, horario_inicio, idioma, tipo) VALUES
(5, 2, '2026-09-26', '15:00:00', 'Dublado', '3D');
INSERT INTO sessao (id_filme, id_sala, data_sessao, horario_inicio, idioma, tipo) VALUES
(1, 3, '2026-09-27', '20:00:00', 'Original', 'IMAX');

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
(1, 1, 1, NULL, 'Inteira', 28.00, '2026-09-09 18:00:00');
INSERT INTO ingresso_status_historico (id_ingresso, status, data_hora, id_funcionario) VALUES
(1, 'Reservado', '2026-09-09 18:00:00', 1),
(1, 'Pago',      '2026-09-09 18:05:00', 1),
(1, 'Utilizado', '2026-09-10 14:10:00', NULL);

-- T2: sessao ja ocorrida, meia-entrada (idoso), ciclo completo ate Utilizado
INSERT INTO ingresso (id_sessao, id_assento, id_cliente, id_documento, tipo, preco_pago, data_compra) VALUES
(1, 2, 5, 2, 'Meia-entrada', 14.00, '2026-09-09 18:00:00');
INSERT INTO ingresso_status_historico (id_ingresso, status, data_hora, id_funcionario) VALUES
(2, 'Reservado', '2026-09-09 18:00:00', 2),
(2, 'Pago',      '2026-09-09 18:05:00', 2),
(2, 'Utilizado', '2026-09-10 14:10:00', NULL);

-- T3: sessao futura, cliente adolescente (16 anos, classificacao 14 ok), APENAS reservado (situacao em aberto)
INSERT INTO ingresso (id_sessao, id_assento, id_cliente, id_documento, tipo, preco_pago, data_compra) VALUES
(2, 6, 2, NULL, 'Inteira', 30.00, '2026-09-17 10:00:00');
INSERT INTO ingresso_status_historico (id_ingresso, status, data_hora, id_funcionario) VALUES
(3, 'Reservado', '2026-09-17 10:00:00', 1);

-- T4: sessao futura, meia-entrada (estudante), paga
INSERT INTO ingresso (id_sessao, id_assento, id_cliente, id_documento, tipo, preco_pago, data_compra) VALUES
(2, 7, 3, 1, 'Meia-entrada', 15.00, '2026-09-16 10:00:00');
INSERT INTO ingresso_status_historico (id_ingresso, status, data_hora, id_funcionario) VALUES
(4, 'Reservado', '2026-09-16 10:00:00', 2),
(4, 'Pago',      '2026-09-16 10:10:00', 2);

-- T5: sequencia (Filme 2), inteira, paga
INSERT INTO ingresso (id_sessao, id_assento, id_cliente, id_documento, tipo, preco_pago, data_compra) VALUES
(4, 11, 1, NULL, 'Inteira', 40.00, '2026-09-16 08:55:00');
INSERT INTO ingresso_status_historico (id_ingresso, status, data_hora, id_funcionario) VALUES
(5, 'Reservado', '2026-09-16 08:55:00', 3),
(5, 'Pago',      '2026-09-16 09:00:00', 3);

-- T6: sequencia (Filme 2), meia-entrada (idoso), paga e depois cancelada dentro do prazo do RN18
INSERT INTO ingresso (id_sessao, id_assento, id_cliente, id_documento, tipo, preco_pago, data_compra) VALUES
(4, 12, 5, 2, 'Meia-entrada', 20.00, '2026-09-16 09:10:00');
INSERT INTO ingresso_status_historico (id_ingresso, status, data_hora, id_funcionario) VALUES
(6, 'Reservado', '2026-09-16 09:10:00', 2),
(6, 'Pago',      '2026-09-16 09:15:00', 2),
(6, 'Cancelado', '2026-09-18 09:00:00', 2);

-- T7: sessao 18+, cliente adulto, inteira, paga
INSERT INTO ingresso (id_sessao, id_assento, id_cliente, id_documento, tipo, preco_pago, data_compra) VALUES
(5, 21, 1, NULL, 'Inteira', 48.00, '2026-09-17 07:55:00');
INSERT INTO ingresso_status_historico (id_ingresso, status, data_hora, id_funcionario) VALUES
(7, 'Reservado', '2026-09-17 07:55:00', 2),
(7, 'Pago',      '2026-09-17 08:00:00', 2);

-- T8: sessao livre, crianca de 11 anos, APENAS reservado (situacao em aberto)
INSERT INTO ingresso (id_sessao, id_assento, id_cliente, id_documento, tipo, preco_pago, data_compra) VALUES
(6, 16, 4, NULL, 'Inteira', 22.00, '2026-09-17 09:00:00');
INSERT INTO ingresso_status_historico (id_ingresso, status, data_hora, id_funcionario) VALUES
(8, 'Reservado', '2026-09-17 09:00:00', 1);

-- T9: sessao IMAX, meia-entrada (estudante), paga
INSERT INTO ingresso (id_sessao, id_assento, id_cliente, id_documento, tipo, preco_pago, data_compra) VALUES
(7, 25, 3, 1, 'Meia-entrada', 16.00, '2026-09-17 09:25:00');
INSERT INTO ingresso_status_historico (id_ingresso, status, data_hora, id_funcionario) VALUES
(9, 'Reservado', '2026-09-17 09:25:00', 1),
(9, 'Pago',      '2026-09-17 09:30:00', 1);

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
(1, 1, '2026-09-09 18:05:00', 46.00);
INSERT INTO venda_ingresso (id_venda, id_ingresso) VALUES (2, 1);
INSERT INTO venda_produto (id_venda, id_produto, quantidade, preco_unitario_venda) VALUES
(2, 1, 1, 18.00);
INSERT INTO pagamento (id_venda, data_pagamento, valor, forma_pagamento) VALUES
(2, '2026-09-09 18:06:00', 46.00, 'Cartao_Credito');

-- Venda do ingresso T2 + refrigerante
INSERT INTO venda (id_cliente, id_funcionario, data_venda, valor_total) VALUES
(5, 2, '2026-09-09 18:05:00', 22.00);
INSERT INTO venda_ingresso (id_venda, id_ingresso) VALUES (3, 2);
INSERT INTO venda_produto (id_venda, id_produto, quantidade, preco_unitario_venda) VALUES
(3, 2, 1, 8.00);
INSERT INTO pagamento (id_venda, data_pagamento, valor, forma_pagamento) VALUES
(3, '2026-09-09 18:07:00', 22.00, 'Pix');

-- Venda avulsa de bomboniere, sem cliente identificado
INSERT INTO venda (id_cliente, id_funcionario, data_venda, valor_total) VALUES
(NULL, 1, '2026-09-17 12:00:00', 21.00);
INSERT INTO venda_produto (id_venda, id_produto, quantidade, preco_unitario_venda) VALUES
(4, 5, 2, 6.00),
(4, 4, 1, 9.00);
INSERT INTO pagamento (id_venda, data_pagamento, valor, forma_pagamento) VALUES
(4, '2026-09-17 12:01:00', 21.00, 'Dinheiro');

-- Venda do ingresso T4
INSERT INTO venda (id_cliente, id_funcionario, data_venda, valor_total) VALUES
(3, 2, '2026-09-16 10:10:00', 15.00);
INSERT INTO venda_ingresso (id_venda, id_ingresso) VALUES (5, 4);
INSERT INTO pagamento (id_venda, data_pagamento, valor, forma_pagamento) VALUES
(5, '2026-09-16 10:11:00', 15.00, 'Pix');

-- Venda do ingresso T5
INSERT INTO venda (id_cliente, id_funcionario, data_venda, valor_total) VALUES
(1, 3, '2026-09-16 09:00:00', 40.00);
INSERT INTO venda_ingresso (id_venda, id_ingresso) VALUES (6, 5);
INSERT INTO pagamento (id_venda, data_pagamento, valor, forma_pagamento) VALUES
(6, '2026-09-16 09:01:00', 40.00, 'Cartao_Debito');

-- Venda do ingresso T6 (posteriormente cancelado — venda/pagamento originais preservados)
INSERT INTO venda (id_cliente, id_funcionario, data_venda, valor_total) VALUES
(5, 2, '2026-09-16 09:15:00', 20.00);
INSERT INTO venda_ingresso (id_venda, id_ingresso) VALUES (7, 6);
INSERT INTO pagamento (id_venda, data_pagamento, valor, forma_pagamento) VALUES
(7, '2026-09-16 09:16:00', 20.00, 'Pix');

-- Venda do ingresso T7
INSERT INTO venda (id_cliente, id_funcionario, data_venda, valor_total) VALUES
(1, 2, '2026-09-17 08:00:00', 48.00);
INSERT INTO venda_ingresso (id_venda, id_ingresso) VALUES (8, 7);
INSERT INTO pagamento (id_venda, data_pagamento, valor, forma_pagamento) VALUES
(8, '2026-09-17 08:01:00', 48.00, 'Cartao_Credito');

-- Venda do ingresso T9
INSERT INTO venda (id_cliente, id_funcionario, data_venda, valor_total) VALUES
(3, 1, '2026-09-17 09:30:00', 16.00);
INSERT INTO venda_ingresso (id_venda, id_ingresso) VALUES (9, 9);
INSERT INTO pagamento (id_venda, data_pagamento, valor, forma_pagamento) VALUES
(9, '2026-09-17 09:31:00', 16.00, 'Dinheiro');

-- T3 e T8 continuam apenas "Reservado" (compra nao finalizada), por
-- isso nao tem venda/pagamento associados ainda.

INSERT INTO fidelidade_pontos (id_cliente, id_venda, pontos, data_credito, data_expiracao) VALUES
-- Pontos ja expirados (creditados em 2025, expiram em 2026-06-01 — antes da data de referencia 2026-09-17)
(1, 1, 35, '2025-06-01 12:05:00', '2026-06-01 12:05:00'),
-- Pontos ainda validos do mesmo cliente (Ana), em vendas diferentes
(1, 2, 46, '2026-09-09 18:06:00', '2027-09-09 18:06:00'),
(1, 6, 40, '2026-09-16 09:01:00', '2027-09-16 09:01:00'),
(1, 8, 48, '2026-09-17 08:01:00', '2027-09-17 08:01:00'),
(5, 3, 22, '2026-09-09 18:07:00', '2027-09-09 18:07:00'),
(5, 7, 20, '2026-09-16 09:16:00', '2027-09-16 09:16:00'),
(3, 5, 15, '2026-09-16 10:11:00', '2027-09-16 10:11:00'),
(3, 9, 16, '2026-09-17 09:31:00', '2027-09-17 09:31:00');
