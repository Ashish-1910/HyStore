<%@page contentType="application/json" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%><%@ page import="java.net.*" %><%@ page import="java.io.*" %><%
    try {
        String productId = request.getParameter("productId");
        
        if (productId == null || productId.trim().isEmpty()) {
            out.print("{\"error\": \"Product ID not provided\"}");
            return;
        }
        
        productId = productId.trim();
        
        // Call Node.js API to fetch product details (Using 127.0.0.1 for better reliability on Windows)
        URL url = new URL("http://127.0.0.1:3000/api/products/" + productId);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setConnectTimeout(5000);
        conn.setReadTimeout(5000);
        
        int responseCode = conn.getResponseCode();
        
        if (responseCode == 200) {
            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                sb.append(line);
            }
            br.close();
            out.print(sb.toString());
        } else {
            out.print("{\"error\": \"Product not found (Status: " + responseCode + ")\"}");
        }
        
        conn.disconnect();
    } catch (Exception e) {
        // Log error and return valid JSON
        System.err.println("Error in getProductDetails: " + e.getMessage());
        out.print("{\"error\": \"Backend connection error: " + e.getMessage().replace("\"", "'") + "\"}");
    }
%>
