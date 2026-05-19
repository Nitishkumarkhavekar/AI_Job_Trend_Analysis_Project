-- ============================================================
--   Script   : 03_Analysis.sql
--   Purpose  : Run advanced data analysis window functions to 
--              uncover key business market insights.
-- ============================================================
USE ai_job_market;

-- Query 1: High-Value Geographic Markets vs the Global Average Compensation Baseline
WITH global_market_average AS (
    SELECT AVG(annual_salary_avg) AS baseline_avg FROM ai_job_postings
)
SELECT 
    geographic_location,
    COUNT(job_id) AS open_requisitions_count,
    ROUND(AVG(annual_salary_avg), 2) AS regional_salary_average,
    ROUND(AVG(annual_salary_avg) - (SELECT baseline_avg FROM global_market_average), 2) AS variance_from_global_baseline
FROM ai_job_postings
GROUP BY geographic_location
ORDER BY regional_salary_average DESC;


-- Query 2: Dense Ranking of Salary Classifications partitioned within Experience Tiers
SELECT 
    experience_tier,
    job_title,
    ROUND(AVG(annual_salary_avg), 2) AS role_salary_average,
    DENSE_RANK() OVER(PARTITION BY experience_tier ORDER BY AVG(annual_salary_avg) DESC) AS ranking_within_tier
FROM ai_job_postings
GROUP BY experience_tier, job_title;