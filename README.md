# AI_Job_Trend_Analysis_Project


## 📌 Project Overview
This data analytics repository provides a complete relational data warehouse structure designed to track and extract insights from hiring metrics across global AI and Data Analytics job markets. The project ingests raw marketplace tracking data, executes data cleaning and database normalization pipelines using sequential SQL scripts, and flattens production views for reporting layers like Power BI.

## 🏢 Business Problems Solved
* **Global Salary Benchmarking:** Establishes clear base salary windows across varying experience levels and role titles.
* **Geographic Marketplace Shifts:** Maps remote workspace adoption trends versus major regional technology hub hiring concentrations.
* **Hiring Volume Density:** Pinpoints specific high-volume hiring role tracks to help guide professional training focuses.

## 📁 Flat Project Layout Explained
* `01_Loading.sql`: Creates the database and handles loading the raw CSV from MySQL's secure directory.
* `02_Cleaning.sql`: Normalizes tables, maps dimensions, handles missing text, and reconciles salary logical range boundaries.
* `03_Analysis.sql`: Runs advanced analytical window ranking functions and global market baseline metrics.
* `04_Views.sql`: Flattens production data into an optimized database view for direct Power BI synchronization.
* `Ai_Job_Trend_Analysis.pbix`: Interactive dashboard workbook for visual reporting.
* `ai_job_dataset.csv`: Raw data source tracking file used for the project setup.
* `job_market_dashboard.png`: Screenshot image highlighting the finished operational dashboard interface.

## 🚀 Step-by-Step Local Deployment Setup

### 1. Replicate Project Directory Tree Locally
```bash
git clone [https://github.com/Nitishkumarkhavekar/ai-job-market-analysis.git](https://github.com/Nitishkumarkhavekar/ai-job-market-analysis.git)
cd ai-job-market-analysis
