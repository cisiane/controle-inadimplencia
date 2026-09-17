-- =====================================================
-- Projeto: Controle da Inadimplência em Operações de Crédito
-- Análise Univariada
-- Tabela analisada: inadimplencia_credito
-- Ferramenta: DuckDB
-- =====================================================


-- =====================================================
-- 3.1 ANÁLISE DE VARIÁVEIS QUALITATIVAS
-- =====================================================
--
-- Objetivo:
-- Analisar a distribuição das categorias de cada variável.
--
-- Lógica:
-- GROUP BY agrupa os registros por categoria.
-- COUNT(*) calcula a frequência absoluta.
-- SUM(COUNT(*)) OVER() calcula o total de registros da base.
-- O percentual é obtido dividindo a frequência da categoria
-- pelo total de registros.
--
-- =====================================================


-- -----------------------------------------------------
-- Variável: Inadimplencia
-- -----------------------------------------------------

SELECT
    Inadimplencia,
    ROUND(COUNT(*) * 1.0 / (
        SELECT COUNT(*)
        FROM main.inadimplencia_credito
    ), 2) AS perc_clientes,
    COUNT(*) AS qtd_clientes
FROM main.inadimplencia_credito
GROUP BY Inadimplencia
ORDER BY qtd_clientes DESC;


-- -----------------------------------------------------
-- Variável: Sexo
-- -----------------------------------------------------

SELECT
    Sexo,
    ROUND(COUNT(*) * 1.0 / (
        SELECT COUNT(*)
        FROM main.inadimplencia_credito
    ), 2) AS perc_clientes,
    COUNT(*) AS qtd_clientes
FROM main.inadimplencia_credito
GROUP BY Sexo
ORDER BY qtd_clientes DESC;


-- -----------------------------------------------------
-- Variável: Escolaridade
-- -----------------------------------------------------

SELECT
    Escolaridade,
    ROUND(COUNT(*) * 1.0 / (
        SELECT COUNT(*)
        FROM main.inadimplencia_credito
    ), 2) AS perc_clientes,
    COUNT(*) AS qtd_clientes
FROM main.inadimplencia_credito
GROUP BY Escolaridade
ORDER BY qtd_clientes DESC;


-- -----------------------------------------------------
-- Variável: Tipo_Moradia
-- -----------------------------------------------------

SELECT
    Tipo_Moradia,
    ROUND(COUNT(*) * 1.0 / (
        SELECT COUNT(*)
        FROM main.inadimplencia_credito
    ), 2) AS perc_clientes,
    COUNT(*) AS qtd_clientes
FROM main.inadimplencia_credito
GROUP BY Tipo_Moradia
ORDER BY qtd_clientes DESC;


-- -----------------------------------------------------
-- Variável: Saldo_Investimento
-- -----------------------------------------------------

SELECT
    Saldo_Investimento,
    ROUND(COUNT(*) * 1.0 / (
        SELECT COUNT(*)
        FROM main.inadimplencia_credito
    ), 2) AS perc_clientes,
    COUNT(*) AS qtd_clientes
FROM main.inadimplencia_credito
GROUP BY Saldo_Investimento
ORDER BY qtd_clientes DESC;


-- -----------------------------------------------------
-- Variável: Saldo_Conta_Corrente
-- -----------------------------------------------------

SELECT
    Saldo_Conta_Corrente,
    ROUND(COUNT(*) * 1.0 / (
        SELECT COUNT(*)
        FROM main.inadimplencia_credito
    ), 2) AS perc_clientes,
    COUNT(*) AS qtd_clientes
FROM main.inadimplencia_credito
GROUP BY Saldo_Conta_Corrente
ORDER BY qtd_clientes DESC;



-- =====================================================
-- 3.2 ESTATÍSTICAS DESCRITIVAS DAS VARIÁVEIS NUMÉRICAS
-- =====================================================
--
-- Objetivo:
-- Compreender o comportamento das variáveis quantitativas.
--
-- Lógica:
-- MIN()              = menor valor
-- MAX()              = maior valor
-- AVG()              = média
-- MEDIAN()           = mediana
-- STDDEV_SAMP()      = desvio padrão amostral
--
-- =====================================================


-- -----------------------------------------------------
-- Variável: Idade
-- -----------------------------------------------------

SELECT
    MIN(Idade) AS minimo,
    MAX(Idade) AS maximo,
    ROUND(AVG(Idade), 2) AS media,
    MEDIAN(Idade) AS mediana,
    ROUND(STDDEV_SAMP(Idade), 2) AS desvio_padrao
FROM main.inadimplencia_credito;


-- -----------------------------------------------------
-- Variável: Valor_Emprestimo
-- -----------------------------------------------------

SELECT
    MIN(Valor_Emprestimo) AS minimo,
    MAX(Valor_Emprestimo) AS maximo,
    ROUND(AVG(Valor_Emprestimo), 2) AS media,
    MEDIAN(Valor_Emprestimo) AS mediana,
    ROUND(STDDEV_SAMP(Valor_Emprestimo), 2) AS desvio_padrao
FROM main.inadimplencia_credito;


-- -----------------------------------------------------
-- Variável: Duracao_Emprestimo
-- -----------------------------------------------------

SELECT
    MIN(Duracao_Emprestimo) AS minimo,
    MAX(Duracao_Emprestimo) AS maximo,
    ROUND(AVG(Duracao_Emprestimo), 2) AS media,
    MEDIAN(Duracao_Emprestimo) AS mediana,
    ROUND(STDDEV_SAMP(Duracao_Emprestimo), 2) AS desvio_padrao
FROM main.inadimplencia_credito;



