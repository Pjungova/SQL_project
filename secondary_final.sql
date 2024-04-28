CREATE TABLE t_petra_jungova_project_SQL_secondary_final AS       
	WITH previous_economies AS (
		SELECT 
        	e.country ,
        	e.year + 1 AS economies_year_previous ,
        	e.GDP
    	FROM economies e
    	WHERE GDP IS NOT NULL 
    	GROUP BY
        	e.country ,
        	e.year
	)
	SELECT 
		ae.country ,
		ae.year AS economies_year ,
		ROUND(ae.GDP, 2) AS GDP_actualy ,
		ROUND(pe.GDP, 2) AS GDP_previous ,
		ROUND((((ae.GDP - pe.GDP) / pe.GDP) * 100), 2) AS percentage_change_GDP
	FROM 
    	economies ae
	JOIN previous_economies pe 
		ON ae.year = pe.economies_year_previous AND 
		ae.country = pe.country
 	;
