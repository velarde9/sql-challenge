ALTER DATABASE "SQL_challenge" SET datestyle TO "ISO, MDY";

-- Create Title Table
CREATE TABLE titles (
	title_id VARCHAR PRIMARY KEY NOT NULL,
	title VARCHAR
);
	
-- Employees table
CREATE TABLE employees (
	emp_no INT PRIMARY KEY NOT NULL,
	emp_title VARCHAR,
	birth_date DATE,
	first_name VARCHAR,
	last_name VARCHAR,
	sex CHAR,
	hire_date DATE,
	FOREIGN KEY (emp_title) REFERENCES titles(title_id)
);

-- Salaries Table
CREATE TABLE salaries (
	emp_no INT PRIMARY KEY NOT NULL,
	salary INT,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

-- Departments table
CREATE TABLE departments (
	dept_no VARCHAR PRIMARY KEY NOT NULL,
	dept_name VARCHAR
);

-- Dept_emp table
CREATE TABLE dept_emp (
	emp_no INT NOT NULL,
	dept_no VARCHAR NOT NULL,
	PRIMARY KEY(emp_no, dept_no),
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no)
);

-- dept_manager table
CREATE TABLE dept_manager (
	dept_no VARCHAR NOT NULL,
	emp_no INT NOT NULL,
	PRIMARY KEY(dept_no, emp_no),
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no)
);


-- DATA ANALYSIS

-- 1. List the employee number, last name, first name, sex, and salary of each employee.
SELECT e.emp_no, last_name, first_name, sex, salary
	FROM employees e
	INNER JOIN salaries s
	ON e.emp_no = s.emp_no;

-- 2. List the first name, last name, and hire date for the employees who were hired in 1986.
SELECT first_name, last_name, hire_date
	FROM employees
	WHERE DATE_PART('year', hire_date) = 1986;

-- 3. List the manager of each department along with their department number, department name, employee number, last name, and first name.
SELECT dm.dept_no, dept_name, dm.emp_no, last_name, first_name
	FROM dept_manager dm
	INNER JOIN departments d
	ON dm.dept_no = d.dept_no
	
	INNER JOIN employees e
	ON dm.emp_no = e.emp_no;
-- 4. List the department number for each employee along with that employee’s employee number, last name, first name, and department name.
SELECT de.dept_no, de.emp_no, last_name, first_name, dept_name
	FROM dept_emp de
	INNER JOIN employees e
	ON de.emp_no = e.emp_no
	
	INNER JOIN departments d
	ON de.dept_no = d.dept_no;

-- 5. List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.
SELECT first_name, last_name, sex
	FROM employees
	WHERE first_name = 'Hercules'
	AND last_name LIKE 'B%';

-- 6. List each employee in the Sales department, including their employee number, last name, and first name.
SELECT emp_no, last_name, first_name
	FROM employees
	WHERE emp_no IN
	(SELECT emp_no FROM dept_emp
	 WHERE dept_no = 
	 
	 (SELECT dept_no FROM departments
	  WHERE dept_name = 'Sales'
	 )	
);

-- 7. List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name.
SELECT emp_no, last_name, first_name
	FROM employees
	WHERE emp_no IN
	(SELECT emp_no FROM dept_emp
	 WHERE dept_no IN 
	 
	 (SELECT dept_no FROM departments
	  WHERE dept_name = 'Sales'
	  OR dept_name = 'Development'
	 )	
);

SELECT dept_no FROM departments
	  WHERE dept_name = 'Sales'
	  OR dept_name = 'Development'
-- 8. List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name).
SELECT last_name, COUNT(last_name) AS "frequency count"
	FROM employees
	GROUP BY last_name
	ORDER BY "frequency count" DESC;
	
	