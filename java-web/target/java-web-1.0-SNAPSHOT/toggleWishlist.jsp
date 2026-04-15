<%@page contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="org.json.*" %>
<%@ page import="com.ecommerce.db.DatabaseConnection" %>
<%
    JSONObject result = new JSONObject();
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        result.put("success", false);
        result.put("message", "Please login to use wishlist.");
        out.print(result.toString());
        return;
    }

    try {
        String productId = request.getParameter("productId");
        String productName = request.getParameter("productName");
        String category = request.getParameter("category");
        String imageUrl = request.getParameter("imageUrl");
        double price = 0;
        try {
            price = Double.parseDouble(request.getParameter("price"));
        } catch (Exception ignore) {}

        Connection conn = DatabaseConnection.getConnection();
        PreparedStatement checkStmt = conn.prepareStatement("SELECT wishlist_id FROM wishlist_items WHERE user_id = ? AND product_id = ?");
        checkStmt.setInt(1, userId);
        checkStmt.setString(2, productId);
        ResultSet rs = checkStmt.executeQuery();

        if (rs.next()) {
            PreparedStatement deleteStmt = conn.prepareStatement("DELETE FROM wishlist_items WHERE user_id = ? AND product_id = ?");
            deleteStmt.setInt(1, userId);
            deleteStmt.setString(2, productId);
            deleteStmt.executeUpdate();
            deleteStmt.close();
            result.put("success", true);
            result.put("message", "Removed from wishlist.");
        } else {
            PreparedStatement insertStmt = conn.prepareStatement(
                "INSERT INTO wishlist_items (user_id, product_id, product_name, category, price, image_url) VALUES (?, ?, ?, ?, ?, ?)"
            );
            insertStmt.setInt(1, userId);
            insertStmt.setString(2, productId);
            insertStmt.setString(3, productName);
            insertStmt.setString(4, category);
            insertStmt.setDouble(5, price);
            insertStmt.setString(6, imageUrl);
            insertStmt.executeUpdate();
            insertStmt.close();
            result.put("success", true);
            result.put("message", "Added to wishlist.");
        }

        rs.close();
        checkStmt.close();
        conn.close();
    } catch (Exception e) {
        result.put("success", false);
        result.put("message", e.getMessage());
    }
    out.print(result.toString());
%>
