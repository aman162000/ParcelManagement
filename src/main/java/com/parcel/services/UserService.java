package com.parcel.services;

import com.parcel.dao.UserDAO;
import com.parcel.models.User;
import com.parcel.exceptions.AuthenticationException;
import com.parcel.exceptions.UserAlreadyExistsException;
import com.parcel.utils.ValidationUtils;

import java.sql.SQLException;
import org.mindrot.jbcrypt.*;

public class UserService {
	private UserDAO userDAO;

	public UserService() {
		this.userDAO = new UserDAO();
	}

	public void registerUser(User user) throws SQLException, UserAlreadyExistsException, IllegalArgumentException {
		// Validate user data
		validateUserData(user);

		userDAO.registerUser(user);
		System.out.println("User registered successfully: " + Thread.currentThread().getName());

	}

	public User login(String userIdString, String password) throws SQLException, AuthenticationException {
		if (!ValidationUtils.isValidUserId(userIdString)) {
			throw new IllegalArgumentException("Invalid User ID format");
		}

		return userDAO.login(userIdString, password);
	}

	public User getUserByCustomerId(String customerId) throws SQLException {
		return userDAO.getUserByCustomerId(customerId);

	}
	
	private void validateUserData(User user) throws IllegalArgumentException {
		if (!ValidationUtils.isValidName(user.getCustomerName())) {
			throw new IllegalArgumentException("Customer name must be 1-50 characters");
		}

		if (!ValidationUtils.isValidEmail(user.getEmail())) {
			throw new IllegalArgumentException("Invalid email format");
		}

		if (!ValidationUtils.isValidMobile(user.getMobileNumber())) {
			throw new IllegalArgumentException("Mobile number must be 10 digits");
		}

		if (!ValidationUtils.isValidUserId(user.getUserIdString())) {
			throw new IllegalArgumentException("User ID must be 5-20 characters");
		}

//		if (!ValidationUtils.isValidPassword(user.getPassword())) {
//			throw new IllegalArgumentException(
//					"Password must be max 30 chars with uppercase, lowercase, and special character");
//		}
	}
}
