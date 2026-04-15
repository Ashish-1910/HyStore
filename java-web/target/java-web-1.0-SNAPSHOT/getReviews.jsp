<%@page contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="org.json.*" %>
<%@ page import="com.ecommerce.db.DatabaseConnection" %>
<%
    JSONObject result = new JSONObject();
    JSONArray reviews = new JSONArray();
    try {
        String productId = request.getParameter("productId");
        Connection conn = DatabaseConnection.getConnection();
        PreparedStatement stmt = conn.prepareStatement(
            "SELECT r.review_id, r.rating, r.review_text, r.created_at, u.full_name " +
            "FROM reviews r JOIN users u ON r.user_id = u.user_id " +
            "WHERE r.product_id = ? AND r.status = 'approved' ORDER BY r.created_at DESC"
        );
        stmt.setString(1, productId);
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            JSONObject item = new JSONObject();
            item.put("review_id", rs.getInt("review_id"));
            item.put("rating", rs.getInt("rating"));
            item.put("review_text", rs.getString("review_text"));
            item.put("created_at", rs.getTimestamp("created_at").toString());
            item.put("full_name", rs.getString("full_name"));
            reviews.put(item);
        }

        rs.close();
        stmt.close();
        conn.close();
    } catch (Exception e) {
        result.put("error", e.getMessage());
    }

    result.put("reviews", reviews);
    out.print(result.toString());
%>
