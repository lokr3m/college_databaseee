// API Base URL
const API_URL = '/api';

// Current editing state
let currentEditingId = null;
let currentTab = 'departments';

// Initialize the app
document.addEventListener('DOMContentLoaded', () => {
    initializeTabs();
    loadAllData();
});

// Tab Management
function initializeTabs() {
    const tabButtons = document.querySelectorAll('.tab-btn');
    
    tabButtons.forEach(button => {
        button.addEventListener('click', () => {
            const tabName = button.getAttribute('data-tab');
            switchTab(tabName);
        });
    });
}

function switchTab(tabName) {
    // Update buttons
    document.querySelectorAll('.tab-btn').forEach(btn => btn.classList.remove('active'));
    document.querySelector(`[data-tab="${tabName}"]`).classList.add('active');
    
    // Update content
    document.querySelectorAll('.tab-content').forEach(content => content.classList.remove('active'));
    document.getElementById(tabName).classList.add('active');
    
    currentTab = tabName;
    
    // Load data for the active tab
    loadTabData(tabName);
}

// Load all initial data
function loadAllData() {
    loadDepartments();
    loadDepartmentHeads();
    loadInstructors();
    loadCourses();
    loadStudents();
    loadEnrollments();
    loadStudentHistory();
}

function loadTabData(tabName) {
    switch(tabName) {
        case 'departments':
            loadDepartments();
            break;
        case 'department-heads':
            loadDepartmentHeads();
            break;
        case 'instructors':
            loadInstructors();
            break;
        case 'courses':
            loadCourses();
            break;
        case 'students':
            loadStudents();
            break;
        case 'enrollments':
            loadEnrollments();
            break;
        case 'student-history':
            loadStudentHistory();
            break;
    }
}

// ============================================
// DEPARTMENTS
// ============================================

async function loadDepartments() {
    try {
        const response = await fetch(`${API_URL}/departments`);
        const departments = await response.json();
        
        const tbody = document.querySelector('#departments-table tbody');
        tbody.innerHTML = '';
        
        if (departments.length === 0) {
            tbody.innerHTML = '<tr><td colspan="5" class="empty-state"><p>No departments found. Add one to get started!</p></td></tr>';
            return;
        }
        
        departments.forEach(dept => {
            const row = `
                <tr>
                    <td>${dept.department_id}</td>
                    <td>${dept.department_name}</td>
                    <td>${dept.building || 'N/A'}</td>
                    <td>$${dept.budget ? parseFloat(dept.budget).toLocaleString() : '0.00'}</td>
                    <td class="action-buttons">
                        <button class="btn btn-warning" onclick="editDepartment(${dept.department_id})">Edit</button>
                        <button class="btn btn-danger" onclick="deleteDepartment(${dept.department_id})">Delete</button>
                    </td>
                </tr>
            `;
            tbody.innerHTML += row;
        });
        
        // Also populate department dropdowns
        populateDepartmentDropdowns(departments);
    } catch (error) {
        console.error('Error loading departments:', error);
        showMessage('error', 'Failed to load departments');
    }
}

function populateDepartmentDropdowns(departments) {
    const dropdowns = [
        '#head-department-id',
        '#instructor-department-id',
        '#course-department-id',
        '#student-major-id'
    ];
    
    dropdowns.forEach(selector => {
        const dropdown = document.querySelector(selector);
        if (dropdown) {
            dropdown.innerHTML = '<option value="">Select Department</option>';
            departments.forEach(dept => {
                dropdown.innerHTML += `<option value="${dept.department_id}">${dept.department_name}</option>`;
            });
        }
    });
}

function showAddForm(entity) {
    const formContainer = document.getElementById(`${entity}-form`);
    const formTitle = document.getElementById(`${entity}-form-title`);
    
    formContainer.style.display = 'block';
    formTitle.textContent = `Add ${entity.replace('-', ' ').replace(/\b\w/g, l => l.toUpperCase())}`;
    
    // Reset form
    const form = formContainer.querySelector('form');
    form.reset();
    currentEditingId = null;
    
    // Load dependent data if needed
    if (entity === 'department-heads' || entity === 'instructors' || entity === 'courses' || entity === 'students') {
        loadDepartments();
    }
    if (entity === 'courses') {
        loadInstructorsForDropdown();
    }
    if (entity === 'enrollments') {
        loadStudentsForDropdown();
        loadCoursesForDropdown();
    }
    if (entity === 'student-history') {
        loadStudentsForDropdown();
    }
}

