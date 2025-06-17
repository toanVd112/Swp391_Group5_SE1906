<%-- 
    Document   : booking-complete
    Created on : Jun 17, 2025, 8:59:46 AM
    Author     : Arcueid
    Updated    : Enhanced version with header and footer
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*" %>
<%
    // Kiểm tra đã login hay chưa
    Boolean isLoggedIn = (Boolean) session.getAttribute("isLoggedIn");
    if (isLoggedIn == null) isLoggedIn = false;

    // Lấy thông tin user từ session
    String userFirstName = (String) session.getAttribute("userFirstName");
    String userLastName  = (String) session.getAttribute("userLastName");
    String userEmail     = (String) session.getAttribute("userEmail");
    String userPhone     = (String) session.getAttribute("userPhone");
    String userCountry   = (String) session.getAttribute("userCountry");
    String username      = (String) session.getAttribute("username");

    // Lấy thông tin booking từ request
    String roomID         = request.getParameter("roomID");
    String roomTypeID     = request.getParameter("roomTypeID");  // ✅ ĐÃ BỔ SUNG
    String roomTypeName   = request.getParameter("roomTypeName");
    String pricePerNight  = request.getParameter("pricePerNight");
    String checkInDate    = request.getParameter("checkInDate");
    String checkOutDate   = request.getParameter("checkOutDate");
    String roomDetail     =request.getParameter("roomDetail");
    // Set default values nếu null
    userFirstName   = (userFirstName != null) ? userFirstName : "";
    userLastName    = (userLastName  != null) ? userLastName  : "";
    userEmail       = (userEmail     != null) ? userEmail     : "";
    userPhone       = (userPhone     != null) ? userPhone     : "";
    userCountry     = (userCountry   != null) ? userCountry   : "VNM";
    username        = (username      != null) ? username      : "";

    roomID          = (roomID        != null) ? roomID        : "101";
    roomTypeID      = (roomTypeID    != null) ? roomTypeID    : "DELUXE";
    roomTypeName    = (roomTypeName  != null) ? roomTypeName  : "Deluxe Room";
    pricePerNight   = (pricePerNight != null) ? pricePerNight : "1000000";
    checkInDate     = (checkInDate   != null) ? checkInDate   : "2025-06-21";
    checkOutDate    = (checkOutDate  != null) ? checkOutDate  : "2025-06-22";

    // Gợi ý: nếu bạn cần dùng lại, có thể lưu vào session ở đây
    session.setAttribute("checkInDate", checkInDate);
    session.setAttribute("checkOutDate", checkOutDate);
    session.setAttribute("roomID", roomID);
    session.setAttribute("roomTypeID", roomTypeID);
    session.setAttribute("roomTypeName", roomTypeName);
    session.setAttribute("pricePerNight", pricePerNight);
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thanh toán - Hoang Nam Hotel</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            /* Reset và Base Styles */
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
                line-height: 1.6;
                color: #333;
                background-color: #f8f9fa;
                padding-top: 0;
            }

            .container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 20px;
            }

            .container-fluid {
                padding-left: 30px;
                padding-right: 30px;
            }

            /* Header Styles */
            .header {
                background: white;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }

            .top-bar {
                background-color: #f8f9fa;
                padding: 8px 0;
                border-bottom: 1px solid #e9ecef;
                font-size: 14px;
            }

            .top-link {
                color: #6c757d;
                text-decoration: none;
                transition: color 0.2s;
            }

            .top-link:hover {
                color: #0d6efd;
            }

            .main-header {
                padding: 15px 0;
            }

            .logo {
                height: 40px;
            }

            .nav-link {
                color: #343a40;
                font-weight: 500;
                text-decoration: none;
                transition: color 0.2s;
            }

            .nav-link:hover {
                color: #0d6efd;
            }

            .search-box {
                position: relative;
                width: 200px;
            }

            .search-icon {
                position: absolute;
                right: 10px;
                top: 50%;
                transform: translateY(-50%);
                color: #6c757d;
            }

            /* Footer Styles */
            .footer {
                background-color: #343a40;
                color: #fff;
                margin-top: 50px;
            }

            .footer-top {
                border-bottom: 1px solid rgba(255,255,255,0.1);
            }

            .footer-logo {
                height: 40px;
            }

            .social-links {
                display: flex;
                gap: 10px;
            }

            .social-link {
                display: flex;
                align-items: center;
                justify-content: center;
                width: 36px;
                height: 36px;
                border-radius: 50%;
                background-color: rgba(255,255,255,0.1);
                color: white;
                transition: background-color 0.2s;
            }

            .social-link:hover {
                background-color: #0d6efd;
                color: white;
            }

            .footer-title {
                color: white;
                font-size: 18px;
                margin-bottom: 20px;
                font-weight: 600;
            }

            .footer-links {
                list-style: none;
                padding: 0;
                margin: 0;
            }

            .footer-links li {
                margin-bottom: 10px;
            }

            .footer-links a {
                color: rgba(255,255,255,0.7);
                text-decoration: none;
                transition: color 0.2s;
            }

            .footer-links a:hover {
                color: white;
            }

            .gallery-grid {
                display: grid;
                grid-template-columns: repeat(2, 1fr);
                gap: 10px;
            }

            .gallery-item img {
                width: 100%;
                height: 60px;
                object-fit: cover;
                border-radius: 4px;
            }

            .footer-bottom {
                background-color: #212529;
            }

            /* Welcome Card Styles */
            .welcome-card {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                border-radius: 12px;
                padding: 20px;
                margin-bottom: 20px;
                box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
            }

            .welcome-card h2 {
                font-size: 24px;
                margin-bottom: 8px;
            }

            .welcome-card p {
                opacity: 0.9;
                font-size: 16px;
            }

            .user-info {
                display: flex;
                align-items: center;
                gap: 10px;
                margin-top: 10px;
            }

            .user-avatar {
                width: 40px;
                height: 40px;
                background: rgba(255,255,255,0.2);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .login-prompt {
                background: #fff3cd;
                border: 1px solid #ffeaa7;
                color: #856404;
                padding: 15px;
                border-radius: 8px;
                margin-bottom: 20px;
            }

            .login-prompt a {
                color: #2563eb;
                text-decoration: none;
                font-weight: 600;
            }

            /* Layout Grid */
            .booking-layout {
                display: grid;
                grid-template-columns: 2fr 1fr;
                gap: 30px;
                margin-top: 20px;
            }

            @media (max-width: 768px) {
                .booking-layout {
                    grid-template-columns: 1fr;
                    gap: 20px;
                }
            }

            /* Card Styles */
            .card {
                background: white;
                border-radius: 12px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                margin-bottom: 20px;
                overflow: hidden;
                transition: box-shadow 0.3s ease;
            }

            .card:hover {
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            }

            .card-header {
                padding: 20px 24px;
                border-bottom: 1px solid #f0f0f0;
                background: #fafafa;
            }

            .card-title {
                font-size: 20px;
                font-weight: 600;
                color: #1a1a1a;
                margin-bottom: 8px;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .card-content {
                padding: 20px 24px 24px;
            }

            /* Date Picker Styles */
            .date-picker-section {
                background: #f8f9fa;
                border-radius: 8px;
                padding: 16px;
                margin-bottom: 20px;
            }

            .date-row {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 16px;
            }

            .date-group {
                display: flex;
                flex-direction: column;
            }

            .date-label {
                font-weight: 600;
                margin-bottom: 8px;
                color: #374151;
            }

            .date-input {
                padding: 12px;
                border: 2px solid #d1d5db;
                border-radius: 8px;
                font-size: 14px;
                transition: border-color 0.2s;
            }

            .date-input:focus {
                outline: none;
                border-color: #2563eb;
                box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
            }

            /* Safe Booking Section */
            .safe-booking-icon {
                width: 32px;
                height: 32px;
                background: #dbeafe;
                border-radius: 8px;
                display: flex;
                align-items: center;
                justify-content: center;
                color: #2563eb;
            }

            .info-box {
                display: flex;
                align-items: flex-start;
                gap: 12px;
                padding: 16px;
                background: #dbeafe;
                border-radius: 8px;
                margin-bottom: 16px;
                border-left: 4px solid #2563eb;
            }

            .info-box.warning {
                background: linear-gradient(to right, #fef3c7, #fed7aa);
                border-left-color: #fbbf24;
            }

            .info-box i {
                color: #2563eb;
                margin-top: 2px;
            }

            .info-box.warning i {
                color: #d97706;
            }

            .info-text {
                flex: 1;
            }

            .info-text h6 {
                font-weight: 600;
                margin-bottom: 4px;
            }

            .info-text p {
                font-size: 14px;
                color: #6b7280;
                margin: 0;
            }

            .info-text .highlight {
                color: #2563eb;
                font-weight: 600;
            }

            /* Form Styles */
            .form-section {
                margin-bottom: 24px;
            }

            .form-row {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 16px;
                margin-bottom: 16px;
            }

            @media (max-width: 768px) {
                .form-row {
                    grid-template-columns: 1fr;
                }

                .date-row {
                    grid-template-columns: 1fr;
                }
            }

            .form-group {
                margin-bottom: 16px;
            }

            .form-label {
                display: block;
                margin-bottom: 6px;
                font-weight: 500;
                color: #374151;
                font-size: 14px;
            }

            .form-input, .form-select {
                width: 100%;
                padding: 12px;
                border: 2px solid #d1d5db;
                border-radius: 8px;
                font-size: 14px;
                transition: all 0.2s;
                background: white;
            }

            .form-input:focus, .form-select:focus {
                outline: none;
                border-color: #2563eb;
                box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
            }

            .form-input.error {
                border-color: #dc2626;
            }

            .form-input.prefilled {
                background-color: #f0f9ff;
                border-color: #0ea5e9;
            }

            .error-message {
                color: #dc2626;
                font-size: 12px;
                margin-top: 4px;
            }

            .prefill-notice {
                background: #dcfce7;
                color: #166534;
                padding: 8px 12px;
                border-radius: 6px;
                font-size: 12px;
                margin-bottom: 16px;
                display: flex;
                align-items: center;
                gap: 6px;
            }

            .checkbox-group {
                display: flex;
                align-items: flex-start;
                gap: 8px;
                margin-bottom: 16px;
            }

            .checkbox-group input[type="checkbox"] {
                margin-top: 2px;
                transform: scale(1.2);
            }

            .checkbox-group label {
                font-size: 14px;
                line-height: 1.4;
                cursor: pointer;
            }

            /* Room Info */
            .room-info {
                margin-bottom: 16px;
                padding: 16px;
                background: #f8f9fa;
                border-radius: 8px;
                border-left: 4px solid #059669;
            }

            .room-info h6 {
                font-weight: 600;
                margin-bottom: 8px;
            }

            .room-details {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 8px;
                font-size: 14px;
                color: #6b7280;
            }

            .amenity {
                display: flex;
                align-items: center;
                gap: 6px;
                color: #059669;
                font-size: 14px;
                margin-top: 8px;
            }

            /* Payment Method */
            .payment-icons {
                display: flex;
                gap: 8px;
                margin-bottom: 16px;
            }

            .payment-icon {
                width: 40px;
                height: 28px;
                display: flex;
                align-items: center;
                justify-content: center;
                border-radius: 6px;
                font-size: 12px;
                font-weight: bold;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }

            .payment-icon.card {
                background: #2563eb;
                color: white;
            }

            .payment-icon.mastercard {
                background: #dc2626;
                color: white;
            }

            .payment-icon.visa {
                background: #1e40af;
                color: white;
            }

            .security-note {
                padding: 12px;
                background: #dcfce7;
                border-radius: 6px;
                margin: 16px 0;
                border-left: 4px solid #059669;
            }

            .security-note p {
                font-size: 14px;
                color: #166534;
                margin: 0;
            }

            .expiry-row {
                display: flex;
                gap: 12px;
            }

            .expiry-row .form-select {
                width: 100px;
            }

            /* Complete Booking Button */
            .complete-booking-btn {
                width: 100%;
                background: linear-gradient(135deg, #2563eb, #1d4ed8);
                color: white;
                border: none;
                border-radius: 8px;
                padding: 16px 24px;
                font-size: 16px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.2s;
                margin: 20px 0;
                box-shadow: 0 4px 8px rgba(37, 99, 235, 0.3);
            }

            .complete-booking-btn:hover {
                background: linear-gradient(135deg, #1d4ed8, #1e40af);
                transform: translateY(-2px);
                box-shadow: 0 6px 12px rgba(37, 99, 235, 0.4);
            }

            .complete-booking-btn:disabled {
                background: #9ca3af;
                cursor: not-allowed;
                transform: none;
                box-shadow: none;
            }

            /* Loading Spinner */
            .loading-spinner {
                display: none;
                width: 20px;
                height: 20px;
                border: 2px solid #ffffff;
                border-top: 2px solid transparent;
                border-radius: 50%;
                animation: spin 1s linear infinite;
            }

            @keyframes spin {
                0% {
                    transform: rotate(0deg);
                }
                100% {
                    transform: rotate(360deg);
                }
            }

            /* Success Message */
            .success-message {
                display: none;
                background: #dcfce7;
                color: #166534;
                padding: 12px;
                border-radius: 8px;
                margin: 16px 0;
                border-left: 4px solid #059669;
            }

            /* Hidden inputs styling */
            .hidden-info {
                background: #f8f9fa;
                border: 1px solid #e5e7eb;
                border-radius: 6px;
                padding: 12px;
                margin-bottom: 16px;
                font-size: 12px;
                color: #6b7280;
            }

            /* Sidebar Styles */
            .sidebar {
                background: white;
                border-radius: 12px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                overflow: hidden;
            }

            .hotel-image {
                width: 100%;
                height: 200px;
                background: linear-gradient(135deg, #e5e7eb, #d1d5db);
                display: flex;
                align-items: center;
                justify-content: center;
                color: #6b7280;
                font-size: 14px;
                position: relative;
            }

            .hotel-info {
                padding: 20px;
            }

            .hotel-name {
                font-size: 18px;
                font-weight: 600;
                margin-bottom: 12px;
                color: #1a1a1a;
            }

            .hotel-rating {
                display: inline-flex;
                align-items: center;
                background: #dcfce7;
                color: #166534;
                padding: 6px 10px;
                border-radius: 6px;
                font-size: 12px;
                font-weight: 600;
                margin-bottom: 16px;
            }

            .hotel-details {
                font-size: 14px;
                color: #6b7280;
                line-height: 1.5;
                margin-bottom: 16px;
            }

            .hotel-details strong {
                color: #374151;
            }

            /* Price Summary */
            .price-summary {
                background: white;
                border-radius: 12px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                padding: 20px;
                margin-top: 20px;
            }

            .price-summary h3 {
                font-size: 18px;
                font-weight: 600;
                margin-bottom: 16px;
                color: #1a1a1a;
            }

            .price-row {
                display: flex;
                justify-content: space-between;
                margin-bottom: 8px;
                font-size: 14px;
            }

            .price-total {
                display: flex;
                justify-content: space-between;
                padding-top: 12px;
                border-top: 2px solid #e5e7eb;
                font-size: 16px;
                font-weight: 600;
                color: #1a1a1a;
                margin-bottom: 8px;
            }

            .price-payment {
                display: flex;
                justify-content: space-between;
                font-size: 14px;
                margin-bottom: 4px;
            }

            .price-payment.now {
                color: #059669;
                font-weight: 600;
            }

            /* Breadcrumb */
            .breadcrumb-section {
                background: #f1f5f9;
                padding: 15px 0;
                border-bottom: 1px solid #e2e8f0;
                margin-bottom: 30px;
            }

            .breadcrumb {
                margin-bottom: 0;
            }

            .page-title {
                font-size: 24px;
                font-weight: 600;
                margin-bottom: 5px;
            }
        </style>
    </head>
    <body>
        <!-- Include Header -->
        <jsp:include page="header.jsp" />

        <!-- Breadcrumb Section -->
        <div class="breadcrumb-section">
            <div class="container">
                <h1 class="page-title">Thanh toán</h1>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/Home">Trang chủ</a></li>
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/rooms.jsp">Phòng</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Thanh toán</li>
                    </ol>
                </nav>
            </div>
        </div>

        <div class="container">
            <!-- Welcome Card hoặc Login Prompt -->
            <% if (isLoggedIn) { %>
            <div class="welcome-card">
                <div class="user-info">
                    <div class="user-avatar">
                        <i class="fas fa-user"></i>
                    </div>
                    <div>
                        <h2>Chào mừng trở lại, <%= userFirstName %> <%= userLastName %>!</h2>
                        <p>Chúng tôi đã tự động điền thông tin của bạn để tiết kiệm thời gian.</p>
                    </div>
                </div>
            </div>
            <% } else { %>
            <div class="login-prompt">
                <i class="fas fa-info-circle"></i>
                <strong>Đăng nhập để có trải nghiệm tốt hơn:</strong>
                Tự động điền thông tin, lưu lịch sử đặt phòng và nhận điểm thưởng.
                <a href="${pageContext.request.contextPath}/login.jsp">Đăng nhập ngay</a>
            </div>
            <% } %>

            <div class="booking-layout">
                <!-- Main Content -->
                <div class="main-content">
                    <!-- Check-in/Check-out Date Section -->
                    <div class="card">
                        <div class="card-header">
                            <div class="card-title">
                                <i class="fas fa-calendar-alt"></i>
                                Thông tin lưu trú
                            </div>
                        </div>
                        <div class="card-content">
                            <div class="date-picker-section">
                                <div class="date-row">
                                    <div class="date-group">
                                        <label class="date-label">Ngày nhận phòng</label>
                                        <input type="date" class="date-input" id="checkInDate" name="checkInDate" value="<%= checkInDate %>" onchange="updateStayDuration()">
                                    </div>
                                    <div class="date-group">
                                        <label class="date-label">Ngày trả phòng</label>
                                        <input type="date" class="date-input" id="checkOutDate" name="checkOutDate" value="<%= checkOutDate %>" onchange="updateStayDuration()">
                                    </div>
                                </div>
                                <div id="stayDuration" style="text-align: center; margin-top: 12px; font-weight: 600; color: #059669;">
                                    1 đêm lưu trú
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Safe Booking Section -->
                    <div class="card">
                        <div class="card-header">
                            <div class="card-title">
                                <div class="safe-booking-icon">
                                    <i class="fas fa-check"></i>
                                </div>
                                Đặt an toàn
                            </div>
                        </div>
                        <div class="card-content">
                            <div class="info-box">
                                <i class="fas fa-calendar-alt"></i>
                                <div class="info-text">
                                    <h6>Hoàn tiền toàn bộ trước 14:00, T6, 20/06 (giờ địa phương nơi lưu trú)</h6>
                                    <p>Bạn có thể thay đổi hoặc hủy kỳ lưu trú này nếu kế hoạch thay đổi. Ví dụ: khi cần linh động</p>
                                </div>
                            </div>

                            <div class="info-box warning">
                                <i class="fas fa-gift"></i>
                                <div class="info-text">
                                    <p class="highlight">Đăng nhập hoặc tạo tài khoản để nhận 252 điểm Rewards sau chuyến đi này</p>
                                </div>
                                <i class="fas fa-chevron-right"></i>
                            </div>
                        </div>
                    </div>

                    <!-- Guest Information -->
                    <div class="card">
                        <div class="card-header">
                            <div class="card-title">Ai sẽ nhận phòng?</div>
                            <p style="font-size: 14px; color: #6b7280; margin: 0;">* Bắt buộc</p>
                        </div>
                        <div class="card-content">
                            <div class="room-info">
                                <h6>Phòng 1: 2 người lớn, 1 giường đôi, không hút thuốc</h6>
                                <div class="room-details">
                                    <span><strong>Room ID:</strong> <%= roomID %></span>
                                    <span><strong>Room Type:</strong> <%= roomTypeName %></span>
                                </div>
                                <div class="amenity">
                                    <i class="fas fa-wifi"></i>
                                    WiFi miễn phí
                                </div>
                            </div>

                            <% if (isLoggedIn) { %>
                            <div class="prefill-notice">
                                <i class="fas fa-magic"></i>
                                Thông tin đã được tự động điền từ tài khoản của bạn
                            </div>
                            <% } %>

                            <form method="post" action="booking" id="bookingForm" novalidate>
                                <!-- Hidden inputs for room and date info -->
                                <input type="hidden" name="roomID" value="<%= roomID %>">
                                <input type="hidden" name="roomTypeID" value="<%= roomTypeName %>">
                                <input type="hidden" name="checkInDate" value="<%= checkInDate %>">
                                <input type="hidden" name="checkOutDate" value="<%= checkOutDate %>">
                                <input type="hidden" name="isLoggedIn" value="<%= isLoggedIn %>">

                                <div class="hidden-info">
                                    <strong>Thông tin booking:</strong> Room ID: <%= roomID %>, Type: <%= roomTypeID %>, 
                                    Check-in: <%= checkInDate %>, Check-out: <%= checkOutDate %>
                                </div>

                                <div class="form-row">
                                    <div class="form-group">
                                        <label class="form-label" for="firstName">Họ: sử dụng chữ cái không dấu *</label>
                                        <input type="text" class="form-input <%= isLoggedIn && !userFirstName.isEmpty() ? "prefilled" : "" %>" 
                                               id="firstName" name="firstName" placeholder="(VD: Nguyen)" 
                                               value="<%= userFirstName %>" required>
                                        <div class="error-message" id="firstNameError"></div>
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label" for="lastName">Tên: sử dụng chữ cái không dấu *</label>
                                        <input type="text" class="form-input <%= isLoggedIn && !userLastName.isEmpty() ? "prefilled" : "" %>" 
                                               id="lastName" name="lastName" placeholder="(VD: Anh)" 
                                               value="<%= userLastName %>" required>
                                        <div class="error-message" id="lastNameError"></div>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="form-label" for="email">Địa chỉ email *</label>
                                    <input type="email" class="form-input <%= isLoggedIn && !userEmail.isEmpty() ? "prefilled" : "" %>" 
                                           id="email" name="email" placeholder="Email để xác nhận" 
                                           value="<%= userEmail %>" required>
                                    <div class="error-message" id="emailError"></div>
                                </div>

                                <div class="checkbox-group">
                                    <input type="checkbox" id="emailOptIn" name="emailOptIn">
                                    <label for="emailOptIn">
                                        Nhận email về ưu đãi, khuyến mãi và thông tin khác từ chúng tôi. Bạn có thể chọn ngừng nhận bất cứ lúc nào.
                                    </label>
                                </div>

                                <div class="form-row">
                                    <div class="form-group">
                                        <label class="form-label" for="country">Quốc gia/khu vực *</label>
                                        <select class="form-select" id="country" name="country" required>
                                            <option value="VNM" <%= "VNM".equals(userCountry) ? "selected" : "" %>>VNM +84</option>
                                            <option value="USA" <%= "USA".equals(userCountry) ? "selected" : "" %>>USA +1</option>
                                            <option value="UK" <%= "UK".equals(userCountry) ? "selected" : "" %>>UK +44</option>
                                            <option value="JP" <%= "JP".equals(userCountry) ? "selected" : "" %>>JP +81</option>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label" for="phone">Số điện thoại *</label>
                                        <input type="tel" class="form-input <%= isLoggedIn && !userPhone.isEmpty() ? "prefilled" : "" %>" 
                                               id="phone" name="phone" value="<%= userPhone %>" required>
                                        <div class="error-message" id="phoneError"></div>
                                    </div>
                                </div>

                                <div class="checkbox-group">
                                    <input type="checkbox" id="smsOptIn" name="smsOptIn" checked>
                                    <label for="smsOptIn">
                                        Nhận tin nhắn thông báo về chuyến đi (miễn phí).
                                    </label>
                                </div>
                        </div>
                    </div>

                    <!-- Payment Method -->
                    <div class="card">
                        <div class="card-header">
                            <div class="card-title">Phương thức thanh toán</div>
                            <div style="display: flex; align-items: center; gap: 8px; color: #059669; font-size: 14px; margin-top: 8px;">
                                <i class="fas fa-check"></i>
                                Thanh toán ngay: 0 ₫. Chỉ cần thông tin thanh toán của quý vị để đảm bảo cho đặt phòng
                            </div>
                        </div>
                        <div class="card-content">
                            <div class="payment-icons">
                                <div class="payment-icon card">
                                    <i class="fas fa-credit-card"></i>
                                </div>
                                <div class="payment-icon mastercard">MC</div>
                                <div class="payment-icon visa">VISA</div>
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="cardName">Tên chủ thẻ *</label>
                                <input type="text" class="form-input" id="cardName" name="cardName" required>
                                <div class="error-message" id="cardNameError"></div>
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="cardNumber">Số thẻ ghi nợ/tín dụng *</label>
                                <input type="text" class="form-input" id="cardNumber" name="cardNumber" placeholder="0000 0000 0000 0000" maxlength="19" required>
                                <div class="error-message" id="cardNumberError"></div>
                            </div>

                            <div class="security-note">
                                <p><i class="fas fa-shield-alt"></i> Chỉ để đảm bảo đặt chỗ - Thông tin được mã hóa an toàn</p>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Ngày hết hạn *</label>
                                <div class="expiry-row">
                                    <select class="form-select" name="expMonth" id="expMonth" required>
                                        <option value="">Tháng</option>
                                        <option value="01">01</option>
                                        <option value="02">02</option>
                                        <option value="03">03</option>
                                        <option value="04">04</option>
                                        <option value="05">05</option>
                                        <option value="06">06</option>
                                        <option value="07">07</option>
                                        <option value="08">08</option>
                                        <option value="09">09</option>
                                        <option value="10">10</option>
                                        <option value="11">11</option>
                                        <option value="12">12</option>
                                    </select>
                                    <select class="form-select" name="expYear" id="expYear" required>
                                        <option value="">Năm</option>
                                        <option value="2024">2024</option>
                                        <option value="2025">2025</option>
                                        <option value="2026">2026</option>
                                        <option value="2027">2027</option>
                                        <option value="2028">2028</option>
                                        <option value="2029">2029</option>
                                        <option value="2030">2030</option>
                                    </select>
                                </div>
                                <div class="error-message" id="expiryError"></div>
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="cvv">Mã bảo mật *</label>
                                <input type="text" class="form-input" id="cvv" name="cvv" maxlength="4" style="width: 120px;" required>
                                <div class="error-message" id="cvvError"></div>
                            </div>
                        </div>
                    </div>

                    <!-- Important Information -->
                    <div class="card">
                        <div class="card-header">
                            <div class="card-title">Thông tin quan trọng</div>
                        </div>
                        <div class="card-content">
                            <div class="success-message" id="successMessage">
                                <i class="fas fa-check-circle"></i> Thông tin đã được xác thực thành công!
                            </div>

                            <button type="submit" class="complete-booking-btn" id="submitBtn">
                                <span id="btnText">Hoàn tất đặt ›</span>
                                <div class="loading-spinner" id="loadingSpinner"></div>
                            </button>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- Sidebar -->
                <div class="sidebar-content">
                    <!-- Hotel Information -->
                    <div class="sidebar">
                        <div class="hotel-image">
                            <span>Hoang Nam Hotel</span>
                        </div>
                        <div class="hotel-info">
                            <h3 class="hotel-name">Hoang Nam Hotel</h3>

                            <div style="margin-bottom: 16px;">
                                <span class="hotel-rating">
                                    <i class="fas fa-star"></i> 8 Rất tốt
                                </span>
                                <span style="font-size: 14px; color: #6b7280; margin-left: 8px;">(417 nhận xét)</span>
                            </div>

                            <div class="hotel-details">
                                <p><strong>1 phòng:</strong><%= roomDetail %></p>
                                <p><strong>Room ID:</strong> <%= roomID %></p>
                                <p><strong>Room Type:</strong> <%= roomTypeName %></p>
                                <p><strong>Nhận phòng:</strong> <span id="displayCheckIn"><%= checkInDate %></span></p>
                                <p><strong>Trả phòng:</strong> <span id="displayCheckOut"><%= checkOutDate %></span></p>
                            </div>
                        </div>
                    </div>

                    <!-- Price Summary -->
                    <div class="price-summary">
                        <h3>Chi tiết giá</h3>
                        <div class="price-row">
                            <span>1 phòng, <span id="nightCount">1</span> đêm</span>
                            <span>6.300.002 ₫</span>
                        </div>
                        <div class="price-row">
                            <span>Thuế</span>
                            <span>630.030 ₫</span>
                        </div>
                        <div class="price-row">
                            <span>Thuế địa phương</span>
                            <span>489.923 ₫</span>
                        </div>
                        <div class="price-total">
                            <span>Tổng</span>
                            <span>7.419.955 ₫</span>
                        </div>
                        <div class="price-payment now">
                            <span>Thanh toán ngay</span>
                            <span>0 ₫</span>
                        </div>
                        <div class="price-payment">
                            <span>Thanh toán tại nơi lưu trú</span>
                            <span>7.419.955 ₫</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Include Footer -->
        <jsp:include page="footer.jsp" />

        <!-- Bootstrap JS and dependencies -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                            // Enhanced form validation and interactions
                                            document.addEventListener('DOMContentLoaded', function () {
                                                const form = document.getElementById('bookingForm');
                                                const submitBtn = document.getElementById('submitBtn');
                                                const btnText = document.getElementById('btnText');
                                                const loadingSpinner = document.getElementById('loadingSpinner');
                                                const successMessage = document.getElementById('successMessage');

                                                // Update stay duration when dates change
                                                updateStayDuration();

                                                // Validation functions
                                                function validateField(field, errorElement, validationFn, errorMessage) {
                                                    const isValid = validationFn(field.value);
                                                    if (!isValid) {
                                                        field.classList.add('error');
                                                        errorElement.textContent = errorMessage;
                                                        return false;
                                                    } else {
                                                        field.classList.remove('error');
                                                        errorElement.textContent = '';
                                                        return true;
                                                    }
                                                }

                                                function validateEmail(email) {
                                                    const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                                                    return re.test(email);
                                                }

                                                function validatePhone(phone) {
                                                    const re = /^[0-9+\-\s]{8,15}$/;
                                                    return re.test(phone);
                                                }

                                                function validateCardNumber(cardNumber) {
                                                    const cleaned = cardNumber.replace(/\s/g, '');
                                                    return cleaned.length >= 13 && cleaned.length <= 19 && /^\d+$/.test(cleaned);
                                                }

                                                function validateCVV(cvv) {
                                                    return /^\d{3,4}$/.test(cvv);
                                                }

                                                // Card number formatting
                                                const cardNumberInput = document.getElementById('cardNumber');
                                                cardNumberInput.addEventListener('input', function (e) {
                                                    let value = e.target.value.replace(/\s/g, '').replace(/[^0-9]/gi, '');
                                                    let formattedValue = value.match(/.{1,4}/g)?.join(' ') || value;
                                                    if (formattedValue.length > 19) {
                                                        formattedValue = formattedValue.substring(0, 19);
                                                    }
                                                    e.target.value = formattedValue;
                                                });

                                                // CVV validation
                                                const cvvInput = document.getElementById('cvv');
                                                cvvInput.addEventListener('input', function (e) {
                                                    e.target.value = e.target.value.replace(/[^0-9]/g, '');
                                                });

                                                // Phone validation
                                                const phoneInput = document.getElementById('phone');
                                                phoneInput.addEventListener('input', function (e) {
                                                    e.target.value = e.target.value.replace(/[^0-9+\-\s]/g, '');
                                                });

                                                // Form submission
                                                form.addEventListener('submit', function (e) {
                                                    e.preventDefault();

                                                    // Validate all fields
                                                    let isValid = true;
                                                    const fields = [
                                                        {field: document.getElementById('firstName'), error: document.getElementById('firstNameError'),
                                                            validator: (v) => v.trim().length >= 2, message: 'Họ phải có ít nhất 2 ký tự'},
                                                        {field: document.getElementById('lastName'), error: document.getElementById('lastNameError'),
                                                            validator: (v) => v.trim().length >= 2, message: 'Tên phải có ít nhất 2 ký tự'},
                                                        {field: document.getElementById('email'), error: document.getElementById('emailError'),
                                                            validator: validateEmail, message: 'Email không hợp lệ'},
                                                        {field: phoneInput, error: document.getElementById('phoneError'),
                                                            validator: validatePhone, message: 'Số điện thoại không hợp lệ'},
                                                        {field: document.getElementById('cardName'), error: document.getElementById('cardNameError'),
                                                            validator: (v) => v.trim().length >= 2, message: 'Tên chủ thẻ không hợp lệ'},
                                                        {field: cardNumberInput, error: document.getElementById('cardNumberError'),
                                                            validator: validateCardNumber, message: 'Số thẻ không hợp lệ'},
                                                        {field: cvvInput, error: document.getElementById('cvvError'),
                                                            validator: validateCVV, message: 'Mã CVV không hợp lệ'}
                                                    ];

                                                    fields.forEach(fieldObj => {
                                                        if (!validateField(fieldObj.field, fieldObj.error, fieldObj.validator, fieldObj.message)) {
                                                            isValid = false;
                                                        }
                                                    });

                                                    // Check expiry date
                                                    const expMonth = document.getElementById('expMonth').value;
                                                    const expYear = document.getElementById('expYear').value;
                                                    if (!expMonth || !expYear) {
                                                        document.getElementById('expiryError').textContent = 'Vui lòng chọn ngày hết hạn';
                                                        isValid = false;
                                                    } else {
                                                        document.getElementById('expiryError').textContent = '';
                                                    }

                                                    if (isValid) {
                                                        // Show loading state
                                                        submitBtn.disabled = true;
                                                        btnText.style.display = 'none';
                                                        loadingSpinner.style.display = 'inline-block';

                                                        // Simulate form submission
                                                        setTimeout(() => {
                                                            // Hide loading state
                                                            submitBtn.disabled = false;
                                                            btnText.style.display = 'inline';
                                                            loadingSpinner.style.display = 'none';

                                                            // Show success message
                                                            successMessage.style.display = 'block';

                                                            // Scroll to success message
                                                            successMessage.scrollIntoView({behavior: 'smooth'});

                                                            console.log('Form submitted successfully');
                                                            // form.submit(); // Uncomment for real submission
                                                        }, 2000);
                                                    }
                                                });
                                            });

                                            // Update stay duration and display dates
                                            function updateStayDuration() {
                                                const checkInDate = document.getElementById('checkInDate').value;
                                                const checkOutDate = document.getElementById('checkOutDate').value;

                                                if (checkInDate && checkOutDate) {
                                                    const checkIn = new Date(checkInDate);
                                                    const checkOut = new Date(checkOutDate);
                                                    const timeDiff = checkOut.getTime() - checkIn.getTime();
                                                    const dayDiff = Math.ceil(timeDiff / (1000 * 3600 * 24));

                                                    if (dayDiff > 0) {
                                                        document.getElementById('stayDuration').textContent = dayDiff + ' đêm lưu trú';
                                                        document.getElementById('nightCount').textContent = dayDiff;

                                                        // Update sidebar display
                                                        document.getElementById('displayCheckIn').textContent = formatDate(checkInDate);
                                                        document.getElementById('displayCheckOut').textContent = formatDate(checkOutDate);

                                                        // Update hidden inputs
                                                        document.querySelector('input[name="checkInDate"]').value = checkInDate;
                                                        document.querySelector('input[name="checkOutDate"]').value = checkOutDate;
                                                    }
                                                }
                                            }

                                            function formatDate(dateString) {
                                                const date = new Date(dateString);
                                                const days = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];
                                                const dayName = days[date.getDay()];
                                                const day = date.getDate().toString().padStart(2, '0');
                                                const month = (date.getMonth() + 1).toString().padStart(2, '0');
                                                return `${dayName}, ${day}/${month}`;
                                                    }

                                                    // Auto-save form data to localStorage
                                                    function saveFormData() {
                                                        const formData = new FormData(document.getElementById('bookingForm'));
                                                        const data = {};
                                                        for (let [key, value] of formData.entries()) {
                                                            data[key] = value;
                                                        }
                                                        localStorage.setItem('bookingFormData', JSON.stringify(data));
                                                    }

                                                    // Save data on input change
                                                    document.getElementById('bookingForm').addEventListener('input', saveFormData);
        </script>
    </body>
</html>
