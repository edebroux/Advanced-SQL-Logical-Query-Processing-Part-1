/*
Framing Exclusions and Shortcuts.sql
Created by: Evan DeBroux

Desscription: Examples and exercises from Ami Levin's Advanced SQL - Window Functions course section on Framing, Exclusions, and Shortcuts

Exercises:
1. Count the number of animals admitted prior to the next animal was admitted to the shelter
*/
-- 1 - need to fix the the '1' DAY for SQL Server - need to use a correlated subquery instead
SELECT
    Species,
    Name,
    Primary_Color,
    Admission_Date,
    (
        SELECT
            COUNT(*)
        FROM
            [Animal_Shelter].[dbo].[Animals] AS T2
        WHERE
            T2.Species = T1.Species
            AND T2.Admission_Date >= '2018-10-31' -- Ensure count is within the overall date range
            AND T2.Admission_Date < T1.Admission_Date -- Count only days *strictly before* the current row's date
    ) AS up_to_previous_day_species_animals
FROM
    [Animal_Shelter].[dbo].[Animals] AS T1
WHERE
    Species = 'Dog'
    AND Admission_Date > '2018-10-31'
ORDER BY
    Species ASC,
    Admission_Date ASC;
-- Check to see if there are any animals that were adopted on the same day
SELECT Species,
       Admission_Date,
       COUNT(*)
FROM [Animal_Shelter].[dbo].[Animals]
GROUP BY Species, Admission_Date
HAVING COUNT(*) > 1;

-- Which dogs were adopted on the same day?
SELECT *
FROM [Animal_Shelter].[dbo].[Animals]
WHERE Admission_Date = '2018-11-01';

