package com.parcel.services;

import com.parcel.dao.BookingDAO;
import com.parcel.models.Booking;
import com.parcel.models.User;
import com.parcel.exceptions.NoDataFoundException;

import java.sql.Date;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.List;

// Base class for inheritance
class BookingHistoryBase {
    protected BookingDAO bookingDAO;
    
    public BookingHistoryBase() {
        this.bookingDAO = new BookingDAO();
    }
    
    public List<Booking> getBookingHistory(String customerId) throws SQLException {
        return bookingDAO.getBookingsByCustomer(customerId);
    }
}

// Customer booking history with single inheritance
class CustomerBookingHistory extends BookingHistoryBase {
    public List<Booking> getCustomerBookings(String customerId) throws SQLException {
        return super.getBookingHistory(customerId);
    }
}

public class BookingService {
    private BookingDAO bookingDAO;
    private CustomerBookingHistory customerBookingHistory;

    public BookingService() {
        this.bookingDAO = new BookingDAO();
        this.customerBookingHistory = new CustomerBookingHistory();
    }

    public int createBooking(Booking booking) throws SQLException {
        // Calculate service cost based on weight and delivery type
        double cost = calculateServiceCost(booking.getParWeightGram(), booking.getParDeliveryType());
        booking.setParServiceCost(cost);
        booking.setParPaymentTime(new Timestamp(System.currentTimeMillis()));
        booking.setParStatus("Booked");
        
        // Create booking in separate thread
        
        return bookingDAO.createBooking(booking);
    }

    public Booking getBookingById(String bookingId) throws SQLException {
        return bookingDAO.getBookingById(bookingId);
    }
    
    public List<Booking> listBooking() throws SQLException, NoDataFoundException{
    	return bookingDAO.getAllBookings();
    }

    public List<Booking> getCustomerBookingHistory(String customerId) throws SQLException {
        return customerBookingHistory.getCustomerBookings(customerId);
    }

    public List<Booking> getOfficerBookingHistory(Date startDate, Date endDate) throws SQLException, NoDataFoundException {
        return bookingDAO.getBookingsByDateRange(startDate, endDate);
    }

    public void updatePickupDropoffTime(String bookingId, Timestamp pickupTime, Timestamp dropoffTime) throws SQLException {
        bookingDAO.updatePickupDropoffTime(bookingId, pickupTime, dropoffTime);
    }

    public void updateBookingPaymentStatus(String bookingId,Boolean status) throws SQLException {
    	bookingDAO.updateBookingPaymentStatus(bookingId,status);
    }
    
    public void updateDeliveryStatus(String bookingId, String status) throws SQLException {
        String[] validStatuses = {"Booked", "In-Transit", "Delivered", "Returned","Picked-up"};
        boolean isValid = false;
        for (String validStatus : validStatuses) {
            if (validStatus.equalsIgnoreCase(status)) {
                isValid = true;
                break;
            }
        }
        
        if (!isValid) {
            throw new IllegalArgumentException("Invalid status. Valid statuses: Booked, In Transit, Delivered, Returned");
        }
        
        bookingDAO.updateDeliveryStatus(bookingId, status);
    }

    private double calculateServiceCost(int weightGram, String deliveryType) {
        double baseCost = 50.0; // Base cost
        double weightCost = (weightGram / 100.0) * 10; // 10 per 100g
        
        double deliveryMultiplier = switch (deliveryType.toLowerCase()) {
            case "express" -> 2.0;
            case "priority" -> 1.5;
            case "standard" -> 1.0;
            default -> 1.0;
        };
        
        return (baseCost + weightCost) * deliveryMultiplier;
    }
}