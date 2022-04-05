-- 							*UTIVA CAPSTONE SQL PROJECT*



--SECTION A
/*QUESTION 1. Within the space of the last three years, what was the profit worth of the breweries,
inclusive of the anglophone and the francophone territories?*/

SELECT 
	SUM(profit) ::MONEY AS Profits_Worth_of_Breweries
FROM int_bre;

/*QUESTION 2. Compare the total profit between these two territories in order for the territory manager,
Mr. Stone made a strategic decision that will aid profit maximization in 2020.*/

SELECT 
	CASE WHEN country IN ('Nigeria', 'Ghana') THEN 'Anglophone'
	WHEN country IN ('Benin', 'Senegal', 'Togo') THEN 'Fracophone'
	END AS territory, SUM (profit):: MONEY AS total_profit
FROM int_bre
GROUP BY 1
ORDER BY 2 DESC;

--QUESTION 3. Country that generated the highest profit in 2019
SELECT 
	country, SUM(profit):: MONEY AS total_profit
FROM int_bre
WHERE year = '2019'
GROUP BY 1
ORDER BY 2 DESC;
--Ghana made the most profit in 2019

--QUESTION 4. Help him find the year with the highest profit.

SELECT 
	SUM(profit)::MONEY AS total_profit, year
FROM int_bre
GROUP BY 2
ORDER  BY total_profit DESC;
--2017 had the most profit

--QUESTION 5. Which month in the three years was the least profit generated?

SELECT 
	SUM (profit)::MONEY AS total_profit, month, year
FROM int_bre
GROUP BY 2,3
ORDER BY 1;
--February 2019 is the month with most profit in period of 2017-2019

--QUESTION 6. What was the minimum profit in the month of December 2018?

SELECT 
	MIN(profit)::MONEY AS minimum_profit, month
FROM int_bre
WHERE month = 'December' AND year = '2018'
GROUP BY 2;

--QUESTION 7. Compare the profit in percentage for each of the month in 2019

WITH table1 AS
	(SELECT 
	 	month, SUM(profit) AS total_profits
	FROM int_bre
	WHERE year = '2019'
	GROUP BY 1),
table2 AS
	(SELECT 
	 	SUM(profit) AS profit_2019
	FROM int_bre
	WHERE year = '2019')
SELECT 
	month, CONCAT(Round(((total_profits/profit_2019)*100), 1), '%') AS profit_percentage
FROM table1, table2;

--QUESTION 8: Which particular brand generated the highest profit in Senegal?

SELECT 
	country, brands, SUM(profit)::MONEY
FROM int_bre
WHERE country = 'Senegal'
GROUP BY 2,1
ORDER BY 3 DESC;
--Castle Lite generated the highest profit in Senegal

/*						BRAND ANALYSIS!
QUESTION 1. Within the last two years, the brand manager wants to know the top three brands
consumed in the francophone countries*/
SELECT 
	brands, SUM(profit)::MONEY AS toral_profts, SUM(quantity) AS quantity_sold
FROM int_bre
WHERE year IN('2019', '2018') AND country IN('Togo', 'Benin', 'Senegal')
GROUP BY 1
ORDER BY 3 desc
LIMIT 3;

--QUESTION 2. Find out the top two choice of consumer brands in Ghana
SELECT 
	brands, SUM(quantity) AS quantity_sold, SUM(profit):: MONEY AS profit_made
FROM int_bre
WHere country IN('Ghana')
GROUP BY 1
Order by 2 desc
LIMIT 2;

/*3. Find out the details of beers consumed in the past three years in the most oil reached
country in West Africa.*/

SELECT 
	brands, SUM(quantity) AS quantity_sold, SUM(Profit)::MONEY AS total_profit
FROM int_bre
WHERE brands NOT LIKE '%malt%' AND  country = 'Nigeria'
GROUP BY 1
ORDER BY 2 DESC;

--QUESTION 4. Favorites malt brand in Anglophone region between 2018 and 2019

SELECT 
	brands AS malt_brand, SUM(quantity) AS quantity
FROM int_bre
WHERE country IN('Nigeria', 'Ghana') AND  year IN('2018', '2019') AND brands LIKE '%malt%'
GROUP BY 1
ORDER BY 2 DESC;
--Grand malt is the favorite malt brand in Anglophone region between 2018 and 2019

--QUESTION 5. Which brands sold the highest in 2019 in Nigeria?
SELECT 
	brands, SUM(profit)::MONEY AS total_profit, SUM(quantity) AS total_quantity
FROM int_bre
WHERE year = '2019' AND country = 'Nigeria'
GROUP BY 1
ORDER BY 3 DESC
LIMIT 3;
--HERO is the most Sold brand in Nigeria in the year 2019

-- QUESTION 6. Favorites brand in South_South region in Nigeria

SELECT 
	brands, SUM(quantity)AS quantity_sold, SUM(profit)::MONEY AS total_profit
FROM int_bre
WHERE country = 'Nigeria' AND region = 'southsouth'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

--QUESTION 7. Beer consumption in Nigeria

SELECT 
	region, brands, SUM(quantity) AS quantity_consumed, SUM(profit)::MONEY AS total_profit
FROM int_bre
WHERE country IN('Nigeria') AND brands NOT LIKE '%malt%'
GROUP BY 1,2
ORDER BY 1,2;

--QUESTION 8. Level of consumption of Budweiser in the regions in Nigeria

SELECT 
	region, SUM(quantity)AS total_quantity, SUM(profit)::MONEY AS total_profit, country
FROM int_bre
WHERE country = 'Nigeria' AND brands ='budweiser'
GROUP BY 1,4
ORDER BY total_quantity DESC;

--QUESTION 9. Level of consumption of Budweiser in the regions in Nigeria in 2019 (Decision on Promo)

SELECT 
region, year, country, SUM(quantity)AS quantity_consumed, SUM(profit)::MONEY AS profit
FROM int_bre
WHERE country LIKE 'Nigeria' AND year NOT IN('2018', '2017')
GROUP BY 1,2,3
ORDER BY 4 DESC;

/*									COUNTRIES ANALYSIS!
QUESTION 1. Country with the highest consumption of beer.*/

SELECT 
	country, SUM(quantity) AS quantity_consumed
FROM int_bre
GROUP BY 1
ORDER BY 2 DESC;

--QUESTION 2. Highest sales personnel of Budweiser in Senegal

SELECT 
	sale_rep sales_representative, email, SUM(quantity) AS quantity_sold, SUM(profit)::MONEY AS profit_made, brands, country
FROM int_bre
WHERE country = 'Senegal' AND brands ='budweiser'
GROUP BY 1,2,5,6
ORDER BY 3 DESC
LIMIT 1;

--QUESTION 3. Country with the highest profit of the fourth quarter in 2019

SELECT 
	country, SUM(profit)::MONEY AS total_profit 
FROM int_bre
WHERE year = '2019' AND month IN ('October', 'November', 'December')
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;
