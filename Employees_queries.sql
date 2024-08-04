/* Questions about the Company */
-- * What is the average salary in the Company?
    SELECT avg(salary) FROM salaries;
    --Output: 63810.74

-- * What are the titles in the company?
    SELECT DISTINCT title FROM titles;
    --Output:
    --    title
    -- --------------------
    --  Assistant Engineer
    --  Engineer
    --  Manager
    --  Senior Engineer
    --  Senior Staff
    --  Staff
    --  Technique Leader    


/*	Questions about Employees Information */
-- * When Elvis Demeyer was hired?
    SELECT first_name, last_name, hire_date FROM employees
    WHERE first_name = 'Elvis' AND last_name = 'Demeyer';
    --Output: 1994-02-17

-- * What is the age of youngest and the oldest employee in the company?
    SELECT MIN(AGE(birth_date)) AS "Youngest employee age", MAX(AGE(birth_date)) as "Oldest employee age" FROM employees;
    --Output: 59 years 5 mons 20 days and 72 years 5 mons 20 days

-- * List of all employees working longer than 30 years:
    SELECT distinct emp_no, first_name, last_name, hire_date
    FROM employees
    WHERE EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM hire_date) > 30;
    --Output: few examples below
    --emp_no |   first_name   |    last_name     | hire_date
    ---------+----------------+------------------+------------
    -- 33812 | Patricio       | Basawa           | 1986-04-09
    -- 53192 | Menkae         | Savasere         | 1985-12-14
    -- 74659 | Lihong         | Malabarba        | 1991-01-10
    -- 50591 | Rimli          | Wixon            | 1991-03-16
    -- 36853 | Yannis         | Speek            | 1989-06-10
    -- 87568 | Erez           | Usery            | 1987-08-12
    -- 70811 | Aris           | Cherinka         | 1991-02-04

-- * Retrieve employee details (employee number, first name, last name, department, current salary, average salary) 
-- for employees whose current salary exceeds the overall average salary of all employees.

WITH 
  current_salaries AS (
      SELECT e.emp_no, e.first_name, e.last_name, d.dept_name, s.salary
      FROM employees AS e
      INNER JOIN dept_emp AS de ON e.emp_no = de.emp_no
      INNER JOIN departments AS d ON de.dept_no = d.dept_no
      INNER JOIN salaries AS s ON e.emp_no = s.emp_no
      WHERE s.from_date <= CURRENT_DATE AND s.to_date >= CURRENT_DATE AND 
      de.from_date <= CURRENT_DATE AND de.to_date >= CURRENT_DATE
    ),

  average_salary AS (
      SELECT ROUND(AVG(salary), 2) AS avg_salary
      FROM current_salaries)
    
SELECT cs.emp_no as "Employee no", cs.first_name as "Name", cs.last_name as "Last name", cs.dept_name as "Department",
 cs.salary as "Current salary", avs.avg_salary as "Average salary"
FROM current_salaries AS cs
CROSS JOIN average_salary AS avs
WHERE cs.salary > avs.avg_salary
ORDER BY cs.emp_no;

--OUTPUT:
--  Employee no |      Name      |    Last name     |     Department     | Current salary | Average salary
-- -------------+----------------+------------------+--------------------+----------------+----------------
--        10001 | Georgi         | Facello          | Development        |          88958 |       72012.24
--        10002 | Bezalel        | Simmel           | Sales              |          72527 |       72012.24
--        10004 | Chirstian      | Koblick          | Production         |          74057 |       72012.24
--        10005 | Kyoichi        | Maliniak         | Human Resources    |          94692 |       72012.24
--        10007 | Tzvetan        | Zielinski        | Research           |          88070 |       72012.24
--        10009 | Sumant         | Peac             | Quality Management |          94409 |       72012.24
--        10010 | Duangkaew      | Piveteau         | Quality Management |          80324 |       72012.24
--        10016 | Kazuhito       | Cappelletti      | Sales              |          77935 |       72012.24
--        10017 | Cristinel      | Bouloucos        | Marketing          |          99651 |       72012.24
--        10018 | Kazuhide       | Peha             | Production         |          84672 |       72012.24
--        10024 | Suzette        | Pettey           | Production         |          96646 |       72012.24
--        10029 | Otmar          | Herbst           | Quality Management |          77777 |       72012.24
--        10030 | Elvis          | Demeyer          | Production         |          88806 |       72012.24
--        10040 | Weiyi          | Meriste          | Research           |          72668 |       72012.24
----more data exists----

--** Also, validating if only one record exists for employee and there is no situation like below:
--emp_id   salary   from          to
--12       20000    2020-01-01    2025-01-01
--12       60000    2023-01-01    9999-01-01

WITH 
record_count AS (
SELECT emp_no, COUNT(*) AS rec_count
FROM salaries
WHERE to_date >= CURRENT_DATE
GROUP BY emp_no)

SELECT emp_no, rec_count FROM record_count
where rec_count>1;

/* Questions about Dates */
-- * When the oldest person born in the company?
    SELECT min(birth_date) as "Birth_year" FROM employees;
    --Output: 1952-02-01


/* Questions about Hiring */
-- * How many employees where hired on January, 1990?
    SELECT count(emp_no) FROM employees
    WHERE EXTRACT (YEAR FROM hire_date) = 1990 and EXTRACT (MONTH FROM hire_date) = 1;
    --Output: 2244

