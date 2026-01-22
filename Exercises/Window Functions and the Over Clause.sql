/*
Window Functions and the OVER Clause.sql
Created by: Evan DeBroux

Description: exercises from Ami Levin's course on Advanced SQL - Window Functions. Exercises are from the second
part of the course, focusing on Window functions and the OVER clause.

Exercises:
1. Aggregate Window Function Example - get the number of animals admitted to the shelter since January 1, 2017.
2. Use the same query, but get a total of animals of the same species as the current row
*/

-- 1
SELECT Species, 
        Name,
        primary_color,
        admission_date,
        COUNT(*) OVER () AS number_of_animals
FROM [Animal_Shelter].[dbo].[Animals]
WHERE admission_date >= '2017-01-01'
ORDER BY admission_date ASC;

-- 2
SELECT Species,
        Name,
        primary_color,
        admission_date,
        COUNT(*) OVER (PARTITION BY Species) AS number_of_animals_of_same_species
FROM [Animal_Shelter].[dbo].[Animals]
ORDER BY species ASC, admission_date ASC;