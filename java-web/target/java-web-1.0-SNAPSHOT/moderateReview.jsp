<%@page contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="org.json.*" %>
<%@ page import="com.ecommerce.db.DatabaseConnection" %>
<%
    JSONObject result = new JSONObject();
    try {
        int reviewId = Integer.parseInt(request.getParameter("reviewId"));
        String status = request.getParameter("status");
        Connection conn = DatabaseConnection.getConnection();
        PreparedStatement stmt = conn.prepareStatement("UPDATE reviews SET status = ? WHERE review_id = ?");
        stmt.setString(1, status);
        stmt.setInt(2, reviewId);
        int updated = stmt.executeUpdate();
        stmt.close();
        conn.close();

        result.put("success", updated > 0);
        result.put("message", updated > 0 ? "Review updated" : "Review not found");
    } catch (Exception e) {
        result.put("success", false);
        result.put("message", e.getMessage());
    }
    out.print(result.toString());
%>
