-- Projeto: Controle da Inadimplência em Operações de Crédito
-- Entendimento dos Dados
-- Tabela analisada: inadimplencia_credito

/* =====================================================
   2.1 Estrutura da base
   ===================================================== */

-- Verificar a estrutura da tabela, nomes das colunas e tipos de dados
PRAGMA	table_info(main.inadimplencia_credito);

-- Confirmar a quantidade de registros da base
SELECT COUNT(*) AS total_registros
FROM main.inadimplencia_credito;

/* =====================================================
   2.2 Completude da base
   ===================================================== */

-- Verificar valores nulos e campos textuais vazios em todas as variáveis
-- Nas colunas categóricas, TRIM() remove espaços em branco nas extremidades
SELECT 'Idade' AS variavel,
       SUM(CASE WHEN Idade IS NULL THEN 1 ELSE 0 END) AS qtd_ausentes
FROM inadimplencia_credito

UNION ALL

SELECT 'Sexo',
       SUM(CASE WHEN Sexo IS NULL OR TRIM(Sexo) = '' THEN 1 ELSE 0 END)
FROM inadimplencia_credito

UNION ALL

SELECT 'Escolaridade',
       SUM(CASE WHEN Escolaridade IS NULL OR TRIM(Escolaridade) = '' THEN 1 ELSE 0 END)
FROM inadimplencia_credito

UNION ALL

SELECT 'Tipo_Moradia',
       SUM(CASE WHEN Tipo_Moradia IS NULL OR TRIM(Tipo_Moradia) = '' THEN 1 ELSE 0 END)
FROM inadimplencia_credito

UNION ALL

SELECT 'Saldo_Investimento',
       SUM(CASE WHEN Saldo_Investimento IS NULL OR TRIM(Saldo_Investimento) = '' THEN 1 ELSE 0 END)
FROM inadimplencia_credito

UNION ALL

SELECT 'Saldo_Conta_Corrente',
       SUM(CASE WHEN Saldo_Conta_Corrente IS NULL OR TRIM(Saldo_Conta_Corrente) = '' THEN 1 ELSE 0 END)
FROM inadimplencia_credito

UNION ALL

SELECT 'Valor_Emprestimo',
       SUM(CASE WHEN Valor_Emprestimo IS NULL THEN 1 ELSE 0 END)
FROM inadimplencia_credito

UNION ALL

SELECT 'Duracao_Emprestimo',
       SUM(CASE WHEN Duracao_Emprestimo IS NULL THEN 1 ELSE 0 END)
FROM inadimplencia_credito

UNION ALL

SELECT 'Inadimplencia',
       SUM(CASE WHEN Inadimplencia IS NULL THEN 1 ELSE 0 END)
FROM inadimplencia_credito;

/* =====================================================
   2.3 Verificação de duplicidade exata dos registros
   ===================================================== */

-- Como a base não possui identificador único do cliente,
-- esta consulta verifica duplicidade exata das linhas,
-- considerando a combinação de todas as variáveis disponíveis
SELECT
    Idade,
    Sexo,
    Escolaridade,
    Tipo_Moradia,
    Saldo_Investimento,
    Saldo_Conta_Corrente,
    Valor_Emprestimo,
    Duracao_Emprestimo,
    Inadimplencia,
    COUNT(*) AS qtd
FROM inadimplencia_credito
GROUP BY
    Idade,
    Sexo,
    Escolaridade,
    Tipo_Moradia,
    Saldo_Investimento,
    Saldo_Conta_Corrente,
    Valor_Emprestimo,
    Duracao_Emprestimo,
    Inadimplencia
HAVING COUNT(*) > 1;

/* =====================================================
   2.4 Verificação de consistência das variáveis
   ===================================================== */

-- Idade: verificar se há valores fora de um intervalo plausível
SELECT COUNT(*) AS idades_fora_do_intervalo
FROM inadimplencia_credito
WHERE Idade < 18 OR Idade > 100;

-- Sexo: verificar categorias existentes
SELECT Sexo, COUNT(*) AS quantidade
FROM inadimplencia_credito
GROUP BY Sexo
ORDER BY quantidade DESC;

-- Escolaridade: verificar categorias existentes
SELECT Escolaridade, COUNT(*) AS quantidade
FROM inadimplencia_credito
GROUP BY Escolaridade
ORDER BY quantidade DESC;

-- Tipo_Moradia: verificar categorias existentes
SELECT Tipo_Moradia, COUNT(*) AS quantidade
FROM inadimplencia_credito
GROUP BY Tipo_Moradia
ORDER BY quantidade DESC;

-- Saldo_Investimento: verificar categorias existentes
-- Objetivo adicional: confirmar se a variável representa classes/faixas,
-- justificando seu armazenamento como VARCHAR
SELECT Saldo_Investimento, COUNT(*) AS quantidade
FROM inadimplencia_credito
GROUP BY Saldo_Investimento
ORDER BY quantidade DESC;

-- Saldo_Conta_Corrente: verificar categorias existentes
-- Objetivo adicional: confirmar se a variável representa classes/faixas,
-- justificando seu armazenamento como VARCHAR
SELECT Saldo_Conta_Corrente, COUNT(*) AS quantidade
FROM inadimplencia_credito
GROUP BY Saldo_Conta_Corrente
ORDER BY quantidade DESC;

-- Valor_Emprestimo: verificar valores incompatíveis com a natureza da variável
SELECT COUNT(*) AS valores_invalidos_valor_emprestimo
FROM inadimplencia_credito
WHERE Valor_Emprestimo <= 0;

-- Duracao_Emprestimo: verificar valores incompatíveis com a natureza da variável
SELECT COUNT(*) AS valores_invalidos_duracao_emprestimo
FROM inadimplencia_credito
WHERE Duracao_Emprestimo <= 0;

-- Inadimplencia: verificar se a variável binária contém apenas 0 e 1
SELECT Inadimplencia, COUNT(*) AS quantidade
FROM main.inadimplencia_credito
GROUP BY Inadimplencia;