function cancelForm(entity) {
    const formContainer = document.getElementById(`${entity}-form`);
    formContainer.style.display = 'none';
    currentEditingId = null;
}

async function editDepartment(id) {
    try {
        const response = await fetch(`${API_URL}/departments/${id}`);
        const dept = await response.json();
        
        document.getElementById('department-id').value = dept.department_id;
        document.getElementById('department-name').value = dept.department_name;
        document.getElementById('department-building').value = dept.building || '';
        document.getElementById('department-budget').value = dept.budget || '';
        
        document.getElementById('departments-form').style.display = 'block';
        document.getElementById('departments-form-title').textContent = 'Edit Department';
        currentEditingId = id;
    } catch (error) {
        console.error('Error loading department:', error);
        showMessage('error', 'Failed to load department');
    }
}

async function deleteDepartment(id) {
    if (!confirm('Are you sure you want to delete this department?')) return;
    
    try {
        const response = await fetch(`${API_URL}/departments/${id}`, {
            method: 'DELETE'
        });
        
        if (response.ok) {
            showMessage('success', 'Department deleted successfully');
            loadDepartments();
        } else {
            const error = await response.json();
            showMessage('error', error.error || 'Failed to delete department');
        }
    } catch (error) {
        console.error('Error deleting department:', error);
        showMessage('error', 'Failed to delete department');
    }
}

// Department form submission
document.getElementById('department-form')?.addEventListener('submit', async (e) => {
    e.preventDefault();
    
    const data = {
        department_name: document.getElementById('department-name').value,
        building: document.getElementById('department-building').value,
        budget: document.getElementById('department-budget').value || null
    };
    
    const id = document.getElementById('department-id').value;
    const method = id ? 'PUT' : 'POST';
    const url = id ? `${API_URL}/departments/${id}` : `${API_URL}/departments`;
    
    try {
        const response = await fetch(url, {
            method,
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data)
        });
        
        if (response.ok) {
            showMessage('success', id ? 'Department updated successfully' : 'Department created successfully');
            cancelForm('departments');
            loadDepartments();
        } else {
            const error = await response.json();
            showMessage('error', error.error || 'Failed to save department');
        }
    } catch (error) {
        console.error('Error saving department:', error);
        showMessage('error', 'Failed to save department');
    }
});

// ============================================
// DEPARTMENT HEADS
// ============================================

async function loadDepartmentHeads() {
    try {
        const response = await fetch(`${API_URL}/departmentheads`);
        const heads = await response.json();
        
        const tbody = document.querySelector('#department-heads-table tbody');
        tbody.innerHTML = '';
        
        if (heads.length === 0) {
            tbody.innerHTML = '<tr><td colspan="7" class="empty-state"><p>No department heads found. Add one to get started!</p></td></tr>';
            return;
        }
        
        heads.forEach(head => {
            const row = `
                <tr>
                    <td>${head.head_id}</td>
                    <td>${head.department_name || 'N/A'}</td>
                    <td>${head.first_name} ${head.last_name}</td>
                    <td>${head.email || 'N/A'}</td>
                    <td>${head.phone || 'N/A'}</td>
                    <td>${head.start_date ? new Date(head.start_date).toLocaleDateString() : 'N/A'}</td>
                    <td class="action-buttons">
                        <button class="btn btn-warning" onclick="editDepartmentHead(${head.head_id})">Edit</button>
                        <button class="btn btn-danger" onclick="deleteDepartmentHead(${head.head_id})">Delete</button>
                    </td>
                </tr>
            `;
            tbody.innerHTML += row;
        });
    } catch (error) {
        console.error('Error loading department heads:', error);
        showMessage('error', 'Failed to load department heads');
    }
}