-- * How many people were hired on each hiring date?
    SELECT hire_date, count(emp_no) as "Amount" employees
    Group BY hire_date
    ORDER BY "Amount" DESC;
    --Output: 5 biggest values:
    --  hire_date  | Amount
    -- ------------+--------
    -- 1985-06-20 |    132
    -- 1985-03-21 |    131
    -- 1985-08-08 |    128
    -- 1985-03-24 |    128
    -- 1985-05-24 |    127
 
-- * How many employees are hired after 1993 and have "Senior" level in their title?
    SELECT COUNT(e.emp_no)
    FROM employees as e
    INNER JOIN titles as t USING (emp_no)
    where EXTRACT (YEAR FROM e.hire_date) > 1993 and t.title LIKE 'Senior%';
    --Output: 17200

/* Questions about Departments: */
-- * How many people are working per department?
    SELECT d.dept_name, count(de.emp_no) as "Total Employees" 
    FROM dept_emp as de
    INNER JOIN departments as d USING (dept_no)
    Group By d.dept_name
    Order BY d.dept_name;
    --Output:
    --     dept_name      | Total Employees
    -- -------------------+-----------------
    -- Customer Service   |           23580
    -- Development        |           85707
    -- Finance            |           17346
    -- Human Resources    |           17786
    -- Marketing          |           20211
    -- Production         |           73485
    -- Quality Management |           20117
    -- Research           |           21126
    -- Sales              |           52245

-- * What is the average salary per department?
WITH current_salary as (
  SELECT s.emp_no, s.salary
  FROM salaries AS s
  WHERE s.from_date <= CURRENT_DATE
  AND s.to_date >= CURRENT_DATE
)

SELECT d.dept_name as "Department name", ROUND(AVG(cs.salary), 2) as "Average Salary" 
FROM current_salary as cs
INNER JOIN employees AS e ON cs.emp_no = e.emp_no
INNER JOIN dept_emp as de ON e.emp_no = de.emp_no
INNER JOIN departments as d ON de.dept_no = d.dept_no
WHERE de.from_date <= CURRENT_DATE AND de.to_date >= CURRENT_DATE
GROUP BY d.dept_name
ORDER BY "Average Salary" DESC;

--OUTPUT:
--   Department name   | Average Salary
-- --------------------+----------------
--  Sales              |       88852.97
--  Marketing          |       80058.85
--  Finance            |       78559.94
--  Research           |       67913.37
--  Production         |       67843.30
--  Development        |       67657.92
--  Customer Service   |       67285.23
--  Quality Management |       65441.99
--  Human Resources    |       63921.90

-- * Calculate and compare each employee's salary to the average salary within their department.

WITH current_salary as (
  SELECT s.emp_no, s.salary
  FROM salaries AS s
  WHERE s.from_date <= CURRENT_DATE
  AND s.to_date >= CURRENT_DATE
)

SELECT cs.emp_no as "Employee no", e.first_name as "First name", e.last_name as "Last name", cs.salary as "Salary", d.dept_name as "Department",
 ROUND(avg(cs.salary) OVER (Partition BY d.dept_name), 2) as "Average salary per dep"
from current_salary as cs
INNER JOIN employees AS e ON cs.emp_no = e.emp_no
INNER JOIN dept_emp as de ON e.emp_no = de.emp_no
INNER JOIN departments as d ON de.dept_no = d.dept_no
WHERE de.from_date <= CURRENT_DATE AND de.to_date >= CURRENT_DATE
ORDER BY cs.emp_no;

--OUTPUT:
--  Employee no |   First name   |    Last name     | Salary |     Department     | Average salary per dep
-- -------------+----------------+------------------+--------+--------------------+------------------------
--        10001 | Georgi         | Facello          |  88958 | Development        |               67657.92
--        10002 | Bezalel        | Simmel           |  72527 | Sales              |               88852.97
--        10003 | Parto          | Bamford          |  43311 | Production         |               67843.30
--        10004 | Chirstian      | Koblick          |  74057 | Production         |               67843.30
--        10005 | Kyoichi        | Maliniak         |  94692 | Human Resources    |               63921.90
--        10006 | Anneke         | Preusig          |  59755 | Development        |               67657.92
--        10007 | Tzvetan        | Zielinski        |  88070 | Research           |               67913.37
--        10009 | Sumant         | Peac             |  94409 | Quality Management |               65441.99
--        10010 | Duangkaew      | Piveteau         |  80324 | Quality Management |               65441.99
----more data exits ----


-- * List all the employees in the Sales department who have been working from date to the present.
-- (Assuming that placeholder 9999-01-01 means employees are still working)
    SELECT de.emp_no, d.dept_name, de.from_date, de.to_date
    FROM dept_emp as de
    INNER JOIN departments as d USING (dept_no)
    where d.dept_name = 'Sales' and de.to_date = '9999-01-01';
    -- Output: few examples:
    -- emp_no | dept_name | from_date  |  to_date
    -- ------+-----------+------------+------------
    -- 10002 | Sales     | 1996-08-03 | 9999-01-01
    -- 10016 | Sales     | 1998-02-11 | 9999-01-01
    -- 10041 | Sales     | 1989-11-12 | 9999-01-01
    -- 10050 | Sales     | 1992-11-05 | 9999-01-01
    -- 10053 | Sales     | 1994-11-13 | 9999-01-01
    --Total records: 37701



