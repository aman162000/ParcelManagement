<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession, com.parcel.models.User"%>

<%
User user = (User) session.getAttribute("user"); // assuming userRole is set as a request attribute
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Booking Service - PMS</title>
<link rel="stylesheet" href="css/style.css">
</head>
<body>
	<nav class="navbar">
		<div class="nav-brand">
			<h1>📦 PMS</h1>
		</div>
		<div class="nav-welcome">
			<span id="welcomeMessage">Welcome, <%= user.getCustomerName() %></span>
		</div>
		<ul class="nav-menu" id="navMenu">
			<%
			String currentPage = request.getRequestURI().substring(request.getRequestURI().lastIndexOf("/") + 1);
			String userRole = user.getRole();
			// Check user role and generate the appropriate navigation menu
			if ("customer".equalsIgnoreCase(userRole)) {
			%>
			<li><a href="customer-home.jsp"
				<%="customer-home.jsp".equals(currentPage) ? "class='active'" : ""%>>Home</a></li>
			<li><a href="booking.jsp"
				<%="booking.jsp".equals(currentPage) ? "class='active'" : ""%>>Booking
					Service</a></li>
			<li><a href="tracking.html"
				<%="tracking.html".equals(currentPage) ? "class='active'" : ""%>>Tracking</a></li>
			<li><a href="booking-history.jsp"
				<%="booking-history.jsp".equals(currentPage) ? "class='active'" : ""%>>Previous
					Booking</a></li>
			<li><a href="customer-support.jsp"
				<%="customer-support.jsp".equals(currentPage) ? "class='active'" : ""%>>Contact
					Support</a></li>
			<li><a href="logout.jsp">Logout</a></li>

			<%
			} else if ("officer".equalsIgnoreCase(userRole)) {
			%>
			<li><a href="officer-home.jsp"
				<%="officer-home.jsp".equals(currentPage) ? "class='active'" : ""%>>Home</a></li>
			<li><a href="tracking.html"
				<%="tracking.html".equals(currentPage) ? "class='active'" : ""%>>Tracking</a></li>
			<li><a href="delivery-status.jsp"
				<%="delivery-status.jsp".equals(currentPage) ? "class='active'" : ""%>>Delivery
					Status</a></li>
			<li><a href="pickup-scheduling.jsp"
				<%="pickup-scheduling.jsp".equals(currentPage) ? "class='active'" : ""%>>Pickup
					Scheduling</a></li>
			<li><a href="booking-history.jsp"
				<%="booking-history.jsp".equals(currentPage) ? "class='active'" : ""%>>Previous
					Booking</a></li>
			<li><a href="logout.jsp">Logout</a></li>

			<%
			} else { // For guest or unauthorized users
			%>
			<li><a href="index.jsp"
				<%="index.jsp".equals(currentPage) ? "class='active'" : ""%>>Home</a></li>
			<li><a href="login.jsp"
				<%="login.jsp".equals(currentPage) ? "class='active'" : ""%>>Login</a></li>
			<%
			}
			%>
		</ul>

	</nav>

	<div class="container">
		<div class="booking-container">
			<h2>📋 Booking Service</h2>

			<form id="bookingForm" class="form">
				<!-- Sender Information -->
				<div class="form-section">
					<h3>👤 Sender Information</h3>
					<div class="form-row">
						<div class="form-group">
							<label for="senderName">Name:</label> <input type="text"
								id="senderName" name="senderName" required> <span
								class="error-message" id="senderNameError"></span>
						</div>
						<div class="form-group">
							<label for="senderContact">Contact Number:</label> <input
								type="tel" id="senderContact" name="senderContact" required>
							<span class="error-message" id="senderContactError"></span>
						</div>
					</div>
					<div class="form-group">
						<label for="senderAddress">Address:</label>
						<textarea id="senderAddress" name="senderAddress" required
							rows="2"></textarea>
						<span class="error-message" id="senderAddressError"></span>
					</div>
					<div class="form-group">
						<label for="senderPincode">Pin Code:</label> <input type="text"
							id="senderPincode" name="senderPincode" required
							pattern="[0-9]{6}"> <span class="error-message"
							id="senderPincodeError"></span>
					</div>
				</div>

				<!-- Receiver Information -->
				<div class="form-section">
					<h3>👥 Receiver Information</h3>
					<div class="form-row">
						<div class="form-group">
							<label for="receiverName">Name:</label> <input type="text"
								id="receiverName" name="receiverName" required> <span
								class="error-message" id="receiverNameError"></span>
						</div>
						<div class="form-group">
							<label for="receiverContact">Contact Number:</label> <input
								type="tel" id="receiverContact" name="receiverContact" required>
							<span class="error-message" id="receiverContactError"></span>
						</div>
					</div>
					<div class="form-group">
						<label for="receiverAddress">Address:</label>
						<textarea id="receiverAddress" name="receiverAddress" required
							rows="2"></textarea>
						<span class="error-message" id="receiverAddressError"></span>
					</div>
					<div class="form-group">
						<label for="receiverPincode">Pin Code:</label> <input type="text"
							id="receiverPincode" name="receiverPincode" required
							pattern="[0-9]{6}"> <span class="error-message"
							id="receiverPincodeError"></span>
					</div>
				</div>

				<!-- Parcel Information -->
				<div class="form-section">
					<h3>📦 Parcel Information</h3>
					<div class="form-row">
						<div class="form-group">
							<label for="weight">Weight (kg):</label> <input type="number"
								id="weight" name="weight" required min="0.1" max="50" step="0.1">
							<span class="error-message" id="weightError"></span>
						</div>
						<div class="form-group">
							<label for="size">Size:</label> <select id="size" name="size"
								required>
								<option value="">Select Size</option>
								<option value="small">Small (up to 30cm)</option>
								<option value="medium">Medium (30-60cm)</option>
								<option value="large">Large (60-100cm)</option>
								<option value="xlarge">Extra Large (100cm+)</option>
							</select> <span class="error-message" id="sizeError"></span>
						</div>
					</div>
					<div class="form-group">
						<label for="contents">Contents Description:</label>
						<textarea id="contents" name="contents" required rows="2"
							placeholder="Describe parcel contents"></textarea>
						<span class="error-message" id="contentsError"></span>
					</div>
				</div>

				<!-- Shipping Options -->
				<div class="form-section">
					<h3>🚚 Shipping Options</h3>
					<div class="form-row">
						<div class="form-group">
							<label for="deliveryType">Delivery Type:</label> <select
								id="deliveryType" name="deliveryType" required>
								<option value="">Select Type</option>
								<option value="standard">Standard (3-5 days)</option>
								<option value="express">Express (1-2 days)</option>
								<option value="overnight">Overnight</option>
							</select> <span class="error-message" id="deliveryTypeError"></span>
						</div>
						<div class="form-group">
							<label for="preferredDate">Preferred Pickup Date:</label> <input
								type="date" id="preferredDate" name="preferredDate" required>
							<span class="error-message" id="preferredDateError"></span>
						</div>
					</div>
					<div class="form-group">
						<label for="preferredTime">Preferred Time Slot:</label> <select
							id="preferredTime" name="preferredTime" required>
							<option value="">Select Time</option>
							<option value="9-12">9:00 AM - 12:00 PM</option>
							<option value="12-15">12:00 PM - 3:00 PM</option>
							<option value="15-18">3:00 PM - 6:00 PM</option>
							<option value="18-21">6:00 PM - 9:00 PM</option>
						</select> <span class="error-message" id="preferredTimeError"></span>
					</div>
				</div>

				<!-- Additional Services -->
				<div class="form-section">
					<h3>➕ Additional Services</h3>
					<div class="checkbox-group">
						<label class="checkbox-label"> <input type="checkbox"
							id="insurance" name="insurance" value="insurance">
							Insurance Coverage (₹50)
						</label> <label class="checkbox-label"> <input type="checkbox"
							id="tracking" name="tracking" value="tracking" checked>
							SMS Tracking Updates (₹20)
						</label> <label class="checkbox-label"> <input type="checkbox"
							id="fragile" name="fragile" value="fragile"> Fragile
							Handling (₹30)
						</label>
					</div>
				</div>

				<!-- Cost Summary -->
				<div class="form-section">
					<h3>💰 Cost Summary</h3>
					<div class="cost-breakdown">
						<div class="cost-item">
							<span>Base Cost:</span> <span id="baseCost">â¹0</span>
						</div>
						<div class="cost-item">
							<span>Additional Services:</span> <span id="additionalCost">â¹0</span>
						</div>
						<div class="cost-item total">
							<span>Total Amount:</span> <span id="totalCost">â¹0</span>
						</div>
					</div>
				</div>

				<div class="button-group">
					<button type="submit" class="btn btn-primary" id="submitBtn">Book
						Service</button>
					<button type="button" class="btn btn-secondary"
						onclick="resetForm()">Reset</button>
					<button type="button" class="btn btn-secondary" onclick="goBack()">Back
						to Home</button>
				</div>
			</form>
		</div>
	</div>
	<script src="js/utils.js"></script>
	<script src="js/booking.js"></script>
</body>
</html>