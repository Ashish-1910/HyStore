<%@page contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="org.json.*" %>
<%@ page import="com.ecommerce.db.DatabaseConnection" %>
<%
    JSONObject result = new JSONObject();
    try {
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        String status = request.getParameter("status");

        Connection conn = DatabaseConnection.getConnection();
        PreparedStatement stmt = conn.prepareStatement("UPDATE orders SET status = ? WHERE order_id = ?");
        stmt.setString(1, status);
        stmt.setInt(2, orderId);
        int updated = stmt.executeUpdate();
        stmt.close();
        conn.close();

        result.put("success", updated > 0);
        result.put("message", updated > 0 ? "Order status updated" : "Order not found");
    } catch (Exception e) {
        result.put("success", false);
        result.put("message", e.getMessage());
    }
    out.print(result.toString());
%>
