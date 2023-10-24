DROP DATABASE IF EXISTS university;

CREATE DATABASE IF NOT EXISTS university;

USE university;

CREATE TABLE IF NOT EXISTS instructor (
    instructor_id INT AUTO_INCREMENT NOT NULL,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    tenured BOOL NULL DEFAULT 0,
    PRIMARY KEY (instructor_id)
);

CREATE TABLE IF NOT EXISTS student (
    student_id INT AUTO_INCREMENT NOT NULL,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    class_rank ENUM('freshman', 'sophomore', 'junior', 'senior'),
    year_admitted INT NOT NULL,
    advisor_id INT NULL,
    PRIMARY KEY (student_id),
    FOREIGN KEY (advisor_id) REFERENCES instructor(instructor_id) ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS course (
    course_id INT AUTO_INCREMENT NOT NULL,
    course_code VARCHAR(255) NOT NULL,
    course_name VARCHAR(255) NOT NULL,
    num_credits INT NOT NULL,
    instructor_id INT NOT NULL,
    PRIMARY KEY (course_id),
    FOREIGN KEY (instructor_id) REFERENCES instructor(instructor_id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS student_schedule (
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES student(student_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES course(course_id) ON UPDATE CASCADE ON DELETE CASCADE
);

INSERT INTO instructor (first_name, last_name, tenured)
VALUES
    ('Lauren', 'Garner', 1),
    ('Herman', 'Watts', 0),
    ('Carl', 'Mccarthy', 0),
    ('Sylvia', 'Sanchez', 1)
;

INSERT INTO student (first_name, last_name, class_rank, year_admitted, advisor_id)
VALUES
    ('Hugh', 'Nichols', 'freshman', 2021, 1),
    ('Carl', 'Mccarthy', 'freshman', 2021, NULL),
    ('Marvin ', 'Sharp', 'sophomore', 2022, 3),
    ('Joyce', 'Harmon', 'junior', 2019, 3),
    ('Doreen', 'Cruz', 'senior', 2018, 1)
;

INSERT INTO course (course_code, course_name, num_credits, instructor_id)
VALUES
    ('LBST 1102', 'Arts & Society: Film', 3, 2),
    ('ITSC 1213', 'Intro to Computer Science II', 4, 1),
    ('ITSC 1600', 'Computing Professionals', 2, 1),
    ('FILM 3220', 'Intro to Screenwriting', 3, 2),
    ('FILM 3120', 'Fund of Video/Film Prod', 3, 4),
    ('ITSC 3181', 'Intro to Comp Architecture', 4, 3),
    ('ITSC 4155', 'Software Development Projects', 4, 3)
;

INSERT INTO student_schedule (student_id, course_id)
VALUES
    (1, 1),
    (1, 2),
    (1, 3),
    (2, 2),
    (2, 3),
    (3, 3),
    (3, 4),
    (4, 3),
    (4, 4),
    (4, 5),
    (5, 6)
; 
-- Everything below is for the intro to SQL exercises for ITSC3155
-- Exercise scripts written by William Bermel III
-- Exercise 1 --
SELECT first_name, last_name FROM student;

-- Exercise 2 --
SELECT instructor_id FROM instructor
WHERE tenured=true;

-- Exercise 3 --
SELECT 
student.first_name AS student_first, 
student.last_name AS student_last, 
advisor.first_name AS advisor_first, 
advisor.last_name AS advisor_last 
FROM instructor advisor JOIN student ON student.advisor_id=advisor.instructor_id;

-- Exercise 4 --
SELECT 
advisor.first_name AS advisor_first, 
advisor.last_name AS advisor_last 
FROM instructor advisor LEFT JOIN student ON advisor.instructor_id = student.advisor_id
WHERE advisor_id IS NULL;

-- Exercise 5 -- 
SELECT first_name, last_name, SUM(num_credits) AS total_credit_hours
FROM instructor INNER JOIN course ON instructor.instructor_id=course.course_id
GROUP BY instructor.instructor_id, first_name, last_name;

-- Exercise 6 -- 
SELECT course_code, course_name
FROM course
WHERE course_code LIKE '%3___';

-- Exercise 7 --
SELECT course_code, first_name, last_name, SUM(num_credits) AS num_credit_hours
FROM course, student_schedule, instructor
WHERE course.course_id = student_schedule.course_id AND course.instructor_id = instructor.instructor_id AND student_id = 1
GROUP BY course_code, first_name, last_name;

