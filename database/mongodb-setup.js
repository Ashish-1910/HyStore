// ===============================================
// MONGODB SETUP SCRIPT FOR HYBRID E-COMMERCE
// Save as: database/mongodb-setup.js
// Run with: node mongodb-setup.js
// ===============================================

// MongoDB Connection String (Update with your Atlas URI)
// mongodb+srv://username:password@cluster.mongodb.net/ecommerce_products

db = db.getSiblingDB("ecommerce_products");

// ===============================================
// CREATE PRODUCTS COLLECTION
// ===============================================

db.products.drop(); // Drop existing collection if present

db.products.insertMany([
  {
    name: "Wireless Headphones",
    description: "High-quality Bluetooth wireless headphones with noise cancellation",
    price: 2999,
    category: "Electronics",
    stock: 50,
    image_url: "https://via.placeholder.com/400x300?text=Wireless+Headphones",
    rating: 4.5,
    reviews_count: 120,
    created_at: new Date(),
    updated_at: new Date()
  },
  {
    name: "Smart Watch",
    description: "Smartwatch with fitness tracking and health monitoring",
    price: 15999,
    category: "Electronics",
    stock: 30,
    image_url: "https://via.placeholder.com/400x300?text=Smart+Watch",
    rating: 4.2,
    reviews_count: 85,
    created_at: new Date(),
    updated_at: new Date()
  },
  {
    name: "USB-C Cable",
    description: "Fast charging USB-C cable compatible with all devices",
    price: 1500,
    category: "Electronics",
    stock: 100,
    image_url: "https://via.placeholder.com/400x300?text=USB-C+Cable",
    rating: 4.0,
    reviews_count: 200,
    created_at: new Date(),
    updated_at: new Date()
  },
  {
    name: "Phone Case",
    description: "Durable protective phone case with premium materials",
    price: 2999,
    category: "Electronics",
    stock: 150,
    image_url: "https://via.placeholder.com/400x300?text=Phone+Case",
    rating: 4.3,
    reviews_count: 310,
    created_at: new Date(),
    updated_at: new Date()
  },
  {
    name: "Screen Protector",
    description: "Tempered glass screen protector for mobile phones",
    price: 2001,
    category: "Electronics",
    stock: 200,
    image_url: "https://via.placeholder.com/400x300?text=Screen+Protector",
    rating: 4.1,
    reviews_count: 145,
    created_at: new Date(),
    updated_at: new Date()
  },
  {
    name: "Laptop Stand",
    description: "Adjustable laptop stand for ergonomic working",
    price: 3999,
    category: "Electronics",
    stock: 40,
    image_url: "https://via.placeholder.com/400x300?text=Laptop+Stand",
    rating: 4.4,
    reviews_count: 95,
    created_at: new Date(),
    updated_at: new Date()
  },
  {
    name: "Wireless Mouse",
    description: "Portable wireless mouse with long battery life",
    price: 1999,
    category: "Electronics",
    stock: 75,
    image_url: "https://via.placeholder.com/400x300?text=Wireless+Mouse",
    rating: 4.2,
    reviews_count: 156,
    created_at: new Date(),
    updated_at: new Date()
  },
  {
    name: "Mechanical Keyboard",
    description: "Professional mechanical keyboard with RGB lighting",
    price: 8999,
    category: "Electronics",
    stock: 25,
    image_url: "https://via.placeholder.com/400x300?text=Keyboard",
    rating: 4.6,
    reviews_count: 78,
    created_at: new Date(),
    updated_at: new Date()
  },
  {
    name: "Web Camera",
    description: "HD web camera for video conferencing and streaming",
    price: 4999,
    category: "Electronics",
    stock: 35,
    image_url: "https://via.placeholder.com/400x300?text=Web+Camera",
    rating: 4.3,
    reviews_count: 102,
    created_at: new Date(),
    updated_at: new Date()
  },
  {
    name: "USB Hub",
    description: "Multi-port USB hub with fast data transfer",
    price: 1599,
    category: "Electronics",
    stock: 80,
    image_url: "https://via.placeholder.com/400x300?text=USB+Hub",
    rating: 4.1,
    reviews_count: 89,
    created_at: new Date(),
    updated_at: new Date()
  }
]);

// ===============================================
// CREATE INDEXES FOR BETTER PERFORMANCE
// ===============================================

db.products.createIndex({ name: "text", description: "text", category: "text" });
db.products.createIndex({ category: 1 });
db.products.createIndex({ price: 1 });
db.products.createIndex({ created_at: -1 });

// ===============================================
// VERIFY SETUP
// ===============================================

console.log("Total products inserted:", db.products.countDocuments());
console.log("\nCollections created:");
console.log(db.getCollectionNames());

console.log("\nSample product:");
console.log(db.products.findOne());

// ===============================================
// IMPORTANT NOTES
// ===============================================
/*

1. MongoDB Atlas Connection String Format:
   mongodb+srv://username:password@cluster.mongodb.net/database-name

2. To run this script:
   - Connect to MongoDB Atlas
   - Use: mongo "mongodb+srv://user:pass@cluster.mongodb.net/admin" --eval "cat database/mongodb-setup.js"
   - Or import the data using MongoDB Compass

3. Database: ecommerce_products
   Collections: products, reviews (optional)

4. Environment Variable for Node.js:
   MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/ecommerce_products

5. Fields in Product Document:
   - name (String, required)
   - description (String)
   - price (Number, required)
   - category (String)
   - stock (Number)
   - image_url (String)
   - rating (Number, 0-5)
   - reviews_count (Number)
   - created_at (Date)
   - updated_at (Date)

*/