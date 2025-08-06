<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession, com.parcel.models.User" %>
<%
	User user = (User) session.getAttribute("user");
	
	if(user == null){
	response.sendRedirect("index.jsp");
	return;
}

%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Dashboard - PMS</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
   <%@include file="nav.jsp" %>
    
    <div class="dashboard">
        <div class="dashboard-header">
            <h2>Customer Dashboard</h2>
            <p>Manage your parcels and deliveries</p>
        </div>
        
        <div class="dashboard-grid">
            <div class="dashboard-card">
                <div class="card-icon">📋</div>
                <h3>Book a Service</h3>
                <p>Schedule a new parcel delivery</p>
                <a href="booking.jsp" class="btn btn-primary">Book Now</a>
            </div>
            
            <div class="dashboard-card">
                <div class="card-icon">🔍</div>
                <h3>Track Parcel</h3>
                <p>Track your parcel's delivery status</p>
                <a href="tracking.jsp" class="btn btn-primary">Track Now</a>
            </div>
            
            <div class="dashboard-card">
                <div class="card-icon">📊</div>
                <h3>Booking History</h3>
                <p>View your previous bookings</p>
                <a href="booking-history.jsp" class="btn btn-primary">View History</a>
            </div>
            
            <div class="dashboard-card">
                <div class="card-icon">💬</div>
                <h3>Customer Support</h3>
                <p>Get help and support</p>
                <a href="customer-support.jsp" class="btn btn-primary">Contact Us</a>
            </div>
        </div>
    </div>
    
    <script src="utils.js"></script>
    <script src="main.js"></script>
</body>
</html>
