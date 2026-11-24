package jdbcassigment;

import java.math.BigDecimal;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;
import java.util.Optional;

/**
* @user:  10878560
*  @time:  4:23:46 pm
*  @date:  21 Nov 2026
*  @todo:  TODO
*
*
**/
public class EmployeeDaoImpl implements EmployeeDao {


	
	    @Override
	    public void addEmployee(Employee e) throws Exception {

	        String sql = """
	                INSERT INTO employee
	                (employee_id, employee_name, salary, department_id)
	                VALUES (?, ?, ?, ?)
	                """;

	        try (Connection con = DatabaseUtil.createConnection();
	             PreparedStatement ps = con.prepareStatement(sql)) {

	            ps.setInt(1, e.getId());
	            ps.setString(2, e.getName());
	            ps.setBigDecimal(3, e.getSalary());
	            ps.setInt(4, e.getDepartmentId());

	            ps.executeUpdate();

	            System.out.println("Employee added successfully.");
	        }
	    }

	    @Override
	    public void viewEmployees() throws Exception {

	        String sql = "SELECT * FROM employee ORDER BY employee_id";

	        try (Connection con = DatabaseUtil.createConnection();
	             PreparedStatement ps = con.prepareStatement(sql);
	             ResultSet rs = ps.executeQuery()) {

	            boolean found = false;

	            while (rs.next()) {

	                found = true;

	                System.out.println(
	                        rs.getInt("employee_id") + " | "
	                        + rs.getString("employee_name") + " | "
	                        + rs.getBigDecimal("salary") + " | "
	                        + rs.getInt("department_id"));
	            }

	            if (!found) {
	                System.out.println("No employees found.");
	            }
	        }
	    }

	    @Override
	    public void findEmployee(int id) throws Exception {

	        String sql = """
	                SELECT * FROM employee
	                WHERE employee_id = ?
	                """;

	        try (Connection con = DatabaseUtil.createConnection();
	             PreparedStatement ps = con.prepareStatement(sql)) {

	            ps.setInt(1, id);

	            try (ResultSet rs = ps.executeQuery()) {

	                if (rs.next()) {

	                    System.out.println(
	                            rs.getInt("employee_id") + " | "
	                            + rs.getString("employee_name") + " | "
	                            + rs.getBigDecimal("salary") + " | "
	                            + rs.getInt("department_id"));

	                } else {
	                    System.out.println("Employee not found.");
	                }
	            }
	        }
	    }

	    @Override
	    public void updateEmployee(Employee e) throws Exception {

	        String sql = """
	                UPDATE employee
	                SET employee_name = ?, salary = ?, department_id = ?
	                WHERE employee_id = ?
	                """;

	        try (Connection con = DatabaseUtil.createConnection();
	             PreparedStatement ps = con.prepareStatement(sql)) {

	            ps.setString(1, e.getName());
	            ps.setBigDecimal(2, e.getSalary());
	            ps.setInt(3, e.getDepartmentId());
	            ps.setInt(4, e.getId());

	            int rows = ps.executeUpdate();

	            System.out.println(rows > 0
	                    ? "Employee updated successfully."
	                    : "Employee not found or unchanged.");
	        }
	    }

	    @Override
	    public void deleteEmployee(int id) throws Exception {

	        String sql = "DELETE FROM employee WHERE employee_id = ?";

	        try (Connection con = DatabaseUtil.createConnection();
	             PreparedStatement ps = con.prepareStatement(sql)) {

	            ps.setInt(1, id);

	            int rows = ps.executeUpdate();

	            System.out.println(rows > 0
	                    ? "Employee deleted successfully."
	                    : "Employee not found.");
	        }
	    }

