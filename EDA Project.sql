-- Exploratory Data Analysis - World Layoffs 03/2020 - 03/2023


SELECT * 
FROM layoffs_staging2;


SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;


-- Companies that laid off 100% of their employees

SELECT * 
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;


-- Layoffs vs Company 
-- Shows total layoffs in each company

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;


-- Date range of Data

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;


-- Layoffs vs Industry
-- Showing industries with the hihgest total number of layoffs

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;


-- Layoffs vs Country 
-- Showing countries with the highest total number of layoffs

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;


-- Layoffs vs Year
-- Showing the total number of layoffs each year

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC; 


-- Layoffs vs Company Stage

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC; 


-- Average Percentage of Layoffs vs Company

SELECT company, AVG(percentage_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;


-- Layoffs vs Date
-- Showing the total number of layoffs each month

SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;


-- Using CTE to perform calculation on Total Layoffs each month 

WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, total_off, SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;

-- Using CTE to perform calculation on Total Layoffs each month in selected year

WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
AND SUBSTRING(`date`,1, 4) = 2020
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, total_off, SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;


-- Layoffs vs Company 
-- Shows total layoffs in each company

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;


-- Shows total layoffs in each company with year

SELECT company, YEAR(`date`) AS `YEAR`, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, `YEAR`
ORDER BY 3 DESC;


-- Using CTE to show 5 companies with highest total number of layoffs in each year

WITH Company_Year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS
(
SELECT *,
DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5;


-- Layoffs vs Date in United States

SELECT company, location, industry, total_laid_off, SUBSTRING(`date`,1, 7) AS `date`, country
FROM layoffs_staging2
WHERE country = 'United States' AND total_laid_off IS NOT NULL AND `date` IS NOT NULL
ORDER BY `date`;


-- Showing the total number of layoffs each month in United States 

SELECT SUBSTRING(`date`,1, 7) `date`, SUM(total_laid_off), country
FROM layoffs_staging2
WHERE country = 'United States' AND total_laid_off IS NOT NULL AND `date` IS NOT NULL
GROUP BY SUBSTRING(`date`,1, 7)
ORDER BY `date`;


-- Using CTE to perform calculation on Total Layoffs each month in United States

WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`,1, 7) `DATE`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE country = 'United States' AND total_laid_off IS NOT NULL AND `date` IS NOT NULL
GROUP BY SUBSTRING(`date`,1, 7)
ORDER BY `DATE`
)
SELECT `DATE`, total_off, SUM(total_off) OVER(ORDER BY `DATE`) AS ROLLING_TOTAL
FROM Rolling_Total;










