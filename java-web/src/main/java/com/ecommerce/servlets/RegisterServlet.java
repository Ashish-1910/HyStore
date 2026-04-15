// ===============================================
// JAVA REGISTER SERVLET
// Save as: src/com/ecommerce/servlets/RegisterServlet.java
// ===============================================

package com.ecommerce.servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;

import com.ecommerce.db.DatabaseConnection;
import com.ecommerce.models.User;

public class RegisterServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        // Get form parameters
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String fullName = request.getParameter("fullName");
        
        // Validation
        if (username == null || username.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            fullName == null || fullName.trim().isEmpty()) {
            
            request.setAttribute("error", "All fields are required!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        if (password.length() < 6) {
            request.setAttribute("error", "Password must be at least 6 characters!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        // Register user
        try {
            Connection conn = DatabaseConnection.getConnection();
            
            // Check if user already exists
            String checkQuery = "SELECT * FROM users WHERE username = ? OR email = ?";
            PreparedStatement checkStmt = conn.prepareStatement(checkQuery);
            checkStmt.setString(1, username);
            checkStmt.setString(2, email);
            
            ResultSet rs = checkStmt.executeQuery();
            
            if (rs.next()) {
                request.setAttribute("error", "Username or Email already exists!");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                checkStmt.close();
                conn.close();
                return;
            }
            
            // Insert new user
            String insertQuery = "INSERT INTO users (username, email, password, full_name, role, status) " +
                                "VALUES (?, ?, ?, ?, 'customer', 'active')";
            PreparedStatement insertStmt = conn.prepareStatement(insertQuery);
            insertStmt.setString(1, username);
            insertStmt.setString(2, email);
            insertStmt.setString(3, password);  // In production, hash this password!
            insertStmt.setString(4, fullName);
            
            int result = insertStmt.executeUpdate();
            
            if (result > 0) {
                request.setAttribute("success", "Registration successful! Please login.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Registration failed! Try again.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
            }
            
            insertStmt.close();
            checkStmt.close();
            conn.close();
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("register.jsp");
    }
}

// ===============================================
// IMPORTANT SECURITY NOTES:
// ===============================================
// 1. ⚠️ PASSWORDS ARE NOT ENCRYPTED IN THIS DEMO!
//    In production, use bcrypt or similar:
//    password = BCrypt.hashpw(password, BCrypt.gensalt());
//
// 2. Always validate input on server-side
// 3. Use HTTPS for production
// 4. Implement CSRF tokens
// 5. Use prepared statements to prevent SQL injection
// ===============================================
