/* 
Created by: Evan DeBroux
Ordering and Paging Exercises
*/

-- Orders by column position
SELECT *
FROM [Animal_Shelter].[dbo].[Animals]
ORDER BY 2, 5, 1;

-- Order by aliases instead!
SELECT *
FROM [Animal_Shelter].[dbo].[Animals]
ORDER BY Species, Breed, Name;

-- Order by 
SELECT DISTINCT Adoption_Date, Species, Name
FROM [Animal_Shelter].[dbo].[Adoptions]
ORDER BY Adoption_Date DESC;

SELECT *
FROM [Animal_Shelter].[dbo].[Animals]
ORDER BY Species, Name;

-- Paging with OFFSET
SELECT *
FROM [Animal_Shelter].[dbo].[Animals]
ORDER BY Admission_Date DESC
OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY;
