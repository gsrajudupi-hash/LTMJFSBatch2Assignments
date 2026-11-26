package com.girish.jdbc.dao.impl;

import com.girish.jdbc.config.ConnectionFactory;
import com.girish.jdbc.dao.EmployeeDao;
import com.girish.jdbc.exception.DataAccessException;
import com.girish.jdbc.model.*;
import java.math.BigDecimal;
import java.sql.*;
import java.util.*;

public class JdbcEmployeeDao implements EmployeeDao {
    private static final String INSERT = "INSERT INTO employee(name,email,salary,hire_date,department_id) VALUES(?,?,?,?,?)";
    private static final String SELECT_ALL = "SELECT employee_id,name,email,salary,hire_date,department_id FROM employee ORDER BY employee_id";
    private static final String SELECT_ID = SELECT_ALL.replace(" ORDER BY employee_id", " WHERE employee_id=?");

    @Override public Employee save(Employee e) {
        try (Connection c = ConnectionFactory.getConnection(); PreparedStatement ps = c.prepareStatement(INSERT, Statement.RETURN_GENERATED_KEYS)) {
            setEmployee(ps, e); ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) { if (rs.next()) return e.withId(rs.getInt(1)); }
            throw new DataAccessException("Employee inserted but generated key was unavailable", null);
        } catch (SQLException ex) { throw translate("Unable to add employee", ex); }
    }
    @Override public List<Employee> findAll() {
        try (Connection c = ConnectionFactory.getConnection(); PreparedStatement ps = c.prepareStatement(SELECT_ALL); ResultSet rs = ps.executeQuery()) {
            List<Employee> list = new ArrayList<>(); while (rs.next()) list.add(map(rs)); return list;
        } catch (SQLException ex) { throw translate("Unable to retrieve employees", ex); }
    }
    @Override public Optional<Employee> findById(int id) {
        try (Connection c = ConnectionFactory.getConnection(); PreparedStatement ps = c.prepareStatement(SELECT_ID)) {
            ps.setInt(1,id); try(ResultSet rs=ps.executeQuery()){ return rs.next()?Optional.of(map(rs)):Optional.empty(); }
        } catch (SQLException ex) { throw translate("Unable to find employee", ex); }
    }
    @Override public List<Employee> findByMinimumSalary(BigDecimal min) {
        String sql = SELECT_ALL.replace(" ORDER BY employee_id", " WHERE salary>=? ORDER BY salary DESC");
        try(Connection c=ConnectionFactory.getConnection(); PreparedStatement ps=c.prepareStatement(sql)){ ps.setBigDecimal(1,min); try(ResultSet rs=ps.executeQuery()){List<Employee> list=new ArrayList<>();while(rs.next())list.add(map(rs));return list;}}
        catch(SQLException ex){throw translate("Unable to execute salary query",ex);}
    }
    @Override public boolean update(Employee e) {
        String sql="UPDATE employee SET name=?,email=?,salary=?,hire_date=?,department_id=? WHERE employee_id=?";
        try(Connection c=ConnectionFactory.getConnection();PreparedStatement ps=c.prepareStatement(sql)){setEmployee(ps,e);ps.setInt(6,e.id());return ps.executeUpdate()==1;}
        catch(SQLException ex){throw translate("Unable to update employee",ex);}
    }
    @Override public boolean deleteById(int id) {
        try(Connection c=ConnectionFactory.getConnection();PreparedStatement ps=c.prepareStatement("DELETE FROM employee WHERE employee_id=?")){ps.setInt(1,id);return ps.executeUpdate()==1;}
        catch(SQLException ex){throw translate("Unable to delete employee",ex);}
    }
    @Override public List<EmployeeDepartmentView> findEmployeeDetailsWithDepartment(){
        String sql="SELECT e.employee_id,e.name,e.email,e.salary,d.department_name,d.location FROM employee e JOIN department d ON d.department_id=e.department_id ORDER BY e.employee_id";
        try(Connection c=ConnectionFactory.getConnection();PreparedStatement ps=c.prepareStatement(sql);ResultSet rs=ps.executeQuery()){List<EmployeeDepartmentView> list=new ArrayList<>();while(rs.next())list.add(new EmployeeDepartmentView(rs.getInt(1),rs.getString(2),rs.getString(3),rs.getBigDecimal(4),rs.getString(5),rs.getString(6)));return list;}
        catch(SQLException ex){throw translate("Unable to execute join query",ex);}
    }
    @Override public List<DepartmentCount> countEmployeesByDepartment(){
        String sql="SELECT d.department_id,d.department_name,COUNT(e.employee_id) employee_count FROM department d LEFT JOIN employee e ON e.department_id=d.department_id GROUP BY d.department_id,d.department_name ORDER BY d.department_id";
        try(Connection c=ConnectionFactory.getConnection();PreparedStatement ps=c.prepareStatement(sql);ResultSet rs=ps.executeQuery()){List<DepartmentCount> list=new ArrayList<>();while(rs.next())list.add(new DepartmentCount(rs.getInt(1),rs.getString(2),rs.getLong(3)));return list;}
        catch(SQLException ex){throw translate("Unable to execute aggregate query",ex);}
    }
    @Override public int[] saveBatch(List<Employee> employees){
        try(Connection c=ConnectionFactory.getConnection();PreparedStatement ps=c.prepareStatement(INSERT)){for(Employee e:employees){setEmployee(ps,e);ps.addBatch();}return ps.executeBatch();}
        catch(SQLException ex){throw translate("Unable to batch insert employees",ex);}
    }
    private static void setEmployee(PreparedStatement ps,Employee e)throws SQLException{ps.setString(1,e.name());ps.setString(2,e.email());ps.setBigDecimal(3,e.salary());ps.setDate(4,java.sql.Date.valueOf(e.hireDate()));ps.setInt(5,e.departmentId());}
    private static Employee map(ResultSet rs)throws SQLException{return new Employee(rs.getInt("employee_id"),rs.getString("name"),rs.getString("email"),rs.getBigDecimal("salary"),rs.getDate("hire_date").toLocalDate(),rs.getInt("department_id"));}
    private static DataAccessException translate(String message,SQLException e){String detail=switch(e.getSQLState()==null?"":e.getSQLState()){case "23000"->"Constraint violation (duplicate value or invalid foreign key).";case "28000"->"Invalid database credentials.";case "42000"->"SQL syntax or database object error.";case "08S01","08001"->"Database is unavailable.";default->e.getMessage();};return new DataAccessException(message+": "+detail,e);}
}
