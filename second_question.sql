WITH first_last_prices AS (
    SELECT 
        category ,
        industry_branch ,
        MIN(year_price_payroll) AS first_year ,
        MAX(year_price_payroll) AS last_year
    FROM t_petra_jungova_project_SQL_primary_final
    GROUP BY 
    		category ,
    		industry_branch
)
SELECT 
    l.industry_branch ,
    f.avg_payroll AS payroll_first_year ,
    l.avg_payroll AS payroll_last_year , 
	fl.category ,
    f.avg_price AS price_first_year ,
    l.avg_price AS price_last_year ,
    ROUND((f.avg_payroll / f.avg_price), 2) AS quantity_first_year ,
    ROUND((l.avg_payroll / l.avg_price), 2) AS quantity_last_year
FROM 
    first_last_prices fl
LEFT JOIN t_petra_jungova_project_SQL_primary_final f 
	ON fl.category = f.category AND 
	fl.first_year = f.year_price_payroll AND 
	fl.industry_branch = f.industry_branch
LEFT JOIN t_petra_jungova_project_SQL_primary_final l 
	ON fl.category = l.category AND 
	fl.last_year = l.year_price_payroll AND 
	fl.industry_branch = l.industry_branch
WHERE 
    f.category LIKE '%chléb%' OR 
    f.category LIKE '%mléko%'
ORDER BY industry_branch
;