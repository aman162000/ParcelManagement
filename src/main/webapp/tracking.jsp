<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page
	import="com.parcel.models.User, com.parcel.models.Booking, java.util.List"%>
<%
// Get user and bookings from request
User user = (User) session.getAttribute("user");
Booking booking = (Booking) request.getAttribute("booking");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Tracking - PMS</title>
<link rel="stylesheet" href="css/style.css" />
</head>
<body>
	<%@ include file="nav.jsp"%>

	<div class="container">
		<%
		if (user.getRole().equalsIgnoreCase("customer")) {
		%>
		<!-- Customer Tracking View -->
		<div class="tracking-container">
			<h2>🔍 Track Your Parcel</h2>
			<form class="tracking-form" method="post" action="TrackingServlet">
				<div class="form-group">
					<label for="trackingId">Enter 12-digit Booking ID:</label>
					<div class="input-group">
						<input type="text" id="bookingId" name="bookingId" maxlength="14"
							placeholder="Enter booking ID" pattern="BK[0-9]{12}"
							title="Please enter a 12-digit booking ID">
						<button type="submit" class="btn btn-primary">Search</button>
					</div>
					<span class="error-message" id="trackingIdError"></span>
				</div>
			</form>
			<%

			%>
			<%
			if (booking != null) {
			%>
			<div id="trackingResult" class="tracking-result">



				<div class="tracking-details">
					<div class="tracking-header">
						<h3>📦 Package Status</h3>
						<%
						String status = booking.getParStatus();
						String statusClass = "status-" + status.toLowerCase().replace(" ", "-");
						%>

						<span class="status-badge <%=statusClass%>"><%=status%></span>
					</div>

					<div class="package-info">
						<div class="info-row">
							<div class="info-item">
								<strong>Booking ID:</strong>
								<%=booking.getBookingId()%>
							</div>
							<div class="info-item">
								<strong>Booking Date:</strong>
								<%=booking.getBookingDate()%>
							</div>
						</div>
						<div class="info-row">
							<div class="info-item">
								<strong>From:</strong>
								<%=booking.getCustomerName()%>
							</div>
							<div class="info-item">
								<strong>To:</strong>
								<%=booking.getRecName()%>
							</div>
						</div>
						<div class="info-item">
							<strong>Delivery Address:</strong>
							<%=booking.getRecAddress()%>
						</div>
					</div>

					<div class="tracking-timeline">
						<h4>Tracking Timeline</h4>

						<div class="tracking-step completed current">
							<div class="step-icon">📋</div>
							<div class="step-content">
								<div class="step-label">Booked</div>
								<div class="step-description">Booking confirmed and
									payment received</div>
							</div>
						</div>

						<div class="tracking-step  ">
							<div class="step-icon">📦</div>
							<div class="step-content">
								<div class="step-label">Picked Up</div>
								<div class="step-description">Package collected from
									sender</div>
							</div>
						</div>

						<div class="tracking-step  ">
							<div class="step-icon">🚚</div>
							<div class="step-content">
								<div class="step-label">In Transit</div>
								<div class="step-description">Package is on the way to
									destination</div>
							</div>
						</div>

						<div class="tracking-step  ">
							<div class="step-icon">✅</div>
							<div class="step-content">
								<div class="step-label">Delivered</div>
								<div class="step-description">Package delivered
									successfully</div>
							</div>
						</div>

					</div>

					<div class="package-details">
						<h4>Package Details</h4>
						<div class="details-grid">
							<div class="detail-item">
								<strong>Weight:</strong> 10 kg
							</div>
							<div class="detail-item">
								<strong>Size:</strong> small
							</div>
							<div class="detail-item">
								<strong>Contents:</strong> boc
							</div>
							<div class="detail-item">
								<strong>Delivery Type:</strong> standard
							</div>
							<div class="detail-item">
								<strong>Preferred Pickup:</strong> 4 Aug 2025 (12-15)
							</div>
							<div class="detail-item">
								<strong>Total Cost:</strong> ₹300
							</div>
						</div>
					</div>
				</div>
			</div>
			<%
			}
			%>

			<%
			} else {
			%>
			<!-- Officer Tracking View -->
			<div class="tracking-container">
				<h2>📦 All Packages</h2>
				<div class="search-form">
					<div class="form-row">
						<div class="form-group">
							<label for="customerIdSearch">Customer ID:</label> <input
								type="text" id="customerIdSearch"
								placeholder="Enter customer ID">
						</div>
						<div class="form-group">
							<label for="bookingIdSearch">Booking ID:</label> <input
								type="text" id="bookingIdSearch" placeholder="Enter booking ID">
						</div>
						<div class="form-group">
							<button onclick="searchOfficerPackages()" class="btn btn-primary">Search</button>
							<button onclick="showAllPackages()" class="btn btn-secondary">Show
								All</button>
						</div>
					</div>
				</div>

				<div id="packagesResult" class="packages-result">
					<div class="table-container">
						<table class="table">
							<thead>
								<tr>
									<th>Booking ID</th>
									<th>Customer ID</th>
									<th>Sender</th>
									<th>Receiver</th>
									<th>Date</th>
									<th>Status</th>
									<th>Amount</th>
								</tr>
							</thead>
							<tbody>

							</tbody>
						</table>
					</div>
				</div>
			</div>
			<%
			}
			%>
		</div>

		<script src="utils.js"></script>
		<script src="tracking.js"></script>
</body>
</html>
