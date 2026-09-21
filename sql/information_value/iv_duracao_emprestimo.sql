WITH faixas AS (
    SELECT
        CASE
            WHEN Duracao_Emprestimo <= 12 THEN 'Até 12 meses'
            WHEN Duracao_Emprestimo <= 24 THEN '13-24 meses'
            WHEN Duracao_Emprestimo <= 36 THEN '25-36 meses'
            ELSE 'Acima de 36 meses' 
        END AS duracao_emprestimo,
        inadimplencia
    FROM main.inadimplencia_credito
),
resumo AS (
	SELECT
    	duracao_emprestimo,
    	SUM(CASE WHEN inadimplencia = 1 THEN 1 ELSE 0 END) AS qtd_maus,
    	SUM(CASE WHEN inadimplencia = 0 THEN 1 ELSE 0 END) AS qtd_bons,
    	COUNT(*) AS total
	FROM faixas
	GROUP BY duracao_emprestimo
),
totais AS (
    SELECT
        SUM(qtd_maus) AS total_maus,
        SUM(qtd_bons) AS total_bons
    FROM resumo
),
proporcoes AS (
    SELECT
        r.duracao_emprestimo,
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
CROSS JOIN iv_total it
ORDER BY 
	CASE
        WHEN duracao_emprestimo = 'Até 12 meses' THEN 1
        WHEN duracao_emprestimo = '13-24 meses' THEN 2
        WHEN duracao_emprestimo = '25-36 meses' THEN 3
        ELSE 4
    END;