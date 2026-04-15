<%@page contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="org.json.*" %>
<%@ page import="com.ecommerce.db.DatabaseConnection" %>
<%
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        try {
            Connection conn = DatabaseConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(
                "INSERT INTO coupons (code, description, discount_type, discount_value, min_order_amount, is_active) VALUES (?, ?, ?, ?, ?, TRUE) " +
                "ON DUPLICATE KEY UPDATE description = VALUES(description), discount_type = VALUES(discount_type), discount_value = VALUES(discount_value), min_order_amount = VALUES(min_order_amount)"
            );
            stmt.setString(1, request.getParameter("code").toUpperCase());
            stmt.setString(2, request.getParameter("description"));
            stmt.setString(3, request.getParameter("discountType"));
            stmt.setDouble(4, Double.parseDouble(request.getParameter("discountValue")));
            stmt.setDouble(5, Double.parseDouble(request.getParameter("minOrderAmount")));
            stmt.executeUpdate();
            stmt.close();
            conn.close();
            response.sendRedirect("admin-coupons.jsp");
            return;
        } catch (Exception e) {
            response.sendRedirect("admin-coupons.jsp");
            return;
        }
    }

    JSONObject result = new JSONObject();
    try {
        Connection conn = DatabaseConnection.getConnection();
        PreparedStatement stmt = conn.prepareStatement("UPDATE coupons SET is_active = ? WHERE coupon_id = ?");
        stmt.setBoolean(1, Boolean.parseBoolean(request.getParameter("toggle")));
        stmt.setInt(2, Integer.parseInt(request.getParameter("couponId")));
        int updated = stmt.executeUpdate();
        stmt.close();
        conn.close();
        result.put("success", updated > 0);
        result.put("message", updated > 0 ? "Coupon updated" : "Coupon not found");
    } catch (Exception e) {
        result.put("success", false);
        result.put("message", e.getMessage());
    }
    out.print(result.toString());
%>
