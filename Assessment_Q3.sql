-- Get all savings and investment plans
WITH plan_details AS (
	SELECT 
		id as plan_id,
		owner_id, 
    	CASE
			WHEN is_regular_savings = 1 THEN 'Savings'
			WHEN is_a_fund = 1 THEN 'Investment'
		END as type
	FROM plans_plan 
	WHERE is_regular_savings = 1
		or is_a_fund         = 1
), 

-- Get the dates of last transaction of all users
last_transaction as (
	SELECT
		plan_id, 
        MAX(transaction_date) AS last_transaction_date
	FROM savings_savingsaccount
	GROUP BY plan_id
), 

-- Merge the table showing the information about the transactions 
-- with the table showing information about the plans
all_user_last_transc as (
select 
	pd.plan_id,
    pd.owner_id,
    pd.type,
    lt.last_transaction_date,
	DATEDIFF(CURDATE(), lt.last_transaction_date) AS inactivity_days
from plan_details as pd
LEFT JOIN last_transaction as lt on lt.plan_id = pd.plan_id
)

-- Final table but filter out people that have been inactive for more than 365 days
select 
	plan_id,
    owner_id,
    type,
	-- To match the format in the expected output
    DATE_FORMAT(last_transaction_date, '%Y-%m-%d') AS last_transaction_date,
    inactivity_days
from all_user_last_transc
where inactivity_days is not null
and inactivity_days > 365 
        
    