	    @Override
	    public void employeeDepartmentJoin() throws Exception {

	        String sql = """
	                SELECT e.employee_id, e.employee_name,
	                       e.salary, d.department_name
	                FROM employee e
	                INNER JOIN department d
	                ON e.department_id = d.department_id
	                ORDER BY e.employee_id
	                """;

	        try (Connection con = DatabaseUtil.createConnection();
	             PreparedStatement ps = con.prepareStatement(sql);
	             ResultSet rs = ps.executeQuery()) {

	            boolean found = false;

	            while (rs.next()) {

	                found = true;

	                System.out.println(
	                        rs.getInt("employee_id") + " | "
	                        + rs.getString("employee_name") + " | "
	                        + rs.getBigDecimal("salary") + " | "
	                        + rs.getString("department_name"));
	            }

	            if (!found) {
	                System.out.println("No employee records found.");
	            }
	        }
	    }

	    @Override
	    public void departmentEmployeeCount() throws Exception {

	        String sql = """
	                SELECT d.department_name,
	                       COUNT(e.employee_id) AS total
	                FROM department d
	                LEFT JOIN employee e
	                ON d.department_id = e.department_id
	                GROUP BY d.department_id, d.department_name
	                ORDER BY d.department_id
	                """;

	        try (Connection con = DatabaseUtil.createConnection();
	             PreparedStatement ps = con.prepareStatement(sql);
	             ResultSet rs = ps.executeQuery()) {

	            while (rs.next()) {

	                System.out.println(
	                        rs.getString("department_name") + " : "
	                        + rs.getInt("total"));
	            }
	        }
	    }

	    @Override
	    public void getEmployeeProcedure(int id) throws Exception {

			/*
			 * String sql = "{CALL GetEmployeeById(?)}";
			 * 
			 * try (Connection con = DatabaseUtil.createConnection(); CallableStatement cs =
			 * con.prepareCall(sql)) {
			 * 
			 * cs.setInt(1, id);
			 * 
			 * try (ResultSet rs = cs.executeQuery()) {
			 * 
			 * if (rs.next()) {
			 * 
			 * System.out.println( rs.getInt("employee_id") + " | " +
			 * rs.getString("employee_name") + " | " + rs.getBigDecimal("salary") + " | " +
			 * rs.getInt("department_id"));
			 * 
			 * } else { System.out.println("Employee not found."); } } }
			 */	    }

	    @Override
	    public void getDepartmentProcedure(int departmentId)
	            throws Exception {

			/*
			 * String sql = "{CALL GetEmployeesByDepartment(?)}";
			 * 
			 * try (Connection con = DatabaseUtil.createConnection(); CallableStatement cs =
			 * con.prepareCall(sql)) {
			 * 
			 * cs.setInt(1, departmentId);
			 * 
			 * try (ResultSet rs = cs.executeQuery()) {
			 * 
			 * boolean found = false;
			 * 
			 * while (rs.next()) {
			 * 
			 * found = true;
			 * 
			 * System.out.println( rs.getInt("employee_id") + " | " +
			 * rs.getString("employee_name") + " | " + rs.getBigDecimal("salary") + " | " +
			 * rs.getInt("department_id")); }
			 * 
			 * if (!found) { System.out.println( "No employees found in this department.");
			 * } } }
			 */
	    }

	    @Override
	    public void transferEmployee(int employeeId, int departmentId)
	            throws Exception {

	        String sql = """
	                UPDATE employee
	                SET department_id = ?
	                WHERE employee_id = ?
	                """;

	        try (Connection con = DatabaseUtil.createConnection()) {

	            con.setAutoCommit(false);

	            try (PreparedStatement ps = con.prepareStatement(sql)) {

	                ps.setInt(1, departmentId);
	                ps.setInt(2, employeeId);

	                int rows = ps.executeUpdate();

	                if (rows == 0) {
	                    con.rollback();
	                    System.out.println("Employee not found.");
	                    return;
	                }

	                con.commit();
	                System.out.println("Employee transferred successfully.");

	            } catch (SQLException e) {

	                try {
	                    con.rollback();
	                } catch (SQLException rollbackError) {
	                    e.addSuppressed(rollbackError);
	                }

	                throw e;
	            }
	        }
	    }

