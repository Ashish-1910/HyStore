// ===============================================
// JAVA ADMIN LOGIN SERVLET
// Save as: src/com/ecommerce/servlets/AdminLoginServlet.java
// ===============================================

package com.ecommerce.servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;

import com.ecommerce.db.DatabaseConnection;
import com.ecommerce.models.User;

public class AdminLoginServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        // Get form parameters
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        // Validation
        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            
            request.setAttribute("error", "Username and password are required!");
            request.getRequestDispatcher("admin-login.jsp").forward(request, response);
            return;
        }
        
        // Authenticate admin user
        try {
            Connection conn = DatabaseConnection.getConnection();
            
            // Query for admin user
            String query = "SELECT * FROM users WHERE username = ? AND password = ? AND role = 'admin' AND status = 'active'";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, username);
            stmt.setString(2, password);
            
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                // Admin found - Create session
                User admin = new User();
                admin.setUserId(rs.getInt("user_id"));
                admin.setUsername(rs.getString("username"));
                admin.setEmail(rs.getString("email"));
                admin.setFullName(rs.getString("full_name"));
                admin.setRole(rs.getString("role"));
                
                // Create session
                HttpSession session = request.getSession();
                session.setAttribute("admin", admin);
                session.setAttribute("adminId", admin.getUserId());
                session.setAttribute("adminUsername", admin.getUsername());
                session.setAttribute("role", "admin");
                session.setMaxInactiveInterval(30 * 60);  // 30 minutes timeout
                
                // Redirect to admin dashboard
                response.sendRedirect(request.getContextPath() + "/admin-dashboard.jsp");
            } else {
                // Admin not found
                request.setAttribute("error", "Invalid admin credentials!");
                request.getRequestDispatcher("admin-login.jsp").forward(request, response);
            }
            
            stmt.close();
            conn.close();
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            request.getRequestDispatcher("admin-login.jsp").forward(request, response);
        }
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("admin-login.jsp");
    }
}

// ===============================================
// TEST CREDENTIALS FOR ADMIN:
// ===============================================
// Username: admin_user
// Password: admin123
// ===============================================
