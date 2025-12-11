-- College Database Schema
-- Drop existing tables if they exist
DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS studenthistory;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS instructors;
DROP TABLE IF EXISTS departmentheads;
DROP TABLE IF EXISTS departments;

-- Create departments table
CREATE TABLE departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL,
    building VARCHAR(100),
    budget DECIMAL(12, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create departmentheads table
CREATE TABLE departmentheads (
    head_id INT PRIMARY KEY AUTO_INCREMENT,
    department_id INT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20),
    start_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE SET NULL
);

-- Create instructors table
CREATE TABLE instructors (
    instructor_id INT PRIMARY KEY AUTO_INCREMENT,
    department_id INT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20),
    hire_date DATE,
    salary DECIMAL(10, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE SET NULL
);

-- Create courses table
CREATE TABLE courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_code VARCHAR(20) NOT NULL UNIQUE,
    course_name VARCHAR(100) NOT NULL,
    department_id INT,
    instructor_id INT,
    credits INT,
    semester VARCHAR(20),
    year INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE SET NULL,
    FOREIGN KEY (instructor_id) REFERENCES instructors(instructor_id) ON DELETE SET NULL
);

-- Create students table
CREATE TABLE students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    date_of_birth DATE,
    enrollment_date DATE,
    major_department_id INT,
    gpa DECIMAL(3, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (major_department_id) REFERENCES departments(department_id) ON DELETE SET NULL
);

-- Create enrollments table
CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    grade VARCHAR(2),
    status VARCHAR(20) DEFAULT 'Enrolled',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE
);

-- Create studenthistory table
CREATE TABLE studenthistory (
    history_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    semester VARCHAR(20),
    year INT,
    gpa DECIMAL(3, 2),
    credits_earned INT,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE
);

-- Insert sample data
INSERT INTO departments (department_name, building, budget) VALUES
('Computer Science', 'Engineering Hall', 500000.00),
('Mathematics', 'Science Building', 350000.00),
('Physics', 'Science Building', 450000.00),
('English', 'Liberal Arts Hall', 300000.00);

INSERT INTO departmentheads (department_id, first_name, last_name, email, phone, start_date) VALUES
(1, 'John', 'Smith', 'john.smith@college.edu', '555-0101', '2020-01-15'),
(2, 'Sarah', 'Johnson', 'sarah.johnson@college.edu', '555-0102', '2019-08-20'),
(3, 'Michael', 'Williams', 'michael.williams@college.edu', '555-0103', '2021-03-10');

INSERT INTO instructors (department_id, first_name, last_name, email, phone, hire_date, salary) VALUES
(1, 'David', 'Brown', 'david.brown@college.edu', '555-0201', '2018-08-15', 75000.00),
(1, 'Emily', 'Davis', 'emily.davis@college.edu', '555-0202', '2019-01-10', 72000.00),
(2, 'James', 'Wilson', 'james.wilson@college.edu', '555-0203', '2017-09-01', 70000.00),
(3, 'Lisa', 'Anderson', 'lisa.anderson@college.edu', '555-0204', '2020-02-15', 68000.00);

INSERT INTO courses (course_code, course_name, department_id, instructor_id, credits, semester, year) VALUES
('CS101', 'Introduction to Programming', 1, 1, 3, 'Fall', 2024),
('CS201', 'Data Structures', 1, 2, 4, 'Spring', 2024),
('MATH101', 'Calculus I', 2, 3, 4, 'Fall', 2024),
('PHYS101', 'General Physics', 3, 4, 4, 'Fall', 2024);

INSERT INTO students (first_name, last_name, email, phone, date_of_birth, enrollment_date, major_department_id, gpa) VALUES
('Alice', 'Cooper', 'alice.cooper@student.edu', '555-1001', '2003-05-12', '2022-09-01', 1, 3.75),
('Bob', 'Martin', 'bob.martin@student.edu', '555-1002', '2002-11-23', '2021-09-01', 1, 3.50),
('Charlie', 'Lee', 'charlie.lee@student.edu', '555-1003', '2003-08-15', '2022-09-01', 2, 3.90),
('Diana', 'Garcia', 'diana.garcia@student.edu', '555-1004', '2004-02-28', '2023-01-15', 3, 3.60);

INSERT INTO enrollments (student_id, course_id, enrollment_date, grade, status) VALUES
(1, 1, '2024-09-01', 'A', 'Completed'),
(1, 2, '2024-01-15', 'A-', 'Completed'),
(2, 1, '2024-09-01', 'B+', 'Completed'),
(3, 3, '2024-09-01', 'A', 'Completed'),
(4, 4, '2024-09-01', NULL, 'Enrolled');

INSERT INTO studenthistory (student_id, semester, year, gpa, credits_earned, notes) VALUES
(1, 'Fall', 2023, 3.80, 15, 'Excellent performance'),
(2, 'Fall', 2023, 3.45, 12, 'Good progress'),
(3, 'Spring', 2024, 3.95, 16, 'Dean\'s List');
