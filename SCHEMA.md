# Database Schema Documentation

## Entity Relationship Overview

This document describes the database schema for the College Database Management System.

## Tables

### 1. departments
Primary table for academic departments.

| Column Name     | Type          | Constraints           | Description                    |
|----------------|---------------|----------------------|--------------------------------|
| department_id   | INT           | PRIMARY KEY, AUTO_INCREMENT | Unique department identifier   |
| department_name | VARCHAR(100)  | NOT NULL             | Name of the department         |
| building        | VARCHAR(100)  |                      | Building where department is located |
| budget          | DECIMAL(12,2) |                      | Department budget              |
| created_at      | TIMESTAMP     | DEFAULT CURRENT_TIMESTAMP | Record creation timestamp      |

### 2. departmentheads
Information about department heads.

| Column Name     | Type          | Constraints           | Description                    |
|----------------|---------------|----------------------|--------------------------------|
| head_id         | INT           | PRIMARY KEY, AUTO_INCREMENT | Unique head identifier         |
| department_id   | INT           | FOREIGN KEY → departments | Associated department          |
| first_name      | VARCHAR(50)   | NOT NULL             | First name                     |
| last_name       | VARCHAR(50)   | NOT NULL             | Last name                      |
| email           | VARCHAR(100)  |                      | Email address                  |
| phone           | VARCHAR(20)   |                      | Phone number                   |
| start_date      | DATE          |                      | Date started as head           |
| created_at      | TIMESTAMP     | DEFAULT CURRENT_TIMESTAMP | Record creation timestamp      |

### 3. instructors
Teaching staff information.

| Column Name     | Type          | Constraints           | Description                    |
|----------------|---------------|----------------------|--------------------------------|
| instructor_id   | INT           | PRIMARY KEY, AUTO_INCREMENT | Unique instructor identifier   |
| department_id   | INT           | FOREIGN KEY → departments | Associated department          |
| first_name      | VARCHAR(50)   | NOT NULL             | First name                     |
| last_name       | VARCHAR(50)   | NOT NULL             | Last name                      |
| email           | VARCHAR(100)  |                      | Email address                  |
| phone           | VARCHAR(20)   |                      | Phone number                   |
| hire_date       | DATE          |                      | Date hired                     |
| salary          | DECIMAL(10,2) |                      | Annual salary                  |
| created_at      | TIMESTAMP     | DEFAULT CURRENT_TIMESTAMP | Record creation timestamp      |

### 4. courses
Course catalog and scheduling.

| Column Name     | Type          | Constraints           | Description                    |
|----------------|---------------|----------------------|--------------------------------|
| course_id       | INT           | PRIMARY KEY, AUTO_INCREMENT | Unique course identifier       |
| course_code     | VARCHAR(20)   | NOT NULL, UNIQUE     | Course code (e.g., CS101)      |
| course_name     | VARCHAR(100)  | NOT NULL             | Course name                    |
| department_id   | INT           | FOREIGN KEY → departments | Offering department            |
| instructor_id   | INT           | FOREIGN KEY → instructors | Teaching instructor            |
| credits         | INT           |                      | Credit hours                   |
| semester        | VARCHAR(20)   |                      | Semester offered               |
| year            | INT           |                      | Year offered                   |
| created_at      | TIMESTAMP     | DEFAULT CURRENT_TIMESTAMP | Record creation timestamp      |

### 5. students
Student information and records.

| Column Name        | Type          | Constraints           | Description                    |
|-------------------|---------------|----------------------|--------------------------------|
| student_id         | INT           | PRIMARY KEY, AUTO_INCREMENT | Unique student identifier      |
| first_name         | VARCHAR(50)   | NOT NULL             | First name                     |
| last_name          | VARCHAR(50)   | NOT NULL             | Last name                      |
| email              | VARCHAR(100)  | UNIQUE               | Email address                  |
| phone              | VARCHAR(20)   |                      | Phone number                   |
| date_of_birth      | DATE          |                      | Date of birth                  |
| enrollment_date    | DATE          |                      | Enrollment date                |
| major_department_id| INT           | FOREIGN KEY → departments | Major department               |
| gpa                | DECIMAL(3,2)  |                      | Grade Point Average            |
| created_at         | TIMESTAMP     | DEFAULT CURRENT_TIMESTAMP | Record creation timestamp      |

