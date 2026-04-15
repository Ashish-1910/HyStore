<%-- 
    Admin Dashboard Page
    Date: 13 Apr 2026
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - HyStore</title>
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
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .dashboard-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }
        
        .dashboard-header h1 {
            font-size: 2rem;
        }
        
        .stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .stat-card h3 {
            color: #999;
            font-size: 0.9rem;
            margin-bottom: 10px;
        }
        
        .stat-card .value {
            font-size: 2rem;
            color: #667eea;
            font-weight: bold;
        }
        
        .content-section {
            background: white;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
        }
        
        th {
            background: #f5f5f5;
            padding: 12px;
            text-align: left;
            border-bottom: 2px solid #ddd;
        }
        
        td {
            padding: 12px;
            border-bottom: 1px solid #ddd;
        }
        
        tr:hover {
            background: #f9f9f9;
        }
        
        .btn {
            padding: 8px 15px;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin-right: 5px;
        }
        
        .btn-danger {
            background: #ff6b6b;
        }
        
        .btn:hover {
            opacity: 0.9;
        }
        
        .nav-tabs {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
            border-bottom: 2px solid #ddd;
        }
        
        .nav-tabs button {
            padding: 10px 20px;
            background: none;
            border: none;
            cursor: pointer;
            border-bottom: 3px solid transparent;
            font-weight: bold;
            color: #999;
        }
        
        .nav-tabs button.active {
            color: #667eea;
            border-bottom-color: #667eea;
        }
        
        .logout-btn {
            background: #ff6b6b;
            color: white;
            text-decoration: none;
        }

        .quick-links {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header>
        <div class="container">
            <div style="display: flex; justify-content: space-between; align-items: center;">
                <h1>🔐 Admin Dashboard</h1>
                <a href="logout" class="btn logout-btn">Logout</a>
            </div>
        </div>
    </header>
    
    <!-- Main Content -->
    <div class="container">
        <!-- Statistics -->
        <div class="stats">
            <div class="stat-card">
                <h3>Total Products</h3>
                <div class="value">1,250</div>
            </div>
            <div class="stat-card">
                <h3>Total Orders</h3>
                <div class="value">5,430</div>
            </div>
            <div class="stat-card">
                <h3>Total Users</h3>
                <div class="value">3,210</div>
            </div>
            <div class="stat-card">
                <h3>Revenue</h3>
                <div class="value">₹52.5L</div>
            </div>
        </div>
        
        <!-- Quick Links -->
        <div class="quick-links">
            <a href="admin-orders.jsp" class="btn">Manage Orders</a>
            <a href="admin-users.jsp" class="btn">Manage Users</a>
            <a href="admin-coupons.jsp" class="btn">Manage Coupons</a>
            <a href="admin-reviews.jsp" class="btn">Moderate Reviews</a>
        </div>

        <!-- Navigation Tabs -->
        <div class="nav-tabs">
            <button class="active" onclick="showTab('products')">Products</button>
            <button onclick="showTab('orders')">Orders</button>
            <button onclick="showTab('users')">Users</button>
        </div>
        
        <!-- Products Section -->
        <div id="products" class="content-section">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                <h2>Manage Products</h2>
                <div>
                    <button class="btn" onclick="addProduct()">+ Add New Product</button>
                    <button class="btn" onclick="refreshProducts()" style="background: #28a745; margin-left: 10px;">🔄 Refresh</button>
                </div>
            </div>
            
            <!-- Search and Filter Bar -->
            <div style="display: flex; gap: 10px; margin-bottom: 15px; flex-wrap: wrap; padding: 15px; background: #f9f9f9; border-radius: 5px;">
                <input type="text" id="searchProduct" placeholder="🔍 Search by product name..." style="flex: 1; min-width: 200px; padding: 8px 12px; border: 1px solid #ddd; border-radius: 5px;">
                <select id="categoryFilter" style="padding: 8px 12px; border: 1px solid #ddd; border-radius: 5px;">
                    <option value="">📁 All Categories</option>
                    <option value="Electronics">Electronics</option>
                    <option value="Clothing">Clothing</option>
                    <option value="Books">Books</option>
                    <option value="Home">Home & Kitchen</option>
                    <option value="Sports">Sports</option>
                    <option value="Accessories">Accessories</option>
                </select>
                <button class="btn" onclick="filterProducts()" style="background: #667eea;">🔎 Filter</button>
                <button class="btn" onclick="clearFilters()" style="background: #999;">✕ Clear</button>
            </div>
            
            <table style="margin-top: 20px; width: 100%;" id="productsTable">
                <thead>
                    <tr>
                        <th>Product ID</th>
                        <th>Name</th>
                        <th>Category</th>
                        <th>Price</th>
                        <th>Stock</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody id="productsBody">
                    <tr>
                        <td colspan="6" style="text-align: center; padding: 30px;">Loading products...</td>
                    </tr>
                </tbody>
            </table>
        </div>
        
        <!-- Orders Section -->
        <div id="orders" class="content-section" style="display: none;">
            <h2>Recent Orders</h2>
            <table>
                <thead>
                    <tr>
                        <th>Order ID</th>
                        <th>Customer</th>
                        <th>Total Amount</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>#ORD001</td>
                        <td>John Doe</td>
                        <td>₹5,999</td>
                        <td><span style="background: #d4edda; padding: 5px 10px; border-radius: 3px;">Delivered</span></td>
                        <td><button class="btn" onclick="viewOrder('#ORD001')">View</button></td>
                    </tr>
                    <tr>
                        <td>#ORD002</td>
                        <td>Jane Smith</td>
                        <td>₹12,500</td>
                        <td><span style="background: #fff3cd; padding: 5px 10px; border-radius: 3px;">Shipped</span></td>
                        <td><button class="btn" onclick="viewOrder('#ORD002')">View</button></td>
                    </tr>
                </tbody>
            </table>
        </div>
        
        <!-- Users Section -->
        <div id="users" class="content-section" style="display: none;">
            <h2>Manage Users</h2>
            <table>
                <thead>
                    <tr>
                        <th>User ID</th>
                        <th>Username</th>
                        <th>Email</th>
                        <th>Role</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>101</td>
                        <td>john_doe</td>
                        <td>john@example.com</td>
                        <td>Customer</td>
                        <td><button class="btn btn-danger" onclick="deleteUser(101)">Deactivate</button></td>
                    </tr>
                    <tr>
                        <td>102</td>
                        <td>jane_smith</td>
                        <td>jane@example.com</td>
                        <td>Customer</td>
                        <td><button class="btn btn-danger" onclick="deleteUser(102)">Deactivate</button></td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
    
    <script>
        // Load products when page loads
        window.addEventListener('load', function() {
            loadProducts();
        });
        
        function showTab(tabName) {
            // Hide all tabs
            document.querySelectorAll('.content-section').forEach(el => el.style.display = 'none');
            
            // Show selected tab
            document.getElementById(tabName).style.display = 'block';
            
            // Update active button
            document.querySelectorAll('.nav-tabs button').forEach(btn => btn.classList.remove('active'));
            event.target.classList.add('active');
        }
        
        function loadProducts() {
            const tbody = document.getElementById('productsBody');
            
            // Fetch products from Node.js API
            fetch('http://localhost:3000/api/products', {
                method: 'GET',
                headers: {
                    'Accept': 'application/json',
                    'Content-Type': 'application/json'
                }
            })
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Failed to fetch products: ' + response.status);
                    }
                    return response.json();
                })
                .then(apiResponse => {
                    // Clear loading message
                    tbody.innerHTML = '';
                    
                    // Extract products from API response (data.data or data.products)
                    const products = apiResponse.data || apiResponse.products || [];
                    
                    if (!products || products.length === 0) {
                        tbody.innerHTML = '<tr><td colspan="6" style="text-align: center; padding: 30px;">No products found</td></tr>';
                        return;
                    }
                    
                    // Store for filtering
                    allProducts = products;
                    
                    // Populate table with products
                    products.forEach(product => {
                        const row = document.createElement('tr');
                        row.innerHTML = `
                            <td>\${product._id || 'N/A'}</td>
                            <td>\${product.name}</td>
                            <td>\${product.category}</td>
                            <td>₹\${product.price ? product.price.toLocaleString('en-IN') : '0'}</td>
                            <td>\${product.stock}</td>
                            <td>
                                <button class="btn" onclick="editProduct('\${product._id}')">Edit</button>
                                <button class="btn btn-danger" onclick="deleteProduct('\${product._id}')">Delete</button>
                            </td>
                        `;
                        tbody.appendChild(row);
                    });
                })
                .catch(error => {
                    console.error('Error loading products:', error);
                    tbody.innerHTML = '<tr><td colspan="6" style="text-align: center; padding: 30px; color: #ff6b6b;">⚠️ Error loading products: ' + error.message + '</td></tr>';
                });
        }
        
        function refreshProducts() {
            const tbody = document.getElementById('productsBody');
            tbody.innerHTML = '<tr><td colspan="6" style="text-align: center; padding: 30px;">Loading products...</td></tr>';
            loadProducts();
        }
        
        function addProduct() {
            window.location.href = '${pageContext.request.contextPath}/admin-add-product.jsp';
        }
        
        function editProduct(id) {
            window.location.href = '${pageContext.request.contextPath}/admin-edit-product.jsp?productId=' + id;
        }
        
        function deleteProduct(id) {
            if (confirm('Are you sure you want to delete this product?')) {
                fetch('http://localhost:3000/api/products/' + id, {
                    method: 'DELETE'
                })
                .then(response => {
                    if (response.ok) {
                        alert('Product deleted successfully!');
                        refreshProducts();
                    } else {
                        alert('Failed to delete product');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Error deleting product: ' + error.message);
                });
            }
        }
        
        function viewOrder(orderId) {
            alert('View order ' + orderId);
        }
        
        function deleteUser(userId) {
            if (confirm('Deactivate this user?')) {
                alert('User deactivated!');
            }
        }
        

        
        // Store all products for client-side filtering
        let allProducts = [];
        
        function displayProducts(products) {
            const tbody = document.getElementById('productsBody');
            tbody.innerHTML = '';
            
            if (!products || products.length === 0) {
                tbody.innerHTML = '<tr><td colspan="6" style="text-align: center; padding: 30px;">No products found</td></tr>';
                return;
            }
            
            products.forEach(product => {
                const row = document.createElement('tr');
                row.innerHTML = `
                    <td>\${product._id || 'N/A'}</td>
                    <td>\${product.name}</td>
                    <td>\${product.category}</td>
                    <td>₹\${product.price ? product.price.toLocaleString('en-IN') : '0'}</td>
                    <td>\${product.stock}</td>
                    <td>
                        <button class="btn" onclick="editProduct('\${product._id}')">Edit</button>
                        <button class="btn btn-danger" onclick="deleteProduct('\${product._id}')">Delete</button>
                    </td>
                `;
                tbody.appendChild(row);
            });
        }
        
        function filterProducts() {
            const searchTerm = document.getElementById('searchProduct').value.toLowerCase();
            const categoryTerm = document.getElementById('categoryFilter').value;
            
            const filtered = allProducts.filter(product => {
                const nameMatch = product.name.toLowerCase().includes(searchTerm);
                const categoryMatch = categoryTerm === '' || product.category === categoryTerm;
                return nameMatch && categoryMatch;
            });
            
            displayProducts(filtered);
        }
        
        function clearFilters() {
            document.getElementById('searchProduct').value = '';
            document.getElementById('categoryFilter').value = '';
            displayProducts(allProducts);
        }
        
        // Add event listeners for real-time search
        document.addEventListener('DOMContentLoaded', function() {
            const searchInput = document.getElementById('searchProduct');
            const categorySelect = document.getElementById('categoryFilter');
            
            if (searchInput) {
                searchInput.addEventListener('keyup', filterProducts);
            }
            if (categorySelect) {
                categorySelect.addEventListener('change', filterProducts);
            }
        });
    </script>
</body>
</html>
