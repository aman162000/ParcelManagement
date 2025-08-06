document.addEventListener("DOMContentLoaded", function() {
	initializeBookingPage();
});

function initializeBookingPage() {
	// Setup form handlers
	setupBookingForm();
	setupCostCalculation();

	// Set minimum date to today
	const preferredDateInput = document.getElementById("preferredDate");
	if (preferredDateInput) {
		preferredDateInput.min = getTodayDate();
		preferredDateInput.value = getTodayDate();
	}
}

function setupBookingForm() {
	const bookingForm = document.getElementById("bookingForm");
	if (bookingForm) {
		bookingForm.addEventListener("submit", handleBookingSubmit);
	}

	// Setup real-time validation
	setupFormValidation();
}

function setupFormValidation() {
	// Pincode validation
	const pincodeFields = ["senderPincode", "receiverPincode"];
	pincodeFields.forEach((fieldId) => {
		const field = document.getElementById(fieldId);
		if (field) {
			field.addEventListener("input", function() {
				this.value = this.value.replace(/\D/g, "");
				if (this.value.length > 6) {
					this.value = this.value.slice(0, 6);
				}
			});
		}
	});

	// Mobile number validation
	const contactFields = ["senderContact", "receiverContact"];
	contactFields.forEach((fieldId) => {
		const field = document.getElementById(fieldId);
		if (field) {
			field.addEventListener("blur", function() {
				if (this.value && !validateMobile(this.value)) {
					showError(fieldId, "Please enter a valid mobile number");
				} else {
					document.getElementById(fieldId + "Error").textContent = "";
				}
			});
		}
	});

	// Weight validation
	const weightField = document.getElementById("weight");
	if (weightField) {
		weightField.addEventListener("input", function() {
			const weight = parseFloat(this.value);
			if (weight > 50) {
				showError("weight", "Maximum weight allowed is 50 kg");
			} else if (weight <= 0) {
				showError("weight", "Weight must be greater than 0");
			} else {
				document.getElementById("weightError").textContent = "";
			}
		});
	}
}

function setupCostCalculation() {
	const costFields = [
		"weight",
		"size",
		"deliveryType",
		"insurance",
		"tracking",
		"fragile",
	];

	costFields.forEach((fieldId) => {
		const field = document.getElementById(fieldId);
		if (field) {
			field.addEventListener("change", updateCostCalculation);
			field.addEventListener("input", updateCostCalculation);
		}
	});

	// Initial calculation
	updateCostCalculation();
}

function updateCostCalculation() {
	const weight = parseFloat(document.getElementById("weight").value) || 0;
	const size = document.getElementById("size").value;
	const deliveryType = document.getElementById("deliveryType").value;

	if (weight > 0 && size && deliveryType) {
		const baseCost = calculateBaseCost(weight, size, deliveryType);

		const additionalServices = {
			insurance: document.getElementById("insurance").checked,
			tracking: document.getElementById("tracking").checked,
			fragile: document.getElementById("fragile").checked,
		};

		const additionalCost = calculateAdditionalCost(additionalServices);
		const totalCost = baseCost + additionalCost;

		document.getElementById("baseCost").textContent = formatCurrency(baseCost);
		document.getElementById("additionalCost").textContent =
			formatCurrency(additionalCost);
		document.getElementById("totalCost").textContent =
			formatCurrency(totalCost);
	} else {
		document.getElementById("baseCost").textContent = formatCurrency(0);
		document.getElementById("additionalCost").textContent = formatCurrency(0);
		document.getElementById("totalCost").textContent = formatCurrency(0);
	}
}

