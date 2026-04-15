<%-- 
    Get User Details - API Endpoint
    Returns user details as JSON
--%>

<%@page contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="org.json.*" %>
<%@ page import="com.ecommerce.db.DatabaseConnection" %>

<%
    try {
        int userId = Integer.parseInt(request.getParameter("userId"));
        
        Connection conn = DatabaseConnection.getConnection();
        PreparedStatement stmt = conn.prepareStatement(
            "SELECT user_id, username, email, full_name, phone, address, city, state, postal_code, role, status, created_at FROM users WHERE user_id = ?"
        );
        stmt.setInt(1, userId);
        ResultSet rs = stmt.executeQuery();
        
        JSONObject userObj = new JSONObject();
        
        if (rs.next()) {
            userObj.put("user_id", rs.getInt("user_id"));
            userObj.put("username", rs.getString("username"));
            userObj.put("email", rs.getString("email"));
            userObj.put("full_name", rs.getString("full_name"));
            userObj.put("phone", rs.getString("phone"));
            userObj.put("address", rs.getString("address"));
            userObj.put("city", rs.getString("city"));
            userObj.put("state", rs.getString("state"));
            userObj.put("postal_code", rs.getString("postal_code"));
            userObj.put("role", rs.getString("role"));
            userObj.put("status", rs.getString("status"));
            userObj.put("created_at", rs.getDate("created_at"));
        } else {
            userObj.put("error", "User not found");
        }
        
        stmt.close();
        conn.close();
        
        out.print(userObj.toString());
    } catch (Exception e) {
        JSONObject error = new JSONObject();
        error.put("error", e.getMessage());
        out.print(error.toString());
    }
%>
