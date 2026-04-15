<%-- 
    Admin Users Management Page
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.ecommerce.db.DatabaseConnection" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users - Admin</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f5f5f5; }
        header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 1rem; }
        .container { max-width: 1200px; margin: 0 auto; padding: 20px; }
        h1 { color: white; font-size: 1.8rem; }
        .content { background: white; border-radius: 8px; padding: 20px; margin-top: 20px; }
        .filter-bar { display: flex; gap: 10px; margin-bottom: 20px; flex-wrap: wrap; padding: 15px; background: #f9f9f9; border-radius: 5px; }
        .filter-bar input, .filter-bar select { padding: 8px 12px; border: 1px solid #ddd; border-radius: 5px; }
        .btn { padding: 8px 15px; background: #667eea; color: white; border: none; border-radius: 5px; cursor: pointer; font-weight: 600; }
        .btn:hover { background: #764ba2; }
        .btn-danger { background: #dc3545; }
        .btn-danger:hover { background: #c82333; }
        .btn-success { background: #28a745; }
        .btn-success:hover { background: #218838; }
        table { width: 100%; border-collapse: collapse; }
        th { background: #f5f5f5; padding: 12px; text-align: left; border-bottom: 2px solid #ddd; font-weight: bold; }
        td { padding: 12px; border-bottom: 1px solid #eee; }
        tr:hover { background: #f9f9f9; }
        .role-badge, .status-badge { display: inline-block; padding: 5px 10px; border-radius: 3px; font-size: 0.85rem; font-weight: bold; }
        .role-admin { background: #cce5ff; color: #004085; }
        .role-customer { background: #d1ecf1; color: #0c5460; }
        .status-active { background: #d4edda; color: #155724; }
        .status-inactive { background: #f8d7da; color: #721c24; }
        .actions { display: flex; gap: 5px; }
        .btn-small { padding: 5px 10px; font-size: 0.85rem; }
        footer { background: #333; color: white; text-align: center; padding: 20px; margin-top: 40px; }
        .modal { display: none; position: fixed; z-index: 1000; inset: 0; background-color: rgba(0,0,0,0.5); }
        .modal-content { background-color: white; margin: 10% auto; padding: 30px; border-radius: 8px; width: 90%; max-width: 500px; }
        .close { color: #aaa; float: right; font-size: 28px; font-weight: bold; cursor: pointer; }
        .user-detail { margin-bottom: 12px; padding-bottom: 12px; border-bottom: 1px solid #eee; }
        .user-detail label { font-weight: bold; color: #333; display: block; margin-bottom: 5px; }
        .user-detail span { color: #666; }
    </style>
</head>
<body>
    <header>
        <div class="container">
            <div style="display: flex; justify-content: space-between; align-items: center;">
                <div><h1>User Management</h1></div>
                <div>
                    <a href="admin-dashboard.jsp" style="color: white; text-decoration: none; margin-right: 15px;">Dashboard</a>
                    <a href="logout" style="color: white; text-decoration: none;">Logout</a>
                </div>
            </div>
        </div>
    </header>

    <div class="container">
        <div class="content">
            <div class="filter-bar">
                <input type="text" id="searchUser" placeholder="Search by username or email...">
                <select id="roleFilter">
                    <option value="">All Roles</option>
                    <option value="admin">Admin</option>
                    <option value="customer">Customer</option>
                </select>
                <select id="statusFilter">
                    <option value="">All Status</option>
                    <option value="active">Active</option>
                    <option value="inactive">Inactive</option>
                </select>
                <button class="btn" onclick="filterUsers()">Filter</button>
                <button class="btn" style="background: #999;" onclick="clearFilters()">Clear</button>
            </div>

            <table id="usersTable">
                <thead>
                    <tr>
                        <th>User ID</th>
                        <th>Username</th>
                        <th>Email</th>
                        <th>Full Name</th>
                        <th>Role</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody id="usersTableBody">
                    <%
                        try {
                            Connection conn = DatabaseConnection.getConnection();
                            Statement stmt = conn.createStatement();
                            ResultSet rs = stmt.executeQuery("SELECT user_id, username, email, full_name, role, status FROM users ORDER BY user_id");
                            boolean hasUsers = false;

                            while (rs.next()) {
                                hasUsers = true;
                                int userId = rs.getInt("user_id");
                                String username = rs.getString("username");
                                String email = rs.getString("email");
                                String fullName = rs.getString("full_name");
                                String role = rs.getString("role");
                                String status = rs.getString("status");
                    %>
                    <tr>
                        <td>#U<%=String.format("%03d", userId)%></td>
                        <td><%=username%></td>
                        <td><%=email%></td>
                        <td><%=fullName%></td>
                        <td>
                            <span class="role-badge <%= "admin".equals(role) ? "role-admin" : "role-customer" %>">
                                <%= "admin".equals(role) ? "Admin" : "Customer" %>
                            </span>
                        </td>
                        <td>
                            <span class="status-badge <%= "active".equals(status) ? "status-active" : "status-inactive" %>">
                                <%= "active".equals(status) ? "Active" : "Inactive" %>
                            </span>
                        </td>
                        <td>
                            <div class="actions">
                                <button class="btn btn-small" onclick="viewUser(<%=userId%>)">View</button>
                                <button class="btn btn-small <%= "active".equals(status) ? "btn-danger" : "btn-success" %>" onclick="toggleUserStatus(<%=userId%>, '<%=username%>', '<%=status%>')">
                                    <%= "active".equals(status) ? "Deactivate" : "Activate" %>
                                </button>
                            </div>
                        </td>
                    </tr>
                    <%
                            }
                            if (!hasUsers) {
                                out.println("<tr><td colspan='7' style='text-align:center; color:#999;'>No users found</td></tr>");
                            }
                            rs.close();
                            stmt.close();
                            conn.close();
                        } catch (Exception e) {
                            out.println("<tr><td colspan='7' style='text-align:center; color:red;'>Error loading users: " + e.getMessage() + "</td></tr>");
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>

    <div id="userModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeUserModal()">&times;</span>
            <h2>User Details</h2>
            <div id="userDetails"></div>
        </div>
    </div>

    <footer>
        <p>&copy; 2026 Hybrid E-Commerce System. All rights reserved.</p>
    </footer>

    <script>
        function viewUser(userId) {
            fetch('getUserDetails.jsp?userId=' + userId)
                .then(response => response.json())
                .then(data => {
                    document.getElementById('userDetails').innerHTML = `
                        <div class="user-detail"><label>User ID:</label><span>#U\${String(data.user_id).padStart(3, '0')}</span></div>
                        <div class="user-detail"><label>Username:</label><span>\${data.username}</span></div>
                        <div class="user-detail"><label>Email:</label><span>\${data.email}</span></div>
                        <div class="user-detail"><label>Full Name:</label><span>\${data.full_name || 'N/A'}</span></div>
                        <div class="user-detail"><label>Phone:</label><span>\${data.phone || 'N/A'}</span></div>
                        <div class="user-detail"><label>Address:</label><span>\${data.address || 'N/A'}, \${data.city || ''}, \${data.state || ''} \${data.postal_code || ''}</span></div>
                        <div class="user-detail"><label>Role:</label><span>\${data.role}</span></div>
                        <div class="user-detail"><label>Status:</label><span>\${data.status || 'active'}</span></div>
                        <div class="user-detail"><label>Member Since:</label><span>\${data.created_at || 'N/A'}</span></div>
                    `;
                    document.getElementById('userModal').style.display = 'block';
                })
                .catch(error => alert('Error loading user details: ' + error));
        }

        function closeUserModal() {
            document.getElementById('userModal').style.display = 'none';
        }

        function toggleUserStatus(userId, username, currentStatus) {
            const nextStatus = currentStatus === 'active' ? 'inactive' : 'active';
            if (confirm(`Are you sure you want to set user "\${username}" to \${nextStatus}?`)) {
                fetch('toggleUserStatus.jsp?userId=' + userId + '&status=' + nextStatus, { method: 'GET' })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            location.reload();
                        } else {
                            alert('Error: ' + data.message);
                        }
                    })
                    .catch(error => alert('Error updating user: ' + error));
            }
        }

        function filterUsers() {
            const userSearch = document.getElementById('searchUser').value.toLowerCase();
            const roleFilter = document.getElementById('roleFilter').value;
            const statusFilter = document.getElementById('statusFilter').value;
            const rows = document.getElementById('usersTableBody').getElementsByTagName('tr');

            for (const row of rows) {
                const cells = row.getElementsByTagName('td');
                if (cells.length === 0) continue;

                const username = cells[1].textContent.toLowerCase();
                const email = cells[2].textContent.toLowerCase();
                const role = cells[4].textContent.toLowerCase();
                const status = cells[5].textContent.toLowerCase();

                let match = true;
                if (userSearch && !username.includes(userSearch) && !email.includes(userSearch)) match = false;
                if (roleFilter && !role.includes(roleFilter)) match = false;
                if (statusFilter && !status.includes(statusFilter)) match = false;

                row.style.display = match ? '' : 'none';
            }
        }

        function clearFilters() {
            document.getElementById('searchUser').value = '';
            document.getElementById('roleFilter').value = '';
            document.getElementById('statusFilter').value = '';
            const rows = document.getElementById('usersTableBody').getElementsByTagName('tr');
            for (const row of rows) row.style.display = '';
        }

        window.onclick = function(event) {
            const modal = document.getElementById('userModal');
            if (event.target === modal) modal.style.display = 'none';
        }
    </script>
</body>
</html>
