DROP DATABASE IF EXISTS cinema;

CREATE DATABASE cinema
	CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;
USE cinema;

CREATE TABLE filme (
    id_filme INT UNSIGNED AUTO_INCREMENT,
    titulo_original	VARCHAR(150) NOT NULL,
    sinopse	TEXT NULL,
    duracao_minutos	SMALLINT UNSIGNED NOT NULL,
    genero_principal VARCHAR(40) NOT NULL,
    classificacao_indicativa ENUM('L','10','12','14','16','18') NOT NULL,
    id_filme_relacionado INT UNSIGNED NULL,
    tipo_relacao ENUM('Sequencia','Preludio') NULL,
    
    CONSTRAINT pk_filme PRIMARY KEY (id_filme),
    CONSTRAINT fk_filme_relacionado FOREIGN KEY (id_filme_relacionado)
        REFERENCES filme (id_filme)
        ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT ck_filme_duracao CHECK (duracao_minutos > 0)
) ENGINE=InnoDB
  COMMENT='RN01/RN02: catálogo de filmes e autorrelacionamento de sequência/prelúdio';

CREATE INDEX idx_filme_genero ON filme (genero_principal);

CREATE TABLE sala (
    id_sala INT UNSIGNED AUTO_INCREMENT,
    numero	VARCHAR(10) NOT NULL,
    capacidade	SMALLINT UNSIGNED NOT NULL,
    tipo_projecao	ENUM('2D','3D','IMAX') NOT NULL,
    
    CONSTRAINT pk_sala PRIMARY KEY (id_sala),
    CONSTRAINT uq_sala_numero UNIQUE (numero),
    CONSTRAINT ck_sala_capacidade CHECK (capacidade > 0)
) ENGINE=InnoDB
  COMMENT='RN03: salas de exibição e sua tecnologia de projeção';
  
  CREATE TABLE assento (
    id_assento	INT UNSIGNED AUTO_INCREMENT,
    id_sala	INT UNSIGNED NOT NULL,
    fileira CHAR(2) NOT NULL,
    numero TINYINT UNSIGNED NOT NULL,
    tipo ENUM('Padrao','VIP','PCD','Namorados') NOT NULL DEFAULT 'Padrao',
    
    CONSTRAINT pk_assento PRIMARY KEY (id_assento),
    CONSTRAINT fk_assento_sala FOREIGN KEY (id_sala)
        REFERENCES sala (id_sala)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT uq_assento_posicao UNIQUE (id_sala, fileira, numero)
) ENGINE=InnoDB
  COMMENT='RN04: mapeamento único de assentos (fileira+número) por sala';

CREATE INDEX idx_assento_sala ON assento (id_sala);
  
CREATE TABLE funcionario (
	id_funcionario INT UNSIGNED AUTO_INCREMENT,
    nome VARCHAR(150) NOT NULL,
    CPF CHAR(11) NOT NULL,
    telefone VARCHAR(20) NULL,
    cargo ENUM('Atendente','Gerente','Projecionista') NOT NULL,
    login VARCHAR(50) NOT NULL,
    senha_hash VARCHAR(255) NOT NULL,
    perfil_acesso ENUM('Operacional','Administrativo') NOT NULL DEFAULT 'Operacional',
    data_admissao DATE NOT NULL,
    ativo TINYINT(1) NOT NULL DEFAULT 1,
    
    CONSTRAINT pk_id_funcionario PRIMARY KEY(id_funcionario),
    CONSTRAINT uq_funcionario_cpf UNIQUE(CPF),
    CONSTRAINT ck_funcionario_cpf CHECK (CHAR_LENGTH(cpf) = 11)
)ENGINE=InnoDB
  COMMENT='RN16: quadro de funcionários e credenciais de acesso';
  
