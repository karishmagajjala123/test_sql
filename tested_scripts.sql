-- using cte  
use testdb;

select * from employees;


WITH highest AS (
  SELECT
    employee_id,
    first_name,
    MAX(salary) AS highest_salary
  FROM employees
  group by job_id
  
)
SELECT
  e.*,
  h.highest_salary
FROM employees e
JOIN highest h
  ON e.employee_id = h.employee_id;
  
  
select  e.first_name, e.salary, -- j.job_title, 
d.department_name, l.state_province, c.country_name, r.region_name
from 
employees e 
-- inner join jobs j on e.job_id = j.job_id
inner join departments d on e.department_id = d.department_id
inner join locations l on d.location_id = l.location_id
inner join countries c on l.country_id = c.country_id
inner join regions r on c.region_id = r.region_id;



select  e.first_name, e.salary, -- j.job_title, 
d.department_name, l.state_province, c.country_name, r.region_name
from 
employees e 
-- inner join jobs j on e.job_id = j.job_id
right join departments d on e.department_id = d.department_id
right join locations l on d.location_id = l.location_id
right join countries c on l.country_id = c.country_id
right join regions r on c.region_id = r.region_id;





-- used windows function and inner join
	-- 1. added row number partitioned by department_id and ordered by salary
    -- 2. found the average salary partitioned by department id
    -- 3. connected 2 tables employee and department

SELECT ROW_NUMBER() OVER (PARTITION BY e.department_id ORDER BY e.salary DESC) 
AS emp_row_no,e.employee_id,e.first_name, e.salary, d.department_name, d.location_id,
avg(e.salary) OVER(PARTITION BY e.department_id) AS Avg_Salary
from employees e 
inner join departments d 
on e.department_id=d.department_id;
-- -------------------------------------------------------------------------------------------

-- used windows function and inner join
	-- 1. added row number partitioned by department_id and ordered by salary
    -- 2. added RANK() function over department _id and order by salary
    -- 3. added DENSE_RANK() function over department _id and order by salary
    
SELECT ROW_NUMBER() OVER (PARTITION BY e.department_id ORDER BY e.salary DESC) 
AS emp_row_no,e.employee_id,e.first_name, e.salary, d.department_name, d.location_id,
RANK() OVER(PARTITION BY e.department_id 
ORDER BY e.salary DESC) AS emp_rank,
DENSE_RANK() OVER(PARTITION BY e.department_id 
                  ORDER BY e.salary DESC) 
                  AS emp_dense_rank
from employees e 
inner join departments d 
on e.department_id=d.department_id;

-- -------------------------------------------------------------------------------
-- Finding the second largest salary using dense_rank

-- used windows function to find the 2nd largest salary
WITH Tabel AS
(
SELECT *,
   DENSE_RANK() OVER (ORDER BY salary Desc) AS Rnk
FROM employees
)
SELECT first_name, salary
FROM Tabel
WHERE Rnk=2;

-- nth highest salary n-1

SELECT first_name, salary, department_id FROM employees 
WHERE salary= (SELECT DISTINCT(salary) 
FROM employees ORDER BY salary DESC LIMIT 6,1);

-- nth highest salary Limit n-1

SELECT * FROM employees 
WHERE salary= (SELECT DISTINCT(salary) 
FROM employees ORDER BY salary DESC LIMIT 0, 1);

SELECT first_name, salary FROM employees ORDER BY salary DESC LIMIT 12, 1;
-- -----------------------------------------------------------