async function editDepartmentHead(id) {
    try {
        const response = await fetch(`${API_URL}/departmentheads/${id}`);
        const head = await response.json();
        
        await loadDepartments();
        
        document.getElementById('head-id').value = head.head_id;
        document.getElementById('head-department-id').value = head.department_id || '';
        document.getElementById('head-first-name').value = head.first_name;
        document.getElementById('head-last-name').value = head.last_name;
        document.getElementById('head-email').value = head.email || '';
        document.getElementById('head-phone').value = head.phone || '';
        document.getElementById('head-start-date').value = head.start_date ? head.start_date.split('T')[0] : '';
        
        document.getElementById('department-heads-form').style.display = 'block';
        document.getElementById('department-heads-form-title').textContent = 'Edit Department Head';
        currentEditingId = id;
    } catch (error) {
        console.error('Error loading department head:', error);
        showMessage('error', 'Failed to load department head');
    }
}

async function deleteDepartmentHead(id) {
    if (!confirm('Are you sure you want to delete this department head?')) return;
    
    try {
        const response = await fetch(`${API_URL}/departmentheads/${id}`, {
            method: 'DELETE'
        });
        
        if (response.ok) {
            showMessage('success', 'Department head deleted successfully');
            loadDepartmentHeads();
        } else {
            const error = await response.json();
            showMessage('error', error.error || 'Failed to delete department head');
        }
    } catch (error) {
        console.error('Error deleting department head:', error);
        showMessage('error', 'Failed to delete department head');
    }
}

document.getElementById('department-head-form')?.addEventListener('submit', async (e) => {
    e.preventDefault();
    
    const data = {
        department_id: document.getElementById('head-department-id').value || null,
        first_name: document.getElementById('head-first-name').value,
        last_name: document.getElementById('head-last-name').value,
        email: document.getElementById('head-email').value,
        phone: document.getElementById('head-phone').value,
        start_date: document.getElementById('head-start-date').value || null
    };
    
    const id = document.getElementById('head-id').value;
    const method = id ? 'PUT' : 'POST';
    const url = id ? `${API_URL}/departmentheads/${id}` : `${API_URL}/departmentheads`;
    
    try {
        const response = await fetch(url, {
            method,
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data)
        });
        
        if (response.ok) {
            showMessage('success', id ? 'Department head updated successfully' : 'Department head created successfully');
            cancelForm('department-heads');
            loadDepartmentHeads();
        } else {
            const error = await response.json();
            showMessage('error', error.error || 'Failed to save department head');
        }
    } catch (error) {
        console.error('Error saving department head:', error);
        showMessage('error', 'Failed to save department head');
    }
});

// ============================================
// INSTRUCTORS
// ============================================

async function loadInstructors() {
    try {
        const response = await fetch(`${API_URL}/instructors`);
        const instructors = await response.json();
        
        const tbody = document.querySelector('#instructors-table tbody');
        tbody.innerHTML = '';
        
        if (instructors.length === 0) {
            tbody.innerHTML = '<tr><td colspan="8" class="empty-state"><p>No instructors found. Add one to get started!</p></td></tr>';
            return;
        }
        
        instructors.forEach(instructor => {
            const row = `
                <tr>
                    <td>${instructor.instructor_id}</td>
                    <td>${instructor.department_name || 'N/A'}</td>
                    <td>${instructor.first_name} ${instructor.last_name}</td>
                    <td>${instructor.email || 'N/A'}</td>
                    <td>${instructor.phone || 'N/A'}</td>
                    <td>${instructor.hire_date ? new Date(instructor.hire_date).toLocaleDateString() : 'N/A'}</td>
                    <td>$${instructor.salary ? parseFloat(instructor.salary).toLocaleString() : '0.00'}</td>
                    <td class="action-buttons">
                        <button class="btn btn-warning" onclick="editInstructor(${instructor.instructor_id})">Edit</button>
                        <button class="btn btn-danger" onclick="deleteInstructor(${instructor.instructor_id})">Delete</button>
                    </td>
                </tr>
            `;
            tbody.innerHTML += row;
        });
    } catch (error) {
        console.error('Error loading instructors:', error);
        showMessage('error', 'Failed to load instructors');
    }
}

async function loadInstructorsForDropdown() {
    try {
        const response = await fetch(`${API_URL}/instructors`);
        const instructors = await response.json();
        
        const dropdown = document.getElementById('course-instructor-id');
        dropdown.innerHTML = '<option value="">Select Instructor</option>';
        instructors.forEach(instructor => {
            dropdown.innerHTML += `<option value="${instructor.instructor_id}">${instructor.first_name} ${instructor.last_name}</option>`;
        });
    } catch (error) {
        console.error('Error loading instructors:', error);
    }
}

