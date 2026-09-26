CREATE DATABASE university_academic_dw;
USE university_academic_dw;

CREATE TABLE dim_college (
    college_key INT PRIMARY KEY,
    college_name VARCHAR(100),
    location VARCHAR(100));
    
INSERT INTO dim_college VALUES
(1, 'Engineering College', 'Chennai'),
(2, 'Arts College', 'Coimbatore'),
(3, 'Science College', 'Madurai'),
(4, 'Commerce College', 'Salem'),
(5, 'Management College', 'Trichy'),
(6, 'Medical College', 'Chennai'),
(7, 'Law College', 'Madurai'),
(8, 'Education College', 'Coimbatore'),
(9, 'Computer College', 'Salem'),
(10, 'Design College', 'Chennai');

CREATE TABLE dim_department (
    department_key INT PRIMARY KEY,
    department_name VARCHAR(100),
    college_key INT,
    FOREIGN KEY (college_key)REFERENCES dim_college(college_key));
    
INSERT INTO dim_department VALUES
(1, 'Computer Science', 1),
(2, 'Information Technology', 1),
(3, 'Mechanical Engineering', 1),
(4, 'English', 2),
(5, 'Physics', 3),
(6, 'Commerce', 4),
(7, 'Management', 5),
(8, 'Medicine', 6),
(9, 'Law', 7),
(10, 'Education', 8);

CREATE TABLE dim_student (
    student_key INT PRIMARY KEY,
    student_id VARCHAR(20),
    student_name VARCHAR(100),
    gender VARCHAR(10),
    department_key INT,
    FOREIGN KEY (department_key)REFERENCES dim_department(department_key));
    
INSERT INTO dim_student VALUES
(1, 'STU001', 'Arun Kumar', 'Male', 1),
(2, 'STU002', 'Priya Sharma', 'Female', 1),
(3, 'STU003', 'Rahul Raj', 'Male', 2),
(4, 'STU004', 'Anitha Devi', 'Female', 2),
(5, 'STU005', 'Karthik M', 'Male', 3),
(6, 'STU006', 'Divya S', 'Female', 4),
(7, 'STU007', 'Vijay Kumar', 'Male', 5),
(8, 'STU008', 'Sneha R', 'Female', 6),
(9, 'STU009', 'Ramesh P', 'Male', 9),
(10, 'STU010', 'Meena K', 'Female', 10);

CREATE TABLE dim_subject (
    subject_key INT PRIMARY KEY,
    subject_code VARCHAR(20),
    subject_name VARCHAR(100),
    department_key INT,
    FOREIGN KEY (department_key) REFERENCES dim_department(department_key));
    
INSERT INTO dim_subject VALUES
(1, 'CS101', 'Database Management', 1),
(2, 'CS102', 'Data Structures', 1),
(3, 'IT101', 'Cloud Computing', 2),
(4, 'IT102', 'Software Engineering', 2),
(5, 'ME101', 'Thermodynamics', 3),
(6, 'ENG101', 'English Literature', 4),
(7, 'PHY101', 'Quantum Physics', 5),
(8, 'COM101', 'Financial Accounting', 6),
(9, 'LAW101', 'Constitutional Law', 9),
(10, 'EDU101', 'Teaching Methods', 10);

CREATE TABLE dim_course (
    course_key INT PRIMARY KEY,
    course_code VARCHAR(20),
    course_name VARCHAR(100),
    subject_key INT,
    FOREIGN KEY (subject_key) REFERENCES dim_subject(subject_key));
    
INSERT INTO dim_course VALUES
(1, 'C001', 'B.Tech Computer Science', 1),
(2, 'C002', 'B.Tech Data Science', 2),
(3, 'C003', 'B.Tech Information Technology', 3),
(4, 'C004', 'B.Tech Software Engineering', 4),
(5, 'C005', 'B.Tech Mechanical', 5),
(6, 'C006', 'BA English', 6),
(7, 'C007', 'B.Sc Physics', 7),
(8, 'C008', 'B.Com Finance', 8),
(9, 'C009', 'LLB Law', 9),
(10, 'C010', 'B.Ed Education', 10);

CREATE TABLE dim_semester (
    semester_key INT PRIMARY KEY,
    semester_number INT,
    academic_year VARCHAR(20));
    
INSERT INTO dim_semester VALUES
(1, 1, '2022-23'),
(2, 2, '2022-23'),
(3, 3, '2023-24'),
(4, 4, '2023-24'),
(5, 5, '2024-25'),
(6, 6, '2024-25'),
(7, 1, '2025-26'),
(8, 2, '2025-26'),
(9, 3, '2025-26'),
(10, 4, '2025-26');

CREATE TABLE fact_academic (
    academic_key INT PRIMARY KEY,
    student_key INT,
    course_key INT,
    semester_key INT,
    marks INT,
    max_marks INT,
    grade VARCHAR(5),
    result VARCHAR(10),
    FOREIGN KEY (student_key)REFERENCES dim_student(student_key),
	FOREIGN KEY (course_key)REFERENCES dim_course(course_key),
	FOREIGN KEY (semester_key)REFERENCES dim_semester(semester_key));
    
INSERT INTO fact_academic VALUES
(1, 1, 1, 1, 85, 100, 'A', 'PASS'),
(2, 2, 1, 1, 78, 100, 'B', 'PASS'),
(3, 3, 3, 2, 88, 100, 'A', 'PASS'),
(4, 4, 4, 2, 72, 100, 'B', 'PASS'),
(5, 5, 5, 3, 65, 100, 'C', 'PASS'),
(6, 6, 6, 4, 91, 100, 'A', 'PASS'),
(7, 7, 8, 5, 76, 100, 'B', 'PASS'),
(8, 8, 8, 6, 68, 100, 'C', 'PASS'),
(9, 9, 9, 7, 82, 100, 'A', 'PASS'),
(10, 10, 10, 8, 55, 100, 'C', 'PASS');

###marks obtained by students
SELECT
    s.student_id,
    s.student_name,
    c.course_name,
    sem.semester_number,
    sem.academic_year,
    f.marks,
    f.grade,
    f.result
FROM fact_academic f
JOIN dim_student s
    ON f.student_key = s.student_key
JOIN dim_course c
    ON f.course_key = c.course_key
JOIN dim_semester sem
    ON f.semester_key = sem.semester_key;
    
###average mark by each dept
SELECT
    d.department_name,
    AVG(f.marks) AS average_marks
FROM fact_academic f
JOIN dim_student s
    ON f.student_key = s.student_key
JOIN dim_department d
    ON s.department_key = d.department_key
GROUP BY d.department_name;

### students marks and grade based on academic year
SELECT
    s.student_name,
    c.course_name,
    sem.semester_number,
    sem.academic_year,
    f.marks,
    f.grade
FROM fact_academic f
JOIN dim_student s
    ON f.student_key = s.student_key
JOIN dim_course c
    ON f.course_key = c.course_key
JOIN dim_semester sem
    ON f.semester_key = sem.semester_key
WHERE sem.academic_year = '2022-23';
