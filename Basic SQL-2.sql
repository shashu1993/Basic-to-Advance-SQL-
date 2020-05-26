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


-- HOMEWORK ASSIGNMENT 3

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
 *    - For this assignment, if you use JOINS to solve the problems, you will not
 *      receive full credit as we have yet to discuss the topic in class. You must use
 *      SUBQUERIES and/or SET OPERATIONS (union, intersect, except) to arrive at the
 *      correct output.
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
 * QUESTION 1 (15 points)
 * --------------------
 *
 * Provide the SQL statement that returns from the table 'idols', the gender and
 * the number of total idols within each gender category. Also, show one row with
 * the total count for all genders. Label the columns as 'Gender' and 'Count'.
 *
 */

-- START ANSWER 1 --

SELECT gender as Gender,
       count(grp) as Count 
  FROM idols
 GROUP BY gender
 
UNION

SELECT 'Total',
       count(gender) 
  FROM idols;


-- END ANSWER 1 --

-------------------------------------------------------------------------------

/*
 * QUESTION 2 (15 points)
 * --------------------
 *
 * Provide the SQL statement that returns from the table 'songs', the top ten
 * artists with the highest average rating. The minimum number of songs to
 * qualify for this list is 5 per artist. That is, do not include any artists
 * who have less than 5 songs in the database. Label these columns 'Artist'
 * and 'Avg_Rating'.
 *
 */

-- START ANSWER 2 --

SELECT artist AS Artist,
       avg(rating) AS Avg_Rating
  FROM songs
 GROUP BY artist
HAVING count(song_id) >= 5
 ORDER BY Avg_Rating DESC
 LIMIT 10;


-- END ANSWER 2 --

-------------------------------------------------------------------------------

/*
 * QUESTION 3 (20 points)
 * --------------------
 *
 * Provide the SQL statement that returns from the table 'plays',
 * a report showing the monthly average number of played songs by quarter.
 * Quarter 1 = (Jan, Feb, Mar), Quarter 2 = (Apr, May, Jun), etc.
 * Include only songs played in the year 2019.
 * Round the monthly averages to 0 dp.
 * Label the columns 'Qtr' and 'Mthly_Avg'.
 *
 */

-- START ANSWER 3 --

SELECT 'Quarter 1' AS Qtr,
       round((count(song_name) / 3),0) AS Mthly_Avg
  FROM plays
 WHERE date(play_dt) BETWEEN '2019-01-01' AND '2019-03-31'
UNION
SELECT 'Quarter 2',
        round((count(song_name) / 3),0) AS Mthly_Avg
  FROM plays
 WHERE date(play_dt) BETWEEN '2019-04-01' AND '2019-06-30'
UNION
SELECT 'Quarter 3',
        round((count(song_name) / 3),0) AS Mthly_Avg
  FROM plays
 WHERE date(play_dt) BETWEEN '2019-07-01' AND '2019-09-30'
UNION
SELECT 'Quarter 4',
        round((count(song_name) / 3),0) AS Mthly_Avg
  FROM plays
 WHERE date(play_dt) BETWEEN '2019-10-01' AND '2019-12-31';

-- END ANSWER 3 --

-------------------------------------------------------------------------------

/*
 * QUESTION 4 (25 points)
 * --------------------
 *
 * Provide the SQL statement that returns from the table 'plays', a list of
 * 20 song names and the date of play ('yyyy-mm-dd') played most recently.
 * Duplicates are allowed. To be included, the song must meet ALL of the
 * following requirements:
 *
 *  - is among the top fifty songs played during months 1 through 5
 *  - is by a 'favorite' artist which means the artist is among the 25 most played
 *    artists within the 'plays' table
 *
 * Label the columns 'Song' and 'Play Date'.
 *
 */

-- START ANSWER 4 --

SELECT Song,
       substr(Play_date, 1, 10) AS PlayDate
  FROM (
           SELECT song_name AS Song,
                  play_dt AS Play_Date
             FROM (
                      SELECT song_name,
                             play_dt,
                             count(play_id) AS c
                        FROM plays
                       WHERE substr(play_dt, 6, 2) >= '01' AND 
                             substr(play_dt, 6, 2) <= '05'
                       GROUP BY song_name
                       ORDER BY c DESC
                       LIMIT 50
                  )
           INTERSECT
           SELECT song_name AS Song,
                  play_dt AS Play_Date
             FROM plays
            WHERE artist IN (
                      SELECT artist
                        FROM plays
                       GROUP BY artist
                       ORDER BY count(artist) DESC
                       LIMIT 25
                  )
       )
 ORDER BY play_date DESC
 LIMIT 20;



-- END ANSWER 4 --

-------------------------------------------------------------------------------

/*
 * QUESTION 5 (25 points)
 * --------------------
 *
 * Provide the SQL statement that returns from the table 'songs', all song names
 * rated 5 and the year of release. The songs must be from artists that
 * have at least triple (3x) the average songs per artist in the 'songs' table.
 * Order by year of release and then by song name. Label the columns 'Song' and
 * 'YOR'.
 *
 */

-- START ANSWER 5 --

SELECT song_name AS Song,
       substr(dor, 1, 4) AS YOR
  FROM (
           SELECT song_name,
                  dor,
                  rating
             FROM songs
            WHERE rating = 5 AND 
                  artist IN (
                      SELECT artist
                        FROM (
                                 SELECT artist,
                                        count(artist) AS ratio
                                   FROM songs
                                  GROUP BY artist
                                 HAVING ratio >= (
                                                     SELECT 3 * (count(song_id) / count(DISTINCT artist) ) 
                                                       FROM songs
                                                 )
                             )
                  )
       )
 ORDER BY YOR,Song;


            

-- END ANSWER 5 --

-------------------------------------------------------------------------------

/*
 * BONUS QUESTION (20 points)
 * --------------------
 *
 * Create a Shiny app using the kpop database, the appropriate SQL statements,
 * and necessary R code meeting the following minimum requirements:
 * 
 *  - a drop-down list showing all artists in the database
 *  - when an artist is selected, a table showing a summary of their songs
 *     - a summary is, at the minimum, the number of songs, 
 *       the artist's average rating, and the number of song plays
 *
 * Use the shiny_kpop2.R file as a template to get started.
 * 
 * Submit the completed file using the filename 'shiny_kpop2_ab1234.R' where
 * ab1234 is your UNI.
 * 
 * An error-free working app will generally earn 10 points. For the full 
 * 20 points, you will have to add more features and formatting to enhance 
 * the basic requirements. Feel free to consult with the instructors for
 * advice and assistance.
 *
 */

-------------------------------------------------------------------------------

-- END HOMEWORK ASSIGNMENT 2 --

-------------------------------------------------------------------------------
