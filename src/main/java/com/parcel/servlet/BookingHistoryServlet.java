package com.parcel.servlet;

import com.parcel.dao.BookingDAO;
import com.parcel.exceptions.NoDataFoundException;
import com.parcel.models.Booking;
import com.parcel.models.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.util.*;
import java.util.stream.Collectors;

@WebServlet("/BookingHistoryServlet")
public class BookingHistoryServlet extends HttpServlet {

    private BookingDAO bookingDAO;

    @Override
    public void init() throws ServletException {
        bookingDAO = new BookingDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        String statusFilter = request.getParameter("statusFilter");
        String fromDateStr = request.getParameter("fromDate");
        String toDateStr = request.getParameter("toDate");

        List<Booking> bookings = new ArrayList<>();

        try {
            // 1. Get all bookings of this customer
        	if(user.getRole().equalsIgnoreCase("customer")) {
        		bookings = bookingDAO.getBookingsByCustomer(user.getCustomerId());
        	}else {
        		bookings = bookingDAO.getAllBookings();
        	}

            // 2. Apply status filter
            if (statusFilter != null && !statusFilter.isEmpty()) {
                bookings = bookings.stream()
                        .filter(b -> b.getParStatus().equalsIgnoreCase(statusFilter))
                        .collect(Collectors.toList());
            }

            // 3. Apply date filters
            if (fromDateStr != null && !fromDateStr.isEmpty()) {
                Date fromDate = Date.valueOf(fromDateStr);
                bookings = bookings.stream()
                        .filter(b -> !b.getBookingDate().before(fromDate))
                        .collect(Collectors.toList());
            }

            if (toDateStr != null && !toDateStr.isEmpty()) {
                Date toDate = Date.valueOf(toDateStr);
                bookings = bookings.stream()
                        .filter(b -> !b.getBookingDate().after(toDate))
                        .collect(Collectors.toList());
            }

            // Set bookings and forward to JSP
            request.setAttribute("bookings", bookings);
            request.getRequestDispatcher("booking-history.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to fetch booking history.");
            request.getRequestDispatcher("booking-history.jsp").forward(request, response);
        } catch (NoDataFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    }
}
