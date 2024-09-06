# Introduction
Dive into the data job market. Focusing on data analyst roles, this project explores top-paying jobs, in demand skills and where high demand meets high salary in data analytics.

Check the SQL queries here: [project_sql folder](/project_sql/)

## The questions I wanted to answer through my SQL queries were:
1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are assosiated with higher salaries?
5. What are the most optimal skills to learn?
# Tools Used
For my deep dive into the data analyst job market, I used the following tools:

- **SQL** 
- **PostgreSQL** 
- **VS Code** 
- **Git & GitHub** 
# The Analysis
Each query for this project aimed at investigating specific aspects of the data analyst job market. Here's how I approached each question: 

### 1. Top Paying Data Analyst Jobs
To identify the highest-paying roles I filtered data analyst positions by average annual salary and location, focusing on remote jobs. This query highlights the high-paying opportunities in the field.
```sql
SELECT
    name AS company,
    job_title_short AS job_title,
    salary_year_avg,
    job_location
FROM job_postings_fact
LEFT JOIN company_dim
ON job_postings_fact.company_id = company_dim.company_id
WHERE
    salary_year_avg IS NOT NULL AND
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere'
ORDER BY
    salary_year_avg DESC
LIMIT 10
```
Here's the breakdown of the top data analyst jobs in 2023:

**Wide Salary Range:** Top 10 paying data analyst roles span from $184,000 to $650,000, indicating significant salary potential in the field.

| company                                | job_title    | salary_year_avg | job_location |
|----------------------------------------|--------------|-----------------|--------------|
| Mantys                                 | Data Analyst | 650 000.0        | Anywhere     |
| Meta                                   | Data Analyst | 336 500.0        | Anywhere     |
| AT&T                                   | Data Analyst | 255 829.5        | Anywhere     |
| Pinterest Job Advertisements           | Data Analyst | 232 423.0        | Anywhere     |
| Uclahealthcareers                      | Data Analyst | 217 000.0        | Anywhere     |
| SmartAsset                             | Data Analyst | 205 000.0        | Anywhere     |
| Inclusively                            | Data Analyst | 189 309.0        | Anywhere     |
| Motional                               | Data Analyst | 189 000.0        | Anywhere     |
| SmartAsset                             | Data Analyst | 186 000.0        | Anywhere     |
| Get It Recruit - Information Technology| Data Analyst | 184 000.0        | Anywhere     |
### 2. Skills for Top Paying Jobs
To understand what skills are required for the top-paying jobs, I joined the job postings with the skills data, providing insights into what employers value for high-compensation roles.
```sql
WITH top_paying_jobs AS (
    SELECT
        name AS company_name,
        job_id,
        job_title_short,
        salary_year_avg
    FROM 
        job_postings_fact
    LEFT JOIN company_dim
    ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst' AND
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT
    top_paying_jobs.*,
    skills
FROM 
    top_paying_jobs
INNER JOIN skills_job_dim
ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim
ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC
```
Here's the breakdown of the most demanded skills for the top 10 highest paying data analyst jobs in 2023:

SQL is the most demanded skill followed by Python and Tableau.
### 3. In-Demand Skills for Data Analysts
This query helped identify the skills most frequently requested in job postings, directing focus to areas with high demand.
```sql
SELECT
    skills,
    COUNT(job_postings_fact.job_id) AS job_postings
FROM
    job_postings_fact
INNER JOIN skills_job_dim
ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim
ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    skills
ORDER BY
    job_postings DESC
LIMIT 5
```
Here's the result of the most demanded skills for data analysts in 2023
| skills   | job_postings |
|----------|--------------|
| sql      | 92 628        |
| excel    | 67 031        |
| python   | 57 326        |
| tableau  | 46 554        |
| power bi | 39 468        |

### 4. Skills Based on Salary
Exploring the average salaries associated with different skills revealed which skills are the highest paying.
```sql
SELECT 
    skills,
    ROUND(AVG(salary_year_avg), 2) AS avg_salary
FROM 
    job_postings_fact
INNER JOIN skills_job_dim 
ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim 
ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    salary_year_avg IS NOT NULL
    AND job_title_short = 'Data Analyst'
GROUP BY 
    skills
ORDER BY 
    avg_salary DESC
```
Result (first 10 rows):
| skills    | avg_salary |
|-----------|------------|
| svn       | 400 000.00  |
| solidity  | 179 000.00  |
| couchbase | 160 515.00  |
| datarobot | 155 485.50  |
| golang    | 155 000.00  |
| mxnet     | 149 000.00  |
| dplyr     | 147 633.33  |
| vmware    | 147 500.00  |
| terraform | 146 733.83  |
| twilio    | 138 500.00  |

### 5. Most Optimal Skills to Learn
Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and have high salaries, offering a strategic focus for skill development.
```sql
SELECT
    skills,
    ROUND(AVG(salary_year_avg), 1) AS avg_salary,
    COUNT(skills_job_dim.job_id) AS job_offers
FROM
    job_postings_fact
INNER JOIN skills_job_dim 
ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim
ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    salary_year_avg IS NOT NULL AND
    job_title_short = 'Data Analyst' AND
    job_work_from_home IS TRUE
GROUP BY
    skills
HAVING
    COUNT(skills_job_dim.job_id) > 10
ORDER BY
    job_offers DESC
```
Result (first 10 rows):

|skills    |avg_salary   |job_offers|
|----------|-------------|------|
|sql       |97 237.2	 |398   |
|excel     |87 288.2	 |256   | 
|python    |101 397.2    |236   | 
|tableau   |99 287.7	 |230   | 
|r         |100 498.8    |148   | 
|sas       |98 902.4	 |126   | 
|power bi  |97 431.3	 |110   | 
|powerpoint|88 701.1	 |58    | 
|looker    |103 795.3    |49    | 
|word      |82 576.0	 |48    | 

# Conclusions
1. **Top-Paying Data Analyst Jobs:** The highest-paying jobs for data analysts that allow remote work offer a wide range of slaries, the highest at $650,000.
2. **Skills for Top-Paying Jobs:** High-paying data analyst jobs require advanced proficiency in SQL, suggesting it's a critical skill for earning a top salary.
3. **Most In Demand Skills:** SQL is also the most demanded skill in the data analyst job market, thus making it essential for job seekers.
4. **Skills with Higher Salaries:** Specialized skills, such as SVN and Solidity are associated with the highest average salaries, indicating a premium on niche expertise.
5. **Optimal Skills for Job Market Value:** SQL leads in demand and offers for a high average salary, positioning it as one of the most optimal skills for data analysts to learn and maximize their market value.
