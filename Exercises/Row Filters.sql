/*
Created by: Evan DeBroux
Row Filters exercise file
*/

-- Task 1: return all species except bull mastiffs
SELECT *
FROM [Animal_Shelter].[dbo].[Animals]
WHERE Species = 'Dog'
	  AND Breed <> 'Bullmastiff';

-- Task 2: selecting all non-purebred animals and non BullMastiff dog
SELECT *
FROM [Animal_Shelter].[dbo].[Animals]
WHERE ISNULL([Breed], 'Some Value') != 'Bullmastiff';
