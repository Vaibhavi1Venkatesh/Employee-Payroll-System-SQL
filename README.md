# Employee-Payroll-System-SQL
This project is a comprehensive Employee Performance and Payroll Management System developed using MySQL.
It's designed to demonstrate an end-to-end understanding of database principles and their application in a business context.

## 📌 Project Overview
This system manages and analyzes employee data, including performance reviews and automated payroll processing.

It highlights:
- Database design best practices (normalization, relationships, constraints)
- Stored procedure automation
- Data analytics with SQL queries

## 🚀 Key Features
- Normalized Database Schema — prevents redundancy & ensures data integrity
- Automated Payroll Processing — `calculate_payroll` stored procedure
- Data-Driven Insights — analytical queries for performance, payroll, and salary fairness

## 💾 Database Schema
| Table Name           | Description |
|----------------------|-------------|
| **departments**      | Stores department information |
| **employees**        | Employee details linked to departments |
| **performance_reviews** | Review scores and comments |
| **payrolls**         | Payroll records with base salary, deductions, and net pay |
| **deductions** *(future)* | Payroll deduction details |
| **bonuses** *(future)*    | Bonus award details |

<img width="449" height="252" alt="departments" src="https://github.com/user-attachments/assets/a5ce502c-9fd5-4495-ad1b-724a5afbde56" />

<img width="897" height="255" alt="payrol table" src="https://github.com/user-attachments/assets/def00ea6-2355-4fd0-ade7-509ae9da813c" />

<img width="1056" height="286" alt="employees" src="https://github.com/user-attachments/assets/7a8c210d-dcf3-44f5-ac86-37d54d28e6cc" />

<img width="887" height="273" alt="performance review" src="https://github.com/user-attachments/assets/cdbe8142-980e-4793-8285-0b8b947ec0fb" />


## 📈 Key Reports & Analytics

### 1. Average Performance Score by Department
```sql
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
```
<img width="440" height="152" alt="query1" src="https://github.com/user-attachments/assets/b33687e0-a387-43d9-b5da-5033a1b3647b" />


### 2. Total Monthly Payroll by Department
```sql
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
```
<img width="643" height="234" alt="query2" src="https://github.com/user-attachments/assets/8a287cf3-b42c-4c24-8a88-1583240c8031" />


### 3. Employees with Below-Average Department Salary
```sql
SELECT
    first_name,
    last_name,
    salary,
    (SELECT AVG(salary) FROM employees WHERE department_id = e.department_id) AS department_average
FROM
    employees e
WHERE
    salary < (SELECT AVG(salary) FROM employees WHERE department_id = e.department_id);
```
<img width="704" height="177" alt="query3" src="https://github.com/user-attachments/assets/cab79a2e-7ecc-4eab-95c8-964adb34c906" />

## 🛠️ Technologies Used
- MySQL
- MySQL Workbench


