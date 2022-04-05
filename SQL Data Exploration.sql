--			SQL DATA EXPLORATION 
-- Covid_death Table
-- Looking at covid death table and vaccination table
SELECT *
 FROM covid_death
 LIMIT 200;
-- Vaccination Table 
SELECT *
FROM vaccination
LIMIT 200;
--------------------------------------------------------------------------------------------
/*			**COVID-19 IMPACTS IN COUNTRIES** 

 This shows covid records cases, deaths and death percentage  of each country*/

-- The death rate of infected population per location. 
SELECT location, population, SUM(new_cases) AS TotalCases, SUM(new_deaths) AS TotalDeaths,
(MAX(Total_Deaths)/SUM(new_cases))*100 AS death_rate
FROM public.covid_death
WHERE continent IS NOT null
GROUP BY 1,2
ORDER BY 1;

-- Rate of covid-19 infection per country
-- Show What percentage of people got covid
SELECT location, population, MAX(total_cases) AS people_infected, 
ROUND(MAX((total_cases/population))*100, 5) AS percentage_of_infected
FROM covid_death
WHERE continent IS NOT null AND total_cases IS NOT null
GROUP BY 1,2
ORDER BY 4 DESC;


-- Shows list countries death count 

SELECT location, MAX(total_deaths) AS total_num_of_deaths
FROM covid_death
WHERE total_deaths IS NOT null AND continent IS NOT null
GROUP BY 1
ORDER BY 2 DESC;

-- Number of infections, deaths and number of vaccinated  population.

SELECT cd.location, MAX(cd.population) population, SUM(cd.new_cases)total_num_infected, 
SUM(new_deaths) total_num_of_deaths, SUM(vax.new_vaccinations) total_num_of_vaccinated
FROM covid_death AS cd
JOIN vaccination AS vax
ON cd.location = vax.location
AND cd.date = vax.date
WHERE cd.continent IS NOT null
GROUP BY 1
ORDER BY 5 DESC;


--------------------------------------------------------------------------------------------

/*			**GLOBAL IMPACT OF COVID-19**

 */

-- Daily Global insght 
SELECT date, SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths,
(SUM(new_deaths)/SUM(new_cases)*100) AS death_percentage
FROM covid_death
WHERE continent IS NOT null
GROUP BY 1
ORDER BY 1;

--showing continent Covid-19 cases by continents 

SELECT continent, SUM(new_cases) AS total_num_of_cases
FROM covid_death
WHERE continent IS NOT null
GROUP BY 1
ORDER BY 2 DESC;

--showing continents deaths count

SELECT continent, SUM(new_deaths) AS total_num_of_deaths
FROM covid_death
WHERE continent IS NOT null
GROUP BY 1
ORDER BY 2 DESC;

-- Total population VS vaccinations (Globally) A.

SELECT cd.continent, cd.location, cd.date, population, vax.new_vaccinations
FROM covid_death AS cd
JOIN vaccination AS vax
ON cd.location = vax.location
AND cd.date = vax.date
WHERE cd.continent IS NOT null
ORDER BY 1,2,3;

-- Total population VS vaccinations (Globally) B (with rolling count of vaccinated by location)

SELECT cd.continent, cd.location, cd.date, population, vax.new_vaccinations,
 SUM(new_vaccinations) OVER(PARTITION BY cd.location ORDER BY cd.location, cd.date) rolling_count_of_people_vaccinated
FROM covid_death AS cd
JOIN vaccination AS vax
 ON cd.location = vax.location
 AND cd.date = vax.date
WHERE cd.continent IS NOT null
ORDER BY 1,2,3;

--------------------------------------------------------------------------------------------
--		**COVID-19 INSIGHT IN NIGERIA**

-- Overview of covid19 cases and deaths in Nigeria

SELECT location, date, new_cases, total_cases, new_deaths,total_deaths
FROM covid_death
WHERE location LIKE '%Nigeria%'
ORDER BY 1,2;

-- Overview of covid19 cases and deaths in Nigeria

SELECT location, date, population, Total_Cases, new_deaths AS TotalDeaths

FROM public.covid_death
WHERE location like'%Nigeria%' AND continent IS NOT null
ORDER BY 2;

/* Looking at the total_cases VS population
 Shows percentage of population got covid*/
 
SELECT location, date, total_cases, population, cast(total_cases/population As real)*100 AS percentage_of_infected
FROM covid_death
WHERE location LIKE '%Nigeria%'
ORDER BY 5 desc;

-- Total cases VS Total deaths in Nigeria
-- Likelihood of dieing from Covid in Nigeria as of February 2022.

SELECT location, date, total_cases,total_deaths, ROUND((total_deaths/total_cases)*100, 2) AS death_ppercentage
FROM covid_death
WHERE location LIKE '%Nigeria%' AND DATE_TRUNC('day', date) = '2022-02-01'
ORDER BY 1,2;


-- Number of cases (Dry season VS Wet season)

Select sum(new_cases) cases_in_dry_seasons,
(SELECT sum(new_cases)
FROM covid_death
WHERE location = 'Nigeria' AND DATE_Part('month', date) between '02'and'10') cases_in_wet_seasons
FROM covid_death
WHERE location = 'Nigeria' AND NOT (DATE_Part('month', date) between '02'and'10')

--------------------------------------------------------------------------------------------

-- create view to store data for data visualization
--------------------------------------------------------------------------------------------
-- Daily Global insght 
--1.
CREATE VIEW Global_insight AS 
SELECT  SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths,
(SUM(new_deaths)/SUM(new_cases)*100) AS death_percentage
FROM covid_death
WHERE continent IS NOT null
--GROUP BY 1
ORDER BY 1;
-- 2
CREATE VIEW continent_death AS
SELECT continent, SUM(new_deaths) AS total_num_of_deaths
FROM covid_death
WHERE continent IS NOT null
GROUP BY 1
ORDER BY 2 DESC;
-- 3
CREATE VIEW infection_rate AS
SELECT location, population, MAX(total_cases) AS people_infected, 
ROUND(MAX((total_cases/population))*100, 5) AS percentage_of_infected
FROM covid_death
WHERE continent IS NOT null AND total_cases IS NOT null
GROUP BY 1,2
ORDER BY 4 DESC;
-- 4
CREATE VIEW daily_infection_rate AS
SELECT location, population, date, MAX(total_cases) AS people_infected, 
ROUND(MAX((total_cases/population))*100, 5) AS percentage_of_infected
FROM covid_death
WHERE continent IS NOT null AND total_cases IS NOT null
GROUP BY 1,2, 3
ORDER BY 5 DESC;
--5
CREATE VIEW weather_difference AS
Select sum(new_cases) cases_in_dry_seasons,
(SELECT sum(new_cases)
FROM covid_death
WHERE location = 'Nigeria' AND DATE_Part('month', date) between '02'and'10') cases_in_wet_seasons
FROM covid_death
WHERE location = 'Nigeria' AND NOT (DATE_Part('month', date) between '02'and'10')
--------------------------------------------------------------------------------------------









