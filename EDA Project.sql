-- Exploratory Data Analysis


SELECT * 
FROM layoffs_staging2;

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

SELECT * 
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

SELECT * 
FROM layoffs_staging2;

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC; 

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC; 

SELECT company, AVG(percentage_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;


SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;


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


SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT company, YEAR(`date`) AS `YEAR`, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, `YEAR`
ORDER BY 3 DESC;

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

SELECT *
FROM layoffs_staging2;

SELECT company, location, industry, total_laid_off, SUBSTRING(`date`,1, 7) AS `date`, country
FROM layoffs_staging2
WHERE country = 'United States' AND total_laid_off IS NOT NULL AND `date` IS NOT NULL
ORDER BY `date`;

SELECT SUBSTRING(`date`,1, 7) `date`, SUM(total_laid_off), country
FROM layoffs_staging2
WHERE country = 'United States' AND total_laid_off IS NOT NULL AND `date` IS NOT NULL
GROUP BY SUBSTRING(`date`,1, 7)
ORDER BY `date`;

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










