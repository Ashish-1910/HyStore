<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.ecommerce.models.CartItem" %>
<%
    List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
    Map<String, Object> appliedCoupon = (Map<String, Object>) session.getAttribute("appliedCoupon");
    if (cart == null || cart.isEmpty()) {
        response.sendRedirect("cart.jsp");
        return;
    }

    double subtotal = 0;
    for (CartItem item : cart) subtotal += item.getSubtotal();
    double tax = subtotal * 0.10;
    double discount = 0;
    String couponCode = "";
    if (appliedCoupon != null) {
        couponCode = String.valueOf(appliedCoupon.get("code"));
        Object amount = appliedCoupon.get("discountAmount");
        discount = amount instanceof Number ? ((Number) amount).doubleValue() : 0;
    }
    double finalTotal = Math.max(subtotal + tax - discount, 0);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout - HyStore</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f5f5f5; }
        .container { max-width: 1000px; margin: 0 auto; padding: 32px 20px; }
        .layout { display: grid; grid-template-columns: 1fr 320px; gap: 20px; }
        .card { background: white; border-radius: 10px; padding: 20px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
        .field { margin-bottom: 14px; }
        .field input, .field textarea, .field select { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 6px; }
        .btn { padding: 12px 18px; border: none; border-radius: 6px; cursor: pointer; }
        .btn-primary { background: #667eea; color: white; width: 100%; }
        @media (max-width: 900px) { .layout { grid-template-columns: 1fr; } }
    </style>
</head>
<body>
    <div class="container">
        <h1 style="margin-bottom:20px;">Checkout</h1>
        <% if (request.getAttribute("error") != null) { %>
            <div class="card" style="margin-bottom:16px; color:#dc3545;"><%= request.getAttribute("error") %></div>
        <% } %>
        <form action="order" method="POST" class="layout">
            <div class="card">
                <div class="field">
                    <label>Shipping Address</label>
                    <input type="text" name="shippingAddress" placeholder="123 Main Street, City, State, Postal Code" required>
                </div>
                <div class="field">
                    <label>Payment Method</label>
                    <select name="paymentMethod">
                        <option value="Credit Card">Credit Card</option>
                        <option value="Debit Card">Debit Card</option>
                        <option value="UPI">UPI</option>
                        <option value="Cash on Delivery">Cash on Delivery</option>
                    </select>
                </div>
                <div class="field">
                    <label>Order Notes</label>
                    <textarea name="notes" rows="5" placeholder="Any delivery instructions?"></textarea>
                </div>
                <button class="btn btn-primary" type="submit">Place Order</button>
            </div>
            <div class="card">
                <h2 style="margin-bottom:14px;">Order Summary</h2>
                <div style="display:flex; justify-content:space-between; margin-bottom:8px;"><span>Items</span><span><%= cart.size() %></span></div>
                <div style="display:flex; justify-content:space-between; margin-bottom:8px;"><span>Subtotal</span><span>₹<%= subtotal %></span></div>
                <div style="display:flex; justify-content:space-between; margin-bottom:8px;"><span>Tax</span><span>₹<%= tax %></span></div>
                <div style="display:flex; justify-content:space-between; margin-bottom:8px;"><span>Coupon <%= couponCode.isEmpty() ? "" : "(" + couponCode + ")" %></span><span>- ₹<%= discount %></span></div>
                <div style="display:flex; justify-content:space-between; font-weight:700; font-size:1.1rem;"><span>Total</span><span>₹<%= finalTotal %></span></div>
            </div>
        </form>
    </div>
</body>
</html>
