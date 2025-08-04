<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession, com.parcel.models.User"%>

<%
User user = (User) session.getAttribute("user");
if (user != null) {
	if(user.getRole().equalsIgnoreCase("CUSTOMER")){
		response.sendRedirect("customer-home.jsp");	
	}else{
		response.sendRedirect("officer-home.jsp");
	}
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Parcel Management System - Login</title>
<link rel="stylesheet" href="css/style.css">
</head>
<body>
	<div class="container">
		<div class="login-card">
			<div class="logo">
				<h1>📦 PMS</h1>
				<p>Parcel Management System</p>
				<%
				String error = (String) request.getAttribute("error");
				%>
				<%
				if (error != null) {
				%>
				<span class="error-message" id="nameError"><%=error%></span>
				<%
				}
				%>
			</div>

			<form id="loginForm" class="form" method="post" action="LoginServlet">
				<h2>Login</h2>

				<div class="form-group">
					<label for="username">Username:</label> <input type="text"
						id="username" name="username" required minlength="5"
						maxlength="20" placeholder="Enter username (5-20 characters)">
					<span class="error-message" id="usernameError"></span>
				</div>

				<div class="form-group">
					<label for="password">Password:</label> <input type="password"
						id="password" name="password" required maxlength="30"
						placeholder="Enter password"> <span class="error-message"
						id="passwordError"></span>
				</div>

				<div class="form-group">
					<label for="role">Login as:</label> <select id="role" name="role"
						required>
						<option value="">Select Role</option>
						<option value="customer">Customer</option>
						<option value="officer">Officer</option>
					</select>
				</div>

				<button type="submit" class="btn btn-primary">Login</button>

				<div class="register-link">
					<p>
						New customer? <a href="customer-register.jsp">Register here</a>
					</p>
				</div>
			</form>
		</div>
	</div>

	<script src="utils.js"></script>
	<script src="auth.js"></script>
</body>
</html>

