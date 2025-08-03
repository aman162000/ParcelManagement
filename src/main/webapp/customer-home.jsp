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
    <nav class="navbar">
        <div class="nav-brand">
            <h1>📦 PMS</h1>
        </div>
        <div class="nav-welcome">
            <span id="welcomeMessage">Welcome, <%= user.getCustomerName()%>
            
            </span>
        </div>
        <ul class="nav-menu">
            <li><a href="customer-home.jsp" class="active">Home</a></li>
            <li><a href="booking.jsp">Booking Service</a></li>
            <li><a href="tracking.jsp">Tracking</a></li>
            <li><a href="booking-history.jsp">Previous Booking</a></li>
            <li><a href="customer-support.jsp">Contact Support</a></li>
            <li><a href="LogoutServlet">Logout</a></li>
        </ul>
    </nav>
    
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
                <a href="booking.html" class="btn btn-primary">Book Now</a>
            </div>
            
            <div class="dashboard-card">
                <div class="card-icon">🔍</div>
                <h3>Track Parcel</h3>
                <p>Track your parcel's delivery status</p>
                <a href="tracking.html" class="btn btn-primary">Track Now</a>
            </div>
            
            <div class="dashboard-card">
                <div class="card-icon">📊</div>
                <h3>Booking History</h3>
                <p>View your previous bookings</p>
                <a href="booking-history.html" class="btn btn-primary">View History</a>
            </div>
            
            <div class="dashboard-card">
                <div class="card-icon">💬</div>
                <h3>Customer Support</h3>
                <p>Get help and support</p>
                <a href="customer-support.html" class="btn btn-primary">Contact Us</a>
            </div>
        </div>
        
        <div class="recent-activity">
            <h3>Recent Activity</h3>
            <div id="recentBookings" class="activity-list">
                <!-- Recent bookings will be loaded here -->
            </div>
        </div>
    </div>
    
    <script src="utils.js"></script>
    <script src="main.js"></script>
</body>
</html>
