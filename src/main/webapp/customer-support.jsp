<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page
	import="com.parcel.models.User,com.parcel.models.Booking,java.util.List,java.sql.Timestamp"%>
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
    <title>Customer Support - PMS</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <%@include file="nav.jsp" %>
    
    <div class="container">
        <div class="support-container">
            <h2>💬 Customer Support</h2>
            <p class="support-intro">Need help? We're here to assist you with any questions or concerns.</p>
            
            <div class="support-grid">
                <div class="support-card">
                    <div class="support-icon">📞</div>
                    <h3>Phone Support</h3>
                    <div class="contact-info">
                        <p><strong>Customer Service:</strong></p>
                        <p class="contact-detail">+91 1800-123-4567</p>
                        <p class="contact-hours">Available 24/7</p>
                    </div>
                    <div class="contact-info">
                        <p><strong>Technical Support:</strong></p>
                        <p class="contact-detail">+91 1800-765-4321</p>
                        <p class="contact-hours">Mon-Fri: 9:00 AM - 6:00 PM</p>
                    </div>
                </div>
                
                <div class="support-card">
                    <div class="support-icon">📧</div>
                    <h3>Email Support</h3>
                    <div class="contact-info">
                        <p><strong>General Inquiries:</strong></p>
                        <p class="contact-detail">support@pms.com</p>
                    </div>
                    <div class="contact-info">
                        <p><strong>Billing & Payments:</strong></p>
                        <p class="contact-detail">billing@pms.com</p>
                    </div>
                    <div class="contact-info">
                        <p><strong>Complaints:</strong></p>
                        <p class="contact-detail">complaints@pms.com</p>
                    </div>
                    <p class="contact-hours">Response within 24 hours</p>
                </div>
                
                <div class="support-card">
                    <div class="support-icon">📍</div>
                    <h3>Office Address</h3>
                    <div class="contact-info">
                        <p><strong>Head Office:</strong></p>
                        <address class="contact-detail">
                            Parcel Management Systems Pvt. Ltd.<br>
                            123 Business District<br>
                            Bengaluru, Karnataka 560066<br>
                            India
                        </address>
                        <p class="contact-hours">Mon-Sat: 9:00 AM - 6:00 PM</p>
                    </div>
                </div>
            </div>
            
            <div class="faq-section">
                <h3>📋 Frequently Asked Questions</h3>
                <div class="faq-list">
                    <div class="faq-item">
                        <div class="faq-question" onclick="toggleFAQ(this)">
                            <span>How can I track my parcel?</span>
                            <span class="faq-toggle">+</span>
                        </div>
                        <div class="faq-answer">
                            <p>You can track your parcel using the 12-digit booking ID provided after booking. Go to the Tracking page and enter your booking ID to see real-time status updates.</p>
                        </div>
                    </div>
                    
                    <div class="faq-item">
                        <div class="faq-question" onclick="toggleFAQ(this)">
                            <span>What are the delivery time options?</span>
                            <span class="faq-toggle">+</span>
                        </div>
                        <div class="faq-answer">
                            <p>We offer three delivery options:</p>
                            <ul>
                                <li><strong>Standard:</strong> 3-5 business days</li>
                                <li><strong>Express:</strong> 1-2 business days</li>
                                <li><strong>Overnight:</strong> Next business day</li>
                            </ul>
                        </div>
                    </div>
                    
                    <div class="faq-item">
                        <div class="faq-question" onclick="toggleFAQ(this)">
                            <span>How do I cancel or modify my booking?</span>
                            <span class="faq-toggle">+</span>
                        </div>
                        <div class="faq-answer">
                            <p>You can cancel or modify your booking before it's picked up by contacting our customer service at +91 1800-123-4567 or emailing support@pms.com with your booking ID.</p>
                        </div>
                    </div>
                    
                    <div class="faq-item">
                        <div class="faq-question" onclick="toggleFAQ(this)">
                            <span>What payment methods do you accept?</span>
                            <span class="faq-toggle">+</span>
                        </div>
                        <div class="faq-answer">
                            <p>We accept all major credit and debit cards including Visa, MasterCard, American Express, and RuPay. All payments are processed securely.</p>
                        </div>
                    </div>
                    
                    <div class="faq-item">
                        <div class="faq-question" onclick="toggleFAQ(this)">
                            <span>What items are prohibited for shipping?</span>
                            <span class="faq-toggle">+</span>
                        </div>
                        <div class="faq-answer">
                            <p>Prohibited items include hazardous materials, flammable substances, liquids, perishable food items, illegal substances, and valuable items like jewelry or cash. Please contact us for a complete list.</p>
                        </div>
                    </div>
                    
                    <div class="faq-item">
                        <div class="faq-question" onclick="toggleFAQ(this)">
                            <span>How is the shipping cost calculated?</span>
                            <span class="faq-toggle">+</span>
                        </div>
                        <div class="faq-answer">
                            <p>Shipping cost is calculated based on package weight, size, delivery type, and additional services like insurance or fragile handling. You can see the cost breakdown during booking.</p>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="quick-actions">
                <h3>🚀 Quick Actions</h3>
                <div class="action-buttons">
                    <a href="booking.jsp" class="btn btn-primary">📋 New Booking</a>
                    <a href="tracking.jsp" class="btn btn-primary">🔍 Track Parcel</a>
                    <a href="booking-history.jsp" class="btn btn-secondary">📊 View History</a>
                    <a href="customer-home.jsp" class="btn btn-secondary">🏠 Back to Home</a>
                </div>
            </div>
        </div>
    </div>
    
    <script src="utils.js"></script>
    <script>
        
        function toggleFAQ(element) {
            const faqItem = element.parentElement;
            const answer = faqItem.querySelector('.faq-answer');
            const toggle = element.querySelector('.faq-toggle');
            
            if (answer.style.display === 'block') {
                answer.style.display = 'none';
                toggle.textContent = '+';
                faqItem.classList.remove('active');
            } else {
                // Close all other FAQ items
                document.querySelectorAll('.faq-item').forEach(item => {
                    item.querySelector('.faq-answer').style.display = 'none';
                    item.querySelector('.faq-toggle').textContent = '+';
                    item.classList.remove('active');
                });
                
                // Open current FAQ item
                answer.style.display = 'block';
                toggle.textContent = '-';
                faqItem.classList.add('active');
            }
        }
    </script>
</body>
</html>