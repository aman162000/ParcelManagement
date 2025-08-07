package com.parcel.dao;

import com.parcel.models.*;
import com.parcel.exceptions.AuthenticationException;
import com.parcel.exceptions.UserAlreadyExistsException;
import com.parcel.utils.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import org.mindrot.jbcrypt.*;

public class UserDAO {

	public void registerUser(User user) throws SQLException, UserAlreadyExistsException {
		// Check if email already exists
		if (isEmailExists(user.getEmail())) {
			throw new UserAlreadyExistsException("Email Already Exists");
		}

		if (isUserNameExists(user.getUserIdString())) {
			throw new UserAlreadyExistsException("UserId Already Exists");
		}

		if (isMobileNumberExists(user.getMobileNumber())) {
			throw new UserAlreadyExistsException("Mobile number Already Exists");
		}

		String sql = """
				INSERT INTO users (customer_name, email, country_code, mobile_number, address,
				                 user_id_string, password, role, preferences,customer_id,user_id)
				VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?,?, ?)
				""";

		try (Connection conn = DatabaseConnection.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, user.getCustomerName());
			pstmt.setString(2, user.getEmail());
			pstmt.setString(3, user.getCountryCode());
			pstmt.setString(4, user.getMobileNumber());
			pstmt.setString(5, user.getAddress());
			pstmt.setString(6, user.getUserIdString());
			pstmt.setString(7, user.getPassword());
			pstmt.setString(8, user.getRole());
			pstmt.setString(9, user.getPreferences());
			pstmt.setString(10, user.getCustomerId());
			pstmt.setInt(11, user.getUserId());

			pstmt.executeUpdate();
		}
	}

	public User login(String userIdString, String password) throws SQLException, AuthenticationException {
		String sql = "SELECT * FROM users WHERE user_id_string = ?";

		try (Connection conn = DatabaseConnection.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, userIdString);

			try (ResultSet rs = pstmt.executeQuery()) {
				if (rs.next()) {
					// Retrieve the stored hashed password from the database
					String storedHashedPassword = rs.getString("password");

					// Compare the entered password with the stored hashed password
					if (BCrypt.checkpw(password, storedHashedPassword)) {
						// Password matches, create and return User object
						User user = new User();
						user.setUserId(rs.getInt("user_id"));
						user.setCustomerName(rs.getString("customer_name"));
						user.setEmail(rs.getString("email"));
						user.setCountryCode(rs.getString("country_code"));
						user.setMobileNumber(rs.getString("mobile_number"));
						user.setAddress(rs.getString("address"));
						user.setUserIdString(rs.getString("user_id_string"));
						user.setPassword(storedHashedPassword); // Store the hashed password (not plain-text)
						user.setRole(rs.getString("role"));
						user.setPreferences(rs.getString("preferences"));
						user.setCustomerId(rs.getString("customer_id"));
						return user;
					} else {
						// Password does not match
						throw new AuthenticationException("Invalid username or password.");
					}
				}
			}
		}
		// User not found or password mismatch
		return null;
	}

	public User getUserByCustomerId(String customerId) throws SQLException {
		String sql = "SELECT * FROM users WHERE customer_id = ?";

		try (Connection conn = DatabaseConnection.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, customerId);

			try (ResultSet rs = pstmt.executeQuery()) {
				if (rs.next()) {
					User user = new User();
					user.setUserId(rs.getInt("user_id"));
					user.setCustomerName(rs.getString("customer_name"));
					user.setEmail(rs.getString("email"));
					user.setCountryCode(rs.getString("country_code"));
					user.setMobileNumber(rs.getString("mobile_number"));
					user.setAddress(rs.getString("address"));
					user.setUserIdString(rs.getString("user_id_string"));
					user.setPassword(""); // Store the hashed password (not plain-text)
					user.setRole(rs.getString("role"));
					user.setPreferences(rs.getString("preferences"));
					user.setCustomerId(rs.getString("customer_id"));
					return user;
				}
			}
		}

		return null;

	}

	private boolean isEmailExists(String email) throws SQLException {
		String sql = "SELECT COUNT(*) FROM users WHERE email = ?";

		try (Connection conn = DatabaseConnection.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, email);
			try (ResultSet rs = pstmt.executeQuery()) {
				return rs.next() && rs.getInt(1) > 0;
			}
		}
	}

	private boolean isUserNameExists(String userId) throws SQLException {
		String sql = "SELECT COUNT(*) FROM users WHERE user_id_string = ?";
		try (Connection conn = DatabaseConnection.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {
			pstmt.setString(1, userId);
			try (ResultSet rs = pstmt.executeQuery()) {
				return rs.next() && rs.getInt(1) > 0;
			}
		}
	}

	private boolean isMobileNumberExists(String mob) throws SQLException {
		String sql = "SELECT COUNT(*) FROM users WHERE mobile_number = ?";
		try (Connection conn = DatabaseConnection.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {
			pstmt.setString(1, mob);
			try (ResultSet rs = pstmt.executeQuery()) {
				return rs.next() && rs.getInt(1) > 0;
			}
		}
	}
}
