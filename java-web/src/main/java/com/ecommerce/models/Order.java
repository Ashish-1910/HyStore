// ===============================================
// JAVA ORDER MODEL CLASS
// Save as: src/com/ecommerce/models/Order.java
// ===============================================

package com.ecommerce.models;

import java.util.ArrayList;
import java.util.List;
import java.time.LocalDateTime;

public class Order {
    
    private int orderId;
    private int userId;
    private LocalDateTime orderDate;
    private double totalAmount;
    private String status;  // pending, confirmed, shipped, delivered, cancelled
    private String shippingAddress;
    private String paymentMethod;
    private String notes;
    private List<CartItem> items;
    
    // Constructor 1: Empty
    public Order() {
        this.items = new ArrayList<>();
        this.status = "pending";
        this.orderDate = LocalDateTime.now();
    }
    
    // Constructor 2: Basic
    public Order(int userId, String shippingAddress) {
        this();
        this.userId = userId;
        this.shippingAddress = shippingAddress;
    }
    
    // Constructor 3: Full
    public Order(int orderId, int userId, LocalDateTime orderDate, double totalAmount,
                 String status, String shippingAddress, String paymentMethod, String notes) {
        this();
        this.orderId = orderId;
        this.userId = userId;
        this.orderDate = orderDate;
        this.totalAmount = totalAmount;
        this.status = status;
        this.shippingAddress = shippingAddress;
        this.paymentMethod = paymentMethod;
        this.notes = notes;
    }
    
    // ============ GETTERS & SETTERS ============
    
    public int getOrderId() {
        return orderId;
    }
    
    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public LocalDateTime getOrderDate() {
        return orderDate;
    }
    
    public void setOrderDate(LocalDateTime orderDate) {
        this.orderDate = orderDate;
    }
    
    public double getTotalAmount() {
        return totalAmount;
    }
    
    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public String getShippingAddress() {
        return shippingAddress;
    }
    
    public void setShippingAddress(String shippingAddress) {
        this.shippingAddress = shippingAddress;
    }
    
    public String getPaymentMethod() {
        return paymentMethod;
    }
    
    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }
    
    public String getNotes() {
        return notes;
    }
    
    public void setNotes(String notes) {
        this.notes = notes;
    }
    
    public List<CartItem> getItems() {
        return items;
    }
    
    public void setItems(List<CartItem> items) {
        this.items = items;
    }
    
    public void addItem(CartItem item) {
        this.items.add(item);
        updateTotalAmount();
    }
    
    public void removeItem(CartItem item) {
        this.items.remove(item);
        updateTotalAmount();
    }
    
    private void updateTotalAmount() {
        this.totalAmount = 0;
        for (CartItem item : items) {
            this.totalAmount += item.getSubtotal();
        }
    }
    
    @Override
    public String toString() {
        return "Order{" +
                "orderId=" + orderId +
                ", userId=" + userId +
                ", totalAmount=" + totalAmount +
                ", status='" + status + '\'' +
                ", items=" + items.size() +
                '}';
    }
}
