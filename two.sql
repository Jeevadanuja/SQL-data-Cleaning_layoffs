-- Exploratory Data Analysis

SELECT * 
FROM layoffs_editable2 ;

-- Sum of total_laid_off for each company
SELECT company, SUM(total_laid_off)
FROM layoffs_editable2
GROUP BY company
ORDER BY 2 DESC ;

-- Sum of total_laid_off in each year
SELECT YEAR(the_date), SUM(total_laid_off)
FROM layoffs_editable2
GROUP BY YEAR(the_date)
ORDER BY 1  ;

-- Sum of total_laid_off for each stage
SELECT stage, SUM(total_laid_off)
FROM layoffs_editable2
GROUP BY stage
ORDER BY 2 DESC ;

-- Find Sum of total_laid_off for each year with month and using rolling_total find total of laid off in the end of the year
SELECT SUBSTRING(the_date,1,7) AS day_count , SUM(total_laid_off)
FROM layoffs_editable2
WHERE SUBSTRING(the_date,1,7) IS NOT NULL
GROUP BY day_count
ORDER BY 1 ;

WITH rolling_total AS (
SELECT SUBSTRING(the_date,1,7) AS day_count , SUM(total_laid_off) AS total
FROM layoffs_editable2
WHERE SUBSTRING(the_date,1,7) IS NOT NULL
GROUP BY day_count
ORDER BY 1 
)
SELECT  day_count,total , SUM(total) OVER (ORDER BY day_count) AS rolling_total
FROM rolling_total
;

-- Get top 5 companies have larger total_laid off for each year
SELECT company,YEAR(the_date) ,SUM(total_laid_off)
FROM layoffs_editable2 
GROUP BY company,YEAR(the_date)
ORDER BY 3 DESC;

WITH company_year (company, years, total) AS 
(
SELECT company,YEAR(the_date) ,SUM(total_laid_off)
FROM layoffs_editable2 
GROUP BY company,YEAR(the_date)
),
company_year_ranking AS
(
SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total DESC ) AS ranking
FROM company_year 
WHERE years IS NOT NULL
)
SELECT *
FROM company_year_ranking
WHERE ranking <= 5 ;

-- Get top 5 countires have high fund raised for each year
WITH fund_country (years, country, fund)  AS
(
SELECT YEAR(the_date) ,country, SUM(funds_raised_millions) AS fund
FROM layoffs_editable2
WHERE funds_raised_millions IS NOT NULL
GROUP BY country, YEAR(the_date)
ORDER BY 1
),
ranking_country_fund As
(
SELECT *, DENSE_RANK() OVER ( PARTITION BY years ORDER BY fund DESC) AS ranking
FROM fund_country
)
SELECT *
FROM ranking_country_fund
WHERE ranking <=5
;
