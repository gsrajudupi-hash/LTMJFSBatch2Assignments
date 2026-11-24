package jdbcassigment;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

/**
* @user:  10878560
*  @time:  4:22:17 pm
*  @date:  21 Nov 2026
*  @todo:  TODO
*
*
**/
public interface EmployeeDao {
	 void addEmployee(Employee employee) throws Exception;

	    void viewEmployees() throws  Exception;

	    void findEmployee(int id) throws  Exception;

	    void updateEmployee(Employee employee) throws Exception;

	    void deleteEmployee(int id) throws  Exception;

	    void employeeDepartmentJoin() throws  Exception;

	    void departmentEmployeeCount() throws Exception;

	    void getEmployeeProcedure(int id) throws Exception;

	    void getDepartmentProcedure(int departmentId)
	            throws Exception;

	    void transferEmployee(int employeeId, int departmentId)
	            throws Exception;

	    void salaryTransaction(int fromId, int toId,
	                           BigDecimal amount) throws Exception;

	    void batchInsert(List<Employee> employees) throws Exception;

	    void searchBySalary(BigDecimal salary) throws Exception;
}
