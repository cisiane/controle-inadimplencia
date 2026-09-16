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
),
resumo AS (
	SELECT
    	faixa_etaria,
    	SUM(CASE WHEN inadimplencia = 1 THEN 1 ELSE 0 END) AS qtd_maus,
    	SUM(CASE WHEN inadimplencia = 0 THEN 1 ELSE 0 END) AS qtd_bons,
    	COUNT(*) AS total
	FROM faixas
	GROUP BY faixa_etaria
),
totais AS (
    SELECT
        SUM(qtd_maus) AS total_maus,
        SUM(qtd_bons) AS total_bons
    FROM resumo
),
proporcoes AS (
    SELECT
        r.faixa_etaria,
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