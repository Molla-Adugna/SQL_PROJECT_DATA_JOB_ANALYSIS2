/*
Answer: What are the top skills based on salary?
-Look at the average salary associated with each skill for Data Analyst positions
_Focus on roles with specified salaries, regardless of location
_Why? It reveals how different skills impact salary levels for Data Analysts and helps identify the most financially rewarding skills to acquire or imrove
*/

SELECT 
    skills,
    ROUND(AVG(salary_year_avg), 0)AS avg_salary
FROM 
    job_postings_fact
INNER JOIN 
    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN 
    skills_dim ON skills_job_dim.skill_id= skills_dim.skill_id
WHERE job_title_short ='Data Analyst'  AND job_work_from_home = True
AND salary_year_avg IS NOT NULL
GROUP BY skills
ORDER BY avg_salary DESC
LIMIT 25

/*
Here is the break down of the results for top paying skills
High-Paying Tech Skills: Backend and systems programming languages like Swift ($153K), Go ($116K), and Scala ($117K) lead in salaries, reflecting demand for high-performance computing and data-heavy applications.

Data & Automation Are Key: Python ($103K), R ($103K), SQL ($98K), and NoSQL ($102K) highlight the need for data analysis, while Shell ($125K), Bash ($94K), and PowerShell ($90K) emphasize automation and DevOps.

Legacy & Specialized Skills Still Pay: Older technologies like Pascal ($92K), VBA ($88K), and SAS ($102K) remain valuable in finance, enterprise applications, and legacy systems.

[
  {
    "skills": "swift",
    "avg_salary": "153750"
  },
  {
    "skills": "golang",
    "avg_salary": "145000"
  },
  {
    "skills": "shell",
    "avg_salary": "125000"
  },
  {
    "skills": "scala",
    "avg_salary": "117379"
  },
  {
    "skills": "go",
    "avg_salary": "116147"
  },
  {
    "skills": "crystal",
    "avg_salary": "114000"
  },
  {
    "skills": "c",
    "avg_salary": "109816"
  },
  {
    "skills": "r",
    "avg_salary": "103431"
  },
  {
    "skills": "python",
    "avg_salary": "102992"
  },
  {
    "skills": "nosql",
    "avg_salary": "102865"
  },
  {
    "skills": "javascript",
    "avg_salary": "102604"
  },
  {
    "skills": "sas",
    "avg_salary": "102161"
  },
  {
    "skills": "c++",
    "avg_salary": "101917"
  },
  {
    "skills": "t-sql",
    "avg_salary": "101214"
  },
  {
    "skills": "java",
    "avg_salary": "99881"
  },
  {
    "skills": "matlab",
    "avg_salary": "99000"
  },
  {
    "skills": "sql",
    "avg_salary": "98269"
  },
  {
    "skills": "rust",
    "avg_salary": "97500"
  },
  {
    "skills": "php",
    "avg_salary": "95000"
  },
  {
    "skills": "bash",
    "avg_salary": "93950"
  },
  {
    "skills": "pascal",
    "avg_salary": "92000"
  },
  {
    "skills": "powershell",
    "avg_salary": "90500"
  },
  {
    "skills": "html",
    "avg_salary": "90000"
  },
  {
    "skills": "vb.net",
    "avg_salary": "90000"
  },
  {
    "skills": "vba",
    "avg_salary": "88015"
  }
]
*/