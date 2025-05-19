-- Get user details especially the number of months since account creation
WITH customer_details as (
	select 
		id as customer_id,
        CONCAT(first_name, ' ', last_name) AS name,
		TIMESTAMPDIFF(
		  MONTH,
		  created_on,
		  CURDATE()
		) AS tenure_months
        
    from users_customuser
),

-- Calculate the amount of profit - approx 0.1% of transaction amount
transc_wt_profit as (
	select 
		owner_id,
        confirmed_amount * 0.1 / 100 as profit
	from savings_savingsaccount
),

-- Determine the number of transactions and average profit for each user
transc_agg as (
	select 
		owner_id,
        COUNT(*) as total_transactions,
        avg(profit) as avg_profit_per_transaction
	from transc_wt_profit
    GROUP BY owner_id
    
)

-- Results table
select 
	cd.customer_id,
    cd.name, 
    cd.tenure_months,
    ta.total_transactions,
	-- The NULLIF is to catch the possibility of tenure_months being 0

	-- The implication is that we cannot calculate CLV for a user that has
	-- opened an account for less than a month
    (ta.total_transactions / NULLIF(cd.tenure_months,0)) * 
    12 * ta.avg_profit_per_transaction as estimated_clv
    
from customer_details as cd
	RIGHT JOIN transc_agg as ta 
    on ta.owner_id = cd.customer_id

ORDER BY estimated_clv DESC;
		
