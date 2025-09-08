package com.hms.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {
	private static final String URL = "jdbc:mysql://localhost:3306/sanjeevani";
    private static final String USER = "root";
    private static final String PASSWORD = "nishigami";
    
    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL JDBC Driver not found", e);
        }
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

public static void testConnection() {
    try (Connection conn = getConnection()) {
        System.out.println("✅ Database connection successful!");
        System.out.println("Database: " + conn.getMetaData().getDatabaseProductName());
        System.out.println("Version: " + conn.getMetaData().getDatabaseProductVersion());
    } catch (SQLException e) {
        System.err.println("❌ Connection failed:");
        e.printStackTrace();
    }
}
}