-- =====================================================
-- 3.3 CÁLCULO DOS QUARTIS
-- =====================================================
--
-- Objetivo:
-- Avaliar a distribuição dos dados por meio dos quartis.
--
-- Lógica:
-- Q1 = 25% dos valores abaixo
-- Q2 = Mediana (50%)
-- Q3 = 75% dos valores abaixo
--
-- =====================================================


-- -----------------------------------------------------
-- Variável: Idade
-- -----------------------------------------------------

SELECT
    QUANTILE_CONT(Idade, 0.25) AS q1,
    QUANTILE_CONT(Idade, 0.50) AS q2,
    QUANTILE_CONT(Idade, 0.75) AS q3
FROM main.inadimplencia_credito;


-- -----------------------------------------------------
-- Variável: Valor_Emprestimo
-- -----------------------------------------------------

SELECT
    QUANTILE_CONT(Valor_Emprestimo, 0.25) AS q1,
    QUANTILE_CONT(Valor_Emprestimo, 0.50) AS q2,
    QUANTILE_CONT(Valor_Emprestimo, 0.75) AS q3
FROM main.inadimplencia_credito;


-- -----------------------------------------------------
-- Variável: Duracao_Emprestimo
-- -----------------------------------------------------

SELECT
    QUANTILE_CONT(Duracao_Emprestimo, 0.25) AS q1,
    QUANTILE_CONT(Duracao_Emprestimo, 0.50) AS q2,
    QUANTILE_CONT(Duracao_Emprestimo, 0.75) AS q3
FROM main.inadimplencia_credito;



-- =====================================================
-- 3.4 DISTRIBUIÇÃO POR FAIXA ETÁRIA
-- =====================================================
--
-- Objetivo:
-- Facilitar a interpretação da distribuição da idade.
--
-- =====================================================

SELECT
    CASE
        WHEN Idade BETWEEN 18 AND 24 THEN '18 a 24'
        WHEN Idade BETWEEN 25 AND 34 THEN '25 a 34'
        WHEN Idade BETWEEN 35 AND 44 THEN '35 a 44'
        WHEN Idade BETWEEN 45 AND 54 THEN '45 a 54'
        WHEN Idade BETWEEN 55 AND 64 THEN '55 a 64'
        ELSE '65+'
    END AS faixa_etaria,

    COUNT(*) AS quantidade,

    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        1
    ) AS percentual

FROM main.inadimplencia_credito

GROUP BY faixa_etaria

ORDER BY
    CASE
        WHEN faixa_etaria = '18 a 24' THEN 1
        WHEN faixa_etaria = '25 a 34' THEN 2
        WHEN faixa_etaria = '35 a 44' THEN 3
        WHEN faixa_etaria = '45 a 54' THEN 4
        WHEN faixa_etaria = '55 a 64' THEN 5
        ELSE 6
    END;



-- =====================================================
-- 3.5 DISTRIBUIÇÃO POR FAIXAS DE VALOR DO EMPRÉSTIMO
-- =====================================================
--
-- Objetivo:
-- Facilitar a interpretação da distribuição
-- dos valores contratados.
--
-- =====================================================

SELECT
    CASE
        WHEN Valor_Emprestimo < 1000 THEN 'Até R$ 999'
        WHEN Valor_Emprestimo < 2000 THEN 'R$ 1.000 a 1.999'
        WHEN Valor_Emprestimo < 3000 THEN 'R$ 2.000 a 2.999'
        WHEN Valor_Emprestimo < 4000 THEN 'R$ 3.000 a 3.999'
        WHEN Valor_Emprestimo < 5000 THEN 'R$ 4.000 a 4.999'
        ELSE 'R$ 5.000 ou mais'
    END AS faixa_valor,

    COUNT(*) AS quantidade,

    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        1
    ) AS percentual

FROM main.inadimplencia_credito

GROUP BY faixa_valor

ORDER BY
    CASE
        WHEN faixa_valor = 'Até R$ 999' THEN 1
        WHEN faixa_valor = 'R$ 1.000 a 1.999' THEN 2
        WHEN faixa_valor = 'R$ 2.000 a 2.999' THEN 3
        WHEN faixa_valor = 'R$ 3.000 a 3.999' THEN 4
        WHEN faixa_valor = 'R$ 4.000 a 4.999' THEN 5
        ELSE 6
    END;



-- =====================================================
-- 3.6 DISTRIBUIÇÃO POR FAIXAS DE DURAÇÃO DO EMPRÉSTIMO
-- =====================================================
--
-- Objetivo:
-- Facilitar a interpretação da distribuição
-- dos prazos contratados.
--
-- Lógica:
-- Utilização de CASE WHEN no ORDER BY para preservar
-- a ordem lógica das categorias.
--
-- =====================================================

SELECT
    CASE
        WHEN Duracao_Emprestimo <= 12 THEN 'Até 12 meses'
        WHEN Duracao_Emprestimo <= 24 THEN '13 a 24 meses'
        WHEN Duracao_Emprestimo <= 36 THEN '25 a 36 meses'
        WHEN Duracao_Emprestimo <= 48 THEN '37 a 48 meses'
        WHEN Duracao_Emprestimo <= 60 THEN '49 a 60 meses'
        ELSE '61 a 72 meses'
    END AS faixa_duracao,

    COUNT(*) AS quantidade,

    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        1
    ) AS percentual

FROM main.inadimplencia_credito

GROUP BY faixa_duracao

ORDER BY
    CASE
        WHEN faixa_duracao = 'Até 12 meses' THEN 1
        WHEN faixa_duracao = '13 a 24 meses' THEN 2
        WHEN faixa_duracao = '25 a 36 meses' THEN 3
        WHEN faixa_duracao = '37 a 48 meses' THEN 4
        WHEN faixa_duracao = '49 a 60 meses' THEN 5
        ELSE 6
    END;
