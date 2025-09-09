package com.hms.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {
    // Local development defaults
    private static final String DEFAULT_URL = "jdbc:mysql://localhost:3306/sanjeevani?useSSL=false&serverTimezone=UTC";
    private static final String DEFAULT_USER = "root";
    private static final String DEFAULT_PASSWORD = "nishigami";
    
    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL JDBC Driver not found", e);
        }
        
        // Check if we're running on Heroku with ClearDB
        String cleardbUrl = System.getenv("CLEARDB_DATABASE_URL");
        if (cleardbUrl != null) {
            // Parse the ClearDB connection string
            return parseClearDBUrl(cleardbUrl);
        }
        
        // Check for individual environment variables
        String dbUrl = System.getenv("JDBC_DATABASE_URL");
        String dbUser = System.getenv("JDBC_DATABASE_USERNAME");
        String dbPassword = System.getenv("JDBC_DATABASE_PASSWORD");
        
        // Use environment variables if available, otherwise use local defaults
        if (dbUrl != null && dbUser != null && dbPassword != null) {
            return DriverManager.getConnection(dbUrl, dbUser, dbPassword);
        } else {
            return DriverManager.getConnection(DEFAULT_URL, DEFAULT_USER, DEFAULT_PASSWORD);
        }
    }
    
    /**
     * Parses the ClearDB connection string format:
     * mysql://username:password@hostname:port/databaseName
     */
    private static Connection parseClearDBUrl(String cleardbUrl) throws SQLException {
        try {
            // Remove the "mysql://" prefix
            String dbUrl = cleardbUrl.substring(cleardbUrl.indexOf("://") + 3);
            
            // Extract username and password
            int atIndex = dbUrl.indexOf("@");
            String userInfo = dbUrl.substring(0, atIndex);
            int colonIndex = userInfo.indexOf(":");
            String username = userInfo.substring(0, colonIndex);
            String password = userInfo.substring(colonIndex + 1);
            
            // Extract host, port and database name
            String serverInfo = dbUrl.substring(atIndex + 1);
            String hostPortDb = serverInfo;
            String jdbcUrl = "jdbc:mysql://" + hostPortDb + "?useSSL=false&serverTimezone=UTC";
            
            return DriverManager.getConnection(jdbcUrl, username, password);
        } catch (Exception e) {
            throw new SQLException("Failed to parse ClearDB URL: " + cleardbUrl, e);
        }
    }

    public static void testConnection() {
        try (Connection conn = getConnection()) {
            System.out.println("✅ Database connection successful!");
            System.out.println("Database: " + conn.getMetaData().getDatabaseProductName());
            System.out.println("Version: " + conn.getMetaData().getDatabaseProductVersion());
            
            // Show which database we're connected to
            String url = conn.getMetaData().getURL();
            if (url.contains("cleardb")) {
                System.out.println("Environment: Production (Heroku ClearDB)");
            } else {
                System.out.println("Environment: Local Development");
            }
        } catch (SQLException e) {
            System.err.println("❌ Connection failed:");
            e.printStackTrace();
        }
    }
    
    // Main method for testing the connection
    public static void main(String[] args) {
        System.out.println("Testing database connection...");
        testConnection();
    }
}