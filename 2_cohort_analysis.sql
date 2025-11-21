SELECT 
	cohort_year,
	ROUND(SUM(net_revenue):: NUMERIC, 2) AS total_revenue,
	COUNT(DISTINCT customerkey) AS total_customers,
	ROUND(SUM(net_revenue):: NUMERIC /COUNT(DISTINCT customerkey),2) AS customer_revenue
FROM cohort_analysis
WHERE orderdate = first_purchase_date 
GROUP BY cohort_year