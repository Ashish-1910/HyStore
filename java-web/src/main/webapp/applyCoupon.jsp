<%@page contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="org.json.*" %>
<%@ page import="com.ecommerce.db.DatabaseConnection" %>
<%
    JSONObject result = new JSONObject();
    try {
        String code = request.getParameter("code");
        double subtotal = Double.parseDouble(request.getParameter("subtotal"));

        Connection conn = DatabaseConnection.getConnection();
        PreparedStatement stmt = conn.prepareStatement(
            "SELECT coupon_id, code, discount_type, discount_value, min_order_amount FROM coupons WHERE code = ? AND is_active = TRUE"
        );
        stmt.setString(1, code);
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            double minOrderAmount = rs.getDouble("min_order_amount");
            if (subtotal < minOrderAmount) {
                session.removeAttribute("appliedCoupon");
                result.put("success", false);
                result.put("message", "Coupon requires minimum order amount of " + minOrderAmount);
            } else {
                double discountAmount = 0;
                String discountType = rs.getString("discount_type");
                double discountValue = rs.getDouble("discount_value");
                if ("percent".equals(discountType)) {
                    discountAmount = subtotal * (discountValue / 100.0);
                } else {
                    discountAmount = discountValue;
                }

                Map<String, Object> coupon = new HashMap<>();
                coupon.put("couponId", rs.getInt("coupon_id"));
                coupon.put("code", rs.getString("code"));
                coupon.put("discountAmount", discountAmount);
                session.setAttribute("appliedCoupon", coupon);

                result.put("success", true);
                result.put("discountAmount", discountAmount);
                result.put("message", "Coupon " + rs.getString("code") + " applied successfully.");
            }
        } else {
            session.removeAttribute("appliedCoupon");
            result.put("success", false);
            result.put("message", "Invalid or inactive coupon code.");
        }

        rs.close();
        stmt.close();
        conn.close();
    } catch (Exception e) {
        result.put("success", false);
        result.put("message", e.getMessage());
    }
    out.print(result.toString());
%>
