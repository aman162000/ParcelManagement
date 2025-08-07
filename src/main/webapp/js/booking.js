//Streamlined Booking functionality for PMS - Combined and Optimized

document.addEventListener('DOMContentLoaded', function() {
	initializeBookingPage();
});

// Pricing configuration
const PRICING_CONFIG = {
	baseRate: 50,
	weightChargePerGram: 0.02,
	deliveryCharges: {
		'standard': 30,
		'express': 80,
		'overnight': 150
	},
	packingCharges: {
		'basic': 10,
		'fragile': 30,
		'waterproof': 30,
		'perishable': 30
	},
	taxRate: 0.05 // 5%
};

function initializeBookingPage() {
	// Check authentication if function exists

	// Setup all functionality
	setupEventListeners();
	initializeDateAndCost();
}


function setupEventListeners() {
	// Form submission
	const bookingForm = document.getElementById('bookingForm');
	bookingForm?.addEventListener('submit', handleBookingSubmit);

	// Reset button
	document.getElementById('resetButton')?.addEventListener('click', resetForm);

	// Cost calculation fields - using both old and new field sets
	const costFields = ['weight', 'size', 'deliveryType', 'packingPreference', 'insurance', 'tracking', 'fragile'];
	costFields.forEach(fieldId => {
		const field = document.getElementById(fieldId);
		if (field) {
			field.addEventListener('change', updateCostCalculation);
			field.addEventListener('input', updateCostCalculation);
		}
	});

	// Drop-off time calculation (for new form structure)
	['deliveryType', 'preferredDate', 'manualTime'].forEach(fieldId => {
		const field = document.getElementById(fieldId);
		field?.addEventListener('change', calculateDropOffTime);
	});

	// Form validation
	setupFormValidation();
}

function setupFormValidation() {
	// Pincode validation
	['senderPincode', 'receiverPincode'].forEach(fieldId => {
		const field = document.getElementById(fieldId);
		field?.addEventListener('input', function() {
			this.value = this.value.replace(/\D/g, '').slice(0, 6);
		});
	});

	// Mobile validation with enhanced rules
	['senderContact', 'receiverContact'].forEach(fieldId => {
		const field = document.getElementById(fieldId);
		if (!field) return;

		field.addEventListener('blur', function() {
			if (this.value && !validateMobile(this.value)) {
				showError(fieldId, getMobileErrorMessage(this.value));
			} else {
				clearError(fieldId);
			}
		});
	});

	// Weight validation - support both kg and grams
	const weightField = document.getElementById('weight');
	weightField?.addEventListener('input', function() {
		const weight = parseFloat(this.value);
		const isGrams = this.placeholder?.includes('grams') || this.max == '50000';

		if (isGrams) {
			if (weight > 50000) {
				showError('weight', 'Maximum weight allowed is 50,000 grams (50 kg)');
			} else if (weight <= 0 && this.value) {
				showError('weight', 'Weight must be greater than 0 grams');
			} else {
				clearError('weight');
			}
		} else {
			if (weight > 50) {
				showError('weight', 'Maximum weight allowed is 50 kg');
			} else if (weight <= 0 && this.value) {
				showError('weight', 'Weight must be greater than 0 kg');
			} else {
				clearError('weight');
			}
		}
	});
}

function validateMobile(mobile) {
	const cleanMobile = mobile.replace(/\D/g, '');
	const invalidNumbers = ['1234567890', '9876543210'];

	return cleanMobile.length === 10 &&
		['6', '7', '8', '9'].includes(cleanMobile[0]) &&
		!invalidNumbers.includes(cleanMobile);
}

function getMobileErrorMessage(mobile) {
	const cleanNumber = mobile.replace(/\D/g, '');

	if (cleanNumber.length !== 10) {
		return 'Mobile number must be exactly 10 digits';
	}
	if (!['6', '7', '8', '9'].includes(cleanNumber[0])) {
		return 'Mobile number must start with 6, 7, 8, or 9';
	}
	if (['1234567890', '9876543210'].includes(cleanNumber)) {
		return 'This number is invalid. Please enter a valid mobile number';
	}
	return 'Please enter a valid mobile number';
}

function validatePincode(pincode) {
	return /^\d{6}$/.test(pincode);
}

