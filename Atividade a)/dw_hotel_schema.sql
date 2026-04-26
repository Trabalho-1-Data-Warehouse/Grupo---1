-- ============================================================
--  DW_HOTEL – Criação da Estrutura (Schema)
--  Execute este arquivo PRIMEIRO para criar o banco e tabelas.
-- ============================================================

-- 1. Criar e selecionar o banco
DROP DATABASE IF EXISTS dw_hotel;
CREATE DATABASE dw_hotel CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE dw_hotel;

-- ============================================================
-- 2. TABELAS DIMENSÃO
-- ============================================================

CREATE TABLE Hospede (
    idHospede   INT PRIMARY KEY,
    nome        VARCHAR(40) NOT NULL
);

CREATE TABLE Agencia (
    idAgencia   INT PRIMARY KEY,
    nome        VARCHAR(30) NOT NULL
);

CREATE TABLE Apto (
    idApartamento   INT PRIMARY KEY,
    numero          INT NOT NULL,
    andar           INT NOT NULL,
    tipo            VARCHAR(10) NOT NULL
);

CREATE TABLE Produto (
    idProduto   INT PRIMARY KEY,
    descricao   VARCHAR(30) NOT NULL
);

CREATE TABLE Servico (
    idServico   INT PRIMARY KEY,
    descricao   VARCHAR(30) NOT NULL
);

CREATE TABLE Tempo (
    idTempo INT PRIMARY KEY,
    ano     CHAR(4) NOT NULL,
    mes     CHAR(2) NOT NULL,
    dia     CHAR(2) NOT NULL
);

-- ============================================================
-- 3. TABELAS FATO
-- ============================================================

CREATE TABLE Hospedagem (
    idHospedagem                INT AUTO_INCREMENT PRIMARY KEY,
    Hospede_idHospede           INT NOT NULL,
    Meio_Transporte             INT NOT NULL,
    Agencia_idAgencia           INT NOT NULL,
    Apartamento_idApartamento   INT NOT NULL,
    Motivo_Viagem               VARCHAR(50) NOT NULL,
    Tempo_idTempo               INT NOT NULL,
    Valor_Faturado              DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (Hospede_idHospede)           REFERENCES Hospede(idHospede),
    FOREIGN KEY (Agencia_idAgencia)           REFERENCES Agencia(idAgencia),
    FOREIGN KEY (Apartamento_idApartamento)   REFERENCES Apto(idApartamento),
    FOREIGN KEY (Tempo_idTempo)               REFERENCES Tempo(idTempo)
);

CREATE TABLE Consumo (
    idConsumo           INT AUTO_INCREMENT PRIMARY KEY,
    Tempo_idTempo       INT NOT NULL,
    Hospede_idHospede   INT NOT NULL,
    Apto_idApartamento  INT NOT NULL,
    Produto_idProduto   INT NOT NULL,
    Servico_idServico   INT NOT NULL,
    quantidade          INT NOT NULL,
    Valor_Consumo       DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (Tempo_idTempo)      REFERENCES Tempo(idTempo),
    FOREIGN KEY (Hospede_idHospede)  REFERENCES Hospede(idHospede),
    FOREIGN KEY (Apto_idApartamento) REFERENCES Apto(idApartamento),
    FOREIGN KEY (Produto_idProduto)  REFERENCES Produto(idProduto),
    FOREIGN KEY (Servico_idServico)  REFERENCES Servico(idServico)
);

-- ============================================================
-- 4. ÍNDICES
-- ============================================================

-- Dimensão Tempo
CREATE INDEX idx_tempo_ano        ON Tempo (ano);
CREATE INDEX idx_tempo_mes        ON Tempo (mes);
CREATE INDEX idx_tempo_ano_mes    ON Tempo (ano, mes);

-- Dimensão Hospede
CREATE INDEX idx_hospede_nome     ON Hospede (nome);

-- Dimensão Agencia
CREATE INDEX idx_agencia_nome     ON Agencia (nome);

-- Dimensão Apto
CREATE INDEX idx_apto_tipo        ON Apto (tipo);
CREATE INDEX idx_apto_andar       ON Apto (andar);

-- Dimensão Produto
CREATE INDEX idx_produto_desc     ON Produto (descricao);

-- Dimensão Servico
CREATE INDEX idx_servico_desc     ON Servico (descricao);

-- Fato Hospedagem
CREATE INDEX idx_hosp_tempo       ON Hospedagem (Tempo_idTempo);
CREATE INDEX idx_hosp_hospede     ON Hospedagem (Hospede_idHospede);
CREATE INDEX idx_hosp_agencia     ON Hospedagem (Agencia_idAgencia);
CREATE INDEX idx_hosp_apto        ON Hospedagem (Apartamento_idApartamento);
CREATE INDEX idx_hosp_valor       ON Hospedagem (Valor_Faturado);
CREATE INDEX idx_hosp_tempo_hosp  ON Hospedagem (Tempo_idTempo, Hospede_idHospede);

-- Fato Consumo
CREATE INDEX idx_cons_tempo       ON Consumo (Tempo_idTempo);
CREATE INDEX idx_cons_hospede     ON Consumo (Hospede_idHospede);
CREATE INDEX idx_cons_produto     ON Consumo (Produto_idProduto);
CREATE INDEX idx_cons_servico     ON Consumo (Servico_idServico);
CREATE INDEX idx_cons_apto        ON Consumo (Apto_idApartamento);
CREATE INDEX idx_cons_tempo_prod  ON Consumo (Tempo_idTempo, Produto_idProduto);
CREATE INDEX idx_cons_tempo_valor ON Consumo (Tempo_idTempo, Valor_Consumo);
