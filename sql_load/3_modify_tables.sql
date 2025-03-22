/* ⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️
Database Load Issues (follow if receiving permission denied when running SQL code below)

NOTE: If you are having issues with permissions. And you get error: 

'could not open file "[your file path]\job_postings_fact.csv" for reading: Permission denied.'

1. Open pgAdmin
2. In Object Explorer (left-hand pane), navigate to `sql_course` database
3. Right-click `sql_course` and select `PSQL Tool`
    - This opens a terminal window to write the following code
4. Get the absolute file path of your csv files
    1. Find path by right-clicking a CSV file in VS Code and selecting “Copy Path”
5. Paste the following into `PSQL Tool`, (with the CORRECT file path)

\copy company_dim FROM '[Insert File Path]/company_dim.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy skills_dim FROM '[Insert File Path]/skills_dim.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy job_postings_fact FROM '[Insert File Path]/job_postings_fact.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy skills_job_dim FROM '[Insert File Path]/skills_job_dim.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

*/

-- NOTE: This has been updated from the video to fix issues with encoding

COPY company_dim FROM 'C:\Users\Molla Adugna\Desktop\SQL Courses with Luke\csv_files\company_dim.csv'
 DELIMITER ',' CSV HEADER;

COPY skills_dim FROM 'C:\Users\Molla Adugna\Desktop\SQL Courses with Luke\csv_files\skills_dim.csv'
 DELIMITER ',' CSV HEADER;

COPY job_postings_fact FROM 'C:\Users\Molla Adugna\Desktop\SQL Courses with Luke\csv_files\job_postings_fact.csv' 
 DELIMITER ',' CSV HEADER;

COPY skills_job_dim FROM 'C:\Users\Molla Adugna\Desktop\SQL Courses with Luke\csv_files\skills_job_dim.csv'
 DELIMITER ',' CSV HEADER;

SELECT *
FROM job_postings_fact
LIMIT 5;





SELECT 
    job_title_short,
    salary_year_avg AS asverage_yearly_salary,
    salary_hour_avg AS average_hourly_salary,
    job_posted_date::DATE AS job_postings
    
FROM 
    job_postings_fact
WHERE job_posted_date > '2023-06-01'
ORDER BY job_posted_date;




SELECT 
    COUNT(job_title) AS job_count,
   job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York' AS job_posting_day , 
    COUNT (EXTRACT(MONTH FROM job_posted_date)) AS month,
    EXTRACT(YEAR FROM job_posted_date) AS year
FROM job_postings_fact
WHERE EXTRACT(YEAR FROM job_posted_date) = 2023
GROUP BY job_postings_fact.job_posted_date
ORDER BY  job_count;



-- January
CREATE TABLE january_jobs AS
        SELECT *
        FROM job_postings_fact
        WHERE EXTRACT(MONTH FROM job_posted_date) = 1;

 --February       
CREATE TABLE february_jobs AS
    SELECT * FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 2;

--March
CREATE TABLE march_jobs AS
    SELECT * FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 3;

    SELECT *
    FROM march_jobs;


SELECT job_title_short,
       job_location
FROM job_postings_fact;




SELECT COUNT(job_id) AS number_of_jobs,
    CASE 
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location  = 'New York, NY' THEN 'Local'
         ELSE 'Onsite'
END AS location_catagory
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst'
GROUP BY location_catagory;



SELECT *
FROM (
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
    ) AS january_jobs;

    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1;



WITH january_jobs AS (
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT (MONTH FROM job_posted_date) = 1   
)
SELECT *
FROM january_jobs;


SELECT company_id, name AS company_name
FROM company_dim
WHERE company_id IN(
SELECT 
    company_id
FROM
    job_postings_fact
WHERE 
    job_no_degree_mention = true
ORDER BY company_id
)



WITH company_job_count AS(
SELECT 
    company_id,COUNT(*) AS total_jobs
FROM 
    job_postings_fact
GROUP BY 
    company_id)


SELECT company_dim.name AS company_name,
        company_job_count.total_jobs
FROM company_dim
LEFT JOIN 
        company_job_count ON  company_job_count.company_id = company_dim.company_id
ORDER BY 
    total_jobs DESC;



SELECT company_id,name AS name_of_company
FROM company_dim
WHERE company_id IN (
    SELECT company_id
    FROM job_postings_fact
    WHERE job_title_short = 'Data Analyst'
);


WITH company_job_counts AS
(
SELECT 
    company_id, 
    COUNT (*) AS total_jobs
FROM 
    job_postings_fact
GROUP BY 
    company_id
    )

SELECT company_dim.name AS company_name,company_job_counts.total_jobs
FROM company_dim
LEFT JOIN company_job_counts ON company_job_counts.company_id = company_dim.company_id
ORDER BY total_jobs DESC



SELECT *
FROM skills_dim
LIMIT 5;


SELECT *
FROM skills_job_dim
LIMIT 5;


SELECT *
FROM job_postings_fact
LIMIT 5;




WITH skills_count
(
SELECT skills
FROM skills_dim
LEFT JOIN skills_job_dim ON skills_dim.skill_id = skills_job_dim.skill_id
)
SELECT job_id
FROM job_postings_fact
LEFT JOIN skills_count ON job_postings_fact.job_id;







SELECT  
    job_title_short,
    company_id,
    job_location

FROM 
    january_jobs

UNION ALL
SELECT  
    job_title_short,
    company_id,
    job_location

FROM 
    february_jobs

UNION ALL
SELECT  
    job_title_short,
    company_id,
    job_location

FROM 
    march_jobs;




SELECT 
    job_title_short,
    job_location,
    job_via,
    job_posted_date::DATE,
    salary_year_avg
FROM
(
    SELECT *
    FROM january_jobs
    UNION ALL
    SELECT *
    FROM february_jobs
    UNION ALL
    SELECT *
    FROM march_jobs
)AS quarter1_job_postings
WHERE 
    salary_year_avg > 70000 AND job_title_short = 'Data Analyst'
ORDER BY 
    salary_year_avg DESC



SELECT 
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date
FROM 
    job_postings_fact
WHERE 
    job_title = 'Data Analysis' AND 
    salary_year_avg IS NOT NULL AND
    job_location =  'Anywhere'
ORDER BY 
    salary_year_avg DESC
LIMIT 10;