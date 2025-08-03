package com.parcel.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

public class DatabaseConnection {

	private static final String MY_SQL_URL = "jdbc:mysql://localhost:32769/parcelDb";
	private static final String MY_SQL_PASSWORD = "admin";
	private static final String MY_SQL_USER = "root";

//	private static final String URL =  "jdbc:derby:" + dbPath + ";create=true";
	private static Connection connection;

	public static Connection getConnection() throws SQLException {
		if (connection == null || connection.isClosed()) {
			try {
//                Class.forName("org.apache.derby.jdbc.EmbeddedDriver");
				Class.forName("com.mysql.cj.jdbc.Driver");
				connection = DriverManager.getConnection(MY_SQL_URL, MY_SQL_USER, MY_SQL_PASSWORD);
				createTables();
			} catch (ClassNotFoundException e) {
				throw new SQLException("Derby driver not found", e);
			}
		}
		return connection;
	}

	private static void createTables() {
		try (Statement stmt = connection.createStatement()) {
			// Create Users table
			String createUsersTable = """
	              CREATE TABLE users (
					    user_id INT AUTO_INCREMENT PRIMARY KEY,
					    customer_name VARCHAR(50) NOT NULL,
					    email VARCHAR(100) UNIQUE NOT NULL,
					    country_code VARCHAR(5) NOT NULL,
					    mobile_number VARCHAR(10) NOT NULL,
					    address VARCHAR(500) NOT NULL,
					    user_id_string VARCHAR(20) UNIQUE NOT NULL,
					    password VARCHAR(30) NOT NULL,
					    role VARCHAR(20) DEFAULT 'CUSTOMER',
					    preferences VARCHAR(500)
					)
	                """;

			// Create Bookings table
			String createBookingsTable = """
					CREATE TABLE bookings (
					    booking_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
					    customer_id INTEGER NOT NULL,
					    customer_name VARCHAR(50) NOT NULL,
					    customer_address VARCHAR(500) NOT NULL,
					    customer_contact VARCHAR(20) NOT NULL,
					    rec_name VARCHAR(50) NOT NULL,
					    rec_address VARCHAR(500) NOT NULL,
					    rec_pin VARCHAR(10) NOT NULL,
					    rec_mobile VARCHAR(10) NOT NULL,
					    par_weight_gram INTEGER NOT NULL,
					    par_contents_description VARCHAR(200) NOT NULL,
					    par_delivery_type VARCHAR(50) NOT NULL,
					    par_packing_preference VARCHAR(50) NOT NULL,
					    par_pickup_time TIMESTAMP,
					    par_dropoff_time TIMESTAMP,
					    par_service_cost DECIMAL(10,2) NOT NULL,
					    par_payment_time TIMESTAMP NOT NULL,
					    par_status VARCHAR(20) DEFAULT 'Booked',
					    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
					    FOREIGN KEY (customer_id) REFERENCES users(user_id)
					)
					""";

			try {
				stmt.executeUpdate(createUsersTable);
			} catch (SQLException e) {
				if (!e.getSQLState().equals("X0Y32")) { // Table already exists
					throw e;
				}
			}

			try {
				stmt.executeUpdate(createBookingsTable);
			} catch (SQLException e) {
				if (!e.getSQLState().equals("X0Y32")) { // Table already exists
					throw e;
				}
			}

			// Insert default officer if not exists
			String insertOfficer = """
					INSERT INTO users (customer_name, email, country_code, mobile_number, address,
					                 user_id_string, password, role, preferences)
					SELECT 'Admin Officer', 'admin@parcel.com', '+91', '9999999999',
					       'Admin Office', 'admin', 'Admin@123', 'OFFICER', 'All notifications'
					FROM (VALUES(0)) AS dummy(x)
					WHERE NOT EXISTS (SELECT 1 FROM users WHERE user_id_string = 'admin')
					""";

			try {
				stmt.executeUpdate(insertOfficer);
			} catch (SQLException e) {
				// Ignore if already exists
			}

		} catch (SQLException e) {
			System.err.println("Error creating tables: " + e.getMessage());
		}
	}

	public static void closeConnection() {
		try {
			if (connection != null && !connection.isClosed()) {
				connection.close();
			}
		} catch (SQLException e) {
			System.err.println("Error closing connection: " + e.getMessage());
		}
	}
}
