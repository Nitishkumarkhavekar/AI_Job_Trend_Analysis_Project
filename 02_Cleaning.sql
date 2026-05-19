-- ============================================================
--   Script   : 02_Cleaning.sql
--   Purpose  : Build the normalized production tables, clean text 
--              anomalies, and fix logical salary range metrics.
-- ============================================================
USE ai_job_market;

-- Drop production tables if they exist to prevent schema collision errors
DROP TABLE IF EXISTS ai_job_postings CASCADE;
DROP TABLE IF EXISTS corporate_companies CASCADE;

-- 1. Create Normalized Dimension Table: Companies
CREATE TABLE corporate_companies (
    company_id INT AUTO_INCREMENT PRIMARY KEY,
    company_name VARCHAR(255) NOT NULL UNIQUE,
    industry_sector VARCHAR(150) DEFAULT 'Technology'
);

-- 2. Populate Company Dimension from Staging Records
INSERT INTO corporate_companies (company_name)
SELECT DISTINCT TRIM(company_name)
FROM job_staging_raw
WHERE company_name IS NOT NULL AND company_name <> '';

-- 3. Create Fact Table: Production Job Postings
CREATE TABLE ai_job_postings (
    job_id INT AUTO_INCREMENT PRIMARY KEY,
    job_title VARCHAR(255) NOT NULL,
    company_id INT,
    geographic_location VARCHAR(150) NOT NULL,
    employment_classification VARCHAR(100) NOT NULL,
    experience_tier VARCHAR(100) NOT NULL,
    annual_salary_min NUMERIC(12, 2),
    annual_salary_max NUMERIC(12, 2),
    annual_salary_avg NUMERIC(12, 2),
    publication_date DATE NOT NULL,
    FOREIGN KEY (company_id) REFERENCES corporate_companies(company_id) ON DELETE CASCADE
);

-- 4. Ingest and Clean Staging Data into Production Structure
INSERT INTO ai_job_postings (
    job_title, company_id, geographic_location, employment_classification, 
    experience_tier, annual_salary_min, annual_salary_max, annual_salary_avg, publication_date
)
SELECT 
    TRIM(REGEXP_REPLACE(stg.title, '[[:space:]]+', ' ')) AS job_title,
    c.company_id,
    COALESCE(TRIM(stg.location), 'Remote') AS geographic_location,
    COALESCE(TRIM(stg.employment_type), 'Full-time') AS employment_classification,
    COALESCE(TRIM(stg.experience_level), 'Mid-Level') AS experience_tier,
    
    -- Reconcile logical range errors where Minimum Salary > Maximum Salary
    CASE WHEN stg.salary_min > stg.salary_max THEN stg.salary_max ELSE stg.salary_min END AS annual_salary_min,
    CASE WHEN stg.salary_min > stg.salary_max THEN stg.salary_min ELSE stg.salary_max END AS annual_salary_max,
    
    -- Calculate Average Annual Salary
    (stg.salary_min + stg.salary_max) / 2 AS annual_salary_avg,
    COALESCE(DATE(stg.posted_date), '2026-01-01') AS publication_date
FROM job_staging_raw stg
JOIN corporate_companies c ON TRIM(stg.company_name) = c.company_name;

-- 5. Add Performance Indexes for Analytical Optimization
CREATE INDEX idx_publication_date ON ai_job_postings(publication_date);
CREATE INDEX idx_job_search ON ai_job_postings(job_title, experience_tier);