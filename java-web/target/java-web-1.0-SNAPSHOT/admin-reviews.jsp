<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.ecommerce.db.DatabaseConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Reviews</title>
</head>
<body style="font-family:Segoe UI,Tahoma,sans-serif; background:#f5f5f5; margin:0;">
    <div style="max-width:1100px; margin:40px auto; padding:20px;">
        <h1>Review Moderation</h1>
        <p><a href="admin-dashboard.jsp">Back to Dashboard</a></p>
        <table style="width:100%; border-collapse:collapse; background:white;">
            <thead>
                <tr>
                    <th style="padding:12px; border-bottom:1px solid #ddd;">Product</th>
                    <th style="padding:12px; border-bottom:1px solid #ddd;">User</th>
                    <th style="padding:12px; border-bottom:1px solid #ddd;">Rating</th>
                    <th style="padding:12px; border-bottom:1px solid #ddd;">Review</th>
                    <th style="padding:12px; border-bottom:1px solid #ddd;">Status</th>
                    <th style="padding:12px; border-bottom:1px solid #ddd;">Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    try {
                        Connection conn = DatabaseConnection.getConnection();
                        Statement stmt = conn.createStatement();
                        ResultSet rs = stmt.executeQuery(
                            "SELECT r.review_id, r.product_id, r.rating, r.review_text, r.status, u.full_name " +
                            "FROM reviews r JOIN users u ON r.user_id = u.user_id ORDER BY r.created_at DESC"
                        );
                        boolean hasReviews = false;
                        while (rs.next()) {
                            hasReviews = true;
                %>
                <tr>
                    <td style="padding:12px; border-bottom:1px solid #eee;"><%= rs.getString("product_id") %></td>
                    <td style="padding:12px; border-bottom:1px solid #eee;"><%= rs.getString("full_name") %></td>
                    <td style="padding:12px; border-bottom:1px solid #eee;"><%= rs.getInt("rating") %>/5</td>
                    <td style="padding:12px; border-bottom:1px solid #eee;"><%= rs.getString("review_text") %></td>
                    <td style="padding:12px; border-bottom:1px solid #eee;"><%= rs.getString("status") %></td>
                    <td style="padding:12px; border-bottom:1px solid #eee;">
                        <button onclick="moderateReview(<%= rs.getInt("review_id") %>, 'approved')">Approve</button>
                        <button onclick="moderateReview(<%= rs.getInt("review_id") %>, 'hidden')">Hide</button>
                    </td>
                </tr>
                <%
                        }
                        if (!hasReviews) {
                            out.println("<tr><td colspan='6' style='padding:12px;'>No reviews yet.</td></tr>");
                        }
                        rs.close();
                        stmt.close();
                        conn.close();
                    } catch (Exception e) {
                        out.println("<tr><td colspan='6' style='padding:12px; color:red;'>Error: " + e.getMessage() + "</td></tr>");
                    }
                %>
            </tbody>
        </table>
    </div>
    <script>
        function moderateReview(reviewId, status) {
            fetch('moderateReview.jsp?reviewId=' + reviewId + '&status=' + status)
                .then(response => response.json())
                .then(data => {
                    if (data.success) location.reload();
                    else alert(data.message);
                })
                .catch(error => alert('Error updating review: ' + error));
        }
    </script>
</body>
</html>
