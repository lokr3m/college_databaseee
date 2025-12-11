-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: localhost    Database: college_database
-- ------------------------------------------------------
-- Server version	8.0.43-0ubuntu0.24.04.2

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Courses`
--

DROP TABLE IF EXISTS `Courses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Courses` (
  `course_id` int NOT NULL AUTO_INCREMENT,
  `course_code` varchar(20) NOT NULL,
  `course_name` varchar(100) NOT NULL,
  `department_id` int NOT NULL,
  `instructor_id` int DEFAULT NULL,
  `credits` int NOT NULL DEFAULT '3',
  `semester` varchar(20) DEFAULT NULL,
  `year` int DEFAULT NULL,
  `room_number` varchar(20) DEFAULT NULL,
  `schedule` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`course_id`),
  UNIQUE KEY `course_code` (`course_code`),
  KEY `idx_department` (`department_id`),
  KEY `idx_instructor` (`instructor_id`),
  KEY `idx_course_code` (`course_code`),
  CONSTRAINT `Courses_ibfk_1` FOREIGN KEY (`department_id`) REFERENCES `Departments` (`department_id`) ON DELETE CASCADE,
  CONSTRAINT `Courses_ibfk_2` FOREIGN KEY (`instructor_id`) REFERENCES `Instructors` (`instructor_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Courses`
--

LOCK TABLES `Courses` WRITE;
/*!40000 ALTER TABLE `Courses` DISABLE KEYS */;
INSERT INTO `Courses` VALUES (1,'CS101','Introduction to Programming',1,1,3,'Fall',2024,'ENG-A101','Mon/Wed 9:00-10:30','2025-11-27 09:01:46','2025-11-27 09:01:46'),(2,'CS201','Data Structures',1,2,4,'Fall',2024,'ENG-A102','Tue/Thu 10:00-12:00','2025-11-27 09:01:46','2025-11-27 09:01:46'),(3,'CS301','Database Systems',1,1,3,'Spring',2024,'ENG-A103','Mon/Wed 14:00-15:30','2025-11-27 09:01:46','2025-11-27 09:01:46'),(4,'MATH101','Calculus I',2,3,4,'Fall',2024,'SCI-B201','Mon/Wed/Fri 11:00-12:00','2025-11-27 09:01:46','2025-11-27 09:01:46'),(5,'MATH201','Linear Algebra',2,4,3,'Fall',2024,'SCI-B202','Tue/Thu 13:00-14:30','2025-11-27 09:01:46','2025-11-27 09:01:46'),(6,'PHY101','Physics I',3,5,4,'Fall',2024,'SCI-C101','Mon/Wed 15:00-17:00','2025-11-27 09:01:46','2025-11-27 09:01:46'),(7,'ENG101','English Composition',4,6,3,'Fall',2024,'HUM-101','Tue/Thu 9:00-10:30','2025-11-27 09:01:46','2025-11-27 09:01:46'),(8,'BUS101','Introduction to Business',5,7,3,'Fall',2024,'BUS-201','Mon/Wed 10:00-11:30','2025-11-27 09:01:46','2025-11-27 09:01:46'),(9,'BUS201','Marketing Fundamentals',5,8,3,'Fall',2024,'BUS-202','Tue/Thu 14:00-15:30','2025-11-27 09:01:46','2025-11-27 09:01:46');
/*!40000 ALTER TABLE `Courses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `DepartmentHeads`
--