function initializeDateAndCost() {
	// Set minimum date to today
	const preferredDateInput = document.getElementById('preferredDate');
	if (preferredDateInput) {
		const today = getTodayDate();
		preferredDateInput.min = today;
		preferredDateInput.value = today;
	}

	// Initial cost calculation
	updateCostCalculation();
}

function updateCostCalculation() {
	const weight = parseFloat(document.getElementById('weight')?.value) || 0;
	const size = document.getElementById('size')?.value;
	const deliveryType = document.getElementById('deliveryType')?.value;
	const packingPreference = document.getElementById('packingPreference')?.value;

	// Check if using new pricing structure (with packing preferences)
	const isNewStructure = !!document.getElementById('packingPreference');


	updateNewCostCalculation(weight, deliveryType, packingPreference);

}

function updateNewCostCalculation(weight, deliveryType, packingPreference) {
	if (weight > 0 && deliveryType && packingPreference) {
		// New pricing structure
		const baseRate = PRICING_CONFIG.baseRate;
		const weightCharge = weight * PRICING_CONFIG.weightChargePerGram;
		const deliveryCharge = PRICING_CONFIG.deliveryCharges[deliveryType] || 0;
		const packingCharge = PRICING_CONFIG.packingCharges[packingPreference] || 0;

		const additionalServices = weightCharge + deliveryCharge + packingCharge;
		const subtotal = baseRate + additionalServices;
		const taxAmount = subtotal * PRICING_CONFIG.taxRate;
		const totalAmount = subtotal + taxAmount;

		console.log(totalAmount)
		// Update display with new structure
		updateElement('serviceCost', baseRate);
		updateElement('additionalCost', additionalServices);
		updateElement('weightCharge', weightCharge);
		updateElement('deliveryCharge', deliveryCharge);
		updateElement('packingCharge', packingCharge);
		updateElement('subtotal', subtotal);
		updateElement('taxAmount', taxAmount);
		updateElement('totalCost', totalAmount);
	} else {
		// Reset to defaults
		updateElement('serviceCost', PRICING_CONFIG.baseRate);
		updateElement('additionalCost', 0);
		updateElement('totalCost', PRICING_CONFIG.baseRate);
	}
}
function calculateDropOffTime() {
	const deliveryType = document.getElementById('deliveryType')?.value;
	const pickupDate = document.getElementById('preferredDate')?.value;
	const manualTime = document.getElementById('manualTime')?.value;
	const dropOffField = document.getElementById('dropOffTime');

	if (!deliveryType || !pickupDate || !dropOffField) return;

	let pickup = new Date(pickupDate);
	if (manualTime) {
		const [hours, minutes] = manualTime.split(':');
		pickup.setHours(parseInt(hours), parseInt(minutes), 0, 0);
	} else {
		// Default pickup time if manual time is not provided (optional)
		pickup.setHours(9, 0, 0, 0); // default 9:00 AM
	}

	let dropOff = new Date(pickup); // clone the pickup time

	switch (deliveryType) {
		case 'standard':
			dropOff.setDate(dropOff.getDate() + 3);
			break;

		case 'express':
			dropOff.setDate(dropOff.getDate() + 2);
			break;

		case 'overnight':
			if (!manualTime) {
				dropOffField.value = 'Please select pickup time first';
				return;
			}
			dropOff.setHours(dropOff.getHours() + 8);
			break;
	}

	// Format output as: YYYY-MM-DD HH:MM
	const year = dropOff.getFullYear();
	const month = String(dropOff.getMonth() + 1).padStart(2, '0');
	const day = String(dropOff.getDate()).padStart(2, '0');
	const hours = String(dropOff.getHours()).padStart(2, '0');
	const minutes = String(dropOff.getMinutes()).padStart(2, '0');

	const formatted = `${year}-${month}-${day} ${hours}:${minutes}`;
	dropOffField.value = formatted;
}

function handleBookingSubmit(e) {
	e.preventDefault();

	const formData = new FormData(e.target);

	// Handle checkboxes properly
	['insurance', 'tracking', 'fragile'].forEach(fieldName => {
		const checkbox = document.querySelector(`input[name="${fieldName}"]`);
		if (checkbox) {
			formData.set(fieldName, checkbox.checked);
		}
	});

	// Collect booking data
	const bookingData = collectBookingData(formData);

	console.log(bookingData);
	// Validate booking data
	const errors = validateBookingData(bookingData);
	if (Object.keys(errors).length > 0) {
		showErrors(errors);
		return;
	}

	// Check if servlet submission is needed
	formData.append("cost", bookingData.cost)
	submitToServlet(formData);

}

