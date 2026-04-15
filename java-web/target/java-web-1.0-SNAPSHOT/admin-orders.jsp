<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.ecommerce.db.DatabaseConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Orders - Admin</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f5f5f5; }
        header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 1rem; }
        .container { max-width: 1200px; margin: 0 auto; padding: 20px; }
        .content { background: white; border-radius: 8px; padding: 20px; margin-top: 20px; }
        .filter-bar { display: flex; gap: 10px; margin-bottom: 20px; flex-wrap: wrap; }
        .filter-bar input, .filter-bar select { padding: 8px 12px; border: 1px solid #ddd; border-radius: 5px; }
        .btn { padding: 8px 15px; background: #667eea; color: white; border: none; border-radius: 5px; cursor: pointer; font-weight: 600; }
        .btn-view { background: #28a745; }
        .btn-delete { background: #dc3545; }
        table { width: 100%; border-collapse: collapse; }
        th { background: #f5f5f5; padding: 12px; text-align: left; border-bottom: 2px solid #ddd; font-weight: bold; }
        td { padding: 12px; border-bottom: 1px solid #eee; }
        .status-badge { display: inline-block; padding: 5px 10px; border-radius: 3px; font-size: 0.85rem; font-weight: bold; }
        .status-pending { background: #fff3cd; color: #856404; }
        .status-confirmed { background: #d1ecf1; color: #0c5460; }
        .status-shipped { background: #cce5ff; color: #004085; }
        .status-delivered { background: #d4edda; color: #155724; }
        .status-cancelled { background: #f8d7da; color: #721c24; }
        .actions { display: flex; gap: 5px; }
        .modal { display: none; position: fixed; inset: 0; background-color: rgba(0,0,0,0.5); }
        .modal-content { background-color: white; margin: 5% auto; padding: 30px; border-radius: 8px; width: 90%; max-width: 700px; }
        .close { color: #aaa; float: right; font-size: 28px; font-weight: bold; cursor: pointer; }
        .order-detail { margin-bottom: 15px; padding-bottom: 15px; border-bottom: 1px solid #eee; }
        .order-detail label { font-weight: bold; color: #333; display: block; margin-bottom: 5px; }
        .items-table { width: 100%; border-collapse: collapse; margin: 15px 0; }
        .items-table th, .items-table td { padding: 10px; border-bottom: 1px solid #eee; }
        footer { background: #333; color: white; text-align: center; padding: 20px; margin-top: 40px; }
    </style>
</head>
<body>
    <header>
        <div class="container" style="display:flex; justify-content:space-between; align-items:center;">
            <h1>Order Management</h1>
            <div>
                <a href="admin-dashboard.jsp" style="color:white; text-decoration:none; margin-right:15px;">Dashboard</a>
                <a href="logout" style="color:white; text-decoration:none;">Logout</a>
            </div>
        </div>
    </header>

    <div class="container">
        <div class="content">
            <div class="filter-bar">
                <input type="text" id="searchOrder" placeholder="Search by Order ID...">
                <input type="text" id="searchCustomer" placeholder="Search by Customer...">
                <select id="statusFilter">
                    <option value="">All Status</option>
                    <option value="pending">Pending</option>
                    <option value="confirmed">Confirmed</option>
                    <option value="shipped">Shipped</option>
                    <option value="delivered">Delivered</option>
                    <option value="cancelled">Cancelled</option>
                </select>
                <button class="btn" onclick="filterOrders()">Filter</button>
            </div>

            <table>
                <thead>
                    <tr>
                        <th>Order ID</th>
                        <th>Customer Name</th>
                        <th>Order Date</th>
                        <th>Items</th>
                        <th>Total Amount</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody id="ordersTable">
                    <%
                        try {
                            Connection conn = DatabaseConnection.getConnection();
                            Statement stmt = conn.createStatement();
                            ResultSet rs = stmt.executeQuery(
                                "SELECT o.order_id, u.full_name, o.order_date, COUNT(oi.order_item_id) as item_count, " +
                                "o.total_amount, o.status FROM orders o " +
                                "JOIN users u ON o.user_id = u.user_id " +
                                "LEFT JOIN order_items oi ON o.order_id = oi.order_id " +
                                "GROUP BY o.order_id ORDER BY o.order_date DESC"
                            );
                            boolean hasOrders = false;
                            while (rs.next()) {
                                hasOrders = true;
                                int orderId = rs.getInt("order_id");
                                String customerName = rs.getString("full_name");
                                java.sql.Date orderDate = rs.getDate("order_date");
                                int itemCount = rs.getInt("item_count");
                                double totalAmount = rs.getDouble("total_amount");
                                String status = rs.getString("status");

                                String statusClass = "status-pending";
                                if ("confirmed".equals(status)) statusClass = "status-confirmed";
                                else if ("shipped".equals(status)) statusClass = "status-shipped";
                                else if ("delivered".equals(status)) statusClass = "status-delivered";
                                else if ("cancelled".equals(status)) statusClass = "status-cancelled";
                                String displayStatus = status.substring(0, 1).toUpperCase() + status.substring(1);
                    %>
                    <tr>
                        <td>#ORD<%= String.format("%03d", orderId) %></td>
                        <td><%= customerName %></td>
                        <td><%= orderDate %></td>
                        <td><%= itemCount %></td>
                        <td>₹<%= String.format("%.2f", totalAmount) %></td>
                        <td>
                            <div style="display:flex; gap:8px; align-items:center; flex-wrap:wrap;">
                                <span class="status-badge <%= statusClass %>"><%= displayStatus %></span>
                                <select onchange="updateOrderStatus(<%= orderId %>, this.value)" style="padding:4px 6px;">
                                    <option value="">Update</option>
                                    <option value="pending">Pending</option>
                                    <option value="confirmed">Confirmed</option>
                                    <option value="shipped">Shipped</option>
                                    <option value="delivered">Delivered</option>
                                    <option value="cancelled">Cancelled</option>
                                </select>
                            </div>
                        </td>
                        <td>
                            <div class="actions">
                                <button class="btn btn-view" onclick="viewOrder(<%= orderId %>)">View</button>
                                <button class="btn btn-delete" onclick="deleteOrder(<%= orderId %>)">Delete</button>
                            </div>
                        </td>
                    </tr>
                    <%
                            }
                            if (!hasOrders) {
                                out.println("<tr><td colspan='7' style='text-align:center; color:#999;'>No orders found</td></tr>");
                            }
                            rs.close();
                            stmt.close();
                            conn.close();
                        } catch (Exception e) {
                            out.println("<tr><td colspan='7' style='text-align:center; color:red;'>Error loading orders: " + e.getMessage() + "</td></tr>");
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>

    <div id="orderModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeOrderModal()">&times;</span>
            <h2>Order Details</h2>
            <div id="orderDetails"></div>
        </div>
    </div>

    <footer>
        <p>&copy; 2026 Hybrid E-Commerce System. All rights reserved.</p>
    </footer>

    <script>
        function viewOrder(orderId) {
            fetch('getOrderDetails.jsp?orderId=' + orderId)
                .then(response => response.json())
                .then(data => {
                    let itemsHtml = '<table class="items-table"><thead><tr><th>Product Name</th><th>Quantity</th><th>Price</th><th>Subtotal</th></tr></thead><tbody>';

                    if (data.items && data.items.length > 0) {
                        data.items.forEach(item => {
                            itemsHtml += `<tr>
                                <td>\${item.product_name}</td>
                                <td>\${item.quantity}</td>
                                <td>₹\${parseFloat(item.price).toFixed(2)}</td>
                                <td>₹\${parseFloat(item.subtotal).toFixed(2)}</td>
                            </tr>`;
                        });
                    }
                    itemsHtml += '</tbody></table>';

                    document.getElementById('orderDetails').innerHTML = `
                        <div class="order-detail"><label>Order ID:</label><span>#ORD\${String(data.order_id).padStart(3, '0')}</span></div>
                        <div class="order-detail"><label>Customer:</label><span>\${data.customer_name}</span></div>
                        <div class="order-detail"><label>Order Date:</label><span>\${data.order_date}</span></div>
                        <div class="order-detail"><label>Status:</label><span>\${data.status}</span></div>
                        <div class="order-detail"><label>Shipping Address:</label><span>\${data.shipping_address || 'N/A'}</span></div>
                        <div class="order-detail"><label>Payment Method:</label><span>\${data.payment_method || 'N/A'}</span></div>
                        <div class="order-detail"><label>Order Items:</label>\${itemsHtml}</div>
                        <div class="order-detail"><label>Total Amount:</label><span style="font-size: 1.2rem; color: #667eea; font-weight: bold;">₹\${parseFloat(data.total_amount).toFixed(2)}</span></div>
                    `;

                    document.getElementById('orderModal').style.display = 'block';
                })
                .catch(error => {
                    alert('Error loading order details: ' + error);
                });
        }

        function closeOrderModal() {
            document.getElementById('orderModal').style.display = 'none';
        }

        function deleteOrder(orderId) {
            if (confirm('Are you sure you want to delete this order?')) {
                fetch('deleteOrder.jsp?orderId=' + orderId, { method: 'GET' })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) location.reload();
                        else alert('Error: ' + data.message);
                    })
                    .catch(error => alert('Error deleting order: ' + error));
            }
        }

        function updateOrderStatus(orderId, status) {
            if (!status) return;
            fetch('updateOrderStatus.jsp?orderId=' + orderId + '&status=' + encodeURIComponent(status), { method: 'GET' })
                .then(response => response.json())
                .then(data => {
                    if (data.success) location.reload();
                    else alert('Error: ' + data.message);
                })
                .catch(error => alert('Error updating status: ' + error));
        }

        function filterOrders() {
            const orderSearch = document.getElementById('searchOrder').value.toLowerCase();
            const customerSearch = document.getElementById('searchCustomer').value.toLowerCase();
            const statusFilter = document.getElementById('statusFilter').value;
            const rows = document.getElementById('ordersTable').getElementsByTagName('tr');

            for (const row of rows) {
                const cells = row.getElementsByTagName('td');
                if (cells.length === 0) continue;

                const orderId = cells[0].textContent.toLowerCase();
                const customer = cells[1].textContent.toLowerCase();
                const status = cells[5].textContent.trim().toLowerCase();

                let match = true;
                if (orderSearch && !orderId.includes(orderSearch)) match = false;
                if (customerSearch && !customer.includes(customerSearch)) match = false;
                if (statusFilter && !status.includes(statusFilter)) match = false;

                row.style.display = match ? '' : 'none';
            }
        }

        window.onclick = function(event) {
            const modal = document.getElementById('orderModal');
            if (event.target === modal) modal.style.display = 'none';
        };
    </script>
</body>
</html>
