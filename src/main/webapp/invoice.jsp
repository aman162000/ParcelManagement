<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="java.util.*, com.parcel.models.Booking, com.parcel.models.User"%>
<%@ page session="true"%>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
User user = (User) session.getAttribute("user");

if (user == null || user.getRole() == null) {
	response.sendRedirect("index.jsp");
	return;
}

Booking booking = (Booking) request.getAttribute("book");
User invoice_user = (User) request.getAttribute("user");


// Define the desired date format
SimpleDateFormat sdf = new SimpleDateFormat("d MMM yyyy, hh:mm a");

// Format the timestamp
String formattedBookingDate = sdf.format(booking.getBookingDate());
String formattedPickupDate = sdf.format(booking.getParDropoffTime());
String paymentDate = sdf.format(booking.getParPaymentTime());

double baseRate = 50;
double weightChargePerGram = 0.02;
double taxRate = 0.05;

// Delivery charges map
java.util.Map<String, Double> deliveryCharges = new java.util.HashMap<>();
deliveryCharges.put("standard", 30.0);
deliveryCharges.put("express", 80.0);
deliveryCharges.put("overnight", 150.0);

// Packing charges map
java.util.Map<String, Double> packingCharges = new java.util.HashMap<>();
packingCharges.put("basic", 10.0);
packingCharges.put("fragile", 30.0);
packingCharges.put("waterproof", 30.0);
packingCharges.put("perishable", 30.0);

// Calculate individual components
double weightCharge = booking.getParWeightGram() * weightChargePerGram;

String deliveryType = booking.getParDeliveryType().toLowerCase();
double deliveryCharge = deliveryCharges.containsKey(deliveryType) ? deliveryCharges.get(deliveryType) : 0;

String packingPref = booking.getParPackingPreference().toLowerCase();
double packingCharge = packingCharges.containsKey(packingPref) ? packingCharges.get(packingPref) : 0;

double subTotal = baseRate + weightCharge + deliveryCharge + packingCharge;
double tax = subTotal * taxRate;
double total = subTotal + tax;
 

