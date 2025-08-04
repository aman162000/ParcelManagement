package com.parcel.servlet;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.sql.*;

import com.parcel.services.BookingService;
import com.parcel.models.Booking;
import com.parcel.models.User;
/**
 * Servlet implementation class BookingServlet
 */
@WebServlet("/BookingServlet")
public class BookingServlet extends HttpServlet {

    private BookingService bookingService;

    @Override
    public void init() throws ServletException {
        // Initialize BookingService once at the start
        this.bookingService = new BookingService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Display the booking form
        RequestDispatcher dispatcher = request.getRequestDispatcher("/booking.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Extract form data
    	
    	HttpSession session = request.getSession();
    	User user = (User) session.getAttribute("user");
    	
    	System.out.print(user.getCustomerId());
    	String customerId = user.getCustomerId();
        String senderName = request.getParameter("senderName");
        String senderContact = request.getParameter("senderContact");
        String senderAddress = request.getParameter("senderAddress");
        String senderPincode = request.getParameter("senderPincode");

        System.out.println("senderName: " + senderName);
        System.out.println("senderContact: " + senderContact);
        
        String receiverName = request.getParameter("receiverName");
        String receiverContact = request.getParameter("receiverContact");
        String receiverAddress = request.getParameter("receiverAddress");
        String receiverPincode = request.getParameter("receiverPincode");

        double weight = Double.parseDouble(request.getParameter("weight"));
        String size = request.getParameter("size");
        String contents = request.getParameter("contents");

        String deliveryType = request.getParameter("deliveryType");
        String preferredDateStr = request.getParameter("preferredDate");
        String preferredTime = request.getParameter("preferredTime");

        // Validate the input data
        if (isInvalidForm(senderName, senderContact, senderAddress, senderPincode,
                          receiverName, receiverContact, receiverAddress, receiverPincode,
                          weight, size, contents, deliveryType, preferredDateStr, preferredTime)) {

            request.setAttribute("errorMessage", "Please fill in all required fields correctly.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/booking.jsp");
            dispatcher.forward(request, response);
            return;
        }

        // Parse the preferred pickup date
        Date preferredDate = Date.valueOf(preferredDateStr);

        // Create a new booking object
        Booking booking = new Booking();
        booking.setCustomerId(customerId);
        booking.setCustomerName(senderName);
        booking.setCustomerContact(senderContact);
        booking.setCustomerAddress(senderAddress+" "+senderPincode);
        booking.setRecName(receiverName);
        booking.setRecMobile(receiverContact);
        booking.setRecAddress(receiverAddress);
        booking.setRecPin(receiverPincode);
        booking.setParWeightGram((int) (weight * 1000)); // Convert kg to grams
        booking.setParContentsDescription(contents);
        booking.setParDeliveryType(deliveryType);
        booking.setParPackingPreference(size);
        booking.setParPickupTime(Timestamp.valueOf(preferredDateStr + " 09:00:00"));
        booking.setParDropoffTime(Timestamp.valueOf(preferredDateStr + " 18:00:00"));
        booking.setBookingDate(new Timestamp(System.currentTimeMillis())); // Set booking date to now

        // Calculate the service cost (this should be done by the service layer)
        try {
            int bookingId = bookingService.createBooking(booking);
            // Redirect to success page or show success message
            request.setAttribute("booking", booking);
            response.sendRedirect("payment.jsp");
        } catch (SQLException e) {
            // Handle database-related errors
        	e.printStackTrace();
            request.setAttribute("errorMessage", "A database error occurred. Please try again later.");
//            RequestDispatcher dispatcher = request.getRequestDispatcher("/booking.jsp");
//            dispatcher.forward(request, response);
        } 
    }

    private boolean isInvalidForm(String senderName, String senderContact, String senderAddress, String senderPincode,
                                  String receiverName, String receiverContact, String receiverAddress, String receiverPincode,
                                  double weight, String size, String contents, String deliveryType,
                                  String preferredDateStr, String preferredTime) {
        // Check for any null or empty values for required fields
        return senderName.isEmpty() || senderContact.isEmpty() || senderAddress.isEmpty() || senderPincode.isEmpty() ||
               receiverName.isEmpty() || receiverContact.isEmpty() || receiverAddress.isEmpty() || receiverPincode.isEmpty() ||
               weight <= 0 || size.isEmpty() || contents.isEmpty() || deliveryType.isEmpty() || preferredDateStr.isEmpty() || preferredTime.isEmpty();
    }
}