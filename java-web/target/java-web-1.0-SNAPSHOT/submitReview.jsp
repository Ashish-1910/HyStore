<%@page contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="org.json.*" %>
<%@ page import="com.ecommerce.db.DatabaseConnection" %>
<%
    JSONObject result = new JSONObject();
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        result.put("success", false);
        result.put("message", "Please login to submit a review.");
        out.print(result.toString());
        return;
    }

    try {
        String productId = request.getParameter("productId");
        int rating = Integer.parseInt(request.getParameter("rating"));
        String reviewText = request.getParameter("reviewText");

        Connection conn = DatabaseConnection.getConnection();
        PreparedStatement stmt = conn.prepareStatement(
            "INSERT INTO reviews (product_id, user_id, rating, review_text, status) VALUES (?, ?, ?, ?, 'pending')"
        );
        stmt.setString(1, productId);
        stmt.setInt(2, userId);
        stmt.setInt(3, rating);
        stmt.setString(4, reviewText);
        stmt.executeUpdate();
        stmt.close();
        conn.close();

        result.put("success", true);
        result.put("message", "Review submitted and sent for admin approval.");
    } catch (Exception e) {
        result.put("success", false);
        result.put("message", e.getMessage());
    }
    out.print(result.toString());
%>
