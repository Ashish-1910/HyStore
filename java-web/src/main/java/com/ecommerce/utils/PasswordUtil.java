// ===============================================
// JAVA PASSWORD UTILITY CLASS
// Save as: src/com/ecommerce/utils/PasswordUtil.java
// ===============================================

package com.ecommerce.utils;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class PasswordUtil {
    
    /**
     * Hash password using SHA-256
     * Note: In production, use bcrypt or argon2
     */
    public static String hashPassword(String password) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(password.getBytes());
            StringBuilder hexString = new StringBuilder();
            
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 algorithm not found", e);
        }
    }
    
    /**
     * Verify password against hash
     */
    public static boolean verifyPassword(String password, String hash) {
        String hashedPassword = hashPassword(password);
        return hashedPassword.equals(hash);
    }
    
    /**
     * Check if password meets minimum requirements
     */
    public static boolean isValidPassword(String password) {
        // At least 6 characters
        if (password == null || password.length() < 6) {
            return false;
        }
        
        // Should contain one uppercase letter
        boolean hasUppercase = password.matches(".*[A-Z].*");
        
        // Should contain one lowercase letter
        boolean hasLowercase = password.matches(".*[a-z].*");
        
        // Should contain one digit
        boolean hasDigit = password.matches(".*\\d.*");
        
        return hasUppercase && hasLowercase && hasDigit;
    }
    
    /**
     * Generate a random temporary password
     */
    public static String generateRandomPassword(int length) {
        String charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz";
        StringBuilder password = new StringBuilder();
        
        for (int i = 0; i < length; i++) {
            int index = (int) (Math.random() * charset.length());
            password.append(charset.charAt(index));
        }
        
        return password.toString();
    }
}
