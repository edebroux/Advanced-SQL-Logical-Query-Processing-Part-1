/*
More on Grouping in SQL
Created by: Evan DeBroux

Exercise file for advanced grouping coursework. Exercise descriptions:
1. Group adoptions by date and filter by groups that have more than 1 adoption.
2. Show all animals that were adopted on the dates where more than 1 adoption occurred.
3. Add Breeds to the output from #2, showing all breeds adopted on those dates.
4. Rank animals by number of vaccinations they have received.
5. Write a query to show the weekly, monthly, and yearly adoptions
7. Number of animals adopted by each person by Year
8. Count Number of animals by breed, species, and overall
9. Count number of vaccinations per
    - Year
    - Species
    - Species per year
    - Staff member
    - Staff member and species
Get latest vaccination year for each group.
*/

-- 1
SELECT Adoption_Date,
       SUM(Adoption_Fee) AS Total_Fee
FROM [Animal_Shelter].[dbo].[Adoptions]
GROUP BY Adoption_Date
HAVING COUNT(*) > 1;

-- 2
SELECT Adoption_Date,
       SUM(Adoption_Fee) AS Total_Fee,
       STRING_AGG(CONCAT(Name, ' the ', Species), ', ')             -- CONCAT to combine Name and Species, STRING_AGG to aggregate by date
       WITHIN GROUP (ORDER BY Species, Name) AS Adopted_Animals
FROM [Animal_Shelter].[dbo].[Adoptions]
GROUP BY Adoption_Date
HAVING COUNT(*) > 1;

--3
SELECT Adoption_Date,
       SUM(Adoption_Fee) AS Total_Fee,
       STRING_AGG(CONCAT(AN.Name, ' the ', AN.Breed, ' ', AN.Species), ', ')  -- Added Breed to CONCAT
       WITHIN GROUP (ORDER BY AN.Species, AN.Breed, AN.Name) AS Adopted_Animals
FROM [Animal_Shelter].[dbo].[Adoptions] AS AD
     INNER JOIN
     [Animal_Shelter].[dbo].[Animals] AS AN
     ON AN.Name = AD.Name
     AND AN.Species = AD.Species
GROUP BY Adoption_Date
HAVING COUNT(*) > 1;

-- 4
SELECT Name,
       Species,
       COUNT(*) AS Number_of_Vaccinations
FROM [Animal_Shelter].[dbo].[Vaccinations]
GROUP BY Name, Species
ORDER BY Species, Number_of_Vaccinations DESC;

-- Try to group results to get the max, min, and avg number of vaccinations by species
-- THIS CODE WORKS FOR POSTGRESQL, BUT NOT FOR SQL SERVER
-- So, using a CTE instead
-- WITH Vaccination_Ranking AS
-- (
--     SELECT Name, Species, COUNT(*) AS NUM_V 
--     FROM [Animal_Shelter].[dbo].[Vaccinations]
--     GROUP BY Name, Species
-- )

-- SELECT Species, MAX(Num_V) AS Max_V, MIN(Num_V) AS Min_V,
--         CAST(AVG(Num_V) AS DECIMAL(9, 2)) AS Avg_V,
--         PERCENT_RANK(5) OVER (ORDER BY Num_V DESC) AS H_RANK
-- FROM Vaccination_Ranking
-- GROUP BY Species;
-- Hypothetical set functions -> see the rank of a hypothetical new animal's rank based on current vaccination data

-- 6 - written as separate queries for weekly, monthly, and yearly adoptions
SELECT YEAR(Adoption_Date) AS Year, 
        MONTH(Adoption_Date) AS Month,
        COUNT(*) AS Monthly_Adoptions
FROM [Animal_Shelter].[dbo].[Adoptions]
GROUP BY YEAR(Adoption_Date), MONTH(Adoption_Date);

SELECT YEAR(Adoption_Date) AS YEAR,
        COUNT(*) AS Annual_Adoptions
FROM [Animal_Shelter].[dbo].[Adoptions]
GROUP BY Year(Adoption_Date);

SELECT COUNT(*) AS Total_Adoptions
FROM [Animal_Shelter].[dbo].[Adoptions]
GROUP BY ();

-- Write 6 as one table, but larger # of tables would make this unwieldy
SELECT YEAR(Adoption_Date) AS Year, 
        MONTH(Adoption_Date) AS Month,
        COUNT(*) AS Monthly_Adoptions
