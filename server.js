const express = require('express');
const cors = require('cors');
const path = require('path');
require('dotenv').config();

const db = require('./config/database');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
const corsOptions = {
    origin: process.env.NODE_ENV === 'production' 
        ? process.env.ALLOWED_ORIGINS?.split(',') || []
        : '*',
    optionsSuccessStatus: 200
};
app.use(cors(corsOptions));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Serve static files (frontend)
app.use(express.static(path.join(__dirname, 'public')));

// ============================================
// DEPARTMENTS ROUTES
// ============================================

// Get all departments
app.get('/api/departments', async (req, res) => {
    try {
        const [rows] = await db.query('SELECT * FROM Departments ORDER BY department_id');
        res.json(rows);
    } catch (error) {
        console.error('Error loading departments:', error);
        res.status(500).json({ error: 'Failed to load departments' });
    }
});

// Get single department
app.get('/api/departments/:id', async (req, res) => {
    try {
        const [rows] = await db.query('SELECT * FROM Departments WHERE department_id = ?', [req.params.id]);
        if (rows.length === 0) {
            return res.status(404).json({ error: 'Department not found' });
        }
        res.json(rows[0]);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Create department
app.post('/api/departments', async (req, res) => {
    try {
        const { department_name, building, budget } = req.body;
        
        // Validate required fields
        if (!department_name || department_name.trim() === '') {
            return res.status(400).json({ error: 'Department name is required' });
        }
        
        const [result] = await db.query(
            'INSERT INTO Departments (department_name, building, budget) VALUES (?, ?, ?)',
            [department_name.trim(), building, budget]
        );
        res.status(201).json({ id: result.insertId, message: 'Department created successfully' });
    } catch (error) {
        console.error('Error creating department:', error);
        res.status(500).json({ error: 'Failed to create department' });
    }
});

// Update department
app.put('/api/departments/:id', async (req, res) => {
    try {
        const { department_name, building, budget } = req.body;
        const [result] = await db.query(
            'UPDATE Departments SET department_name = ?, building = ?, budget = ? WHERE department_id = ?',
            [department_name, building, budget, req.params.id]
        );
        if (result.affectedRows === 0) {
            return res.status(404).json({ error: 'Department not found' });
        }
        res.json({ message: 'Department updated successfully' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Delete department
app.delete('/api/departments/:id', async (req, res) => {
    try {
        const [result] = await db.query('DELETE FROM Departments WHERE department_id = ?', [req.params.id]);
        if (result.affectedRows === 0) {
            return res.status(404).json({ error: 'Department not found' });
        }
        res.json({ message: 'Department deleted successfully' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// ============================================
// DEPARTMENT HEADS ROUTES
// ============================================

// Get all department heads
app.get('/api/departmentheads', async (req, res) => {
    try {
        const [rows] = await db.query(`
            SELECT dh.*, d.department_name 
            FROM DepartmentHeads dh
            LEFT JOIN Departments d ON dh.department_id = d.department_id
            ORDER BY dh.head_id
        `);
        res.json(rows);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Get single department head
app.get('/api/departmentheads/:id', async (req, res) => {
    try {
        const [rows] = await db.query(`
            SELECT dh.*, d.department_name 
            FROM DepartmentHeads dh
            LEFT JOIN Departments d ON dh.department_id = d.department_id
            WHERE dh.head_id = ?
        `, [req.params.id]);
        if (rows.length === 0) {
            return res.status(404).json({ error: 'Department head not found' });
        }
        res.json(rows[0]);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Create department head
app.post('/api/departmentheads', async (req, res) => {
    try {
        const { department_id, first_name, last_name, email, phone, start_date } = req.body;
        
        // Validate required fields
        if (!first_name || first_name.trim() === '' || !last_name || last_name.trim() === '') {
            return res.status(400).json({ error: 'First name and last name are required' });
        }
        
        const [result] = await db.query(
            'INSERT INTO DepartmentHeads (department_id, first_name, last_name, email, phone, start_date) VALUES (?, ?, ?, ?, ?, ?)',
            [department_id, first_name.trim(), last_name.trim(), email, phone, start_date]
        );
        res.status(201).json({ id: result.insertId, message: 'Department head created successfully' });
    } catch (error) {
        console.error('Error creating department head:', error);
        res.status(500).json({ error: 'Failed to create department head' });
    }
});

// Update department head
app.put('/api/departmentheads/:id', async (req, res) => {
    try {
        const { department_id, first_name, last_name, email, phone, start_date } = req.body;
        const [result] = await db.query(
            'UPDATE DepartmentHeads SET department_id = ?, first_name = ?, last_name = ?, email = ?, phone = ?, start_date = ? WHERE head_id = ?',
            [department_id, first_name, last_name, email, phone, start_date, req.params.id]
        );
        if (result.affectedRows === 0) {
            return res.status(404).json({ error: 'Department head not found' });
        }
        res.json({ message: 'Department head updated successfully' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Delete department head
app.delete('/api/departmentheads/:id', async (req, res) => {
    try {
        const [result] = await db.query('DELETE FROM DepartmentHeads WHERE head_id = ?', [req.params.id]);
        if (result.affectedRows === 0) {
            return res.status(404).json({ error: 'Department head not found' });
        }
        res.json({ message: 'Department head deleted successfully' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// ============================================
// INSTRUCTORS ROUTES
// ============================================

// Get all instructors
app.get('/api/instructors', async (req, res) => {
    try {
        const [rows] = await db.query(`
            SELECT i.*, d.department_name 
            FROM Instructors i
            LEFT JOIN Departments d ON i.department_id = d.department_id
            ORDER BY i.instructor_id
        `);
        res.json(rows);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Get single instructor
app.get('/api/instructors/:id', async (req, res) => {
    try {
        const [rows] = await db.query(`
            SELECT i.*, d.department_name 
            FROM Instructors i
            LEFT JOIN Departments d ON i.department_id = d.department_id
            WHERE i.instructor_id = ?
        `, [req.params.id]);
        if (rows.length === 0) {
            return res.status(404).json({ error: 'Instructor not found' });
        }
        res.json(rows[0]);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Create instructor
app.post('/api/instructors', async (req, res) => {
    try {
        const { department_id, first_name, last_name, email, phone, hire_date, salary } = req.body;
        
        // Validate required fields
        if (!first_name || first_name.trim() === '' || !last_name || last_name.trim() === '') {
            return res.status(400).json({ error: 'First name and last name are required' });
        }
        
        const [result] = await db.query(
            'INSERT INTO Instructors (department_id, first_name, last_name, email, phone, hire_date, salary) VALUES (?, ?, ?, ?, ?, ?, ?)',
            [department_id, first_name.trim(), last_name.trim(), email, phone, hire_date, salary]
        );
        res.status(201).json({ id: result.insertId, message: 'Instructor created successfully' });
    } catch (error) {
        console.error('Error creating instructor:', error);
        res.status(500).json({ error: 'Failed to create instructor' });
    }
});

// Update instructor
app.put('/api/instructors/:id', async (req, res) => {
    try {
        const { department_id, first_name, last_name, email, phone, hire_date, salary } = req.body;
        const [result] = await db.query(
            'UPDATE Instructors SET department_id = ?, first_name = ?, last_name = ?, email = ?, phone = ?, hire_date = ?, salary = ? WHERE instructor_id = ?',
            [department_id, first_name, last_name, email, phone, hire_date, salary, req.params.id]
        );
        if (result.affectedRows === 0) {
            return res.status(404).json({ error: 'Instructor not found' });
        }
        res.json({ message: 'Instructor updated successfully' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Delete instructor
app.delete('/api/instructors/:id', async (req, res) => {
    try {
        const [result] = await db.query('DELETE FROM Instructors WHERE instructor_id = ?', [req.params.id]);
        if (result.affectedRows === 0) {
            return res.status(404).json({ error: 'Instructor not found' });
        }
        res.json({ message: 'Instructor deleted successfully' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// ============================================
// COURSES ROUTES
// ============================================

// Get all courses
app.get('/api/courses', async (req, res) => {
    try {
        const [rows] = await db.query(`
            SELECT c.*, d.department_name, 
                   CONCAT(i.first_name, ' ', i.last_name) as instructor_name
            FROM Courses c
            LEFT JOIN Departments d ON c.department_id = d.department_id
            LEFT JOIN Instructors i ON c.instructor_id = i.instructor_id
            ORDER BY c.course_id
        `);
        res.json(rows);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Get single course
app.get('/api/courses/:id', async (req, res) => {
    try {
        const [rows] = await db.query(`
            SELECT c.*, d.department_name, 
                   CONCAT(i.first_name, ' ', i.last_name) as instructor_name
            FROM Courses c
            LEFT JOIN Departments d ON c.department_id = d.department_id
            LEFT JOIN Instructors i ON c.instructor_id = i.instructor_id
            WHERE c.course_id = ?
        `, [req.params.id]);
        if (rows.length === 0) {
            return res.status(404).json({ error: 'Course not found' });
        }
        res.json(rows[0]);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Create course
app.post('/api/courses', async (req, res) => {
    try {
        const { course_code, course_name, department_id, instructor_id, credits, semester, year } = req.body;
        
        // Validate required fields
        if (!course_code || course_code.trim() === '' || !course_name || course_name.trim() === '') {
            return res.status(400).json({ error: 'Course code and course name are required' });
        }
        
        const [result] = await db.query(
            'INSERT INTO Courses (course_code, course_name, department_id, instructor_id, credits, semester, year) VALUES (?, ?, ?, ?, ?, ?, ?)',
            [course_code.trim(), course_name.trim(), department_id, instructor_id, credits, semester, year]
        );
        res.status(201).json({ id: result.insertId, message: 'Course created successfully' });
    } catch (error) {
        console.error('Error creating course:', error);
        res.status(500).json({ error: 'Failed to create course' });
    }
});

// Update course
app.put('/api/courses/:id', async (req, res) => {
    try {
        const { course_code, course_name, department_id, instructor_id, credits, semester, year } = req.body;
        const [result] = await db.query(
            'UPDATE Courses SET course_code = ?, course_name = ?, department_id = ?, instructor_id = ?, credits = ?, semester = ?, year = ? WHERE course_id = ?',
            [course_code, course_name, department_id, instructor_id, credits, semester, year, req.params.id]
        );
        if (result.affectedRows === 0) {
            return res.status(404).json({ error: 'Course not found' });
        }
        res.json({ message: 'Course updated successfully' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Delete course
app.delete('/api/courses/:id', async (req, res) => {
    try {
        const [result] = await db.query('DELETE FROM Courses WHERE course_id = ?', [req.params.id]);
        if (result.affectedRows === 0) {
            return res.status(404).json({ error: 'Course not found' });
        }
        res.json({ message: 'Course deleted successfully' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// ============================================
// STUDENTS ROUTES
// ============================================

// Get all students
app.get('/api/students', async (req, res) => {
    try {
        const [rows] = await db.query(`
            SELECT s.*, d.department_name as major_name
            FROM Students s
            LEFT JOIN Departments d ON s.major_department_id = d.department_id
            ORDER BY s.student_id
        `);
        res.json(rows);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Get single student
app.get('/api/students/:id', async (req, res) => {
    try {
        const [rows] = await db.query(`
            SELECT s.*, d.department_name as major_name
            FROM Students s
            LEFT JOIN Departments d ON s.major_department_id = d.department_id
            WHERE s.student_id = ?
        `, [req.params.id]);
        if (rows.length === 0) {
            return res.status(404).json({ error: 'Student not found' });
        }
        res.json(rows[0]);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Create student
app.post('/api/students', async (req, res) => {
    try {
        const { first_name, last_name, email, phone, date_of_birth, enrollment_date, major_department_id, gpa } = req.body;
        
        // Validate required fields
        if (!first_name || first_name.trim() === '' || !last_name || last_name.trim() === '') {
            return res.status(400).json({ error: 'First name and last name are required' });
        }
        
        const [result] = await db.query(
            'INSERT INTO Students (first_name, last_name, email, phone, date_of_birth, enrollment_date, major_department_id, gpa) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
            [first_name.trim(), last_name.trim(), email, phone, date_of_birth, enrollment_date, major_department_id, gpa]
        );
        res.status(201).json({ id: result.insertId, message: 'Student created successfully' });
    } catch (error) {
        console.error('Error creating student:', error);
        res.status(500).json({ error: 'Failed to create student' });
    }
});

// Update student
app.put('/api/students/:id', async (req, res) => {
    try {
        const { first_name, last_name, email, phone, date_of_birth, enrollment_date, major_department_id, gpa } = req.body;
        const [result] = await db.query(
            'UPDATE Students SET first_name = ?, last_name = ?, email = ?, phone = ?, date_of_birth = ?, enrollment_date = ?, major_department_id = ?, gpa = ? WHERE student_id = ?',
            [first_name, last_name, email, phone, date_of_birth, enrollment_date, major_department_id, gpa, req.params.id]
        );
        if (result.affectedRows === 0) {
            return res.status(404).json({ error: 'Student not found' });
        }
        res.json({ message: 'Student updated successfully' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Delete student
app.delete('/api/students/:id', async (req, res) => {
    try {
        const [result] = await db.query('DELETE FROM Students WHERE student_id = ?', [req.params.id]);
        if (result.affectedRows === 0) {
            return res.status(404).json({ error: 'Student not found' });
        }
        res.json({ message: 'Student deleted successfully' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// ============================================
// ENROLLMENTS ROUTES
// ============================================

// Get all enrollments
app.get('/api/enrollments', async (req, res) => {
    try {
        const [rows] = await db.query(`
            SELECT e.*, 
                   CONCAT(s.first_name, ' ', s.last_name) as student_name,
                   c.course_code, c.course_name
            FROM Enrollments e
            LEFT JOIN Students s ON e.student_id = s.student_id
            LEFT JOIN Courses c ON e.course_id = c.course_id
            ORDER BY e.enrollment_id
        `);
        res.json(rows);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Get single enrollment
app.get('/api/enrollments/:id', async (req, res) => {
    try {
        const [rows] = await db.query(`
            SELECT e.*, 
                   CONCAT(s.first_name, ' ', s.last_name) as student_name,
                   c.course_code, c.course_name
            FROM Enrollments e
            LEFT JOIN Students s ON e.student_id = s.student_id
            LEFT JOIN Courses c ON e.course_id = c.course_id
            WHERE e.enrollment_id = ?
        `, [req.params.id]);
        if (rows.length === 0) {
            return res.status(404).json({ error: 'Enrollment not found' });
        }
        res.json(rows[0]);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Create enrollment
app.post('/api/enrollments', async (req, res) => {
    try {
        const { student_id, course_id, enrollment_date, grade, status } = req.body;
        const [result] = await db.query(
            'INSERT INTO Enrollments (student_id, course_id, enrollment_date, grade, status) VALUES (?, ?, ?, ?, ?)',
            [student_id, course_id, enrollment_date, grade, status]
        );
        res.status(201).json({ id: result.insertId, message: 'Enrollment created successfully' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Update enrollment
app.put('/api/enrollments/:id', async (req, res) => {
    try {
        const { student_id, course_id, enrollment_date, grade, status } = req.body;
        const [result] = await db.query(
            'UPDATE Enrollments SET student_id = ?, course_id = ?, enrollment_date = ?, grade = ?, status = ? WHERE enrollment_id = ?',
            [student_id, course_id, enrollment_date, grade, status, req.params.id]
        );
        if (result.affectedRows === 0) {
            return res.status(404).json({ error: 'Enrollment not found' });
        }
        res.json({ message: 'Enrollment updated successfully' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Delete enrollment
app.delete('/api/enrollments/:id', async (req, res) => {
    try {
        const [result] = await db.query('DELETE FROM Enrollments WHERE enrollment_id = ?', [req.params.id]);
        if (result.affectedRows === 0) {
            return res.status(404).json({ error: 'Enrollment not found' });
        }
        res.json({ message: 'Enrollment deleted successfully' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// ============================================
// STUDENT HISTORY ROUTES
// ============================================

// Get all student history records
app.get('/api/studenthistory', async (req, res) => {
    try {
        const [rows] = await db.query(`
            SELECT sh.*, 
                   CONCAT(s.first_name, ' ', s.last_name) as student_name
            FROM StudentHistory sh
            LEFT JOIN Students s ON sh.student_id = s.student_id
            ORDER BY sh.history_id
        `);
        res.json(rows);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Get single student history record
app.get('/api/studenthistory/:id', async (req, res) => {
    try {
        const [rows] = await db.query(`
            SELECT sh.*, 
                   CONCAT(s.first_name, ' ', s.last_name) as student_name
            FROM StudentHistory sh
            LEFT JOIN Students s ON sh.student_id = s.student_id
            WHERE sh.history_id = ?
        `, [req.params.id]);
        if (rows.length === 0) {
            return res.status(404).json({ error: 'Student history record not found' });
        }
        res.json(rows[0]);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Create student history record
app.post('/api/studenthistory', async (req, res) => {
    try {
        const { student_id, semester, year, gpa, credits_earned, notes } = req.body;
        const [result] = await db.query(
            'INSERT INTO StudentHistory (student_id, semester, year, gpa, credits_earned, notes) VALUES (?, ?, ?, ?, ?, ?)',
            [student_id, semester, year, gpa, credits_earned, notes]
        );
        res.status(201).json({ id: result.insertId, message: 'Student history record created successfully' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Update student history record
app.put('/api/studenthistory/:id', async (req, res) => {
    try {
        const { student_id, semester, year, gpa, credits_earned, notes } = req.body;
        const [result] = await db.query(
            'UPDATE StudentHistory SET student_id = ?, semester = ?, year = ?, gpa = ?, credits_earned = ?, notes = ? WHERE history_id = ?',
            [student_id, semester, year, gpa, credits_earned, notes, req.params.id]
        );
        if (result.affectedRows === 0) {
            return res.status(404).json({ error: 'Student history record not found' });
        }
        res.json({ message: 'Student history record updated successfully' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Delete student history record
app.delete('/api/studenthistory/:id', async (req, res) => {
    try {
        const [result] = await db.query('DELETE FROM StudentHistory WHERE history_id = ?', [req.params.id]);
        if (result.affectedRows === 0) {
            return res.status(404).json({ error: 'Student history record not found' });
        }
        res.json({ message: 'Student history record deleted successfully' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// ============================================
// ROOT ROUTE
// ============================================

app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// ============================================
// START SERVER
// ============================================

app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
    console.log(`API is available at http://localhost:${PORT}/api`);
});
