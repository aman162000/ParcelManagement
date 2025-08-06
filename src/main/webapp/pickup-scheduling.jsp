<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="java.util.*, com.parcel.models.Booking, com.parcel.models.User"%>
<%@ page session="true"%>
<%@ include file="successModal.jsp"%>
<%
User user = (User) session.getAttribute("user");

if (user == null || user.getRole() == null || !"officer".equalsIgnoreCase(user.getRole())) {
	response.sendRedirect("index.jsp");
	return;
}

List<Booking> todaysBooking = (List<Booking>) request.getAttribute("todaysBookings");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Pickup Scheduling - PMS</title>
<link rel="stylesheet" href="css/style.css">
</head>
<body>
	<%@ include file="nav.jsp"%>

	<div class="container">
		<div class="pickup-container">
			<h2>📅 Pickup Scheduling</h2>

			<div class="scheduling-form">
				<h3>Schedule Pickup</h3>
				<form id="pickupForm" class="form">
					<div class="form-group">
						<label for="bookingId">Booking ID:</label> <input type="text"
							id="bookingId" name="bookingId" required maxlength="12"
							placeholder="Enter 12-digit booking ID"> <span
							class="error-message" id="bookingIdError"></span>
					</div>

					<div id="bookingDetails" class="booking-details hidden">
						<!-- Booking details will be populated here -->
					</div>

					<div class="form-row">
						<div class="form-group">
							<label for="pickupDate">Pickup Date:</label> <input type="date"
								id="pickupDate" name="pickupDate" required> <span
								class="error-message" id="pickupDateError"></span>
						</div>

						<div class="form-group">
							<label for="pickupTime">Pickup Time:</label> <select
								id="pickupTime" name="pickupTime" required>
								<option value="">Select Time Slot</option>
								<option value="9-12">9:00 AM - 12:00 PM</option>
								<option value="12-15">12:00 PM - 3:00 PM</option>
								<option value="15-18">3:00 PM - 6:00 PM</option>
								<option value="18-21">6:00 PM - 9:00 PM</option>
							</select> <span class="error-message" id="pickupTimeError"></span>
						</div>
					</div>

					<div class="form-group">
						<label for="pickupNotes">Pickup Notes (Optional):</label>
						<textarea id="pickupNotes" name="pickupNotes" rows="3"
							placeholder="Any special instructions for pickup"></textarea>
					</div>

					<div class="button-group">
						<button type="submit" class="btn btn-primary">Schedule
							Pickup</button>
						<button type="button" class="btn btn-secondary"
							onclick="resetPickupForm()">Reset</button>
						<button type="button" class="btn btn-secondary"
							onclick="goToOfficerHome()">Back to Home</button>
					</div>
				</form>
			</div>

			<div class="scheduled-pickups">
				<h3>📋 Today's Scheduled Pickups</h3>
				<div id="todayPickups" class="pickups-list">
					<%
					if (todaysBooking != null) {
					for (Booking book : todaysBooking) {
					%>
					<div class="pickup-item">
						<div class="pickup-header">
							<strong>Booking ID: <%=book.getBookingId()%></strong> <span
								class="status-badge status-booked"><%=book.getParStatus()%></span>
						</div>
						<div class="pickup-details">
							<p>
								<strong>Sender:</strong>
								<%=book.getCustomerName()%>
								| <strong>Contact:</strong>
								<%=book.getCustomerContact()%>
							</p>
							<p>
								<strong>Address:</strong>
								<%=book.getRecAddress()%>
							</p>
							<p>
								<strong>Time:</strong>
								<%=book.getParPickupTime()%>
							</p>
							<p>
								<strong>Package:</strong>
								<%=book.getParWeightGram() / 1000 + "kg"%>,
								<%=book.getParPackingPreference()%>
								-
								<%=book.getParContentsDescription()%>
							</p>
						</div>


					</div>
					<%
					}

					}
					%>


				</div>
			</div>
		</div>
	</div>

	<!-- Success Modal -->
	<div id="successModal" class="modal hidden">
		<div class="modal-content">
			<h2 class="success-title">Pickup Scheduled Successfully! ✅</h2>
			<div id="successDetails" class="success-details"></div>
			<button onclick="closeSuccessModal()" class="btn btn-primary">OK</button>
		</div>
	</div>

	<script src="utils.js"></script>
</body>
</html>