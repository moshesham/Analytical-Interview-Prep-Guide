
# Section A: Relational Databases and SQL Basics

## Understanding Databases
Databases are organized collections of data. Relational databases store data in tables (relations), which are made up of rows (tuples) and columns (attributes). Unlike hierarchical or network models, relational databases use a flexible, table-based structure that supports powerful querying and data integrity.

## The Relational Model
- **Relation:** A table of data.
- **Attribute:** A column in a table.
- **Tuple:** A row in a table.
- **Entity:** A real-world object or concept represented in the database.

E.F. Codd’s relational model introduced the idea of organizing data into relations and using keys to uniquely identify records. 

## Normalization
Normalization is the process of structuring a relational database to reduce redundancy and improve data integrity. The first three normal forms (1NF, 2NF, 3NF) are most common. Keys (primary, candidate, surrogate) ensure each row is uniquely identifiable.

## Relationships
- **One-to-One:** Each row in Table A relates to one row in Table B.
- **One-to-Many:** A row in Table A can relate to many rows in Table B.
- **Many-to-Many:** Rows in Table A can relate to many in Table B and vice versa (implemented via a junction table).
- **Cardinality:** Defines the minimum and maximum number of times an entity can be associated with another.

## SQL as a Language
SQL is a nonprocedural language, meaning you specify *what* you want, not *how* to get it. It is a data sublanguage, focused on data definition, manipulation, and control.

## SQL Standards
SQL is governed by ANSI and ISO standards (e.g., SQL:2006). Most RDBMSs (Oracle, SQL Server, MySQL, DB2) implement a core subset of these standards, with vendor-specific extensions.

## Types of SQL Statements
- **DDL (Data Definition Language):** CREATE, ALTER, DROP
- **DML (Data Manipulation Language):** SELECT, INSERT, UPDATE, DELETE
- **DCL (Data Control Language):** GRANT, REVOKE

## Execution Methods
SQL can be executed directly (via a client), embedded in application code, or called via APIs (ODBC, JDBC).

---