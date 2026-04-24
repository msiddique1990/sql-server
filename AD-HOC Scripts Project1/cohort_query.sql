WITH customer_cohorts
AS (
	SELECT DISTINCT phone_number
		,MIN(convert(DATE, call_date)) first_day
	FROM DataLayer.dbo.CallData
	WHERE call_date BETWEEN '2025-01-01'
			AND '2025-04-10'
	GROUP BY phone_number
	)
	,grouped
AS (
	SELECT c.first_day
		,COUNT(DISTINCT c.phone_number) AS cohort_size
		,COUNT(DISTINCT CASE 
				WHEN DATEDIFF(DAY, c.first_day, convert(DATE, a.call_date)) = 7
					THEN a.phone_number
				END) return_day_7
	FROM customer_cohorts c
	LEFT JOIN DataLayer.dbo.CallData a
		ON a.phone_number = c.phone_number
	GROUP BY c.first_day
	)
SELECT first_day
	,cohort_size
	,return_day_7
	,CAST(return_day_7 AS FLOAT) / NULLIF(cohort_size, 0) Ret_Rate
FROM grouped;