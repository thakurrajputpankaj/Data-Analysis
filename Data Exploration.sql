-- Exploratory Data Analysis

SELECT *
FROM layoffs_staging2;

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

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 1 DESC;

SELECT SUBSTRING(`date`, 1,7) AS `month`, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY `month`;

WITH rolling_total_cte AS 
(
SELECT SUBSTRING(`date`, 1,7) AS `month`, SUM(total_laid_off) AS laid_offs_total
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1,7) IS NOT NULL
GROUP BY `month`
ORDER BY 1 DESC
)
SELECT `month`,laid_offs_total, SUM(laid_offs_total) OVER(ORDER BY  `month`) AS rolling_total
FROM rolling_total_cte;

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company,  YEAR(`date`)
ORDER BY 1 DESC;

WITH company_year_cte (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company,  YEAR(`date`)
), company_year_rank AS
(
SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranks
FROM company_year_cte
WHERE years IS NOT NULL
)
SELECT *
FROM company_year_rank 
WHERE ranks <= 5;
