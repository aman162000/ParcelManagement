<%
String currentURL = request.getRequestURI(); // Gets the current request URL
%>
<nav class="navbar">
	<div class="nav-brand">
		<h1>PMS</h1>
	</div>
	<div class="nav-welcome">
		<span id="welcomeMessage">Welcome, <%=user.getCustomerName()%>
		</span>
	</div>
	<%
	if (user.getRole().equalsIgnoreCase("customer")) {
	%>
	<ul class="nav-menu">
		<li><a href="customer-home.jsp" class="<%= currentURL.contains("customer-home.jsp") ? "active" : "" %>">Home</a></li>
		<li><a href="booking.jsp" class="<%= currentURL.contains("booking.jsp") ? "active" : "" %>">Booking Service</a></li>
		<li><a href="tracking.jsp" class="<%= currentURL.contains("tracking.jsp") ? "active" : "" %>">Tracking</a></li>
		<li><a href="booking-history.jsp" class="<%= currentURL.contains("booking-history.jsp") ? "active" : "" %>">Previous Booking</a></li>
		<li><a href="customer-support.jsp" class="<%= currentURL.contains("customer-support.jsp") ? "active" : "" %>">Contact Support</a></li>
		<li><a href="LogoutServlet">Logout</a></li>
	</ul>
	<%
	} else {
	%>
	<ul class="nav-menu">
		<li><a href="officer-home.jsp" class="<%= currentURL.contains("officer-home.jsp") ? "active" : "" %>">Home</a></li>
		<li><a href="tracking.jsp" class="<%= currentURL.contains("tracking.jsp") ? "active" : "" %>">Tracking</a></li>
		<li><a href="UpdateDeliveryStatusServlet?action=view" class="<%= currentURL.contains("UpdateDeliveryStatusServlet?action=view") ? "active" : "" %>">Delivery Status</a></li>
		<li><a href="SchedulingServlet?action=view" class="<%= currentURL.contains("SchedulingServlet?action=view") ? "active" : "" %>">Pickup Scheduling</a></li>
		<li><a href="booking-history.jsp" class="<%= currentURL.contains("booking-history.jsp") ? "active" : "" %>">Previous Booking</a></li>
		<li><a href="LogoutServlet">Logout</a></li>
	</ul>
	<%
	}
	%>

</nav>