// ===============================================
// PRODUCT MODEL - MongoDB Schema
// Save as: nodejs-api/models/Product.js
// ===============================================

const mongoose = require("mongoose");

// Create Product Schema
const productSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
    trim: true,
  },
  description: {
    type: String,
    required: true,
  },
  price: {
    type: Number,
    required: true,
    min: 0,
  },
  category: {
    type: String,
    required: true,
    default: "General",
  },
  stock: {
    type: Number,
    required: true,
    default: 0,
    min: 0,
  },
  image_url: {
    type: String,
    default: "https://via.placeholder.com/400x300?text=Product+Image",
  },
  rating: {
    type: Number,
    default: 0,
    min: 0,
    max: 5,
  },
  reviews_count: {
    type: Number,
    default: 0,
  },
  created_at: {
    type: Date,
    default: Date.now,
  },
  updated_at: {
    type: Date,
    default: Date.now,
  },
});

// Auto update the updated_at field before saving
productSchema.pre("save", function (next) {
  this.updated_at = Date.now();
  next();
});

// Create and Export Product Model
module.exports = mongoose.model("Product", productSchema);
