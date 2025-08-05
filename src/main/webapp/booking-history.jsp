<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page
	import="com.parcel.models.User,com.parcel.models.Booking,java.util.List,java.sql.Timestamp"%>
<%
User user = (User) session.getAttribute("user");

List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");

if (user == null) {
	response.sendRedirect("index.jsp");
	return;
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Booking History - PMS</title>
<link rel="stylesheet" href="css/style.css" />
</head>
<body>
	<%@include file="nav.jsp"%>

	<div class="container">
		<div class="history-container">
			<h2>📊 Booking History</h2>

			<div id="filterSection" class="filter-section">
				<!-- Filters will be populated based on user role -->
				<form class="filter-form" action="BookingHistoryServlet">
					<div class="form-row">
						<div class="form-group">
							<label for="statusFilter">Status:</label> <select
								name="statusFilter" id="statusFilter"
								onchange="filterCustomerBookings()">
								<option value="">All Status</option>
								<option value="booked">Booked</option>
								<option value="picked-up">Picked Up</option>
								<option value="in-transit">In Transit</option>
								<option value="delivered">Delivered</option>
								<option value="returned">Returned</option>
							</select>
						</div>
						<div class="form-group">
							<label for="dateFromFilter">From Date:</label> <input type="date"
								id="dateFromFilter" name="startDate"
								onchange="filterCustomerBookings()">
						</div>
						<div class="form-group">
							<label for="dateToFilter">To Date:</label> <input type="date"
								id="dateToFilter" name="endDate"
								onchange="filterCustomerBookings()">
						</div>
						<div class="form-group">
							<label for="dateToFilter" style="color: #ffffff">Clear</label>

							<button onclick="clearCustomerFilters()"
								class="btn btn-secondary">Clear Filters</button>
							<button type="submit" class="btn btn-secondary">Submit</button>
						</div>
					</div>
				</form>
			</div>

			<div id="historyResults" class="history-results">
				<!-- Results will be populated here -->
				<div class="table-container">
					<table class="table">
						<%
						if (bookings != null && bookings.size() > 0) {
						%>
						<thead>
							<tr>
								<th>Customer ID</th>
								<th>Booking ID</th>
								<th>Booking Date</th>
								<th>Receiver Name</th>
								<th>Delivered Address</th>
								<th>Amount</th>
								<th>Status</th>
							</tr>
						</thead>
						<tbody>
							<%
							for (Booking book : bookings) {
							%>
							<tr>
								<td><%=book.getCustomerId()%></td>
								<td><%=book.getBookingId()%></td>
								<%
								Timestamp timestamp = book.getBookingDate(); // example timestamp
								String dateOnly = new java.text.SimpleDateFormat("yyyy-MM-dd").format(timestamp);
								%>
								<td><%=dateOnly%></td>
								<td><%=book.getRecName()%></td>
								<td><%=book.getRecAddress()%></td>
								<td>₹<%=book.getParServiceCost()%></td>
								<%
								String status = book.getParStatus();
								String statusClass = "status-" + status.toLowerCase().replace(" ", "-");
								%>
								<td><span class="status-badge <%=statusClass%>"><%=status%></span>
								</td>
							</tr>
							<%
							}
							%>
							<%
							} else {
							%>
							<div class="no-results">
								<h3>No bookings found</h3>
								<p>No bookings match your current filters.</p>
							</div>
						</tbody>
						<%
						}
						%>

					</table>
				</div>
			</div>

			<div id="pagination" class="pagination">
				<!-- Pagination will be added here -->
			</div>
		</div>
	</div>

	<script src="js/utils.js"></script>
	<script src="js/booking-history.js"></script>
</body>
</html>
