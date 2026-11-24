package jdbcassigment;
/**
* @user:  10878560
*  @time:  4:39:30 pm
*  @date:  21 Nov 2026
*  @todo:  TODO
*
*
**/
import java.math.BigDecimal;
import java.util.List;

public class EmployeeService {

	EmployeeDao  dao = new EmployeeDaoImpl();

    public void validateEmployee(Employee e) {

        if (e.getId() <= 0)
            throw new IllegalArgumentException("Invalid employee ID");

        if (e.getName() == null || e.getName().isBlank()
                || e.getName().length() > 100)
            throw new IllegalArgumentException("Invalid employee name");

        if (e.getSalary() == null
                || e.getSalary().signum() < 0
                || e.getSalary().scale() > 2
                || e.getSalary().compareTo(
                        new BigDecimal("9999999999.99")) > 0)
            throw new IllegalArgumentException("Invalid salary");

        if (e.getDepartmentId() <= 0)
            throw new IllegalArgumentException("Invalid department ID");
    }

    public void addEmployee(Employee e) throws Exception {
        validateEmployee(e);
        dao.addEmployee(e);
    }

    public void viewEmployees() throws Exception {
        dao.viewEmployees();
    }

    public void findEmployee(int id) throws Exception {
        dao.findEmployee(id);
    }

    public void updateEmployee(Employee e) throws Exception {
        validateEmployee(e);
        dao.updateEmployee(e);
    }

    public void deleteEmployee(int id) throws Exception {
        dao.deleteEmployee(id);
    }

    public void employeeDepartmentJoin() throws Exception {
        dao.employeeDepartmentJoin();
    }

    public void departmentEmployeeCount() throws Exception {
        dao.departmentEmployeeCount();
    }

    public void getEmployeeProcedure(int id) throws Exception {
        dao.getEmployeeProcedure(id);
    }

    public void getDepartmentProcedure(int id) throws Exception {
        dao.getDepartmentProcedure(id);
    }

    public void transferEmployee(int id, int deptId)
            throws Exception {
        dao.transferEmployee(id, deptId);
    }

    public void salaryTransaction(int fromId, int toId,
                                  BigDecimal amount) throws Exception {
        dao.salaryTransaction(fromId, toId, amount);
    }

    public void batchInsert(List<Employee> employees)
            throws Exception {

        for (Employee e : employees) {
            validateEmployee(e);
        }

        dao.batchInsert(employees);
    }

    public void searchBySalary(BigDecimal salary)
            throws Exception {

        if (salary == null || salary.signum() < 0)
            throw new IllegalArgumentException("Invalid minimum salary");

        dao.searchBySalary(salary);
    }
}
