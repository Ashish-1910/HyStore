// ===============================================
// JAVA ORDER SERVLET
// Save as: src/com/ecommerce/servlets/OrderServlet.java
// ===============================================

package com.ecommerce.servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;
import java.math.BigDecimal;
import java.util.*;

import com.ecommerce.db.DatabaseConnection;
import com.ecommerce.models.CartItem;

public class OrderServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("userId") == null) {
            request.setAttribute("error", "Please login to place order!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }
        
        int userId = (Integer) session.getAttribute("userId");
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            request.setAttribute("error", "Your cart is empty.");
            request.getRequestDispatcher("cart.jsp").forward(request, response);
            return;
        }
        
        // Get order details from request
        String shippingAddress = request.getParameter("shippingAddress");
        String paymentMethod = request.getParameter("paymentMethod");
        String notes = request.getParameter("notes");
        
        // Validation
        if (shippingAddress == null || shippingAddress.trim().isEmpty()) {
            request.setAttribute("error", "Shipping address is required!");
            request.getRequestDispatcher("check-out.jsp").forward(request, response);
            return;
        }
        
        try {
            Connection conn = DatabaseConnection.getConnection();
            
            // Start transaction
            conn.setAutoCommit(false);
            
            // Insert order
            BigDecimal subtotal = BigDecimal.ZERO;
            for (CartItem item : cart) {
                subtotal = subtotal.add(BigDecimal.valueOf(item.getSubtotal()));
            }
            BigDecimal tax = subtotal.multiply(BigDecimal.valueOf(0.10));
            BigDecimal discountAmount = BigDecimal.ZERO;

            Map<String, Object> appliedCoupon = (Map<String, Object>) session.getAttribute("appliedCoupon");
            if (appliedCoupon != null) {
                Object amount = appliedCoupon.get("discountAmount");
                if (amount instanceof Number) {
                    discountAmount = BigDecimal.valueOf(((Number) amount).doubleValue());
                }
            }

            BigDecimal totalAmount = subtotal.add(tax).subtract(discountAmount);
            if (totalAmount.compareTo(BigDecimal.ZERO) < 0) {
                totalAmount = BigDecimal.ZERO;
            }

            String orderQuery = "INSERT INTO orders (user_id, total_amount, status, shipping_address, payment_method, notes) " +
                              "VALUES (?, ?, 'pending', ?, ?, ?)";
            PreparedStatement orderStmt = conn.prepareStatement(orderQuery, Statement.RETURN_GENERATED_KEYS);
            orderStmt.setInt(1, userId);
            orderStmt.setBigDecimal(2, totalAmount);
            orderStmt.setString(3, shippingAddress);
            orderStmt.setString(4, paymentMethod != null ? paymentMethod : "Credit Card");
            orderStmt.setString(5, notes);
            
            int result = orderStmt.executeUpdate();
            
            if (result > 0) {
                // Get the generated order ID
                ResultSet generatedKeys = orderStmt.getGeneratedKeys();
                int orderId = 0;
                
                if (generatedKeys.next()) {
                    orderId = generatedKeys.getInt(1);
                }
                
                String itemQuery = "INSERT INTO order_items (order_id, product_id, product_name, quantity, price, subtotal) VALUES (?, ?, ?, ?, ?, ?)";
                PreparedStatement itemStmt = conn.prepareStatement(itemQuery);
                for (CartItem item : cart) {
                    itemStmt.setInt(1, orderId);
                    itemStmt.setString(2, item.getProductId());
                    itemStmt.setString(3, item.getProductName());
                    itemStmt.setInt(4, item.getQuantity());
                    itemStmt.setBigDecimal(5, BigDecimal.valueOf(item.getPrice()));
                    itemStmt.setBigDecimal(6, BigDecimal.valueOf(item.getSubtotal()));
                    itemStmt.addBatch();
                }
                itemStmt.executeBatch();
                itemStmt.close();

                if (appliedCoupon != null && appliedCoupon.get("couponId") != null) {
                    PreparedStatement couponStmt = conn.prepareStatement(
                        "INSERT INTO coupon_usages (coupon_id, user_id, order_id, discount_amount) VALUES (?, ?, ?, ?)"
                    );
                    couponStmt.setInt(1, Integer.parseInt(appliedCoupon.get("couponId").toString()));
                    couponStmt.setInt(2, userId);
                    couponStmt.setInt(3, orderId);
                    couponStmt.setBigDecimal(4, discountAmount);
                    couponStmt.executeUpdate();
                    couponStmt.close();
                }
                
                conn.commit();
                conn.setAutoCommit(true);
                
                session.removeAttribute("cart");
                session.removeAttribute("appliedCoupon");
                request.setAttribute("success", "Order placed successfully! Order ID: " + orderId);
                request.setAttribute("orderId", orderId);
                request.setAttribute("finalAmount", totalAmount);
                request.getRequestDispatcher("order-confirmation.jsp").forward(request, response);
            } else {
                conn.rollback();
                conn.setAutoCommit(true);
                
                request.setAttribute("error", "Failed to place order!");
                request.getRequestDispatcher("check-out.jsp").forward(request, response);
            }
            
            orderStmt.close();
            conn.close();
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            request.getRequestDispatcher("check-out.jsp").forward(request, response);
        }
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        int userId = (Integer) session.getAttribute("userId");
        
        String action = request.getParameter("action");
        
        try {
            if ("checkout".equals(action)) {
                request.getRequestDispatcher("check-out.jsp").forward(request, response);
                return;
            }
            
            request.getRequestDispatcher("dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading page: " + e.getMessage());
            request.getRequestDispatcher("dashboard.jsp").forward(request, response);
        }
    }
}
