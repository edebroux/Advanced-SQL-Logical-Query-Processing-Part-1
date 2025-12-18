/*
Subqueries and Set Operators Exercise File
Created By: Evan DeBroux

Exercises to work on SQL queries that involve subqueries/set operators

Exercise 1:
1. Show adoption rows including fees
2. Show the max fee ever paid
3. Discount from MAX in percent
4. Show the fee for each species
5. Show attributes for people who adopted at least 1 animal
6. Show animals that were not adopted
7. CHALLENGE - show breeds that were never adopted
	- Breeds, not animals
	- Breed are not an animal identifier
	- Breeds can be null
	- Non-breed dogs and non-breed cats
	- Only breed not adopted was a Turkish Angora Cat
	- Use OUTER JOIN, NOT EXISTS, and NOT IN first
*/
SELECT MAX(Adoption_Fee)
FROM [Animal_Shelter].[dbo].[Adoptions];

-- 1, 2, 3
SELECT *,
	   (SELECT MAX(Adoption_Fee)
		FROM [Animal_Shelter].[dbo].[Adoptions]) as Max_Fee,
		(((SELECT MAX(Adoption_Fee) FROM [Animal_Shelter].[dbo].[Adoptions]) - Adoption_Fee) * 100) / (SELECT MAX(Adoption_Fee) FROM [Animal_Shelter].[dbo].[Adoptions]) AS Discount_Percent
FROM [Animal_Shelter].[dbo].[Adoptions];

-- 4
SELECT *,
		( SELECT MAX(Adoption_Fee)
		  FROM [Animal_Shelter].[dbo].[Adoptions] as A2
		  WHERE A2.Species = A1.Species
		  ) AS Max_Fee
FROM [Animal_Shelter].[dbo].[Adoptions] as A1;

-- 5 - use distinct
SELECT DISTINCT P.*
FROM [Animal_Shelter].[dbo].[Persons] as P
	INNER JOIN
	Animal_Shelter.dbo.Adoptions as A
	ON A.Adopter_Email = P.Email;
-- Could use a filter - make sure column aliases are referenced correctly
SELECT *
FROM [Animal_Shelter].[dbo].[Persons]
WHERE Email in (SELECT Adopter_Email FROM [Animal_Shelter].[dbo].[Adoptions]);

-- Use exists
SELECT *
FROM [Animal_Shelter].[dbo].[Persons] as P
WHERE EXISTS (
				SELECT NULL						-- Select doesn't return anything when using an EXISTS clause
				FROM [Animal_Shelter].[dbo].[Adoptions] as A
				WHERE A.Adopter_Email = P.Email
			);

-- 6 requires an anti-join
SELECT DISTINCT AN.Name, AN.Species
FROM [Animal_Shelter].[dbo].[Animals] as AN
	LEFT OUTER JOIN
	[Animal_Shelter].[dbo].[Adoptions] as AD
	ON AD.NAME = AN.NAME
		AND
		AD.Species = AN.Species
WHERE AD.Name IS NULL;

-- Use not exist - subquery is evaluated once per animal, so no duplicates are seen
SELECT Name, Species
FROM [Animal_Shelter].[dbo].[Animals] as AN
WHERE NOT EXISTS (
	SELECT NULL
	FROM [Animal_Shelter].[dbo].[Adoptions] as AD
	WHERE AD.Name = AN.Name
			AND
			AD.Species = AN.Species
);

-- Use set operators EXCEPT
SELECT Name, Species
FROM [Animal_Shelter].[dbo].[Animals]
EXCEPT
SELECT Name, Species
FROM [Animal_Shelter].[dbo].[Adoptions];

-- 7 - doesn't work because some dogs which were adopted will show up & NOT EXISTS has the same issue
/*
SELECT DISTINCT AN.Breed, AN.Species
FROM [Animal_Shelter].[dbo].[Animals] as AN
	LEFT OUTER JOIN [Animal_Shelter].[dbo].[Adoptions] as AD
	ON AN.Species = AD.Species
		AND AN.Name = AD.Name
WHERE AD.Species IS NULL;
*/

-- Trying EXCEPT, column order matters!
SELECT DISTINCT AN1.Breed, AN1.Species
FROM [Animal_Shelter].[dbo].[Animals] as AN1
EXCEPT
(
SELECT AN2.Breed, AN2.Species
FROM [Animal_Shelter].[dbo].[Animals] as AN2
INNER JOIN [Animal_Shelter].[dbo].[Adoptions] as AD
	ON AD.Species = AN2.Species
	AND AN2.Name = AD.Name);



	