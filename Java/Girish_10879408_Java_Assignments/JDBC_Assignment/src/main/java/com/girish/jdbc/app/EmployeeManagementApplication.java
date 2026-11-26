package com.girish.jdbc.app;

import com.girish.jdbc.dao.impl.JdbcEmployeeDao;import com.girish.jdbc.exception.DataAccessException;import com.girish.jdbc.model.Employee;import com.girish.jdbc.service.EmployeeService;import com.girish.jdbc.util.Input;
import java.util.*;

public class EmployeeManagementApplication {
 private final Scanner in=new Scanner(System.in);private final EmployeeService service=new EmployeeService(new JdbcEmployeeDao());
 public static void main(String[] args){new EmployeeManagementApplication().run();}
 private void run(){while(true){menu();try{int c=Input.integer(in,"Enter choice: ");switch(c){case 1->add();case 2->service.all().forEach(System.out::println);case 3->System.out.println(service.byId(Input.integer(in,"Employee ID: ")));case 4->update();case 5->service.delete(Input.integer(in,"Employee ID: "));case 6->service.details().forEach(System.out::println);case 7->service.counts().forEach(System.out::println);case 8->System.out.println(service.callEmployeeSummary(Input.integer(in,"Employee ID: ")));case 9->System.out.println("Payroll: "+service.callDepartmentPayroll(Input.integer(in,"Department ID: ")));case 10->service.transferEmployee(Input.integer(in,"Employee ID: "),Input.integer(in,"Target department ID: "));case 11->batch();case 12->service.salaryAtLeast(Input.decimal(in,"Minimum salary: ")).forEach(System.out::println);case 0->{System.out.println("Goodbye");return;}default->System.out.println("Unknown option");}}catch(IllegalArgumentException|DataAccessException e){System.err.println("Operation failed: "+e.getMessage());}}}
 private void menu(){System.out.println("\n=== EMPLOYEE MANAGEMENT SYSTEM ===\n1 Add employee\n2 View all\n3 Find by ID\n4 Update\n5 Delete\n6 Employee + department join\n7 Department employee count\n8 Stored procedure: employee summary\n9 Stored procedure: department payroll\n10 Transfer employee transaction\n11 Batch insert demo\n12 Parameterized salary search\n0 Exit");}
 private Employee read(Integer id){return new Employee(id,Input.text(in,"Name: "),Input.text(in,"Email: "),Input.decimal(in,"Salary: "),Input.date(in,"Hire date (yyyy-MM-dd): "),Input.integer(in,"Department ID: "));}
 private void add(){System.out.println("Created: "+service.add(read(null)));}
 private void update(){int id=Input.integer(in,"Employee ID: ");service.update(read(id));System.out.println("Updated.");}
 private void batch(){int n=Input.integer(in,"How many employees? ");List<Employee> list=new ArrayList<>();for(int i=1;i<=n;i++){System.out.println("Employee "+i);list.add(read(null));}System.out.println("Batch result: "+Arrays.toString(service.batch(list)));}
}
