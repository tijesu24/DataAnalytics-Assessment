-- Get the number of transactions performed by each user in each month
WITH monthly_counts AS (
  SELECT
    owner_id,
	DATE_FORMAT(transaction_date, '%Y-%m') AS month,
    COUNT(*) AS transc_count
  FROM savings_savingsaccount
  GROUP BY owner_id, month
), 


  -- Average those monthly counts for each user
avg_counts AS (
  SELECT
    owner_id,
    AVG(transc_count) AS avg_transc_per_month
  FROM monthly_counts
  GROUP BY owner_id
), 

-- Categorise the users
avg_with_freq_text AS (
  SELECT
	  owner_id, avg_transc_per_month,
    CASE
      WHEN avg_transc_per_month >= 10 THEN 'High Frequency'
      WHEN avg_transc_per_month BETWEEN 3  AND 9  THEN 'Medium Frequency'
      ELSE 'Low Frequency'
    END AS frequency_category
  FROM avg_counts)
    
-- Summarise the data 
SELECT
	frequency_category,
	COUNT(*) AS customer_count,
	ROUND(AVG(avg_transc_per_month), 1) AS avg_transactions_per_month
FROM avg_with_freq_text
GROUP BY frequency_category
        
    