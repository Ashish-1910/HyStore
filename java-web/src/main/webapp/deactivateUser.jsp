<%-- 
    Deactivate User - API Endpoint
    Updates user status to inactive
--%>

<%@page contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="org.json.*" %>
<%@ page import="com.ecommerce.db.DatabaseConnection" %>

<%
    JSONObject response = new JSONObject();
    
    try {
        int userId = Integer.parseInt(request.getParameter("userId"));
        
        // Don't allow deactivating self
        HttpSession session = request.getSession(false);
        Integer currentAdminId = session != null ? (Integer) session.getAttribute("adminId") : null;
        if (currentAdminId != null && userId == currentAdminId) {
            response.put("success", false);
            response.put("message", "You cannot deactivate your own account");
            out.print(response.toString());
            return;
        }
        
        Connection conn = DatabaseConnection.getConnection();
        
        // Check if user exists and is not already inactive
        PreparedStatement checkStmt = conn.prepareStatement("SELECT user_id FROM users WHERE user_id = ?");
        checkStmt.setInt(1, userId);
        ResultSet checkRs = checkStmt.executeQuery();
        
        if (!checkRs.next()) {
            response.put("success", false);
            response.put("message", "User not found");
            out.print(response.toString());
            checkStmt.close();
            conn.close();
            return;
        }
        
        PreparedStatement updateStmt = conn.prepareStatement(
            "UPDATE users SET status = 'inactive' WHERE user_id = ? AND status <> 'inactive'"
        );
        updateStmt.setInt(1, userId);
        int result = updateStmt.executeUpdate();
        
        if (result > 0) {
            response.put("success", true);
            response.put("message", "User deactivated successfully");
        } else {
            response.put("success", false);
            response.put("message", "User is already deactivated or could not be updated");
        }
        
        checkStmt.close();
        updateStmt.close();
        conn.close();
    } catch (NumberFormatException e) {
        response.put("success", false);
        response.put("message", "Invalid user ID");
    } catch (Exception e) {
        response.put("success", false);
        response.put("message", e.getMessage());
    }
    
    out.print(response.toString());
%>
