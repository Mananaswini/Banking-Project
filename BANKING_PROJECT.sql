USE ASSGN3; 

--BANKING PROJECT
SELECT * FROM Account_Perfrmance_Data;
SELECT * FROM Employer_details;

SELECT 
A.ACCOUNT_NUMBER,
A.PORTFOLIO,
A.SSN,
A.[Phone No#], 
A.[Place Name],
A.County,
A.City,
A.State,
A.Zip,
A.Region,
A.[Account Open Date],
A.Last_payment_date,
A.Loan_amount,
A.loan_status,
A.Origination_fico_score,
A.Current_fico_score,
A.Current_outstanding,
B.CUSTOMER_NUMBER,
B.COMPANY_NAME,
B.PRIMARY_INDUSTRY,
B.[REVENUES (IN MILLIONS DOLLAR)],
B.CATEGORY
FROM Account_Perfrmance_Data AS A
LEFT JOIN
Employer_details AS B
ON 
A.ACCOUNT_NUMBER=B.ACCOUNT_NUMBER;

--Q2 Get Month on Booking (MOB) from Account Open Date to Current Date
SELECT 
A.ACCOUNT_NUMBER,
A.PORTFOLIO,
A.SSN,
A.[Phone No#], 
A.[Place Name],
A.County,
A.City,
A.State,
A.Zip,
A.Region,
A.[Account Open Date],
A.Last_payment_date,
DATEDIFF(MONTH,A.[Account Open Date],GETDATE()) AS MONTH_ON_BOOKING,	
A.Loan_amount,
A.loan_status,
A.Origination_fico_score,
A.Current_fico_score,
A.Current_outstanding,
B.CUSTOMER_NUMBER,
B.COMPANY_NAME,
B.PRIMARY_INDUSTRY,
B.[REVENUES (IN MILLIONS DOLLAR)],
B.CATEGORY
FROM Account_Perfrmance_Data AS A
LEFT JOIN
Employer_details AS B
ON 
A.ACCOUNT_NUMBER=B.ACCOUNT_NUMBER;

--Q3 Get Delinquency days (Loan Defaulted by number of days)	
--if loan_status="Non-Default" then Delienquncy days=0
--Else Delienquncy days=datedif(last_payment_date,today(),"d")
SELECT 
A.ACCOUNT_NUMBER,
A.PORTFOLIO,
A.SSN,
A.[Phone No#], 
A.[Place Name],
A.County,
A.City,
A.State,
A.Zip,
A.Region,
A.[Account Open Date],
A.Last_payment_date,
DATEDIFF(MONTH,A.[Account Open Date],GETDATE()) AS MONTH_ON_BOOKING,	
A.Loan_amount,
A.loan_status,
CASE
	WHEN A.loan_status='Non-Default' THEN '0'
	Else DATEDIFF(DAY,A.last_payment_date,GETDATE())
END AS Delinquencydays,
A.Origination_fico_score,
A.Current_fico_score,
A.Current_outstanding,
B.CUSTOMER_NUMBER,
B.COMPANY_NAME,
B.PRIMARY_INDUSTRY,
B.[REVENUES (IN MILLIONS DOLLAR)],
B.CATEGORY
INTO EMP_ACCOUNT_PERFORMANCE_DETAILS
FROM Account_Perfrmance_Data AS A
LEFT JOIN
Employer_details AS B
ON 
A.ACCOUNT_NUMBER=B.ACCOUNT_NUMBER;


--Q4	Create Delinquency Bucket Days	Delinqency Days=0	Current
		-->0 and <=30	X Days
		-->30 and <=60	X+1 Days
		-->60 and <=90	X+2 Days
		-->90 and <=120	X+3 Days
		-->120 and <=150	X+4 Days
		-->150 and <=180	X+5 Days
		-->180	Charge Off
SELECT 
ACCOUNT_NUMBER,
PORTFOLIO,
SSN,
[Phone No#], 
[Place Name],
County,
City,
State,
Zip,
Region,
[Account Open Date],
Last_payment_date,
MONTH_ON_BOOKING,	
Loan_amount,
loan_status,
Delinquencydays,
CASE
	WHEN Delinquencydays=0 THEN 'CURRENT'
	WHEN Delinquencydays >0 and Delinquencydays<=30	THEN 'X Days'
	WHEN Delinquencydays >30 and Delinquencydays <=60 THEN 'X+1 Days'
	WHEN Delinquencydays >60 and Delinquencydays<=90	THEN 'X+2 Days'
	WHEN Delinquencydays >90 and Delinquencydays<=120 THEN 'X+3 Days'
	WHEN Delinquencydays >120 and Delinquencydays<=150 THEN 'X+4 Days'
	WHEN Delinquencydays >150 and Delinquencydays <=180	THEN 'X+5 Days'
	WHEN Delinquencydays >180 THEN 'Charge Off'
  ELSE '0'
END Delinquencydays_BUCKET,
Origination_fico_score,
Current_fico_score,
Current_outstanding,
CUSTOMER_NUMBER,
COMPANY_NAME,
PRIMARY_INDUSTRY,
[REVENUES (IN MILLIONS DOLLAR)],
CATEGORY
FROM EMP_ACCOUNT_PERFORMANCE_DETAILS;


--Q5	Create Origination vs Currect Fico score variance in %	
	--If Its negative value use conditional formatting to highlight that	
SELECT 
ACCOUNT_NUMBER,
PORTFOLIO,
SSN,
[Phone No#], 
[Place Name],
County,
City,
State,
Zip,
Region,
[Account Open Date],
Last_payment_date,
MONTH_ON_BOOKING,	
Loan_amount,
loan_status,
Delinquencydays,
CASE
	WHEN Delinquencydays=0 THEN 'CURRENT'
	WHEN Delinquencydays >0 and Delinquencydays<=30	THEN 'X Days'
	WHEN Delinquencydays >30 and Delinquencydays <=60 THEN 'X+1 Days'
	WHEN Delinquencydays >60 and Delinquencydays<=90	THEN 'X+2 Days'
	WHEN Delinquencydays >90 and Delinquencydays<=120 THEN 'X+3 Days'
	WHEN Delinquencydays >120 and Delinquencydays<=150 THEN 'X+4 Days'
	WHEN Delinquencydays >150 and Delinquencydays <=180	THEN 'X+5 Days'
	WHEN Delinquencydays >180 THEN 'Charge Off'
	ELSE '0'
END Delinquencydays_BUCKET,
Origination_fico_score,
Current_fico_score,
(Origination_fico_score-Current_fico_score)/Origination_fico_score AS SCORE_VARIANCE, 
Current_outstanding,
CUSTOMER_NUMBER,
COMPANY_NAME,
PRIMARY_INDUSTRY,
[REVENUES (IN MILLIONS DOLLAR)],
CATEGORY
FROM EMP_ACCOUNT_PERFORMANCE_DETAILS;

--Q6	Current Outstanding Balance in % Current_outstanding/Loan_amount
SELECT 
ACCOUNT_NUMBER,
PORTFOLIO,
SSN,
[Phone No#], 
[Place Name],
County,
City,
State,
Zip,
Region,
[Account Open Date],
Last_payment_date,
MONTH_ON_BOOKING,	
Loan_amount,
loan_status,
Delinquencydays,
CASE
	WHEN Delinquencydays=0 THEN 'CURRENT'
	WHEN Delinquencydays >0 and Delinquencydays<=30	THEN 'X Days'
	WHEN Delinquencydays >30 and Delinquencydays <=60 THEN 'X+1 Days'
	WHEN Delinquencydays >60 and Delinquencydays<=90 THEN 'X+2 Days'
	WHEN Delinquencydays >90 and Delinquencydays<=120 THEN 'X+3 Days'
	WHEN Delinquencydays >120 and Delinquencydays<=150 THEN 'X+4 Days'
	WHEN Delinquencydays >150 and Delinquencydays <=180	THEN 'X+5 Days'
	WHEN Delinquencydays >180 THEN 'Charge Off'
	ELSE '0'
END Delinquencydays_BUCKET,
Origination_fico_score,
Current_fico_score,
(Origination_fico_score-Current_fico_score)/Origination_fico_score AS SCORE_VARIANCE, 
Current_outstanding,
(Current_outstanding/Loan_amount) AS Outstanding_BALANCE,
CUSTOMER_NUMBER,
COMPANY_NAME,
PRIMARY_INDUSTRY,
[REVENUES (IN MILLIONS DOLLAR)],
CATEGORY
INTO EMP_ACCOUNT_PERFORMANCE_DETAILS_V1
FROM EMP_ACCOUNT_PERFORMANCE_DETAILS;


--Q7	Develop Risk Segment
SELECT 
ACCOUNT_NUMBER,
PORTFOLIO,
SSN,
[Phone No#], 
[Place Name],
County,
City,
State,
Zip,
Region,
[Account Open Date],
Last_payment_date,
MONTH_ON_BOOKING,	
Loan_amount,
loan_status,
Delinquencydays,
Delinquencydays_BUCKET,
Origination_fico_score,
Current_fico_score,
SCORE_VARIANCE, 
Current_outstanding,
Outstanding_BALANCE,
CASE
 WHEN DelinquencyDays <=60 AND Score_Variance < 0 AND Outstanding_BALANCE >= 0.5 THEN 'HIGH RISK-1'
 WHEN DelinquencyDays >60 AND Score_Variance < 0 AND Outstanding_BALANCE >= 0.5 THEN 'HIGH RISK-2'
 WHEN DelinquencyDays <=60 AND Score_Variance < 0 AND Outstanding_BALANCE >0.3 AND Outstanding_BALANCE < 0.5 THEN 'HIGH RISK-3'
 WHEN DelinquencyDays >60 AND Score_Variance < 0 AND Outstanding_BALANCE >0.3 AND Outstanding_BALANCE < 0.5 THEN 'HIGH RISK-4'
 WHEN DelinquencyDays <=60 AND Score_Variance < 0 AND Outstanding_BALANCE >0.1 AND Outstanding_BALANCE <=0.3  THEN 'MID RISK-1'
 WHEN DelinquencyDays >60 AND Score_Variance < 0 AND Outstanding_BALANCE>0.1 AND Outstanding_BALANCE <=0.3 THEN 'MID RISK-2'
 ELSE 'Low_risk'
END AS RISK_SEGMENT,
CUSTOMER_NUMBER,
COMPANY_NAME,
PRIMARY_INDUSTRY,
[REVENUES (IN MILLIONS DOLLAR)],
CATEGORY
INTO EMP_ACCOUNT_PERFORMANCE_DETAILS_V2
FROM EMP_ACCOUNT_PERFORMANCE_DETAILS_V1;


SELECT * FROM EMP_ACCOUNT_PERFORMANCE_DETAILS_V2;

--Q8	Create Summary Report for all different portfolios	
--Good Loan Per Account	Outstanding Balance of non-default account/# of non default account
--Bad Loan Per Account	Outstanding Balance of default account/# of default account
SELECT
    PORTFOLIO,
    SUM(CASE WHEN LOAN_STATUS = 'Non-Default' THEN CURRENT_OUTSTANDING ELSE 0 END) / COUNT(CASE WHEN LOAN_STATUS = 'Non-Default' THEN 1 END) AS Good_Loan_Per_Account,
    SUM(CASE WHEN LOAN_STATUS = 'Default' THEN CURRENT_OUTSTANDING ELSE 0 END) / COUNT(CASE WHEN LOAN_STATUS = 'Default' THEN 1 END) AS Bad_Loan_Per_Account
FROM EMP_ACCOUNT_PERFORMANCE_DETAILS_V2
GROUP BY PORTFOLIO;


--Q9	Create Summary Report for all different portfolios
SELECT
PORTFOLIO,
DELINQUENCYDAYS_BUCKET,
COUNT(ACCOUNT_NUMBER) AS COUNT_OF_ACCOUNT,
SUM(CURRENT_OUTSTANDING) AS TOTAL_OUTSTANDING_BALANCE
FROM EMP_ACCOUNT_PERFORMANCE_DETAILS_V2
GROUP BY PORTFOLIO,DELINQUENCYDAYS_BUCKET;

--Q10	Create Summary Report for all different portfolios


--Q11	Portfolio Level each risk segment wise # of accounts vs Total Balance $
SELECT
PORTFOLIO,
RISK_SEGMENT,
COUNT(ACCOUNT_NUMBER) AS COUNT_OF_ACCOUNT,
SUM(CURRENT_OUTSTANDING) AS TOTAL_OUTSTANDING_BALANCE
FROM EMP_ACCOUNT_PERFORMANCE_DETAILS_V2
GROUP BY PORTFOLIO,RISK_SEGMENT;

--Q12	Portfolio Level each risk segment wise # of accounts vs Total Balance $
