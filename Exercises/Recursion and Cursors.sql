/*
Recursion and Cursors.sql
Created by: Evan DeBroux

Examples and exercises for Ami Levin's Recursion chapter in Advanced SQL: Logical Query Processing, Part 2

Exercises & Examples:
1. Recursively generate days of the year 2019
2. Generate an website web crawler
*/

-- 1
WITH days_of_2019 (day) AS (
    SELECT CAST('20190101' AS DATE)
    UNION ALL
    SELECT DATEADD(DAY, 1, day)        -- DATEADD(datepart, number, date) returns a new date that is the specified time interval added to the specified date
    -- Recursion with PostgreSQL: SELECT CAST(day + INTERVAL '1 DAY' as date)
    FROM days_of_2019
    WHERE day < CAST('20191231' AS DATE)
)

SELECT *
FROM days_of_2019
ORDER BY day ASC
OPTION(MAXRECURSION 365); -- Recursion depth by default is 100, so we need to set it to 365 to generate all days of the year 2019

-- 2
DROP TABLE [Animal_Shelter].[dbo].[Weblinks];

CREATE TABLE Weblinks (
    URL CHAR(3) NOT NULL,
    Points_To_URL CHAR(3) NOT NULL,
    PRIMARY KEY (URL, Points_To_URL),
    CHECK (URL <> Points_To_URL)
);

INSERT INTO weblinks (URL, Points_To_URL)
VALUES ('U1', 'U9'), ('U1', 'U3'), ('U2', 'U8'), ('U2', 'U6'),
      ('U3', 'U2'), ('U3', 'U4'), ('U3', 'U5'), ('U3', 'U9'),
      ('U4', 'U2'), ('U5', 'U4'), ('U5', 'U6');;

SELECT *
FROM Weblinks
ORDER BY URL, Points_To_URL;

WITH Crawler (From_URL, To_URL, Level) AS (
    SELECT CAST('>' AS CHAR(3)),
            CAST('U4' AS CHAR(3)),
            CAST(0 AS INT)
    UNION ALL
    SELECT c.To_URL,
            W.Points_To_URL,
            level + 1
    FROM Weblinks as W
    INNER JOIN Crawler AS c
    ON W.URL = c.To_URL
)

SELECT *
FROM Crawler
ORDER BY Level, From_URL, To_URL
OPTION (MAXRECURSION 10000); -- Recursion depth by default is 100, so we need to set it to 1000 to generate all paths from U4 to other URLs