<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Products - HyStore</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f5f5f5; }
        header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 1rem 0; }
        nav { display: flex; justify-content: space-between; align-items: center; max-width: 1200px; margin: 0 auto; padding: 0 20px; flex-wrap: wrap; gap: 1rem; }
        nav ul { list-style: none; display: flex; gap: 1rem; flex-wrap: wrap; }
        nav a { color: white; text-decoration: none; }
        .container { max-width: 1200px; margin: 0 auto; padding: 32px 20px; }
        .filters { background: white; padding: 16px; border-radius: 10px; display: flex; gap: 10px; flex-wrap: wrap; margin-bottom: 20px; }
        .filters input, .filters select, .filters button { padding: 10px 12px; border: 1px solid #ddd; border-radius: 6px; }
        .filters button { background: #667eea; color: white; cursor: pointer; }
        .products-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(260px, 1fr)); gap: 18px; }
        .product-card { background: white; border-radius: 10px; padding: 18px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
        .product-image { height: 180px; border-radius: 8px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); display: grid; place-items: center; color: white; font-size: 2rem; margin-bottom: 12px; }
        .product-name { font-size: 1.1rem; font-weight: 700; margin-bottom: 6px; }
        .product-category { color: #666; margin-bottom: 6px; }
        .product-price { color: #667eea; font-size: 1.2rem; font-weight: 700; margin-bottom: 6px; }
        .product-actions { display: grid; grid-template-columns: repeat(3, 1fr); gap: 8px; margin-top: 12px; }
        .btn { display: inline-block; padding: 10px; border: none; border-radius: 6px; text-align: center; cursor: pointer; text-decoration: none; }
        .btn-view { background: #667eea; color: white; }
        .btn-cart { background: #28a745; color: white; }
        .btn-wish { background: #f0f0f0; color: #333; }
    </style>
</head>
<body>
    <header>
        <nav>
            <span style="font-size:1.5rem; font-weight:700;">HyStore</span>
            <ul>
                <li><a href="index.jsp">Home</a></li>
                <li><a href="products.jsp">Products</a></li>
                <li><a href="cart.jsp">Cart</a></li>
                <li><a href="wishlist.jsp">Wishlist</a></li>
                <%
                    String username = (String) session.getAttribute("username");
                    if (username != null) {
                %>
                <li><a href="dashboard.jsp">Dashboard</a></li>
                <li><a href="logout">Logout (<%= username %>)</a></li>
                <% } else { %>
                <li><a href="login.jsp">Login</a></li>
                <li><a href="register.jsp">Register</a></li>
                <% } %>
            </ul>
        </nav>
    </header>

    <div class="container">
        <h1 style="margin-bottom:20px;">Our Products</h1>
        <div class="filters">
            <input type="text" id="searchInput" placeholder="Search products by name">
            <select id="categoryFilter">
                <option value="">All Categories</option>
                <option value="Electronics">Electronics</option>
                <option value="Clothing">Clothing</option>
                <option value="Books">Books</option>
                <option value="Home">Home</option>
                <option value="Sports">Sports</option>
                <option value="Accessories">Accessories</option>
            </select>
            <button onclick="applyFilters()">Apply</button>
            <button onclick="clearFilters()">Clear</button>
        </div>
        <div id="productsGrid" class="products-grid"></div>
    </div>

    <script>
        let allProducts = [];

        document.addEventListener('DOMContentLoaded', loadProducts);

        function loadProducts() {
            fetch('http://localhost:3000/api/products')
                .then(response => response.json())
                .then(apiResponse => {
                    allProducts = apiResponse.data || apiResponse.products || [];
                    renderProducts(allProducts);
                })
                .catch(() => {
                    document.getElementById('productsGrid').innerHTML = '<div style="background:white; padding:20px; border-radius:10px;">Error loading products.</div>';
                });
        }

        function renderProducts(products) {
            const grid = document.getElementById('productsGrid');
            if (!products.length) {
                grid.innerHTML = '<div style="background:white; padding:20px; border-radius:10px;">No products found.</div>';
                return;
            }

            grid.innerHTML = products.map(product => `
                <div class="product-card">
                    <div class="product-image">📦</div>
                    <div class="product-name">\${product.name}</div>
                    <div class="product-category">\${product.category || 'General'}</div>
                    <div>\${product.description || 'High-quality product'}</div>
                    <div class="product-price">₹\${product.price ? product.price.toLocaleString('en-IN') : '0'}</div>
                    <div>Stock: \${product.stock > 0 ? product.stock : 'Out of stock'}</div>
                    <div class="product-actions">
                        <a href="product-detail.jsp?id=\${product._id}" class="btn btn-view">View</a>
                        <button class="btn btn-cart">Cart</button>
                        <button class="btn btn-wish">Wish</button>
                    </div>
                </div>
            `).join('');

            grid.querySelectorAll('.btn-cart').forEach((button, index) => {
                const product = products[index];
                button.onclick = () => addToCart(product._id, product.name, product.price);
            });

            grid.querySelectorAll('.btn-wish').forEach((button, index) => {
                const product = products[index];
                button.onclick = () => toggleWishlist(product);
            });
        }

        function applyFilters() {
            const search = document.getElementById('searchInput').value.toLowerCase();
            const category = document.getElementById('categoryFilter').value;
            const filtered = allProducts.filter(product => {
                const searchMatch = !search || product.name.toLowerCase().includes(search);
                const categoryMatch = !category || product.category === category;
                return searchMatch && categoryMatch;
            });
            renderProducts(filtered);
        }

        function clearFilters() {
            document.getElementById('searchInput').value = '';
            document.getElementById('categoryFilter').value = '';
            renderProducts(allProducts);
        }

        function addToCart(id, name, price) {
            const formData = new URLSearchParams();
            formData.append('action', 'add');
            formData.append('productId', id);
            formData.append('name', name);
            formData.append('price', price);
            formData.append('quantity', 1);

            fetch('${pageContext.request.contextPath}/cart', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'X-Requested-With': 'XMLHttpRequest'
                },
                body: formData
            })
            .then(response => {
                if (response.ok) {
                    alert('Product added to cart.');
                } else {
                    alert('Failed to add product to cart.');
                }
            })
            .catch(() => alert('Error adding product to cart.'));
        }

        function toggleWishlist(product) {
            const formData = new URLSearchParams();
            formData.append('productId', product._id);
            formData.append('productName', product.name);
            formData.append('category', product.category || '');
            formData.append('price', product.price || 0);
            formData.append('imageUrl', product.image_url || '');

            fetch('${pageContext.request.contextPath}/toggleWishlist.jsp', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: formData
            })
            .then(response => response.json())
            .then(data => alert(data.message || 'Wishlist updated'))
            .catch(() => alert('Unable to update wishlist.'));
        }
    </script>
</body>
</html>
