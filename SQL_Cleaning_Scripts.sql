-- =============================================
-- 1. CLEANING DIM_ARTISTS
-- =============================================

-- 1.1. Handle invalid Birth/Death years (Convert 0 to NULL)
-- Reference: PDF Page 7
UPDATE Dim_Artists
SET BeginDate = NULL
WHERE BeginDate = 0;

UPDATE Dim_Artists
SET EndDate = NULL
WHERE EndDate = 0;

-- 1.2. Clean Gender and Nationality
-- Remove extra spaces and handle empty strings as NULL
-- Reference: PDF Page 8-9
UPDATE Dim_Artists
SET Gender = NULL
WHERE TRIM(Gender) = '';

UPDATE Dim_Artists
SET Nationality = NULL
WHERE TRIM(Nationality) = '';


-- =============================================
-- 2. CLEANING DIM_ARTWORKS
-- =============================================

-- 2.1. Standardize DateAcquired
-- Step 1: Set invalid formats to NULL (keep only format like '4/9/1996')
UPDATE Dim_Artworks
SET DateAcquired = NULL
WHERE DateAcquired NOT LIKE '%/%';

-- Step 2: Convert String to Date format (MySQL standard YYYY-MM-DD)
-- Reference: PDF Page 11
UPDATE Dim_Artworks
SET DateAcquired = STR_TO_DATE(DateAcquired, '%c/%e/%Y')
WHERE DateAcquired IS NOT NULL;

-- Step 3: Change column data type to DATE
ALTER TABLE Dim_Artworks
MODIFY DateAcquired DATE;

-- 2.2. Clean DateCreated text field
-- Remove extra spaces
UPDATE Dim_Artworks
SET DateCreated = TRIM(DateCreated);

-- Set meaningless values ('Unknown', 'n.d.', etc.) to NULL
-- Reference: PDF Page 13
UPDATE Dim_Artworks
SET DateCreated = NULL
WHERE DateCreated IN ('', 'n.d.', 'Unknown', 'n.d', 'nd')
   OR DateCreated IS NULL;

-- (Optional) Standardize 'circa' to 'c.'
UPDATE Dim_Artworks
SET DateCreated = REPLACE(DateCreated, 'circa', 'c.')
WHERE DateCreated LIKE 'circa %';

-- 2.3. Extract YearCreated (Feature Engineering)
-- Add new column
ALTER TABLE Dim_Artworks
ADD COLUMN YearCreated INT;

-- Use Regex to extract the first 4 consecutive digits
-- Reference: PDF Page 15
UPDATE Dim_Artworks
SET YearCreated = CAST(REGEXP_SUBSTR(DateCreated, '[0-9]{4}') AS UNSIGNED)
WHERE DateCreated REGEXP '[0-9]{4}';

-- =============================================
-- 3. CLEANING ARTWORK_ARTIST
-- =============================================

--Separate the data in column ConstituentID
CREATE TABLE Artwork_Artist_Clean AS
SELECT 
    t1.ObjectID,
    TRIM(j.Single_ID) AS ConstituentID
FROM 
    Artwork_Artist t1,
    JSON_TABLE(
        -- Biến chuỗi "123, 456" thành mảng JSON "[123, 456]" để MySQL hiểu
        CONCAT('[', t1.ConstituentID, ']'), 
        "$[*]" 
        COLUMNS(Single_ID VARCHAR(255) PATH "$")
    ) j
WHERE t1.ConstituentID IS NOT NULL 
  AND t1.ConstituentID != '';

-- =============================================
-- 4. VERIFY RELATIONSHIPS (TEST JOIN)
-- =============================================

-- Query to test if the model works by joining 3 tables
-- Reference: PDF Page 19
/*
SELECT 
    aw.Title AS Artwork_Title,
    aw.YearCreated,
    ar.DisplayName AS Artist_Name,
    ar.Nationality,
    aw.Department
FROM Dim_Artworks aw
JOIN Artwork_Artist_Clean aa ON aw.ObjectID = aa.ObjectID
JOIN Dim_Artists ar ON aa.ConstituentID = ar.ConstituentID
LIMIT 10;
*/
