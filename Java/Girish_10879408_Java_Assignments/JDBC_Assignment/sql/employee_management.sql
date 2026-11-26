-- Run once in MySQL Workbench. Java never creates the database.
CREATE DATABASE IF NOT EXISTS employee_management;
USE employee_management;

CREATE TABLE IF NOT EXISTS department (
 department_id INT PRIMARY KEY AUTO_INCREMENT,
 department_name VARCHAR(80) NOT NULL UNIQUE,
 location VARCHAR(80) NOT NULL
);
CREATE TABLE IF NOT EXISTS employee (
 employee_id INT PRIMARY KEY AUTO_INCREMENT,
 name VARCHAR(100) NOT NULL,
 email VARCHAR(120) NOT NULL UNIQUE,
 salary DECIMAL(12,2) NOT NULL CHECK (salary >= 0),
 hire_date DATE NOT NULL,
 department_id INT NOT NULL,
 CONSTRAINT fk_employee_department FOREIGN KEY (department_id) REFERENCES department(department_id)
);
CREATE TABLE IF NOT EXISTS employee_transfer (
 transfer_id INT PRIMARY KEY AUTO_INCREMENT,
 employee_id INT NOT NULL,
 from_department_id INT NOT NULL,
 to_department_id INT NOT NULL,
 transfer_date DATE NOT NULL,
 FOREIGN KEY (employee_id) REFERENCES employee(employee_id),
 FOREIGN KEY (from_department_id) REFERENCES department(department_id),
 FOREIGN KEY (to_department_id) REFERENCES department(department_id)
);
INSERT IGNORE INTO department(department_id,department_name,location) VALUES (1,'Engineering','Bengaluru'),(2,'Human Resources','Hyderabad'),(3,'Finance','Pune');
INSERT IGNORE INTO employee(employee_id,name,email,salary,hire_date,department_id) VALUES (1,'Aarav Sharma','aarav@example.com',75000,'2024-01-15',1),(2,'Diya Patel','diya@example.com',62000,'2024-03-10',2),(3,'Kabir Rao','kabir@example.com',88000,'2023-08-01',1);

DROP PROCEDURE IF EXISTS sp_employee_summary;
DROP PROCEDURE IF EXISTS sp_department_payroll;
DELIMITER $$
CREATE PROCEDURE sp_employee_summary(IN p_employee_id INT)
BEGIN
 SELECT e.employee_id,e.name,e.email,e.salary,e.hire_date,d.department_name,d.location
 FROM employee e JOIN department d ON d.department_id=e.department_id WHERE e.employee_id=p_employee_id;
END$$
CREATE PROCEDURE sp_department_payroll(IN p_department_id INT, OUT p_total DECIMAL(14,2))
BEGIN
 SELECT COALESCE(SUM(salary),0) INTO p_total FROM employee WHERE department_id=p_department_id;
END$$
DELIMITER ;