FROM [Animal_Shelter].[dbo].[Adoptions]
GROUP BY YEAR(Adoption_Date), MONTH(Adoption_Date)
UNION ALL
SELECT YEAR(Adoption_Date) AS YEAR,
        COUNT(*) AS Annual_Adoptions,
        NULL AS Month
FROM [Animal_Shelter].[dbo].[Adoptions]
GROUP BY Year(Adoption_Date)
UNION ALL
SELECT COUNT(*) AS Total_Adoptions,
        NULL AS Year,
        NULL AS Month
FROM [Animal_Shelter].[dbo].[Adoptions]
GROUP BY ();

-- 6 - write using a WITH clause
WITH Aggregated_Adoptions AS
(
    SELECT YEAR(Adoption_Date) AS Year, 
            MONTH(Adoption_Date) AS Month,
            COUNT(*) AS Monthly_Adoptions
    FROM [Animal_Shelter].[dbo].[Adoptions]
    GROUP BY YEAR(Adoption_Date), MONTH(Adoption_Date)
)

-- Use CTE to get the Adoptions
SELECT * FROM Aggregated_Adoptions
UNION ALL
SELECT Year, NULL, COUNT(*)
FROM Aggregated_Adoptions
GROUP BY Year
UNION ALL
SELECT NULL, NULL, COUNT(*)
FROM Aggregated_Adoptions
GROUP BY ();

-- 6 - use grouping sets
SELECT YEAR(Adoption_Date) AS Year, 
        MONTH(Adoption_Date) AS Month,
        COUNT(*) AS Adoption_Count
FROM [Animal_Shelter].[dbo].[Adoptions]
GROUP BY GROUPING SETS
(
    (YEAR(Adoption_Date), MONTH(Adoption_Date)),  -- Monthly
    (YEAR(Adoption_Date)),                         -- Yearly
    ()                                             -- Total
)
;

-- 7
SELECT YEAR(Adoption_Date) AS Year,
       Adopter_Email,
       COUNT(*) AS MONTHLY_ADOPTIONS
FROM [Animal_Shelter].[dbo].[Adoptions]
GROUP BY GROUPING SETS
(
    (YEAR(Adoption_Date), Adopter_Email)
);

-- Another example, get # of animals by breed, species and overall
-- Need to add COALESCE to replace NULLs with 'All' or similar
-- Need to add CASE statements to handle multiple grouping levels
SELECT COALESCE(Species, 'All') AS Species,
       CASE
              WHEN GROUPING(Breed) = 1 THEN 'All'
              ELSE Breed
         END AS Breed,
         COUNT(*) AS Number_of_Animals
FROM [Animal_Shelter].[dbo].[Animals]
GROUP BY GROUPING SETS
(
    (Breed, Species),
    (Breed),
    ()
)
ORDER BY Species, Breed;

-- Preview Data for 9
SELECT TOP(10) *
FROM [Animal_Shelter].[dbo].[Vaccinations];
-- 9
SELECT COALESCE(CAST(YEAR(V.Vaccination_Time) AS VARCHAR(10)), 'All Years') AS Year,
       COALESCE(V.Species, 'All Species') AS Species,
       COALESCE(S.Email, 'All Staff') AS Email,
       CASE WHEN GROUPING(S.Email) = 0
            THEN MAX(S.First_Name)
            ELSE ''
            END AS First_Name,
        CASE WHEN GROUPING(S.Email) = 0
             THEN MAX(S.Last_Name)
             ELSE ''
             END AS Last_Name,
       COUNT(*) AS Number_of_Vaccinations,
       MAX(YEAR(V.Vaccination_Time)) AS Latest_Vaccination_Year
FROM [Animal_Shelter].[dbo].[Vaccinations] AS V
         INNER JOIN
         [Animal_Shelter].[dbo].[Persons] AS S
         ON V.Email = S.Email
GROUP BY GROUPING SETS
(
    (YEAR(V.Vaccination_Time), V.Species),   -- Year and Species
    (YEAR(V.Vaccination_Time)),              -- Year only
    (V.Species),                             -- Species only
    (S.Email),                               -- Staff member only
    (V.Species, S.Email),                    -- Staff member and Species
    ()                                       -- Overall
)
ORDER BY Year, Species, First_Name, Last_Name;