CREATE TABLE atendente(
	id_funcionario INT UNSIGNED NOT NULL,
    numero_guiche TINYINT UNSIGNED NOT NULL,
    turno ENUM('Matutino','Vespertino','Noturno') NOT NULL,
    vendas_dia SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    
    CONSTRAINT pk_id_funcionario PRIMARY KEY(id_funcionario),
    CONSTRAINT fk_id_funcionario FOREIGN KEY(id_funcionario)
		REFERENCES funcionario (id_funcionario)
        ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE=InnoDB
  COMMENT='Especialização de funcionario: atendentes de bilheteria/bomboniere';
  
CREATE TABLE gerente (
	id_funcionario INT UNSIGNED NOT NULL,
    sala_escritorio VARCHAR(20) NOT NULL,
    nivel_acesso INT UNSIGNED NOT NULL,
    gratificacao_cargo DECIMAL(8,2) NOT NULL DEFAULT 0.00,
    
    CONSTRAINT pk_id_funcionario PRIMARY KEY(id_funcionario),
    CONSTRAINT fk_id_funcionario_gerente FOREIGN KEY(id_funcionario) 
		REFERENCES funcionario (id_funcionario) 
        ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT ck_gerente_gratificacao CHECK(gratificacao_cargo >= 0)
)ENGINE=InnoDB
  COMMENT='Especialização de funcionario: gerentes de unidade';
  
CREATE TABLE projecionista (
	id_funcionario INT UNSIGNED NOT NULL,
    id_gerente INT UNSIGNED NULL,
    id_sala_responsavel INT UNSIGNED NULL,
    certificado_tec VARCHAR(50) NULL,
    
    CONSTRAINT pk_id_funcionario_proj PRIMARY KEY(id_funcionario),
    CONSTRAINT fk_projecionista_funcionario FOREIGN KEY(id_funcionario)
		REFERENCES funcionario(id_funcionario)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_id_gerente FOREIGN KEY(id_gerente)
		REFERENCES gerente(id_funcionario) 
		ON DELETE SET NULL ON UPDATE CASCADE,
	CONSTRAINT fk_projecionista_sala FOREIGN KEY (id_sala_responsavel)
        REFERENCES sala (id_sala)
        ON DELETE SET NULL ON UPDATE CASCADE
)ENGINE=InnoDB
  COMMENT='Especialização de funcionario: projecionistas e sua sala/gerente responsável';

CREATE TABLE cliente (
	id_cliente INT UNSIGNED AUTO_INCREMENT,
    nome VARCHAR(150) NOT NULL,
    CPF CHAR(11) NOT NULL,
    telefone VARCHAR(20) NULL,
    email VARCHAR(100) NOT NULL,
	data_nascimento DATE NOT NULL,
    
	CONSTRAINT pk_id_cliente PRIMARY KEY(id_cliente),
    CONSTRAINT uq_cliente_cpf UNIQUE(CPF),
    CONSTRAINT ck_cliente_cpf CHECK (CHAR_LENGTH(cpf) = 11),
    CONSTRAINT uq_cliente_email UNIQUE(email)
) ENGINE=InnoDB
  COMMENT='RN08: cadastro de clientes';
  
CREATE TABLE documento_meia_entrada (
    id_documento INT UNSIGNED AUTO_INCREMENT,
    id_cliente INT UNSIGNED NOT NULL,
    tipo_documento ENUM('Estudante','Idoso','Deficiencia','Professor','Outro') NOT NULL,
    numero_documento VARCHAR(30) NOT NULL,
    validade DATE NULL,
    
    CONSTRAINT pk_documento_meia PRIMARY KEY (id_documento),
    CONSTRAINT fk_documento_cliente FOREIGN KEY (id_cliente)
        REFERENCES cliente (id_cliente)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB
  COMMENT='RN12: documentos comprobatórios usados para validar meia-entrada';
  
CREATE TABLE sessao (
	id_sessao INT UNSIGNED AUTO_INCREMENT,
    id_filme INT UNSIGNED NOT NULL,
    id_sala INT UNSIGNED NOT NULL,
    data_sessao DATE NOT NULL,
    horario_inicio TIME NOT NULL,
    idioma ENUM('Dublado','Legendado','Original') NOT NULL,
    tipo ENUM('2D','3D','IMAX') NOT NULL,

	CONSTRAINT pk_id_sessao PRIMARY KEY(id_sessao),
    CONSTRAINT fk_id_filme FOREIGN KEY(id_filme)
		REFERENCES filme (id_filme)
        ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT fk_id_sala FOREIGN KEY(id_sala)
		REFERENCES sala (id_sala)
        ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT uq_sessao_sala_horario UNIQUE (id_sala, data_sessao, horario_inicio)
) ENGINE=InnoDB
  COMMENT='RN05/RN06: programação de sessões por filme/sala/data/horário';
  
CREATE INDEX idx_sessao_data ON sessao (data_sessao);
CREATE INDEX idx_sessao_filme ON sessao (id_filme);

CREATE TABLE sessao_preco_historico (
    id_preco INT UNSIGNED AUTO_INCREMENT,
    id_sessao INT UNSIGNED NOT NULL,
    preco_base DECIMAL(6,2) NOT NULL,
    vigencia_inicio DATETIME NOT NULL,
    
    CONSTRAINT pk_sessao_preco PRIMARY KEY (id_preco),
    CONSTRAINT fk_preco_sessao FOREIGN KEY (id_sessao)
        REFERENCES sessao (id_sessao)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT uq_preco_sessao_vigencia UNIQUE (id_sessao, vigencia_inicio),
    CONSTRAINT ck_preco_base CHECK (preco_base > 0)
) ENGINE=InnoDB
  COMMENT='RN07: histórico datado de preço base por sessão';
  
  CREATE TABLE ingresso (
    id_ingresso INT UNSIGNED AUTO_INCREMENT,
    id_sessao INT UNSIGNED NOT NULL,
    id_assento INT UNSIGNED NOT NULL,
    id_cliente INT UNSIGNED NOT NULL,
    id_documento INT UNSIGNED NULL,
    tipo ENUM('Inteira','Meia-entrada') NOT NULL,
    preco_pago DECIMAL(6,2) NOT NULL,
    data_compra DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT pk_ingresso PRIMARY KEY (id_ingresso),
    CONSTRAINT fk_ingresso_sessao FOREIGN KEY (id_sessao)
        REFERENCES sessao (id_sessao)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_ingresso_assento FOREIGN KEY (id_assento)
        REFERENCES assento (id_assento)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_ingresso_cliente FOREIGN KEY (id_cliente)
        REFERENCES cliente (id_cliente)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_ingresso_documento FOREIGN KEY (id_documento)
        REFERENCES documento_meia_entrada (id_documento)
        ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT ck_ingresso_preco CHECK (preco_pago > 0),
    CONSTRAINT ck_ingresso_meia_documento CHECK ((tipo = 'Inteira' AND id_documento IS NULL) OR (tipo = 'Meia-entrada' AND id_documento IS NOT NULL))
) ENGINE=InnoDB
  COMMENT='RN09/RN10/RN11/RN12: venda de ingressos por assento/sessão';

CREATE INDEX idx_ingresso_sessao_assento ON ingresso (id_sessao, id_assento);
CREATE INDEX idx_ingresso_cliente ON ingresso (id_cliente);

CREATE TABLE ingresso_status_historico (
    id_status_hist INT UNSIGNED AUTO_INCREMENT,
    id_ingresso INT UNSIGNED NOT NULL,
    status ENUM('Reservado','Pago','Cancelado','Utilizado') NOT NULL,
    data_hora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_funcionario INT UNSIGNED NULL,
    
    CONSTRAINT pk_ingresso_status PRIMARY KEY (id_status_hist),
    CONSTRAINT fk_status_ingresso FOREIGN KEY (id_ingresso)
        REFERENCES ingresso (id_ingresso)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_status_funcionario FOREIGN KEY (id_funcionario)
        REFERENCES funcionario (id_funcionario)
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB
  COMMENT='RN13/RN18: histórico de status do ingresso ao longo do tempo';
  
  CREATE INDEX idx_status_ingresso ON ingresso_status_historico (id_ingresso, data_hora);
  
CREATE TABLE produto (
    id_produto INT UNSIGNED AUTO_INCREMENT,
    nome VARCHAR(80) NOT NULL,
    categoria ENUM('Pipoca','Bebida','Doce','Combo','Outro') NOT NULL,
    preco_unitario_atual DECIMAL(6,2) NOT NULL,
    estoque_atual SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    estoque_minimo SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    
    CONSTRAINT pk_produto PRIMARY KEY (id_produto),
    CONSTRAINT ck_produto_preco CHECK (preco_unitario_atual > 0)
) ENGINE=InnoDB
  COMMENT='RN14: catálogo e estoque de produtos da bomboniere';
  
  CREATE TABLE venda (
    id_venda INT UNSIGNED AUTO_INCREMENT,
    id_cliente INT UNSIGNED NULL,
    id_funcionario INT UNSIGNED NOT NULL,
    data_venda DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    valor_total DECIMAL(8,2) NOT NULL,
    
    CONSTRAINT pk_venda PRIMARY KEY (id_venda),
    CONSTRAINT fk_venda_cliente FOREIGN KEY (id_cliente)
        REFERENCES cliente (id_cliente)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_venda_funcionario FOREIGN KEY (id_funcionario)
        REFERENCES funcionario (id_funcionario)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT ck_venda_valor CHECK (valor_total > 0)
) ENGINE=InnoDB
  COMMENT='RN15/RN17/RN20: transação de venda (ingressos e/ou bomboniere)';

CREATE INDEX idx_venda_cliente ON venda (id_cliente);
CREATE INDEX idx_venda_funcionario ON venda (id_funcionario);

CREATE TABLE venda_ingresso (
    id_venda INT UNSIGNED NOT NULL,
    id_ingresso INT UNSIGNED NOT NULL,
    CONSTRAINT pk_venda_ingresso PRIMARY KEY (id_venda, id_ingresso),
    CONSTRAINT fk_id_venda FOREIGN KEY (id_venda)
        REFERENCES venda (id_venda)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_id_ingresso FOREIGN KEY (id_ingresso)
        REFERENCES ingresso (id_ingresso)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT uq_vi_ingresso UNIQUE (id_ingresso)
) ENGINE=InnoDB
  COMMENT='RN15: ingressos incluídos em cada venda (um ingresso pertence a uma única venda)';
  
CREATE TABLE venda_produto (
    id_venda_produto INT UNSIGNED AUTO_INCREMENT,
    id_venda INT UNSIGNED NOT NULL,
    id_produto INT UNSIGNED NOT NULL,
    quantidade SMALLINT UNSIGNED NOT NULL,
    preco_unitario_venda DECIMAL(6,2) NOT NULL,
    
    CONSTRAINT pk_venda_produto PRIMARY KEY (id_venda_produto),
    CONSTRAINT fk_vp_venda FOREIGN KEY (id_venda)
        REFERENCES venda (id_venda)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_vp_produto FOREIGN KEY (id_produto)
        REFERENCES produto (id_produto)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT ck_vp_quantidade CHECK (quantidade > 0),
    CONSTRAINT ck_vp_preco CHECK (preco_unitario_venda > 0)
) ENGINE=InnoDB
  COMMENT='RN14/RN15: itens de bomboniere vendidos em cada venda';
  
  CREATE TABLE pagamento (
    id_pagamento INT UNSIGNED AUTO_INCREMENT,
    id_venda INT UNSIGNED NOT NULL,
    data_pagamento DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    valor DECIMAL(8,2) NOT NULL,
    forma_pagamento ENUM('Dinheiro','Cartao_Credito','Cartao_Debito','Pix') NOT NULL,
    
    CONSTRAINT pk_pagamento PRIMARY KEY (id_pagamento),
    CONSTRAINT fk_pagamento_venda FOREIGN KEY (id_venda)
        REFERENCES venda (id_venda)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT uq_pagamento_venda UNIQUE (id_venda),
    CONSTRAINT ck_pagamento_valor CHECK (valor > 0)
) ENGINE=InnoDB
  COMMENT='RN20: pagamento de uma venda (1 pagamento por venda, nesta modelagem)';
  
CREATE TABLE fidelidade_pontos (
    id_ponto INT UNSIGNED AUTO_INCREMENT,
    id_cliente INT UNSIGNED NOT NULL,
    id_venda INT UNSIGNED NOT NULL,
    pontos INT UNSIGNED NOT NULL,
    data_credito DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_expiracao DATETIME NOT NULL,
    CONSTRAINT pk_fidelidade PRIMARY KEY (id_ponto),
    CONSTRAINT fk_fidelidade_cliente FOREIGN KEY (id_cliente)
        REFERENCES cliente (id_cliente)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_fidelidade_venda FOREIGN KEY (id_venda)
        REFERENCES venda (id_venda)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT ck_fidelidade_pontos CHECK (pontos > 0),
    CONSTRAINT ck_fidelidade_expiracao CHECK (data_expiracao > data_credito)
) ENGINE=InnoDB
  COMMENT='RN19: pontos de fidelidade por venda, com expiração em 12 meses';

CREATE INDEX idx_fidelidade_cliente ON fidelidade_pontos (id_cliente);

DELIMITER $$

-- RN02: id_filme_relacionado e tipo_relacao devem ser preenchidos juntos
-- ou ficar ambos em branco (não pode ser feito via CHECK — ver comentário
-- na tabela filme).
CREATE TRIGGER trg_filme_valida_relacao
BEFORE INSERT ON filme
FOR EACH ROW
BEGIN
    IF (NEW.id_filme_relacionado IS NULL) <> (NEW.tipo_relacao IS NULL) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'RN02: id_filme_relacionado e tipo_relacao devem ser preenchidos juntos.';
    END IF;
END$$

-- RN06: impede sobreposição de horário na mesma sala, considerando a
-- duração do filme + 30 minutos de limpeza entre sessões.
CREATE TRIGGER trg_sessao_valida_horario
BEFORE INSERT ON sessao
FOR EACH ROW
BEGIN
    DECLARE v_duracao INT;
    DECLARE v_conflitos INT;

    SELECT duracao_minutos INTO v_duracao FROM filme WHERE id_filme = NEW.id_filme;

    SELECT COUNT(*) INTO v_conflitos
    FROM sessao s
    JOIN filme f ON f.id_filme = s.id_filme
    WHERE s.id_sala = NEW.id_sala
      AND s.data_sessao = NEW.data_sessao
      AND TIMESTAMP(s.data_sessao, s.horario_inicio)
            < TIMESTAMP(NEW.data_sessao, ADDTIME(NEW.horario_inicio, SEC_TO_TIME((v_duracao + 30) * 60)))
      AND TIMESTAMP(NEW.data_sessao, NEW.horario_inicio)
            < TIMESTAMP(s.data_sessao, ADDTIME(s.horario_inicio, SEC_TO_TIME((f.duracao_minutos + 30) * 60)));

    IF v_conflitos > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'RN06: conflito de horario na sala (sobreposicao + intervalo de limpeza de 30min).';
    END IF;
END$$

-- RN09/RN10/RN11/RN12: validações de venda de ingresso.
CREATE TRIGGER trg_ingresso_valida_regras
BEFORE INSERT ON ingresso
FOR EACH ROW
BEGIN
    DECLARE v_data_nasc DATE;
    DECLARE v_data_sessao DATE;
    DECLARE v_classificacao VARCHAR(3);
    DECLARE v_idade INT;
    DECLARE v_idade_min INT;
    DECLARE v_ocupado INT;

    -- RN10/RN11: assento não pode estar ocupado por outro ingresso
    -- ainda ativo (status mais recente diferente de 'Cancelado') na
    -- mesma sessão.
    SELECT COUNT(*) INTO v_ocupado
    FROM ingresso i
    WHERE i.id_sessao = NEW.id_sessao
      AND i.id_assento = NEW.id_assento
      AND (
          SELECT h.status
          FROM ingresso_status_historico h
          WHERE h.id_ingresso = i.id_ingresso
          ORDER BY h.data_hora DESC, h.id_status_hist DESC
          LIMIT 1
      ) <> 'Cancelado';

    IF v_ocupado > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'RN10/RN11: assento ja ocupado nesta sessao.';
    END IF;

    -- RN09: idade do cliente deve respeitar a classificação indicativa
    -- da sessão no momento da compra.
    SELECT f.classificacao_indicativa, s.data_sessao
        INTO v_classificacao, v_data_sessao
    FROM sessao s
    JOIN filme f ON f.id_filme = s.id_filme
    WHERE s.id_sessao = NEW.id_sessao;

    SELECT data_nascimento INTO v_data_nasc FROM cliente WHERE id_cliente = NEW.id_cliente;

    SET v_idade = TIMESTAMPDIFF(YEAR, v_data_nasc, v_data_sessao);
    SET v_idade_min = CASE v_classificacao
        WHEN 'L' THEN 0 WHEN '10' THEN 10 WHEN '12' THEN 12
        WHEN '14' THEN 14 WHEN '16' THEN 16 WHEN '18' THEN 18 ELSE 0 END;

    IF v_idade < v_idade_min THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'RN09: idade do cliente nao atende a classificacao indicativa da sessao.';
    END IF;
END$$

-- RN18: ingresso pago só pode ser cancelado até 1h antes da sessão.
CREATE TRIGGER trg_status_valida_cancelamento
BEFORE INSERT ON ingresso_status_historico
FOR EACH ROW
BEGIN
    DECLARE v_data_sessao DATE;
    DECLARE v_horario TIME;
    DECLARE v_status_atual VARCHAR(20);

    IF NEW.status = 'Cancelado' THEN
        SELECT s.data_sessao, s.horario_inicio INTO v_data_sessao, v_horario
        FROM ingresso i
        JOIN sessao s ON s.id_sessao = i.id_sessao
        WHERE i.id_ingresso = NEW.id_ingresso;

        SELECT status INTO v_status_atual
        FROM ingresso_status_historico
        WHERE id_ingresso = NEW.id_ingresso
        ORDER BY data_hora DESC, id_status_hist DESC
        LIMIT 1;

        IF v_status_atual = 'Pago'
           AND NEW.data_hora > (TIMESTAMP(v_data_sessao, v_horario) - INTERVAL 1 HOUR) THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'RN18: cancelamento de ingresso pago so e permitido ate 1h antes da sessao.';
        END IF;
    END IF;
END$$

DELIMITER ;