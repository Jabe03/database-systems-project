CREATE DATABASE IF NOT EXISTS TutorSystem;
USE TutorSystem;

/*Create Tables*/
CREATE TABLE IF NOT EXISTS Students (
StudentID VARCHAR(5) PRIMARY KEY,
FirstName VARCHAR(20) NOT NULL,
LastName VARCHAR(20) NOT NULL,
Email VARCHAR(60) UNIQUE NOT NULL,
AGE INTEGER,
Year VARCHAR(10) CHECK (Year IN ('freshman', 'sophomore', 'junior', 'senior')),
CHECK (Email LIKE '%@uiowa.edu')
);

CREATE TABLE IF NOT EXISTS Courses ( 
CourseID VARCHAR(5) PRIMARY KEY,
CourseName VARCHAR(50),
CreditHours INTEGER CHECK (CreditHours >= 0 AND CreditHours <= 4)
);

CREATE TABLE IF NOT EXISTS Tutors (
TutorID VARCHAR(5) PRIMARY KEY,
FirstName VARCHAR(20) NOT NULL,
LastName VARCHAR(20) NOT NULL,
Email VARCHAR(60) UNIQUE NOT NULL,
HourlyRate INTEGER,
CHECK (Email LIKE '%@%.%')
);

CREATE TABLE IF NOT EXISTS TutorSession ( 
SessionID VARCHAR(5) PRIMARY KEY,
SessionDate DATE,
Length INTEGER CHECK (Length >=15 AND Length <= 600),
Location VARCHAR(20), 
ScheduledStatus BOOLEAN DEFAULT TRUE,
TutorID VARCHAR(5),
StudentID VARCHAR(5),
FOREIGN KEY (TutorID) REFERENCES Tutors(TutorID) ON DELETE CASCADE,
FOREIGN KEY (StudentID) REFERENCES Students(StudentID) ON DELETE CASCADE,
CHECK (Location IN ('library', 'online', 'study_room'))
);

