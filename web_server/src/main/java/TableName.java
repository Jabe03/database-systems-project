public enum TableName {
    STUDENTS("Students", "StudentID"),
    COURSES("Courses", "CourseID"),
    TUTORS("Tutors", "TutorID"),
    TUTOR_SESSION("TutorSession", "SessionID"),
    REVIEW("Review", "ReviewID"),
    ENROLLMENT("Enrollment", null),
    TEACHES("Teaches", null),
    SESSION_COURSE("SessionCourse", null),
    AVAILABILITY("Availability", null),
    QUALIFICATION("Qualification", null);

    private final String tableName;
    private final String primaryKey;

    TableName(String tableName, String primaryKey) {
        this.tableName = tableName;
        this.primaryKey = primaryKey;
    }

    public String primaryKey() {
        return primaryKey;
    }

    @Override
    public String toString() {
        return tableName;
    }

    public static TableName fromPath(String pathSegment) {
        for (TableName t : values()) {
            if (t.tableName.equalsIgnoreCase(pathSegment)) {
                return t;
            }
        }
        return null;
    }
}