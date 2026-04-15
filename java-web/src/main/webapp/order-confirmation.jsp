<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Confirmed</title>
</head>
<body style="font-family:Segoe UI,Tahoma,sans-serif; background:#f5f5f5; display:grid; place-items:center; min-height:100vh;">
    <div style="background:white; padding:32px; border-radius:12px; text-align:center; max-width:520px;">
        <h1>Order Confirmed</h1>
        <p><%= request.getAttribute("success") != null ? request.getAttribute("success") : "Your order was placed successfully." %></p>
        <% if (request.getAttribute("finalAmount") != null) { %>
        <p>Total Paid: <%= request.getAttribute("finalAmount") %></p>
        <% } %>
        <div style="display:flex; gap:12px; justify-content:center; flex-wrap:wrap;">
            <a href="dashboard.jsp">View Dashboard</a>
            <a href="products.jsp">Continue Shopping</a>
        </div>
    </div>
</body>
</html>
