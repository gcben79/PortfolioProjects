/*
	Cleaning Data in SQL Queries
*/

SELECT *
FROM nash_housing
LIMIT 100;



----------------------------------------------------------------------------------------------------------------------------------
-- standardize date format
SELECT sale_date, sale_date :: Date
FROM nash_housing;

UPDATE nash_housing
SET Sale_Date = sale_date :: Date;

SELECT *
FROM nash_housing
LIMIT 100;



----------------------------------------------------------------------------------------------------------------------------------
-- fill the empty Property Address data
SELECT *
FROM nash_housing
WHERE property_address IS null;


SELECT a.parcel_id, a.property_address, b.parcel_id, b.property_address, COALESCE(a.property_address, b.property_address ) 
FROM nash_housing a
JOIN nash_housing b
ON a.parcel_id = b.parcel_id
AND a.unique_id <> b.unique_id
WHERE a.property_address IS null;

UPDATE nash_housing
sET property_address = COALESCE(a.property_address, b.property_address )
FROM nash_housing a
JOIN nash_housing b
ON a.parcel_id = b.parcel_id
AND a.unique_id <> b.unique_id
WHERE a.property_address is null;



----------------------------------------------------------------------------------------------------------------------------------
-- Breaking out Address into individual columns (Address, City, State)

-- Property address contains the city in every record.
SELECT property_address
FROM nash_housing;

SELECT 
 SUBSTRING (property_address, 1, POSITION(','in property_address)-1) AS address,
 SUBSTRING (property_address, POSITION(','in property_address) +2, LENGTH (property_address)) AS property_city
FROM nash_housing;

-- Adding the new column to the Dataset

ALTER TABLE nash_housing
ADD address varchar(255);

UPDATE nash_housing
SET address = SUBSTRING (property_address, 1, POSITION(','IN property_address)-1);

ALTER TABLE nash_housing
ADD property_city varchar(255);

Update nash_housing
Set property_city = SUBSTRING (property_address, POSITION(','IN property_address) +2, LENGTH (property_address));



----------------------------------------------------------------------------------------------------------------------------------
-- Breaking out Owner_Address into individual columns (Address, City, State)

SELECT owner_address
FROM nash_housing;

SELECT
 SUBSTRING(SPLIT_PART(owner_address, ',', 1), 2, LENGTH(SPLIT_PART(owner_address, ',', 1))),
 SUBSTRING(SPLIT_PART(owner_address, ',', 2), 2, LENGTH(SPLIT_PART(owner_address, ',', 2))),
 SUBSTRING(SPLIT_PART(owner_address, ',', 3), 2, LENGTH(SPLIT_PART(owner_address, ',', 3)))
From nash_housing 

-- Adding New columns to the Dataset
ALTER TABLE nash_housing 
ADD ownersplit_address Varchar(255);

ALTER TABLE nash_housing 
ADD owner_city Varchar(255);

ALTER TABLE nash_housing 
ADD owner_state Varchar(255);

UPDATE nash_housing 
SET ownersplit_address = SUBSTRING(SPLIT_PART(owner_address, ',', 1), 2, LENGTH(SPLIT_PART(owner_address, ',', 1)));

UPDATE nash_housing
SET owner_city = SUBSTRING(SPLIT_PART(owner_address, ',', 2), 2, LENGTH(SPLIT_PART(owner_address, ',', 2)));

UPDATE nash_housing
SET owner_state = SUBSTRING(SPLIT_PART(owner_address, ',', 3), 2, LENGTH(SPLIT_PART(owner_address, ',', 3)));



----------------------------------------------------------------------------------------------------------------------------------
-- Change 'Y' and 'N' to 'Yes' and 'No' in "sold_as_vacant" field. 
SELECT DISTINCT sold_as_vacant, COUNT (sold_as_vacant)
FROM nash_housing
Group by 1;

SELECT sold_as_vacant,
 CASE WHEN sold_as_vacant = 'Y' THEN 'Yes'
      WHEN sold_as_vacant = 'N' THEN 'No'
	  ELSE sold_as_vacant END
FROM nash_housing;

UPDATE nash_housing
SET sold_as_vacant = CASE WHEN sold_as_vacant = 'Y' THEN 'Yes'
      WHEN sold_as_vacant = 'N' THEN 'No'
	  ELSE sold_as_vacant END;
	  


----------------------------------------------------------------------------------------------------------------------------------
-- I will be Removing duplicates

-- Show the duplicated records
WITH row_nums AS (
SELECT *,
   ROW_NUMBER() OVER (
   PARTITION BY parcel_id,
	   property_address,
	   sale_date,
	   sale_price,
	   legal_reference 
	   ORDER BY unique_id 
   ) AS row_num
 FROM nash_housing
)
SELECT *
FROM row_nums
WHERE row_num > 1

-- Delete duplicates
DELETE
FROM nash_housing
WHERE unique_id in
(SELECT unique_id
     From
(SELECT *,
   ROW_NUMBER() OVER (
   PARTITION BY parcel_id,
	   property_address,
	   sale_date,
	   sale_price,
	   legal_reference 
	   ORDER BY unique_id 
   ) AS row_num
 FROM nash_housing) AS ta
 WHERE ta.row_num > 1);
 
 

----------------------------------------------------------------------------------------------------------------------------------
-- Delete unused Column

ALTER TABLE nash_housing
DROP COLUMN tax_district,
DROP COLUMN property_address,
DROP COLUMN owner_address;

SELECT *
FROM nash_housing;




