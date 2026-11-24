package jdbcassigment;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

/**
* @user:  10878560
*  @time:  4:41:47 pm
*  @date:  21 Nov 2026
*  @todo:  TODO
*
*
**/
public class EmployeeMain {
	

	    public static void main(String[] args) throws Exception {

	        
	        try (Connection con = DatabaseUtil.createConnection()) {
	            System.out.println("Database connected successfully.");
	        } catch (SQLException e) {
	            System.out.println("Connection failed: " + e.getMessage());
	            return;
	        }
	        EmployeeService service = new EmployeeService();
	        Scanner sc = new Scanner(System.in);

	        while (true) {

	            System.out.println("\n===== EMPLOYEE MANAGEMENT =====");
	            System.out.println("1. Add Employee");
	            System.out.println("2. View Employees");
	            System.out.println("3. Find Employee");
	            System.out.println("4. Update Employee");
	            System.out.println("5. Delete Employee");
	            System.out.println("6. Employee Department JOIN");
	            System.out.println("7. Department Employee Count");
	            System.out.println("8. Employee Stored Procedure");
	            System.out.println("9. Department Stored Procedure");
	            System.out.println("10. Transfer Employee");
	            System.out.println("11. Transaction Demo");
	            System.out.println("12. Batch Insert");
	            System.out.println("13. Search By Salary");
	            System.out.println("14. Exit");

	            System.out.print("Enter choice: ");

	            try {

	                int choice = Integer.parseInt(sc.nextLine().trim());

	                switch (choice) {

	                    case 1, 4 -> {

	                        System.out.print("Employee ID: ");
	                        int id = Integer.parseInt(sc.nextLine().trim());

	                        System.out.print("Employee Name: ");
	                        String name = sc.nextLine();

	                        System.out.print("Salary: ");
	                        BigDecimal salary =
	                                new BigDecimal(sc.nextLine().trim());

	                        System.out.print("Department ID: ");
	                        int deptId = Integer.parseInt(sc.nextLine().trim());

	                        Employee e =
	                                new Employee(id, name, salary, deptId);

	                        if (choice == 1)
	                            service.addEmployee(e);
	                        else
	                            service.updateEmployee(e);
	                    }

	                    case 2 -> service.viewEmployees();

	                    case 3 -> {

	                        System.out.print("Employee ID: ");
	                        int id = Integer.parseInt(sc.nextLine().trim());

	                        service.findEmployee(id);
	                    }

	                    case 5 -> {

	                        System.out.print("Employee ID: ");
	                        int id = Integer.parseInt(sc.nextLine().trim());

	                        service.deleteEmployee(id);
	                    }

	                    case 6 -> service.employeeDepartmentJoin();

	                    case 7 -> service.departmentEmployeeCount();

	                    case 8 -> {

	                        System.out.print("Employee ID: ");
	                        int id = Integer.parseInt(sc.nextLine().trim());

	                        service.getEmployeeProcedure(id);
	                    }

	                    case 9 -> {

	                        System.out.print("Department ID: ");
	                        int id = Integer.parseInt(sc.nextLine().trim());

	                        service.getDepartmentProcedure(id);
	                    }

	                    case 10 -> {

	                        System.out.print("Employee ID: ");
	                        int id = Integer.parseInt(sc.nextLine().trim());

	                        System.out.print("New Department ID: ");
	                        int deptId = Integer.parseInt(sc.nextLine().trim());

	                        service.transferEmployee(id, deptId);
	                    }

	                    case 11 -> {

	                        System.out.print("Source Employee ID: ");
	                        int from = Integer.parseInt(sc.nextLine().trim());

	                        System.out.print("Destination Employee ID: ");
	                        int to = Integer.parseInt(sc.nextLine().trim());

	                        System.out.print("Amount: ");
	                        BigDecimal amount =
	                                new BigDecimal(sc.nextLine().trim());

	                        service.salaryTransaction(from, to, amount);
	                    }

	                    case 12 -> {

	                        System.out.print("Number of employees: ");
	                        int count = Integer.parseInt(sc.nextLine().trim());

	                        if (count <= 0 || count > 1000)
	                            throw new IllegalArgumentException(
	                                    "Batch count must be between 1 and 1000");

	                        List<Employee> employees = new ArrayList<>();

	                        for (int i = 0; i < count; i++) {

	                            System.out.println("Employee " + (i + 1));

	                            System.out.print("ID: ");
	                            int id = Integer.parseInt(sc.nextLine().trim());

	                            System.out.print("Name: ");
	                            String name = sc.nextLine();

	                            System.out.print("Salary: ");
	                            BigDecimal salary =
	                                    new BigDecimal(sc.nextLine().trim());

	                            System.out.print("Department ID: ");
	                            int deptId =
	                                    Integer.parseInt(sc.nextLine().trim());

	                            employees.add(
	                                    new Employee(id, name, salary, deptId));
	                        }

	                        service.batchInsert(employees);
	                    }

	                    case 13 -> {

	                        System.out.print("Minimum Salary: ");

	                        BigDecimal salary =
	                                new BigDecimal(sc.nextLine().trim());

	                        service.searchBySalary(salary);
	                    }

	                    case 14 -> {
	                        System.out.println("Application closed.");
	                        sc.close();
	                        return;
	                    }

	                    default -> System.out.println("Invalid menu choice.");
	                }

	            } catch (NumberFormatException e) {

	                System.out.println(
	                        "Invalid number. Please enter correct input.");

	            } catch (IllegalArgumentException e) {

	                System.out.println(
	                        "Validation error: " + e.getMessage());

	            } catch (SQLException e) {

	                if (e.getErrorCode() == 1062) {
	                    System.out.println("Duplicate employee ID.");

	                } else if (e.getErrorCode() == 1451
	                        || e.getErrorCode() == 1452) {
	                    System.out.println("Foreign key constraint violation.");

	                } else if (e.getSQLState() != null
	                        && e.getSQLState().startsWith("08")) {
	                    System.out.println("Database connection error.");

	                } else if (e.getErrorCode() == 1045) {
	                    System.out.println("Invalid database credentials.");

	                } else {
	                    System.out.println(
	                            "Database error: " + e.getMessage());
	                }

	            } catch (java.util.NoSuchElementException e) {

	                System.out.println("Input closed. Exiting.");
	                sc.close();
	                return;
	            }
	        }
	    }
	}

