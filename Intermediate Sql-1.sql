-- APAN 5310: SQL & RELATIONAL DATABASES

   -------------------------------------------------------------------------
   --                                                                     --
   --                            HONOR CODE                               --
   --                                                                     --
   --  I affirm that I will not plagiarize, use unauthorized materials,   --
   --  or give or receive illegitimate help on assignments, papers, or    --
   --  examinations. I will also uphold equity and honesty in the         --
   --  evaluation of my work and the work of others. I do so to sustain   --
   --  a community built around this Code of Honor.                       --
   --                                                                     --
   -------------------------------------------------------------------------

/*
 *    You are responsible for submitting your own, original work. We are
 *    obligated to report incidents of academic dishonesty as per the
 *    Student Conduct and Community Standards.
 */


-------------------------------------------------------------------------------
-------------------------------------------------------------------------------


-- HOMEWORK ASSIGNMENT 4

/*
 *  NOTES:
 *
 *    - For all SQL statements, enter your answers between the START and END tags 
 *      for each question, as shown in the example. Do not alter this template 
 *      file in any other way other than adding your answers. Do not delete the
 *      START/END tags. The .sql file you submit will be validated before
 *      grading and will not be graded if it fails validation due to any
 *      alteration of the commented sections.
 *
 *    - Our course is using SQLite which should be installed locally on your machine. 
 *      We will grade your assignments in SQLite. You risk losing points
 *      if you prepare your SQL queries for a different database system
 *      (PostgreSQL, MySQL, MS SQL Server, Oracle, etc).
 *
 *    - The source database 'bank' is provided to you. If you modify the data
 *      in any way, your results might differ from the correct results. You can  
 *      always add a fresh version of the original database from Canvas if needed.
 *
 *    - It is advised to format your queries using the 'Format SQL'
 *      feature in SQLiteStudio to allow for better readability of the code.
 *
 *    - Make sure you test each one of your answers. If a query returns an
 *      error it will earn no points.
 *
 *    - Each question specifies the exact columns requested in the output. Any more
 *      or any less columns will result in less than full score for the question.
 *
 *    - You must use JOINS to solve each question. Lack of JOINS in your code
 *      will earn you zero points for that question.
 *
 */

-------------------------------------------------------------------------------

/*
 * EXAMPLE
 * -------
 *
 * Provide the SQL statement that returns all columns and rows from
 * a table named "tbl1".
 *
 */

-- START EXAMPLE --

SELECT * FROM tbl1;

-- END EXAMPLE --

-------------------------------------------------------------------------------

/*
 * The bank data dictionary
 * ------------------------
 *
 * The 'bank' database has been structured to represent a normalized relational
 * database comprised of three tables containing data for a fictitious
 * consumer bank:
 *
 *   1. custs - a table of customers of our bank
 *        a. cust_id - the unique customer number of each customer
 *        b. first_name - the first name of the customer
 *        c. last_name - the last name of the customer
 *        d. street - the street address of the customer
 *        e. city - the city of residence of the customer
 *        f. state - the US state (plus DC) of residence of the customer
 *        g. zip - the five digit zip code of residence of the customer
 *        h. dob - the date of birth of the customer (yyyy-mm-dd)
 *   2. accts - a table of bank accounts owned by our customers
 *        a. acct_id - the unique account number for each account
 *        b. acct_type - the account type (S = savings, C = checking, M = money mkt)
 *        c. cust_id - the customer number of customer who owns the account
 *   3. txns - a table of transactions performed by our customers
 *        a. txn_id - a unique identifier of each transaction
 *        b. txn_type - the type of transaction (D = deposit, W = withdrawal)
 *        c. txn_dt - the date and time of transaction (yyyy-mm-dd HH:MM)
 *        d. amt - the dollar amount of the transaction; withdrawals are shown as
 *                 positive amounts but should be deducted from any balance calcs
 *        e. acct_id - the account number to which the amout was added or
 *                     from which the amount was subtracted
 *
 */

-------------------------------------------------------------------------------

/*
 * QUESTION 1 (25 points)
 * --------------------
 *
 * - Provide the SQL statement that lists all the customers living in the state
 *   of New York (NY) with more than one account.
 * - Order alphabetically by city.
 * - Label the columns as 'Full_Name' (concatenate first and last name with
 *   a space in between), 'City', 'DOB'
 *
 */

-- START ANSWER 1 --

SELECT (first_name || ' ' || last_name) AS Full_Name,
       City,
       DOB
  FROM (
           SELECT cust_id,
                  count(cust_id) AS count
             FROM accts
            GROUP BY cust_id
           HAVING count > 1
            ORDER BY cust_id
       )
       a
       JOIN
       custs c ON a.cust_id = c.cust_id
 WHERE c.state = 'NY'
 ORDER BY c.city;

-- END ANSWER 1 --

-------------------------------------------------------------------------------

/*
 * QUESTION 2 (25 points)
 * --------------------
 *
 * - Provide the SQL statement that returns the average deposit amount
 *   (rounded to 2 dp) for customers older than 35 years of age as of 12/31/2019
 *   (including those whose dob falls on New Year's Eve).
 * - Customers must have total deposit amounts in 2019 greater than $9,999.99.
 * - Group the results by each age (35, 36, ..., 60), including ages for which no
 *   selected customers are of that age.
 * - Do not include withdrawal amounts in your average, just the gross deposits.
 * - Label the columns as 'Age', 'Avg_Dep_Amt'.
 *
 */

-- START ANSWER 2 --

