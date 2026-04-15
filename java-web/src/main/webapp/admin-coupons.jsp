<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.ecommerce.db.DatabaseConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Coupons</title>
</head>
<body style="font-family:Segoe UI,Tahoma,sans-serif; background:#f5f5f5; margin:0;">
    <div style="max-width:1100px; margin:40px auto; padding:20px;">
        <h1>Coupon Management</h1>
        <p><a href="admin-dashboard.jsp">Back to Dashboard</a></p>
        <form action="manageCoupon.jsp" method="post" style="background:white; padding:20px; border-radius:10px; margin-bottom:20px; display:grid; grid-template-columns:repeat(auto-fit,minmax(180px,1fr)); gap:12px;">
            <input type="text" name="code" placeholder="Coupon Code" required>
            <input type="text" name="description" placeholder="Description" required>
            <select name="discountType">
                <option value="percent">Percent</option>
                <option value="flat">Flat</option>
            </select>
            <input type="number" step="0.01" name="discountValue" placeholder="Discount Value" required>
            <input type="number" step="0.01" name="minOrderAmount" placeholder="Min Order Amount" required>
            <button type="submit">Save Coupon</button>
        </form>
        <table style="width:100%; border-collapse:collapse; background:white;">
            <thead>
                <tr>
                    <th style="padding:12px; border-bottom:1px solid #ddd;">Code</th>
                    <th style="padding:12px; border-bottom:1px solid #ddd;">Description</th>
                    <th style="padding:12px; border-bottom:1px solid #ddd;">Type</th>
                    <th style="padding:12px; border-bottom:1px solid #ddd;">Value</th>
                    <th style="padding:12px; border-bottom:1px solid #ddd;">Min Order</th>
                    <th style="padding:12px; border-bottom:1px solid #ddd;">Status</th>
                    <th style="padding:12px; border-bottom:1px solid #ddd;">Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    try {
                        Connection conn = DatabaseConnection.getConnection();
                        Statement stmt = conn.createStatement();
                        ResultSet rs = stmt.executeQuery("SELECT * FROM coupons ORDER BY created_at DESC");
                        boolean hasCoupons = false;
                        while (rs.next()) {
                            hasCoupons = true;
                %>
                <tr>
                    <td style="padding:12px; border-bottom:1px solid #eee;"><%= rs.getString("code") %></td>
                    <td style="padding:12px; border-bottom:1px solid #eee;"><%= rs.getString("description") %></td>
                    <td style="padding:12px; border-bottom:1px solid #eee;"><%= rs.getString("discount_type") %></td>
                    <td style="padding:12px; border-bottom:1px solid #eee;"><%= rs.getDouble("discount_value") %></td>
                    <td style="padding:12px; border-bottom:1px solid #eee;"><%= rs.getDouble("min_order_amount") %></td>
                    <td style="padding:12px; border-bottom:1px solid #eee;"><%= rs.getBoolean("is_active") ? "Active" : "Inactive" %></td>
                    <td style="padding:12px; border-bottom:1px solid #eee;">
                        <button onclick="toggleCoupon(<%= rs.getInt("coupon_id") %>, <%= rs.getBoolean("is_active") ? "false" : "true" %>)">
                            <%= rs.getBoolean("is_active") ? "Disable" : "Enable" %>
                        </button>
                    </td>
                </tr>
                <%
                        }
                        if (!hasCoupons) {
                            out.println("<tr><td colspan='7' style='padding:12px;'>No coupons found.</td></tr>");
                        }
                        rs.close();
                        stmt.close();
                        conn.close();
                    } catch (Exception e) {
                        out.println("<tr><td colspan='7' style='padding:12px; color:red;'>Error: " + e.getMessage() + "</td></tr>");
                    }
                %>
            </tbody>
        </table>
    </div>
    <script>
        function toggleCoupon(couponId, active) {
            fetch('manageCoupon.jsp?couponId=' + couponId + '&toggle=' + active)
                .then(response => response.json())
                .then(data => {
                    if (data.success) location.reload();
                    else alert(data.message);
                })
                .catch(error => alert('Error updating coupon: ' + error));
        }
    </script>
</body>
</html>
