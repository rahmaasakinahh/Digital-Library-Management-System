package com.library.util;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * Database Utility class for managing database connections
 */
public class DBUtil {
    private static String URL;
    private static String USERNAME;
    private static String PASSWORD;
    private static String DRIVER;

    static {
        try {
            // Load database configuration from properties file
            Properties props = new Properties();
            InputStream input = DBUtil.class.getClassLoader().getResourceAsStream("config.properties");
            
            if (input != null) {
                props.load(input);
                URL = props.getProperty("db.url");
                USERNAME = props.getProperty("db.username");
                PASSWORD = props.getProperty("db.password");
                DRIVER = props.getProperty("db.driver");
            } else {
                // Fallback to default values
                URL = "jdbc:postgresql://localhost:5432/library_db";
                USERNAME = "postgres";
                PASSWORD = "postgres";
                DRIVER = "org.postgresql.Driver";
            }

            // Load the PostgreSQL driver
            Class.forName(DRIVER);
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("PostgreSQL JDBC Driver not found", e);
        } catch (IOException e) {
            System.err.println("Could not load config.properties, using default values");
            URL = "jdbc:postgresql://localhost:5432/library_db";
            USERNAME = "postgres";
            PASSWORD = "postgres";
            DRIVER = "org.postgresql.Driver";
        }
    }

    /**
     * Get a database connection
     * @return Connection object
     * @throws SQLException if connection fails
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }

    /**
     * Close database connection
     * @param conn Connection to close
     */
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                System.err.println("Error closing connection: " + e.getMessage());
            }
        }
    }

    /**
     * Close AutoCloseable resources (Connection, Statement, ResultSet)
     * @param resources AutoCloseable resources to close
     */
    public static void close(AutoCloseable... resources) {
        for (AutoCloseable resource : resources) {
            if (resource != null) {
                try {
                    resource.close();
                } catch (Exception e) {
                    System.err.println("Error closing resource: " + e.getMessage());
                }
            }
        }
    }

    /**
     * Test database connection
     * @return true if connection is successful
     */
    public static boolean testConnection() {
        try (Connection conn = getConnection()) {
            return conn != null && !conn.isClosed();
        } catch (SQLException e) {
            System.err.println("Database connection test failed: " + e.getMessage());
            return false;
        }
    }
}
