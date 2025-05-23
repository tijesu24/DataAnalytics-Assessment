-- Get all savings and investment plans
WITH plan_details AS (
	SELECT 
		id AS plan_id,
		owner_id, 
    	CASE
			WHEN is_regular_savings = 1 THEN 'Savings'
			WHEN is_a_fund = 1 THEN 'Investment'
		END AS type
	FROM plans_plan 
	WHERE is_regular_savings = 1
		OR is_a_fund         = 1
), 

-- Get the dates of last transaction of all users
last_transaction AS (
	SELECT
		plan_id, 
        MAX(transaction_date) AS last_transaction_date
	FROM savings_savingsaccount
	GROUP BY plan_id
), 

-- Merge the table showing the information about the transactions 
-- with the table showing information about the plans
all_user_last_transc AS (
SELECT 
	pd.plan_id,
    pd.owner_id,
    pd.type,
    lt.last_transaction_date,
	DATEDIFF(CURDATE(), lt.last_transaction_date) AS inactivity_days
FROM plan_details AS pd
LEFT JOIN last_transaction AS lt ON lt.plan_id = pd.plan_id
)

-- Final table but filter out people that have been inactive for more than 365 days
SELECT 
	plan_id,
    owner_id,
    type,
	-- To match the format in the expected output
    DATE_FORMAT(last_transaction_date, '%Y-%m-%d') AS last_transaction_date,
    inactivity_days
FROM all_user_last_transc
WHERE inactivity_days IS NOT NULL
AND inactivity_days > 365 
        
    