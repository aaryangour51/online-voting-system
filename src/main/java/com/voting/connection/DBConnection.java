package com.voting.connection;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    // TiDB Cloud URL
    private static final String URL =
        "dhnCS0tDRUNftcD4@gateway01.ap-southeast-1.prod.aws.tidbcloud.com:4000/sys?sslMode=VERIFY_IDENTITY";

    // TiDB Username
    private static final String USER =
        "online-voting";

    // TiDB Password
    private static final String PASSWORD =
        "dhnCS0tDRUNftcD4";

    static {

        try {

            Class.forName("com.mysql.cj.jdbc.Driver");

        } catch (ClassNotFoundException e) {

            throw new RuntimeException(
                    "MySQL Driver not found", e);
        }
    }

    public static Connection getConnection()
            throws SQLException {

        return DriverManager.getConnection(
                URL, USER, PASSWORD);
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
