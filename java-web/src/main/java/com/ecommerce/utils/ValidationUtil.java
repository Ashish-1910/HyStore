// ===============================================
// JAVA VALIDATION UTILITY CLASS
// Save as: src/com/ecommerce/utils/ValidationUtil.java
// ===============================================

package com.ecommerce.utils;

import java.util.regex.Pattern;

public class ValidationUtil {
    
    private static final String EMAIL_REGEX = "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$";
    private static final String PHONE_REGEX = "^[0-9]{10,15}$";
    private static final String USERNAME_REGEX = "^[a-zA-Z0-9_]{3,20}$";
    private static final Pattern EMAIL_PATTERN = Pattern.compile(EMAIL_REGEX);
    private static final Pattern PHONE_PATTERN = Pattern.compile(PHONE_REGEX);
    private static final Pattern USERNAME_PATTERN = Pattern.compile(USERNAME_REGEX);
    
    /**
     * Validate email format
     */
    public static boolean isValidEmail(String email) {
        if (email == null || email.isEmpty()) {
            return false;
        }
        return EMAIL_PATTERN.matcher(email).matches();
    }
    
    /**
     * Validate phone number format
     */
    public static boolean isValidPhone(String phone) {
        if (phone == null || phone.isEmpty()) {
            return false;
        }
        return PHONE_PATTERN.matcher(phone).matches();
    }
    
    /**
     * Validate username format
     */
    public static boolean isValidUsername(String username) {
        if (username == null || username.isEmpty()) {
            return false;
        }
        return USERNAME_PATTERN.matcher(username).matches();
    }
    
    /**
     * Validate full name
     */
    public static boolean isValidFullName(String fullName) {
        if (fullName == null || fullName.trim().isEmpty()) {
            return false;
        }
        return fullName.length() >= 3 && fullName.length() <= 100;
    }
    
    /**
     * Validate postal code format (India)
     */
    public static boolean isValidPostalCode(String postalCode) {
        if (postalCode == null || postalCode.isEmpty()) {
            return false;
        }
        return postalCode.matches("^[0-9]{6}$");
    }
    
    /**
     * Validate address
     */
    public static boolean isValidAddress(String address) {
        if (address == null || address.trim().isEmpty()) {
            return false;
        }
        return address.length() >= 5 && address.length() <= 255;
    }
    
    /**
     * Check if string is null or empty
     */
    public static boolean isEmptyOrNull(String str) {
        return str == null || str.trim().isEmpty();
    }
    
    /**
     * Check if number is valid price
     */
    public static boolean isValidPrice(double price) {
        return price > 0 && price < 1000000;
    }
    
    /**
     * Check if number is valid quantity
     */
    public static boolean isValidQuantity(int quantity) {
        return quantity > 0 && quantity < 10000;
    }
    
    /**
     * Sanitize input to prevent SQL injection (basic)
     */
    public static String sanitizeInput(String input) {
        if (input == null) {
            return "";
        }
        return input.replace("'", "''").replace("\"", "\"\"");
    }
}
