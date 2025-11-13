/*
Created by: Evan DeBroux

Examples and exercise from Constructing Query Source
Data Sets
*/

-- FROM clause example
SELECT *
FROM [Animal_Shelter].[dbo].[Staff];

-- SELECT a string from Staff table
SELECT 'SQL IS FUN' AS Fact
FROM [Animal_Shelter].[dbo].[Staff];

/*
Source dataset gets evaluated in the FROM clause
SELECT evaluates expression for every row
WHICH MEANS - the outputted table has a row for
each record which says `SQL IS FUN` for each row of
the Fact column
*/

/*
Write a query that generates a row for each staff member
and staff roles
*/

-- Cartesian product of Staff and Staff Roles
SELECT *
FROM [Animal_Shelter].[dbo].[Staff]
	 CROSS JOIN [Animal_Shelter].[dbo].[Staff_Roles];

-- What happens when we try to inner join these two tables
-- but use the qualification predicate of 1=1? Should yield
-- the same results, a cross join (product)
SELECT *
FROM [Animal_Shelter].[dbo].[Staff]
	 INNER JOIN [Animal_Shelter].[dbo].[Staff_Roles]
	 ON 1=1;

/*
Write a query to get their Implant_Chip_ID and Breed
*/
SELECT t1.Name, t1.Species, t2.Adopter_Email, t2.Adoption_Date, t2.Adoption_Fee, t1.Implant_Chip_ID, t1.Breed
FROM [Animal_Shelter].[dbo].[Animals] as t1
	 LEFT OUTER JOIN
	 [Animal_Shelter].[dbo].[Adoptions] AS t2
	 ON t1.Name = t2.Name AND t1.Species = t2.Species
	 ;
/*
Why did we get null names, species, adopter emails?
There are animals in the database which did not get
adopted. Since we pulled only the Chip ID and breed of
animals, we have reserved rows from the left table which,
when they don't match, get filled with nulls in the
corresponding rows from the right table. To fix the name
we could rewrite the query to pull the name from the animals table
and drop the name column from the adoptions table
*/

-- Multiple source joins
SELECT *
FROM [Animal_Shelter].[dbo].[Animals] AS t1
	 INNER JOIN [Animal_Shelter].[dbo].[Adoptions] as t2
	 ON t1.Name = t2.Name AND t1.Species = t2.Species
	 INNER JOIN [Animal_Shelter].[dbo].[Persons] as t3
	 ON t3.Email = t2.Adopter_Email;

-- Return all animals which were not adopted
/* SELECT *
FROM [Animal_Shelter].[dbo].[Animals] AS t1
	 LEFT OUTER JOIN [Animal_Shelter].[dbo].[Adoptions] as t2
	 ON t1.Name = t2.Name AND t1.Species = t2.Species
	 INNER JOIN [Animal_Shelter].[dbo].[Persons] as t3
	 ON t3.Email = t2.Adopter_Email;

That didn't work since the left outer join occurs before
the final inner join which matches on adopting animal parents
so it will return the same result

*/

-- Technically works but messy and potential performance penalty
SELECT *
FROM [Animal_Shelter].[dbo].[Adoptions] as t2
	 INNER JOIN [Animal_Shelter].[dbo].[Persons] as t3
	 ON t3.Email = t2.Adopter_Email
	 RIGHT OUTER JOIN [Animal_Shelter].[dbo].[Animals] AS t1
	 ON t1.Name = t2.Name AND t1.Species = t2.Species;

SELECT *
FROM [Animal_Shelter].[dbo].[Animals] AS t1
	 LEFT OUTER JOIN 
	 (	 [Animal_Shelter].[dbo].[Adoptions] as t2
		 INNER JOIN [Animal_Shelter].[dbo].[Persons] as t3
		 ON t3.Email = t2.Adopter_Email
	  )
	  ON t1.Name = t2.Name AND t1.Species = t2.Species;

/* CHALLENGE:
Tables used:
- Animals
- Vaccinations
- Persons
- Staff Assignments

*/
SELECT t1.Name, t1.Species, t1.Breed, t1.Primary_Color,
       t2.Vaccination_Time, t2.Vaccine, t3.First_Name, 
	   t3.Last_Name, t4.Role
FROM [Animal_Shelter].[dbo].[Animals] AS t1
	 LEFT OUTER JOIN
	 (
		[Animal_Shelter].[dbo].[Vaccinations] as t2
		INNER JOIN [Animal_Shelter].[dbo].[Persons] as t3
		ON t2.Email = t3.Email
		INNER JOIN
		[Animal_Shelter].[dbo].[Staff_Assignments] as t4
		ON t3.Email = t4.Email
	 )
	 ON t1.Species = t2.Species AND t1.Name = t2.Named;

	 -- Correct on the first try!