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


-- HOMEWORK ASSIGNMENT 2

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
 *    - The source database 'kpop' is provided to you. If you modify the data 
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
 * QUESTION 1 (5 points)
 * --------------------
 *
 * Provide the SQL statement that returns from the table 'idols', the stage names
 * of all the memTbers of the group (grp) 'Twice'. Order the results by their stage 
 * names in alphabetical order (A to Z).
 *
 */

-- START ANSWER 1 --

SELECT stage_name
  FROM idols
 WHERE grp = "Twice"
 ORDER BY stage_name;


-- END ANSWER 1 --

-------------------------------------------------------------------------------

/*
 * QUESTION 2 (10 points)
 * --------------------
 *
 * Provide the SQL statement that returns from the table 'idols', the full names,
 * stage names, and dates of birth (dob) of all the members of the group 'BTS'. 
 * Order the results by age (oldest to youngest).
 *
 */

-- START ANSWER 2 --

SELECT full_name,
       stage_name,
       dob
  FROM idols
 WHERE grp = "BTS"
 ORDER BY dob ASC;

-- END ANSWER 2 --

-------------------------------------------------------------------------------

/*
 * QUESTION 3 (10 points)
 * --------------------
 *
 * Provide the SQL statement that returns from the table 'idols', the stage names of
 * the twenty youngest female solo performers. A solo performer is indicated by
 * his/her group being NULL. Order the results reverse-alphabetically (Z to A)
 * by stage name.
 *
 */

-- START ANSWER 3 --

SELECT stage_name
  FROM (
           SELECT stage_name
             FROM idols
            WHERE grp IS NULL
            ORDER BY dob DESC
            LIMIT 20
       )
 ORDER BY stage_name DESC;

-- END ANSWER 3 --

-------------------------------------------------------------------------------

/*
 * QUESTION 4 (10 points)
 * --------------------
 *
 * Provide the SQL statement that returns from the table 'idols', the full names,
 * stage names, and dates of birth of all the members of groups beginning with the
 * letter 'S', immediately followed by a vowel ('a', 'e', 'i', 'o', 'u'). Order
 * the results alphabetically first by group and then by full name.
 *
 */

-- START ANSWER 4 --

SELECT full_name,
       stage_name,
       dob
  FROM idols
 WHERE grp LIKE 'Sa%' OR 
       grp LIKE 'Se%' OR 
       grp LIKE 'Si%' OR 
       grp LIKE 'So%' OR 
       grp LIKE 'Su%'
 ORDER BY grp,
          full_name;

-- END ANSWER 4 --

-------------------------------------------------------------------------------

/*
 * QUESTION 5 (10 points)
 * --------------------
 *
 * Using the same criteria from Question 4, what is the stage name of the 
 * fifth oldest idol from that dataset?
 *
 */

-- START ANSWER 5 --

SELECT full_name,
       stage_name,
       dob
  FROM idols
 WHERE grp LIKE 'Sa%' OR 
       grp LIKE 'Se%' OR 
       grp LIKE 'Si%' OR 
       grp LIKE 'So%' OR 
       grp LIKE 'Su%'
 ORDER BY dob
 LIMIT 1 OFFSET 4;

-- END ANSWER 5 --

-------------------------------------------------------------------------------

/*
 * QUESTION 6 (10 points)
 * --------------------
 *
 * Provide the SQL statement that returns from the table 'songs'
 * the song names and ratings of exactly ten random songs with a rating 
 * of 4 or 5.
 *
 */

-- START ANSWER 6 --

SELECT song_name,
       rating
  FROM songs
 WHERE rating = 4 OR 
       rating = 5
 ORDER BY random() limit 10;

-- END ANSWER 6 --

-------------------------------------------------------------------------------

/*
 * QUESTION 7 (10 points)
 * --------------------
 *
 * Provide the SQL statement that returns all the columns from the table 'songs'
 * the 20 newest songs by an artist beginning with the letters 'EXO'.
 * A song is newer than another song if its date of release (dor) comes 
 * chronologically later.
 *
 */

-- START ANSWER 7 --

SELECT *
  FROM songs
 WHERE artist LIKE 'EXO%'
 ORDER BY dor DESC
 LIMIT 20;

-- END ANSWER 7 --

-------------------------------------------------------------------------------

/*
 * QUESTION 8 (15 points)
 * --------------------
 *
 * Provide the SQL statement that returns from the table 'songs'
 * all of the highest rated songs (artist, song_name, rating, rating2)
 * where 'rating2' is defined as:
 *
 *   rating2 = [(rating + day of release) mod 7] + 1
 *
 * For example, for song_id 3280, rating = 5, dor = '2019-04-12'.
 *
 *   day of release = 12
 *   rating + day of release = 5 + 12 = 17
 *   17 mod 7 = 3
 *   rating2 = 3 + 1 = 4
 *   
 */

-- START ANSWER 8 --

SELECT artist,
       song_name,
       rating,
       ( ( (rating + substr(dor, 9, 2) ) % 7) + 1) AS rating2
  FROM songs
 ORDER BY rating2 DESC;

-- END ANSWER 8 --

-------------------------------------------------------------------------------

/*
 * QUESTION 9 (20 points)
 * --------------------
 *
 * Provide the SQL statement that returns from the table 'plays'
 * a list of distinct song names and artists meeting ALL of the following
 * criteria:
 *
 *  - played between the hours of 8 AM and 4 PM inclusively
 *  - played during the Summer of 2019 (between 6/21 and 9/22)
 *  - not played during the Fall of 2019 (between 9/23 and 12/20)
 *
 */

-- START ANSWER 9 --

SELECT DISTINCT song_name,
                artist
  FROM plays
 WHERE substr(play_dt, 12, 5) BETWEEN '08:00' AND '16:00' AND 
       (substr(play_dt, 6, 5) ) BETWEEN '06-21' AND '09-22'
EXCEPT
SELECT DISTINCT song_name,
                artist
  FROM plays
 WHERE (substr(play_dt, 6, 5) ) BETWEEN '09-23' AND '12-20';


-- END ANSWER 9 --

-------------------------------------------------------------------------------

/*
 * BONUS QUESTION (20 points)
 * --------------------
 *
 * Create a Shiny app using the kpop database, the appropriate SQL statements,
 * and necessary R code meeting the following minimum requirements:
 * 
 *  - a drop-down list showing all artists in the database
 *  - when an artist is selected, a table of their songs is shown
 *
 * Use the shiny_kpop.R file as a template to get started.
 * 
 * Submit the completed file using the filename 'shiny_kpop_ab1234.R' where
 * ab1234 is your UNI.
 * 
 * A working app will generally earn 10 points. For the full 20 points, you will
 * have to add more features and formatting to enhance the basic requirements.
 * Feel free to consult with the instructors for advice and assistance.
 *
 */

-------------------------------------------------------------------------------

-- END HOMEWORK ASSIGNMENT 2 --

-------------------------------------------------------------------------------
