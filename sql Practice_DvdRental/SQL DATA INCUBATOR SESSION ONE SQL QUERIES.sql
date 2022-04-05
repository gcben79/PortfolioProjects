--This is a query displaying all the data in the film table
SELECT *
FROM film;

/*Q2. Retrieve only the film ID, title and rating from the 
film data.*/
SELECT film_id, title, rating
FROM film;


/*Q3. Order the data by the film ID and display the first 
10 results only in Q2.
*/
SELECT film_id, title, rating
FROM film
ORDER BY film_id
LIMIT 10;

/*4. Display film titles and their length. Sort from the 
highest length to the lowest. Display 20 results only.
*/
SELECT title, length
FROM film
ORDER BY length DESC
LIMIT 20;


/*Q5. Reorder the results in Q4 from the lowest length to the 
highest length. Use ALIASING for your 
columns and COLUMN INDEXING in your ORDER BY statement.*/
SELECT title AS ttl, length AS len, rental_rate
FROM film
ORDER BY 3;

/*Q6. Produce a table with a new column deriving the 
difference in replacement cost and rental rate.
*/
SELECT replacement_cost, rental_rate,
	   (replacement_cost - rental_rate) AS difference_in_cost
FROM film;

--FILTER AND CONDITIONS
--Q7. Show all movie titles satisfying the following conditions:
--a. Only ‘PG’ rating. Sort in descending alphabetical order
SELECT title, rating
FROM film
WHERE rating = 'PG'
ORDER BY 1 DESC;

--b. ‘PG’, ‘R’ or ‘G’ rating only. 
SELECT title, rating
FROM film
WHERE rating IN ('PG', 'R', 'G')
ORDER BY 1 DESC;

/*c. Movie length not more than 60 minutes. 
Sort length from highest to lowest*/
SELECT title, length
FROM film 
WHERE length <= 60
ORDER BY 2 DESC;

/*d. 'R’ rated movies with movie lengths between 60 and 100 
minutes. Sort from the longer movies and then by movie titles 
in an alphabetical order*/
SELECT title
FROM film
WHERE rating = 'R' AND length BETWEEN 60 AND 100
ORDER BY length DESC, 1;

/*e. Movie description containing the word ‘drama’. Sort by 
movie title and display the first 15 results only.*/
SELECT title, description, rental_rate
FROM film 
WHERE description LIKE '%M_n%'
ORDER BY 1
LIMIT 15;

--8. AGGREGATE FUNCTIONS
/*8. Obtain the following results using aggregate functions:
a. How many movies are available on the database? */
SELECT COUNT(title) AS no_of_movies
FROM film;

--b. Also, how many movie categories are there?
SELECT COUNT(name) no_of_movie_categories
FROM category;

/*c. What is the highest replacement cost of any movie on the 
database? (Also try and derive this answer without using an
aggregate function)*/
SELECT replacement_cost, MAX(replacement_cost) AS lowest_replacement_cost
FROM film
GROUP BY 1;

SELECT replacement_cost AS min_rplcmnt_cost
FROM film
ORDER BY 1
LIMIT 1;

/*Q9. How many movies are of similar lengths in the database? 
Sort from the highest movie count.
*/
SELECT length,
	   COUNT(length) AS movie_count
FROM film
GROUP BY 1
ORDER BY 2 DESC;

/*10. How many movies which have a replacement cost of ’20.99’ 
or ’13.99’, contain the word ‘Drama’ in their description and
have either of an ‘R’, ‘NC-17’ or ‘PG’ rating?*/
SELECT rating, COUNT(title) AS movie_count
FROM film
WHERE replacement_cost IN (20.99, 13.99)
	  AND description LIKE '%Drama%'
	  AND rating IN ('R', 'NC-17', 'PG')
GROUP BY 1
ORDER BY 2 DESC;

/*Q11. Create a table with three categories of movie lengths and 
name them as such:
0 - 59 minutes, Short movie
60 – 119 minutes, Moderately long movie
120 or more minutes, Long movie
Let the table show the count of movies that fall under each 
category.*/

SELECT CASE WHEN length <=59 THEN 'Short movie'
	    WHEN length BETWEEN 60 AND 119 THEN 'Moderately long movie'
	    WHEN length >= 120 THEN 'Long movie'
	END AS movie_len_category,
	COUNT(*) AS movie_count
FROM film
GROUP BY 1






