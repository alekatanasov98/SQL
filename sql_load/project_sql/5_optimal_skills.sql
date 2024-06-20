SELECT
    skills,
    ROUND(AVG(salary_year_avg), 1) AS avg_per_skill,
    COUNT(skills_job_dim.job_id) AS demand
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
    avg_per_skill DESC