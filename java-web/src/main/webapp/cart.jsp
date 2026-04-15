<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.ecommerce.models.CartItem" %>
<%
    List<CartItem> sessionCart = (List<CartItem>) session.getAttribute("cart");
    Map<String, Object> appliedCoupon = (Map<String, Object>) session.getAttribute("appliedCoupon");
    double couponDiscount = 0;
    String couponCode = "";
    if (appliedCoupon != null) {
        couponCode = String.valueOf(appliedCoupon.get("code"));
        Object amount = appliedCoupon.get("discountAmount");
        couponDiscount = amount instanceof Number ? ((Number) amount).doubleValue() : 0;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shopping Cart - HyStore</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f5f5f5; }
        .container { max-width: 1100px; margin: 0 auto; padding: 32px 20px; }
        .layout { display: grid; grid-template-columns: 1fr 320px; gap: 20px; }
        .card { background: white; border-radius: 10px; padding: 20px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 12px; border-bottom: 1px solid #eee; text-align: left; }
        .btn { padding: 10px 14px; border: none; border-radius: 6px; cursor: pointer; }
        .btn-danger { background: #dc3545; color: white; }
        .btn-primary { background: #667eea; color: white; width: 100%; margin-top: 10px; }
        .btn-muted { background: #f0f0f0; color: #333; width: 100%; margin-top: 10px; }
        @media (max-width: 900px) { .layout { grid-template-columns: 1fr; } }
    </style>
    <script>const contextPath = '<%= request.getContextPath() %>';</script>
</head>
<body>
    <div class="container">
        <h1 style="margin-bottom:20px;">Your Shopping Cart</h1>
        <% if (sessionCart == null || sessionCart.isEmpty()) { %>
            <div class="card">
                <p>Your cart is empty.</p>
                <a href="products.jsp">Continue Shopping</a>
            </div>
        <% } else { %>
            <div class="layout">
                <div class="card">
                    <table>
                        <thead>
                            <tr>
                                <th>Product</th>
                                <th>Price</th>
                                <th>Quantity</th>
                                <th>Subtotal</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody id="cartItems"></tbody>
                    </table>
                </div>
                <div class="card">
                    <h2 style="margin-bottom:12px;">Order Summary</h2>
                    <div style="display:flex; justify-content:space-between; margin-bottom:8px;"><span>Items</span><span id="itemsCount"><%= sessionCart.size() %></span></div>
                    <div style="display:flex; justify-content:space-between; margin-bottom:8px;"><span>Subtotal</span><span id="subtotal">0.00</span></div>
                    <div style="display:flex; justify-content:space-between; margin-bottom:8px;"><span>Tax (10%)</span><span id="tax">0.00</span></div>
                    <div style="display:flex; justify-content:space-between; margin-bottom:8px;"><span>Coupon Discount</span><span id="discount"><%= couponDiscount %></span></div>
                    <div style="display:flex; justify-content:space-between; margin-bottom:14px; font-weight:700;"><span>Total</span><span id="total">0.00</span></div>
                    <input type="text" id="couponCode" value="<%= couponCode %>" placeholder="Enter coupon code" style="padding:10px; width:100%; border:1px solid #ddd; border-radius:6px;">
                    <button class="btn btn-muted" onclick="applyCoupon()">Apply Coupon</button>
                    <div id="couponMessage" style="margin-top:8px; font-size:0.9rem; color:#28a745;"><%= couponCode.isEmpty() ? "" : ("Applied coupon: " + couponCode) %></div>
                    <button class="btn btn-primary" onclick="proceedToCheckout()">Proceed to Checkout</button>
                    <button class="btn btn-muted" onclick="location.href='products.jsp'">Continue Shopping</button>
                </div>
            </div>
        <% } %>
    </div>

    <script>
        let cartItems = [
            <%
                if (sessionCart != null) {
                    for (int i = 0; i < sessionCart.size(); i++) {
                        CartItem item = sessionCart.get(i);
            %>
            {
                id: '<%= item.getProductId() %>',
                name: '<%= (item.getProductName() != null ? item.getProductName().replace("'", "\\'") : "Product") %>',
                price: <%= item.getPrice() %>,
                quantity: <%= item.getQuantity() %>
            }<%= i < sessionCart.size() - 1 ? "," : "" %>
            <%
                    }
                }
            %>
        ];
        let appliedDiscount = <%= couponDiscount %>;

        function renderCart() {
            const tbody = document.getElementById('cartItems');
            if (!tbody) return;
            tbody.innerHTML = cartItems.map(item => `
                <tr>
                    <td>\${item.name}</td>
                    <td>₹\${item.price.toLocaleString('en-IN')}</td>
                    <td>
                        <button onclick="changeQuantity('\${item.id}', -1)">-</button>
                        <span style="padding:0 10px;">\${item.quantity}</span>
                        <button onclick="changeQuantity('\${item.id}', 1)">+</button>
                    </td>
                    <td>₹\${(item.price * item.quantity).toLocaleString('en-IN')}</td>
                    <td><button class="btn btn-danger" onclick="removeItem('\${item.id}')">Remove</button></td>
                </tr>
            `).join('');
            updateSummary();
        }

        function updateSummary() {
            const subtotal = cartItems.reduce((sum, item) => sum + (item.price * item.quantity), 0);
            const tax = subtotal * 0.10;
            const total = Math.max(subtotal + tax - appliedDiscount, 0);
            document.getElementById('subtotal').textContent = '₹' + subtotal.toLocaleString('en-IN');
            document.getElementById('tax').textContent = '₹' + tax.toLocaleString('en-IN');
            document.getElementById('discount').textContent = '₹' + appliedDiscount.toLocaleString('en-IN');
            document.getElementById('total').textContent = '₹' + total.toLocaleString('en-IN');
            document.getElementById('itemsCount').textContent = cartItems.length;
        }

        function changeQuantity(productId, delta) {
            const item = cartItems.find(i => i.id === productId);
            if (!item) return;
            const newQuantity = item.quantity + delta;
            if (newQuantity < 1) return;

            const formData = new URLSearchParams();
            formData.append('action', 'update');
            formData.append('productId', productId);
            formData.append('quantity', newQuantity);

            fetch(contextPath + '/cart', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: formData
            }).then(() => {
                item.quantity = newQuantity;
                renderCart();
            });
        }

        function removeItem(productId) {
            const formData = new URLSearchParams();
            formData.append('action', 'remove');
            formData.append('productId', productId);

            fetch(contextPath + '/cart', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: formData
            }).then(() => location.reload());
        }

        function applyCoupon() {
            const coupon = document.getElementById('couponCode').value.trim().toUpperCase();
            const subtotal = cartItems.reduce((sum, item) => sum + (item.price * item.quantity), 0);
            fetch(contextPath + '/applyCoupon.jsp?code=' + encodeURIComponent(coupon) + '&subtotal=' + subtotal)
                .then(response => response.json())
                .then(data => {
                    appliedDiscount = data.success ? (data.discountAmount || 0) : 0;
                    document.getElementById('couponMessage').textContent = data.message;
                    updateSummary();
                })
                .catch(() => alert('Error applying coupon.'));
        }

        function proceedToCheckout() {
            location.href = contextPath + '/order?action=checkout';
        }

        renderCart();
    </script>
</body>
</html>
