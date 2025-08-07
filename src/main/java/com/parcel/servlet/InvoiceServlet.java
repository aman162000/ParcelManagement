package com.parcel.servlet;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.parcel.models.Booking;
import com.parcel.models.User;
import com.parcel.services.BookingService;
import com.parcel.services.UserService;

/**
 * Servlet implementation class InvoiceServlet
 */
@WebServlet("/InvoiceServlet")
public class InvoiceServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public InvoiceServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String bookingId = request.getParameter("bookingId");
		BookingService bookingService = new BookingService();
		UserService userService = new UserService();
		try {
			Booking book = bookingService.getBookingById(bookingId);
			User user = userService.getUserByCustomerId(book.getCustomerId());
			
			request.setAttribute("user",user);
			request.setAttribute("book", book);
            request.getRequestDispatcher("invoice.jsp").forward(request, response);

			
		} catch (SQLException e) {
			request.setAttribute("error","Not found.");

            request.getRequestDispatcher("invoice.jsp").forward(request, response);

			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