CREATE TABLE IF NOT EXISTS Review (
ReviewID VARCHAR(5) PRIMARY KEY,
Rating INT CHECK (Rating >= 1 AND Rating <= 5),
COMMENT VARCHAR(1000),
TutorID VARCHAR(5),
StudentID VARCHAR(5),
FOREIGN KEY (TutorID) REFERENCES Tutors(TutorID) ON DELETE CASCADE,
FOREIGN KEY (StudentID) REFERENCES Students(StudentID) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Enrollment (
CourseID VARCHAR(5),
StudentID VARCHAR(5),
EnrollmentStatus VARCHAR(15) CHECK (EnrollmentStatus IN ('enrolled', 'completed', 'dropped')),
Grade VARCHAR(2),
PRIMARY KEY (CourseID, StudentID),
FOREIGN KEY (CourseID) REFERENCES Courses(CourseID) ON DELETE CASCADE,
FOREIGN KEY (StudentID) REFERENCES Students(StudentID) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Teaches (
TutorID VARCHAR(5),
CourseID VARCHAR(5),
FOREIGN KEY (TutorID) REFERENCES Tutors(TutorID) ON DELETE CASCADE,
FOREIGN KEY (CourseID) REFERENCES Courses(CourseID) ON DELETE CASCADE,
PRIMARY KEY (CourseID, TutorID)
);

CREATE TABLE IF NOT EXISTS SessionCourse (
SessionID VARCHAR(5),
CourseID VARCHAR(5),
FOREIGN KEY (SessionID) REFERENCES TutorSession(SessionID) ON DELETE CASCADE,
FOREIGN KEY (CourseID) REFERENCES Courses(CourseID) ON DELETE CASCADE,
PRIMARY KEY (CourseID, SessionID)
);

CREATE TABLE IF NOT EXISTS Availability(
TutorID VARCHAR(5),
AvailableTime DATETIME,
PRIMARY KEY (TutorID, AvailableTime),
FOREIGN KEY (TutorID) REFERENCES Tutors(TutorID) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Qualification (
TutorID VARCHAR(5),
CourseID VARCHAR(5),
FOREIGN KEY (TutorID) REFERENCES Tutors(TutorID) ON DELETE CASCADE,
FOREIGN KEY (CourseID) REFERENCES Courses(CourseID) ON DELETE CASCADE,
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
('C101','S001','enrolled',NULL),
('C101','S002','completed','A'),
('C102','S002','enrolled',NULL),
('C102','S001','completed','B'),
('C103','S003','dropped',NULL);

/* Teaches */
INSERT INTO Teaches VALUES
('T001','C101'),
('T001','C102'),
('T001','C103'),
('T002','C102'),
('T003','C103');

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
('T001','2026-04-10 14:00:00'),
('T002','2026-04-11 11:00:00'),
('T003','2026-04-12 12:00:00'),
('T004','2026-04-13 13:00:00');

/* Qualification */
INSERT INTO Qualification VALUES
('T001','C101'),
('T002','C102'),
('T003','C103'),
('T004','C104'),
('T005','C105');

/* Create Roles for users (Role Based Access Control from slides)*/
DROP ROLE IF EXISTS student;
DROP ROLE IF EXISTS tutor;
DROP ROLE IF EXISTS university_admin;
DROP ROLE IF EXISTS tutor_manager;

CREATE ROLE student;
CREATE ROLE tutor;
CREATE ROLE university_admin;
CREATE ROLE tutor_manager;

/* Add permissions to roles */

GRANT SELECT ON Enrollment TO student;
GRANT SELECT ON Availability TO student;
GRANT INSERT ON Review TO student;
GRANT INSERT ON TutorSession TO student;
GRANT INSERT ON SessionCourse TO student;

GRANT SELECT ON Review TO tutor;
GRANT SELECT, INSERT, UPDATE ON Availability TO tutor;
GRANT SELECT ON TutorSession TO tutor;
GRANT SELECT ON Teaches TO tutor;

GRANT SELECT, INSERT, UPDATE ON Students TO university_admin;
GRANT SELECT, INSERT, UPDATE ON Courses TO university_admin;
GRANT SELECT ON Enrollment TO university_admin;
GRANT SELECT ON Teaches TO university_admin;

GRANT SELECT, INSERT, UPDATE ON Tutors TO tutor_manager;
GRANT SELECT ON Review TO tutor_manager;
GRANT SELECT, INSERT, UPDATE ON Qualification TO tutor_manager;
GRANT SELECT ON Availability TO tutor_manager;
GRANT SELECT, INSERT, UPDATE ON Teaches TO tutor_manager;

/*Create Dummy Users*/ 
CREATE USER IF NOT EXISTS 'tutor_manager1'@'localhost' IDENTIFIED BY 'tutor_manager123';
CREATE USER IF NOT EXISTS 'university_administrator1'@'localhost' IDENTIFIED BY 'university_administrator123';
CREATE USER IF NOT EXISTS 'tutor1'@'localhost' IDENTIFIED BY 'tutor123';
CREATE USER IF NOT EXISTS 'student1'@'localhost' IDENTIFIED BY 'student123';

/* Grant them designated roles */
GRANT tutor_manager TO 'tutor_manager1'@'localhost';
GRANT university_admin TO 'university_administrator1'@'localhost';
GRANT tutor TO 'tutor1'@'localhost';
GRANT student TO 'student1'@'localhost';

/* Views */
CREATE VIEW tutorPerformance AS
SELECT T.TutorID, T.FirstName, T.LastName, T.HourlyRate, ROUND(AVG(R.Rating), 2) AS AverageRating, COUNT(R.ReviewID) AS TotalReviews
FROM Tutors T LEFT JOIN Review R ON T.TutorID = R.TutorID
GROUP BY 
    T.TutorID, 
    T.FirstName, 
    T.LastName, 
    T.HourlyRate;

CREATE VIEW sessionDetails AS
SELECT ts.SessionID, ts.SessionDate, ts.Location, ts.Length AS length, c.CourseName,
s.FirstName AS studentFName, s.LastName AS studentLName, t.FirstName AS tutorFName, t.LastName AS tutorLName,
ts.ScheduledStatus
FROM TutorSession ts
JOIN Students s ON ts.StudentID = s.StudentID
JOIN Tutors t ON ts.TutorID = t.TutorID
JOIN SessionCourse sc ON ts.SessionID = sc.SessionID
JOIN Courses c ON sc.CourseID = c.CourseID;

/* Triggers */

DELIMITER //
CREATE TRIGGER ensureSessionIsAValidDate
BEFORE INSERT ON TutorSession
FOR EACH ROW
BEGIN
    IF NEW.SessionDate < current_date() THEN
        SIGNAL SQLSTATE '45000';
    END IF;
END; //
DELIMITER ;

DELIMITER //
CREATE TRIGGER formatStudentNames
BEFORE INSERT ON Students
FOR EACH ROW
BEGIN
    SET NEW.FirstName = CONCAT(UPPER(SUBSTRING(NEW.FirstName, 1, 1)), LOWER(SUBSTRING(NEW.FirstName, 2)));
    SET NEW.LastName = CONCAT(UPPER(SUBSTRING(NEW.LastName, 1, 1)), LOWER(SUBSTRING(NEW.LastName, 2)));
END; //
DELIMITER ;

DELIMITER //
CREATE TRIGGER enforceValidReviews
BEFORE INSERT ON Review
FOR EACH ROW
BEGIN
    DECLARE session_num INT;
    SELECT COUNT(*) INTO session_num
    FROM TutorSession
    WHERE StudentID = NEW.StudentID 
    AND TutorID = NEW.TutorID;

    IF session_num = 0 THEN
        SIGNAL SQLSTATE '45000';
    END IF;
END; //
DELIMITER ;

/* Testing Trigger --> enforceValidReviews */
/* This should fail since S003 never had a session with T001. */
INSERT INTO Review VALUES
('R999', 5, 'Great tutor!', 'T001', 'S003');

/* Queries */
/* Join */
/* Getting all tutoring sessions with student + tutor names */
SELECT ts.SessionID, ts.SessionDate, 
       s.FirstName AS StudentFirstName, s.LastName AS StudentLastName,
       t.FirstName AS TutorFirstName, t.LastName AS TutorLastName
FROM TutorSession ts
JOIN Students s ON ts.StudentID = s.StudentID
JOIN Tutors t ON ts.TutorID = t.TutorID;

/* join + aggregation */
/* Average rating per tutor */
SELECT T.TutorID, T.FirstName, T.LastName,
       AVG(R.Rating) AS AvgRating
FROM Tutors T
JOIN Review R ON T.TutorID = R.TutorID
GROUP BY T.TutorID, T.FirstName, T.LastName;

/* Join */
/* The courses each tutor teaches */
SELECT T.FirstName, T.LastName, C.CourseName
FROM Tutors T
JOIN Teaches Te ON T.TutorID = Te.TutorID
JOIN Courses C ON Te.CourseID = C.CourseID;

/* Subquery */
/* The students who are enrolled in at least one course */
SELECT FirstName, LastName
FROM Students
WHERE StudentID IN (
    SELECT StudentID FROM Enrollment
);

/* Uses a view + aggregation */
SELECT * 
FROM tutorPerformance
WHERE AverageRating >= 4;

/* Stored Procedure */
DELIMITER //

/*Schedules a tutoring session by updating multiple tables*/
CREATE PROCEDURE ScheduleTutoringSession(
    IN p_SessionID VARCHAR(5),
    IN p_SessionDate DATE,
    IN p_Length INTEGER,
    IN p_Location VARCHAR(20),
    IN p_TutorID VARCHAR(5),
    IN p_StudentID VARCHAR(5),
    IN p_CourseID VARCHAR(5)
)
BEGIN
    INSERT INTO TutorSession (SessionID, SessionDate, Length, Location, ScheduledStatus, TutorID, StudentID)
    VALUES (p_SessionID, p_SessionDate, p_Length, p_Location, TRUE, p_TutorID, p_StudentID);
    
    INSERT INTO SessionCourse (SessionID, CourseID)
    VALUES (p_SessionID, p_CourseID);
END //

DELIMITER ;

/* Sample call*/
CALL ScheduleTutoringSession('SS006', '2026-05-01', 60, 'online', 'T001', 'S002', 'C101');
SELECT * FROM tutorsession;
SELECT * FROM sessioncourse

/* Finds how many tutors are qualified for a certain course */
DELIMITER //

CREATE FUNCTION CountQualifiedTutors(
    p_CourseID VARCHAR(5)
) 
RETURNS INTEGER
DETERMINISTIC
BEGIN
    DECLARE tutor_count INTEGER DEFAULT 0;
    SELECT COUNT(*) INTO tutor_count
    FROM Qualification
    WHERE CourseID = p_CourseID;
    RETURN tutor_count;
END //

DELIMITER ;

/* sample call*/
SELECT CourseName, CountQualifiedTutors('C101') AS AvailableTutors 
FROM Courses 
WHERE CourseID = 'C101';
