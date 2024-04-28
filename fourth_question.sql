WITH avg_price_payroll AS (
    SELECT 
        year_price_payroll ,
        ROUND(AVG(percentage_change_price), 2) AS avg_price_change ,
        ROUND(AVG(percentage_change_payroll), 2) AS avg_payroll_change
    FROM engeto_2024_03_18.t_petra_jungova_project_sql_primary_final
    GROUP BY year_price_payroll
    HAVING avg_price_change IS NOT NULL
),
price_payroll_growth AS (
    SELECT 
        app.year_price_payroll ,
        (app.avg_price_change - app.avg_payroll_change) AS price_vs_payroll_growth
    FROM avg_price_payroll app
)
SELECT 
    app.year_price_payroll ,
    app.avg_price_change ,
    app.avg_payroll_change ,
    ppg.price_vs_payroll_growth ,
    CASE
        WHEN ppg.price_vs_payroll_growth > 10 THEN 'Ano'
        ELSE 'Ne'
    END AS price_vs_payroll_growth_10_percent
FROM avg_price_payroll app
JOIN price_payroll_growth ppg 
	ON app.year_price_payroll = ppg.year_price_payroll
;