function handleBookingSubmit(e) {
	e.preventDefault();

	const formData = new FormData(e.target);

	// Add boolean values explicitly to FormData
	formData.set("insurance", document.querySelector('input[name="insurance"]').checked);
	formData.set("tracking", document.querySelector('input[name="tracking"]').checked);
	formData.set("fragile", document.querySelector('input[name="fragile"]').checked);

	// Validate using FormData values
	const bookingData = {
		senderName: formData.get("senderName").trim(),
		senderContact: formData.get("senderContact").trim(),
		senderAddress: formData.get("senderAddress").trim(),
		senderPincode: formData.get("senderPincode").trim(),
		receiverName: formData.get("receiverName").trim(),
		receiverContact: formData.get("receiverContact").trim(),
		receiverAddress: formData.get("receiverAddress").trim(),
		receiverPincode: formData.get("receiverPincode").trim(),
		weight: parseFloat(formData.get("weight")),
		size: formData.get("size"),
		contents: formData.get("contents").trim(),
		deliveryType: formData.get("deliveryType"),
		preferredDate: formData.get("preferredDate"),
		preferredTime: formData.get("preferredTime"),
		insurance: formData.get("insurance") === 'true',
		tracking: formData.get("tracking") === 'true',
		fragile: formData.get("fragile") === 'true',
	};

	const errors = validateBookingData(bookingData);

	if (Object.keys(errors).length > 0) {
		showErrors(errors);
		return;
	}

	// Send FormData
	fetch('BookingServlet', {
		method: 'POST',
		body: new URLSearchParams([...formData.entries()])
	})
	.then(res => res.json())
	.then(data => {
	  if (data.status === "success") {
	    alert("Booking successful!");
	    // Redirect or show payment UI
		window.location.href = "payment.jsp"
	  } else {
	    alert("Error: " + data.message);
	  }
	})
	.catch(err => {
	  console.error("Fetch error:", err);
	});
	resetForm();
}
function validateBookingData(data) {
	const errors = {};

	// Sender validation
	if (!data.senderName) errors.senderName = "Sender name is required";
	if (!data.senderContact || !validateMobile(data.senderContact)) {
		errors.senderContact = "Valid sender contact number is required";
	}
	if (!data.senderAddress) errors.senderAddress = "Sender address is required";
	if (!data.senderPincode || !validatePincode(data.senderPincode)) {
		errors.senderPincode = "Valid 6-digit pincode is required";
	}

	// Receiver validation
	if (!data.receiverName) errors.receiverName = "Receiver name is required";
	if (!data.receiverContact || !validateMobile(data.receiverContact)) {
		errors.receiverContact = "Valid receiver contact number is required";
	}
	if (!data.receiverAddress)
		errors.receiverAddress = "Receiver address is required";
	if (!data.receiverPincode || !validatePincode(data.receiverPincode)) {
		errors.receiverPincode = "Valid 6-digit pincode is required";
	}

	// Parcel validation
	if (!data.weight || data.weight <= 0 || data.weight > 50) {
		errors.weight = "Weight must be between 0.1 and 50 kg";
	}
	if (!data.size) errors.size = "Parcel size is required";
	if (!data.contents) errors.contents = "Contents description is required";

	// Shipping validation
	if (!data.deliveryType) errors.deliveryType = "Delivery type is required";
	if (!data.preferredDate)
		errors.preferredDate = "Preferred pickup date is required";
	else {
		const selectedDate = new Date(data.preferredDate);
		const today = new Date();
		today.setHours(0, 0, 0, 0);
		if (selectedDate < today) {
			errors.preferredDate = "Pickup date cannot be in the past";
		}
	}
	if (!data.preferredTime)
		errors.preferredTime = "Preferred time slot is required";

	return errors;
}

function resetForm() {
	const form = document.getElementById("bookingForm");
	if (form) {
		form.reset();
		clearErrors();
		updateCostCalculation();

		// Reset date to today
		const preferredDateInput = document.getElementById("preferredDate");
		if (preferredDateInput) {
			preferredDateInput.value = getTodayDate();
		}
	}
}

// Helper functions
function validateMobile(mobile) {
	const regex = /^[0-9]{10}$/;
	return regex.test(mobile);
}

function validatePincode(pincode) {
	return /^\d{6}$/.test(pincode);
}

function showError(fieldId, message) {
	const errorElement = document.getElementById(fieldId + "Error");
	if (errorElement) {
		errorElement.textContent = message;
	}
}

function showErrors(errors) {
	for (const field in errors) {
		showError(field, errors[field]);
	}
}

function getTodayDate() {
	const today = new Date();
	return today.toISOString().split("T")[0]; // YYYY-MM-DD
}

function generateBookingId() {
	return "BOOK" + Math.floor(Math.random() * 1000000);
}

function calculateBaseCost(weight, size, deliveryType) {
	// Placeholder cost calculation
	return weight * 10 + (size === "large" ? 20 : 10) + (deliveryType === "express" ? 30 : 10);
}

function calculateAdditionalCost(additionalServices) {
	let additionalCost = 0;
	if (additionalServices.insurance) additionalCost += 50;
	if (additionalServices.tracking) additionalCost += 20;
	if (additionalServices.fragile) additionalCost += 30;
	return additionalCost;
}

function formatCurrency(amount) {
	return `₹${amount.toFixed(2)}`;
}
