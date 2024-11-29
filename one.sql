-- Data Cleaning Project

SELECT *
FROM layoffs ;


-- 1. Remove Duplicates
-- 2. Standardize the data
-- 3. Null Values or Blank Values
-- 4. Remove any Columns

-- Create copy of mother data table to make edits
CREATE TABLE layoffs_editable
LIKE layoffs ;

SELECT * 
FROM layoffs_editable ;

INSERT INTO layoffs_editable
SELECT *
FROM layoffs ;

-- Find Duplicate 
WITH CTE_rownum AS (
SELECT *,
ROW_NUMBER() OVER (PARTITION BY company,location,industry,total_laid_off,percentage_laid_off, date ,stage,country,funds_raised_millions) AS row_num
FROM layoffs_editable )
SELECT *
FROM CTE_rownum 
WHERE row_num > 1 ;

SELECT * 
FROM layoffs_editable
WHERE company = "Yahoo" ;

CREATE TABLE `layoffs_editable2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * 
FROM layoffs_editable2 ;

INSERT INTO layoffs_editable2
SELECT *,
ROW_NUMBER() OVER (PARTITION BY company,location,industry,total_laid_off,percentage_laid_off, date ,stage,country,funds_raised_millions) AS row_num
FROM layoffs_editable ;

DELETE
FROM layoffs_editable2
WHERE row_num > 1;

SELECT * 
FROM layoffs_editable2 
WHERE row_num > 1;

-- Standardize the data

SELECT company, TRIM(company)
FROM layoffs_editable2 ;

UPDATE layoffs_editable2
SET company = TRIM(company) ; 

SELECT *
FROM layoffs_editable2
WHERE industry LIKE "%Crypto%";

UPDATE layoffs_editable2
SET industry = "Crypto"
WHERE industry LIKE "%Crypto%";

SELECT DISTINCT industry
FROM layoffs_editable2
ORDER BY industry ;

SELECT *
FROM layoffs_editable2
WHERE country LIKE "%United States%";

UPDATE layoffs_editable2
SET country = "United States"
WHERE country LIKE "%United States%";

SELECT DISTINCT country
FROM layoffs_editable2
ORDER BY 1 ;

SELECT date,
STR_TO_DATE (date, "%m/%d/%Y")
FROM layoffs_editable2;

UPDATE layoffs_editable2
SET date = STR_TO_DATE (date, "%m/%d/%Y") ;

SELECT *
FROM layoffs_editable2 ;

ALTER TABLE layoffs_editable2
MODIFY COLUMN date DATE ;

-- Null values or Blank Values

SELECT *
FROM layoffs_editable2
WHERE industry IS NULL OR industry = "";

SELECT t1.company,t1.industry, t2.industry
FROM layoffs_editable2 t1
JOIN layoffs_editable2 t2
ON t1.company= t2.company
WHERE (t1.industry = "" OR t1.industry IS NULL)
AND t2.industry IS NOT NULL 
;

UPDATE layoffs_editable2
SET industry = NULL 
WHERE industry = "" ;

UPDATE layoffs_editable2 t1
JOIN layoffs_editable2 t2
ON t1.company= t2.company
SET t1.industry = t2.industry
WHERE (t1.industry = "" OR t1.industry IS NULL)
AND t2.industry IS NOT NULL ;

SELECT *
FROM layoffs_editable2 
WHERE company LIKE "%Bally%" 
;

DELETE
FROM layoffs_editable2
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_editable2 ;

ALTER TABLE layoffs_editable2
RENAME COLUMN date TO the_date ;

ALTER TABLE layoffs_editable2
DROP COLUMN row_num ;









