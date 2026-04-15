<%-- 
    Admin Add Product Page
    Date: 14 Apr 2026
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Product - HyStore Admin</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f5f5;
        }
        
        header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 1rem;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .header-content {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .header-content h1 {
            font-size: 1.8rem;
        }
        
        .logout-btn {
            background: #ff6b6b;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
        }
        
        .logout-btn:hover {
            background: #ff5252;
        }
        
        .container {
            max-width: 800px;
            margin: 30px auto;
            padding: 20px;
        }
        
        .form-card {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        
        .form-card h2 {
            color: #667eea;
            margin-bottom: 10px;
            font-size: 1.8rem;
        }
        
        .form-subtitle {
            color: #999;
            margin-bottom: 25px;
            font-size: 0.9rem;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 500;
            font-size: 0.95rem;
        }
        
        input[type="text"],
        input[type="number"],
        input[type="url"],
        select,
        textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 1rem;
            font-family: inherit;
        }
        
        input[type="text"]:focus,
        input[type="number"]:focus,
        input[type="url"]:focus,
        select:focus,
        textarea:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        textarea {
            resize: vertical;
            min-height: 100px;
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        
        .error {
            background: #f8d7da;
            color: #721c24;
            padding: 12px;
            border-radius: 5px;
            margin-bottom: 20px;
            border: 1px solid #f5c6cb;
        }
        
        .success {
            background: #d4edda;
            color: #155724;
            padding: 12px;
            border-radius: 5px;
            margin-bottom: 20px;
            border: 1px solid #c3e6cb;
        }
        
        .form-actions {
            display: flex;
            gap: 10px;
            margin-top: 30px;
        }
        
        .btn {
            padding: 12px 30px;
            border: none;
            border-radius: 5px;
            font-size: 1rem;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
            display: inline-block;
            text-decoration: none;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            flex: 1;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.3);
        }
        
        .btn-secondary {
            background: #e9ecef;
            color: #333;
            flex: 1;
        }
        
        .btn-secondary:hover {
            background: #dee2e6;
        }
        
        .required {
            color: #ff6b6b;
        }
        
        .hint {
            font-size: 0.85rem;
            color: #999;
            margin-top: 5px;
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header>
        <div class="header-content">
            <h1>🔐 Admin Panel</h1>
            <a href="logout" class="logout-btn">Logout</a>
        </div>
    </header>
    
    <!-- Main Content -->
    <div class="container">
        <div class="form-card">
            <h2>➕ Add New Product</h2>
            <div class="form-subtitle">Fill in the product details below</div>
            
            <% if (request.getAttribute("error") != null) { %>
                <div class="error">
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>
            
            <% if (request.getAttribute("success") != null) { %>
                <div class="success">
                    <%= request.getAttribute("success") %>
                </div>
            <% } %>
            
            <form action="admin-products" method="POST">
                <input type="hidden" name="action" value="add">
                
                <!-- Product Name -->
                <div class="form-group">
                    <label for="name">Product Name <span class="required">*</span></label>
                    <input type="text" id="name" name="name" placeholder="e.g., Wireless Headphones" required>
                </div>
                
                <!-- Category and Price Row -->
                <div class="form-row">
                    <div class="form-group">
                        <label for="category">Category <span class="required">*</span></label>
                        <select id="category" name="category" required>
                            <option value="">-- Select Category --</option>
                            <option value="Electronics">Electronics</option>
                            <option value="Clothing">Clothing</option>
                            <option value="Books">Books</option>
                            <option value="Home">Home & Kitchen</option>
                            <option value="Sports">Sports</option>
                            <option value="Accessories">Accessories</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="price">Price (₹) <span class="required">*</span></label>
                        <input type="number" id="price" name="price" placeholder="e.g., 2999" min="1" step="0.01" required>
                    </div>
                </div>
                
                <!-- Stock Row -->
                <div class="form-row">
                    <div class="form-group">
                        <label for="stock">Stock Quantity <span class="required">*</span></label>
                        <input type="number" id="stock" name="stock" placeholder="e.g., 50" min="0" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="imageUrl">Image URL <span class="required">*</span></label>
                        <input type="url" id="imageUrl" name="imageUrl" placeholder="https://example.com/image.jpg" required>
                        <div class="hint">Provide full URL to product image</div>
                    </div>
                </div>
                
                <!-- Description -->
                <div class="form-group">
                    <label for="description">Description <span class="required">*</span></label>
                    <textarea id="description" name="description" placeholder="Enter product description..." required></textarea>
                    <div class="hint">Provide detailed product description</div>
                </div>
                
                <!-- Form Actions -->
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">✅ Add Product</button>
                    <a href="admin-dashboard.jsp" class="btn btn-secondary">← Back to Dashboard</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
