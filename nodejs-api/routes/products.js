// ===============================================
// PRODUCT ROUTES
// Save as: nodejs-api/routes/products.js
// ===============================================

const express = require("express");
const router = express.Router();
const productController = require("../controllers/productController");

// ========== PUBLIC ROUTES ==========

// Get all products
router.get("/", productController.getAllProducts);

// Get single product by ID
router.get("/:id", productController.getProductById);

// Get products by category
router.get("/category/:category", productController.getProductsByCategory);

// Search products
router.get("/search/query", productController.searchProducts);

// ========== ADMIN ROUTES (Ideally with auth middleware) ==========

// Create new product
router.post("/", productController.createProduct);

// Update product
router.put("/:id", productController.updateProduct);

// Delete product
router.delete("/:id", productController.deleteProduct);

module.exports = router;