### 6. enrollments
Student course enrollments and grades.

| Column Name     | Type          | Constraints           | Description                    |
|----------------|---------------|----------------------|--------------------------------|
| enrollment_id   | INT           | PRIMARY KEY, AUTO_INCREMENT | Unique enrollment identifier   |
| student_id      | INT           | FOREIGN KEY → students (CASCADE) | Enrolled student               |
| course_id       | INT           | FOREIGN KEY → courses (CASCADE) | Enrolled course                |
| enrollment_date | DATE          |                      | Date of enrollment             |
| grade           | VARCHAR(2)    |                      | Final grade (A, B+, etc.)      |
| status          | VARCHAR(20)   | DEFAULT 'Enrolled'   | Enrollment status              |
| created_at      | TIMESTAMP     | DEFAULT CURRENT_TIMESTAMP | Record creation timestamp      |

### 7. studenthistory
Historical academic performance records.

| Column Name     | Type          | Constraints           | Description                    |
|----------------|---------------|----------------------|--------------------------------|
| history_id      | INT           | PRIMARY KEY, AUTO_INCREMENT | Unique history record ID       |
| student_id      | INT           | FOREIGN KEY → students (CASCADE) | Associated student             |
| semester        | VARCHAR(20)   |                      | Semester                       |
| year            | INT           |                      | Year                           |
| gpa             | DECIMAL(3,2)  |                      | Semester GPA                   |
| credits_earned  | INT           |                      | Credits earned that semester   |
| notes           | TEXT          |                      | Additional notes               |
| created_at      | TIMESTAMP     | DEFAULT CURRENT_TIMESTAMP | Record creation timestamp      |

## Relationships

```
departments (1) ←→ (N) departmentheads
departments (1) ←→ (N) instructors
departments (1) ←→ (N) courses
departments (1) ←→ (N) students (as major)
instructors (1) ←→ (N) courses
students (1) ←→ (N) enrollments
courses (1) ←→ (N) enrollments
students (1) ←→ (N) studenthistory
```

## Foreign Key Behaviors

- **ON DELETE CASCADE**: 
  - enrollments → students
  - enrollments → courses
  - studenthistory → students
  
  (If a student or course is deleted, associated enrollments/history are also deleted)

- **ON DELETE SET NULL**: 
  - All other foreign keys
  
  (If referenced record is deleted, the foreign key is set to NULL)

## Indexes

Primary keys are automatically indexed. Consider adding indexes on:
- departments.department_name
- students.email
- courses.course_code
- Foreign key columns for better JOIN performance

## Sample Queries

### Get all courses with department and instructor information:
```sql
SELECT c.*, d.department_name, 
       CONCAT(i.first_name, ' ', i.last_name) as instructor_name
FROM courses c
LEFT JOIN departments d ON c.department_id = d.department_id
LEFT JOIN instructors i ON c.instructor_id = i.instructor_id;
```

### Get student enrollments with course details:
```sql
SELECT e.*, 
       CONCAT(s.first_name, ' ', s.last_name) as student_name,
       c.course_code, c.course_name
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id;
```

### Get student performance history:
```sql
SELECT sh.*, 
       CONCAT(s.first_name, ' ', s.last_name) as student_name,
       d.department_name as major
FROM studenthistory sh
JOIN students s ON sh.student_id = s.student_id
LEFT JOIN departments d ON s.major_department_id = d.department_id
ORDER BY sh.year DESC, sh.semester;
```
