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
    WHERE EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM hire_date) > 30
    LIMIT 7;
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
    ORDER BY "Amount" DESC
    LIMIT 5;
    --Output: 5 biggest values:
    --  hire_date  | Amount
    -- ------------+--------
    -- 1985-06-20 |    132
    -- 1985-03-21 |    131
    -- 1985-08-08 |    128
    -- 1985-03-24 |    128
    -- 1985-05-24 |    127
 
-- * Count all employees who were hired after 1993 and have "Senior" level in their title
    SELECT COUNT(e.emp_no)
    FROM employees as e
    JOIN titles as t USING (emp_no)
    where EXTRACT (YEAR FROM e.hire_date) > 1993 and t.title LIKE 'Senior%';
    --Output: 17200

/* Questions about Departments: */
-- * How many people are working per department?
    SELECT d.dept_name, count(de.emp_no) as "Total Employees" 
    FROM dept_emp as de
    Join departments as d USING (dept_no)
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
    SELECT d.dept_name as "Department name", ROUND(AVG(s.salary), 2) as "Average Salary" 
    FROM departments as d
    JOIN dept_emp as de USING (dept_no)
    JOIN salaries AS s USING (emp_no)
    GROUP BY d.dept_name
    ORDER BY "Average Salary" DESC;
    --Output:
    --  Department name   | Average Salary
    -- -------------------+----------------
    -- Sales              |       80667.61
    -- Marketing          |       71913.20
    -- Finance            |       70489.36
    -- Research           |       59665.18
    -- Production         |       59605.48
    -- Development        |       59478.90
    -- Customer Service   |       58770.37
    -- Quality Management |       57251.27
    -- Human Resources    |       55574.88

-- * List all the employees in the Sales department who have been working from date to the present.
-- (Assuming that placeholder 9999-01-01 means employees are still working)
    SELECT de.emp_no, d.dept_name, de.from_date, de.to_date
    FROM dept_emp as de
    JOIN departments as d USING (dept_no)
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

