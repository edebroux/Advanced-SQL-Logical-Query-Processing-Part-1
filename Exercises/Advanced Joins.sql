/*
Advanced Joins
Created by: Evan DeBroux

Exercises to write advanced SQL join queries from Ami Levin's Advanced SQL course about Logical Query Processing
1. Show adopters who adopted two animals in one day
2. Show animals with their most recent vaccination
3. Challenge: exploring ways to breed pure bred animals
    - Male and female of the same purebred breed
*/
-- 1. Show adopters who adopted two animals in one day
SELECT t1.Adopter_Email,
       t1.Adoption_Date,
       t1.Name as Name1,
       t1.Species as Species1,
       t2.Name as Name2,
       t2.Species as Species2
FROM [Animal_Shelter].[dbo].[Adoptions] as t1
     INNER JOIN [Animal_Shelter].[dbo].[Adoptions] as t2
     ON t1.Adopter_Email = t2.Adopter_Email AND
        t1.Adoption_Date = t2.Adoption_Date AND
        (
            (t1.Name = t2.Name AND t1.Species > t2.Species) OR
            (t1.Name > t2.Name AND t1.Species = t2.Species) OR
            (t1.Name <> t2.Name AND t1.Species > t2.Species)
        )                             -- Need to avoid duplicates where the names are the same but species are not
ORDER BY t1.Adopter_Email,
         t1.Adoption_Date;

-- 2. Show animals with their most recent vaccination
SELECT A.Name, A.Primary_Color, A.Breed,
    Last_Vaccinations.*
FROM [Animal_Shelter].[dbo].[Animals] as A
    OUTER APPLY
    (
        SELECT V.Vaccine, V.Vaccination_Time
        FROM [Animal_Shelter].[dbo].[Vaccinations] as V
        WHERE V.Name = A.Name AND V.Species = A.Species
        ORDER BY V.Vaccination_Time DESC
        OFFSET 0 ROWS FETCH NEXT 3 ROW ONLY
    ) AS Last_Vaccinations;

-- 3. Challenge: exploring ways to breed pure bred animals
SELECT M.Species,
       M.Breed as Breed,
       M.Name as Male,
       F.Name as Female
FROM [Animal_Shelter].[dbo].[Animals] as M
    INNER JOIN [Animal_Shelter].[dbo].[Animals] as F
    ON M.Breed = F.Breed AND                                -- Breed equality removes NULLs, i.e. non-purebred
       M.Species = F.Species AND 
       M.Gender = 'M' AND
       F.Gender = 'F'
ORDER BY M.Species, M.Breed;