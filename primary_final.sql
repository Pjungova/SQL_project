CREATE TABLE t_petra_jungova_project_sql_primary_final AS
	WITH previous_price AS (
		SELECT 
        	cp.category_code ,
        	YEAR(cp.date_from) + 1 AS price_year_previous ,
        	ROUND(AVG(cp.value), 2) AS avg_price_previous
   		FROM czechia_price cp
    	GROUP BY
       		cp.category_code ,
       		YEAR(cp.date_from)
	),
	actualy_price AS (
		SELECT 
      		cp.category_code ,
        	YEAR(cp.date_from) AS price_year ,
        	ROUND(AVG(cp.value), 2) AS avg_price
    	FROM czechia_price cp
    	GROUP BY
        	cp.category_code ,
        	YEAR(cp.date_from)
	) ,
	previous_payroll AS(
		SELECT 
        	cpp.payroll_year + 1 AS payroll_year_previous ,
        	ROUND(AVG(cpp.value), 2) AS avg_payroll_previous ,
        	cpp.industry_branch_code
    	FROM czechia_payroll cpp
    	WHERE cpp.value_type_code = '5958'
    	GROUP BY
      		cpp.industry_branch_code ,
    		cpp.payroll_year
	) ,
	actualy_payroll AS (
		SELECT 
			cpp.value_type_code ,
			cpp.unit_code ,
			cpp.industry_branch_code ,
			cpp.payroll_year,
			ROUND(AVG(cpp.value), 2) AS avg_payroll
    	FROM czechia_payroll cpp
    	WHERE 
			cpp.value_type_code = '5958'
			AND cpp.industry_branch_code IS NOT NULL
    	GROUP BY
        	cpp.industry_branch_code ,
        	cpp.payroll_year
	)
	SELECT 
		ap.price_year AS year_price_payroll ,	
		cpc.name AS category,
		cpc.price_value ,
		cpc.price_unit ,
		ap.avg_price,
		pp.avg_price_previous,
		ROUND((((ap.avg_price - pp.avg_price_previous) / pp.avg_price_previous) * 100), 2) AS percentage_change_price ,
		cpib.name AS industry_branch ,
		apa.avg_payroll,
		ppa.avg_payroll_previous,
		ROUND((((apa.avg_payroll - ppa.avg_payroll_previous) / ppa.avg_payroll_previous) * 100), 2) AS percentage_change_payroll
	FROM actualy_price ap
	LEFT JOIN previous_price pp 
		ON ap.price_year = pp.price_year_previous AND 
		ap.category_code = pp.category_code
	LEFT JOIN actualy_payroll apa 
		ON ap.price_year = apa.payroll_year
	LEFT JOIN previous_payroll ppa 
		ON apa.payroll_year = ppa.payroll_year_previous AND 
		apa.industry_branch_code = ppa.industry_branch_code
    LEFT JOIN czechia_price_category cpc 
    	ON ap.category_code = cpc.code
	LEFT JOIN czechia_payroll_industry_branch cpib 
		ON apa.industry_branch_code = cpib.code
;
 	
