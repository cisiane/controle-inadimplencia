-- =====================================================
-- Projeto: Biblioteca de Cálculo do Information Value (IV)
-- Arquivo: calculo_information_value.sql
-- Técnica: Análise Bivariada
-- Ferramenta: DuckDB
-- =====================================================

-- =====================================================
-- OBJETIVO
-- =====================================================
--
-- Calcular o Information Value (IV) de uma variável
-- em relação a um evento binário.
--
-- Variáveis quantitativas devem ser previamente
-- transformadas em categorias por meio da criação
-- de faixas.
--
-- Neste exemplo:
-- Variável analisada : Escolaridade
-- Evento             : inadimplencia
--
-- Observação:
-- A variável Escolaridade é utilizada apenas como
-- exemplo. Para reutilizar esta consulta em outros
-- projetos, substitua Escolaridade pela variável
-- desejada em todos os pontos da query.
--
-- =====================================================


-- =====================================================
-- 1 PREPARAÇÃO DE VARIÁVEIS QUANTITATIVAS
-- =====================================================
--
-- Objetivo:
-- Transformar variáveis quantitativas em categorias
-- para possibilitar o cálculo do Information Value.
--
-- Lógica:
-- O IV é calculado a partir da comparação entre
-- categorias. Portanto, variáveis numéricas devem
-- ser previamente agrupadas em faixas utilizando
-- a estrutura CASE WHEN.
--
-- Observação:
-- Esta etapa não é necessária para variáveis que já
-- são naturalmente categóricas, como Escolaridade,
-- Sexo ou Tipo_Moradia.
--
-- Resultado esperado:
-- Uma nova variável categórica que poderá ser
-- utilizada nas etapas seguintes do cálculo do IV.
--
-- =====================================================


-- Exemplo: criação de faixas para a variável Idade

SELECT
    CASE
        WHEN Idade BETWEEN 18 AND 24 THEN '18 a 24'
        WHEN Idade BETWEEN 25 AND 34 THEN '25 a 34'
        WHEN Idade BETWEEN 35 AND 44 THEN '35 a 44'
        WHEN Idade BETWEEN 45 AND 54 THEN '45 a 54'
        WHEN Idade BETWEEN 55 AND 64 THEN '55 a 64'
        ELSE '65+'
    END AS faixa_etaria,
    COUNT(*) AS quantidade
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
-- 1.1 UTILIZAÇÃO DAS FAIXAS NO CÁLCULO DO IV
-- =====================================================
--
-- Objetivo:
-- Demonstrar como uma variável quantitativa
-- transformada em faixas passa a ser utilizada
-- nas etapas seguintes do cálculo do Information Value.
--
-- Lógica:
-- A CTE faixas cria uma nova variável categórica
-- chamada faixa_etaria a partir da variável Idade.
--
-- Após a transformação, a nova variável passa a ser
-- utilizada no agrupamento dos dados, substituindo
-- a variável numérica original.
--
-- SUM(CASE WHEN ...) contabiliza separadamente
-- a quantidade de inadimplentes (qtd_maus)
-- e adimplentes (qtd_bons) em cada faixa.
--
-- COUNT(*) calcula o total de clientes
-- em cada categoria.
--
-- O ORDER BY com CASE WHEN é utilizado para
-- preservar a ordem lógica das faixas etárias,
-- evitando a ordenação alfabética.
--
-- Resultado esperado:
--
-- faixa_etaria
-- qtd_maus
-- qtd_bons
-- total
--
-- Essa estrutura possui o mesmo formato utilizado
-- nas etapas iniciais do cálculo do IV para
-- variáveis originalmente categóricas.
--
-- =====================================================

