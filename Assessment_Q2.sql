
-- Get the number of transactions performed by each user in each month
WITH monthly_counts AS (
  SELECT
    owner_id,
	DATE_FORMAT(transaction_date, '%Y-%m') AS month,
    COUNT(*) AS txn_count
  FROM savings_savingsaccount
  GROUP BY owner_id, month
), 


  -- Average those monthly counts for each user
avg_counts AS (
  SELECT
    owner_id,
    AVG(txn_count) AS avg_txn_per_month
  FROM monthly_counts
  GROUP BY owner_id
), 

-- Categorise the users
avg_with_freq_text AS (
  SELECT
	  owner_id, avg_txn_per_month,
    CASE
      WHEN avg_txn_per_month >= 10 THEN 'High Frequency'
      WHEN avg_txn_per_month BETWEEN 3  AND 9  THEN 'Medium Frequency'
      ELSE 'Low Frequency'
    END AS frequency_segment
  from avg_counts)
    
-- Summarise the data 
SELECT
	frequency_segment,
	COUNT(*) AS customer_count,
	ROUND(AVG(avg_txn_per_month), 1) AS avg_transactions_per_month
from avg_with_freq_text
GROUP BY frequency_segment
        
    