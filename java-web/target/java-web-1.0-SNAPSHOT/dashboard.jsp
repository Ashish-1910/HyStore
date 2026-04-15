<%-- 
    Customer Dashboard Page - Order History & Profile
    Date: 14 Apr 2026
    Features: User profile, order history, order tracking, status management
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.ecommerce.db.DatabaseConnection" %>

<%
    // Check if user is logged in
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    // Get user information from session
    Integer userId = (Integer) session.getAttribute("userId");
    List<Map<String, Object>> orders = new ArrayList<>();
    Map<String, String> userInfo = new HashMap<>();
    
    try {
        Connection conn = DatabaseConnection.getConnection();
        
        // Get user profile information
        String userQuery = "SELECT user_id, username, email, full_name, phone, address, city, state, postal_code, created_at FROM users WHERE user_id = ?";
        PreparedStatement userStmt = conn.prepareStatement(userQuery);
        userStmt.setInt(1, userId != null ? userId : 0);
        ResultSet userRs = userStmt.executeQuery();
        
        if (userRs.next()) {
            userInfo.put("username", userRs.getString("username"));
            userInfo.put("email", userRs.getString("email"));
            userInfo.put("full_name", userRs.getString("full_name"));
            userInfo.put("phone", userRs.getString("phone") != null ? userRs.getString("phone") : "Not provided");
            userInfo.put("address", userRs.getString("address") != null ? userRs.getString("address") : "Not provided");
            userInfo.put("city", userRs.getString("city") != null ? userRs.getString("city") : "");
            userInfo.put("state", userRs.getString("state") != null ? userRs.getString("state") : "");
            userInfo.put("postal_code", userRs.getString("postal_code") != null ? userRs.getString("postal_code") : "");
            userInfo.put("member_since", userRs.getString("created_at"));
        }
        userRs.close();
        userStmt.close();
        
        // Get user's orders
        String query = "SELECT o.order_id, o.order_date, o.status, o.total_amount, COUNT(oi.order_item_id) as item_count " +
                       "FROM orders o LEFT JOIN order_items oi ON o.order_id = oi.order_id " +
                       "WHERE o.user_id = ? GROUP BY o.order_id ORDER BY o.order_date DESC LIMIT 10";
        
        PreparedStatement ps = conn.prepareStatement(query);
        ps.setInt(1, userId != null ? userId : 0);
        ResultSet rs = ps.executeQuery();
        
        while (rs.next()) {
            Map<String, Object> order = new HashMap<>();
            order.put("order_id", rs.getInt("order_id"));
            order.put("order_date", rs.getString("order_date"));
            order.put("total_amount", rs.getDouble("total_amount"));
            order.put("status", rs.getString("status"));
            order.put("item_count", rs.getInt("item_count"));
            orders.add(order);
        }
        
        rs.close();
        ps.close();
        conn.close();
        
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Dashboard - HyStore</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f5f5;
        }
        
        header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 1rem 0;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            position: sticky;
            top: 0;
            z-index: 100;
        }
        
        header nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
            flex-wrap: wrap;
            gap: 1rem;
        }
        
        header .logo {
            font-size: 1.8rem;
            font-weight: bold;
            letter-spacing: 1px;
        }
        
        header nav ul {
            list-style: none;
            display: flex;
            gap: 2rem;
            flex-wrap: wrap;
        }
        
        header nav a {
            color: white;
            text-decoration: none;
            transition: 0.3s;
            font-weight: 500;
        }
        
        header nav a:hover {
            opacity: 0.8;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 40px 20px;
        }
        
        .dashboard-main {
            display: grid;
            grid-template-columns: 250px 1fr;
            gap: 20px;
        }
        
        .sidebar {
            background: white;
            border-radius: 8px;
            padding: 20px;
            height: fit-content;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .sidebar h3 {
            margin-bottom: 20px;
            color: #333;
        }
        
        .sidebar ul {
            list-style: none;
        }
        
        .sidebar li {
            margin-bottom: 10px;
        }
        
        .sidebar a {
            display: block;
            padding: 10px;
            color: #667eea;
            text-decoration: none;
            border-radius: 5px;
            transition: background 0.3s;
            font-weight: 500;
        }
        
        .sidebar a:hover {
            background: #f5f5f5;
        }
        
        .sidebar a.active {
            background: #667eea;
            color: white;
        }
        
        .content {
            background: white;
            border-radius: 8px;
            padding: 30px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        h1 {
            color: #333;
            margin-bottom: 20px;
            font-size: 1.8rem;
        }
        
        h2 {
            color: #333;
            margin-bottom: 15px;
            margin-top: 25px;
            font-size: 1.3rem;
        }
        
        .info-box {
            background: #f9f9f9;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            border-left: 4px solid #667eea;
            font-size: 0.95rem;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        
        th {
            background: #f5f5f5;
            padding: 12px;
            text-align: left;
            border-bottom: 2px solid #ddd;
            font-weight: 600;
        }
        
        td {
            padding: 12px;
            border-bottom: 1px solid #eee;
        }
        
        tr:hover {
            background: #f9f9f9;
        }
        
        .btn {
            padding: 8px 15px;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            font-weight: 600;
            transition: 0.3s;
        }
        
        .btn:hover {
            background: #764ba2;
        }
        
        footer {
            background: #333;
            color: white;
            text-align: center;
            padding: 20px;
            margin-top: 40px;
        }
        
        @media (max-width: 768px) {
            .dashboard-main {
                grid-template-columns: 1fr;
            }
            
            header nav {
                flex-direction: column;
                gap: 0.5rem;
            }
            
            header nav ul {
                gap: 1rem;
            }
        }
    </style>
</head>
<body>
    <!-- Navigation Header -->
    <header>
        <nav>
            <span class="logo">HyStore</span>
            <ul>
                <li><a href="<%= request.getContextPath() %>/index.jsp">Home</a></li>
                <li><a href="<%= request.getContextPath() %>/products.jsp">Products</a></li>
                <li><a href="<%= request.getContextPath() %>/dashboard.jsp">Dashboard</a></li>
                <li><a href="<%= request.getContextPath() %>/cart.jsp">Cart</a></li>
                <li><a href="<%= request.getContextPath() %>/logout">Logout</a></li>
            </ul>
        </nav>
    </header>
    
    <!-- Main Dashboard -->
    <div class="container">
        <div class="dashboard-main">
            <!-- Sidebar Menu -->
            <div class="sidebar">
                <h3>📋 My Account</h3>
                <ul>
                    <li><a href="#orders" class="active">My Orders</a></li>
                    <li><a href="#addresses">Addresses</a></li>
                    <li><a href="<%= request.getContextPath() %>/wishlist.jsp">Wishlist</a></li>
                    <li><a href="#settings">Settings</a></li>
                </ul>
            </div>
            
            <!-- Main Content -->
            <div class="content">
                <h1>Welcome, <%= userInfo.getOrDefault("full_name", username) %>!</h1>
                
                <div class="info-box">
                    <strong>📧 Email:</strong> <%= userInfo.getOrDefault("email", "N/A") %> | 
                    <strong>👤 Full Name:</strong> <%= userInfo.getOrDefault("full_name", "N/A") %> | 
                    <strong>✅ Account Status:</strong> Active
                </div>
                
                <h2>📦 Your Orders</h2>
                
                <!-- Filters -->
                <div style="display: flex; gap: 10px; margin-bottom: 20px; flex-wrap: wrap;">
                    <select id="statusFilter" onchange="filterOrders()" style="padding: 8px 12px; border: 1px solid #ddd; border-radius: 5px;">
                        <option value="">All Status</option>
                        <option value="pending">Pending</option>
                        <option value="confirmed">Confirmed</option>
                        <option value="shipped">Shipped</option>
                        <option value="delivered">Delivered</option>
                        <option value="cancelled">Cancelled</option>
                    </select>
                    <input type="text" id="orderSearch" placeholder="🔍 Search Order ID..." style="padding: 8px 12px; border: 1px solid #ddd; border-radius: 5px; flex: 1; min-width: 200px;" onkeyup="filterOrders()" />
                    <button onclick="clearOrderFilters()" style="padding: 8px 15px; background: #999; color: white; border: none; border-radius: 5px; cursor: pointer;">🔄 Clear</button>
                </div>
                
                <% if (orders.size() > 0) { %>
                    <table id="ordersTable">
                        <thead>
                            <tr>
                                <th>Order ID</th>
                                <th>Date</th>
                                <th>Items</th>
                                <th>Total</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Map<String, Object> order : orders) { %>
                                <%
                                    String status = (String) order.get("status");
                                    String statusColor = "";
                                    switch(status) {
                                        case "delivered": statusColor = "#d4edda"; break;
                                        case "shipped": statusColor = "#fff3cd"; break;
                                        case "confirmed": statusColor = "#cfe2ff"; break;
                                        case "cancelled": statusColor = "#f8d7da"; break;
                                        default: statusColor = "#e2e3e5"; 
                                    }
                                    String displayStatus = status.substring(0, 1).toUpperCase() + status.substring(1);
                                %>
                                <tr class="order-row" data-status="<%= status %>" data-order-id="#<%= order.get("order_id") %>">
                                    <td><strong>#<%= String.format("%06d", order.get("order_id")) %></strong></td>
                                    <td><%= order.get("order_date").toString().substring(0, 10) %></td>
                                    <td><%= order.get("item_count") %> item(s)</td>
                                    <td>₹<%= String.format("%.2f", order.get("total_amount")) %></td>
                                    <td><span style="background: <%= statusColor %>; padding: 5px 10px; border-radius: 3px; font-weight: 500;"><%= displayStatus %></span></td>
                                    <td>
                                        <a href="<%= request.getContextPath() %>/getOrderDetails.jsp?orderId=<%= order.get("order_id") %>" class="btn" style="padding: 6px 12px; font-size: 0.9rem;">View</a>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                <% } else { %>
                    <div style="text-align: center; padding: 40px; color: #999;">
                        <p style="font-size: 1.2rem; margin-bottom: 20px;">📭 No orders yet</p>
                        <a href="<%= request.getContextPath() %>/products.jsp" class="btn" style="display: inline-block;">Start Shopping Now</a>
                    </div>
                <% } %>
                
                <h2 style="margin-top: 30px;">⚡ Quick Actions</h2>
                <div style="display: flex; gap: 10px; margin-top: 15px; flex-wrap: wrap;">
                    <a href="<%= request.getContextPath() %>/products.jsp" class="btn">🛍️ Continue Shopping</a>
                    <a href="<%= request.getContextPath() %>/cart.jsp" class="btn">🛒 View Cart</a>
                    <button class="btn" onclick="editProfile()" style="background: #28a745;">✏️ Edit Profile</button>
                    <a href="<%= request.getContextPath() %>/logout" class="btn" style="background: #dc3545;">🚪 Logout</a>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Footer -->
    <footer>
        <p>&copy; 2026 Hybrid E-Commerce System. All rights reserved.</p>
    </footer>
    
    <script>
        // Filter orders by status and search
        function filterOrders() {
            const statusFilter = document.getElementById('statusFilter').value.toLowerCase();
            const searchTerm = document.getElementById('orderSearch').value.toLowerCase();
            const rows = document.querySelectorAll('.order-row');
            
            rows.forEach(row => {
                const status = row.getAttribute('data-status').toLowerCase();
                const orderId = row.getAttribute('data-order-id').toLowerCase();
                
                const statusMatch = !statusFilter || status === statusFilter;
                const searchMatch = !searchTerm || orderId.includes(searchTerm);
                
                row.style.display = (statusMatch && searchMatch) ? '' : 'none';
            });
        }
        
        // Clear order filters
        function clearOrderFilters() {
            document.getElementById('statusFilter').value = '';
            document.getElementById('orderSearch').value = '';
            filterOrders();
        }
        
        // Edit profile
        function editProfile() {
            alert('Edit profile feature coming soon! You can update your profile information here.');
        }
    </script>
</body>
</html>
