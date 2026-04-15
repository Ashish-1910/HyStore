// ===============================================
// PRODUCT CONTROLLER - Business Logic
// Save as: nodejs-api/controllers/productController.js
// ===============================================

const Product = require("../models/Product");

// Get ALL Products
exports.getAllProducts = async (req, res) => {
  try {
    const products = await Product.find().sort({ created_at: -1 });
    res.status(200).json({
      success: true,
      message: "Products retrieved successfully",
      data: products,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "Error retrieving products",
      error: error.message,
    });
  }
};

// Get Product by ID
exports.getProductById = async (req, res) => {
  try {
    const product = await Product.findById(req.params.id);

    if (!product) {
      return res.status(404).json({
        success: false,
        message: "Product not found",
      });
    }

    res.status(200).json({
      success: true,
      message: "Product retrieved successfully",
      data: product,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "Error retrieving product",
      error: error.message,
    });
  }
};

// Create NEW Product (Admin only)
exports.createProduct = async (req, res) => {
  try {
    const { name, description, price, category, stock, image_url } = req.body;

    // Validation
    if (!name || !description || !price || !category) {
      return res.status(400).json({
        success: false,
        message: "Please provide all required fields",
      });
    }

    const newProduct = new Product({
      name,
      description,
      price,
      category,
      stock: stock || 0,
      image_url,
    });

    const savedProduct = await newProduct.save();

    res.status(201).json({
      success: true,
      message: "Product created successfully",
      data: savedProduct,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "Error creating product",
      error: error.message,
    });
  }
};

// Update Product (Admin only)
exports.updateProduct = async (req, res) => {
  try {
    const { id } = req.params;
    const updateData = req.body;

    const updatedProduct = await Product.findByIdAndUpdate(id, updateData, {
      new: true,
      runValidators: true,
    });

    if (!updatedProduct) {
      return res.status(404).json({
        success: false,
        message: "Product not found",
      });
    }

    res.status(200).json({
      success: true,
      message: "Product updated successfully",
      data: updatedProduct,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "Error updating product",
      error: error.message,
    });
  }
};

// Delete Product (Admin only)
exports.deleteProduct = async (req, res) => {
  try {
    const { id } = req.params;

    const deletedProduct = await Product.findByIdAndDelete(id);

    if (!deletedProduct) {
      return res.status(404).json({
        success: false,
        message: "Product not found",
      });
    }

    res.status(200).json({
      success: true,
      message: "Product deleted successfully",
      data: deletedProduct,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "Error deleting product",
      error: error.message,
    });
  }
};

// Get Products by Category
exports.getProductsByCategory = async (req, res) => {
  try {
    const { category } = req.params;

    const products = await Product.find({ category }).sort({ created_at: -1 });

    res.status(200).json({
      success: true,
      message: "Products retrieved by category",
      data: products,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "Error retrieving products by category",
      error: error.message,
    });
  }
};

// Search Products
exports.searchProducts = async (req, res) => {
  try {
    const { query } = req.query;

    if (!query) {
      return res.status(400).json({
        success: false,
        message: "Search query is required",
      });
    }

    const products = await Product.find({
      $or: [
        { name: { $regex: query, $options: "i" } },
        { description: { $regex: query, $options: "i" } },
        { category: { $regex: query, $options: "i" } },
      ],
    });

    res.status(200).json({
      success: true,
      message: "Search results retrieved",
      data: products,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "Error searching products",
      error: error.message,
    });
  }
};
