## Running the Project Locally

### 1. Start MySQL

Make sure your MySQL server is running.

In MySQL Workbench or another MySQL client, run the project SQL script to create and populate the `TutorSystem` database.

### 2. Set the database password environment variable

The Java API reads the database password from the `DB_PASSWORD` environment variable.

In IntelliJ:

1. Open the Java API run configuration.
2. Find `Environment variables`.
3. Add:

`DB_PASSWORD=your_mysql_password`

### 3. Start the Java API server

Run the Java API server from IntelliJ.

The API server should start on:

`http://localhost:8080`

### 4. Start the website server

Open a terminal and go to the `site` directory:

`cd database-systems-project/site`

Then run:

`npx http-server web`

Open one of the URLs printed by `http-server`.

For example:

`http://localhost:8081`

### 5. Use the website

From the homepage, use the links to access the database table pages.

The website supports:

- Viewing table rows
- Creating new rows
- Editing existing rows
- Deleting rows
- Running the required SQL query demonstrations