%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Invoice - PMS</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <%@include file="nav.jsp" %>
    
    <div class="container">
        <div class="invoice-container">
            <div class="invoice-header">
                <div class="company-info">
                    <h1>📦 PMS</h1>
                    <p>Parcel Management Systems Pvt. Ltd.</p>
                    <p>123 Business District, Bengaluru, Karnataka 560066</p>
                    <p>Phone: +91 1800-123-4567 | Email: support@pms.com</p>
                </div>
                <div class="invoice-title">
                    <h2>INVOICE</h2>
                    <p id="invoiceNumber">Invoice #: INV-<%= booking.getBookingId() %></p>
                    <p id="invoiceDate">Date: <%=booking.getBookingDate() %></p>
                </div>
            </div>
            
            <div class="invoice-details">
                <div class="billing-info">
                    <div class="bill-to">
                        <h3>Bill To:</h3>
                        <div id="customerInfo">
                <p><strong><%= invoice_user.getCustomerName() %></strong></p>
                <p><%= invoice_user.getEmail() %></p>
                <p>+91 <%= invoice_user.getMobileNumber() %></p>
                <p><%= invoice_user.getAddress() %></p>
                <p>Customer ID: <%= invoice_user.getCustomerId() %></p>
            </div>
                    </div>
                    
                    <div class="booking-info">
                        <h3>Booking Details:</h3>
                        <div id="bookingInfo">
                <p><strong>Booking ID:</strong> <%= booking.getBookingId() %></p>
                <p><strong>Booking Date:</strong> <%= formattedBookingDate %></p>
                <p><strong>Delivery Type:</strong> <%= booking.getParPackingPreference() %></p>
                <p><strong>Preferred Pickup:</strong> <%= formattedPickupDate %></p>
            </div>
                    </div>
                </div>
                
                <div class="service-details">
                    <h3>Service Details:</h3>
                    <div class="table-container">
                        <table class="table invoice-table">
                            <thead>
                                <tr>
                                    <th>Description</th>
                                    <th>Quantity</th>
                                    <th>Rate</th>
                                    <th>Amount</th>
                                </tr>
                            </thead>
                            <tbody id="serviceItems">
                <tr>
                    <td><%=deliveryType  %> Delivery (<%= booking.getParWeightGram()/1000 %>kg, <%=booking.getSize() %>)</td>
                    <td>1</td>
                    <td>₹<%= deliveryCharge %></td>
                    <td>₹<%=deliveryCharge %></td>
                </tr>
            
               
            
                <tr>
                    <td><%=packingPref %> Handling</td>
                    <td>1</td>
                    <td>₹<%=packingCharge %></td>
                    <td>₹<%=packingCharge %></td>
                </tr>
            </tbody>
                        </table>
                    </div>
                </div>
                
                <div class="invoice-summary">
                    <div class="summary-table">
                        <div class="summary-row">
                            <span>Subtotal:</span>
                            <span id="subtotal">₹<%=subTotal %></span>
                        </div>
                        <div class="summary-row">
                            <span>Tax:</span>
                            <span id="additionalServices">₹<%=tax %></span>
                        </div>
                        <div class="summary-row total">
                            <span>Total Amount:</span>
                            <span id="totalAmount">₹<%=total %></span>
                        </div>
                        <div class="summary-row">
                            <span>Payment Status:</span>
                            <span id="paymentStatus" class="payment-status paid">PAID</span>
                        </div>
                        <div class="summary-row">
                            <span>Payment Date:</span>
                            <span id="paymentDate"><%=paymentDate %></span>
                        </div>
                    </div>
                </div>
                
                <div class="delivery-details">
                    <h3>Delivery Information:</h3>
                    <div id="deliveryInfo">
                <div class="delivery-addresses">
                    <div class="pickup-address">
                        <h4>Pickup Address:</h4>
                        <p><strong><%= invoice_user.getCustomerName() %></strong></p>
                        <p>+91 <%= invoice_user.getMobileNumber() %></p>
                        <p><%=booking.getCustomerAddress() %></p>
                    </div>
                    
                    <div class="delivery-address">
                         <h4>Delivery Address:</h4>
                        <p><strong><%= booking.getRecName() %></strong></p>
                        <p>+91 <%=booking.getRecMobile() %></p>
                        <p><%=booking.getRecAddress() %></p>
                        <p>Pin Code: <%= booking.getRecPin() %></p>
                    </div>
                </div>
                
                <div class="package-details">
                    <h4>Package Details:</h4>
                    <p><strong>Weight:</strong> <%= booking.getParWeightGram()/1000 %> kg</p>
                    <p><strong>Size:</strong> <%=booking.getSize() %></p>
                    <p><strong>Contents:</strong> <%= booking.getParContentsDescription() %></p>
                </div>
            </div>
                </div>
            </div>
            
            <div class="invoice-footer">
                <div class="terms">
                    <h4>Terms &amp; Conditions:</h4>
                    <ul>
                        <li>All parcels are subject to our standard terms and conditions.</li>
                        <li>Insurance claims must be reported within 24 hours of delivery.</li>
                        <li>Delivery times are estimates and may vary due to unforeseen circumstances.</li>
                        <li>Customer is responsible for providing accurate delivery information.</li>
                    </ul>
                </div>
                
                <div class="contact-info">
                    <p><strong>For any queries, contact us:</strong></p>
                    <p>Phone: +91 1800-123-4567 | Email: support@pms.com</p>
                </div>
            </div>
            
            <div class="invoice-actions">
                <button onclick="printInvoice()" class="btn btn-primary">🖨️ Print Invoice</button>
                <button onclick="goToHome()" class="btn btn-secondary">🏠 Back to Home</button>
            </div>
        </div>
    </div>
    
    <script src="utils.js"></script>
    <script>
       
       
        
        function printInvoice() {
            const navbar = document.querySelector('.navbar');
            const actions = document.querySelector('.invoice-actions');
            
            navbar.style.display = 'none';
            actions.style.display = 'none';
            
            window.print();
            
            // Restore elements after printing
            navbar.style.display = 'flex';
            actions.style.display = 'block';
        }
        
        function goToHome() {
            if (user && user.role === 'customer') {
                window.location.href = 'customer-home.jsp';
            } else {
                window.location.href = 'officer-home.jsp';
            }
        }
    </script>
</body>
</html>