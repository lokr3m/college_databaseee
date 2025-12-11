# College Database Management System

A simple and efficient web-based application for managing college database with MySQL backend and a clean frontend interface.

## Features

- **Complete CRUD Operations** for all tables:
  - Departments
  - Department Heads
  - Instructors
  - Courses
  - Students
  - Enrollments
  - Student History

- **Modern UI**: Clean and responsive interface built with HTML, CSS, and JavaScript
- **RESTful API**: Node.js/Express backend with proper API endpoints
- **MySQL Database**: Relational database with proper foreign key relationships

## Database Tables

The system manages the following tables:

1. **departments** - Academic departments with budget and building information
2. **departmentheads** - Department heads with contact information
3. **instructors** - Teaching staff with salary and hire date information
4. **courses** - Course catalog with credits, semester, and year information
5. **students** - Student records with GPA and enrollment information
6. **enrollments** - Student course enrollments with grades and status
7. **studenthistory** - Historical academic performance records

## Prerequisites

- Node.js (v14 or higher)
- MySQL (v5.7 or higher)
- npm (comes with Node.js)

## Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd college_databaseee
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Set up MySQL database**
   
   a. Create a new database:
   ```sql
   CREATE DATABASE college_db;
   ```
   
   b. Import the schema:
   ```bash
   mysql -u root -p college_db < schema.sql
   ```
   
   Or run the schema.sql file directly in your MySQL client.

4. **Configure environment variables**
   
   Copy `.env.example` to `.env` and update with your database credentials:
   ```bash
   cp .env.example .env
   ```
   
   Edit `.env` file:
   ```
   DB_HOST=localhost
   DB_USER=root
   DB_PASSWORD=your_mysql_password
   DB_NAME=college_db
   DB_PORT=3306
   PORT=3000
   ```

## Usage

1. **Start the server**
   ```bash
   npm start
   ```
   
   For development with auto-restart:
   ```bash
   npm run dev
   ```

2. **Access the application**
   
   Open your web browser and navigate to:
   ```
   http://localhost:3000
   ```

## API Endpoints

All endpoints are prefixed with `/api`

### Departments
- GET `/api/departments` - Get all departments
- GET `/api/departments/:id` - Get single department
- POST `/api/departments` - Create department
- PUT `/api/departments/:id` - Update department
- DELETE `/api/departments/:id` - Delete department

### Department Heads
- GET `/api/departmentheads` - Get all department heads
- GET `/api/departmentheads/:id` - Get single department head
- POST `/api/departmentheads` - Create department head
- PUT `/api/departmentheads/:id` - Update department head
- DELETE `/api/departmentheads/:id` - Delete department head

### Instructors
- GET `/api/instructors` - Get all instructors
- GET `/api/instructors/:id` - Get single instructor
- POST `/api/instructors` - Create instructor
- PUT `/api/instructors/:id` - Update instructor
- DELETE `/api/instructors/:id` - Delete instructor

### Courses
- GET `/api/courses` - Get all courses
- GET `/api/courses/:id` - Get single course
- POST `/api/courses` - Create course
- PUT `/api/courses/:id` - Update course
- DELETE `/api/courses/:id` - Delete course

### Students
- GET `/api/students` - Get all students
- GET `/api/students/:id` - Get single student
- POST `/api/students` - Create student
- PUT `/api/students/:id` - Update student
- DELETE `/api/students/:id` - Delete student

### Enrollments
- GET `/api/enrollments` - Get all enrollments
- GET `/api/enrollments/:id` - Get single enrollment
- POST `/api/enrollments` - Create enrollment
- PUT `/api/enrollments/:id` - Update enrollment
- DELETE `/api/enrollments/:id` - Delete enrollment

### Student History
- GET `/api/studenthistory` - Get all student history records
- GET `/api/studenthistory/:id` - Get single student history record
- POST `/api/studenthistory` - Create student history record
- PUT `/api/studenthistory/:id` - Update student history record
- DELETE `/api/studenthistory/:id` - Delete student history record

## Project Structure

```
college_databaseee/
├── config/
│   └── database.js          # Database connection configuration
├── public/
│   ├── index.html           # Main HTML file
│   ├── style.css            # Styles
│   └── app.js               # Frontend JavaScript
├── .env                     # Environment variables (create from .env.example)
├── .env.example             # Example environment variables
├── package.json             # Node.js dependencies
├── schema.sql               # Database schema with sample data
├── server.js                # Express server and API routes
└── README.md                # This file
```

## Sample Data

The `schema.sql` file includes sample data for testing:
- 4 departments
- 3 department heads
- 4 instructors
- 4 courses
- 4 students
- 5 enrollments
- 3 student history records

## Technologies Used

- **Backend**: Node.js, Express.js
- **Database**: MySQL
- **Frontend**: HTML5, CSS3, Vanilla JavaScript
- **Dependencies**:
  - mysql2 - MySQL client for Node.js
  - express - Web framework
  - cors - CORS middleware
  - dotenv - Environment variable management

## Troubleshooting

### Database Connection Issues
- Ensure MySQL is running: `sudo service mysql status` (Linux) or check Services (Windows)
- Verify credentials in `.env` file
- Check if the database exists: `SHOW DATABASES;` in MySQL

### Port Already in Use
- Change the PORT in `.env` file to a different port
- Or kill the process using port 3000: `lsof -ti:3000 | xargs kill` (Mac/Linux)

### Module Not Found Errors
- Run `npm install` to install all dependencies
- Delete `node_modules` and `package-lock.json`, then run `npm install` again

## Security Considerations

This application is designed for **local development and educational purposes**. Before deploying to production, consider implementing the following security measures:

### For Production Deployment

1. **Rate Limiting**: Add rate limiting middleware (e.g., `express-rate-limit`) to prevent abuse:
   ```bash
   npm install express-rate-limit
   ```
   ```javascript
   const rateLimit = require('express-rate-limit');
   const limiter = rateLimit({
     windowMs: 15 * 60 * 1000, // 15 minutes
     max: 100 // limit each IP to 100 requests per windowMs
   });
   app.use('/api/', limiter);
   ```

2. **Authentication**: Implement user authentication and authorization
3. **HTTPS**: Use SSL/TLS certificates for encrypted connections
4. **Input Sanitization**: Add additional input sanitization to prevent SQL injection
5. **Environment Variables**: Never commit `.env` file with real credentials
6. **CORS**: Configure CORS to allow only trusted domains (already configurable via `.env`)
7. **Database User**: Use a MySQL user with limited privileges instead of root
8. **Password Validation**: Require strong passwords in the database configuration
9. **Session Management**: Implement proper session handling for user authentication
10. **Logging**: Add comprehensive logging for security auditing

### Current Security Features

- ✅ Input validation on required fields
- ✅ Parameterized queries to prevent SQL injection
- ✅ Generic error messages to avoid information leakage
- ✅ Configurable CORS (production-ready)
- ✅ Environment-based configuration
- ✅ Password warning for empty database passwords

## License

MIT

## Contributing

Feel free to submit issues and enhancement requests!