WITH faixas AS (
    SELECT
        CASE
            WHEN Idade BETWEEN 18 AND 24 THEN '18 a 24'
            WHEN Idade BETWEEN 25 AND 34 THEN '25 a 34'
            WHEN Idade BETWEEN 35 AND 44 THEN '35 a 44'
            WHEN Idade BETWEEN 45 AND 54 THEN '45 a 54'
            WHEN Idade BETWEEN 55 AND 64 THEN '55 a 64'
            ELSE '65+'
        END AS faixa_etaria,
        inadimplencia
    FROM main.inadimplencia_credito
)
SELECT
    faixa_etaria,
    SUM(CASE WHEN inadimplencia = 1 THEN 1 ELSE 0 END) AS qtd_maus,
    SUM(CASE WHEN inadimplencia = 0 THEN 1 ELSE 0 END) AS qtd_bons,
    COUNT(*) AS total
FROM faixas
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
-- 2 CONTAGEM DE MAUS E BONS POR CATEGORIA
-- =====================================================
--
-- Objetivo:
-- Calcular a quantidade de inadimplentes, adimplentes
-- e o total de clientes em cada categoria.
--
-- Lógica:
-- SUM(CASE WHEN ...) contabiliza separadamente
-- maus e bons pagadores.
--
-- COUNT(*) calcula o total de registros.
--
-- GROUP BY gera uma linha para cada categoria.
--
-- Resultado esperado:
-- Uma tabela contendo:
-- categoria | qtd_maus | qtd_bons | total
--
-- =====================================================

SELECT
    Escolaridade,
    SUM(CASE WHEN inadimplencia = 1 THEN 1 ELSE 0 END) AS qtd_maus,
    SUM(CASE WHEN inadimplencia = 0 THEN 1 ELSE 0 END) AS qtd_bons,
    COUNT(*) AS total
FROM main.inadimplencia_credito
GROUP BY Escolaridade;


-- =====================================================
-- 3 CÁLCULO DOS TOTAIS GERAIS
-- =====================================================
--
-- Objetivo:
-- Calcular o total de inadimplentes e adimplentes
-- existentes na base.
--
-- Lógica:
-- A consulta anterior é transformada em uma CTE
-- chamada resumo.
--
-- SUM() soma a quantidade de maus e bons
-- pagadores de todas as categorias.
--
-- Resultado esperado:
-- total_maus | total_bons
--
-- =====================================================

WITH resumo AS (
    SELECT
        Escolaridade,
        SUM(CASE WHEN inadimplencia = 1 THEN 1 ELSE 0 END) AS qtd_maus,
        SUM(CASE WHEN inadimplencia = 0 THEN 1 ELSE 0 END) AS qtd_bons,
        COUNT(*) AS total
    FROM main.inadimplencia_credito
    GROUP BY Escolaridade
)
SELECT
    SUM(qtd_maus) AS total_maus,
    SUM(qtd_bons) AS total_bons
FROM resumo;

-- =====================================================
-- 4 CÁLCULO DAS PROPORÇÕES E DA TAXA DE INADIMPLÊNCIA
-- =====================================================
--
-- Objetivo:
-- Calcular:
--
-- perc_maus
-- perc_bons
-- taxa_inadimp
--
-- Lógica:
--
-- perc_maus =
-- qtd_maus / total_maus
--
-- perc_bons =
-- qtd_bons / total_bons
--
-- taxa_inadimp =
-- qtd_maus / total
--
-- A multiplicação por 1.0 força o SQL a realizar
-- divisão decimal.
--
-- O CROSS JOIN replica os totais gerais em todas
-- as linhas da consulta.
--
-- Resultado esperado:
--
-- categoria
-- qtd_maus
-- qtd_bons
-- total
-- perc_maus
-- perc_bons
-- taxa_inadimp
--
-- =====================================================

