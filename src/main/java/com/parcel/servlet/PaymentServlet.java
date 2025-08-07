package com.parcel.servlet;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.parcel.models.Booking;
import com.parcel.services.BookingService;

/**
 * Servlet implementation class PaymentServlet
 */
@WebServlet("/PaymentServlet")
public class PaymentServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public PaymentServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String bookingId = request.getParameter("bookingId");

        // Basic input validation
        if (bookingId == null || bookingId.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing or invalid bookingId parameter.");
            return;
        }

        BookingService bookingService = new BookingService();

        try {
            Booking booking = bookingService.getBookingById(bookingId);

            if (booking == null) {
                // Booking not found
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Booking not found for ID: " + bookingId);
                return;
            }

            // Set booking in request scope for JSP or servlet to use
            request.setAttribute("booking", booking);

            // Forward to JSP page (adjust the path to your JSP)
            request.getRequestDispatcher("payment.jsp").forward(request, response);

        } catch (SQLException e) {
            // Log the exception (use your logging framework here, e.g., SLF4J or java.util.logging)
            e.printStackTrace();

            // Return a 500 Internal Server Error with a user-friendly message
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error retrieving booking data. Please try again later.");
        }
    }


	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
    @Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
    	
    	String bookingId = request.getParameter("bookingId");
        BookingService bookingService = new BookingService();

        try {
        	bookingService.updateBookingPaymentStatus(bookingId, true);
        	Booking booking = bookingService.getBookingById(bookingId);
            request.setAttribute("booking", booking);

        	request.setAttribute("isSuccess", true);
            request.getRequestDispatcher("payment.jsp").forward(request, response);

        	
		} catch (SQLException e) {
			// TODO Auto-generated catch block
        	request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("payment.jsp").forward(request, response);

			e.printStackTrace();
		}
    	
    }
	

}
