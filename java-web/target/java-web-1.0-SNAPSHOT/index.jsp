<%-- 
    Home/Landing Page - Modern Design
    Date: 13 Apr 2026
    Author: Ashish
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HyStore - Hybrid E-Commerce System</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        :root {
            --primary: #667eea;
            --secondary: #764ba2;
            --dark: #2c3e50;
            --light: #ecf0f1;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            color: #333;
        }
        
        /* Header Styles */
        header {
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            color: white;
            padding: 1rem 0;
            position: sticky;
            top: 0;
            z-index: 100;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        
        header nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
            flex-wrap: wrap;
            gap: 1rem;
        }
        
        header .logo {
            font-size: 1.8rem;
            font-weight: bold;
            letter-spacing: 1px;
        }
        
        header nav ul {
            list-style: none;
            display: flex;
            gap: 2rem;
        }
        
        header nav a {
            color: white;
            text-decoration: none;
            transition: 0.3s;
            font-weight: 500;
            position: relative;
        }
        
        header nav a:hover::after {
            content: '';
            position: absolute;
            bottom: -5px;
            left: 0;
            width: 100%;
            height: 2px;
            background: white;
        }
        
        /* Button Styles */
        .btn {
            display: inline-block;
            padding: 12px 24px;
            background: var(--primary);
            color: white;
            text-decoration: none;
            border-radius: 50px;
            transition: all 0.3s ease;
            border: 2px solid transparent;
            cursor: pointer;
            font-size: 1rem;
            font-weight: 600;
        }
        
        .btn:hover {
            background: var(--secondary);
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.4);
        }
        
        .btn-secondary {
            background: white;
            color: var(--primary);
            border: 2px solid var(--primary);
            padding: 8px 15px;
            font-size: 0.9rem;
        }
        
        .btn-secondary:hover {
            background: var(--primary);
            color: white;
        }
        
        /* Hero Section */
        .hero {
            background: linear-gradient(135deg, rgba(102, 126, 234, 0.95) 0%, rgba(118, 75, 162, 0.95) 100%);
            color: white;
            text-align: center;
            padding: 120px 20px;
            min-height: 600px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            position: relative;
            overflow: hidden;
        }
        
        .hero::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -10%;
            width: 500px;
            height: 500px;
            background: rgba(255,255,255,0.1);
            border-radius: 50%;
            animation: float 6s ease-in-out infinite;
        }
        
        .hero::after {
            content: '';
            position: absolute;
            bottom: -30%;
            left: -5%;
            width: 400px;
            height: 400px;
            background: rgba(255,255,255,0.05);
            border-radius: 50%;
            animation: float 8s ease-in-out infinite reverse;
        }
        
        @keyframes float {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(30px); }
        }
        
        .hero-content {
            position: relative;
            z-index: 2;
            animation: fadeInUp 0.8s ease-in-out;
        }
        
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .hero h1 {
            font-size: 3.5rem;
            margin-bottom: 1.5rem;
            font-weight: 700;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
            letter-spacing: 1px;
        }
        
        .hero p {
            font-size: 1.3rem;
            margin-bottom: 2rem;
            max-width: 600px;
            margin-left: auto;
            margin-right: auto;
            line-height: 1.8;
        }
        
        .hero-buttons {
            display: flex;
            gap: 1rem;
            justify-content: center;
            flex-wrap: wrap;
        }
        
        /* Section Styles */
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 60px 20px;
        }
        
        h2 {
            margin: 40px 0 40px;
            font-size: 2.5rem;
            color: var(--dark);
            text-align: center;
            position: relative;
            padding-bottom: 15px;
        }
        
        h2::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 80px;
            height: 4px;
            background: linear-gradient(90deg, var(--primary), var(--secondary));
            border-radius: 2px;
        }
        
        /* Features Grid */
        .features {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 30px;
            margin-bottom: 40px;
        }
        
        .feature-box {
            background: white;
            padding: 30px;
            border-radius: 15px;
            text-align: center;
            transition: all 0.3s ease;
            border: 2px solid transparent;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            cursor: pointer;
        }
        
        .feature-box:hover {
            transform: translateY(-10px);
            border-color: var(--primary);
            box-shadow: 0 15px 40px rgba(102, 126, 234, 0.2);
        }
        
        .feature-box h3 {
            color: var(--primary);
            margin: 15px 0;
            font-size: 1.4rem;
        }
        
        .feature-box p {
            color: #666;
            line-height: 1.8;
        }
        
        .feature-icon {
            font-size: 2.5rem;
            margin-bottom: 10px;
        }
        
        /* Products Section */
        .products-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }
        
        .product-card {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            border: 1px solid #eee;
        }
        
        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 30px rgba(102, 126, 234, 0.2);
        }
        
        .product-image {
            width: 100%;
            height: 200px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 3rem;
            color: white;
        }
        
        .product-info {
            padding: 20px;
        }
        
        .product-info h4 {
            margin-bottom: 8px;
            color: var(--dark);
            font-size: 1.1rem;
        }
        
        .product-info p {
            color: #666;
            margin-bottom: 15px;
            font-size: 0.9rem;
        }
        
        .product-price {
            font-size: 1.3rem;
            color: var(--primary);
            font-weight: bold;
            margin-bottom: 15px;
        }
        
        /* Testimonials */
        .testimonials {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }
        
        .testimonial-card {
            background: #f8f9fa;
            padding: 30px;
            border-radius: 12px;
            border-left: 4px solid var(--primary);
        }
        
        .stars {
            color: #ffc107;
            margin-bottom: 15px;
            font-size: 1.2rem;
        }
        
        .testimonial-text {
            color: #555;
            margin-bottom: 15px;
            font-style: italic;
            line-height: 1.8;
        }
        
        .testimonial-author {
            font-weight: bold;
            color: var(--primary);
        }
        
        /* Newsletter Section */
        .newsletter {
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            color: white;
            padding: 50px;
            border-radius: 15px;
            text-align: center;
            margin: 40px 0;
        }
        
        .newsletter h2 { color: white; }
        .newsletter h2::after { background: rgba(255,255,255,0.5); }
        
        .newsletter-form {
            display: flex;
            gap: 10px;
            max-width: 500px;
            margin: 25px auto;
            flex-wrap: wrap;
            justify-content: center;
        }
        
        .newsletter-form input {
            flex: 1;
            min-width: 250px;
            padding: 12px 20px;
            border: none;
            border-radius: 50px;
            font-size: 1rem;
        }
        
        /* Footer */
        footer {
            background: var(--dark);
            color: white;
            padding: 50px 20px 20px;
            margin-top: 60px;
        }
        
        .footer-content {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 30px;
            max-width: 1200px;
            margin: 0 auto 30px;
        }
        
        .footer-section h4 {
            margin-bottom: 15px;
            color: var(--primary);
            font-size: 1.1rem;
        }
        
        .footer-section ul {
            list-style: none;
        }
        
        .footer-section ul li {
            margin-bottom: 8px;
        }
        
        .footer-section a {
            color: #bbb;
            text-decoration: none;
            transition: 0.3s;
        }
        
        .footer-section a:hover {
            color: white;
            padding-left: 5px;
        }
        
        .footer-bottom {
            text-align: center;
            border-top: 1px solid #444;
            padding-top: 20px;
            color: #999;
        }
        
        .auth-links {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
            align-items: center;
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .hero h1 { font-size: 2.2rem; }
            .hero p { font-size: 1.1rem; }
            h2 { font-size: 1.8rem; }
            header nav ul { gap: 1rem; }
            .hero-buttons { flex-direction: column; align-items: center; }
            .hero-buttons .btn { width: 100%; max-width: 300px; }
        }
    </style>
