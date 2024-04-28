SELECT 
	year_price_payroll ,
	industry_branch ,
	payroll_change 
FROM (
		SELECT 
			year_price_payroll ,
			industry_branch ,
			CASE 
				WHEN avg_payroll > avg_payroll_previous THEN 'Rostoucí'
				WHEN avg_payroll < avg_payroll_previous THEN 'Klesající'
				ELSE 'Stejná'
			END AS payroll_change ,
			avg_payroll ,
			avg_payroll_previous 
		FROM engeto_2024_03_18.t_petra_jungova_project_sql_primary_final
		GROUP BY
			industry_branch ,
			year_price_payroll
	) AS growing_decreasing
GROUP BY
	year_price_payroll ,
	industry_branch ,
	payroll_change
HAVING	payroll_change = 'Klesající'
ORDER BY 
	year_price_payroll ,
	payroll_change DESC 
;


