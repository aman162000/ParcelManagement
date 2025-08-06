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

import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.stream.Collectors;

@WebServlet("/SchedulingServlet")
public class SchedulingServlet extends HttpServlet {
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
					request.getRequestDispatcher("pickup-scheduling.jsp").forward(request, response);
					return;
				}

				request.setAttribute("booking", booking);
				request.getRequestDispatcher("pickup-scheduling.jsp").forward(request, response);

			} catch (SQLException e) {
				response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
						"An error occurred while processing your request.");
			}

			break;
		case "view":
			try {
				List<Booking> todaysBookings = bookingService.listBooking().stream().filter(book -> {
					Timestamp timestamp = book.getBookingDate();
					LocalDate bookingDate = timestamp.toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
					System.out.println(bookingDate);
					return bookingDate.isEqual(LocalDate.now()) && book.getParStatus().equalsIgnoreCase("booked");
				}).collect(Collectors.toList());
				System.out.print("Booking"+todaysBookings.toString());
				request.setAttribute("todaysBookings", todaysBookings);
				request.getRequestDispatcher("pickup-scheduling.jsp").forward(request, response);

			} catch (SQLException | NoDataFoundException e) {
				e.printStackTrace();
			}

		}

	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
	}
}
