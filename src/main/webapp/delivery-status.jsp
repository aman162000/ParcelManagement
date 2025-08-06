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

Booking booking = (Booking) request.getAttribute("booking");
List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");

Map<String, Integer> stats = new HashMap<>();
stats.put("picked-up", 0);
stats.put("in-transit", 0);
stats.put("delivered", 0);
stats.put("returned", 0);

if (bookings != null) {
	for (Booking book : bookings) {
		if (book != null && book.getParStatus() != null) {
	String status = book.getParStatus().toLowerCase();

	if (stats.containsKey(status)) {
		stats.put(status, stats.get(status) + 1);
	} else {
		stats.put(status, stats.getOrDefault(status, 0) + 1);
	}
		}
	}
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Delivery Status - PMS</title>
<link rel="stylesheet" href="css/style.css">
</head>
<body>

	<%@ include file="nav.jsp"%>

	<div class="container">
		<div class="delivery-container">
			<h2>🚚 Delivery Status Management</h2>

			<div class="status-overview">
				<h3>📊 Status Overview</h3>
				<div class="status-stats">
					<div class="stat-card">
						<h4>Picked Up</h4>
						<div class="stat-number" id="pickedUpCount">
							<%=stats.getOrDefault("picked-up", 0)%>
						</div>
					</div>
					<div class="stat-card">
						<h4>In Transit</h4>
						<div class="stat-number" id="inTransitCount">
							<%=stats.getOrDefault("in-transit", 0)%>

						</div>
					</div>
					<div class="stat-card">
						<h4>Delivered</h4>
						<div class="stat-number" id="deliveredCount">
							<%=stats.getOrDefault("delivered", 0)%>
						</div>
					</div>
					<div class="stat-card">
						<h4>Returned</h4>
						<div class="stat-number" id="returnedCount">
							<%=stats.getOrDefault("returned", 0)%>
						</div>
					</div>
				</div>
			</div>

			<div class="status-update-form">
				<h3>Update Package Status</h3>
				<form id="statusForm" class="form"
					action="UpdateDeliveryStatusServlet" method="get">
					<div class="form-group">
						<label for="bookingId">Booking ID:</label> <input type="text"
							id="bookingId" name="bookingId" required="" maxlength="14"
							placeholder="Enter 12-digit booking ID"> <input
							type="hidden" name="action" value="get-booking">
						<div class="button-group">
							<button type="submit" class="btn btn-primary">Search</button>
						</div>
						<span class="error-message" id="bookingIdError"></span>
					</div>
					<%
					if (booking != null) {
					%>
					<div id="packageDetails" class="package-details">
						<h4>Package Details</h4>
						<div class="details-grid">
							<div class="detail-item">
								<%
								String status = booking.getParStatus();
								String statusClass = "status-" + status.toLowerCase().replace(" ", "-");
								%>

								<strong>Current Status: </strong><span
									class="status-badge <%=statusClass%>"><%=status%></span>

							</div>
							<div class="detail-item">
								<strong>Sender:</strong>
								<%=booking.getCustomerName()%>
							</div>
							<div class="detail-item">
								<strong>Receiver:</strong>
								<%=booking.getRecName()%>
							</div>
							<div class="detail-item">
								<strong>Delivery Address:</strong>
								<%=booking.getRecAddress()%>
							</div>
							<div class="detail-item">
								<strong>Package:</strong>
								<%=booking.getParWeightGram() / 1000%>
								kg
							</div>
							<div class="detail-item">
								<strong>Contents:</strong>
								<%=booking.getParContentsDescription()%>
							</div>
						</div>
					</div>
					<%
					}
					%>

				</form>
				<form method="post" action="UpdateDeliveryStatusServlet">
					<%
					String currentStatus = booking != null ? booking.getParStatus().toLowerCase() : "booked";
					String id = booking != null ? booking.getBookingId() : "";
					Map<String, List<String>> validTransitions = new HashMap<>();
					validTransitions.put("booked", Arrays.asList("picked-up"));
					validTransitions.put("picked-up", Arrays.asList("in-transit", "returned"));
					validTransitions.put("in-transit", Arrays.asList("delivered", "returned"));
					validTransitions.put("delivered", Collections.emptyList());
					validTransitions.put("returned", Collections.emptyList());

					List<String> nextStatuses = validTransitions.getOrDefault(currentStatus, Collections.emptyList());
					%>
					<div class="form-group">
						<label for="newStatus">Update Status To:</label> <select
							id="newStatus" name="newStatus" required>
							<option value="">Select Status</option>
							<%
							if (nextStatuses != null) {
								for (String status : nextStatuses) {
									// Format display name: picked-up → Picked Up
									String displayName = status.replace("-", " ");

									displayName = displayName.substring(0, 1).toUpperCase() + displayName.substring(1);
							%>
							<option value="<%=status%>"><%=displayName%></option>
							<%
							}
							} else {
							%>
							<option value="">No transitions available</option>
							<%
							}
							%>
						</select> <span class="error-message" id="newStatusError"></span> <input
							type="hidden" name="bookingId" value="<%=id%>">
					</div>
					<div class="form-group">
						<label for="statusNotes">Status Notes:</label>
						<textarea id="statusNotes" name="statusNotes" rows="3"
							placeholder="Add any relevant notes about the status update"></textarea>
					</div>

					<div class="button-group">
						<button type="submit" class="btn btn-primary">Update
							Status</button>
						<button type="button" class="btn btn-secondary"
							onclick="resetStatusForm()">Reset</button>
						<button type="button" class="btn btn-secondary"
							onclick="goToOfficerHome()">Back to Home</button>
					</div>

				</form>
			</div>


		</div>
	</div>

	<%
	if (request.getAttribute("showSuccessModal") != null) {
	%>
	<script>
		document.addEventListener("DOMContentLoaded", function() {
			showSuccessModal();
		});
	</script>
	<%
	}
	%>


	<script src="utils.js"></script>
</body>
</html>