async function editInstructor(id) {
    try {
        const response = await fetch(`${API_URL}/instructors/${id}`);
        const instructor = await response.json();
        
        await loadDepartments();
        
        document.getElementById('instructor-id').value = instructor.instructor_id;
        document.getElementById('instructor-department-id').value = instructor.department_id || '';
        document.getElementById('instructor-first-name').value = instructor.first_name;
        document.getElementById('instructor-last-name').value = instructor.last_name;
        document.getElementById('instructor-email').value = instructor.email || '';
        document.getElementById('instructor-phone').value = instructor.phone || '';
        document.getElementById('instructor-hire-date').value = instructor.hire_date ? instructor.hire_date.split('T')[0] : '';
        document.getElementById('instructor-salary').value = instructor.salary || '';
        
        document.getElementById('instructors-form').style.display = 'block';
        document.getElementById('instructors-form-title').textContent = 'Edit Instructor';
        currentEditingId = id;
    } catch (error) {
        console.error('Error loading instructor:', error);
        showMessage('error', 'Failed to load instructor');
    }
}

async function deleteInstructor(id) {
    if (!confirm('Are you sure you want to delete this instructor?')) return;
    
    try {
        const response = await fetch(`${API_URL}/instructors/${id}`, {
            method: 'DELETE'
        });
        
        if (response.ok) {
            showMessage('success', 'Instructor deleted successfully');
            loadInstructors();
        } else {
            const error = await response.json();
            showMessage('error', error.error || 'Failed to delete instructor');
        }
    } catch (error) {
        console.error('Error deleting instructor:', error);
        showMessage('error', 'Failed to delete instructor');
    }
}

document.getElementById('instructor-form')?.addEventListener('submit', async (e) => {
    e.preventDefault();
    
    const data = {
        department_id: document.getElementById('instructor-department-id').value || null,
        first_name: document.getElementById('instructor-first-name').value,
        last_name: document.getElementById('instructor-last-name').value,
        email: document.getElementById('instructor-email').value,
        phone: document.getElementById('instructor-phone').value,
        hire_date: document.getElementById('instructor-hire-date').value || null,
        salary: document.getElementById('instructor-salary').value || null
    };
    
    const id = document.getElementById('instructor-id').value;
    const method = id ? 'PUT' : 'POST';
    const url = id ? `${API_URL}/instructors/${id}` : `${API_URL}/instructors`;
    
    try {
        const response = await fetch(url, {
            method,
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data)
        });
        
        if (response.ok) {
            showMessage('success', id ? 'Instructor updated successfully' : 'Instructor created successfully');
            cancelForm('instructors');
            loadInstructors();
        } else {
            const error = await response.json();
            showMessage('error', error.error || 'Failed to save instructor');
        }
    } catch (error) {
        console.error('Error saving instructor:', error);
        showMessage('error', 'Failed to save instructor');
    }
});

// ============================================
// COURSES
// ============================================

async function loadCourses() {
    try {
        const response = await fetch(`${API_URL}/courses`);
        const courses = await response.json();
        
        const tbody = document.querySelector('#courses-table tbody');
        tbody.innerHTML = '';
        
        if (courses.length === 0) {
            tbody.innerHTML = '<tr><td colspan="9" class="empty-state"><p>No courses found. Add one to get started!</p></td></tr>';
            return;
        }
        
        courses.forEach(course => {
            const row = `
                <tr>
                    <td>${course.course_id}</td>
                    <td>${course.course_code}</td>
                    <td>${course.course_name}</td>
                    <td>${course.department_name || 'N/A'}</td>
                    <td>${course.instructor_name || 'N/A'}</td>
                    <td>${course.credits || 'N/A'}</td>
                    <td>${course.semester || 'N/A'}</td>
                    <td>${course.year || 'N/A'}</td>
                    <td class="action-buttons">
                        <button class="btn btn-warning" onclick="editCourse(${course.course_id})">Edit</button>
                        <button class="btn btn-danger" onclick="deleteCourse(${course.course_id})">Delete</button>
                    </td>
                </tr>
            `;
            tbody.innerHTML += row;
        });
    } catch (error) {
        console.error('Error loading courses:', error);
        showMessage('error', 'Failed to load courses');
    }
}

