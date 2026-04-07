CREATE DATABASE CCDS;

use ccds;

CREATE TABLE cc_detail (
    Client_Num INT,
    Card_Category VARCHAR(20),
    Annual_Fees INT,
    Activation_30_Days INT,
    Customer_Acq_Cost INT,
    Week_Start_Date varchar(20),
    Week_Num VARCHAR(20),
    Qtr VARCHAR(10),
    current_year INT,
    Credit_Limit DECIMAL(10,2),
    Total_Revolving_Bal INT,
    Total_Trans_Amt INT,
    Total_Trans_Ct INT,
    Avg_Utilization_Ratio DECIMAL(10,3),
    Use_Chip VARCHAR(10),
    Exp_Type VARCHAR(50),
    Interest_Earned DECIMAL(10,3),
    Delinquent_Acc VARCHAR(5)
);

CREATE TABLE cust_detail (
    Client_Num INT,
    Customer_Age INT,
    Gender VARCHAR(5),
    Dependent_Count INT,
    Education_Level VARCHAR(50),
    Marital_Status VARCHAR(20),
    State_cd VARCHAR(50),
    Zipcode VARCHAR(20),
    Car_Owner VARCHAR(5),
    House_Owner VARCHAR(5),
    Personal_Loan VARCHAR(5),
    Contact VARCHAR(50),
    Customer_Job VARCHAR(50),
    Income INT,
    Cust_Satisfaction_Score INT
);

SELECT * FROM cc_detail;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/credit_card.csv'
INTO TABLE cc_detail
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

UPDATE cc_detail
SET Week_Start_Date = STR_TO_DATE(Week_Start_Date, '%d-%m-%Y');

ALTER TABLE cc_detail 
MODIFY Week_Start_Date DATE;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/customer.csv'
INTO TABLE cust_detail
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM cc_detail;

SELECT Card_Category, 
       SUM(Total_Trans_Amt) AS Total_Amount,
       SUM(Total_Trans_Ct) AS Total_Transactions
FROM cc_detail
GROUP BY Card_Category;

SELECT Week_Start_Date, 
       SUM(Total_Trans_Amt) AS Total_Amount
FROM cc_detail
GROUP BY Week_Start_Date
ORDER BY Week_Start_Date;

SELECT Client_Num, 
       SUM(Total_Trans_Amt) AS Total_Spending
FROM cc_detail
GROUP BY Client_Num
ORDER BY Total_Spending DESC
LIMIT 10;

SELECT Card_Category, 
       AVG(Credit_Limit) AS Avg_Credit_Limit
FROM cc_detail
GROUP BY Card_Category;


SELECT Gender, COUNT(*) AS Total_Customers
FROM cust_detail
GROUP BY Gender;

SELECT 
    CASE 
        WHEN Income < 30000 THEN 'Low Income'
        WHEN Income BETWEEN 30000 AND 70000 THEN 'Medium Income'
        ELSE 'High Income'
    END AS Income_Group,
    COUNT(*) AS Customer_Count
FROM cust_detail
GROUP BY Income_Group;


SELECT c.Client_Num, 
       Gender, 
       SUM(Total_Trans_Amt) AS Total_Spending
FROM cc_detail c
JOIN cust_detail cu 
ON c.Client_Num = cu.Client_Num
GROUP BY c.Client_Num, Gender
ORDER BY Total_Spending DESC;


