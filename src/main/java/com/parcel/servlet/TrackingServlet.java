package com.parcel.servlet;

import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.parcel.models.Booking;
import com.parcel.services.BookingService;

@WebServlet("/TrackingServlet")
public class TrackingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final BookingService bookingService = new BookingService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        String bookingId = request.getParameter("bookingId");
        System.out.print(bookingId);
        if (bookingId == null || bookingId.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Booking ID is required.");
            return;
        }

        try {
            Booking booking = bookingService.getBookingById(bookingId.trim());

            if (booking == null) {
            	request.setAttribute("error", "Booking not found for ID: " + bookingId);
                request.getRequestDispatcher("tracking.jsp").forward(request, response);
                return;
            }

            request.setAttribute("booking", booking);
            request.getRequestDispatcher("tracking.jsp").forward(request, response);

        } catch (SQLException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred while processing your request.");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "GET method is not supported for this endpoint.");
    }
}
