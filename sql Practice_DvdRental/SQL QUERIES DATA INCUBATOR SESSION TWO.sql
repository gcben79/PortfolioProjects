SELECT *
FROM film;

SELECT payment_date
FROM payment;

/*1. Using DATE FUNCTIONS, answer the following questions:
a. How many customers made a rental on the 28th day of 
the month?*/
SELECT COUNT(rental_id) AS no_of_customers
FROM payment
WHERE DATE_PART('day', payment_date) = 28;

/*b. How many customers made a rental on the 28
th day in the month of April*/

SELECT COUNT(rental_id) AS no_of_rents
FROM payment
WHERE DATE_TRUNC('day', payment_date) = '2007-04-28';

SELECT DATE_TRUNC('day', payment_date),
	   DATE_PART('day', payment_date)
FROM payment;

/*2. Using JOINs, solve the following problems:
a. Classify every movie by its category.*/

SELECT fi.title AS movie_title, 
		ca.name AS movie_category
FROM category AS ca
JOIN film_category AS fc
ON ca.category_id = fc.category_id
JOIN film AS fi 
ON fc.film_id = fi.film_id;

/*b. List the first name and last name of every actor for 
each movie.*/

SELECT f.title AS movie_name,
	   ac.first_name,
	   ac.last_name
FROM actor AS ac
JOIN film_actor AS fa
ON ac.actor_id = fa.actor_id
JOIN film AS f
ON f.film_id = fa.film_id;

/*c. List every movie, the date it was rented and returned, 
the first and last name of the customer who did the business, 

the amount paid and the city the business took place.
*/

SELECT fi.title AS movie_name,
	   r.rental_date,
	   r.return_date,
	   cu.first_name,
	   cu.last_name,
	   p.amount AS amt_paid,
	   ci.city
FROM film AS fi
JOIN inventory AS i
ON fi.film_id = i.film_id
JOIN rental AS r
ON r.inventory_id = i.inventory_id
JOIN customer AS cu
ON cu.customer_id = r.customer_id
JOIN payment AS p
ON p.customer_id = cu.customer_id
JOIN staff AS s
ON s.staff_id = p.staff_id
JOIN address AS ad
ON ad.address_id = s.address_id
JOIN city AS ci
ON ci.city_id = ad.city_id;

/*d. How many cities are in each country on the database? 
Sort from country with the most cities 
to the least.*/

SELECT COUNT(ci.city) AS num_of_cities, co.country
FROM city AS ci
JOIN country AS co
ON ci.country_id = co.country_id
GROUP BY 2
ORDER BY 1 DESC;

/*e. What movies were the most rented in Nigerian cities? 
Sort from highest rent count to lowest.
*/

SELECT fi.title AS movie_name,
	   COUNT(r.rental_id) AS rent_count,
	   ci.city
FROM film AS fi
JOIN inventory AS i
ON fi.film_id = i.film_id
JOIN rental AS r
ON r.inventory_id = i.inventory_id
JOIN staff AS s
ON s.staff_id = r.staff_id
JOIN address AS ad
ON ad.address_id = s.address_id
JOIN city AS ci
ON ci.city_id = ad.city_id
JOIN country AS co
ON co.country_id = ci.country_id
GROUP BY 1, 3;

/*f. Our company is offering a special discount to our most 
frequent customers this upcoming holiday season. For this, we 
need the top 30 highest paying customers and we also want to 
see how many movies they have each rented.*/

SELECT cu.first_name, cu.last_name,
	   SUM(p.amount) AS total_amt_spent,
	   COUNT(r.rental_id) AS total_movies_rented
FROM customer AS cu
JOIN payment AS p
ON cu.customer_id = p.customer_id
JOIN rental AS r
ON r.rental_id = p.rental_id
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 30;

--SUBQUERIES AND CTEs

/*3. Using both Subqueries and CTEs, solve the following 
problems:
a. Return a table displaying how much individual customers spent
on renting in the month of February alone. Using this obtained 
data, determine the highest, lowest and average amount 
spent for that month of February?*/
--SUB QUERY
SELECT average_amt
FROM
	(SELECT MAX(total_amt_spent) AS highest_amt,
   		   MIN(total_amt_spent) AS lowest_amt,
		   AVG(total_amt_spent) AS average_amt
	 FROM
		(SELECT cu.first_name AS customer,
			    SUM(p.amount) AS total_amt_spent
		FROM customer AS cu
		JOIN payment AS p
		ON cu.customer_id = p.customer_id
		WHERE DATE_PART('month', p.payment_date) = 2
		GROUP BY 1
		ORDER BY 2 DESC) AS sub1) AS sub2;

/*3. Using both Subqueries and CTEs, solve the following 
problems:
a. Return a table displaying how much individual customers spent
on renting in the month of February alone. Using this obtained 
data, determine the highest, lowest and average amount 
spent for that month of February?*/
--CTEs
WITH table1 AS 
		(SELECT cu.first_name AS customer,
			    SUM(p.amount) AS total_amt_spent
		FROM customer AS cu
		JOIN payment AS p
		ON cu.customer_id = p.customer_id
		WHERE DATE_PART('month', p.payment_date) = 2
		GROUP BY 1
		ORDER BY 2 DESC),
	
	table2 AS 
		(SELECT MAX(total_amt_spent) AS highest_amt,
	   			MIN(total_amt_spent) AS lowest_amt,
	   			AVG(total_amt_spent) AS average_amt
		 FROM table1)

SELECT average_amt
FROM table2;

/*b. Generate a table showing the most rented categories of 
movies. Using the new table, further classify the movie 
categories into parent categories with the following guide:

Finally, provide the total number of movies rented in each 
parent category and other by most rented parent category.

HINT: Use a CASE WHEN statement to classify the movie 
categories into parent categories
PARENT CATEGORY     SUB-CATEGORIES
Family-friendly     Family, Comedy, Drama, Animation, Children and Music
Reality             Games, Documentary, Sports and Travel
Mature Audiences    Horror, Action, Classics and Sci-Fi
Others              New and Foreign*/

SELECT CASE WHEN category_name IN ('Family', 'Comedy', 'Drama', 'Animation', 'Children', 'Music') THEN 'Family-friendly'
			WHEN category_name IN ('Games', 'Documentary', 'Sports', 'Travel') THEN 'Reality'
			WHEN category_name IN ('Horror', 'Action', 'Classics', 'Sci-Fi') THEN 'Mature Audiences'
			WHEN category_name IN ('New', 'Foreign') THEN 'Others'
	   END AS parent_category,
	   SUM(rent_count) AS rent_count
FROM
	(SELECT ca.name AS category_name, 
		   COUNT(r.rental_id) AS rent_count
	FROM category AS ca
	JOIN film_category AS fc
	ON ca.category_id = fc.category_id
	JOIN film AS fi
	ON fi.film_id = fc.film_id
	JOIN inventory AS i
	ON i.film_id = fi.film_id
	JOIN rental AS r
	ON r.inventory_id = i.inventory_id
	GROUP BY 1
	ORDER BY 2 DESC) AS sub1
GROUP BY 1;

