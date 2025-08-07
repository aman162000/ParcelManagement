<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession, com.parcel.models.User"%>
<%@include file="successModal.jsp"%>
<%
User user = (User) session.getAttribute("user");

if (user == null) {
	response.sendRedirect("index.jsp");
	return;
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Booking Service - PMS</title>
<link rel="stylesheet" href="css/style.css">
</head>
<body>

	<%@include file="nav.jsp"%>

	<div class="container">
		<div class="booking-container">
			<h2>📋 Booking Service</h2>

			<form id="bookingForm" class="form" onsubmit="">
				<!-- Sender Information -->
				<div class="form-section">
					<h3>👤 Sender Information</h3>
					<div class="form-row">
						<div class="form-group">
							<label for="senderName">Name:</label> <input type="text"
								id="senderName" name="senderName" required /> <span
								class="error-message" id="senderNameError"></span>
						</div>
						<div class="form-group">
							<label for="senderContact">Contact Number:</label> <input
								type="tel" id="senderContact" name="senderContact" required />
							<span class="error-message" id="senderContactError"></span>
						</div>
					</div>
					<div class="form-group">
						<label for="senderAddress">Address:</label>
						<textarea id="senderAddress" name="senderAddress" required
							rows="2"></textarea>
						<span class="error-message" id="senderAddressError"></span>
					</div>
					<div class="form-group">
						<label for="senderPincode">Pin Code:</label> <input type="text"
							id="senderPincode" name="senderPincode" required
							pattern="[0-9]{6}" /> <span class="error-message"
							id="senderPincodeError"></span>
					</div>
				</div>

				<!-- Receiver Information -->
				<div class="form-section">
					<h3>👥 Receiver Information</h3>
					<div class="form-row">
						<div class="form-group">
							<label for="receiverName">Name:</label> <input type="text"
								id="receiverName" name="receiverName" required /> <span
								class="error-message" id="receiverNameError"></span>
						</div>
						<div class="form-group">
							<label for="receiverContact">Contact Number:</label> <input
								type="tel" id="receiverContact" name="receiverContact" required />
							<span class="error-message" id="receiverContactError"></span>
						</div>
					</div>
					<div class="form-group">
						<label for="receiverAddress">Address:</label>
						<textarea id="receiverAddress" name="receiverAddress" required
							rows="2"></textarea>
						<span class="error-message" id="receiverAddressError"></span>
					</div>
					<div class="form-group">
						<label for="receiverPincode">Pin Code:</label> <input type="text"
							id="receiverPincode" name="receiverPincode" required
							pattern="[0-9]{6}" /> <span class="error-message"
							id="receiverPincodeError"></span>
					</div>
				</div>

				<!-- Parcel Information -->
				<div class="form-section">
					<h3>📦 Parcel Information</h3>
					<div class="form-row">
						<div class="form-group">
							<label for="weight">Weight (grams):</label> <input type="number"
								id="weight" name="weight" required min="1" max="50000" step="1"
								placeholder="Enter weight in grams" /> <span
								class="error-message" id="weightError"></span>
						</div>
						<div class="form-group">
							<label for="size">Size:</label> <select id="size" name="size"
								required>
								<option value="">Select Size</option>
								<option value="small">Small (up to 30cm)</option>
								<option value="medium">Medium (30-60cm)</option>
								<option value="large">Large (60-100cm)</option>
								<option value="xlarge">Extra Large (100cm+)</option>
							</select> <span class="error-message" id="sizeError"></span>
						</div>
					</div>
					<div class="form-group">
						<label for="contents">Contents Description:</label>
						<textarea id="contents" name="contents" required rows="2"
							placeholder="Describe parcel contents"></textarea>
						<span class="error-message" id="contentsError"></span>
					</div>
				</div>

				<!-- Shipping Options -->
				<div class="form-section">
					<h3>🚚 Shipping Options</h3>
					<div class="form-row">
						<div class="form-group">
							<label for="deliveryType">Delivery Type:</label> <select
								id="deliveryType" name="deliveryType" required>
								<option value="">Select Type</option>
								<option value="standard">Standard (3 days) - ₹30</option>
								<option value="express">Express (2 days) - ₹80</option>
								<option value="overnight">Overnight (8 hours) - ₹150</option>
							</select> <span class="error-message" id="deliveryTypeError"></span>
						</div>
						<div class="form-group">
							<label for="preferredDate">Preferred Pickup Date:</label> <input
								type="date" id="preferredDate" name="preferredDate" required />
							<span class="error-message" id="preferredDateError"></span>
						</div>
					</div>

					<!-- PickUp Time -->
					<div class="form-row">
						<div class="form-group">
							<label for="manualTime">PickUp Time:</label> <input type="time"
								id="manualTime" name="manualTime" placeholder="HH:MM" /> <span
								class="error-message" id="manualTimeError"></span>
						</div>
					</div>

					<!-- Packing Preference -->
					<div class="form-group">
						<label for="packingPreference">Packing Preference:</label> <select
							id="packingPreference" name="packingPreference" required>
							<option value="">Select Packing Type</option>
							<option value="basic">Basic Packaging - ₹10</option>
							<option value="fragile">Fragile Packaging - ₹30</option>
							<option value="waterproof">Waterproof Packaging - ₹30</option>
							<option value="perishable">Perishable Goods Packaging -
								₹30</option>
						</select> <span class="error-message" id="packingPreferenceError"></span>
					</div>

					<!-- Drop Off Time (Auto-calculated) -->
					<div class="form-group">
						<label for="dropOffTime">Estimated Drop-off Date & Time:</label> <input
							type="text" id="dropOffTime" name="dropOffTime" readonly
							placeholder="Will be calculated automatically"
							style="background-color: #f8f9fa" />
					</div>
				</div>

				<!-- Cost Summary -->
				<div class="form-section">
					<h3>💰 Cost Summary</h3>
					<div class="cost-breakdown">
						<div class="cost-item">
							<span>Base Service Cost:</span> <span id="serviceCost">₹50.00</span>
						</div>
						<div class="cost-item">
							<span>Additional Services:</span> <span id="additionalCost">₹0.00</span>
						</div>
						<div class="cost-item-details"
							style="font-size: 0.9em; color: #666; margin: 5px 0">
							<div>
								• Weight Charge: <span id="weightCharge">₹0.00</span>
							</div>
							<div>
								• Delivery Charge: <span id="deliveryCharge">₹0.00</span>
							</div>
							<div>
								• Packing Charge: <span id="packingCharge">₹0.00</span>
							</div>
						</div>
						<div class="cost-item subtotal"
							style="border-top: 1px solid #ddd; padding-top: 8px">
							<span>Subtotal:</span> <span id="subtotal">₹ 50.00</span>
						</div>
						<div class="cost-item tax" style="font-size: 0.9em; color: #666">
							<span>Tax (5%):</span> <span id="taxAmount">₹ 2.50</span>
						</div>
						<div class="cost-item total"
							style="border-top: 2px solid #28a745; padding-top: 10px; font-weight: bold; font-size: 1.1em; color: #28a745;">
							<span>Total Amount:</span> <span id="totalCost">₹ 52.50</span>
						</div>
					</div>
					<div
						style="margin-top: 10px; padding: 10px; background-color: #e7f3ff; border-left: 4px solid #007bff; border-radius: 4px;">
						<small style="color: #004085"> <strong>Note:</strong>
							Final amount includes all charges and 5% GST. Weight is
							calculated at ₹0.02 per gram.
						</small>
					</div>
				</div>

				<div class="button-group">
					<button type="submit" class="btn btn-primary" id="submitBtn">
						<span>📦 Book Parcel</span>
					</button>
					<button type="button" class="btn btn-secondary" id="resetButton">
						<span>🔄 Reset Form</span>
					</button>
					<button type="button" class="btn btn-secondary" onclick="goBack()">
						<span>🏠 Back to Home</span>
					</button>
				</div>
			</form>
		</div>
	</div>


	<script src="js/utils.js"></script>
	<script src="js/booking.js"></script>

	<script>
      const style = document.createElement("style");
      style.textContent = `
            @keyframes pulse {
                0% { transform: scale(1); }
                50% { transform: scale(1.05); }
                100% { transform: scale(1); }
            }
            
            .cost-breakdown {
                background: #f8f9fa;
                border-radius: 8px;
                padding: 15px;
                border: 1px solid #e9ecef;
            }
            
            .cost-item {
                display: flex;
                justify-content: space-between;
                margin: 8px 0;
                padding: 4px 0;
            }
            
            .cost-item.total {
                font-size: 1.2em;
                font-weight: bold;
            }
            
            .form-group small {
                display: block;
                margin-top: 4px;
            }
            
            .button-group {
                display: flex;
                gap: 10px;
                justify-content: center;
                margin-top: 20px;
                flex-wrap: wrap;
            }
            
            .btn {
                padding: 12px 24px;
                border: none;
                border-radius: 6px;
                cursor: pointer;
                font-size: 16px;
                transition: all 0.3s ease;
                min-width: 140px;
            }
            
            .btn-primary {
                background: #007bff;
                color: white;
            }
            
            .btn-primary:hover {
                background: #0056b3;
                transform: translateY(-2px);
            }
            
            .btn-secondary {
                background: #6c757d;
                color: white;
            }
            
            .btn-secondary:hover {
                background: #5a6268;
                transform: translateY(-2px);
            }
        `;
      document.head.appendChild(style);

	</script>
</body>
</html>