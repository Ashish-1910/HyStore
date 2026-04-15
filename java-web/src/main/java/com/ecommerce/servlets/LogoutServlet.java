// ===============================================
// JAVA LOGOUT SERVLET
// Save as: src/com/ecommerce/servlets/LogoutServlet.java
// ===============================================

package com.ecommerce.servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.*;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get current session
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            // Invalidate session
            session.invalidate();
        }
        
        // Redirect to home
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}