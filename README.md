# CS:4400 Database Systems Final Project
This project is a database representing a university tutoring service. We plan to implement a simple web interface to the database by the time the project is complete.
## Group members
Joshua Bergthold  
Bradley Alldredge  
Needal Arbid  

# Website
## Running the website

In order to run the website, you need (in order)
1) SQL instance running
2) Java API server running
   - The README in the api_server directory tells you how to sign into your database instance
   - TLDR: set DB_PASSWORD env variable to your password to your instance
4) Website active
   - With typescript code making requests to the java API for SQL commands

## Hardcoded example
Currently, there is a hardcoded example of a handling of a request and call to a handler for that request
Call chain: 
1) typescript `client.ts` sends http message to `localhost:8080` with a string identifying the "end point" (the web page/data we actually want)
2) The Java `ApiServer.java` recieves the http message and, if the route is registered (eg `localhost:8080/tutorCount`), it calls the `handle()` method that was given by `server.createContext()` when creating the server.
3) The handle method must make a connection to the database, build a quesry, then execute that query. Then, it writes an http message back (via `sendJson()`) containing whatever it wants (currently it just sends a JSON like `{"qualified_tutor_count" : "1"}`)

## TODO
- ~~Set up connection between Java API and typescript requests~~
- Make HTML for website
   - Index page that shows all of the tables
   - Want a page that shows each table 
      - Want to be able to edit, delete, add rows to table
   - Want to show off our functions/procedures
- Design request-response protocol for website
  - Enumerate all database commands we want to implement
  - Provide explicit support for these commands

## How to run Java API
To run the java database API server, you must provide the password to the database server.  
In this project you must set the environment variable DB_PASSWORD to your database password.  
In intellij, you can go to configure your run configuration and set the environment varaible by typing 
`DB_PASSWORD={password}` in the `Environment varaibles` section.

## How to run website server
To launch the website, you must go to the `\database-systems-project\site` directory and run `npx http-server web`, then click on one of the links that it gives for your web server to access the pages

## How to use API/REPL
The REPL accepts the following formats:
### CRUD

`GET table_name` - Gets all the columns of the table  

`GET table_name?columns=table_col_name1,table_col_name2,...` - Gets only the specified columns of the table  

`POST table_name {"table_col_name": "table_col_value", ...}` - Creates a new row in the table with the given attributes  

`POST table_name/PK_value {"table_col_name": "table_col_value", ...}` - Updates the row in the given table with primary key `PK_value` by replacing the given `table_col_name` columns with `tale_col_value` values.  

`DELETE table_name/PK_value` - Deletes the row that has primary key `PK_value`  

### Views

`GET view/tutorPerformance` - Returns tutor performance (average rating and total reviews)  

`GET view/sessionDetails` - Returns detailed session info including student, tutor, and course data  

### Custom Queries

`GET query/tutoringSessionsWithNames` - Returns tutoring sessions with student and tutor names  

`GET query/tutorCourses` - Returns the courses each tutor teaches  

`GET query/enrolledStudents` - Returns students enrolled in at least one course  

`GET query/highlyRatedTutors` - Returns tutors with average rating ≥ 4  

### Functions

`GET function/qualifiedTutorCount/C101` - Returns number of tutors qualified for course `C101`  

### Stored Procedures

`POST procedure/scheduleSession {"SessionID":"SS006","SessionDate":"2026-05-01","Length":60,"Location":"online","TutorID":"T001","StudentID":"S002","CourseID":"C101"}`  - Schedules a tutoring session (inserts into multiple tables)  

