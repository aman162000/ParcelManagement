package com.parcel.servlet;

import com.parcel.services.BookingService;
import com.parcel.models.Booking;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.Map;

@WebServlet("/paymentSuccessServlet")
public class PaymentSuccessServlet extends HttpServlet {

    private BookingService bookingService;

    @Override
    public void init() throws ServletException {
        bookingService = new BookingService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Extract payment details from the request
            String bookingId = request.getParameter("bookingId");
            String paymentId = request.getParameter("paymentId");
            String orderId = request.getParameter("orderId");
            String signature = request.getParameter("signature");

            // Verify the payment with Razorpay API (you can use Razorpay's SDK here)
            boolean isVerified = verifyPaymentWithRazorpay(orderId, paymentId, signature);

            if (isVerified) {
                // Update booking status to 'paid'
                bookingService.updateBookingPaymentStatus(bookingId, true);
                response.getWriter().write("Payment successful");
            } else {
                // Handle failed payment verification
                response.getWriter().write("Payment verification failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Payment failed");
        }
    }

    private boolean verifyPaymentWithRazorpay(String orderId, String paymentId, String signature) {
        // Use Razorpay SDK or manual API call to verify payment signature
        // Razorpay documentation provides the verification process
        return true;
    }
}
