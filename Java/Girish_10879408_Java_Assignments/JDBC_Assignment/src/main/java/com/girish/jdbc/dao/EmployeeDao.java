package com.girish.jdbc.dao;
import com.girish.jdbc.model.*;
import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;
public interface EmployeeDao {
    Employee save(Employee employee);
    List<Employee> findAll();
    Optional<Employee> findById(int id);
    List<Employee> findByMinimumSalary(BigDecimal minimumSalary);
    boolean update(Employee employee);
    boolean deleteById(int id);
    List<EmployeeDepartmentView> findEmployeeDetailsWithDepartment();
    List<DepartmentCount> countEmployeesByDepartment();
    int[] saveBatch(List<Employee> employees);
}
