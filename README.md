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


## TODO
- ~~Set up connection between Java API and typescript requests~~
- Make HTML for website
- Design request-response protocol for website
  - Enumerate all database commands we want to implement
  - Provide explicit support for these commands
