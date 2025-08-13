CREATE DATABASE IF NOT EXISTS employee_payroll_system;
USE employee_payroll_system;
CREATE TABLE IF NOT EXISTS departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL,
    location VARCHAR(100)
);
CREATE TABLE IF NOT EXISTS employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    hire_date DATE,
    job_title VARCHAR(100),
    department_id INT,
    salary DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

CREATE TABLE IF NOT EXISTS performance_reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT,
    review_date DATE NOT NULL,
    reviewer_id INT,
    score INT CHECK (score BETWEEN 1 AND 5),
    comments TEXT,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (reviewer_id) REFERENCES employees(employee_id)
);

CREATE TABLE IF NOT EXISTS payrolls (
    payroll_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT,
    pay_date DATE NOT NULL,
    base_salary DECIMAL(10, 2) NOT NULL,
    total_deductions DECIMAL(10, 2),
    total_bonuses DECIMAL(10, 2),
    net_pay DECIMAL(10, 2),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

CREATE TABLE IF NOT EXISTS deductions (
    deduction_id INT PRIMARY KEY AUTO_INCREMENT,
    payroll_id INT,
    deduction_type VARCHAR(50) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (payroll_id) REFERENCES payrolls(payroll_id)
);

CREATE TABLE IF NOT EXISTS bonuses (
    bonus_id INT PRIMARY KEY AUTO_INCREMENT,
    payroll_id INT,
    bonus_type VARCHAR(50) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (payroll_id) REFERENCES payrolls(payroll_id)
);

INSERT INTO departments (department_name, location) VALUES
('Sales', 'New York'),
('Engineering', 'San Francisco');

INSERT INTO employees (first_name, last_name, email, hire_date, job_title, department_id, salary) VALUES
('John', 'Doe', 'john.doe@example.com', '2022-01-15', 'Sales Manager', 1, 60000.00),
('Jane', 'Smith', 'jane.smith@example.com', '2021-05-20', 'Software Engineer', 2, 85000.00),
('Alice', 'Williams', 'alice.williams@example.com', '2023-03-10', 'Data Analyst', 2, 72000.00),
('Bob', 'Johnson', 'bob.johnson@example.com', '2022-07-01', 'Sales Representative', 1, 55000.00);

INSERT INTO performance_reviews (employee_id, review_date, reviewer_id, score, comments) VALUES
(1, '2023-01-10', 2, 4, 'Exceeded expectations on a key project.'),
(1, '2024-01-10', 2, 5, 'Consistently a top performer and mentor.'),
(2, '2023-03-25', 1, 3, 'Met all core objectives for the quarter.'),
(3, '2024-02-05', 2, 5, 'Excellent problem-solving skills and fast learner.');

DELIMITER $$
CREATE PROCEDURE calculate_payroll(IN emp_id INT, IN p_date DATE)
BEGIN
    DECLARE v_base_salary DECIMAL(10, 2);
    DECLARE v_total_deductions DECIMAL(10, 2);
    DECLARE v_total_bonuses DECIMAL(10, 2);
    DECLARE v_net_pay DECIMAL(10, 2);

    -- Get the employee's current base salary
    SELECT salary INTO v_base_salary FROM employees WHERE employee_id = emp_id;

    -- Example: Calculate a flat 20% tax deduction
    SET v_total_deductions = v_base_salary * 0.20;


    -- Example: Check for a bonus based on a recent high performance score (e.g., score of 5)
    SET v_total_bonuses = 0;
    SELECT SUM(CASE WHEN score = 5 THEN 500 ELSE 0 END) INTO v_total_bonuses
    FROM performance_reviews
    WHERE employee_id = emp_id AND review_date >= DATE_SUB(p_date, INTERVAL 6 MONTH);
    -- This is a simple example. You can add more complex bonus logic here.

    -- Calculate the final net pay
    SET v_net_pay = (v_base_salary + v_total_bonuses) - v_total_deductions;

    -- Insert the new payroll record
    INSERT INTO payrolls (employee_id, pay_date, base_salary, total_deductions, total_bonuses, net_pay)
    VALUES (emp_id, p_date, v_base_salary, v_total_deductions, v_total_bonuses, v_net_pay);
END $$
DELIMITER ;

CALL calculate_payroll(1, '2025-08-31');
CALL calculate_payroll(2, '2025-08-31');
CALL calculate_payroll(3, '2025-08-31');
CALL calculate_payroll(4, '2025-08-31');

-- Query 1: Find the average performance score for each department
-- This helps in department-level performance analysis.
SELECT
    d.department_name,
    AVG(pr.score) AS average_score
FROM
    employees e
JOIN
    departments d ON e.department_id = d.department_id
JOIN
    performance_reviews pr ON e.employee_id = pr.employee_id
GROUP BY
    d.department_name
ORDER BY
    average_score DESC;
    
-- Query 2: Find the total net pay for each department for the most recent payroll date
-- This provides a quick financial overview per department.
SELECT
    d.department_name,
    SUM(p.net_pay) AS total_monthly_payroll
FROM
    payrolls p
JOIN
    employees e ON p.employee_id = e.employee_id
JOIN
    departments d ON e.department_id = d.department_id
WHERE
    p.pay_date = '2025-08-31'
GROUP BY
    d.department_name;
    
-- Query 3: Identify employees whose salary is below their department's average
-- This uses a subquery to compare an employee's salary to the departmental average.
SELECT
    first_name,
    last_name,
    salary,
    (SELECT AVG(salary) FROM employees WHERE department_id = e.department_id) AS department_average
FROM
    employees e
WHERE
    salary < (SELECT AVG(salary) FROM employees WHERE department_id = e.department_id);
