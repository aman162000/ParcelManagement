package com.parcel.servlet;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.sql.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;
import java.io.PrintWriter;

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
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// Display the booking form
		RequestDispatcher dispatcher = request.getRequestDispatcher("/booking.jsp");
		dispatcher.forward(request, response);
	}

	private boolean isInvalidForm(String senderName, String senderContact, String senderAddress, String senderPincode,
			String receiverName, String receiverContact, String receiverAddress, String receiverPincode, double weight,
			String size, String contents, String deliveryType, String preferredDateStr, String preferredTime) {
// Check for any null or empty values for required fields
		return senderName.isEmpty() || senderContact.isEmpty() || senderAddress.isEmpty() || senderPincode.isEmpty()
				|| receiverName.isEmpty() || receiverContact.isEmpty() || receiverAddress.isEmpty()
				|| receiverPincode.isEmpty() || weight <= 0 || size.isEmpty() || contents.isEmpty()
				|| deliveryType.isEmpty() || preferredDateStr.isEmpty() || preferredTime.isEmpty();
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();

		HttpSession session = request.getSession();
		User user = (User) session.getAttribute("user");

		if (user == null) {
			response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
			out.print("{\"status\":\"error\", \"message\":\"User not authenticated.\"}");
			out.flush();
			return;
		}

		String customerId = user.getCustomerId();
		String senderName = request.getParameter("senderName");
		String senderContact = request.getParameter("senderContact");
		String senderAddress = request.getParameter("senderAddress");
		String senderPincode = request.getParameter("senderPincode");

		String receiverName = request.getParameter("receiverName");
		String receiverContact = request.getParameter("receiverContact");
		String receiverAddress = request.getParameter("receiverAddress");
		String receiverPincode = request.getParameter("receiverPincode");

		String weightStr = request.getParameter("weight");
		double weight = 0.0;
		try {
			weight = Double.parseDouble(weightStr);
		} catch (NumberFormatException e) {
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			out.print("{\"status\":\"error\", \"message\":\"Invalid weight format.\"}");
			out.flush();
			return;
		}

		String size = request.getParameter("size");
		String contents = request.getParameter("contents");
		String deliveryType = request.getParameter("deliveryType");
		String preferredDateStr = request.getParameter("preferredDate");
		String preferredTime = request.getParameter("preferredTime");

		if (isInvalidForm(senderName, senderContact, senderAddress, senderPincode, receiverName, receiverContact,
				receiverAddress, receiverPincode, weight, size, contents, deliveryType, preferredDateStr,
				preferredTime)) {
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			out.print("{\"status\":\"error\", \"message\":\"Please fill in all required fields correctly.\"}");
			out.flush();
			return;
		}

		Date preferredDate = Date.valueOf(preferredDateStr);
		String dateTimeStr = preferredDateStr + "T" + preferredTime;

		LocalDateTime dateTime;
		try {
			dateTime = LocalDateTime.parse(dateTimeStr);
		} catch (DateTimeParseException e) {
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			out.print("{\"status\":\"error\", \"message\":\"Invalid date or time format.\"}");
			out.flush();
			return;
		}

		Booking booking = new Booking();
		booking.setCustomerId(customerId);
		booking.setCustomerName(senderName);
		booking.setCustomerContact(senderContact);
		booking.setCustomerAddress(senderAddress + " " + senderPincode);
		booking.setRecName(receiverName);
		booking.setRecMobile(receiverContact);
		booking.setRecAddress(receiverAddress);
		booking.setRecPin(receiverPincode);
		booking.setParWeightGram((int) (weight * 1000));
		booking.setParContentsDescription(contents);
		booking.setParDeliveryType(deliveryType);
		booking.setParPackingPreference(size);
		booking.setParPickupTime(Timestamp.valueOf(dateTime));
		booking.setParDropoffTime(Timestamp.valueOf(preferredDateStr + " 18:00:00"));
		booking.setBookingDate(new Timestamp(System.currentTimeMillis()));

		try {
			int bookingId = bookingService.createBooking(booking);

			out.print("{\"status\":\"success\", \"message\":\"Booking created successfully.\", \"bookingId\":"
					+ bookingId + "}");
			out.flush();
		} catch (SQLException e) {
			e.printStackTrace();
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			out.print("{\"status\":\"error\", \"message\":\"A database error occurred. Please try again later.\"}");
			out.flush();
		}
	}

}