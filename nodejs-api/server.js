// ===============================================
// NODEJS API - MAIN SERVER FILE
// Save as: nodejs-api/server.js
// Run with: node server.js
// ===============================================

const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
const dotenv = require("dotenv");
const bodyParser = require("body-parser");

// Load environment variables
dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// ===============================================
// MIDDLEWARE
// ===============================================

// Body Parser Middleware
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// CORS Middleware (Allow requests from Java app on port 8080)
app.use(
  cors({
    origin: process.env.CORS_ORIGIN || "http://localhost:8080",
    credentials: true,
  }),
);

// ===============================================
// MONGODB CONNECTION
// ===============================================

mongoose
  .connect(process.env.MONGODB_URI, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .then(() => console.log("✅ MongoDB Connected Successfully!"))
  .catch((err) => console.log("❌ MongoDB Connection Error:", err.message));

// ===============================================
// PRODUCT SCHEMA & MODEL
// ===============================================

const productSchema = new mongoose.Schema({
  product_id: String,
  name: {
    type: String,
    required: true,
  },
  category: {
    type: String,
    default: "Electronics",
  },
  description: String,
  price: {
    type: Number,
    required: true,
  },
  stock: {
    type: Number,
    default: 0,
  },
  image_url: String,
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

const Product = mongoose.model("Product", productSchema);

// ===============================================
// ROUTES
// ===============================================

// Home Route
app.get("/", (req, res) => {
  res.json({
    message: "Welcome to E-Commerce Product API",
    version: "v1",
    endpoints: {
      "GET /api/products": "Get all products",
      "GET /api/products/:id": "Get single product",
      "POST /api/products": "Create product (Admin)",
      "PUT /api/products/:id": "Update product (Admin)",
      "DELETE /api/products/:id": "Delete product (Admin)",
    },
  });
});

// ===============================================
// GET ALL PRODUCTS
// ===============================================
app.get("/api/products", async (req, res) => {
  try {
    const products = await Product.find();

    // If no products, return sample data for testing
    if (products.length === 0) {
      return res.json({
        success: true,
        message: "No products found",
        data: [],
      });
    }

    res.json({
      success: true,
      count: products.length,
      data: products,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: error.message,
    });
  }
});

// ===============================================
// GET SINGLE PRODUCT BY ID
// ===============================================
app.get("/api/products/:id", async (req, res) => {
  try {
    const product = await Product.findById(req.params.id);

    if (!product) {
      return res.status(404).json({
        success: false,
        message: "Product not found",
      });
    }

    res.json({
      success: true,
      data: product,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: error.message,
    });
  }
});

// ===============================================
// CREATE NEW PRODUCT (Admin Only)
// ===============================================
app.post("/api/products", async (req, res) => {
  try {
    const { name, category, description, price, stock, image_url } = req.body;

    // Validation
    if (!name || !price) {
      return res.status(400).json({
        success: false,
        message: "Name and price are required",
      });
    }

    const newProduct = new Product({
      name,
      category: category || "Electronics",
      description: description || "",
      price,
      stock: stock || 0,
      image_url: image_url || "https://via.placeholder.com/300?text=" + name,
      rating: 0,
      reviews_count: 0,
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
      error: error.message,
    });
  }
});

// ===============================================
// UPDATE PRODUCT (Admin Only)
// ===============================================
app.put("/api/products/:id", async (req, res) => {
  try {
    const { name, category, description, price, stock, image_url } = req.body;

    const updateData = {
      name: name || undefined,
      category: category || undefined,
      description: description || undefined,
      price: price || undefined,
      stock: stock || undefined,
      image_url: image_url || undefined,
      updated_at: new Date(),
    };

    // Remove undefined fields
    Object.keys(updateData).forEach(
      (key) => updateData[key] === undefined && delete updateData[key],
    );

    const updatedProduct = await Product.findByIdAndUpdate(
      req.params.id,
      updateData,
      { new: true, runValidators: true },
    );

    if (!updatedProduct) {
      return res.status(404).json({
        success: false,
        message: "Product not found",
      });
    }

    res.json({
      success: true,
      message: "Product updated successfully",
      data: updatedProduct,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: error.message,
    });
  }
});

// ===============================================
// DELETE PRODUCT (Admin Only)
// ===============================================
app.delete("/api/products/:id", async (req, res) => {
  try {
    const deletedProduct = await Product.findByIdAndDelete(req.params.id);

    if (!deletedProduct) {
      return res.status(404).json({
        success: false,
        message: "Product not found",
      });
    }

    res.json({
      success: true,
      message: "Product deleted successfully",
      data: deletedProduct,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: error.message,
    });
  }
});

// ===============================================
// SEED DATABASE WITH SAMPLE PRODUCTS
// ===============================================
app.get("/api/seed", async (req, res) => {
  try {
    // Check if products already exist
    const existingProducts = await Product.countDocuments();

    if (existingProducts > 0) {
      return res.json({
        success: true,
        message: "Database already has products",
      });
    }

    const sampleProducts = [
      {
        name: "Wireless Headphones",
        category: "Audio",
        description: "High-quality wireless headphones with noise cancellation",
        price: 2999,
        stock: 50,
        image_url: "https://via.placeholder.com/300?text=Wireless+Headphones",
        rating: 4.5,
        reviews_count: 125,
      },
      {
        name: "USB-C Cable",
        category: "Cables",
        description: "Durable USB-C charging cable, 2 meters long",
        price: 599,
        stock: 200,
        image_url: "https://via.placeholder.com/300?text=USB-C+Cable",
        rating: 4.2,
        reviews_count: 89,
      },
      {
        name: "Phone Case",
        category: "Accessories",
        description: "Protective phone case with shock absorption",
        price: 499,
        stock: 150,
        image_url: "https://via.placeholder.com/300?text=Phone+Case",
        rating: 4.0,
        reviews_count: 67,
      },
      {
        name: "Screen Protector",
        category: "Accessories",
        description: "Tempered glass screen protector for smartphones",
        price: 299,
        stock: 300,
        image_url: "https://via.placeholder.com/300?text=Screen+Protector",
        rating: 3.8,
        reviews_count: 45,
      },
      {
        name: "Power Bank",
        category: "Power",
        description: "20000mAh portable power bank with fast charging",
        price: 1999,
        stock: 80,
        image_url: "https://via.placeholder.com/300?text=Power+Bank",
        rating: 4.6,
        reviews_count: 156,
      },
      {
        name: "Laptop Stand",
        category: "Accessories",
        description: "Ergonomic aluminum laptop stand for better posture",
        price: 1499,
        stock: 60,
        image_url: "https://via.placeholder.com/300?text=Laptop+Stand",
        rating: 4.3,
        reviews_count: 78,
      },
    ];

    await Product.insertMany(sampleProducts);

    res.json({
      success: true,
      message: "Database seeded with sample products",
      count: sampleProducts.length,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: error.message,
    });
  }
});

// ===============================================
// 404 ERROR HANDLER
// ===============================================
app.use((req, res) => {
  res.status(404).json({
    success: false,
    message: "Route not found",
  });
});

// ===============================================
// START SERVER
// ===============================================
app.listen(PORT, () => {
  console.log("╔════════════════════════════════════════╗");
  console.log(`║ ✅ Server running on port ${PORT}              ║`);
  console.log("║ 🌐 http://localhost:" + PORT + "                    ║");
  console.log("║ 📊 API: http://localhost:" + PORT + "/api/products    ║");
  console.log("║ 🌱 Seed DB: http://localhost:" + PORT + "/api/seed     ║");
  console.log("╚════════════════════════════════════════╝");
});

module.exports = app;
