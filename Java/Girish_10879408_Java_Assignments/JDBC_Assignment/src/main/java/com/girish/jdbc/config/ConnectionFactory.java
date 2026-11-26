package com.girish.jdbc.config;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public final class ConnectionFactory {
    private static final Properties PROPERTIES = new Properties();
    static {
        try (InputStream input = ConnectionFactory.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (input == null) throw new IllegalStateException("db.properties not found");
            PROPERTIES.load(input);
        } catch (IOException e) { throw new ExceptionInInitializerError(e); }
    }
    private ConnectionFactory() {}
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(PROPERTIES.getProperty("db.url"), PROPERTIES.getProperty("db.user"), PROPERTIES.getProperty("db.password"));
    }
}
