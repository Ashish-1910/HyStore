<%@page contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="org.json.*" %>
<%@ page import="com.ecommerce.db.DatabaseConnection" %>
<%
    JSONObject response = new JSONObject();

    try {
        int userId = Integer.parseInt(request.getParameter("userId"));
        String status = request.getParameter("status");

        if (!"active".equals(status) && !"inactive".equals(status)) {
            response.put("success", false);
            response.put("message", "Invalid status");
            out.print(response.toString());
            return;
        }

        HttpSession session = request.getSession(false);
        Integer currentAdminId = session != null ? (Integer) session.getAttribute("adminId") : null;
        if (currentAdminId != null && userId == currentAdminId) {
            response.put("success", false);
            response.put("message", "You cannot change your own account status");
            out.print(response.toString());
            return;
        }

        Connection conn = DatabaseConnection.getConnection();
        PreparedStatement stmt = conn.prepareStatement("UPDATE users SET status = ? WHERE user_id = ?");
        stmt.setString(1, status);
        stmt.setInt(2, userId);
        int updated = stmt.executeUpdate();
        stmt.close();
        conn.close();

        response.put("success", updated > 0);
        response.put("message", updated > 0 ? "User status updated" : "User not found");
    } catch (Exception e) {
        response.put("success", false);
        response.put("message", e.getMessage());
    }

    out.print(response.toString());
%>
