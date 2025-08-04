package com.parcel.models;

import com.parcel.utils.NumericUniqueIDGenerator;

public class User extends BaseModel {
	private int userId;
	private String customerName;
	private String email;
	private String countryCode;
	private String mobileNumber;
	private String address;
	private String userIdString;
	private String password;
	private String role;
	private String preferences;
	private String customerId;

	public User() {
	}

	public User(String customerName, String email, String countryCode, String mobileNumber, String address,
			String userIdString, String password, String role, String preferences) {

		this.customerId = NumericUniqueIDGenerator.generateUniqueId("CUST");
		this.customerName = customerName;
		this.email = email;
		this.countryCode = countryCode;
		this.mobileNumber = mobileNumber;
		this.address = address;
		this.userIdString = userIdString;
		this.password = password;
		this.role = role;
		this.preferences = preferences;
		this.userId = Integer.parseInt(NumericUniqueIDGenerator.generateUniqueId("").substring(0, 5));
	}

	public int getUserId() {
		return userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}

	public String getCustomerName() {
		return customerName;
	}

	public void setCustomerName(String customerName) {
		this.customerName = customerName;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getCountryCode() {
		return countryCode;
	}

	public void setCountryCode(String countryCode) {
		this.countryCode = countryCode;
	}

	public String getMobileNumber() {
		return mobileNumber;
	}

	public void setMobileNumber(String mobileNumber) {
		this.mobileNumber = mobileNumber;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getUserIdString() {
		return userIdString;
	}

	public void setUserIdString(String userIdString) {
		this.userIdString = userIdString;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getRole() {
		return role;
	}

	public void setRole(String role) {
		this.role = role;
	}

	public String getPreferences() {
		return preferences;
	}

	public void setPreferences(String preferences) {
		this.preferences = preferences;
	}

	public String getCustomerId() {
		return customerId;
	}

	public void setCustomerId(String customerId) {
		this.customerId = customerId;
	}

}
