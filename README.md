# Banking-Project
Overview: The project is based on banking data, involving two key tables: Account_Perfrmance_Data and Employer_details. My goal was to analyze account performance and employer data to assess credit risk and monitor customer accounts.

Understanding the Database: I used a database named ASSGN3. The Account_Perfrmance_Data table holds customer details like account numbers, loan amounts, FICO scores, and loan statuses. The Employer_details table contains information about the customer’s employer, including company name, industry, and revenue.

Query Highlights:

I performed a LEFT JOIN between Account_Perfrmance_Data and Employer_details based on ACCOUNT_NUMBER, allowing me to link customer accounts with their employer details. This helps in understanding the financial health of customers based on their employment and company details.
One of my key calculations was to compute the Months on Booking (MOB), which calculates the time (in months) from when an account was opened until the current date. This helps monitor how long customers have been with the bank and track payment performance over time.
Purpose: The project was focused on analyzing and monitoring the risk levels of accounts by combining customer and employer data. This kind of analysis could help in detecting risky accounts early and improve strategies for managing credit portfolios.