async function loadCoursesForDropdown() {
    try {
        const response = await fetch(`${API_URL}/courses`);
        const courses = await response.json();
        
        const dropdown = document.getElementById('enrollment-course-id');
        dropdown.innerHTML = '<option value="">Select Course</option>';
        courses.forEach(course => {
            dropdown.innerHTML += `<option value="${course.course_id}">${course.course_code} - ${course.course_name}</option>`;
        });
    } catch (error) {
        console.error('Error loading courses:', error);
    }
}

async function editCourse(id) {
    try {
        const response = await fetch(`${API_URL}/courses/${id}`);
        const course = await response.json();
        
        await loadDepartments();
        await loadInstructorsForDropdown();
        
        document.getElementById('course-id').value = course.course_id;
        document.getElementById('course-code').value = course.course_code;
        document.getElementById('course-name').value = course.course_name;
        document.getElementById('course-department-id').value = course.department_id || '';
        document.getElementById('course-instructor-id').value = course.instructor_id || '';
        document.getElementById('course-credits').value = course.credits || '';
        document.getElementById('course-semester').value = course.semester || '';
        document.getElementById('course-year').value = course.year || '';
        
        document.getElementById('courses-form').style.display = 'block';
        document.getElementById('courses-form-title').textContent = 'Edit Course';
        currentEditingId = id;
    } catch (error) {
        console.error('Error loading course:', error);
        showMessage('error', 'Failed to load course');
    }
}

async function deleteCourse(id) {
    if (!confirm('Are you sure you want to delete this course?')) return;
    
    try {
        const response = await fetch(`${API_URL}/courses/${id}`, {
            method: 'DELETE'
        });
        
        if (response.ok) {
            showMessage('success', 'Course deleted successfully');
            loadCourses();
        } else {
            const error = await response.json();
            showMessage('error', error.error || 'Failed to delete course');
        }
    } catch (error) {
        console.error('Error deleting course:', error);
        showMessage('error', 'Failed to delete course');
    }
}

document.getElementById('course-form')?.addEventListener('submit', async (e) => {
    e.preventDefault();
    
    const data = {
        course_code: document.getElementById('course-code').value,
        course_name: document.getElementById('course-name').value,
        department_id: document.getElementById('course-department-id').value || null,
        instructor_id: document.getElementById('course-instructor-id').value || null,
        credits: document.getElementById('course-credits').value || null,
        semester: document.getElementById('course-semester').value,
        year: document.getElementById('course-year').value || null
    };
    
    const id = document.getElementById('course-id').value;
    const method = id ? 'PUT' : 'POST';
    const url = id ? `${API_URL}/courses/${id}` : `${API_URL}/courses`;
    
    try {
        const response = await fetch(url, {
            method,
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data)
        });
        
        if (response.ok) {
            showMessage('success', id ? 'Course updated successfully' : 'Course created successfully');
            cancelForm('courses');
            loadCourses();
        } else {
            const error = await response.json();
            showMessage('error', error.error || 'Failed to save course');
        }
    } catch (error) {
        console.error('Error saving course:', error);
        showMessage('error', 'Failed to save course');
    }
});

// ============================================
// STUDENTS
// ============================================

async function loadStudents() {
    try {
        const response = await fetch(`${API_URL}/students`);
        const students = await response.json();
        
        const tbody = document.querySelector('#students-table tbody');
        tbody.innerHTML = '';
        
        if (students.length === 0) {
            tbody.innerHTML = '<tr><td colspan="9" class="empty-state"><p>No students found. Add one to get started!</p></td></tr>';
            return;
        }
        
        students.forEach(student => {
            const row = `
                <tr>
                    <td>${student.student_id}</td>
                    <td>${student.first_name} ${student.last_name}</td>
                    <td>${student.email || 'N/A'}</td>
                    <td>${student.phone || 'N/A'}</td>
                    <td>${student.date_of_birth ? new Date(student.date_of_birth).toLocaleDateString() : 'N/A'}</td>
                    <td>${student.enrollment_date ? new Date(student.enrollment_date).toLocaleDateString() : 'N/A'}</td>
                    <td>${student.major_name || 'N/A'}</td>
                    <td>${student.gpa || 'N/A'}</td>
                    <td class="action-buttons">
                        <button class="btn btn-warning" onclick="editStudent(${student.student_id})">Edit</button>
                        <button class="btn btn-danger" onclick="deleteStudent(${student.student_id})">Delete</button>
                    </td>
                </tr>
            `;
            tbody.innerHTML += row;
        });
    } catch (error) {
        console.error('Error loading students:', error);
        showMessage('error', 'Failed to load students');
    }
}

