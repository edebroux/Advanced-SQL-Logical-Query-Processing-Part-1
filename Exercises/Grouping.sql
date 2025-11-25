/*
Created By: Evan DeBroux
Grouping and Group Filters Exercise Set

*/

-- Count animals by species
SELECT COUNT(*) AS Count, Species
FROM [Animal_Shelter].[dbo].[Animals]
GROUP BY Species;

-- See the vaccinations by species
SELECT Name,
	   Species,
	   COUNT(*) AS Count
FROM [Animal_Shelter].[dbo].[Vaccinations]
GROUP BY Name, Species;

-- How many animals we have for each breed
SELECT Species,
	   Breed,
	   COUNT(*) AS Number_Of_Animals
FROM [Animal_Shelter].[dbo].[Animals]
GROUP BY Breed, Species;

-- Get the people who were born in the same year
SELECT YEAR(CURRENT_TIMESTAMP) - YEAR(Birth_Date) AS AGE,
	   COUNT(*) AS Number_Of_Persons
FROM [Animal_Shelter].[dbo].[Persons]
GROUP BY YEAR(Birth_Date);

-- Get every distinct row of animal that got a vaccination using GROUP BY
SELECT Species, Name
FROM [Animal_Shelter].[dbo].[Vaccinations]
GROUP BY Species, Name;

-- Will  not return distinct values
-- DISTINCT does not provide unique rows
SELECT DISTINCT Species, COUNT(*) AS Num_Vaccines
FROM [Animal_Shelter].[dbo].[Vaccinations]
GROUP BY Species, Name
ORDER BY Species;

-- See how many animals people have adopted and
-- keep those emails where the number of animals adopted
-- is > 1
SELECT Adopter_Email,
	   COUNT(*) AS Number_of_Adoptions
FROM [Animal_Shelter].[dbo].[Adoptions]
GROUP BY Adopter_Email
HAVING COUNT(*) > 1
ORDER BY Number_of_Adoptions DESC;

/* CHALLENGE */
-- Preview necessary data tables
SELECT TOP(5) * FROM [Animal_Shelter].[dbo].[Animals];
SELECT TOP(25) * FROM [Animal_Shelter].[dbo].[Vaccinations];

SELECT t1.Name, t1.Species, t1.Primary_Color,
	   t1.Breed, COUNT(t2.Vaccine) AS Num_Vaccinations
FROM [Animal_Shelter].[dbo].[Animals] as t1
LEFT OUTER JOIN [Animal_Shelter].[dbo].[Vaccinations] as t2
ON t1.Name = t2.Name AND t1.Species = t2.Species
WHERE t1.Species <> 'Rabbit' AND
	  ISNULL(t2.Vaccine, 0) <> 'Rabbies'
GROUP BY t1.Name, t1.Species, t1.Primary_Color, t1.Breed
HAVING MAX(t2.Vaccination_Time) < '20191001' OR MAX(t2.Vaccination_Time) IS NULL;