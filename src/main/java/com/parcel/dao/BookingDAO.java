package com.parcel.dao;

import com.parcel.models.Booking;
import com.parcel.utils.DatabaseConnection;
import com.parcel.exceptions.NoDataFoundException;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {
    
    public int createBooking(Booking booking) throws SQLException {
        String sql = """
            INSERT INTO bookings (customer_id, customer_name, customer_address, customer_contact,
                                rec_name, rec_address, rec_pin, rec_mobile, par_weight_gram,
                                par_contents_description, par_delivery_type, par_packing_preference,
                                par_pickup_time, par_dropoff_time, par_service_cost, par_payment_time,
                                par_status, booking_date,booking_id,payment_status)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """;

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setString(1, booking.getCustomerId());
            pstmt.setString(2, booking.getCustomerName());
            pstmt.setString(3, booking.getCustomerAddress());
            pstmt.setString(4, booking.getCustomerContact());
            pstmt.setString(5, booking.getRecName());
            pstmt.setString(6, booking.getRecAddress());
            pstmt.setString(7, booking.getRecPin());
            pstmt.setString(8, booking.getRecMobile());
            pstmt.setInt(9, booking.getParWeightGram());
            pstmt.setString(10, booking.getParContentsDescription());
            pstmt.setString(11, booking.getParDeliveryType());
            pstmt.setString(12, booking.getParPackingPreference());
            pstmt.setTimestamp(13, booking.getParPickupTime());
            pstmt.setTimestamp(14, booking.getParDropoffTime());
            pstmt.setDouble(15, booking.getParServiceCost());
            pstmt.setTimestamp(16, booking.getParPaymentTime());
            pstmt.setString(17, booking.getParStatus());
            pstmt.setTimestamp(18, booking.getBookingDate());
            pstmt.setString(19, booking.getBookingId());
            pstmt.setBoolean(20, false);
            pstmt.executeUpdate();
            
            try (ResultSet rs = pstmt.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return -1;
    }

    public Booking getBookingById(String bookingId) throws SQLException {
        String sql = "SELECT * FROM bookings WHERE booking_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, bookingId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToBooking(rs);
                }
            }
        }
        return null;
    }
    
    public Booking getBookingByCustomer(String bookingId,String customerId) throws SQLException {
        String sql = "SELECT * FROM bookings WHERE booking_id = ? AND customer_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, bookingId);
            pstmt.setString(2, customerId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToBooking(rs);
                }
            }
        }
        return null;
    }
    

    public List<Booking> getBookingsByCustomer(String customerId) throws SQLException {
        String sql = "SELECT * FROM bookings WHERE customer_id = ? ORDER BY booking_date DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, customerId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                List<Booking> bookings = new ArrayList<>();
                while (rs.next()) {
                    bookings.add(mapResultSetToBooking(rs));
                }
                return bookings;
            }
        }
    }

    public List<Booking> getBookingsByDateRange(Date startDate, Date endDate) throws SQLException, NoDataFoundException {
        String sql = "SELECT * FROM bookings WHERE booking_date BETWEEN ? AND ? ORDER BY booking_date DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setDate(1, startDate);
            pstmt.setDate(2, endDate);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                List<Booking> bookings = new ArrayList<>();
                while (rs.next()) {
                    bookings.add(mapResultSetToBooking(rs));
                }
                
                if (bookings.isEmpty()) {
                    throw new NoDataFoundException("No Details found in the given criteria");
                }
                
                return bookings;
            }
        }
    }

    public void updatePickupDropoffTime(String bookingId, Timestamp pickupTime, Timestamp dropoffTime) throws SQLException {
        String sql = "UPDATE bookings SET par_pickup_time = ?, par_dropoff_time = ? WHERE booking_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setTimestamp(1, pickupTime);
            pstmt.setTimestamp(2, dropoffTime);
            pstmt.setString(3, bookingId);
            
            pstmt.executeUpdate();
        }
    }

    public void updateBookingPaymentStatus(String bookingId,Boolean status) throws SQLException {
        String sql = "UPDATE bookings SET payment_status = ? WHERE booking_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
               
               pstmt.setBoolean(1, status);
               pstmt.setString(2, bookingId);
               
               pstmt.executeUpdate();
           }
    }
    
    public void updateDeliveryStatus(String bookingId, String status) throws SQLException {
        String sql = "UPDATE bookings SET par_status = ? WHERE booking_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, status);
            pstmt.setString(2, bookingId);
            
            pstmt.executeUpdate();
        }
    }

    public List<Booking> getAllBookings() throws SQLException, NoDataFoundException {
        String sql = "SELECT * FROM bookings ORDER BY booking_date DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            try (ResultSet rs = pstmt.executeQuery()) {
                List<Booking> bookings = new ArrayList<>();
                while (rs.next()) {
                    bookings.add(mapResultSetToBooking(rs));
                }
                
                if (bookings.isEmpty()) {
                    throw new NoDataFoundException("No Details found in the given criteria");
                }
                
                return bookings;
            }
        }
    }

    
    private Booking mapResultSetToBooking(ResultSet rs) throws SQLException {
        Booking booking = new Booking();
        booking.setBookingId(rs.getString("booking_id"));
        booking.setCustomerId(rs.getString("customer_id"));
        booking.setCustomerName(rs.getString("customer_name"));
        booking.setCustomerAddress(rs.getString("customer_address"));
        booking.setCustomerContact(rs.getString("customer_contact"));
        booking.setRecName(rs.getString("rec_name"));
        booking.setRecAddress(rs.getString("rec_address"));
        booking.setRecPin(rs.getString("rec_pin"));
        booking.setRecMobile(rs.getString("rec_mobile"));
        booking.setParWeightGram(rs.getInt("par_weight_gram"));
        booking.setParContentsDescription(rs.getString("par_contents_description"));
        booking.setParDeliveryType(rs.getString("par_delivery_type"));
        booking.setParPackingPreference(rs.getString("par_packing_preference"));
        booking.setParPickupTime(rs.getTimestamp("par_pickup_time"));
        booking.setParDropoffTime(rs.getTimestamp("par_dropoff_time"));
        booking.setParServiceCost(rs.getDouble("par_service_cost"));
        booking.setParPaymentTime(rs.getTimestamp("par_payment_time"));
        booking.setParStatus(rs.getString("par_status"));
        booking.setBookingDate(rs.getTimestamp("booking_date"));
        booking.setPaid(rs.getBoolean("payment_status"));
        return booking;
    }
}