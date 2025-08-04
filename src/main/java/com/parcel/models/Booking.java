package com.parcel.models;

import com.parcel.utils.NumericUniqueIDGenerator;
import java.sql.Timestamp;

public class Booking {
	private String bookingId;
	private String customerId;
	private String customerName;
	private String customerAddress;
	private String customerContact;
	private String recName;
	private String recAddress;
	private String recPin;
	private String recMobile;
	private int parWeightGram;
	private String parContentsDescription;
	private String parDeliveryType;
	private String parPackingPreference;
	private Timestamp parPickupTime;
	private Timestamp parDropoffTime;
	private double parServiceCost;
	private Timestamp parPaymentTime;
	private String parStatus;
	private Timestamp bookingDate;
	private boolean isPaid;

	public Booking() {
		this.bookingId = NumericUniqueIDGenerator.generateUniqueId("BK");
	}

	@Override
	public String toString() {
		return "Booking [bookingId=" + bookingId + ", customerId=" + customerId + ", customerName=" + customerName
				+ ", customerAddress=" + customerAddress + ", customerContact=" + customerContact + ", recName="
				+ recName + ", recAddress=" + recAddress + ", recPin=" + recPin + ", recMobile=" + recMobile
				+ ", parWeightGram=" + parWeightGram + ", parContentsDescription=" + parContentsDescription
				+ ", parDeliveryType=" + parDeliveryType + ", parPackingPreference=" + parPackingPreference
				+ ", parPickupTime=" + parPickupTime + ", parDropoffTime=" + parDropoffTime + ", parServiceCost="
				+ parServiceCost + ", parPaymentTime=" + parPaymentTime + ", parStatus=" + parStatus + ", bookingDate="
				+ bookingDate + ", isPaid=" + isPaid + "]";
	}

	public Booking(String customerId, String customerName, String customerAddress, String customerContact, String recName,
			String recAddress, String recPin, String recMobile, int parWeightGram, String parContentsDescription,
			String parDeliveryType, String parPackingPreference, Timestamp parPickupTime, Timestamp parDropoffTime,
			double parServiceCost, Timestamp parPaymentTime, String parStatus) {
		this.customerId = customerId;
		this.customerName = customerName;
		this.customerAddress = customerAddress;
		this.customerContact = customerContact;
		this.recName = recName;
		this.recAddress = recAddress;
		this.recPin = recPin;
		this.recMobile = recMobile;
		this.parWeightGram = parWeightGram;
		this.parContentsDescription = parContentsDescription;
		this.parDeliveryType = parDeliveryType;
		this.parPackingPreference = parPackingPreference;
		this.parPickupTime = parPickupTime;
		this.parDropoffTime = parDropoffTime;
		this.parServiceCost = parServiceCost;
		this.parPaymentTime = parPaymentTime;
		this.parStatus = parStatus;
		this.bookingDate = new Timestamp(System.currentTimeMillis());
		this.bookingId = NumericUniqueIDGenerator.generateUniqueId("BK");
		this.isPaid = false;
	}

	// Getters and Setters
	public String getBookingId() {
		return bookingId;
	}

	public void setBookingId(String bookingId) {
		this.bookingId = bookingId;
	}

	public String getCustomerId() {
		return customerId;
	}

	public void setCustomerId(String customerId) {
		this.customerId = customerId;
	}

	public String getCustomerName() {
		return customerName;
	}

	public void setCustomerName(String customerName) {
		this.customerName = customerName;
	}

	public String getCustomerAddress() {
		return customerAddress;
	}

	public void setCustomerAddress(String customerAddress) {
		this.customerAddress = customerAddress;
	}

	public String getCustomerContact() {
		return customerContact;
	}

	public void setCustomerContact(String customerContact) {
		this.customerContact = customerContact;
	}

	public String getRecName() {
		return recName;
	}

	public void setRecName(String recName) {
		this.recName = recName;
	}

	public String getRecAddress() {
		return recAddress;
	}

	public void setRecAddress(String recAddress) {
		this.recAddress = recAddress;
	}

	public String getRecPin() {
		return recPin;
	}

	public void setRecPin(String recPin) {
		this.recPin = recPin;
	}

	public String getRecMobile() {
		return recMobile;
	}

	public void setRecMobile(String recMobile) {
		this.recMobile = recMobile;
	}

	public int getParWeightGram() {
		return parWeightGram;
	}

	public void setParWeightGram(int parWeightGram) {
		this.parWeightGram = parWeightGram;
	}

	public String getParContentsDescription() {
		return parContentsDescription;
	}

	public void setParContentsDescription(String parContentsDescription) {
		this.parContentsDescription = parContentsDescription;
	}

	public String getParDeliveryType() {
		return parDeliveryType;
	}

	public void setParDeliveryType(String parDeliveryType) {
		this.parDeliveryType = parDeliveryType;
	}

	public String getParPackingPreference() {
		return parPackingPreference;
	}

	public void setParPackingPreference(String parPackingPreference) {
		this.parPackingPreference = parPackingPreference;
	}

	public Timestamp getParPickupTime() {
		return parPickupTime;
	}

	public void setParPickupTime(Timestamp parPickupTime) {
		this.parPickupTime = parPickupTime;
	}

	public Timestamp getParDropoffTime() {
		return parDropoffTime;
	}

	public void setParDropoffTime(Timestamp parDropoffTime) {
		this.parDropoffTime = parDropoffTime;
	}

	public double getParServiceCost() {
		return parServiceCost;
	}

	public void setParServiceCost(double parServiceCost) {
		this.parServiceCost = parServiceCost;
	}

	public Timestamp getParPaymentTime() {
		return parPaymentTime;
	}

	public void setParPaymentTime(Timestamp parPaymentTime) {
		this.parPaymentTime = parPaymentTime;
	}

	public String getParStatus() {
		return parStatus;
	}

	public void setParStatus(String parStatus) {
		this.parStatus = parStatus;
	}

	public Timestamp getBookingDate() {
		return bookingDate;
	}

	public void setBookingDate(Timestamp bookingDate) {
		this.bookingDate = bookingDate;
	}

	public boolean isPaid() {
		return isPaid;
	}

	public void setPaid(boolean isPaid) {
		this.isPaid = isPaid;
	}

}