function collectBookingData(formData) {
	return {
		senderName: formData.get('senderName')?.trim(),
		senderContact: formData.get('senderContact')?.trim(),
		senderAddress: formData.get('senderAddress')?.trim(),
		senderPincode: formData.get('senderPincode')?.trim(),
		receiverName: formData.get('receiverName')?.trim(),
		receiverContact: formData.get('receiverContact')?.trim(),
		receiverAddress: formData.get('receiverAddress')?.trim(),
		receiverPincode: formData.get('receiverPincode')?.trim(),
		weight: parseFloat(formData.get('weight')),
		size: formData.get('size'),
		contents: formData.get('contents')?.trim(),
		deliveryType: formData.get('deliveryType'),
		packingPreference: formData.get('packingPreference'),
		preferredDate: formData.get('preferredDate'),
		preferredTime: formData.get('manualTime'),
		dropOffTime: formData.get("dropOffTime"),
		cost: document.getElementById("totalCost").textContent.replace(/[^\d.]/g, ''),
	};
}

function submitToServlet(formData) {
	fetch('BookingServlet', {
		method: 'POST',
		body: new URLSearchParams([...formData.entries()])
	})
		.then(res => res.json())
		.then(data => {
			if (data.status === "success") {
				alert("Booking successful!");
				const bookingId = encodeURIComponent(data.bookingId);
				window.location.href = "PaymentServlet?bookingId=" + bookingId;
			} else {
				alert("Error: " + data.message);
			}
		})
		.catch(err => {
			console.error("Fetch error:", err);
			alert("Booking submission failed. Please try again.");
		});

	resetForm();
}

function validateBookingData(data) {
	const errors = {};

	// Required field validations
	const requiredFields = {
		senderName: 'Sender name is required',
		senderAddress: 'Sender address is required',
		receiverName: 'Receiver name is required',
		receiverAddress: 'Receiver address is required',
		contents: 'Contents description is required',
		deliveryType: 'Delivery type is required',
		preferredDate: 'Preferred pickup date is required'
	};

	Object.entries(requiredFields).forEach(([field, message]) => {
		if (!data[field]) errors[field] = message;
	});

	// Mobile validation
	if (!data.senderContact || !validateMobile(data.senderContact)) {
		errors.senderContact = 'Valid sender contact number is required';
	}
	if (!data.receiverContact || !validateMobile(data.receiverContact)) {
		errors.receiverContact = 'Valid receiver contact number is required';
	}

	// Pincode validation
	if (!data.senderPincode || !validatePincode(data.senderPincode)) {
		errors.senderPincode = 'Valid 6-digit pincode is required';
	}
	if (!data.receiverPincode || !validatePincode(data.receiverPincode)) {
		errors.receiverPincode = 'Valid 6-digit pincode is required';
	}

	// Weight validation (support both kg and grams)
	const weightField = document.getElementById('weight');
	const isGrams = weightField?.placeholder?.includes('grams') || weightField?.max == '50000';

	if (isGrams) {
		if (!data.weight || data.weight <= 0 || data.weight > 50000) {
			errors.weight = 'Weight must be between 1 and 50,000 grams';
		}
	} else {
		if (!data.weight || data.weight <= 0 || data.weight > 50) {
			errors.weight = 'Weight must be between 0.1 and 50 kg';
		}
		if (!data.size) errors.size = 'Parcel size is required';
	}

	// Packing preference (for new structure)
	if (document.getElementById('packingPreference') && !data.packingPreference) {
		errors.packingPreference = 'Packing preference is required';
	}

	// Date validation
	if (data.preferredDate) {
		const selectedDate = new Date(data.preferredDate);
		const today = new Date();
		today.setHours(0, 0, 0, 0);
		if (selectedDate < today) {
			errors.preferredDate = 'Pickup date cannot be in the past';
		}
	}

	// Time validation
	if (!data.preferredTime) {
		errors.preferredTime = 'Preferred time is required';
	}

	return errors;
}

