<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.ecommerce.db.DatabaseConnection" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Wishlist</title>
</head>
<body style="font-family:Segoe UI,Tahoma,sans-serif; background:#f5f5f5; margin:0;">
    <div style="max-width:1100px; margin:40px auto; padding:20px;">
        <h1>My Wishlist</h1>
        <p><a href="products.jsp">Back to Products</a></p>
        <div style="display:grid; grid-template-columns:repeat(auto-fit,minmax(240px,1fr)); gap:16px;">
            <%
                try {
                    Connection conn = DatabaseConnection.getConnection();
                    PreparedStatement stmt = conn.prepareStatement(
                        "SELECT product_id, product_name, category, price, image_url, created_at FROM wishlist_items WHERE user_id = ? ORDER BY created_at DESC"
                    );
                    stmt.setInt(1, userId);
                    ResultSet rs = stmt.executeQuery();
                    boolean hasItems = false;
                    while (rs.next()) {
                        hasItems = true;
            %>
            <div style="background:white; padding:20px; border-radius:10px;">
                <div style="font-weight:700; margin-bottom:8px;"><%= rs.getString("product_name") %></div>
                <div style="color:#666; margin-bottom:8px;"><%= rs.getString("category") %></div>
                <div style="color:#667eea; font-weight:700; margin-bottom:12px;"><%= rs.getDouble("price") %></div>
                <div style="display:flex; gap:8px; flex-wrap:wrap;">
                    <a href="product-detail.jsp?id=<%= rs.getString("product_id") %>">View</a>
                    <button onclick="removeFromWishlist('<%= rs.getString("product_id") %>', '<%= rs.getString("product_name").replace("'", "\\'") %>', '<%= rs.getString("category") != null ? rs.getString("category").replace("'", "\\'") : "" %>', '<%= rs.getDouble("price") %>', '<%= rs.getString("image_url") != null ? rs.getString("image_url").replace("'", "\\'") : "" %>')">Remove</button>
                </div>
            </div>
            <%
                    }
                    if (!hasItems) {
                        out.println("<div style='background:white; padding:20px; border-radius:10px;'>Your wishlist is empty.</div>");
                    }
                    rs.close();
                    stmt.close();
                    conn.close();
                } catch (Exception e) {
                    out.println("<div style='background:white; padding:20px; border-radius:10px; color:red;'>Error loading wishlist: " + e.getMessage() + "</div>");
                }
            %>
        </div>
    </div>
    <script>
        function removeFromWishlist(productId, productName, category, price, imageUrl) {
            const formData = new URLSearchParams();
            formData.append('productId', productId);
            formData.append('productName', productName);
            formData.append('category', category);
            formData.append('price', price);
            formData.append('imageUrl', imageUrl);

            fetch('toggleWishlist.jsp', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) location.reload();
                else alert(data.message);
            })
            .catch(error => alert('Error updating wishlist: ' + error.message));
        }
    </script>
</body>
</html>
