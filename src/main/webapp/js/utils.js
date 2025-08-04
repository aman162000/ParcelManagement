// Utility functions for the Parcel Management System

// Date and time utilities
function formatDate(date) {
  return new Date(date).toLocaleDateString("en-IN", {
    year: "numeric",
    month: "short",
    day: "numeric",
  });
}

function formatDateTime(date) {
  return new Date(date).toLocaleString("en-IN", {
    year: "numeric",
    month: "short",
    day: "numeric",
    hour: "2-digit",
    minute: "2-digit",
  });
}

function getTodayDate() {
  return new Date().toISOString().split("T")[0];
}

function addDays(date, days) {
  const result = new Date(date);
  result.setDate(result.getDate() + days);
  return result;
}

// ID generation utilities
function generateBookingId() {
  const timestamp = Date.now().toString();
  const random = Math.floor(Math.random() * 1000)
    .toString()
    .padStart(3, "0");
  return timestamp.slice(-9) + random;
}

function generateCustomerId() {
  const prefix = "CUST";
  const timestamp = Date.now().toString().slice(-8);
  return prefix + timestamp;
}

// Validation utilities
function validateEmail(email) {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
}

function validateMobile(mobile) {
  const mobileRegex = /^(\+\d{1,3}[- ]?)?\d{10}$/;
  return mobileRegex.test(mobile);
}