function resetForm() {
	const form = document.getElementById('bookingForm');
	if (!form) return;

	form.reset();
	clearAllErrors();

	// Remove acknowledgment displays
	document.querySelectorAll('.booking-success').forEach(el => el.remove());

	// Re-populate customer info if needed
	const user = typeof getCurrentUser === 'function' ? getCurrentUser() : null;
	if (user?.role === 'customer') {
		prefillCustomerInfo(user);
	}

	// Reset date and calculations
	initializeDateAndCost();

	// Clear drop-off time if exists
	const dropOffField = document.getElementById('dropOffTime');
	if (dropOffField) {
		dropOffField.value = '';
	}
}

// Utility functions
function calculateBaseCost(weight, size, deliveryType) {
	return weight * 10 + (size === "large" ? 20 : 10) + (deliveryType === "express" ? 30 : 10);
}

function calculateAdditionalCost(additionalServices) {
	let cost = 0;
	if (additionalServices.insurance) cost += 50;
	if (additionalServices.tracking) cost += 20;
	if (additionalServices.fragile) cost += 30;
	return cost;
}

function calculateTotalCost(data) {
	const baseRate = PRICING_CONFIG.baseRate;
	const weightCharge = data.weight * PRICING_CONFIG.weightChargePerGram;
	const deliveryCharge = PRICING_CONFIG.deliveryCharges[data.deliveryType] || 0;
	const packingCharge = PRICING_CONFIG.packingCharges[data.packingPreference] || 0;

	const subtotal = baseRate + weightCharge + deliveryCharge + packingCharge;
	return Math.round(subtotal * (1 + PRICING_CONFIG.taxRate) * 100) / 100;
}

function createBookingRecord(data, totalAmount, user) {
	const currentDateTime = new Date().toISOString();

	return {
		bookingId: generateBookingId(),
		customerId: user?.id,
		...data,
		totalAmount,
		status: 'pending',
		paymentStatus: 'pending',
		bookingDate: currentDateTime,
		createdBy: user?.role
	};
}

function showBookingAcknowledgment(booking) {
	const acknowledgmentHtml = `
        <div class="booking-success" style="background: #d4edda; border: 1px solid #c3e6cb; border-radius: 8px; padding: 20px; margin: 20px 0;">
            <h3 style="color: #155724;">🎉 Booking Successful!</h3>
            <div style="color: #155724;">
                <p><strong>Booking ID:</strong> ${booking.bookingId}</p>
                <p><strong>Total Amount:</strong> ${formatCurrency(booking.totalAmount)}</p>
                <p style="margin-top: 15px; font-weight: bold;">Redirecting to payment page...</p>
            </div>
        </div>
    `;

	const form = document.getElementById('bookingForm');
	const acknowledgmentDiv = document.createElement('div');
	acknowledgmentDiv.innerHTML = acknowledgmentHtml;
	form.parentNode.insertBefore(acknowledgmentDiv, form);
	acknowledgmentDiv.scrollIntoView({ behavior: 'smooth' });
}

function updateElement(id, value) {
	const element = document.getElementById(id);
	if (element) {
		element.textContent = formatCurrency(value);
	}
}

function showError(fieldId, message) {
	const errorElement = document.getElementById(fieldId + 'Error');
	if (errorElement) {
		errorElement.textContent = message;
		errorElement.style.color = '#dc3545';
	}
}

function clearError(fieldId) {
	const errorElement = document.getElementById(fieldId + 'Error');
	if (errorElement) {
		errorElement.textContent = '';
	}
}

function showErrors(errors) {
	Object.entries(errors).forEach(([field, message]) => {
		showError(field, message);
	});
}

function clearAllErrors() {
	document.querySelectorAll('[id$="Error"]').forEach(el => el.textContent = '');
}

function getTodayDate() {
	return new Date().toISOString().split('T')[0];
}

function generateBookingId() {
	return 'BK' + Date.now().toString().slice(-8) + Math.random().toString(36).substr(2, 4).toUpperCase();
}

function formatCurrency(amount) {
	return `₹${amount.toFixed(2)}`;
}

// Backward compatibility function
function goBack() {
	const user = typeof getCurrentUser === 'function' ? getCurrentUser() : null;
	const destination = user?.role === 'customer' ? 'customer-home.html' : 'officer-home.html';
	window.location.href = destination;
}