async function loadStudentsForDropdown() {
    try {
        const response = await fetch(`${API_URL}/students`);
        const students = await response.json();
        
        const dropdowns = ['#enrollment-student-id', '#history-student-id'];
        dropdowns.forEach(selector => {
            const dropdown = document.querySelector(selector);
            if (dropdown) {
                dropdown.innerHTML = '<option value="">Select Student</option>';
                students.forEach(student => {
                    dropdown.innerHTML += `<option value="${student.student_id}">${student.first_name} ${student.last_name}</option>`;
                });
            }
        });
    } catch (error) {
        console.error('Error loading students:', error);
    }
}

async function editStudent(id) {
    try {
        const response = await fetch(`${API_URL}/students/${id}`);
        const student = await response.json();
        
        await loadDepartments();
        
        document.getElementById('student-id').value = student.student_id;
        document.getElementById('student-first-name').value = student.first_name;
        document.getElementById('student-last-name').value = student.last_name;
        document.getElementById('student-email').value = student.email || '';
        document.getElementById('student-phone').value = student.phone || '';
        document.getElementById('student-dob').value = student.date_of_birth ? student.date_of_birth.split('T')[0] : '';
        document.getElementById('student-enrollment-date').value = student.enrollment_date ? student.enrollment_date.split('T')[0] : '';
        document.getElementById('student-major-id').value = student.major_department_id || '';
        document.getElementById('student-gpa').value = student.gpa || '';
        
        document.getElementById('students-form').style.display = 'block';
        document.getElementById('students-form-title').textContent = 'Edit Student';
        currentEditingId = id;
    } catch (error) {
        console.error('Error loading student:', error);
        showMessage('error', 'Failed to load student');
    }
}

async function deleteStudent(id) {
    if (!confirm('Are you sure you want to delete this student?')) return;
    
    try {
        const response = await fetch(`${API_URL}/students/${id}`, {
            method: 'DELETE'
        });
        
        if (response.ok) {
            showMessage('success', 'Student deleted successfully');
            loadStudents();
        } else {
            const error = await response.json();
            showMessage('error', error.error || 'Failed to delete student');
        }
    } catch (error) {
        console.error('Error deleting student:', error);
        showMessage('error', 'Failed to delete student');
    }
}

document.getElementById('student-form')?.addEventListener('submit', async (e) => {
    e.preventDefault();
    
    const data = {
        first_name: document.getElementById('student-first-name').value,
        last_name: document.getElementById('student-last-name').value,
        email: document.getElementById('student-email').value,
        phone: document.getElementById('student-phone').value,
        date_of_birth: document.getElementById('student-dob').value || null,
        enrollment_date: document.getElementById('student-enrollment-date').value || null,
        major_department_id: document.getElementById('student-major-id').value || null,
        gpa: document.getElementById('student-gpa').value || null
    };
    
    const id = document.getElementById('student-id').value;
    const method = id ? 'PUT' : 'POST';
    const url = id ? `${API_URL}/students/${id}` : `${API_URL}/students`;
    
    try {
        const response = await fetch(url, {
            method,
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data)
        });
        
        if (response.ok) {
            showMessage('success', id ? 'Student updated successfully' : 'Student created successfully');
            cancelForm('students');
            loadStudents();
        } else {
            const error = await response.json();
            showMessage('error', error.error || 'Failed to save student');
        }
    } catch (error) {
        console.error('Error saving student:', error);
        showMessage('error', 'Failed to save student');
    }
});

// ============================================
// ENROLLMENTS
// ============================================