</head>
<body>
    <!-- Navigation Header -->
    <header>
        <nav>
            <div class="logo">🛍️ HyStore</div>
            <ul>
                <li><a href="index.jsp">Home</a></li>
                <li><a href="products.jsp">Products</a></li>
                <li><a href="cart.jsp">Cart</a></li>
                <li><a href="admin-login.jsp">Admin</a></li>
            </ul>
            <div class="auth-links">
                <% 
                    if (session.getAttribute("user") == null) {
                %>
                    <a href="login.jsp" class="btn btn-secondary">Login</a>
                    <a href="register.jsp" class="btn btn-secondary">Register</a>
                <% 
                    } else {
                %>
                    <span style="color: white; font-weight: 500;">Welcome, <%= session.getAttribute("username") %>!</span>
                    <a href="logout" class="btn btn-secondary">Logout</a>
                <% 
                    }
                %>
            </div>
        </nav>
    </header>
    
    <!-- Hero Section -->
    <section class="hero">
        <div class="hero-content">
            <h1>🚀 Welcome to HyStore</h1>
            <p>Your ultimate hybrid shopping destination - Quality products at unbeatable prices</p>
            <div class="hero-buttons">
                <a href="products.jsp" class="btn">🛒 Start Shopping</a>
                <a href="products.jsp" class="btn btn-secondary">📱 View Catalog</a>
            </div>
        </div>
    </section>
    
    <!-- Main Content -->
    <div class="container">
        <!-- Why Choose Us Section -->
        <section>
            <h2>💎 Why Choose Us?</h2>
            <div class="features">
                <div class="feature-box">
                    <div class="feature-icon">💰</div>
                    <h3>Best Prices</h3>
                    <p>Competitive pricing on thousands of products from trusted brands. Get the best deals every day!</p>
                </div>
                <div class="feature-box">
                    <div class="feature-icon">⚡</div>
                    <h3>Fast Delivery</h3>
                    <p>Quick and reliable shipping directly to your doorstep within 2-5 business days.</p>
                </div>
                <div class="feature-box">
                    <div class="feature-icon">🔒</div>
                    <h3>Secure Payment</h3>
                    <p>Multiple payment options with secure transaction processing and data encryption.</p>
                </div>
                <div class="feature-box">
                    <div class="feature-icon">🎧</div>
                    <h3>Customer Support</h3>
                    <p>24/7 customer service ready to assist you anytime via chat, email, or phone.</p>
                </div>
                <div class="feature-box">
                    <div class="feature-icon">🔄</div>
                    <h3>Easy Returns</h3>
                    <p>Hassle-free returns within 30 days of purchase. No questions asked!</p>
                </div>
                <div class="feature-box">
                    <div class="feature-icon">📦</div>
                    <h3>Wide Selection</h3>
                    <p>Browse from hundreds of products across multiple categories all in one place.</p>
                </div>
            </div>
        </section>
        
        <!-- Featured Products Section -->
        <section>
            <h2>⭐ Featured Products</h2>
            <div class="products-grid">
                <div class="product-card">
                    <div class="product-image">📱</div>
                    <div class="product-info">
                        <h4>Smartphone Pro Max</h4>
                        <p>Latest technology with advanced camera and 5G connectivity</p>
                        <div class="stars">★★★★★</div>
                        <div class="product-price">$899.99</div>
                        <a href="products.jsp" class="btn" style="display: block; text-align: center;">View Details</a>
                    </div>
                </div>
                <div class="product-card">
                    <div class="product-image">💻</div>
                    <div class="product-info">
                        <h4>Ultra-Slim Laptop</h4>
                        <p>High-performance computing with stunning display and long battery life</p>
                        <div class="stars">★★★★★</div>
                        <div class="product-price">$1,299.99</div>
                        <a href="products.jsp" class="btn" style="display: block; text-align: center;">View Details</a>
                    </div>
                </div>
                <div class="product-card">
                    <div class="product-image">⌚</div>
                    <div class="product-info">
                        <h4>Smart Watch Elite</h4>
                        <p>Stay connected with health tracking, notifications, and stylish design</p>
                        <div class="stars">★★★★☆</div>
                        <div class="product-price">$299.99</div>
                        <a href="products.jsp" class="btn" style="display: block; text-align: center;">View Details</a>
                    </div>
                </div>
            </div>
        </section>
        
        <!-- Categories Section -->
        <section>
            <h2>🏪 Shop by Category</h2>
            <div class="features">
                <div class="feature-box" onclick="window.location.href='products.jsp';">
                    <div class="feature-icon">📱</div>
                    <h3>Electronics</h3>
                    <p>Latest gadgets and technology products</p>
                </div>
                <div class="feature-box" onclick="window.location.href='products.jsp';">
                    <div class="feature-icon">👕</div>
                    <h3>Fashion</h3>
                    <p>Trendy clothing and accessories for all styles</p>
                </div>
                <div class="feature-box" onclick="window.location.href='products.jsp';">
                    <div class="feature-icon">🏠</div>
                    <h3>Home & Garden</h3>
                    <p>Everything you need to make your home comfortable</p>
                </div>
                <div class="feature-box" onclick="window.location.href='products.jsp';">
                    <div class="feature-icon">📚</div>
                    <h3>Books & Media</h3>
                    <p>Physical and digital books, movies, and entertainment</p>
                </div>
                <div class="feature-box" onclick="window.location.href='products.jsp';">
                    <div class="feature-icon">🎮</div>
                    <h3>Gaming</h3>
                    <p>Gaming consoles, games, and accessories</p>
                </div>
                <div class="feature-box" onclick="window.location.href='products.jsp';">
                    <div class="feature-icon">💪</div>
                    <h3>Sports & Fitness</h3>
                    <p>Equipment and gear for your active lifestyle</p>
                </div>
            </div>
        </section>
        
        <!-- Testimonials Section -->
        <section>
            <h2>🌟 What Our Customers Say</h2>
            <div class="testimonials">
                <div class="testimonial-card">
                    <div class="stars">★★★★★</div>
                    <div class="testimonial-text">"Excellent experience! Fast delivery and great customer support. I'll definitely shop here again!"</div>
                    <div class="testimonial-author">- Sarah Johnson</div>
                </div>
                <div class="testimonial-card">
                    <div class="stars">★★★★★</div>
                    <div class="testimonial-text">"Amazing prices and fantastic product quality. This is now my go-to shopping platform."</div>
                    <div class="testimonial-author">- Mike Chen</div>
                </div>
                <div class="testimonial-card">
                    <div class="stars">★★★★☆</div>
                    <div class="testimonial-text">"Great selection and easy checkout process. A little faster shipping would be perfect!"</div>
                    <div class="testimonial-author">- Emily Rodriguez</div>
                </div>
            </div>
        </section>
        
        <!-- Newsletter Section -->
        <section class="newsletter">
            <h2>📧 Subscribe to Our Newsletter</h2>
            <p>Get exclusive deals, new product launches, and special offers directly to your inbox!</p>
            <form class="newsletter-form" onsubmit="event.preventDefault(); alert('Thank you for subscribing!');">
                <input type="email" placeholder="Enter your email address" required>
                <button type="submit" class="btn">Subscribe Now</button>
            </form>
        </section>
    </div>
    
    <!-- Footer -->
    <footer>
        <div class="footer-content">
            <div class="footer-section">
                <h4>About HyStore</h4>
                <p>Your trusted hybrid e-commerce platform offering quality products with exceptional service.</p>
            </div>
            <div class="footer-section">
                <h4>Quick Links</h4>
                <ul>
                    <li><a href="products.jsp">Shop Now</a></li>
                    <li><a href="#">About Us</a></li>
                    <li><a href="#">Contact Us</a></li>
                    <li><a href="#">Careers</a></li>
                </ul>
            </div>
            <div class="footer-section">
                <h4>Customer Service</h4>
                <ul>
                    <li><a href="#">FAQ</a></li>
                    <li><a href="#">Shipping Info</a></li>
                    <li><a href="#">Returns</a></li>
                    <li><a href="#">Track Order</a></li>
                </ul>
            </div>
            <div class="footer-section">
                <h4>Connect With Us</h4>
                <ul>
                    <li><a href="#">Facebook</a></li>
                    <li><a href="#">Twitter</a></li>
                    <li><a href="#">Instagram</a></li>
                    <li><a href="#">LinkedIn</a></li>
                </ul>
            </div>
        </div>
        <div class="footer-bottom">
            <p>&copy; 2026 Hybrid E-Commerce System. All rights reserved.</p>
            <p>Developed with Java Servlets, Node.js Express, and MongoDB | Secure Payment Processing</p>
        </div>
    </footer>
</body>
</html>
