package com.parcel.servlet;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.validator.EmailValidator;
import org.mindrot.jbcrypt.*;

import com.parcel.services.UserService;
import com.parcel.models.User;
import com.parcel.exceptions.*;
/**
 * Servlet implementation class RegisterServlet
 */
@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private static final String COUNTRY_CODE = "+91"; // Hardcode country code only if necessary

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public RegisterServlet() {
		super();
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		try {
			UserService userService = new UserService();

			// Input validation
			String name = request.getParameter("name");
			String email = request.getParameter("email");
			String mobile = request.getParameter("mobile");
			String userId = request.getParameter("userId");
			String address = request.getParameter("address");
			String password = request.getParameter("password");
			String confirmPassword = request.getParameter("confirmPassword");
			String[] checkBoxValues = request.getParameterValues("preferences");

			if (StringUtils.isBlank(name) || StringUtils.isBlank(email) || StringUtils.isBlank(mobile)
					|| StringUtils.isBlank(userId) || StringUtils.isBlank(address) || StringUtils.isBlank(password)
					|| StringUtils.isBlank(confirmPassword)) {
				throw new IllegalArgumentException("All fields are required.");
			}

			if (!password.equals(confirmPassword)) {
				throw new IllegalArgumentException("Passwords do not match!");
			}

			// Validate email format
			if (!EmailValidator.getInstance().isValid(email)) {
				throw new IllegalArgumentException("Invalid email format!");
			}

			String _mobile = mobile.split(" ")[1];
			
			// Validate mobile number format (basic validation for a 10-digit number)
			if (_mobile.length() != 10 || !StringUtils.isNumeric(_mobile)) {
				throw new IllegalArgumentException("Invalid mobile number format!");
			}

			// Hash the password before storing
			String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

			// Assuming preferences are optional
			String preferences = checkBoxValues != null && checkBoxValues.length > 0 ? checkBoxValues[0] : null;

			User user = new User(name, email, COUNTRY_CODE, _mobile, address, userId, hashedPassword, "CUSTOMER",
					preferences);

			// Register the user
			userService.registerUser(user);

			request.setAttribute("isRegistered", true);
			request.setAttribute("user", user);
			RequestDispatcher rd = request.getRequestDispatcher("customer-register.jsp");
			rd.forward(request, response);

		} catch (UserAlreadyExistsException |IllegalArgumentException | IllegalStateException e) {
			// Handle known validation or registration errors
			request.setAttribute("error", e.getMessage());
			RequestDispatcher rd = request.getRequestDispatcher("customer-register.jsp");
			rd.forward(request, response);
		} catch (Exception e) {
			// Handle unexpected errors
			e.printStackTrace(); // Replace with logger in production
			request.setAttribute("error", "An unexpected error occurred. Please try again later.");
			RequestDispatcher rd = request.getRequestDispatcher("customer-register.jsp");
			rd.forward(request, response);
		}
	}
}