WITH resumo AS (
    SELECT
        Escolaridade,
        SUM(CASE WHEN inadimplencia = 1 THEN 1 ELSE 0 END) AS qtd_maus,
        SUM(CASE WHEN inadimplencia = 0 THEN 1 ELSE 0 END) AS qtd_bons,
        COUNT(*) AS total
    FROM main.inadimplencia_credito
    GROUP BY Escolaridade
),
totais AS (
    SELECT
        SUM(qtd_maus) AS total_maus,
        SUM(qtd_bons) AS total_bons
    FROM resumo
)
SELECT
    r.Escolaridade,
    r.qtd_maus,
    r.qtd_bons,
    r.total,
    r.qtd_maus * 1.0 / t.total_maus AS perc_maus,
    r.qtd_bons * 1.0 / t.total_bons AS perc_bons,
    ROUND(r.qtd_maus * 100.0 / r.total) AS taxa_inadimp
FROM resumo r
CROSS JOIN totais t;

-- =====================================================
-- 5 CÁLCULO DO IV PARCIAL
-- =====================================================
--
-- Objetivo:
-- Calcular a contribuição individual de cada
-- categoria para o Information Value.
--
-- Fórmula:
--
-- (perc_maus - perc_bons)
-- *
-- LN(perc_maus / perc_bons)
--
-- Resultado esperado:
--
-- categoria
-- iv_parcial
--
-- =====================================================

WITH resumo AS (
    SELECT
        Escolaridade,
        SUM(CASE WHEN inadimplencia = 1 THEN 1 ELSE 0 END) AS qtd_maus,
        SUM(CASE WHEN inadimplencia = 0 THEN 1 ELSE 0 END) AS qtd_bons,
        COUNT(*) AS total
    FROM main.inadimplencia_credito
    GROUP BY Escolaridade
),
totais AS (
    SELECT
        SUM(qtd_maus) AS total_maus,
        SUM(qtd_bons) AS total_bons
    FROM resumo
),
proporcoes AS (
    SELECT
        r.Escolaridade,
        r.qtd_maus,
        r.qtd_bons,
        r.total,
        r.qtd_maus * 1.0 / t.total_maus AS perc_maus,
        r.qtd_bons * 1.0 / t.total_bons AS perc_bons,
        ROUND(r.qtd_maus * 100.0 / r.total) AS taxa_inadimp
    FROM resumo r
    CROSS JOIN totais t
)
SELECT
    *,
    (perc_maus - perc_bons) * LN(perc_maus / perc_bons) AS iv_parcial
FROM proporcoes;



-- =====================================================
-- 6 CÁLCULO DO IV TOTAL
-- =====================================================
--
-- Objetivo:
-- Somar os IVs parciais para obter o
-- Information Value total da variável.
--
-- Resultado esperado:
--
-- categoria
-- qtd_maus
-- qtd_bons
-- total
-- perc_maus
-- perc_bons
-- taxa_inadimp
-- iv_parcial
-- iv_total
--
-- =====================================================

WITH resumo AS (
    SELECT
        Escolaridade,
        SUM(CASE WHEN inadimplencia = 1 THEN 1 ELSE 0 END) AS qtd_maus,
        SUM(CASE WHEN inadimplencia = 0 THEN 1 ELSE 0 END) AS qtd_bons,
        COUNT(*) AS total
    FROM main.inadimplencia_credito
    GROUP BY Escolaridade
),
totais AS (
    SELECT
        SUM(qtd_maus) AS total_maus,
        SUM(qtd_bons) AS total_bons
    FROM resumo
),
proporcoes AS (
    SELECT
        r.Escolaridade,
        r.qtd_maus,
        r.qtd_bons,
        r.total,
        r.qtd_maus * 1.0 / t.total_maus AS perc_maus,
        r.qtd_bons * 1.0 / t.total_bons AS perc_bons,
        ROUND(r.qtd_maus * 100.0 / r.total) AS taxa_inadimp
    FROM resumo r
    CROSS JOIN totais t
),
iv_parcial AS (
    SELECT
        *,
        (perc_maus - perc_bons) * LN(perc_maus / perc_bons) AS iv_parcial
    FROM proporcoes
),
iv_total AS (
    SELECT
        SUM(iv_parcial) AS iv_total
    FROM iv_parcial
)
SELECT
    ip.*,
    it.iv_total
FROM iv_parcial ip
CROSS JOIN iv_total it;