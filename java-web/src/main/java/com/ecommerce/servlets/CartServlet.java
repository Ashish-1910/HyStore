package com.ecommerce.servlets;

import com.ecommerce.models.CartItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "CartServlet", urlPatterns = {"/cart"})
public class CartServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Just redirect to cart.jsp to show the cart
        response.sendRedirect("cart.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        
        // Get or create cart in session
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
            session.setAttribute("cart", cart);
        }
        
        try {
            if ("add".equals(action) || action == null) {
                addItem(request, cart);
                if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                    response.setContentType("text/plain");
                    response.getWriter().write("Success");
                    return;
                }
            } else if ("remove".equals(action)) {
                String productId = request.getParameter("productId");
                cart.removeIf(item -> item.getProductId().equals(productId));
            } else if ("update".equals(action)) {
                String productId = request.getParameter("productId");
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                for (CartItem item : cart) {
                    if (item.getProductId().equals(productId)) {
                        item.setQuantity(quantity);
                        break;
                    }
                }
            } else if ("clear".equals(action)) {
                cart.clear();
            }
            
            response.sendRedirect("cart.jsp");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, e.getMessage());
        }
    }

    private void addItem(HttpServletRequest request, List<CartItem> cart) {
        String productId = request.getParameter("productId");
        String productName = request.getParameter("name");
        String priceStr = request.getParameter("price");
        String quantityStr = request.getParameter("quantity");
        String imageUrl = request.getParameter("imageUrl");
        
        double price = priceStr != null ? Double.parseDouble(priceStr) : 0.0;
        int quantity = quantityStr != null ? Integer.parseInt(quantityStr) : 1;
        
        // Check if item already exists in cart
        boolean found = false;
        for (CartItem item : cart) {
            if (item.getProductId().equals(productId)) {
                item.setQuantity(item.getQuantity() + quantity);
                found = true;
                break;
            }
        }
        
        if (!found) {
            cart.add(new CartItem(productId, productName != null ? productName : "Product", price, quantity, imageUrl));
        }
    }
}