function validatePassword(password) {
  // Must contain uppercase, lowercase, and special character
  const hasUpper = /[A-Z]/.test(password);
  const hasLower = /[a-z]/.test(password);
  const hasSpecial = /[!@#$%^&*(),.?":{}|<>]/.test(password);
  return hasUpper && hasLower && hasSpecial && password.length <= 30;
}

function validatePincode(pincode) {
  return /^[0-9]{6}$/.test(pincode);
}

function validateUsername(username) {
  return username.length >= 5 && username.length <= 20;
}

// Local storage utilities
function saveToStorage(key, data) {
  try {
    localStorage.setItem(key, JSON.stringify(data));
    return true;
  } catch (error) {
    console.error("Error saving to storage:", error);
    return false;
  }
}

function getFromStorage(key, defaultValue = null) {
  try {
    const item = localStorage.getItem(key);
    return item ? JSON.parse(item) : defaultValue;
  } catch (error) {
    console.error("Error reading from storage:", error);
    return defaultValue;
  }
}

function removeFromStorage(key) {
  try {
    localStorage.removeItem(key);
    return true;
  } catch (error) {
    console.error("Error removing from storage:", error);
    return false;
  }
}

// Session storage utilities
function saveToSession(key, data) {
  try {
    localStorage.setItem(key, JSON.stringify(data));
    return true;
  } catch (error) {
    console.error("Error saving to session:", error);
    return false;
  }
}

function getFromSession(key, defaultValue = null) {
  try {
    const item = localStorage.getItem(key);
    return item ? JSON.parse(item) : defaultValue;
  } catch (error) {
    console.error("Error reading from session:", error);
    return defaultValue;
  }
}

// User session management
function getCurrentUser() {
  return getFromSession("currentUser");
}

function isLoggedIn() {
  return getCurrentUser() !== null;
}

function requireAuth() {
  if (!isLoggedIn()) {
    alert("Please log in to access this page.");
    window.location.href = "index.html";
    return false;
  }
  return true;
}

function logout() {
  localStorage.removeItem("currentUser");
  localStorage.removeItem("currentBooking");
  localStorage.removeItem("paymentData");
  window.location.href = "index.html";
}

// Form utilities
function clearErrors() {
  document.querySelectorAll(".error-message").forEach((el) => {
    el.textContent = "";
  });
}

function showError(fieldId, message) {
  const errorElement = document.getElementById(fieldId + "Error");
  if (errorElement) {
    errorElement.textContent = message;
  }
}

function showErrors(errors) {
  clearErrors();
  Object.keys(errors).forEach((field) => {
    showError(field, errors[field]);
  });
}

function resetForm(formId) {
  const form = document.getElementById(formId);
  if (form) {
    form.reset();
    clearErrors();
  }
}

// Cost calculation utilities
function calculateBaseCost(weight, size, deliveryType) {
  let baseCost = 0;

  // Base cost by weight
  if (weight <= 1) baseCost += 50;
  else if (weight <= 5) baseCost += 100;
  else if (weight <= 10) baseCost += 200;
  else baseCost += 300;

  // Size multiplier
  const sizeMultipliers = {
    small: 1,
    medium: 1.2,
    large: 1.5,
    xlarge: 2,
  };
  baseCost *= sizeMultipliers[size] || 1;

  // Delivery type multiplier
  const deliveryMultipliers = {
    standard: 1,
    express: 1.5,
    overnight: 2.5,
  };
  baseCost *= deliveryMultipliers[deliveryType] || 1;

  return Math.round(baseCost);
}

function calculateAdditionalCost(services) {
  let additionalCost = 0;

  if (services.insurance) additionalCost += 50;
  if (services.tracking) additionalCost += 20;
  if (services.fragile) additionalCost += 30;

  return additionalCost;
}

// Status utilities
function getStatusBadgeClass(status) {
  const statusClasses = {
    booked: "status-booked",
    "picked-up": "status-picked-up",
    "in-transit": "status-in-transit",
    delivered: "status-delivered",
    returned: "status-returned",
  };
  return statusClasses[status] || "status-booked";
}

function getStatusText(status) {
  const statusTexts = {
    booked: "Booked",
    "picked-up": "Picked Up",
    "in-transit": "In Transit",
    delivered: "Delivered",
    returned: "Returned",
  };
  return statusTexts[status] || "Unknown";
}

// Navigation utilities
function updateNavigation(userRole) {
  const navMenu = document.getElementById("navMenu");
  if (!navMenu) return;

  const currentPage = window.location.pathname.split("/").pop();

  if (userRole === "customer") {
    navMenu.innerHTML = `
            <li><a href="customer-home.html" ${
              currentPage === "customer-home.html" ? 'class="active"' : ""
            }>Home</a></li>
            <li><a href="booking.html" ${
              currentPage === "booking.html" ? 'class="active"' : ""
            }>Booking Service</a></li>
            <li><a href="tracking.html" ${
              currentPage === "tracking.html" ? 'class="active"' : ""
            }>Tracking</a></li>
            <li><a href="booking-history.html" ${
              currentPage === "booking-history.html" ? 'class="active"' : ""
            }>Previous Booking</a></li>
            <li><a href="customer-support.html" ${
              currentPage === "customer-support.html" ? 'class="active"' : ""
            }>Contact Support</a></li>
            <li><a href="#" onclick="logout()">Logout</a></li>
        `;
  } else if (userRole === "officer") {
    navMenu.innerHTML = `
            <li><a href="officer-home.html" ${
              currentPage === "officer-home.html" ? 'class="active"' : ""
            }>Home</a></li>
            <li><a href="tracking.html" ${
              currentPage === "tracking.html" ? 'class="active"' : ""
            }>Tracking</a></li>
            <li><a href="delivery-status.html" ${
              currentPage === "delivery-status.html" ? 'class="active"' : ""
            }>Delivery Status</a></li>
            <li><a href="pickup-scheduling.html" ${
              currentPage === "pickup-scheduling.html" ? 'class="active"' : ""
            }>Pickup Scheduling</a></li>
            <li><a href="booking-history.html" ${
              currentPage === "booking-history.html" ? 'class="active"' : ""
            }>Previous Booking</a></li>
            <li><a href="#" onclick="logout()">Logout</a></li>
        `;
  }
}

// Data initialization utilities
function initializeSampleData() {
  // Initialize sample users if not exists
  const users = getFromStorage("users", []);
  if (users.length === 0) {
    const sampleUsers = [
      {
        id: "CUST00000001",
        username: "john_doe",
        password: "John@123",
        role: "customer",
        name: "John Doe",
        email: "john@example.com",
        mobile: "+91 9876543210",
        address: "123 Main Street, Mumbai, Maharashtra",
      },
      {
        id: "OFF00000001",
        username: "officer1",
        password: "Officer@123",
        role: "officer",
        name: "Officer Smith",
        email: "officer@pms.com",
        mobile: "+91 9876543211",
        address: "PMS Office, Mumbai",
      },
    ];
    saveToStorage("users", sampleUsers);
  }

  // Initialize sample bookings if not exists
  const bookings = getFromStorage("bookings", []);
  if (bookings.length === 0) {
    const sampleBookings = [
      {
        bookingId: "123456789012",
        customerId: "CUST00000001",
        senderName: "John Doe",
        senderContact: "+91 9876543210",
        senderAddress: "123 Main Street, Mumbai",
        senderPincode: "400001",
        receiverName: "Jane Smith",
        receiverContact: "+91 9876543220",
        receiverAddress: "456 Park Avenue, Delhi",
        receiverPincode: "110001",
        weight: 2,
        size: "medium",
        contents: "Books and documents",
        deliveryType: "express",
        preferredDate: getTodayDate(),
        preferredTime: "9-12",
        baseCost: 240,
        additionalCost: 70,
        totalCost: 310,
        status: "in-transit",
        paymentStatus: "paid",
        bookingDate: new Date().toISOString(),
        paymentTime: new Date().toISOString(),
      },
    ];
    saveToStorage("bookings", sampleBookings);
  }
}

// Format currency
function formatCurrency(amount) {
  return `₹${amount}`;
}

// Debounce utility
function debounce(func, wait) {
  let timeout;
  return function executedFunction(...args) {
    const later = () => {
      clearTimeout(timeout);
      func(...args);
    };
    clearTimeout(timeout);
    timeout = setTimeout(later, wait);
  };
}

// Show loading state
function showLoading(element) {
  if (element) {
    element.classList.add("loading");
    element.disabled = true;
  }
}

function hideLoading(element) {
  if (element) {
    element.classList.remove("loading");
    element.disabled = false;
  }
}

// Initialize the application
function initializeApp() {
  initializeSampleData();

  // Check authentication for protected pages
  const protectedPages = [
    "customer-home.html",
    "officer-home.html",
    "booking.html",
    "payment.html",
    "invoice.html",
    "tracking.html",
    "customer-support.html",
    "booking-history.html",
    "pickup-scheduling.html",
    "delivery-status.html",
  ];

  const currentPage = window.location.pathname.split("/").pop();
  if (protectedPages.includes(currentPage)) {
    requireAuth();
  }
}

// Call initialization when the DOM is loaded
document.addEventListener("DOMContentLoaded", initializeApp);
