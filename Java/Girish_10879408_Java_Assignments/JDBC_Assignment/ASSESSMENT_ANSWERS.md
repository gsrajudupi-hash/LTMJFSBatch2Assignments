# Assessment Answers and Design Notes

## Why PreparedStatement is preferred
PreparedStatement separates SQL from values, prevents SQL injection, handles type conversion safely, supports statement-plan reuse, and avoids quoting/escaping errors. This project uses it for insert, select-by-ID, parameterized salary search, update, delete, joins, aggregates, locking, auditing and batch inserts.

## JDBC interfaces demonstrated
- `DriverManager` and `Connection`: connection and transaction boundaries
- `PreparedStatement`: all parameterized CRUD/query operations
- `CallableStatement`: two stored procedures
- `ResultSet`: row mapping
- `Statement.RETURN_GENERATED_KEYS`: generated employee ID

## Transaction behavior
`transferEmployee` disables auto-commit, locks the employee row, updates the department, writes an audit row, and commits. Any error triggers rollback, preserving atomicity.

## Error handling
The DAO translates SQLState categories for bad credentials, unavailable database, integrity/foreign-key or duplicate-key violations, and SQL syntax errors. The service handles invalid input and record-not-found cases. The console catches errors and continues.

## Resource management
Every JDBC resource uses try-with-resources. Auto-commit is reset after the transaction.

## No Spring
The solution uses plain Java 17 and JDBC with a clean layered architecture. Maven is used only for dependency/build management.
