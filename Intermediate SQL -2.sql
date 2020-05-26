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


-- HOMEWORK ASSIGNMENT 5

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
 * QUESTION 1 (50 points)
 * --------------------
 *
 * - Provide the SQL statement that lists all the states in which the customers
 *   live and the account type (C, M, S) in greatest use by those customers.
 * - The columns should be labeled: 'State' and 'Greatest_Acct_Type'.
 * - Greatest use is defined by the number of transactions incurred for the 
 *   given account type
 * - If there are ties for the top account type, all tied account types must be 
 *   listed in one column separated by commas.
 * - For example, if state ZZ had 
 *     Checking accounts with 200 transactions
 *     Money Market acccounts with 200 transactions
 *     Savings accounts with 100 transactions
 *   Then, the output for this state should be: 'ZZ', 'C,M' since C & M are tied
 *     for the top spot with 200 transactions.    
 * - Order alphabetically by state.
 *
 */

-- START ANSWER 1 --


WITH bank_acct AS (
    SELECT state,
           acct_type,
           count(txn_id),
           RANK() OVER (PARTITION BY state ORDER BY count(txn_id) desc) as rank
      FROM accts a
           JOIN
           txns t ON a.acct_id = t.acct_id
           JOIN
           custs c ON a.cust_id = c.cust_id
     GROUP BY state,
              acct_type
)
SELECT state,
       GROUP_CONCAT(acct_type) AS Greatest_Acct_Type
  FROM bank_acct
 WHERE rank = 1
 GROUP BY state
 ORDER BY state;


-- END ANSWER 1 --

-------------------------------------------------------------------------------

/*
 * QUESTION 2 (50 points)
 * --------------------
 *
 * - Use four Common Table Expressions (CTEs) to help produce a report showing
 *     customers grouped by the first three digits of their zip code (zip3)
 *     and the number of customers by age groups.
 * - The columns should be labeled: 
 *     'Zip3', 
 *     'Customers_Age_0_to_35', 
 *     'Customers_Age_36_to_50', 
 *     'Customers_Age_51_and_Over',
 *     'Total_Customers'
 * - Each CTE (c1, c2, c3, c4) should show the zip3 code along with one of 
 *   the customer columns.
 * - There should be no NULL values in the final output. Replace with zeroes.
 * - Order by total customers (greatest to least).
 *
 */

-- START ANSWER 2 --

WITH c1 AS (
    SELECT substr(zip, 0, 4) AS zip3,
           date('now') - dob - (strftime('%m %d', 'now') < strftime('%m %d', dob)) AS age1,
           count() AS n1
      FROM custs
     WHERE age1 <= 35
     GROUP BY zip3
),
c2 AS (
    SELECT substr(zip, 0, 4) AS zip3,
           date('now') - dob - (strftime('%m %d', 'now') < strftime('%m %d', dob)) AS age2,
           count() AS n2
      FROM custs
     WHERE age2 >= 36 AND 
           age2 <= 50
     GROUP BY zip3
),
c3 AS (
    SELECT substr(zip, 0, 4) AS zip3,
           date('now') - dob - (strftime('%m %d', 'now') < strftime('%m %d', dob)) AS age3,
           count() AS n3
      FROM custs
     WHERE age3 > 50
     GROUP BY zip3
),
c4 AS (
    SELECT substr(zip, 0, 4) AS zip3,
           date('now') - dob - (strftime('%m %d', 'now') < strftime('%m %d', dob)) AS age4,
           count() AS n4
      FROM custs
     GROUP BY zip3
)
SELECT c4.zip3 Zip3,
       COALESCE(n1, 0) Customers_Age_0_to_35,
       COALESCE(n2, 0) Customers_Age_36_to_50,
       COALESCE(n3, 0) Customers_Age_51_and_Over,
       n4 AS Total_Customers
  FROM c4
       LEFT JOIN
       c3 ON c4.zip3 = c3.zip3
       LEFT JOIN
       c2 ON c4.zip3 = c2.zip3
       LEFT JOIN
       c1 ON c4.zip3 = c1.zip3
 ORDER BY total_customers DESC;


-- END ANSWER 2 --

-------------------------------------------------------------------------------

/*
 * BONUS QUESTION (20 points)
 * --------------------
 *
 * Create a Shiny app using the bank database, the appropriate SQL statements,
 * and necessary R code to build a loan calculator:
 * 
 *  - a text box to enter an amount of loan to be taken
 *  - a text box to enter the annual interest rate for the loan
 *  - a text box to enter the number of annual payments to repay the loan
 *  - an output showing the annual installment repayment amount
 *
 * Use any of the prior R files to get started.
 * 
 * Submit the completed file using the filename 'shiny_bank2_ab1234.R' where
 * ab1234 is your UNI.
 * 
 * An error-free working app will generally earn 10 points. For the full 
 * 20 points, you will have to add more features and formatting to enhance 
 * the basic requirements. 
 *
 * Some ideas for additional features could include:
 *  - showing different payment amounts for different interest rates
 *  - a way to enter the desired repayment amount and then to show the number of 
 *    payments needed to payoff the loan
 *  - having different payment frequencies (monthly, quarterly, etc)
 *  - a ledger showing the progression of loan principal and interest amounts
 *  - in general, whatever would provide helpful information for a consumer to make 
 *    a decision on taking out a loan
 *
 */

-------------------------------------------------------------------------------

-- END HOMEWORK ASSIGNMENT 5 --

-------------------------------------------------------------------------------
