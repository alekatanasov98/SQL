SELECT
    name,
    job_title_short,
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