// ===============================================
// JAVA PRODUCT MODEL CLASS
// Save as: src/com/ecommerce/models/Product.java
// ===============================================

package com.ecommerce.models;

public class Product {
    
    private String productId;
    private String name;
    private String description;
    private double price;
    private String category;
    private int stock;
    private String imageUrl;
    private double rating;
    private int reviewsCount;
    
    // Constructor 1: Empty
    public Product() {
    }
    
    // Constructor 2: Basic
    public Product(String name, double price, String category) {
        this.name = name;
        this.price = price;
        this.category = category;
    }
    
    // Constructor 3: Full
    public Product(String productId, String name, String description, double price,
                   String category, int stock, String imageUrl, double rating, int reviewsCount) {
        this.productId = productId;
        this.name = name;
        this.description = description;
        this.price = price;
        this.category = category;
        this.stock = stock;
        this.imageUrl = imageUrl;
        this.rating = rating;
        this.reviewsCount = reviewsCount;
    }
    
    // ============ GETTERS & SETTERS ============
    
    public String getProductId() {
        return productId;
    }
    
    public void setProductId(String productId) {
        this.productId = productId;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public double getPrice() {
        return price;
    }
    
    public void setPrice(double price) {
        this.price = price;
    }
    
    public String getCategory() {
        return category;
    }
    
    public void setCategory(String category) {
        this.category = category;
    }
    
    public int getStock() {
        return stock;
    }
    
    public void setStock(int stock) {
        this.stock = stock;
    }
    
    public String getImageUrl() {
        return imageUrl;
    }
    
    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
    
    public double getRating() {
        return rating;
    }
    
    public void setRating(double rating) {
        this.rating = rating;
    }
    
    public int getReviewsCount() {
        return reviewsCount;
    }
    
    public void setReviewsCount(int reviewsCount) {
        this.reviewsCount = reviewsCount;
    }
    
    @Override
    public String toString() {
        return "Product{" +
                "productId='" + productId + '\'' +
                ", name='" + name + '\'' +
                ", price=" + price +
                ", category='" + category + '\'' +
                ", stock=" + stock +
                '}';
    }
}
