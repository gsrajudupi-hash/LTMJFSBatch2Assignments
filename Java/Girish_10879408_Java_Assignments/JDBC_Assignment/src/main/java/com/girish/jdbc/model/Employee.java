package com.girish.jdbc.model;

import java.math.BigDecimal;
import java.time.LocalDate;

public record Employee(Integer id, String name, String email, BigDecimal salary, LocalDate hireDate, Integer departmentId) {
    public Employee withId(Integer newId) { return new Employee(newId, name, email, salary, hireDate, departmentId); }
}
