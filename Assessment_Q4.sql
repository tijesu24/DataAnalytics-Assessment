-- Get user details especially the number of months since account creation
WITH customer_details AS (
	SELECT 
		id AS customer_id,
        CONCAT(first_name, ' ', last_name) AS name,
		TIMESTAMPDIFF(
		  MONTH,
		  created_on,
		  CURDATE()
		) AS tenure_months
        
    FROM users_customuser
),

-- Calculate the amount of profit - approx 0.1% of transaction amount
transc_wt_profit AS (
	SELECT 
		owner_id,
        confirmed_amount * 0.1 / 100 AS profit
	FROM savings_savingsaccount
),

-- Determine the number of transactions and average profit for each user
transc_agg AS (
	SELECT 
		owner_id,
        COUNT(*) AS total_transactions,
        avg(profit) AS avg_profit_per_transaction
	FROM transc_wt_profit
    GROUP BY owner_id
    
)

-- Results table
SELECT 
	cd.customer_id,
    cd.name, 
    cd.tenure_months,
    ta.total_transactions,
	-- The NULLIF is to catch the possibility of tenure_months being 0

	-- The implication is that we cannot calculate CLV for a user that has
	-- opened an account for less than a month
    (ta.total_transactions / NULLIF(cd.tenure_months,0)) * 
    12 * ta.avg_profit_per_transaction AS estimated_clv
    
FROM customer_details AS cd
	RIGHT JOIN transc_agg AS ta 
    ON ta.owner_id = cd.customer_id

-- Order from highest clv to lowest
ORDER BY estimated_clv DESC;
		
