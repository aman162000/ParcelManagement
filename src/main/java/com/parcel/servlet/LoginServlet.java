package com.parcel.servlet;

import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.parcel.models.User;
import com.parcel.services.UserService;
import com.parcel.exceptions.AuthenticationException;

/**
 * Servlet implementation class LoginServlet
 */
@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	// UserService is injected, improving testability and decoupling
	private UserService userService = new UserService();

	public LoginServlet() {
		super();
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// Not used in this case, can be removed if unnecessary
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		RequestDispatcher rd = null;

		// Input Validation
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String role = request.getParameter("role");

		if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
			request.setAttribute("error", "Username and Password are required.");
			rd = request.getRequestDispatcher("index.jsp");
			rd.forward(request, response);
			return;
		}

		try {
			// Authentication using service layer
			User user = userService.login(username, password);

			if (user != null) {
				HttpSession session = request.getSession();
				session.setAttribute("user", user);
				String actualRole = user.getRole(); // from database or session
				
				if ("officer".equalsIgnoreCase(role) && "officer".equalsIgnoreCase(actualRole)) {
					response.sendRedirect("officer-home.jsp");
				} else if ("customer".equalsIgnoreCase(role) && "customer".equalsIgnoreCase(actualRole)) {
					response.sendRedirect("customer-home.jsp");
				} else {
					// Invalid role selection
					request.setAttribute("error", "Invalid role selected for the user.");
					request.getRequestDispatcher("index.jsp").forward(request, response);
				}
			} else {
				// Invalid credentials
				request.setAttribute("error", "Invalid username or password.");
				rd = request.getRequestDispatcher("index.jsp");
				rd.forward(request, response);
			}
		} catch (SQLException e) {
			// Database related error
			request.setAttribute("error", "Database error, please try again later.");
			rd = request.getRequestDispatcher("index.jsp");
			rd.forward(request, response);

		} catch (AuthenticationException e) {
			// Custom authentication error handling (e.g., account locked, incorrect role)
			request.setAttribute("error", e.getMessage());
			rd = request.getRequestDispatcher("index.jsp");
			rd.forward(request, response);

		} catch (Exception e) {
			// Generic error handling
			request.setAttribute("error", "An unexpected error occurred, please try again later.");
			rd = request.getRequestDispatcher("index.jsp");
			rd.forward(request, response);
		}
	}
}
