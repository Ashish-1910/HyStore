<%-- 
    Get Order Details - API Endpoint
    Returns order details as JSON
--%>

<%@page contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="org.json.*" %>
<%@ page import="com.ecommerce.db.DatabaseConnection" %>

<%
    try {
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        
        Connection conn = DatabaseConnection.getConnection();
        
        // Get order details
        PreparedStatement stmt = conn.prepareStatement(
            "SELECT o.order_id, u.full_name, o.order_date, o.total_amount, o.status, " +
            "o.shipping_address, o.payment_method FROM orders o " +
            "JOIN users u ON o.user_id = u.user_id WHERE o.order_id = ?"
        );
        stmt.setInt(1, orderId);
        ResultSet rs = stmt.executeQuery();
        
        JSONObject orderObj = new JSONObject();
        
        if (rs.next()) {
            orderObj.put("order_id", rs.getInt("order_id"));
            orderObj.put("customer_name", rs.getString("full_name"));
            orderObj.put("order_date", rs.getDate("order_date").toString());
            orderObj.put("total_amount", rs.getDouble("total_amount"));
            orderObj.put("status", rs.getString("status"));
            orderObj.put("shipping_address", rs.getString("shipping_address"));
            orderObj.put("payment_method", rs.getString("payment_method"));
            
            // Get order items
            PreparedStatement itemStmt = conn.prepareStatement(
                "SELECT product_name, quantity, price, subtotal FROM order_items WHERE order_id = ?"
            );
            itemStmt.setInt(1, orderId);
            ResultSet itemRs = itemStmt.executeQuery();
            
            JSONArray itemsArray = new JSONArray();
            while (itemRs.next()) {
                JSONObject itemObj = new JSONObject();
                itemObj.put("product_name", itemRs.getString("product_name"));
                itemObj.put("quantity", itemRs.getInt("quantity"));
                itemObj.put("price", itemRs.getDouble("price"));
                itemObj.put("subtotal", itemRs.getDouble("subtotal"));
                itemsArray.put(itemObj);
            }
            
            orderObj.put("items", itemsArray);
            itemStmt.close();
        }
        
        stmt.close();
        conn.close();
        
        out.print(orderObj.toString());
    } catch (Exception e) {
        JSONObject error = new JSONObject();
        error.put("error", e.getMessage());
        out.print(error.toString());
    }
%>
