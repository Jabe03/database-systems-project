public enum TableName {
    STUDENTS("STUDENTS"),
    COURSES("COURSES"),
    TUTORS("TUTORS"),
    TUTOR_SESSION("TUTORSESSION"),
    REVIEW("REVIEW"),
    ENROLLMENT("ENROLLMENT"),
    TEACHES("TEACHES"),
    SESSION_COURSE("SESSIONCOURSE"),
    AVAILABILITY("AVAILABILITY"),
    QUALIFICATION("QUALIFICATION");

    private final String tableName;

    TableName(String tableName) {
        this.tableName = tableName;
    }

    @Override
    public String toString() {
        return tableName;
    }

    public static boolean isValid(String pathSegment) {
        for (TableName t : values()) {
            if (t.tableName.equalsIgnoreCase(pathSegment)) {
                return true;
            }
        }
        return false;
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