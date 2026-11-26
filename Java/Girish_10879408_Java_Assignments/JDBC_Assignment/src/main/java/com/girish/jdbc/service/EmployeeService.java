package com.girish.jdbc.service;

import com.girish.jdbc.config.ConnectionFactory;
import com.girish.jdbc.dao.EmployeeDao;
import com.girish.jdbc.exception.DataAccessException;
import com.girish.jdbc.model.*;
import java.math.BigDecimal;
import java.sql.*;
import java.util.List;

public class EmployeeService {
    private final EmployeeDao dao;
    public EmployeeService(EmployeeDao dao){this.dao=dao;}
    public Employee add(Employee e){validate(e);return dao.save(e);}
    public List<Employee> all(){return dao.findAll();}
    public Employee byId(int id){return dao.findById(id).orElseThrow(()->new IllegalArgumentException("Employee not found: "+id));}
    public List<Employee> salaryAtLeast(BigDecimal min){if(min.signum()<0)throw new IllegalArgumentException("Salary cannot be negative");return dao.findByMinimumSalary(min);}
    public void update(Employee e){validate(e);if(e.id()==null||!dao.update(e))throw new IllegalArgumentException("Employee not found: "+e.id());}
    public void delete(int id){if(!dao.deleteById(id))throw new IllegalArgumentException("Employee not found: "+id);}
    public List<EmployeeDepartmentView> details(){return dao.findEmployeeDetailsWithDepartment();}
    public List<DepartmentCount> counts(){return dao.countEmployeesByDepartment();}
    public int[] batch(List<Employee> employees){employees.forEach(this::validate);return dao.saveBatch(employees);}

    public String callEmployeeSummary(int employeeId){
        try(Connection c=ConnectionFactory.getConnection();CallableStatement cs=c.prepareCall("{call sp_employee_summary(?)}")){cs.setInt(1,employeeId);try(ResultSet rs=cs.executeQuery()){if(!rs.next())return "Employee not found";return rs.getInt("employee_id")+" | "+rs.getString("name")+" | "+rs.getString("department_name")+" | "+rs.getBigDecimal("salary");}}
        catch(SQLException e){throw new DataAccessException("Stored procedure sp_employee_summary failed",e);}
    }
    public BigDecimal callDepartmentPayroll(int departmentId){
        try(Connection c=ConnectionFactory.getConnection();CallableStatement cs=c.prepareCall("{call sp_department_payroll(?,?)}")){cs.setInt(1,departmentId);cs.registerOutParameter(2,Types.DECIMAL);cs.execute();return cs.getBigDecimal(2);}
        catch(SQLException e){throw new DataAccessException("Stored procedure sp_department_payroll failed",e);}
    }
    public void transferEmployee(int employeeId,int targetDepartmentId){
        String lock="SELECT department_id FROM employee WHERE employee_id=? FOR UPDATE";
        String update="UPDATE employee SET department_id=? WHERE employee_id=?";
        String audit="INSERT INTO employee_transfer(employee_id,from_department_id,to_department_id,transfer_date) VALUES(?,?,?,CURRENT_DATE)";
        try(Connection c=ConnectionFactory.getConnection()){
            c.setAutoCommit(false);
            try(PreparedStatement p1=c.prepareStatement(lock);PreparedStatement p2=c.prepareStatement(update);PreparedStatement p3=c.prepareStatement(audit)){
                p1.setInt(1,employeeId);int from;try(ResultSet rs=p1.executeQuery()){if(!rs.next())throw new IllegalArgumentException("Employee not found: "+employeeId);from=rs.getInt(1);}
                p2.setInt(1,targetDepartmentId);p2.setInt(2,employeeId);p2.executeUpdate();
                p3.setInt(1,employeeId);p3.setInt(2,from);p3.setInt(3,targetDepartmentId);p3.executeUpdate();c.commit();
            }catch(Exception e){c.rollback();throw e;}finally{c.setAutoCommit(true);}
        }catch(SQLException e){throw new DataAccessException("Employee transfer transaction failed and was rolled back",e);}
    }
    private void validate(Employee e){if(e==null||e.name()==null||e.name().isBlank())throw new IllegalArgumentException("Name is required");if(e.email()==null||!e.email().matches("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$"))throw new IllegalArgumentException("Valid email is required");if(e.salary()==null||e.salary().signum()<0)throw new IllegalArgumentException("Salary must be non-negative");if(e.hireDate()==null||e.departmentId()==null)throw new IllegalArgumentException("Hire date and department are required");}
}
