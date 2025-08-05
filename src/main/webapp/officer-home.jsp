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
    <meta charset="UTF-16">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Officer Dashboard - PMS</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <nav class="navbar">
        <div class="nav-brand">
            <h1>📦 PMS</h1>
        </div>
        <div class="nav-welcome">
            <span id="welcomeMessage">Welcome, 
            <%= user.getCustomerName() %>
            </span>
        </div>
        <ul class="nav-menu">
            <li><a href="officer-home.jsp" class="active">Home</a></li>
            <li><a href="tracking.jsp">Tracking</a></li>
            <li><a href="delivery-status.jsp">Delivery Status</a></li>
            <li><a href="pickup-scheduling.jsp">Pickup Scheduling</a></li>
            <li><a href="booking-history.jsp">Previous Booking</a></li>
            <li><a href="LogoutServlet">Logout</a></li>
        </ul>
    </nav>
    
    <div class="dashboard">
        <div class="dashboard-header">
            <h2>Officer Dashboard</h2>
            <p>Manage deliveries and customer services</p>
        </div>
        
        <div class="dashboard-grid">
            <div class="dashboard-card">
                <div class="card-icon">📋</div>
                <h3>Create Booking</h3>
                <p>Create booking for customers</p>
                <a href="booking.jsp" class="btn btn-primary">Create Booking</a>
            </div>
            
            <div class="dashboard-card">
                <div class="card-icon">🔍</div>
                <h3>Track Parcels</h3>
                <p>View all shipped packages</p>
                <a href="tracking.jsp" class="btn btn-primary">View Packages</a>
            </div>
            
            <div class="dashboard-card">
                <div class="card-icon">🚚</div>
                <h3>Delivery Status</h3>
                <p>Update package delivery status</p>
                <a href="delivery-status.jsp" class="btn btn-primary">Update Status</a>
            </div>
            
            <div class="dashboard-card">
                <div class="card-icon">📅</div>
                <h3>Pickup Scheduling</h3>
                <p>Schedule package pickups</p>
                <a href="pickup-scheduling.jsp" class="btn btn-primary">Schedule Pickup</a>
            </div>
            
            <div class="dashboard-card">
                <div class="card-icon">📊</div>
                <h3>Booking History</h3>
                <p>View booking records</p>
                <a href="booking-history.jsp" class="btn btn-primary">View Records</a>
            </div>
        </div>
        
        <div class="stats-grid">
            <div class="stat-card">
                <h4>Today's Pickups</h4>
                <div class="stat-number" id="todayPickups">--</div>
            </div>
            <div class="stat-card">
                <h4>Pending Deliveries</h4>
                <div class="stat-number" id="pendingDeliveries">--</div>
            </div>
            <div class="stat-card">
                <h4>Completed Today</h4>
                <div class="stat-number" id="completedToday">--</div>
            </div>
        </div>
    </div>
    
    <script src="utils.js"></script>
    <script src="main.js"></script>
</body>
</html>