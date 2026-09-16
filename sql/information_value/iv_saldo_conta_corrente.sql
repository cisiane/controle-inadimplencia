WITH resumo AS (
    SELECT
        Saldo_Conta_Corrente,
        SUM(CASE WHEN inadimplencia = 1 THEN 1 ELSE 0 END) AS qtd_maus,
        SUM(CASE WHEN inadimplencia = 0 THEN 1 ELSE 0 END) AS qtd_bons,
        COUNT(*) AS total
    FROM main.inadimplencia_credito
    GROUP BY Saldo_Conta_Corrente
),
totais AS (
    SELECT
        SUM(qtd_maus) AS total_maus,
        SUM(qtd_bons) AS total_bons
    FROM resumo
),
proporcoes AS (
    SELECT
        r.Saldo_Conta_Corrente,
        r.qtd_maus,
        r.qtd_bons,
        r.total,
        r.qtd_maus * 1.0 / t.total_maus AS perc_maus,
        r.qtd_bons * 1.0 / t.total_bons AS perc_bons,
        ROUND(r.qtd_maus * 100.0 / r.total) AS taxa_inadimp
    FROM resumo r CROSS JOIN totais t
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
    it.iv_total AS iv_total
FROM iv_parcial ip 
CROSS JOIN iv_total it
ORDER BY
	CASE
        WHEN Saldo_Conta_Corrente = 'Sem conta' THEN 1
        WHEN Saldo_Conta_Corrente = 'Pouco' THEN 2
        WHEN Saldo_Conta_Corrente = 'Moderado' THEN 3
        WHEN Saldo_Conta_Corrente = 'Alto' THEN 4
    END;