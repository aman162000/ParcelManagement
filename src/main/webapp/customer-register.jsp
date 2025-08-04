<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession, com.parcel.models.User" %>

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
    <title>Customer Registration - PMS</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <div class="register-card">
            <div class="logo">
                <h1>📦 PMS</h1>
                <p>Customer Registration</p>
                <% String error = (String) request.getAttribute("error"); %>
                <% if(error!=null) {%>
                        <span class="error-message" id="nameError"><%= error %></span>
                
                <%}%>
            </div>
            
            <form id="registerForm" class="form" method="post" action="RegisterServlet">
                <h2>Create Account</h2>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="name">Full Name:</label>
                        <input type="text" id="name" name="name" required 
                               maxlength="50" placeholder="Enter full name">
                        <span class="error-message" id="nameError"></span>
                    </div>
                    
                    <div class="form-group">
                        <label for="email">Email:</label>
                        <input type="email" id="email" name="email" required 
                               placeholder="Enter email address">
                        <span class="error-message" id="emailError"></span>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="mobile">Mobile Number:</label>
                        <input type="tel" id="mobile" name="mobile" required 
                               pattern="^(\+\d{1,3}[- ]?)?\d{10}$" 
                               placeholder="Country code + 10 digits">
                        <span class="error-message" id="mobileError"></span>
                    </div>
                    
                    <div class="form-group">
                        <label for="userId">User ID:</label>
                        <input type="text" id="userId" name="userId" required 
                               minlength="5" maxlength="20" 
                               placeholder="Choose username (5-20 characters)">
                        <span class="error-message" id="userIdError"></span>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="address">Address:</label>
                    <textarea id="address" name="address" required 
                              placeholder="Enter complete address" rows="3"></textarea>
                    <span class="error-message" id="addressError"></span>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="password">Password:</label>
                        <input type="password" id="password" name="password" required 
                               maxlength="30" placeholder="Strong password required">
                        <span class="error-message" id="passwordError"></span>
                        <small>Must include uppercase, lowercase, and special character</small>
                    </div>
                    
                    <div class="form-group">
                        <label for="confirmPassword">Confirm Password:</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" required 
                               placeholder="Re-enter password">
                        <span class="error-message" id="confirmPasswordError"></span>
                    </div>
                </div>
                
                <div class="preferences-section">
                    <h3>Preferences</h3>
                    <div class="checkbox-group">
                        <label class="checkbox-label">
                            <input type="checkbox" name="preferences" value="emailNotifications" checked>
                            Email Notifications
                        </label>
                        <label class="checkbox-label">
                            <input type="checkbox" name="preferences" value="smsNotifications">
                            SMS Notifications
                        </label>
                        <label class="checkbox-label">
                            <input type="checkbox" name="preferences" value="homeDelivery" checked>
                            Home Delivery Preference
                        </label>
                        <label class="checkbox-label">
                            <input type="checkbox" name="preferences" value="insurance">
                            Default Insurance Coverage
                        </label>
                    </div>
                </div>
                
                <div class="button-group">
                    <button type="submit" class="btn btn-primary">Register</button>
                    <button type="reset" class="btn btn-secondary">Reset</button>
                </div>
                
                <div class="login-link">
                    <p>Already have an account? <a href="index.jsp">Login here</a></p>
                </div>
            </form>
        </div>
    </div>
    
    <!-- Success Modal -->
    <% Boolean isRegisteredSuccessfully = (Boolean) request.getAttribute("isRegistered"); %>
    <% if(isRegisteredSuccessfully != null) {%>
   
    
    <div id="successModal" class="modal">
        <div class="modal-content">
            <h2 class="success-title">Registration Successful! ✅</h2>
            <div id="successDetails" class="success-details">
            <div class="success-info">
            <p><strong>Generated Username:</strong> <%= user.getUserIdString()%></p>
            <p><strong>Customer Name:</strong> <%= user.getCustomerName()%></p>
            <p><strong>Email:</strong> <%= user.getEmail() %></p>
            <p><strong>Customer ID:</strong> <%= user.getCustomerId()%></p>
            <p class="success-message">Account created successfully! You can now log in with your credentials.</p>
        </div>
            </div>
            <button onclick="window.location.href='index.jsp'" class="btn btn-primary">Go to Login</button>
        </div>
    </div>
    <%}%>
    
    <script src="utils.js"></script>
    <script src="auth.js"></script>
</body>
</html>
