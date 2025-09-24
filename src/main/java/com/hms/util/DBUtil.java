package com.hms.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {

    // Local MySQL defaults (for development)
    private static final String LOCAL_URL = "jdbc:mysql://localhost:3306/sanjeevani?useSSL=false&serverTimezone=UTC";
    private static final String LOCAL_USER = "root";
    private static final String LOCAL_PASSWORD = "nishigami";

    public static Connection getConnection() throws SQLException {
        try {
            // Load both drivers
            Class.forName("org.postgresql.Driver"); // Render Postgres
            Class.forName("com.mysql.cj.jdbc.Driver"); // Local MySQL
        } catch (ClassNotFoundException e) {
            throw new SQLException("JDBC Driver not found", e);
        }

        // Use Postgres environment variables first
        String url = System.getenv("JDBC_DATABASE_URL");
        String user = System.getenv("JDBC_DATABASE_USERNAME");
        String password = System.getenv("JDBC_DATABASE_PASSWORD");

        if (url != null && user != null && password != null) {
            return DriverManager.getConnection(url, user, password);
        }

        // Fallback to local MySQL
        return DriverManager.getConnection(LOCAL_URL, LOCAL_USER, LOCAL_PASSWORD);
    }

    public static void testConnection() {
        try (Connection conn = getConnection()) {
            System.out.println("✅ Database connection successful!");
            System.out.println("Database: " + conn.getMetaData().getDatabaseProductName());
            System.out.println("Version: " + conn.getMetaData().getDatabaseProductVersion());
            System.out.println("URL: " + conn.getMetaData().getURL());
        } catch (SQLException e) {
            System.err.println("❌ Connection failed:");
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        testConnection();
    }
}
