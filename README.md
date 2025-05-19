I used the Common Table Expressions (CTE) approach to solve all the challenges  

# Assessment 1: High-Value Customers with Multiple Products  

To solve this assessment, I broke down the problem into steps  

1.      Get a list of funded\* savings and investment plans  

    * I defined funded plans as plans that have had at least one deposit (i.e. sum of savings_savingsaccount.confirmed_amount for each plan is greater than 0)  

2.      Find the number of funded savings and investment plans owned by each person  

3.      Determine the total amount of deposits made by each owner into all their funded savings and investment plans  

4.      Filter out users with at least one funded savings plans and at least one funded investment plan and then sorted the table by total deposits

**CHALLENGE**: The instructions asked to find customers with “at least one funded savings plan AND one funded investment plan”. I was not sure if I was to find customers with _one or more funded savings plans and only one funded investment plan_, or customers with _one or more funded savings plan and one or more funded investment plan_. I chose to do the later because it made more sense with relation to the topic of finding “high-value customers with multiple products”.

# Assessment 2: Transaction Frequency Analysis

I broke the problem into these steps:

1.      With the __savings\_savingsaccount__ table, calculate the number of transactions performed by each user each month  

2.      Use the result to calculate the average number of monthly transactions performed by each user  

3.      Categorise the users into High, Medium and Low frequency buckets based on the value of average monthly transactions (AMT)  

4.      Count the number of users in each category, and include the category-average of users’ AMT

# Assessment 3: Account Inactivity Alert

To get the customers with inactive accounts, I performed the following computations:

1.      Get a list of all savings and investment plans, alongside the users that own the them

2.      With those users, determine their last transaction dates and number of inactive days

3.      Filter the users with more than 365 inactive days

# Assessment 4: Customer Lifetime Value (CLV) Estimation

To estimate the CLV, these were the operations I performed

1.      Calculate the number of months since the user’s account was created

2.      Calculate the average profit per transaction of each user

3.      Calculate the number of transactions done by each user

4.      Calculate the CLV

5.      Order the resulting table in descending order of CLV

**NOTE**: The profit was given as 0.1% of transaction value. I assume profits are only gotten on deposits and not withdrawals. This was why I used confirmed\_amount as the transaction value