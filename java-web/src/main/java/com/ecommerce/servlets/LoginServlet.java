// ===============================================
// JAVA LOGIN SERVLET
// Save as: src/com/ecommerce/servlets/LoginServlet.java
// ===============================================

package com.ecommerce.servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;

import com.ecommerce.db.DatabaseConnection;
import com.ecommerce.models.User;

public class LoginServlet extends HttpServlet {
    
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
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }
        
        // Authenticate user
        try {
            Connection conn = DatabaseConnection.getConnection();
            
            String query = "SELECT * FROM users WHERE username = ? AND password = ? AND role = 'customer' AND status = 'active'";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, username);
            stmt.setString(2, password);
            
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                // User found - Create session
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setFullName(rs.getString("full_name"));
                user.setPhone(rs.getString("phone"));
                user.setAddress(rs.getString("address"));
                user.setCity(rs.getString("city"));
                user.setState(rs.getString("state"));
                user.setPostalCode(rs.getString("postal_code"));
                user.setRole(rs.getString("role"));
                
                // Create session
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setAttribute("userId", user.getUserId());
                session.setAttribute("username", user.getUsername());
                session.setAttribute("role", "customer");
                session.setMaxInactiveInterval(30 * 60);  // 30 minutes timeout
                
                // Redirect to dashboard
                response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
            } else {
                // User not found
                request.setAttribute("error", "Invalid username or password!");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
            
            stmt.close();
            conn.close();
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
}

// ===============================================
// TEST CREDENTIALS FOR CUSTOMER:
// ===============================================
// Username: john_doe
// Password: 123456
//
// Username: jane_smith
// Password: 456789
// ===============================================
