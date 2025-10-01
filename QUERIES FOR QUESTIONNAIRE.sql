-- TOtal Number of Projects by OUTCOME--
SELECT
  state,
  COUNT(*) AS total_projects
FROM projects
GROUP BY state;
 
 
 -- Total Number of Projects by LOCATION
SELECT 
  count(distinct location_id) from projects;
  
  
-- Total number of Projects based on Category --
select count(distinct category_id) as total_category_project from projects;
  

-- Total number of Projects by Year, Quarter, Month--
SELECT 
  YEAR(FROM_UNIXTIME(created_at)) AS year,
  QUARTER(FROM_UNIXTIME(created_at)) AS quarter,
  MONTH(FROM_UNIXTIME(created_at)) AS month,
  COUNT(*) AS total_projects
FROM projects
GROUP BY year, quarter, month
ORDER BY year, quarter, month;

-- Total Amount Raised for Successful Projects -- 
  SELECT 
  ROUND(SUM(pledged) / 1000000000, 2) AS total_amount_raised_billion
FROM projects
WHERE state = 'successful';
-- Total number of backers for Successful projects--
SELECT 
  ROUND(SUM(backers_count) / 1000000, 2) AS total_backers_million
FROM projects
WHERE state = 'successful';

-- Avg Number of Days for Successful Projects --
SELECT 
  ROUND(AVG(DATEDIFF( launched_date , created_date)), 2) AS avg_days_successful_projects
FROM projects
WHERE state = 'successful';

-- Top 10 Successful Projects by Backers Count -- 
  SELECT 
    ProjectID,
    name,
    backers_count
FROM projects
WHERE state = 'successful'
ORDER BY backers_count DESC
LIMIT 10;

-- Top 10 Successful Projects by Amount Raised --
SELECT 
    ProjectID,
    name,
    usd_pledged
FROM projects
WHERE state = 'successful'
ORDER BY usd_pledged DESC
LIMIT 10;
-- Percentage Of successful projects overall --
SELECT 
  ROUND(
    (SUM(CASE WHEN state = 'successful' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 
    2
  ) AS success_percentage
FROM projects;
-- Percentage of successful project by category --
SELECT 
  c.name AS category_name,
  COUNT(*) AS total_projects,
  SUM(CASE WHEN p.state = 'successful' THEN 1 ELSE 0 END) AS successful_projects,
  ROUND(
    (SUM(CASE WHEN p.state = 'successful' THEN 1 ELSE 0 END) * 100.0) / COUNT(*),
    2
  ) AS success_percentage
FROM projects p
JOIN category c ON p.category_id = c.id
GROUP BY c.name;
-- Percentage of Successful Projects by Year, Month--
SELECT 
  DATE_FORMAT(FROM_UNIXTIME(created_at), '%Y-%m') AS `year_month`,
  COUNT(*) AS total_projects,
  SUM(CASE WHEN state = 'successful' THEN 1 ELSE 0 END) AS successful_projects,
  ROUND(
    (SUM(CASE WHEN state = 'successful' THEN 1 ELSE 0 END) * 100.0) / COUNT(*),
    2
  ) AS success_percentage
FROM projects
GROUP BY DATE_FORMAT(FROM_UNIXTIME(created_at), '%Y-%m')
ORDER BY DATE_FORMAT(FROM_UNIXTIME(created_at), '%Y-%m');



-- Percentage of successful project by Goal Range --
SELECT
  CASE
    WHEN goal_usd < 1000 THEN 'Below 1K'
    WHEN goal_usd BETWEEN 1000 AND 5000 THEN '1K–5K'
    WHEN goal_usd BETWEEN 5001 AND 10000 THEN '5K–10K'
    WHEN goal_usd BETWEEN 10001 AND 50000 THEN '10K–50K'
    ELSE 'Above 50K'
  END AS goal_range,
  COUNT(*) AS total_projects,
  SUM(CASE WHEN state = 'successful' THEN 1 ELSE 0 END) AS successful_projects,
  ROUND(
    SUM(CASE WHEN state = 'successful' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
    2
  ) AS success_percentage
FROM projects
GROUP BY goal_range
ORDER BY FIELD(goal_range, 'Below 1K', '1K–5K', '5K–10K', '10K–50K', 'Above 50K');


  





















