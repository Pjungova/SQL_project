WITH GDP_change AS (
    SELECT
        s.economies_year ,
        s.GDP_previous ,
        s.GDP_actualy ,
        s.percentage_change_GDP
    FROM engeto_2024_03_18.t_petra_jungova_project_SQL_secondary_final s
    WHERE s.country = 'Czech Republic'
),
price_payroll_change AS (
    SELECT
        p.year_price_payroll ,
        p.category ,
        ROUND(AVG(p.percentage_change_price), 2) AS avg_price_change ,
        p.industry_branch ,
        ROUND(AVG(p.percentage_change_payroll), 2) AS avg_payroll_change
    FROM engeto_2024_03_18.t_petra_jungova_project_SQL_primary_final p
    WHERE p.percentage_change_price IS NOT NULL
    GROUP BY p.year_price_payroll
)
SELECT
    ppc.year_price_payroll ,
    ppc.avg_price_change ,
    ppc.avg_payroll_change ,
    gc.percentage_change_GDP
FROM GDP_change gc
JOIN price_payroll_change ppc 
	ON gc.economies_year = ppc.year_price_payroll
ORDER BY ppc.year_price_payroll 
;