<%-- 
    Delete Order - API Endpoint
    Deletes an order and related order items
--%>

<%@page contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="org.json.*" %>
<%@ page import="com.ecommerce.db.DatabaseConnection" %>

<%
    JSONObject response = new JSONObject();
    
    try {
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        
        Connection conn = DatabaseConnection.getConnection();
        conn.setAutoCommit(false);
        
        try {
            // Delete order items first
            PreparedStatement deleteItems = conn.prepareStatement("DELETE FROM order_items WHERE order_id = ?");
            deleteItems.setInt(1, orderId);
            deleteItems.executeUpdate();
            deleteItems.close();
            
            // Delete order
            PreparedStatement deleteOrder = conn.prepareStatement("DELETE FROM orders WHERE order_id = ?");
            deleteOrder.setInt(1, orderId);
            int result = deleteOrder.executeUpdate();
            deleteOrder.close();
            
            conn.commit();
            
            if (result > 0) {
                response.put("success", true);
                response.put("message", "Order deleted successfully");
            } else {
                response.put("success", false);
                response.put("message", "Order not found");
            }
        } catch (Exception e) {
            conn.rollback();
            throw e;
        } finally {
            conn.close();
        }
    } catch (NumberFormatException e) {
        response.put("success", false);
        response.put("message", "Invalid order ID");
    } catch (Exception e) {
        response.put("success", false);
        response.put("message", e.getMessage());
    }
    
    out.print(response.toString());
%>
