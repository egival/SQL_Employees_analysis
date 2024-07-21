/*	Questions level - Easy */

-- 1. What is the average salary for the company?

    SELECT avg(salary) FROM salaries;
    --Output: 63810.74

-- 2. When the oldest person born in the company?

    SELECT min(birth_date) as "Birth_year" FROM employees;
    --Output: 1952-02-01

-- 3. What is the age of youngest and oldest employee in the company?

    SELECT MIN(AGE(birth_date)) AS "Youngest employee age", MAX(AGE(birth_date)) as "Oldest employee age" FROM employees;
    --Output: 59 years 5 mons 20 days and 72 years 5 mons 20 days

-- 4. List of all employees working longer than 30 years:

    SELECT distinct emp_no, first_name, last_name, hire_date
    FROM employees
    WHERE EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM hire_date) > 30;
    --Output: lentele Q4


 How many people earn less than company average 63810.74?

