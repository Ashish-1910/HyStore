// ===============================================
// JAVA USER MODEL CLASS
// Save as: src/com/ecommerce/models/User.java
// ===============================================

package com.ecommerce.models;

public class User {
    
    private int userId;
    private String username;
    private String email;
    private String password;
    private String fullName;
    private String phone;
    private String address;
    private String city;
    private String state;
    private String postalCode;
    private String role;  // "customer" or "admin"
    
    // Constructor 1: Empty
    public User() {
    }
    
    // Constructor 2: For Login
    public User(String username, String password) {
        this.username = username;
        this.password = password;
    }
    
    // Constructor 3: For Registration
    public User(String username, String email, String password, String fullName) {
        this.username = username;
        this.email = email;
        this.password = password;
        this.fullName = fullName;
        this.role = "customer";  // Default role
    }
    
    // Constructor 4: Full
    public User(int userId, String username, String email, String password, String fullName,
                String phone, String address, String city, String state, String postalCode, String role) {
        this.userId = userId;
        this.username = username;
        this.email = email;
        this.password = password;
        this.fullName = fullName;
        this.phone = phone;
        this.address = address;
        this.city = city;
        this.state = state;
        this.postalCode = postalCode;
        this.role = role;
    }
    
    // ===============================================
    // GETTERS & SETTERS
    // ===============================================
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public String getUsername() {
        return username;
    }
    
    public void setUsername(String username) {
        this.username = username;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getPassword() {
        return password;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
    
    public String getFullName() {
        return fullName;
    }
    
    public void setFullName(String fullName) {
        this.fullName = fullName;
    }
    
    public String getPhone() {
        return phone;
    }
    
    public void setPhone(String phone) {
        this.phone = phone;
    }
    
    public String getAddress() {
        return address;
    }
    
    public void setAddress(String address) {
        this.address = address;
    }
    
    public String getCity() {
        return city;
    }
    
    public void setCity(String city) {
        this.city = city;
    }
    
    public String getState() {
        return state;
    }
    
    public void setState(String state) {
        this.state = state;
    }
    
    public String getPostalCode() {
        return postalCode;
    }
    
    public void setPostalCode(String postalCode) {
        this.postalCode = postalCode;
    }
    
    public String getRole() {
        return role;
    }
    
    public void setRole(String role) {
        this.role = role;
    }
    
    // ===============================================
    // UTILITY METHODS
    // ===============================================
    
    public boolean isAdmin() {
        return "admin".equals(this.role);
    }
    
    public boolean isCustomer() {
        return "customer".equals(this.role);
    }
    
    @Override
    public String toString() {
        return "User{" +
                "userId=" + userId +
                ", username='" + username + '\'' +
                ", email='" + email + '\'' +
                ", fullName='" + fullName + '\'' +
                ", role='" + role + '\'' +
                '}';
    }
}