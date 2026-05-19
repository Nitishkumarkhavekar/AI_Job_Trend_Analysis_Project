-- ============================================================
--   Script   : 04_Views.sql
--   Purpose  : Create a flattened database view optimized for 
--              direct import and rapid visual rendering in Power BI.
-- ============================================================
USE ai_job_market;

CREATE OR REPLACE VIEW v_job_market_summary AS
SELECT 
    j.job_id,
    j.job_title,
    c.company_name,
    c.industry_sector,
    j.geographic_location,
    j.employment_classification,
    j.experience_tier,
    j.annual_salary_min,
    j.annual_salary_max,
    j.annual_salary_avg,
    j.publication_date,
    EXTRACT(YEAR FROM j.publication_date) AS metrics_year,
    EXTRACT(MONTH FROM j.publication_date) AS metrics_month
FROM ai_job_postings j
JOIN corporate_companies c ON j.company_id = c.company_id;