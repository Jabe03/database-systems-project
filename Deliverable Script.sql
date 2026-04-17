CREATE DATABASE TutorSystem;
USE TutorSystem;


/*Create Tables*/
CREATE TABLE Students (
StudentID VARCHAR(5) PRIMARY KEY,
FirstName VARCHAR(20),
LastName VARCHAR(20),
Email VARCHAR(30), 
AGE INTEGER,
Year VARCHAR(10) CHECK (Year IN ('freshman', 'sophomore', 'junior', 'senior'))
);

CREATE TABLE Courses ( 
CourseID VARCHAR(5) PRIMARY KEY,
CourseName VARCHAR(30),
CreditHours INTEGER CHECK (CreditHours >= 0 AND CreditHours <= 4)
);

CREATE TABLE Tutors (
TutorID VARCHAR(5) PRIMARY KEY,
FirstName VARCHAR(20),
LastName VARCHAR(20),
Email VARCHAR(20), 
HourlyRate INTEGER
);

CREATE TABLE TutorSession ( 
SessionID VARCHAR(5) PRIMARY KEY,
SessionDate DATE,
Length INTEGER CHECK (Length >=0 AND Length <= 600),
Location VARCHAR(20), /*Should this be constrained to certain locations? */
ScheduledStatues BOOLEAN,
TutorID VARCHAR(5) REFERENCES Tutors(TutorID),
StudentID VARCHAR(5) REFERENCES Students(StudentID)
);

CREATE TABLE Review (
ReviewID VARCHAR(5) PRIMARY KEY,
Rating INT CHECK (Rating >= 1 AND Rating <= 5),
COMMENT VARCHAR(1000),
TutorID VARCHAR(5) REFERENCES Tutors(TutorID),
StudentID VARCHAR(5) REFERENCES Students(StudentID)
);

CREATE TABLE Enrollment (
CourseID VARCHAR(5) REFERENCES Courses(CourseID),
StudentID VARCHAR(5) REFERENCES Students(StudentID),
GRADE VARCHAR(1),
EnrollmentStatus BOOLEAN,
PRIMARY KEY (CourseID, StudentID)
);

CREATE TABLE Teaches (
TutorID VARCHAR(5) REFERENCES Tutors(TutorID),
CourseID VARCHAR(5) REFERENCES Courses(CourseID),
PRIMARY KEY (CourseID, TutorID)
);

CREATE TABLE SessionCourse (
SessionID VARCHAR(5) REFERENCES TutorSession(SessionID),
CourseID VARCHAR(5) REFERENCES Courses(CourseID),
PRIMARY KEY (CourseID, SessionID)
);

CREATE TABLE Availability(
TutorID VARCHAR(5) REFERENCES Tutors(TutorID),
AvailableTime INTEGER, /* Need to clarify this */
PRIMARY KEY (TutorID)
);

CREATE TABLE Qualification (
TutorID VARCHAR(5) REFERENCES Tutors(TutorID),
CourseID VARCHAR(5) REFERENCES Courses(CourseID),
PRIMARY KEY (TutorID, CourseID)
);


/*ADD 5 rows of data into each table */ 
INSERT INTO Students VALUES 
('0001', 'Bob', 'Smith', 'bsmith@university.edu', 20, 'Sophomore'),
('0002', 'Jim', 'Brooks', 'jbrooks@university.edu', 19, 'Freshman'),
('0003', 'Alice', 'Collins', 'acollins@university.edu', 22, 'Senior'),
('0004', 'Ron', 'Garnet', 'rgarnet@university.edu', 22, 'Junior'),
('0005', 'Emily', 'Booker', 'ebooker@university.edu', 21, 'Junior');

INSERT INTO Courses VALUES 
('0001', 'Computer Science', '3'),
('0002', 'Probability and Statistics', '3'),
('0003', 'Physics', '4'),
('0004', 'Database Systems', '3'),
('0005', 'Algorithms', '2');

INSERT INTO Tutors VALUES 
('0001', 'Derek', 'Taylor', 'dtaylor@university.edu', 15),
('0002', 'Leo', 'Everett', 'leverett@university.edu', 17),
('0003', 'Joanne', 'Gilbert', 'jgilbert@university.edu', 20),
('0004', 'Sarah', 'Milton', 'smilton@university.edu', 22),
('0005', 'Cindy', 'Alison', 'calison@university.edu', 21);

INSERT INTO TutorSession VALUES
('0001', curdate(), '60', 'Zoom', '1', '0002', '0003'),
('0002', curdate(), '30', 'Math Building', '1', '0002', '0001'),
('0003', curdate(), '45', 'Chemistry Building', '0', '0003', '0002'),
('0004', curdate(), '50', 'IMU', '1', '0001', '0005'),
('0005', curdate(), '120', 'Zoom', '1', '0005', '0004');

INSERT INTO Review VALUES
('0001', '4', 'Good', '0005', '0002'),
('0002', '2', 'It was not very helpful.', '0002', '0001'),
('0003', '5', 'It was an excellent session.', '0001', '0002'),
('0004', '3', 'It was okay.', '0002', '0004'),
('0005', '4', 'Awesome', '0001', '0005');


INSERT INTO Enrollment VALUES
('0001', '0001', 'A', '1'),
('0001', '0002', 'B', '1'),
('0003', '0001', 'B', '1'),
('0004', '0003', 'D', '0'),
('0004', '0004', 'C', '1');


INSERT INTO Teaches VALUES 
('0001', '0001'),
('0001', '0002'),
('0002', '0003'),
('0002', '0001'),
('0003', '0002'),
('0003', '0004'),
('0004', '0005'),
('0005', '0003'),
('0005', '0001'),
('0005', '0002');

INSERT INTO SessionCourse VALUES 
('0001', '0005'),
('0002', '0004'),
('0003', '0003'),
('0004', '0002'),
('0005', '0001');

INSERT INTO Availability VALUES 
('0001', '1'),
('0002', '2'),
('0003', '3'),
('0004', '4'),
('0005', '5');

INSERT INTO Qualification VALUES
('0001', '0001'),
('0003', '0005'),
('0002', '0004'),
('0005', '0003'),
('0004', '0002');


/*Create Users*/ 
CREATE USER 'tutor_manager'@'localhost' IDENTIFIED BY 'tutor_manager123';
CREATE USER 'university_administrator'@'localhost' IDENTIFIED BY 'university_administrator123';
CREATE USER 'tutor'@'localhost' IDENTIFIED BY 'tutor123';
CREATE USER 'student'@'localhost' IDENTIFIED BY 'student123';

/* TODO - Add permissions */
