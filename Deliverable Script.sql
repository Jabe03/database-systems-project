CREATE DATABASE TutorSystem;
USE TutorSystem;


/*Create Tables*/
CREATE TABLE Students (
StudentID VARCHAR(5) PRIMARY KEY,
FirstName VARCHAR(20),
LastName VARCHAR(20),
Email VARCHAR(20) UNIQUE, 
AGE INTEGER,
Year VARCHAR(10) CHECK (Year IN ('freshman', 'sophomore', 'junior', 'senior')),
CHECK (Email LIKE '%@%.%')
);

CREATE TABLE Courses ( 
CourseID VARCHAR(5) PRIMARY KEY,
CourseName VARCHAR(20),
CreditHours INTEGER CHECK (CreditHours >= 0 AND CreditHours <= 4)
);

CREATE TABLE Tutors (
TutorID VARCHAR(5) PRIMARY KEY,
FirstName VARCHAR(20),
LastName VARCHAR(20),
Email VARCHAR(20) UNIQUE, 
HourlyRate INTEGER
CHECK (Email LIKE '%@%.%')
);

CREATE TABLE TutorSession ( 
SessionID VARCHAR(5) PRIMARY KEY,
SessionDate DATE,
Length INTEGER CHECK (Length >=0 AND Length <= 600),
Location VARCHAR(20), /*Should this be constrained to certain locations? */
ScheduledStatues BOOLEAN,
TutorID VARCHAR(5) REFERENCES Tutors(TutorID),
StudentID VARCHAR(5) REFERENCES Students(StudentID)
CHECK (Location IN ('library', 'online', 'study_room'))
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
AvailableTime DATETIME, 
PRIMARY KEY (TutorID)
);

CREATE TABLE Qualification (
TutorID VARCHAR(5) REFERENCES Tutors(TutorID),
CourseID VARCHAR(5) REFERENCES Courses(CourseID),
PRIMARY KEY (TutorID, CourseID)
);


/* TODO - ADD 5 rows of data into each table */ 
/* Students */
INSERT INTO Students VALUES
('S001','John','Doe','john@uiowa.edu',18,'freshman'),
('S002','Jane','Smith','jane@uiowa.edu',19,'sophomore'),
('S003','Mike','Brown','mike@uiowa.edu',20,'junior'),
('S004','Emily','Davis','emily@uiowa.edu',21,'senior'),
('S005','Chris','Wilson','chris@uiowa.edu',18,'freshman');

/* Courses */
INSERT INTO Courses VALUES
('C101','Math',3),
('C102','Physics',4),
('C103','Chemistry',3),
('C104','Biology',4),
('C105','English',3);

/* Tutors */
INSERT INTO Tutors VALUES
('T001','Alice','Johnson','alice@uiowa.edu',15),
('T002','Bob','Lee','bob@uiowa.edu',18),
('T003','Carol','King','carol@uiowa.edu',20),
('T004','David','Scott','david@uiowa.edu',17),
('T005','Eva','Green','eva@uiowa.edu',19);

/* TutorSession */
INSERT INTO TutorSession VALUES
('SS001','2026-04-10',60,'library',TRUE,'T001','S001'),
('SS002','2026-04-11',90,'online',TRUE,'T002','S002'),
('SS003','2026-04-12',120,'library',FALSE,'T003','S003'),
('SS004','2026-04-13',45,'study_room',TRUE,'T004','S004'),
('SS005','2026-04-14',30,'online',TRUE,'T005','S005');

/* Review */
INSERT INTO Review VALUES
('R001',5,'Great tutor','T001','S001'),
('R002',4,'Very helpful','T002','S002'),
('R003',3,'Okay session','T003','S003'),
('R004',5,'Excellent','T004','S004'),
('R005',4,'Good explanations','T005','S005');

/* Enrollment */
INSERT INTO Enrollment VALUES
('C101','S001','enrolled'),
('C102','S002','enrolled'),
('C103','S003','dropped'),
('C104','S004','enrolled'),
('C105','S005','completed');

/* Teaches */
INSERT INTO Teaches VALUES
('T001','C101'),
('T002','C102'),
('T003','C103'),
('T004','C104'),
('T005','C105');

/* SessionCourse */
INSERT INTO SessionCourse VALUES
('SS001','C101'),
('SS002','C102'),
('SS003','C103'),
('SS004','C104'),
('SS005','C105');

/* Availability */
INSERT INTO Availability VALUES
('T001','2026-04-10 10:00:00'),
('T002','2026-04-11 11:00:00'),
('T003','2026-04-12 12:00:00'),
('T004','2026-04-13 13:00:00'),
('T005','2026-04-14 14:00:00');

/* Qualification */
INSERT INTO Qualification VALUES
('T001','C101'),
('T002','C102'),
('T003','C103'),
('T004','C104'),
('T005','C105');

/*Create Users*/ 
CREATE USER 'tutor_manager'@'localhost' IDENTIFIED BY 'tutor_manager123';
CREATE USER 'university_administrator'@'localhost' IDENTIFIED BY 'university_administrator123';
CREATE USER 'tutor'@'localhost' IDENTIFIED BY 'tutor123';
CREATE USER 'student'@'localhost' IDENTIFIED BY 'student123';

/* TODO - Add permissions */
