WITH customer_details AS (
	SELECT 
		id AS owner_id,
        CONCAT(first_name, ' ', last_name) AS name
       
    FROM users_customuser
),

-- Filter out savings and investment plans
savings_and_investment_plans AS (
	SELECT
		owner_id,
		id AS plan_id,
        is_regular_savings,
        is_a_fund
	FROM plans_plan
    WHERE is_regular_savings  = 1
    OR is_a_fund = 1
),


-- Get all transactions for funded savings and investment plans by checking for 
-- plans WHERE the user has deposited before
selected_plans_transac_merge AS (
	SELECT 
		trans.owner_id,
		trans.plan_id, 
        plans.is_regular_savings,
        plans.is_a_fund,
        sum(trans.confirmed_amount) AS total_deposit_in_plan

    FROM savings_savingsaccount AS trans
    JOIN savings_and_investment_plans AS plans
    ON trans.plan_id = plans.plan_id
    GROUP BY trans.owner_id, trans.plan_id
    
    HAVING total_deposit_in_plan > 0
),


-- Get the total number of deposits made by customers
total_deposit_per_owner AS (
	SELECT
		owner_id,
        COUNT(CASE WHEN is_regular_savings = 1  THEN 1 END) AS savings_count,
        COUNT(CASE WHEN is_a_fund = 1 THEN 1 END) AS investment_count,
        sum(total_deposit_in_plan) AS total_deposits
	FROM selected_plans_transac_merge
    GROUP BY owner_id
)

SELECT   
		cd.owner_id,
        cd.name,
        td.savings_count,
        td.investment_count,
        td.total_deposits
FROM total_deposit_per_owner AS td
LEFT JOIN customer_details AS cd
ON td.owner_id = cd.owner_id

-- Filter out customers with multiple funded savings and investment plans
HAVING  td.savings_count >= 1
        AND td.investment_count >= 1

-- Order by deposits
ORDER BY td.total_deposits