async function loadEnrollments() {
    try {
        const response = await fetch(`${API_URL}/enrollments`);
        const enrollments = await response.json();
        
        const tbody = document.querySelector('#enrollments-table tbody');
        tbody.innerHTML = '';
        
        if (enrollments.length === 0) {
            tbody.innerHTML = '<tr><td colspan="7" class="empty-state"><p>No enrollments found. Add one to get started!</p></td></tr>';
            return;
        }
        
        enrollments.forEach(enrollment => {
            const row = `
                <tr>
                    <td>${enrollment.enrollment_id}</td>
                    <td>${enrollment.student_name || 'N/A'}</td>
                    <td>${enrollment.course_code ? enrollment.course_code + ' - ' + enrollment.course_name : 'N/A'}</td>
                    <td>${enrollment.enrollment_date ? new Date(enrollment.enrollment_date).toLocaleDateString() : 'N/A'}</td>
                    <td>${enrollment.grade || 'N/A'}</td>
                    <td>${enrollment.status || 'N/A'}</td>
                    <td class="action-buttons">
                        <button class="btn btn-warning" onclick="editEnrollment(${enrollment.enrollment_id})">Edit</button>
                        <button class="btn btn-danger" onclick="deleteEnrollment(${enrollment.enrollment_id})">Delete</button>
                    </td>
                </tr>
            `;
            tbody.innerHTML += row;
        });
    } catch (error) {
        console.error('Error loading enrollments:', error);
        showMessage('error', 'Failed to load enrollments');
    }
}

async function editEnrollment(id) {
    try {
        const response = await fetch(`${API_URL}/enrollments/${id}`);
        const enrollment = await response.json();
        
        await loadStudentsForDropdown();
        await loadCoursesForDropdown();
        
        document.getElementById('enrollment-id').value = enrollment.enrollment_id;
        document.getElementById('enrollment-student-id').value = enrollment.student_id || '';
        document.getElementById('enrollment-course-id').value = enrollment.course_id || '';
        document.getElementById('enrollment-date').value = enrollment.enrollment_date ? enrollment.enrollment_date.split('T')[0] : '';
        document.getElementById('enrollment-grade').value = enrollment.grade || '';
        document.getElementById('enrollment-status').value = enrollment.status || 'Enrolled';
        
        document.getElementById('enrollments-form').style.display = 'block';
        document.getElementById('enrollments-form-title').textContent = 'Edit Enrollment';
        currentEditingId = id;
    } catch (error) {
        console.error('Error loading enrollment:', error);
        showMessage('error', 'Failed to load enrollment');
    }
}

async function deleteEnrollment(id) {
    if (!confirm('Are you sure you want to delete this enrollment?')) return;
    
    try {
        const response = await fetch(`${API_URL}/enrollments/${id}`, {
            method: 'DELETE'
        });
        
        if (response.ok) {
            showMessage('success', 'Enrollment deleted successfully');
            loadEnrollments();
        } else {
            const error = await response.json();
            showMessage('error', error.error || 'Failed to delete enrollment');
        }
    } catch (error) {
        console.error('Error deleting enrollment:', error);
        showMessage('error', 'Failed to delete enrollment');
    }
}

document.getElementById('enrollment-form')?.addEventListener('submit', async (e) => {
    e.preventDefault();
    
    const data = {
        student_id: document.getElementById('enrollment-student-id').value,
        course_id: document.getElementById('enrollment-course-id').value,
        enrollment_date: document.getElementById('enrollment-date').value || null,
        grade: document.getElementById('enrollment-grade').value || null,
        status: document.getElementById('enrollment-status').value
    };
    
    const id = document.getElementById('enrollment-id').value;
    const method = id ? 'PUT' : 'POST';
    const url = id ? `${API_URL}/enrollments/${id}` : `${API_URL}/enrollments`;
    
    try {
        const response = await fetch(url, {
            method,
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data)
        });
        
        if (response.ok) {
            showMessage('success', id ? 'Enrollment updated successfully' : 'Enrollment created successfully');
            cancelForm('enrollments');
            loadEnrollments();
        } else {
            const error = await response.json();
            showMessage('error', error.error || 'Failed to save enrollment');
        }
    } catch (error) {
        console.error('Error saving enrollment:', error);
        showMessage('error', 'Failed to save enrollment');
    }
});

