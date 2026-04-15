// ===============================================
// JAVA ADMIN PRODUCT SERVLET
// Save as: src/com/ecommerce/servlets/AdminProductServlet.java
// ===============================================

package com.ecommerce.servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.*;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.HttpClientBuilder;
import org.json.JSONObject;

public class AdminProductServlet extends HttpServlet {
    
    private static final String API_URL = "http://localhost:3000/api";
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is admin
        HttpSession session = request.getSession(false);
        
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("admin-login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("edit".equals(action)) {
            String productId = request.getParameter("id");
            request.setAttribute("productId", productId);
            request.getRequestDispatcher("admin-edit-product.jsp").forward(request, response);
        } else if ("delete".equals(action)) {
            deleteProduct(request, response);
        } else {
            response.sendRedirect("admin-dashboard.jsp");
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is admin
        HttpSession session = request.getSession(false);
        
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("admin-login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("add".equals(action)) {
            addProduct(request, response);
        } else if ("update".equals(action)) {
            updateProduct(request, response);
        } else {
            response.sendRedirect("admin-dashboard.jsp");
        }
    }
    
    // Add new product
    private void addProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String name = request.getParameter("name");
            String category = request.getParameter("category");
            String description = request.getParameter("description");
            String price = request.getParameter("price");
            String stock = request.getParameter("stock");
            String imageUrl = request.getParameter("imageUrl");
            
            // Create JSON object
            JSONObject productJson = new JSONObject();
            productJson.put("name", name);
            productJson.put("category", category);
            productJson.put("description", description);
            productJson.put("price", Double.parseDouble(price));
            productJson.put("stock", Integer.parseInt(stock));
            productJson.put("image_url", imageUrl);
            
            // Call Node.js API
            HttpClient httpClient = HttpClientBuilder.create().build();
            HttpPost httpPost = new HttpPost(API_URL + "/products");
            httpPost.setHeader("Content-Type", "application/json");
            httpPost.setEntity(new StringEntity(productJson.toString()));
            
            HttpResponse apiResponse = httpClient.execute(httpPost);
            
            if (apiResponse.getStatusLine().getStatusCode() == 201) {
                request.setAttribute("success", "Product added successfully!");
                request.getRequestDispatcher("admin-dashboard.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Failed to add product!");
                request.getRequestDispatcher("admin-add-product.jsp").forward(request, response);
            }
            
            httpPost.releaseConnection();
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            try {
                request.getRequestDispatcher("admin-add-product.jsp").forward(request, response);
            } catch (ServletException ex) {
                ex.printStackTrace();
            }
        }
    }
    
    // Update product
    private void updateProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String productId = request.getParameter("productId");
        System.out.println("Updating product ID: " + productId);
        
        try {
            if (productId == null || productId.isEmpty()) {
                throw new Exception("Product ID is missing");
            }

            String name = request.getParameter("name");
            String category = request.getParameter("category");
            String description = request.getParameter("description");
            String price = request.getParameter("price");
            String stock = request.getParameter("stock");
            String imageUrl = request.getParameter("imageUrl");
            
            System.out.println("Product details: Name=" + name + ", Price=" + price);
            
            // Create JSON object
            JSONObject productJson = new JSONObject();
            productJson.put("name", name);
            productJson.put("category", category);
            productJson.put("description", description);
            if (price != null && !price.isEmpty()) productJson.put("price", Double.parseDouble(price));
            if (stock != null && !stock.isEmpty()) productJson.put("stock", Integer.parseInt(stock));
            if (imageUrl != null && !imageUrl.isEmpty()) productJson.put("image_url", imageUrl);
            
            // Call Node.js API
            HttpClient httpClient = HttpClientBuilder.create().build();
            HttpPut httpPut = new HttpPut(API_URL + "/products/" + productId);
            httpPut.setHeader("Content-Type", "application/json");
            httpPut.setEntity(new StringEntity(productJson.toString()));
            
            HttpResponse apiResponse = httpClient.execute(httpPut);
            int statusCode = apiResponse.getStatusLine().getStatusCode();
            System.out.println("API Response Status: " + statusCode);
            
            if (statusCode == 200) {
                request.setAttribute("success", "Product updated successfully!");
                response.sendRedirect("admin-dashboard.jsp");
            } else {
                request.setAttribute("error", "Failed to update product! Status Code: " + statusCode);
                request.getRequestDispatcher("admin-edit-product.jsp?productId=" + productId).forward(request, response);
            }
            
            httpPut.releaseConnection();
            
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Error in updateProduct: " + e.getMessage());
            request.setAttribute("error", "Error: " + e.getMessage());
            try {
                request.getRequestDispatcher("admin-edit-product.jsp?productId=" + productId).forward(request, response);
            } catch (ServletException ex) {
                ex.printStackTrace();
            }
        }
    }
    
    // Delete product
    private void deleteProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String productId = request.getParameter("id");
            
            // Call Node.js API
            HttpClient httpClient = HttpClientBuilder.create().build();
            HttpDelete httpDelete = new HttpDelete(API_URL + "/products/" + productId);
            
            HttpResponse apiResponse = httpClient.execute(httpDelete);
            
            if (apiResponse.getStatusLine().getStatusCode() == 200) {
                request.setAttribute("success", "Product deleted successfully!");
            } else {
                request.setAttribute("error", "Failed to delete product!");
            }
            
            httpDelete.releaseConnection();
            response.sendRedirect("admin-dashboard.jsp");
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            try {
                request.getRequestDispatcher("admin-dashboard.jsp").forward(request, response);
            } catch (ServletException ex) {
                ex.printStackTrace();
            }
        }
    }
}

// ===============================================
// IMPORTANT: Maven Dependency Required
// ===============================================
// Add to pom.xml for HTTP client and JSON:
// 
// <dependency>
//     <groupId>org.apache.httpcomponents</groupId>
//     <artifactId>httpclient</artifactId>
//     <version>4.5.13</version>
// </dependency>
// 
// <dependency>
//     <groupId>org.json</groupId>
//     <artifactId>json</artifactId>
//     <version>20230227</version>
// </dependency>
// ===============================================