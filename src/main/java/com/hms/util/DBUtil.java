package com.hms.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {

    // Local defaults (for development)
    private static final String LOCAL_URL = "jdbc:mysql://localhost:3306/sanjeevani?useSSL=false&serverTimezone=UTC";
    private static final String LOCAL_USER = "root";
    private static final String LOCAL_PASSWORD = "nishigami";

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // Load MySQL driver
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL JDBC Driver not found", e);
        }

        // Step 1: Try standard environment variables first
        String url = System.getenv("JDBC_DATABASE_URL");
        String user = System.getenv("JDBC_DATABASE_USERNAME");
        String password = System.getenv("JDBC_DATABASE_PASSWORD");

        if (url != null && user != null && password != null) {
            return DriverManager.getConnection(url, user, password);
        }

        // Step 2: Optional - support Heroku ClearDB style URL
        String cleardbUrl = System.getenv("CLEARDB_DATABASE_URL");
        if (cleardbUrl != null) {
            return parseClearDBUrl(cleardbUrl);
        }

        // Step 3: Fallback to local defaults
        return DriverManager.getConnection(LOCAL_URL, LOCAL_USER, LOCAL_PASSWORD);
    }

    // Parses ClearDB URL format: mysql://username:password@hostname:port/database
    private static Connection parseClearDBUrl(String cleardbUrl) throws SQLException {
        try {
            String dbUrl = cleardbUrl.substring(cleardbUrl.indexOf("://") + 3);

            int atIndex = dbUrl.indexOf("@");
            String userInfo = dbUrl.substring(0, atIndex);
            String username = userInfo.split(":")[0];
            String password = userInfo.split(":")[1];

            String hostDb = dbUrl.substring(atIndex + 1);
            String jdbcUrl = "jdbc:mysql://" + hostDb + "?useSSL=false&serverTimezone=UTC";

            return DriverManager.getConnection(jdbcUrl, username, password);
        } catch (Exception e) {
            throw new SQLException("Failed to parse ClearDB URL", e);
        }
    }

    // Test method
    public static void testConnection() {
        try (Connection conn = getConnection()) {
            System.out.println("✅ Database connection successful!");
            System.out.println("Database: " + conn.getMetaData().getDatabaseProductName());
            System.out.println("Version: " + conn.getMetaData().getDatabaseProductVersion());
            System.out.println("Connected URL: " + conn.getMetaData().getURL());
        } catch (SQLException e) {
            System.err.println("❌ Connection failed:");
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        testConnection();
    }
}
