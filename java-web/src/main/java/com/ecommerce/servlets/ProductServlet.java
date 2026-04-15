// ===============================================
// JAVA PRODUCT SERVLET
// Save as: src/com/ecommerce/servlets/ProductServlet.java
// ===============================================

package com.ecommerce.servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;

public class ProductServlet extends HttpServlet {
    
    private static final String API_URL = "http://localhost:3000/api";
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null || action.isEmpty()) {
            // Show all products
            response.sendRedirect("products.jsp");
        } else if ("detail".equals(action)) {
            // Show product detail
            String productId = request.getParameter("id");
            request.setAttribute("productId", productId);
            request.getRequestDispatcher("product-detail.jsp").forward(request, response);
        } else if ("addToCart".equals(action)) {
            response.sendRedirect("cart.jsp");
        } else {
            response.sendRedirect("products.jsp");
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
