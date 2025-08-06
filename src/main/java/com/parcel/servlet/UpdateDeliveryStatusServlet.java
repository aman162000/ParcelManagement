package com.parcel.servlet;

import com.parcel.models.Booking;
import com.parcel.models.User;
import com.parcel.services.BookingService;
import com.parcel.exceptions.NoDataFoundException;

import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;


@WebServlet("/UpdateDeliveryStatusServlet")
public class UpdateDeliveryStatusServlet extends HttpServlet {
	private BookingService bookingService;

	@Override
	public void init() throws ServletException {
		bookingService = new BookingService();
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String action = request.getParameter("action");

		switch (action) {

		case "get-booking":
			String bookingId = request.getParameter("bookingId");
			if (bookingId == null || bookingId.trim().isEmpty()) {
				response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Booking ID is required.");
				return;
			}

			try {
				Booking booking = bookingService.getBookingById(bookingId.trim());

				if (booking == null) {
					request.setAttribute("error", "Booking not found for ID: " + bookingId);
					request.getRequestDispatcher("delivery-status.jsp").forward(request, response);
					return;
				}

				request.setAttribute("booking", booking);
				request.getRequestDispatcher("delivery-status.jsp").forward(request, response);

			} catch (SQLException e) {
				response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
						"An error occurred while processing your request.");
			}

			break;
		case "view":
			try {
				List<Booking> bookings = bookingService.listBooking();
				request.setAttribute("bookings", bookings);
				request.getRequestDispatcher("delivery-status.jsp").forward(request, response);

			}catch(SQLException | NoDataFoundException e) {
				e.printStackTrace();
			}
			

		}

	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);
		User user = (User) (session != null ? session.getAttribute("user") : null);

		if (user == null || !"officer".equalsIgnoreCase(user.getRole())) {
			response.sendRedirect("index.jsp");
			return;
		}

		String bookingId = request.getParameter("bookingId");
		String newStatus = request.getParameter("newStatus");
		String statusNotes = request.getParameter("statusNotes");

		if (bookingId == null || newStatus == null || bookingId.isBlank() || newStatus.isBlank()) {
			request.setAttribute("error", "Booking ID and new status are required.");
			request.getRequestDispatcher("delivery-status.jsp").forward(request, response);
			return;
		}

		try {
			bookingService.updateDeliveryStatus(bookingId, newStatus);
			request.setAttribute("modalTitle", "Updated Successfully!");
			request.setAttribute("modalMessage",
					"The booking status having " + bookingId + " updated to " + newStatus.toUpperCase() + ".");
			request.setAttribute("showSuccessModal", true); // Used to trigger modal on page load
			List<Booking> bookings = bookingService.listBooking();
			request.setAttribute("bookings", bookings);
			request.getRequestDispatcher("delivery-status.jsp").forward(request, response);

		} catch (IllegalArgumentException e) {
			request.setAttribute("error", "Invalid status: " + e.getMessage());
		} catch (Exception e) {
			request.setAttribute("error", "Failed to update delivery status due to a server error.");
			e.printStackTrace();
		}

		request.getRequestDispatcher("delivery-status.jsp").forward(request, response);
	}
}
