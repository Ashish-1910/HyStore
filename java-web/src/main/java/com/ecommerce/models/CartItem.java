// ===============================================
// JAVA CART ITEM MODEL CLASS
// Save as: src/com/ecommerce/models/CartItem.java
// ===============================================

package com.ecommerce.models;

public class CartItem {
    
    private int cartItemId;
    private String productId;
    private String productName;
    private double price;
    private int quantity;
    private String imageUrl;
    
    // Constructor 1: Empty
    public CartItem() {
    }
    
    // Constructor 2: For adding to cart
    public CartItem(String productId, String productName, double price, int quantity, String imageUrl) {
        this.productId = productId;
        this.productName = productName;
        this.price = price;
        this.quantity = quantity;
        this.imageUrl = imageUrl;
    }
    
    // Constructor 3: Full
    public CartItem(int cartItemId, String productId, String productName, double price,
                    int quantity, String imageUrl) {
        this.cartItemId = cartItemId;
        this.productId = productId;
        this.productName = productName;
        this.price = price;
        this.quantity = quantity;
        this.imageUrl = imageUrl;
    }
    
    // ============ GETTERS & SETTERS ============
    
    public int getCartItemId() {
        return cartItemId;
    }
    
    public void setCartItemId(int cartItemId) {
        this.cartItemId = cartItemId;
    }
    
    public String getProductId() {
        return productId;
    }
    
    public void setProductId(String productId) {
        this.productId = productId;
    }
    
    public String getProductName() {
        return productName;
    }
    
    public void setProductName(String productName) {
        this.productName = productName;
    }
    
    public double getPrice() {
        return price;
    }
    
    public void setPrice(double price) {
        this.price = price;
    }
    
    public int getQuantity() {
        return quantity;
    }
    
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
    
    public String getImageUrl() {
        return imageUrl;
    }
    
    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
    
    // ============ HELPER METHODS ============
    
    public double getSubtotal() {
        return this.price * this.quantity;
    }
    
    @Override
    public String toString() {
        return "CartItem{" +
                "cartItemId=" + cartItemId +
                ", productId='" + productId + '\'' +
                ", productName='" + productName + '\'' +
                ", price=" + price +
                ", quantity=" + quantity +
                ", subtotal=" + getSubtotal() +
                '}';
    }
}