WITH cnt AS (
    SELECT 35 Age
    UNION
    SELECT Age + 1
      FROM cnt
     WHERE Age < 60
)
SELECT a.Age,
       z.Avg_Dep AS Avg_Dep_Amt
  FROM cnt AS a
       LEFT JOIN
       (
           SELECT b.Age,
                  round(avg(txns.amt), 2) AS Avg_Dep
             FROM (
                      SELECT cust_id,
                             ('2019-12-31' - dob) AS Age
                        FROM custs
                       WHERE Age > 35
                  )
                  AS b
                  LEFT JOIN
                  accts c ON b.cust_id = c.cust_id
                  JOIN
                  (
                      SELECT cust_id,
                             sum(amt) AS total_amt
                        FROM accts d
                             JOIN
                             txns e ON d.acct_id = e.acct_id
                       WHERE txn_type = 'd' AND 
                             substr(txn_dt, 1, 4) = '2019'
                       GROUP BY cust_id
                  )
                  d ON c.cust_id = d.cust_id
                  JOIN
                  txns ON txns.acct_id = c.acct_id
            WHERE d.total_amt > 9999.99
            GROUP BY Age
       )
       z ON a.Age = z.Age;


-- END ANSWER 2 --

-------------------------------------------------------------------------------

/*
 * QUESTION 3 (25 points)
 * --------------------
 *
 * - Provide the SQL statement that returns the number of WD transactions, the
 *   total WD amounts of those transactions, grouped by month of transaction.
 * - Include only customers living in the 25 cities most represented in the db. That
 *   is, the 25 cities where the most customers live.
 * - Include only checking (C) and savings (S) accounts.
 * - Include all months.
 * - Label the columns as 'Month', 'Number_WDs', 'Total_WD_Amt'.
 *
 */

-- START ANSWER 3 --

SELECT substr(txn_dt, 6, 2) Month,
       count() Numbers_WDs,
       round(sum(amt), 2) Total_WD_Amt
  FROM custs a
       JOIN
       (
           SELECT acct_id,
                  cust_id
             FROM accts
            WHERE acct_type != 'M'
       )
       b ON a.cust_id = b.cust_id
       JOIN
       (
           SELECT acct_id,
                  amt,
                  txn_dt
             FROM txns
            WHERE txn_type = 'W'
       )
       c ON b.acct_id = c.acct_id
 WHERE city || state IN (
           SELECT city || state
             FROM custs
            GROUP BY city || state
            ORDER BY count() DESC
            LIMIT 25
       )
 GROUP BY Month;

-- END ANSWER 3 --

-------------------------------------------------------------------------------

/*
 * QUESTION 4 (25 points)
 * --------------------
 *
 * - Provide the SQL statement that returns for selected customers and accounts in the
 *   Pacific coast states (WA, OR, CA, AK, HI), the minimum starting balance
 *   on 1/1/2019 00:00 to avoid having an overdrawn account as of end of day 9/30/2019.
 * - There must be at least 1.05x the overdrawn amount in the account to keep the
 *   account active on 10/1/2019.
 * - Include only customers who have a negative balance at that time.
 * - Label the columns as 'Customer_ID', 'State', 'Acct_Num', 'Acct_Type',
 *   'Net_Txn_Amt_AsOf_0930', 'Req_Min_Bal_On_0101'.
 * - Order the results by Req_Min_Bal_On_0101 (largest to smallest).
 * - For example, let's say a customer (acct num 0000) has a savings account with
 *   net transaction amount of -2,500 by 9/30. Then, the output would be:
 *     0000, CA, A99999, S, -2500, 2625
 *
 */

-- START ANSWER 4 --

WITH c AS (
    SELECT *
      FROM custs
     WHERE state IN ('WA', 'OR', 'CA', 'AK', 'HI') 
),
t AS (
    SELECT *
      FROM txns
     WHERE txn_dt < '2019-10-01'
)
SELECT c.cust_id AS Customer_ID,
       c.state AS State,
       accts.acct_id AS Acct_Num,
       accts.acct_type AS Acct_Type,
       sum(amt * (txn_type = 'D') - amt * (txn_type = 'W') ) AS Net_Txn_Amt_AsOf_0930,
       sum(amt * (txn_type = 'D') - amt * (txn_type = 'W') ) * -1.05 AS Req_Min_Bal_On_0101
  FROM c
       JOIN
       accts ON c.cust_id = accts.cust_id
       JOIN
       t ON accts.acct_id = t.acct_id
 GROUP BY c.cust_id,
          accts.acct_id
HAVING Net_Txn_Amt_AsOf_0930 < 0
 ORDER BY Req_Min_Bal_On_0101 DESC;


-- END ANSWER 4 --

-------------------------------------------------------------------------------
/*
 * BONUS QUESTION (20 points)
 * --------------------
 *
 * Create a Shiny app using the bank database, the appropriate SQL statements,
 * and necessary R code meeting the following minimum requirements:
 * 
 *  - a search box allowing the search of any customer name
 *  - a date box allowing a reference date to be entered
 *  - a button, when clicked, that will ring up relevant account information
 *    on that customer as of the date selected
 *
 * Use the shiny_bank.R file as a template to get started.
 * 
 * Submit the completed file using the filename 'shiny_bank_ab1234.R' where
 * ab1234 is your UNI.
 * 
 * An error-free working app will generally earn 10 points. For the full 
 * 20 points, you will have to add more features and formatting to enhance 
 * the basic requirements. Feel free to consult with the instructors for
 * advice and assistance.
 *
 */

-------------------------------------------------------------------------------

-- END HOMEWORK ASSIGNMENT 4 --

-------------------------------------------------------------------------------
