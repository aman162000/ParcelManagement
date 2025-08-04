<%@ page import="java.util.*,java.text.*" %>
<%@ page import="java.sql.*, com.parcel.services.BookingService, com.parcel.models.Booking" %>
<%
    // Get the booking ID from the URL parameter
    String bookingId = request.getParameter("bookingId");
	BookingService bookingService = new BookingService();
    // Fetch booking details from the database (You can implement the logic in your BookingService class)
    // Assuming BookingService has a method to fetch booking by ID
    Booking booking = bookingService.getBookingById(bookingId);

    double amount = booking.getParServiceCost(); // The amount you want to charge, for example, booking cost

    // Razorpay API Key (use your actual API Key here)
    String apiKey = "YOUR_RAZORPAY_API_KEY";
    String secretKey = "YOUR_RAZORPAY_SECRET_KEY";

    // Prepare Razorpay order creation payload
    String razorpayOrderId = createRazorpayOrder(amount, apiKey, secretKey);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment - Razorpay</title>
    <script src="https://checkout.razorpay.com/v1/checkout.js"></script>
</head>
<body>
    <h1>Complete Your Payment</h1>

    <form name="razorpay-payment-form" action="paymentSuccessServlet" method="POST">
        <script>
            var options = {
                "key": "<%= apiKey %>", // Your Razorpay API Key
                "amount": "<%= (int)(amount * 100) %>", // Amount in paise (100 paise = 1 INR)
                "currency": "INR",
                "order_id": "<%= razorpayOrderId %>", // Order ID created by Razorpay
                "name": "Booking Service",
                "description": "Payment for Booking ID: <%= bookingId %>",
                "image": "https://example.com/your-logo.png",
                "handler": function (response) {
                    // On success, send payment details to the server for verification and updating booking status
                    var bookingId = "<%= bookingId %>";
                    var paymentId = response.razorpay_payment_id;
                    var orderId = response.razorpay_order_id;
                    var signature = response.razorpay_signature;
                    
                    // Send payment details to your server for verification and update the booking status
                    fetch('paymentSuccessServlet', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json'
                        },
                        body: JSON.stringify({
                            bookingId: bookingId,
                            paymentId: paymentId,
                            orderId: orderId,
                            signature: signature
                        })
                    }).then(response => {
                        if (response.ok) {
                            window.location.href = "paymentSuccess.jsp?bookingId=" + bookingId;
                        } else {
                            alert("Payment failed. Please try again.");
                        }
                    });
                },
                "theme": {
                    "color": "#F37254"
                }
            };

            var rzp1 = new Razorpay(options);
            rzp1.open();
        </script>
    </form>
</body>
</html>