// ============================================
// STUDENT HISTORY
// ============================================

async function loadStudentHistory() {
    try {
        const response = await fetch(`${API_URL}/studenthistory`);
        const history = await response.json();
        
        const tbody = document.querySelector('#student-history-table tbody');
        tbody.innerHTML = '';
        
        if (history.length === 0) {
            tbody.innerHTML = '<tr><td colspan="8" class="empty-state"><p>No student history records found. Add one to get started!</p></td></tr>';
            return;
        }
        
        history.forEach(record => {
            const row = `
                <tr>
                    <td>${record.history_id}</td>
                    <td>${record.student_name || 'N/A'}</td>
                    <td>${record.semester || 'N/A'}</td>
                    <td>${record.year || 'N/A'}</td>
                    <td>${record.gpa || 'N/A'}</td>
                    <td>${record.credits_earned || 'N/A'}</td>
                    <td>${record.notes || 'N/A'}</td>
                    <td class="action-buttons">
                        <button class="btn btn-warning" onclick="editStudentHistory(${record.history_id})">Edit</button>
                        <button class="btn btn-danger" onclick="deleteStudentHistory(${record.history_id})">Delete</button>
                    </td>
                </tr>
            `;
            tbody.innerHTML += row;
        });
    } catch (error) {
        console.error('Error loading student history:', error);
        showMessage('error', 'Failed to load student history');
    }
}

async function editStudentHistory(id) {
    try {
        const response = await fetch(`${API_URL}/studenthistory/${id}`);
        const record = await response.json();
        
        await loadStudentsForDropdown();
        
        document.getElementById('history-id').value = record.history_id;
        document.getElementById('history-student-id').value = record.student_id || '';
        document.getElementById('history-semester').value = record.semester || '';
        document.getElementById('history-year').value = record.year || '';
        document.getElementById('history-gpa').value = record.gpa || '';
        document.getElementById('history-credits').value = record.credits_earned || '';
        document.getElementById('history-notes').value = record.notes || '';
        
        document.getElementById('student-history-form').style.display = 'block';
        document.getElementById('student-history-form-title').textContent = 'Edit History Record';
        currentEditingId = id;
    } catch (error) {
        console.error('Error loading student history:', error);
        showMessage('error', 'Failed to load student history');
    }
}

async function deleteStudentHistory(id) {
    if (!confirm('Are you sure you want to delete this student history record?')) return;
    
    try {
        const response = await fetch(`${API_URL}/studenthistory/${id}`, {
            method: 'DELETE'
        });
        
        if (response.ok) {
            showMessage('success', 'Student history record deleted successfully');
            loadStudentHistory();
        } else {
            const error = await response.json();
            showMessage('error', error.error || 'Failed to delete student history');
        }
    } catch (error) {
        console.error('Error deleting student history:', error);
        showMessage('error', 'Failed to delete student history');
    }
}

document.getElementById('history-form')?.addEventListener('submit', async (e) => {
    e.preventDefault();
    
    const data = {
        student_id: document.getElementById('history-student-id').value,
        semester: document.getElementById('history-semester').value,
        year: document.getElementById('history-year').value || null,
        gpa: document.getElementById('history-gpa').value || null,
        credits_earned: document.getElementById('history-credits').value || null,
        notes: document.getElementById('history-notes').value
    };
    
    const id = document.getElementById('history-id').value;
    const method = id ? 'PUT' : 'POST';
    const url = id ? `${API_URL}/studenthistory/${id}` : `${API_URL}/studenthistory`;
    
    try {
        const response = await fetch(url, {
            method,
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data)
        });
        
        if (response.ok) {
            showMessage('success', id ? 'Student history updated successfully' : 'Student history created successfully');
            cancelForm('student-history');
            loadStudentHistory();
        } else {
            const error = await response.json();
            showMessage('error', error.error || 'Failed to save student history');
        }
    } catch (error) {
        console.error('Error saving student history:', error);
        showMessage('error', 'Failed to save student history');
    }
});

// ============================================
// UTILITY FUNCTIONS
// ============================================

function showMessage(type, message) {
    // Create a simple alert for now
    alert(message);
}
