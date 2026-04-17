CREATE DATABASE TutorSystem;
USE TutorSystem;


/*Create Tables*/
CREATE TABLE Students (
StudentID VARCHAR(5) PRIMARY KEY,
FirstName VARCHAR(20),
LastName VARCHAR(20),
Email VARCHAR(20), /* need to restrict this to right form*/
AGE INTEGER,
Year VARCHAR(10) CHECK (Year IN ('freshman', 'sophomore', 'junior', 'senior'))
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
Email VARCHAR(20), /* need to restrict this to right form*/
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


/* TODO - ADD 5 rows of data into each table */ 



/*Create Users*/ 
CREATE USER 'tutor_manager'@'localhost' IDENTIFIED BY 'tutor_manager123';
CREATE USER 'university_administrator'@'localhost' IDENTIFIED BY 'university_administrator123';
CREATE USER 'tutor'@'localhost' IDENTIFIED BY 'tutor123';
CREATE USER 'student'@'localhost' IDENTIFIED BY 'student123';

/* TODO - Add permissions */