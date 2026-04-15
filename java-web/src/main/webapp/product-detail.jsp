<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product Details - HyStore</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f5f5f5; }
        header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 1rem 0; }
        nav { display: flex; justify-content: space-between; max-width: 1200px; margin: 0 auto; padding: 0 20px; }
        nav a { color: white; text-decoration: none; margin-left: 16px; }
        .container { max-width: 1000px; margin: 0 auto; padding: 32px 20px; }
        .card { background: white; border-radius: 12px; padding: 24px; box-shadow: 0 2px 10px rgba(0,0,0,0.08); }
        .product-layout { display: grid; grid-template-columns: 1fr 1fr; gap: 24px; }
        .image { min-height: 320px; border-radius: 10px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); display: grid; place-items: center; color: white; font-size: 3rem; }
        .actions { display: flex; gap: 10px; flex-wrap: wrap; margin-top: 16px; }
        .btn { padding: 12px 18px; border: none; border-radius: 8px; cursor: pointer; }
        .btn-primary { background: #667eea; color: white; }
        .btn-success { background: #28a745; color: white; }
        .btn-muted { background: #f0f0f0; color: #333; }
        #reviewsSection { margin-top: 24px; }
        @media (max-width: 768px) { .product-layout { grid-template-columns: 1fr; } }
    </style>
</head>
<body>
    <header>
        <nav>
            <div style="font-size:1.5rem; font-weight:700;">HyStore</div>
            <div>
                <a href="index.jsp">Home</a>
                <a href="products.jsp">Products</a>
                <a href="cart.jsp">Cart</a>
                <a href="wishlist.jsp">Wishlist</a>
            </div>
        </nav>
    </header>

    <div class="container">
        <div id="loadingMessage" class="card">Loading product details...</div>
        <div id="detailContent" class="card" style="display:none;">
            <div class="product-layout">
                <div class="image">📦</div>
                <div>
                    <h1 id="prodName">Loading...</h1>
                    <p id="prodCategory" style="color:#666; margin:8px 0;"></p>
                    <div id="prodPrice" style="font-size:1.5rem; color:#667eea; font-weight:700; margin-bottom:10px;"></div>
                    <div id="prodRating" style="margin-bottom:10px;">No ratings yet</div>
                    <p id="prodDescription" style="line-height:1.6; color:#444;"></p>
                    <div style="margin-top:14px;">Stock: <span id="prodStock"></span></div>
                    <div style="margin-top:14px;">
                        Quantity:
                        <input type="number" id="quantity" min="1" value="1" style="padding:8px; width:70px;">
                    </div>
                    <div class="actions">
                        <button class="btn btn-success" id="addToCartBtn" onclick="addToCart()">Add to Cart</button>
                        <button class="btn btn-muted" onclick="addToWishlist()">Wishlist</button>
                        <button class="btn btn-primary" onclick="location.href='products.jsp'">Back</button>
                    </div>
                </div>
            </div>

            <div id="reviewsSection">
                <h2 style="margin-bottom:12px;">Customer Reviews</h2>
                <div id="reviewsList" style="display:grid; gap:12px; margin-bottom:20px;"></div>
                <% if (session.getAttribute("userId") != null) { %>
                <form id="reviewForm" onsubmit="submitReview(event)" style="display:grid; gap:12px;">
                    <select id="rating" required style="padding:10px;">
                        <option value="">Select rating</option>
                        <option value="5">5 - Excellent</option>
                        <option value="4">4 - Good</option>
                        <option value="3">3 - Average</option>
                        <option value="2">2 - Poor</option>
                        <option value="1">1 - Bad</option>
                    </select>
                    <textarea id="reviewText" rows="4" placeholder="Write your review" style="padding:10px;"></textarea>
                    <button class="btn btn-primary" type="submit" style="max-width:220px;">Submit Review</button>
                </form>
                <% } else { %>
                <p>Please <a href="login.jsp">login</a> to submit a review.</p>
                <% } %>
            </div>
        </div>
    </div>

    <script>
        let currentProduct = null;

        document.addEventListener('DOMContentLoaded', function() {
            const productId = new URLSearchParams(window.location.search).get('id');
            if (!productId) {
                document.getElementById('loadingMessage').textContent = 'Product ID not found.';
                return;
            }
            loadProductDetails(productId);
        });

        function loadProductDetails(id) {
            fetch('${pageContext.request.contextPath}/getProductDetails.jsp?productId=' + id)
                .then(response => response.json())
                .then(apiResponse => {
                    if (apiResponse.error) throw new Error(apiResponse.error);

                    const product = apiResponse.data || apiResponse;
                    currentProduct = product;
                    document.getElementById('prodName').textContent = product.name;
                    document.getElementById('prodCategory').textContent = 'Category: ' + (product.category || 'General');
                    document.getElementById('prodPrice').textContent = '₹' + (product.price ? product.price.toLocaleString('en-IN') : '0');
                    document.getElementById('prodDescription').textContent = product.description || 'No description available.';
                    document.getElementById('prodStock').textContent = product.stock > 0 ? (product.stock + ' available') : 'Out of stock';
                    document.getElementById('prodRating').textContent = '⭐ ' + (product.rating || 0) + '/5 (' + (product.reviews_count || 0) + ' reviews)';

                    if (product.stock <= 0) {
                        document.getElementById('addToCartBtn').disabled = true;
                        document.getElementById('addToCartBtn').textContent = 'Out of Stock';
                    }

                    document.getElementById('loadingMessage').style.display = 'none';
                    document.getElementById('detailContent').style.display = 'block';
                    loadReviews(id);
                })
                .catch(error => {
                    document.getElementById('loadingMessage').textContent = 'Error loading product details: ' + error.message;
                });
        }

        function addToCart() {
            if (!currentProduct) return;
            const formData = new URLSearchParams();
            formData.append('action', 'add');
            formData.append('productId', currentProduct._id);
            formData.append('name', currentProduct.name);
            formData.append('price', currentProduct.price);
            formData.append('quantity', document.getElementById('quantity').value || 1);
            formData.append('imageUrl', currentProduct.image_url || '');

            fetch('${pageContext.request.contextPath}/cart', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'X-Requested-With': 'XMLHttpRequest'
                },
                body: formData
            })
            .then(response => {
                if (response.ok) alert('Product added to cart.');
                else alert('Failed to add product to cart.');
            })
            .catch(() => alert('Error adding product to cart.'));
        }

        function addToWishlist() {
            if (!currentProduct) return;
            const formData = new URLSearchParams();
            formData.append('productId', currentProduct._id);
            formData.append('productName', currentProduct.name);
            formData.append('category', currentProduct.category || '');
            formData.append('price', currentProduct.price || 0);
            formData.append('imageUrl', currentProduct.image_url || '');

            fetch('${pageContext.request.contextPath}/toggleWishlist.jsp', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: formData
            })
            .then(response => response.json())
            .then(data => alert(data.message || 'Wishlist updated'))
            .catch(() => alert('Error updating wishlist.'));
        }

        function loadReviews(productId) {
            fetch('${pageContext.request.contextPath}/getReviews.jsp?productId=' + productId)
                .then(response => response.json())
                .then(data => {
                    const list = document.getElementById('reviewsList');
                    const reviews = data.reviews || [];
                    if (!reviews.length) {
                        list.innerHTML = '<div style="padding:16px; background:#f9f9f9; border-radius:8px;">No approved reviews yet.</div>';
                        return;
                    }

                    list.innerHTML = reviews.map(review => `
                        <div style="padding:16px; border:1px solid #eee; border-radius:8px;">
                            <div style="font-weight:700; margin-bottom:4px;">${review.full_name} · ${'⭐'.repeat(review.rating)}</div>
                            <div style="color:#666; margin-bottom:8px;">${review.created_at}</div>
                            <div>${review.review_text || ''}</div>
                        </div>
                    `).join('');
                })
                .catch(() => {
                    document.getElementById('reviewsList').innerHTML = '<div>Error loading reviews.</div>';
                });
        }

        function submitReview(event) {
            event.preventDefault();
            if (!currentProduct) return;

            const formData = new URLSearchParams();
            formData.append('productId', currentProduct._id);
            formData.append('rating', document.getElementById('rating').value);
            formData.append('reviewText', document.getElementById('reviewText').value);

            fetch('${pageContext.request.contextPath}/submitReview.jsp', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                alert(data.message || 'Review submitted.');
                if (data.success) document.getElementById('reviewForm').reset();
            })
            .catch(() => alert('Error submitting review.'));
        }
    </script>
</body>
</html>
