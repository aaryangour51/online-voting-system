package com.voting.connection;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    // Replace with your Railway public host and port
    private static final String URL =
            "jdbc:mysql://YOUR_PUBLIC_HOST:YOUR_PUBLIC_PORT/railway?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";

    // Railway MySQL username
    private static final String USER = "root";

    // Railway MySQL password
    private static final String PASSWORD = "787977";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL Driver not found", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
