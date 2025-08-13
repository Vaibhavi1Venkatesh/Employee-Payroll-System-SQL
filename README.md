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

## 🛠️ Technologies Used
- MySQL
- MySQL Workbench

## 📂 How to Run
1. Clone the repository:
```bash
git clone https://github.com/YourUsername/Employee-Payroll-System-SQL.git
```
2. Open `sql/employee_payroll_project.sql` in MySQL Workbench
3. Execute the script to:
   - Create tables
   - Insert sample data
   - Create `calculate_payroll` stored procedure
4. Run the queries for insights