	    @Override
	    public void salaryTransaction(int fromId, int toId,
	                                  BigDecimal amount) throws Exception {

	        if (fromId == toId) {
	            throw new IllegalArgumentException(
	                    "Source and destination employees must differ.");
	        }

	        if (amount == null || amount.signum() <= 0
	                || amount.scale() > 2) {
	            throw new IllegalArgumentException(
	                    "Amount must be positive with at most two decimals.");
	        }

	        String deduct = """
	                UPDATE employee
	                SET salary = salary - ?
	                WHERE employee_id = ? AND salary >= ?
	                """;

	        String credit = """
	                UPDATE employee
	                SET salary = salary + ?
	                WHERE employee_id = ?
	                  AND salary <= 9999999999.99 - ?
	                """;

	        try (Connection con = DatabaseUtil.createConnection()) {

	            con.setAutoCommit(false);

	            try (PreparedStatement ps1 = con.prepareStatement(deduct);
	                 PreparedStatement ps2 = con.prepareStatement(credit)) {

	                ps1.setBigDecimal(1, amount);
	                ps1.setInt(2, fromId);
	                ps1.setBigDecimal(3, amount);

	                int debitRows = ps1.executeUpdate();

	                if (debitRows != 1) {
	                    throw new SQLException(
	                            "Source employee missing or insufficient salary.");
	                }

	                ps2.setBigDecimal(1, amount);
	                ps2.setInt(2, toId);
	                ps2.setBigDecimal(3, amount);

	                int creditRows = ps2.executeUpdate();

	                if (creditRows != 1) {
	                    throw new SQLException(
	                            "Destination employee missing or salary limit exceeded.");
	                }

	                con.commit();

	                System.out.println("Transaction committed successfully.");

	            } catch (SQLException e) {

	                try {
	                    con.rollback();
	                } catch (SQLException rollbackError) {
	                    e.addSuppressed(rollbackError);
	                }

	                System.out.println("Transaction failed. Rollback attempted.");
	                throw e;
	            }
	        }
	    }

	    @Override
	    public void batchInsert(List<Employee> employees)
	            throws Exception {

	        if (employees == null || employees.isEmpty()) {
	            throw new IllegalArgumentException(
	                    "Employee batch cannot be empty.");
	        }

	        String sql = """
	                INSERT INTO employee
	                (employee_id, employee_name, salary, department_id)
	                VALUES (?, ?, ?, ?)
	                """;

	        try (Connection con = DatabaseUtil.createConnection()) {

	            con.setAutoCommit(false);

	            try (PreparedStatement ps = con.prepareStatement(sql)) {

	                for (Employee e : employees) {

	                    ps.setInt(1, e.getId());
	                    ps.setString(2, e.getName());
	                    ps.setBigDecimal(3, e.getSalary());
	                    ps.setInt(4, e.getDepartmentId());

	                    ps.addBatch();
	                }

	                int[] results = ps.executeBatch();

	                for (int result : results) {
	                    if (result == Statement.EXECUTE_FAILED) {
	                        throw new SQLException("Batch insert failed.");
	                    }
	                }

	                con.commit();

	                System.out.println(
	                        results.length + " employees inserted successfully.");

	            } catch (SQLException e) {

	                try {
	                    con.rollback();
	                } catch (SQLException rollbackError) {
	                    e.addSuppressed(rollbackError);
	                }

	                System.out.println("Batch failed. Rollback attempted.");
	                throw e;
	            }
	        }
	    }

	    @Override
	    public void searchBySalary(BigDecimal salary) throws Exception {

	        String sql = """
	                SELECT * FROM employee
	                WHERE salary >= ?
	                ORDER BY salary DESC
	                """;

	        try (Connection con = DatabaseUtil.createConnection();
	             PreparedStatement ps = con.prepareStatement(sql)) {

	            ps.setBigDecimal(1, salary);

	            try (ResultSet rs = ps.executeQuery()) {

	                boolean found = false;

	                while (rs.next()) {

	                    found = true;

	                    System.out.println(
	                            rs.getInt("employee_id") + " | "
	                            + rs.getString("employee_name") + " | "
	                            + rs.getBigDecimal("salary") + " | "
	                            + rs.getInt("department_id"));
	                }

	                if (!found) {
	                    System.out.println("No matching employees found.");
	                }
	            }
	        }
	    }

		
			
		
	
}
