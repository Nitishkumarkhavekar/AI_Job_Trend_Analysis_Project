-- ============================================================
--   upGrad Data & AI Hackathon 2026
--   Global AI Job Market Trend Analysis | Level 3
-- ============================================================
--   Script   : 01_Loading.sql

--   Purpose  : Create the ai_job_market database and load the raw 
--              CSV directly from the local Windows Downloads folder.
--              All fixes and new columns are in 02_Cleaning.sql
-- ============================================================

-- ------------------------------------------------------------
-- STEP 1 : Create the Database
-- ------------------------------------------------------------
DROP DATABASE IF EXISTS ai_job_market;

CREATE DATABASE ai_job_market
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE ai_job_market;


-- ------------------------------------------------------------
-- STEP 2 : Create the Staging Table
-- ------------------------------------------------------------
DROP TABLE IF EXISTS job_staging_raw;

CREATE TABLE job_staging_raw (
    title               VARCHAR(255),
    company_name        VARCHAR(255),
    location            VARCHAR(150),
    employment_type     VARCHAR(100),
    experience_level    VARCHAR(100),
    salary_min          NUMERIC(12, 2),
    salary_max          NUMERIC(12, 2),
    posted_date         DATETIME
);


-- ------------------------------------------------------------
-- STEP 3 : Load the CSV from Windows Downloads Folder
-- ------------------------------------------------------------
-- Enable local infile loading on the server session
SET GLOBAL local_infile = 1;

-- Pulls directly from Downloads. Requires Workbench connection Advanced settings to allow local data.
LOAD DATA LOCAL INFILE 'C:/Users/user/Downloads/ai_job_dataset.csv'
INTO TABLE job_staging_raw
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'  -- Standard Windows line breaks
IGNORE 1 ROWS
(
    title,
    company_name,
    location,
    employment_type,
    experience_level,
    salary_min,
    salary_max,
    @raw_posted_date
)
SET
    -- Parses the timestamp and trims the trailing 'Z' timezone indicator if present
    posted_date = STR_TO_DATE(TRIM(TRAILING 'Z' FROM @raw_posted_date), '%Y-%m-%dT%H:%i:%s');


-- ------------------------------------------------------------
-- STEP 4 : Confirm the Load Worked
-- ------------------------------------------------------------
-- Verify total rows loaded match your source dataset row count
SELECT COUNT(*) AS total_records_loaded FROM job_staging_raw;

-- Visual data integrity verification
SELECT * FROM job_staging_raw LIMIT 10;

-- Confirm dates parsed correctly (should display real dates, not NULL)
SELECT title, posted_date FROM job_staging_raw LIMIT 5;