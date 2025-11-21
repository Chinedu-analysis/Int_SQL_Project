-- Customer Segmentation 
WITH customer_ltv AS (
	SELECT 
		customerkey,
		cleaned_name,
		SUM(net_revenue) AS total_ltv
	FROM cohort_analysis 
	GROUP BY customerkey, cleaned_name 
),
customer_segmentations AS (
	SELECT 
		PERCENTILE_CONT(.25) WITHIN GROUP (ORDER BY total_ltv) AS ltv_percentile_25th,
		PERCENTILE_CONT(.75) WITHIN GROUP (ORDER BY total_ltv) AS ltv_percentile_75th
	FROM customer_ltv
),
segment_values AS (
	SELECT 
		c.*,
		CASE WHEN c.total_ltv < cs.ltv_percentile_25th THEN '1 - Low-Value'
			 WHEN c.total_ltv <= cs.ltv_percentile_75th THEN '2 - Mid-Value'
			 ELSE '3 - High-Value'
		END AS customer_segments
	FROM customer_ltv c,
		customer_segmentations cs
)
	
SELECT 
	customer_segments,
	ROUND(SUM(total_ltv)::NUMERIC, 2) AS total_ltv,
	COUNT(customerkey) AS customer_count,
	ROUND(CAST(SUM(total_ltv)/COUNT(customerkey) AS NUMERIC), 2) AS avg_ltv
FROM segment_values
GROUP BY customer_segments
ORDER BY total_ltv DESC
	
	
	