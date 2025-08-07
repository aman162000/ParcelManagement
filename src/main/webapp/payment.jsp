<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="java.util.*, com.parcel.models.Booking, com.parcel.models.User"%>
<%@ page session="true"%>
<%@ include file="successModal.jsp"%>
<%
User user = (User) session.getAttribute("user");

if (user == null || user.getRole() == null) {
	response.sendRedirect("index.jsp");
	return;
}

Booking booking = (Booking) request.getAttribute("booking");
Boolean isSuccessObj = (Boolean) request.getAttribute("isSuccess");
boolean isSuccess = Boolean.TRUE.equals(isSuccessObj);
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Payment - PMS</title>
<link rel="stylesheet" href="css/style.css">

</head>
<body>
	<%@include file="nav.jsp"%>

	<div class="container">
		<div class="payment-container">
			<h2>💳 Payment</h2>

			<div class="bill-summary">
				<h3>Bill Summary</h3>
				<div class="bill-details">
					<div class="bill-item">
						<span>Booking ID:</span> <span id="bookingId"><%=booking.getBookingId()%></span>
					</div>
					<div class="bill-item">
						<span>Service Type:</span> <span id="serviceType"><%=booking.getParDeliveryType()%></span>
					</div>

					<div class="bill-item total">
						<span>Total Bill Amount:</span> <span id="totalBillAmount">₹<%=booking.getParServiceCost()%></span>
					</div>
				</div>
			</div>

			<div class="payment-form">
				<h3>Payment Method</h3>
				<form id="paymentForm" method="post" action="PaymentServlet" onsubmit="return handleSubmit">
				
					<div class="form-group">
						<label>Mode of Payment:</label>
						<div class="radio-group">
							<label class="radio-label"> <input type="radio"
								name="paymentMode" value="credit" required> Credit Card
							</label> <label class="radio-label"> <input type="radio"
								name="paymentMode" value="debit" required> Debit Card
							</label>
						</div>
					</div>
					
					<div id="cardDetails" class="card-details hidden">
						<h4>Card Details</h4>
						<div class="form-group">
							<label for="cardNumber">Card Number:</label> <input type="text"
								id="cardNumber" name="cardNumber" maxlength="19"
								placeholder="1234 5678 9012 3456"> <span
								class="error-message" id="cardNumberError"></span>
						</div>
						<input type="hidden" name="bookingId" value="<%= booking.getBookingId() %>"/>

						<div class="form-group">
							<label for="cardHolder">Card Holder Name:</label> <input
								type="text" id="cardHolder" name="cardHolder"
								placeholder="Name as on card"> <span
								class="error-message" id="cardHolderError"></span>
						</div>

						<div class="form-row">
							<div class="form-group">
								<label for="expiryDate">Expiry Date (MM/YY):</label> <input
									type="text" id="expiryDate" name="expiryDate"
									pattern="[0-9]{2}/[0-9]{2}" maxlength="5" placeholder="MM/YY">
								<span class="error-message" id="expiryDateError"></span>
							</div>

							<div class="form-group">
								<label for="cvv">CVV:</label> <input type="password" id="cvv"
									name="cvv" pattern="[0-9]{3}" maxlength="3" placeholder="123">
								<span class="error-message" id="cvvError"></span>
							</div>
						</div>
					</div>

					<div class="button-group">
						<button type="submit" class="btn btn-primary" id="payNowBtn"
							disabled>💳 Pay Now</button>
						<button type="button" class="btn btn-secondary"
							onclick="backToBooking()">← Back to Booking</button>
					</div>
				</form>
			</div>
		</div>
	</div>

	<!-- Payment Success Modal -->
	<div id="paymentSuccessModal"
		class="modal <%=isSuccess ? "" : "hidden"%>">
		<div class="modal-content">
			<h2 class="success-title">Payment Successful! ✅</h2>
			<div class="success-details">
				<p>
					<strong>Booking ID:</strong> <span id="successBookingId"><%=booking.getBookingId() %></span>
				</p>
				<p>
					<strong>Amount Paid:</strong> <span id="successAmount"><%= booking.getParServiceCost() %> </span>
				</p>
			
				<p class="success-message">Your parcel will be picked up as
					scheduled.</p>
			</div>
			<div class="button-group">
				<button onclick="viewInvoice()" class="btn btn-primary">View
					Invoice</button>
				<button onclick="goToHome()" class="btn btn-secondary">Go
					to Home</button>
			</div>
		</div>
	</div>

	<script src="js/utils.js"></script>
	<script>
        // Initialize payment page
        document.addEventListener('DOMContentLoaded', function() {
            
            setupPaymentForm();
        });
        function setupPaymentForm() {
            const paymentModes = document.querySelectorAll('input[name="paymentMode"]');
            const cardDetails = document.getElementById('cardDetails');
            const payNowBtn = document.getElementById('payNowBtn');

            console.log(paymentModes)
            
            
            paymentModes.forEach(mode => {
                mode.addEventListener('change', function() {
                    if (this.checked) {
                        cardDetails.classList.remove('hidden');
                        payNowBtn.disabled = false;
                    }
                });
            });

            // Format card number input
            const cardNumberInput = document.getElementById('cardNumber');
            cardNumberInput.addEventListener('input', function() {
                let value = this.value.replace(/\s/g, '').replace(/[^0-9]/gi, '');
                let formattedValue = value.match(/.{1,4}/g)?.join(' ') || value;
                this.value = formattedValue;
            });

            // Format expiry date input
            const expiryInput = document.getElementById('expiryDate');
            expiryInput.addEventListener('input', function() {
                let value = this.value.replace(/\D/g, '');
                if (value.length >= 2) {
                    value = value.substring(0, 2) + '/' + value.substring(2, 4);
                }
                this.value = value;
            });

            // Payment form submission
            
            const handleSubmit = (e)=>{
            	 if (validatePaymentForm()) {
                 	return true    
                 }else false;
}
            
        }

        function validatePaymentForm() {
            let isValid = true;
            const errors = {};

            const cardNumber = document.getElementById('cardNumber').value.replace(/\s/g, '');
            if (!/^[0-9]{16}$/.test(cardNumber)) {
                errors.cardNumber = 'Please enter a valid 16-digit card number';
                isValid = false;
            }

            const cardHolder = document.getElementById('cardHolder').value.trim();
            if (!cardHolder) {
                errors.cardHolder = 'Card holder name is required';
                isValid = false;
            }

            const expiryDate = document.getElementById('expiryDate').value;
            if (!/^[0-9]{2}\/[0-9]{2}$/.test(expiryDate)) {
                errors.expiryDate = 'Please enter a valid expiry date (MM/YY)';
                isValid = false;
            } else {
                const [month, year] = expiryDate.split('/');
                const currentDate = new Date();
                const currentYear = currentDate.getFullYear() % 100;
                const currentMonth = currentDate.getMonth() + 1;
                
                if (parseInt(month) < 1 || parseInt(month) > 12) {
                    errors.expiryDate = 'Invalid month';
                    isValid = false;
                } else if (parseInt(year) < currentYear || 
                          (parseInt(year) === currentYear && parseInt(month) < currentMonth)) {
                    errors.expiryDate = 'Card has expired';
                    isValid = false;
                }
            }

            const cvv = document.getElementById('cvv').value;
            if (!/^[0-9]{3}$/.test(cvv)) {
                errors.cvv = 'Please enter a valid 3-digit CVV';
                isValid = false;
            }

            // Display errors
            Object.keys(errors).forEach(field => {
                const errorElement = document.getElementById(field + 'Error');
                if (errorElement) {
                    errorElement.textContent = errors[field];
                }
            });

            // Clear previous errors
            if (isValid) {
                document.querySelectorAll('.error-message').forEach(el => el.textContent = '');
            }

            return isValid;
        }
      

        
        function viewInvoice() {
        	window.location.href = "InvoiceServlet?=" + "<%= booking.getBookingId() %>";
        }

        function goToHome() {
            window.location.href = 'customer-home.jsp';
        }

        function backToBooking() {
            window.location.href = 'booking.jsp';
        }
    </script>
</body>
</html>