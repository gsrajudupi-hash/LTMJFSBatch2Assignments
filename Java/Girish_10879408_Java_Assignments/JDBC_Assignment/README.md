# Advanced Java Practical Assessment - Java 17 JDBC

A complete console-based Employee Management System using Java 17, JDBC and MySQL. It does not use Spring. It applies Advanced Java/J2EE-style layered design: Model, DAO, Service, configuration, custom exceptions, transactions and resource management.

## Requirements covered
- CRUD using PreparedStatement (more than five operations)
- Primary-key lookup and parameterized salary search
- JOIN and aggregate GROUP BY query
- Two stored procedures using CallableStatement
- Transaction with commit/rollback and SELECT ... FOR UPDATE
- Batch processing using addBatch/executeBatch
- SQL exception translation, validation, record-not-found handling
- try-with-resources for Connection, Statement and ResultSet
- Java 17 records and switch expressions

## Run
1. Install JDK 17, Maven 3.9+, MySQL 8.x.
2. Run `sql/employee_management.sql` in MySQL Workbench.
3. Edit `src/main/resources/db.properties`.
4. From this folder run: `mvn clean compile exec:java`.

## Architecture
`Application -> Service -> DAO -> JDBC -> MySQL`

The SQL script is a setup/reference artifact. The Java program does not create or alter the database.
