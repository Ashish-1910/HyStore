// ===============================================
// JAVA DATABASE CONNECTION UTILITY
// Save as: src/com/ecommerce/db/DatabaseConnection.java
// ===============================================

package com.ecommerce.db;

import java.sql.*;

public class DatabaseConnection {
    
    // Database Configuration
    private static final String JDBC_DRIVER = "com.mysql.cj.jdbc.Driver";
    private static final String DB_URL = "jdbc:mysql://localhost:3306/ecommerce_db";
    private static final String DB_USER = "root_user";
    private static final String DB_PASSWORD = "password";  // CHANGE THIS!
    
    // Get Database Connection
    public static Connection getConnection() throws SQLException, ClassNotFoundException {
        try {
            // Load MySQL JDBC Driver
            Class.forName(JDBC_DRIVER);
            
            // Get Connection
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            return conn;
        } catch (ClassNotFoundException e) {
            System.out.println("MySQL JDBC Driver not found!");
            throw e;
        } catch (SQLException e) {
            System.out.println("Database Connection Error: " + e.getMessage());
            throw e;
        }
    }
    
    // Close Connection (Helper Method)
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                System.out.println("Error closing connection: " + e.getMessage());
            }
        }
    }
    
    // Close Statement (Helper Method)
    public static void closeStatement(Statement stmt) {
        if (stmt != null) {
            try {
                stmt.close();
            } catch (SQLException e) {
                System.out.println("Error closing statement: " + e.getMessage());
            }
        }
    }
    
    // Close ResultSet (Helper Method)
    public static void closeResultSet(ResultSet rs) {
        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException e) {
                System.out.println("Error closing result set: " + e.getMessage());
            }
        }
    }
}

// ===============================================
// IMPORTANT: MySQL JDBC Driver Setup
// ===============================================
// 1. Download MySQL JDBC Driver from:
//    https://dev.mysql.com/downloads/connector/j/
// 2. Extract the jar file
// 3. Add to Tomcat libraries:
//    - Copy JAR to: TOMCAT_HOME/lib/
// 4. OR add to Eclipse project:
//    - Right-click project → Build Path → Add External Archives
//    - Select the JAR file

// ===============================================
// IMPORTANT: Change Database Password!
// ===============================================
// Replace "your_mysql_password" with the actual password
// you set when installing MySQL!