DROP TABLE IF EXISTS `DepartmentHeads`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `DepartmentHeads` (
  `department_id` int NOT NULL,
  `instructor_id` int NOT NULL,
  `start_date` date NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`department_id`),
  UNIQUE KEY `instructor_id` (`instructor_id`),
  CONSTRAINT `DepartmentHeads_ibfk_1` FOREIGN KEY (`department_id`) REFERENCES `Departments` (`department_id`) ON DELETE CASCADE,
  CONSTRAINT `DepartmentHeads_ibfk_2` FOREIGN KEY (`instructor_id`) REFERENCES `Instructors` (`instructor_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DepartmentHeads`
--

LOCK TABLES `DepartmentHeads` WRITE;
/*!40000 ALTER TABLE `DepartmentHeads` DISABLE KEYS */;
INSERT INTO `DepartmentHeads` VALUES (1,1,'2020-01-01','2025-11-27 09:01:46','2025-11-27 09:01:46'),(2,3,'2019-07-01','2025-11-27 09:01:46','2025-11-27 09:01:46'),(3,5,'2018-01-01','2025-11-27 09:01:46','2025-11-27 09:01:46'),(4,6,'2021-01-01','2025-11-27 09:01:46','2025-11-27 09:01:46'),(5,7,'2017-09-01','2025-11-27 09:01:46','2025-11-27 09:01:46');
/*!40000 ALTER TABLE `DepartmentHeads` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Departments`
--

DROP TABLE IF EXISTS `Departments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Departments` (
  `department_id` int NOT NULL AUTO_INCREMENT,
  `department_name` varchar(100) NOT NULL,
  `building` varchar(100) DEFAULT NULL,
  `budget` decimal(12,2) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`department_id`),
  UNIQUE KEY `department_name` (`department_name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Departments`
--

LOCK TABLES `Departments` WRITE;
/*!40000 ALTER TABLE `Departments` DISABLE KEYS */;
INSERT INTO `Departments` VALUES (1,'Computer Science','Engineering Building A',500000.00,'2025-11-27 09:01:46','2025-11-27 09:01:46'),(2,'Mathematics','Science Building B',350000.00,'2025-11-27 09:01:46','2025-11-27 09:01:46'),(3,'Physics','Science Building C',450000.00,'2025-11-27 09:01:46','2025-11-27 09:01:46'),(4,'English','Humanities Building',250000.00,'2025-11-27 09:01:46','2025-11-27 09:01:46'),(5,'Business Administration','Business Hall',600000.00,'2025-11-27 09:01:46','2025-11-27 09:01:46');
/*!40000 ALTER TABLE `Departments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Enrollments`
--

DROP TABLE IF EXISTS `Enrollments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Enrollments` (
  `enrollment_id` int NOT NULL AUTO_INCREMENT,
  `student_id` int NOT NULL,
  `course_id` int NOT NULL,
  `enrollment_date` date NOT NULL,
  `grade` varchar(2) DEFAULT NULL,
  `status` varchar(20) DEFAULT 'Active',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`enrollment_id`),
  UNIQUE KEY `unique_enrollment` (`student_id`,`course_id`),
  KEY `idx_student` (`student_id`),
  KEY `idx_course` (`course_id`),
  CONSTRAINT `Enrollments_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `Students` (`student_id`) ON DELETE CASCADE,
  CONSTRAINT `Enrollments_ibfk_2` FOREIGN KEY (`course_id`) REFERENCES `Courses` (`course_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=112 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Enrollments`
--

LOCK TABLES `Enrollments` WRITE;
/*!40000 ALTER TABLE `Enrollments` DISABLE KEYS */;
INSERT INTO `Enrollments` VALUES (1,1,1,'2024-08-20','A','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(2,1,2,'2024-08-20','A-','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(3,1,4,'2024-08-20','B+','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(4,2,1,'2024-08-20','B+','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(5,2,3,'2024-08-20','B','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(6,3,4,'2024-08-20','A','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(7,3,5,'2024-08-20','A-','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(8,4,6,'2024-08-20','A','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(9,4,7,'2024-08-20','A-','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(10,5,8,'2024-08-20','B','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(11,5,9,'2024-08-20','B+','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(12,6,7,'2024-08-20','A-','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(13,6,4,'2024-08-20','B+','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(14,7,1,'2024-08-20','C+','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(15,7,2,'2024-08-20','C','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(16,8,4,'2024-08-20','A','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(17,8,5,'2024-08-20','A','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(18,9,1,'2024-08-20','A-','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(19,9,2,'2024-08-20','B+','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(20,10,4,'2024-08-20','A','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(21,10,5,'2024-08-20','A-','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(22,11,6,'2024-08-20','A','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(23,11,7,'2024-08-20','B+','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(24,12,8,'2024-08-20','B','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(25,12,9,'2024-08-20','B+','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(26,13,1,'2024-08-20','A-','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(27,13,3,'2024-08-20','B+','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(28,14,4,'2024-08-20','A','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(29,14,5,'2024-08-20','A-','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(30,15,6,'2024-08-20','B+','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(31,15,7,'2024-08-20','B','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(32,16,7,'2024-08-20','B-','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(33,16,4,'2024-08-20','C+','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(34,17,8,'2024-08-20','A','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(35,17,9,'2024-08-20','A-','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(36,18,1,'2024-08-20','A-','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(37,18,2,'2024-08-20','B+','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(38,19,4,'2024-08-20','B','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(39,19,5,'2024-08-20','B+','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(40,20,6,'2024-08-20','A','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(41,20,7,'2024-08-20','A-','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(42,21,7,'2024-08-20','C+','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(43,21,4,'2024-08-20','C','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(44,22,8,'2024-08-20','A-','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(45,22,9,'2024-08-20','B+','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(46,23,1,'2024-08-20','A','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(47,23,2,'2024-08-20','A','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(48,24,4,'2024-08-20','B+','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(49,24,5,'2024-08-20','B','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(50,25,6,'2024-08-20','B+','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(51,25,7,'2024-08-20','A-','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(52,26,1,'2024-08-20','A-','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(53,26,3,'2024-08-20','A','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(54,27,4,'2024-08-20','A','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(55,27,5,'2024-08-20','A-','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(56,28,6,'2024-08-20','B','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(57,28,7,'2024-08-20','B+','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(58,29,7,'2024-08-20','A','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(59,29,4,'2024-08-20','A-','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(60,30,8,'2024-08-20','C+','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(61,30,9,'2024-08-20','B-','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(62,31,1,'2024-08-20','A-','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(63,31,2,'2024-08-20','B+','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(64,32,4,'2024-08-20','B+','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(65,32,5,'2024-08-20','B','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(66,33,6,'2024-08-20','A','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(67,33,7,'2024-08-20','A','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(68,34,7,'2024-08-20','B','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(69,34,4,'2024-08-20','B+','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(70,35,8,'2024-08-20','A-','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(71,35,9,'2024-08-20','A','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(72,36,1,'2024-08-20','A-','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(73,36,3,'2024-08-20','B+','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(74,37,4,'2024-08-20','B','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(75,37,5,'2024-08-20','B+','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(76,38,6,'2024-08-20','A-','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(77,38,7,'2024-08-20','B+','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(78,39,7,'2024-08-20','A','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(79,39,4,'2024-08-20','A-','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(80,40,8,'2024-08-20','B','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(81,40,9,'2024-08-20','B-','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(82,41,1,'2024-08-20','A-','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(83,41,2,'2024-08-20','B+','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(84,42,4,'2024-08-20','A','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(85,42,5,'2024-08-20','A-','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(86,43,6,'2024-08-20','C+','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(87,43,7,'2024-08-20','B-','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(88,44,7,'2024-08-20','A','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(89,44,4,'2024-08-20','A','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(90,45,8,'2024-08-20','B','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(91,45,9,'2024-08-20','B+','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(92,46,1,'2024-08-20','A-','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(93,46,3,'2024-08-20','B+','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(94,47,4,'2024-08-20','A','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(95,47,5,'2024-08-20','A-','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(96,48,6,'2024-08-20','B','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(97,48,7,'2024-08-20','B+','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(98,49,7,'2024-08-20','B+','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(99,49,4,'2024-08-20','B','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(100,50,8,'2024-08-20','A-','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(101,50,9,'2024-08-20','A','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(102,51,1,'2024-08-20','A','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(103,51,2,'2024-08-20','A-','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(104,52,4,'2024-08-20','B+','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(105,52,5,'2024-08-20','A-','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(106,53,6,'2024-08-20','A-','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(107,53,7,'2024-08-20','B+','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(108,54,7,'2024-08-20','A','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(109,54,4,'2024-08-20','A-','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(110,55,8,'2024-08-20','B','Active','2025-11-27 09:01:46','2025-11-27 09:01:46'),(111,55,9,'2024-08-20','B+','Active','2025-11-27 09:01:46','2025-11-27 09:01:46');
/*!40000 ALTER TABLE `Enrollments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Instructors`
--

DROP TABLE IF EXISTS `Instructors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Instructors` (
  `instructor_id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `department_id` int NOT NULL,
  `salary` decimal(10,2) DEFAULT NULL,
  `hire_date` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`instructor_id`),
  UNIQUE KEY `email` (`email`),
  KEY `idx_department` (`department_id`),
  KEY `idx_email` (`email`),
  CONSTRAINT `Instructors_ibfk_1` FOREIGN KEY (`department_id`) REFERENCES `Departments` (`department_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Instructors`
--

LOCK TABLES `Instructors` WRITE;
/*!40000 ALTER TABLE `Instructors` DISABLE KEYS */;
INSERT INTO `Instructors` VALUES (1,'John','Smith','john.smith@college.edu','555-0101',1,85000.00,'2015-08-15','2025-11-27 09:01:46','2025-11-27 09:01:46'),(2,'Emily','Johnson','emily.johnson@college.edu','555-0102',1,78000.00,'2017-01-10','2025-11-27 09:01:46','2025-11-27 09:01:46'),(3,'Michael','Williams','michael.williams@college.edu','555-0103',2,82000.00,'2014-09-01','2025-11-27 09:01:46','2025-11-27 09:01:46'),(4,'Sarah','Brown','sarah.brown@college.edu','555-0104',2,75000.00,'2018-08-20','2025-11-27 09:01:46','2025-11-27 09:01:46'),(5,'David','Jones','david.jones@college.edu','555-0105',3,88000.00,'2013-07-15','2025-11-27 09:01:46','2025-11-27 09:01:46'),(6,'Jennifer','Garcia','jennifer.garcia@college.edu','555-0106',4,72000.00,'2016-01-05','2025-11-27 09:01:46','2025-11-27 09:01:46'),(7,'Robert','Martinez','robert.martinez@college.edu','555-0107',5,95000.00,'2012-09-01','2025-11-27 09:01:46','2025-11-27 09:01:46'),(8,'Lisa','Anderson','lisa.anderson@college.edu','555-0108',5,87000.00,'2015-06-15','2025-11-27 09:01:46','2025-11-27 09:01:46');
/*!40000 ALTER TABLE `Instructors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `StudentHistory`
--

DROP TABLE IF EXISTS `StudentHistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `StudentHistory` (
  `history_id` int NOT NULL AUTO_INCREMENT,
  `student_id` int NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `enrollment_year` int DEFAULT NULL,
  `major_department_id` int DEFAULT NULL,
  `gpa` decimal(3,2) DEFAULT NULL,
  `original_created_at` timestamp NULL DEFAULT NULL,
  `original_updated_at` timestamp NULL DEFAULT NULL,
  `changed_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `change_type` enum('UPDATE','DELETE') NOT NULL DEFAULT 'UPDATE',
  PRIMARY KEY (`history_id`),
  KEY `idx_student_history` (`student_id`),
  KEY `idx_changed_at` (`changed_at`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `StudentHistory`
--

LOCK TABLES `StudentHistory` WRITE;
/*!40000 ALTER TABLE `StudentHistory` DISABLE KEYS */;
INSERT INTO `StudentHistory` VALUES (1,1,'Alice','Wilson','alice.wilson@student.college.edu','555-1001','2003-05-15',2023,1,3.50,'2023-09-01 07:00:00','2023-09-01 07:00:00','2023-12-15 12:30:00','UPDATE'),(2,1,'Alice','Wilson','alice.wilson@student.college.edu','555-1001','2003-05-15',2023,1,3.65,'2023-09-01 07:00:00','2023-12-15 12:30:00','2024-05-20 06:15:00','UPDATE'),(3,1,'Alice','Wilson','alice.wilson@student.college.edu','555-1001','2003-05-15',2023,1,3.75,'2023-09-01 07:00:00','2024-05-20 06:15:00','2024-09-10 08:00:00','UPDATE'),(4,2,'Bob','Taylor','bob.taylor@student.college.edu','555-1002-OLD','2002-11-22',2022,1,3.20,'2022-09-01 06:00:00','2022-09-01 06:00:00','2023-06-01 13:45:00','UPDATE'),(5,2,'Bob','Taylor','bob.taylor@student.college.edu','555-1002','2002-11-22',2022,1,3.35,'2022-09-01 06:00:00','2023-06-01 13:45:00','2024-01-15 08:20:00','UPDATE'),(6,9,'Mari','Tamm','mari.tamm@student.college.edu','555-1009','2003-03-12',2023,5,3.60,'2023-09-01 05:30:00','2023-09-01 05:30:00','2024-02-01 11:00:00','UPDATE'),(7,13,'Kadri','Rebane','kadri.rebane@student.college.edu','555-1013','2003-06-18',2023,1,3.45,'2023-09-01 07:00:00','2023-09-01 07:00:00','2024-01-20 12:00:00','UPDATE'),(8,26,'James','Anderson','james.anderson@student.college.edu','555-1026-OLD','2003-04-05',2023,1,3.70,'2023-09-01 06:30:00','2023-09-01 06:30:00','2024-03-15 08:30:00','UPDATE');
/*!40000 ALTER TABLE `StudentHistory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Students`
--

DROP TABLE IF EXISTS `Students`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Students` (
  `student_id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `enrollment_year` int DEFAULT NULL,
  `major_department_id` int DEFAULT NULL,
  `gpa` decimal(3,2) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`student_id`),
  UNIQUE KEY `email` (`email`),
  KEY `idx_email` (`email`),
  KEY `idx_major_department` (`major_department_id`),
  CONSTRAINT `Students_ibfk_1` FOREIGN KEY (`major_department_id`) REFERENCES `Departments` (`department_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Students`
--

LOCK TABLES `Students` WRITE;
/*!40000 ALTER TABLE `Students` DISABLE KEYS */;
INSERT INTO `Students` VALUES (1,'Alice','Wilson','alice.wilson@student.college.edu','555-1001','2003-05-15',2023,1,3.85,'2025-11-27 09:01:46','2025-11-27 09:01:46'),(2,'Bob','Taylor','bob.taylor@student.college.edu','555-1002','2002-11-22',2022,1,3.45,'2025-11-27 09:01:46','2025-11-27 09:01:46'),(3,'Charlie','Moore','charlie.moore@student.college.edu','555-1003','2003-08-10',2023,2,3.72,'2025-11-27 09:01:46','2025-11-27 09:01:46'),(4,'Diana','Thomas','diana.thomas@student.college.edu','555-1004','2004-02-28',2024,3,3.90,'2025-11-27 09:01:46','2025-11-27 09:01:46'),(5,'Edward','Jackson','edward.jackson@student.college.edu','555-1005','2003-07-19',2023,5,3.55,'2025-11-27 09:01:46','2025-11-27 09:01:46'),(6,'Fiona','White','fiona.white@student.college.edu','555-1006','2002-12-05',2022,4,3.68,'2025-11-27 09:01:46','2025-11-27 09:01:46'),(7,'George','Harris','george.harris@student.college.edu','555-1007','2003-09-14',2023,1,3.25,'2025-11-27 09:01:46','2025-11-27 09:01:46'),(8,'Hannah','Martin','hannah.martin@student.college.edu','555-1008','2004-04-30',2024,2,3.95,'2025-11-27 09:01:46','2025-11-27 09:01:46'),(9,'Mari','Tamm','mari.tamm@student.college.edu','555-1009','2003-03-12',2023,1,3.78,'2025-11-27 09:01:46','2025-11-27 09:01:46'),(10,'Kristjan','Kask','kristjan.kask@student.college.edu','555-1010','2002-07-25',2022,2,3.62,'2025-11-27 09:01:46','2025-11-27 09:01:46'),(11,'Liisa','Mägi','liisa.magi@student.college.edu','555-1011','2004-01-08',2024,3,3.88,'2025-11-27 09:01:46','2025-11-27 09:01:46'),(12,'Andres','Saar','andres.saar@student.college.edu','555-1012','2003-11-30',2023,5,3.42,'2025-11-27 09:01:46','2025-11-27 09:01:46'),(13,'Kadri','Rebane','kadri.rebane@student.college.edu','555-1013','2003-06-18',2023,1,3.67,'2025-11-27 09:01:46','2025-11-27 09:01:46'),(14,'Martin','Lepik','martin.lepik@student.college.edu','555-1014','2002-09-03',2022,2,3.81,'2025-11-27 09:01:46','2025-11-27 09:01:46'),(15,'Anna','Sepp','anna.sepp@student.college.edu','555-1015','2004-03-22',2024,3,3.54,'2025-11-27 09:01:46','2025-11-27 09:01:46'),(16,'Priit','Kuusk','priit.kuusk@student.college.edu','555-1016','2003-12-07',2023,4,3.39,'2025-11-27 09:01:46','2025-11-27 09:01:46'),(17,'Kertu','Pärn','kertu.parn@student.college.edu','555-1017','2002-04-14',2022,5,3.92,'2025-11-27 09:01:46','2025-11-27 09:01:46'),(18,'Taavi','Valk','taavi.valk@student.college.edu','555-1018','2003-08-29',2023,1,3.76,'2025-11-27 09:01:46','2025-11-27 09:01:46'),(19,'Marika','Rand','marika.rand@student.college.edu','555-1019','2004-05-11',2024,2,3.48,'2025-11-27 09:01:46','2025-11-27 09:01:46'),(20,'Siim','Koppel','siim.koppel@student.college.edu','555-1020','2002-10-26',2022,3,3.83,'2025-11-27 09:01:46','2025-11-27 09:01:46'),(21,'Liina','Sild','liina.sild@student.college.edu','555-1021','2003-01-19',2023,4,3.29,'2025-11-27 09:01:46','2025-11-27 09:01:46'),(22,'Rauno','Toom','rauno.toom@student.college.edu','555-1022','2004-07-04',2024,5,3.71,'2025-11-27 09:01:46','2025-11-27 09:01:46'),(23,'Piret','Oja','piret.oja@student.college.edu','555-1023','2002-02-08',2022,1,3.94,'2025-11-27 09:01:46','2025-11-27 09:01:46'),(24,'Meelis','Kivi','meelis.kivi@student.college.edu','555-1024','2003-11-13',2023,2,3.56,'2025-11-27 09:01:46','2025-11-27 09:01:46'),(25,'Triin','Mets','triin.mets@student.college.edu','555-1025','2004-06-27',2024,3,3.63,'2025-11-27 09:01:46','2025-11-27 09:01:46'),(26,'James','Anderson','james.anderson@student.college.edu','555-1026','2003-04-05',2023,1,3.79,'2025-11-27 09:01:46','2025-11-27 09:01:46'),(27,'Emma','Thompson','emma.thompson@student.college.edu','555-1027','2002-08-20',2022,2,3.87,'2025-11-27 09:01:46','2025-11-27 09:01:46'),(28,'William','Clark','william.clark@student.college.edu','555-1028','2004-01-15',2024,3,3.44,'2025-11-27 09:01:46','2025-11-27 09:01:46'),(29,'Olivia','Lewis','olivia.lewis@student.college.edu','555-1029','2003-10-09',2023,4,3.91,'2025-11-27 09:01:46','2025-11-27 09:01:46'),(30,'Benjamin','Walker','benjamin.walker@student.college.edu','555-1030','2002-05-28',2022,5,3.33,'2025-11-27 09:01:46','2025-11-27 09:01:46'),(31,'Sophia','Hall','sophia.hall@student.college.edu','555-1031','2003-07-17',2023,1,3.75,'2025-11-27 09:01:46','2025-11-27 09:01:46'),(32,'Lucas','Allen','lucas.allen@student.college.edu','555-1032','2004-12-03',2024,2,3.58,'2025-11-27 09:01:46','2025-11-27 09:01:46'),(33,'Isabella','Young','isabella.young@student.college.edu','555-1033','2002-03-12',2022,3,3.96,'2025-11-27 09:01:46','2025-11-27 09:01:46'),(34,'Mason','King','mason.king@student.college.edu','555-1034','2003-09-25',2023,4,3.41,'2025-11-27 09:01:46','2025-11-27 09:01:46'),(35,'Ava','Wright','ava.wright@student.college.edu','555-1035','2004-04-18',2024,5,3.82,'2025-11-27 09:01:46','2025-11-27 09:01:46'),(36,'Ethan','Scott','ethan.scott@student.college.edu','555-1036','2002-11-07',2022,1,3.69,'2025-11-27 09:01:46','2025-11-27 09:01:46'),(37,'Mia','Green','mia.green@student.college.edu','555-1037','2003-02-22',2023,2,3.53,'2025-11-27 09:01:46','2025-11-27 09:01:46'),(38,'Alexander','Adams','alexander.adams@student.college.edu','555-1038','2004-08-14',2024,3,3.77,'2025-11-27 09:01:46','2025-11-27 09:01:46'),(39,'Charlotte','Baker','charlotte.baker@student.college.edu','555-1039','2002-06-30',2022,4,3.89,'2025-11-27 09:01:46','2025-11-27 09:01:46'),(40,'Daniel','Nelson','daniel.nelson@student.college.edu','555-1040','2003-12-19',2023,5,3.46,'2025-11-27 09:01:46','2025-11-27 09:01:46'),(41,'Kaarel','Põld','kaarel.pold@student.college.edu','555-1041','2004-02-11',2024,1,3.72,'2025-11-27 09:01:46','2025-11-27 09:01:46'),(42,'Helen','Raud','helen.raud@student.college.edu','555-1042','2002-07-06',2022,2,3.85,'2025-11-27 09:01:46','2025-11-27 09:01:46'),(43,'Ott','Laas','ott.laas@student.college.edu','555-1043','2003-05-24',2023,3,3.38,'2025-11-27 09:01:46','2025-11-27 09:01:46'),(44,'Eliise','Nurm','eliise.nurm@student.college.edu','555-1044','2004-10-08',2024,4,3.93,'2025-11-27 09:01:46','2025-11-27 09:01:46'),(45,'Rasmus','Hint','rasmus.hint@student.college.edu','555-1045','2002-01-29',2022,5,3.51,'2025-11-27 09:01:46','2025-11-27 09:01:46'),(46,'Kätlin','Vaher','katlin.vaher@student.college.edu','555-1046','2003-08-03',2023,1,3.66,'2025-11-27 09:01:46','2025-11-27 09:01:46'),(47,'Silver','Teder','silver.teder@student.college.edu','555-1047','2004-04-16',2024,2,3.84,'2025-11-27 09:01:46','2025-11-27 09:01:46'),(48,'Moonika','Paju','moonika.paju@student.college.edu','555-1048','2002-09-21',2022,3,3.47,'2025-11-27 09:01:46','2025-11-27 09:01:46'),(49,'Indrek','Lepp','indrek.lepp@student.college.edu','555-1049','2003-03-07',2023,4,3.59,'2025-11-27 09:01:46','2025-11-27 09:01:46'),(50,'Getter','Aas','getter.aas@student.college.edu','555-1050','2004-11-25',2024,5,3.78,'2025-11-27 09:01:46','2025-11-27 09:01:46'),(51,'Noah','Carter','noah.carter@student.college.edu','555-1051','2002-12-14',2022,1,3.91,'2025-11-27 09:01:46','2025-11-27 09:01:46'),(52,'Emily','Mitchell','emily.mitchell@student.college.edu','555-1052','2003-06-02',2023,2,3.64,'2025-11-27 09:01:46','2025-11-27 09:01:46'),(53,'Liam','Perez','liam.perez@student.college.edu','555-1053','2004-09-19',2024,3,3.73,'2025-11-27 09:01:46','2025-11-27 09:01:46'),(54,'Sophie','Roberts','sophie.roberts@student.college.edu','555-1054','2002-04-25',2022,4,3.88,'2025-11-27 09:01:46','2025-11-27 09:01:46'),(55,'Jacob','Turner','jacob.turner@student.college.edu','555-1055','2003-10-31',2023,5,3.42,'2025-11-27 09:01:46','2025-11-27 09:01:46');
/*!40000 ALTER TABLE `Students` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`mysql`@`%`*/ /*!50003 TRIGGER `trg_student_history_update` BEFORE UPDATE ON `Students` FOR EACH ROW BEGIN
    INSERT INTO StudentHistory (
        student_id,
        first_name,
        last_name,
        email,
        phone,
        date_of_birth,
        enrollment_year,
        major_department_id,
        gpa,
        original_created_at,
        original_updated_at,
        change_type
    ) VALUES (
        OLD.student_id,
        OLD.first_name,
        OLD.last_name,
        OLD.email,
        OLD.phone,
        OLD.date_of_birth,
        OLD.enrollment_year,
        OLD.major_department_id,
        OLD.gpa,
        OLD.created_at,
        OLD.updated_at,
        'UPDATE'
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`mysql`@`%`*/ /*!50003 TRIGGER `trg_student_history_delete` BEFORE DELETE ON `Students` FOR EACH ROW BEGIN
    INSERT INTO StudentHistory (
        student_id,
        first_name,
        last_name,
        email,
        phone,
        date_of_birth,
        enrollment_year,
        major_department_id,
        gpa,
        original_created_at,
        original_updated_at,
        change_type
    ) VALUES (
        OLD.student_id,
        OLD.first_name,
        OLD.last_name,
        OLD.email,
        OLD.phone,
        OLD.date_of_birth,
        OLD.enrollment_year,
        OLD.major_department_id,
        OLD.gpa,
        OLD.created_at,
        OLD.updated_at,
        'DELETE'
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Dumping events for database 'college_database'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-11 10:32:16
