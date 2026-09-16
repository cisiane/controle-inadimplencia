WITH faixas AS (
    SELECT
        CASE
            WHEN Valor_Emprestimo <= 999 THEN 'Até R$ 999'
            WHEN Valor_Emprestimo BETWEEN 1000 AND 1999 THEN 'R$ 1.000 a 1.999'
            WHEN Valor_Emprestimo BETWEEN 2000 AND 2999 THEN 'R$ 2.000 a 2.999'
            WHEN Valor_Emprestimo BETWEEN 3000 AND 3999 THEN 'R$ 3.000 a 3.999'
            WHEN Valor_Emprestimo BETWEEN 4000 AND 4999 THEN 'R$ 4.000 a 4.999'
            ELSE 'R$ 5.000 ou mais' 
        END AS valor_emprestimo,
        inadimplencia
    FROM main.inadimplencia_credito
),
resumo AS (
	SELECT
    	valor_emprestimo,
    	SUM(CASE WHEN inadimplencia = 1 THEN 1 ELSE 0 END) AS qtd_maus,
    	SUM(CASE WHEN inadimplencia = 0 THEN 1 ELSE 0 END) AS qtd_bons,
    	COUNT(*) AS total
	FROM faixas
	GROUP BY valor_emprestimo
),
totais AS (
    SELECT
        SUM(qtd_maus) AS total_maus,
        SUM(qtd_bons) AS total_bons
    FROM resumo
),
proporcoes AS (
    SELECT
        r.valor_emprestimo,
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
        WHEN valor_emprestimo = 'Até R$ 999' THEN 1
        WHEN valor_emprestimo = 'R$ 1.000 a 1.999' THEN 2
        WHEN valor_emprestimo = 'R$ 2.000 a 2.999' THEN 3
        WHEN valor_emprestimo = 'R$ 3.000 a 3.999' THEN 4
        WHEN valor_emprestimo = 'R$ 4.000 a 4.999' THEN 5
        ELSE 6
    END;