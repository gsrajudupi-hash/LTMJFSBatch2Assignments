package jdbcassigment;

import java.math.BigDecimal;

/**
* @user:  10878560
*  @time:  4:18:05 pm
*  @date:  21 Nov 2026
*  @todo:  TODO
*
*
**/
public class Employee {

	    private final int id;
	    private final String name;
	    private final BigDecimal salary;
	    private final int departmentId;

	    public Employee(int id, String name,
	                    BigDecimal salary, int departmentId) {

	        if (id <= 0)
	            throw new IllegalArgumentException("Employee ID must be positive");

	        if (name == null || name.isBlank() || name.length() > 100)
	            throw new IllegalArgumentException(
	                    "Employee name must contain 1 to 100 characters");

	        if (salary == null || salary.signum() < 0
	                || salary.scale() > 2
	                || salary.precision() - salary.scale() > 10)
	            throw new IllegalArgumentException(
	                    "Salary must be between 0 and 9999999999.99");

	        if (departmentId <= 0)
	            throw new IllegalArgumentException(
	                    "Department ID must be positive");

	        this.id = id;
	        this.name = name.trim();
	        this.salary = salary;
	        this.departmentId = departmentId;
	    }

	    public int getId() {
	        return id;
	    }

	    public String getName() {
	        return name;
	    }

	    public BigDecimal getSalary() {
	        return salary;
	    }

	    public int getDepartmentId() {
	        return departmentId;
	    }

	    @Override
	    public String toString() {
	        return String.format(
	                "ID: %d | Name: %s | Salary: %s | Department: %d",
	                id, name, salary, departmentId);
	    }
	}
