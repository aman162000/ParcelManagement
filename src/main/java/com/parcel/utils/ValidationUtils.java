package com.parcel.utils;

import java.util.regex.Pattern;

public class ValidationUtils {
    
    public static boolean isValidEmail(String email) {
        String emailRegex = "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$";
        return Pattern.matches(emailRegex, email);
    }

    public static boolean isValidMobile(String mobile) {
        return mobile != null && mobile.matches("\\d{10}");
    }

    public static boolean isValidUserId(String userId) {
        return userId != null && userId.length() >= 5 && userId.length() <= 20;
    }

    public static boolean isValidPassword(String password) {
        if (password == null || password.length() > 30 || password.length() < 8) {
            return false;
        }
        
        boolean hasUpper = false, hasLower = false, hasSpecial = false;
        for (char c : password.toCharArray()) {
            if (Character.isUpperCase(c)) hasUpper = true;
            else if (Character.isLowerCase(c)) hasLower = true;
            else if (!Character.isLetterOrDigit(c)) hasSpecial = true;
        }
        
        return hasUpper && hasLower && hasSpecial;
    }

    public static boolean isValidName(String name) {
        return name != null && name.trim().length() > 0 && name.length() <= 50;
    }
}