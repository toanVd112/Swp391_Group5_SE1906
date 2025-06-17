<%-- 
    Document   : booking
    Created on : Jun 17, 2025, 8:59:46 AM
    Author     : Arcueid
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán</title>
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
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        /* Header Styles */
        .header {
            background: white;
            border-bottom: 1px solid #e0e0e0;
            padding: 15px 0;
            margin-bottom: 20px;
        }

        .header-content {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .back-btn {
            background: none;
            border: none;
            font-size: 18px;
            color: #666;
            cursor: pointer;
            padding: 8px;
        }

        .header h1 {
            font-size: 24px;
            font-weight: 600;
            color: #1a1a1a;
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
        }

        .card-header {
            padding: 20px 24px;
            border-bottom: 1px solid #f0f0f0;
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
        }

        .info-box.warning {
            background: linear-gradient(to right, #fef3c7, #fed7aa);
            border: 1px solid #fbbf24;
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
            border: 1px solid #d1d5db;
            border-radius: 6px;
            font-size: 14px;
            transition: border-color 0.2s;
        }

        .form-input:focus, .form-select:focus {
            outline: none;
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        .checkbox-group {
            display: flex;
            align-items: flex-start;
            gap: 8px;
            margin-bottom: 16px;
        }

        .checkbox-group input[type="checkbox"] {
            margin-top: 2px;
        }

        .checkbox-group label {
            font-size: 14px;
            line-height: 1.4;
        }

        /* Room Info */
        .room-info {
            margin-bottom: 16px;
        }

        .room-info h6 {
            font-weight: 600;
            margin-bottom: 8px;
        }

        .amenity {
            display: flex;
            align-items: center;
            gap: 6px;
            color: #059669;
            font-size: 14px;
        }

        /* Payment Method */
        .payment-icons {
            display: flex;
            gap: 8px;
            margin-bottom: 16px;
        }

        .payment-icon {
            width: 32px;
            height: 24px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
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
            width: 80px;
        }

        /* Policy Section */
        .policy-item {
            display: flex;
            align-items: flex-start;
            gap: 8px;
            margin-bottom: 12px;
        }

        .policy-dot {
            width: 8px;
            height: 8px;
            background: #059669;
            border-radius: 50%;
            margin-top: 6px;
            flex-shrink: 0;
        }

        .policy-text {
            font-size: 14px;
            line-height: 1.5;
        }

        /* Important Info */
        .info-list {
            list-style: none;
            padding: 0;
        }

        .info-list li {
            margin-bottom: 12px;
            font-size: 14px;
            line-height: 1.5;
            padding-left: 16px;
            position: relative;
        }

        .info-list li::before {
            content: "•";
            position: absolute;
            left: 0;
            color: #6b7280;
        }

        .checkin-info {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            padding: 16px;
            background: #f9fafb;
            border-radius: 8px;
            margin: 16px 0;
        }

        .checkin-item {
            text-align: center;
        }

        .checkin-label {
            font-weight: 600;
            color: #374151;
            margin-bottom: 4px;
        }

        .checkin-time {
            font-size: 14px;
            color: #6b7280;
        }

        /* Legal Text */
        .legal-text {
            font-size: 12px;
            color: #6b7280;
            line-height: 1.4;
            margin: 16px 0;
        }

        .legal-text a {
            color: #2563eb;
            text-decoration: none;
        }

        .legal-text a:hover {
            text-decoration: underline;
        }

        /* Complete Booking Button */
        .complete-booking-btn {
            width: 100%;
            background: #2563eb;
            color: white;
            border: none;
            border-radius: 8px;
            padding: 16px 24px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.2s;
            margin: 20px 0;
        }

        .complete-booking-btn:hover {
            background: #1d4ed8;
        }

        /* Security Notice */
        .security-notice {
            display: flex;
            align-items: center;
            padding: 12px;
            background: #f0fdf4;
            border-radius: 8px;
            margin: 16px 0;
            font-size: 12px;
            color: #166534;
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
            background: #e5e7eb;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #6b7280;
            font-size: 14px;
            position: relative;
        }

        .image-nav {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            background: rgba(255, 255, 255, 0.8);
            border: none;
            border-radius: 50%;
            width: 32px;
            height: 32px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .image-nav.prev {
            left: 12px;
        }

        .image-nav.next {
            right: 12px;
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
            padding: 4px 8px;
            border-radius: 4px;
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

        .special-request-btn {
            width: 100%;
            padding: 12px;
            border: 1px solid #d1d5db;
            background: white;
            border-radius: 6px;
            cursor: pointer;
            margin-bottom: 16px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .availability-notice {
            display: flex;
            align-items: flex-start;
            gap: 8px;
            padding: 12px;
            background: #dcfce7;
            border-radius: 8px;
            margin-top: 16px;
        }

        .availability-notice i {
            color: #059669;
            margin-top: 2px;
        }

        .availability-notice p {
            font-size: 14px;
            color: #166534;
            margin: 0;
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
            border-top: 1px solid #e5e7eb;
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

        .price-note {
            font-size: 12px;
            color: #6b7280;
            line-height: 1.4;
            margin-top: 16px;
        }

        .price-note strong {
            color: #374151;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .container {
                padding: 10px;
            }
            
            .checkin-info {
                grid-template-columns: 1fr;
                gap: 12px;
            }
            
            .card-content {
                padding: 16px 20px 20px;
            }
            
            .card-header {
                padding: 16px 20px;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <div class="header">
        <div class="header-content">
            <button class="back-btn">
                <i class="fas fa-chevron-left"></i>
            </button>
            <h1>Expedia: Thanh toán</h1>
        </div>
    </div>

    <div class="container">
        <div class="booking-layout">
            <!-- Main Content -->
            <div class="main-content">
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
                                <p class="highlight">Đăng nhập hoặc tạo tài khoản để nhận 252 điểm Expedia Rewards sau chuyến đi này</p>
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
                            <div class="amenity">
                                <i class="fas fa-wifi"></i>
                                WiFi miễn phí
                            </div>
                        </div>

                        <form method="post" action="booking">
                            <div class="form-row">
                                <div class="form-group">
                                    <label class="form-label" for="firstName">Họ: sử dụng chữ cái không dấu *</label>
                                    <input type="text" class="form-input" id="firstName" name="firstName" placeholder="(VD: Nguyen)" required>
                                </div>
                                <div class="form-group">
                                    <label class="form-label" for="lastName">Tên: sử dụng chữ cái không dấu *</label>
                                    <input type="text" class="form-input" id="lastName" name="lastName" placeholder="(VD: Anh)" required>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="email">Địa chỉ email *</label>
                                <input type="email" class="form-input" id="email" name="email" placeholder="Email để xác nhận" required>
                            </div>

                            <div class="checkbox-group">
                                <input type="checkbox" id="emailOptIn" name="emailOptIn">
                                <label for="emailOptIn">
                                    Nhận email về ưu đãi, khuyến mãi và thông tin khác từ Expedia. Bạn có thể chọn ngừng nhận bất cứ lúc nào.
                                </label>
                            </div>

                            <div class="form-row">
                                <div class="form-group">
                                    <label class="form-label" for="country">Quốc gia/khu vực *</label>
                                    <select class="form-select" id="country" name="country" required>
                                        <option value="VNM">VNM +84</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label class="form-label" for="phone">Số điện thoại *</label>
                                    <input type="tel" class="form-input" id="phone" name="phone" required>
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
                            <input type="text" class="form-input" id="cardName" name="cardName">
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="cardNumber">Số thẻ ghi nợ/tín dụng *</label>
                            <input type="text" class="form-input" id="cardNumber" name="cardNumber" placeholder="0000 0000 0000 0000">
                        </div>

                        <div class="security-note">
                            <p>Chỉ để đảm bảo đặt chỗ</p>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Ngày hết hạn *</label>
                            <div class="expiry-row">
                                <select class="form-select" name="expMonth">
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
                                <select class="form-select" name="expYear">
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
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="cvv">Mã bảo mật *</label>
                            <input type="text" class="form-input" id="cvv" name="cvv" maxlength="4" style="width: 100px;">
                        </div>
                    </div>
                </div>

                <!-- Cancellation Policy -->
                <div class="card">
                    <div class="card-header">
                        <div class="card-title">Chính sách hủy</div>
                    </div>
                    <div class="card-content">
                        <div class="policy-item">
                            <div class="policy-dot"></div>
                            <div class="policy-text">Hoàn tiền toàn bộ trước T6, 20/06</div>
                        </div>
                        <div class="policy-item">
                            <div class="policy-dot"></div>
                            <div class="policy-text">
                                Thay đổi hoặc hủy thực hiện sau 14:00 (giờ địa phương nơi lưu trú) ngày 20/06/2025 hoặc khách không nhận phòng sẽ chịu phí nơi lưu trú tương đương 100% tổng giá đã thanh toán cho đặt phòng.
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Important Information -->
                <div class="card">
                    <div class="card-header">
                        <div class="card-title">Thông tin quan trọng</div>
                    </div>
                    <div class="card-content">
                        <ul class="info-list">
                            <li>Nhân viên tiếp tân sẽ đón tiếp khi khách đến nơi lưu trú.</li>
                            <li>Khi nhận phòng, chủ thẻ phải xuất trình thẻ tín dụng đã dùng để đặt phòng cùng với giấy tờ tùy thân có ảnh trùng khớp, đồng thời khách phải thông báo cho nơi lưu trú trước khi đến nếu có yêu cầu gì khác.</li>
                            <li>Bạn sẽ được yêu cầu thanh toán cho nơi lưu trú các khoản phí sau. Phí có thể bao gồm các loại thuế hiện hành:</li>
                        </ul>
                        
                        <p style="font-size: 14px; margin-left: 16px; color: #6b7280;">
                            Thuế do thành phố quy định: 8.13 EUR mỗi người, mỗi đêm. Không áp dụng thuế này với trẻ em dưới 18 tuổi
                        </p>
                        
                        <p style="font-size: 14px; margin: 16px 0;">
                            Chúng tôi đã liệt kê mọi khoản phí được nơi lưu trú cung cấp thông tin.
                        </p>

                        <div class="checkin-info">
                            <div class="checkin-item">
                                <div class="checkin-label">Nhận phòng:</div>
                                <div class="checkin-time">15:00, T7, 21/06</div>
                            </div>
                            <div class="checkin-item">
                                <div class="checkin-label">Trả phòng:</div>
                                <div class="checkin-time">11:00, CN, 22/06 (1 đêm lưu trú)</div>
                            </div>
                        </div>

                        <div class="legal-text">
                            Bằng việc bấm vào nút dưới đây, tôi xác nhận đã kiểm tra 
                            <a href="#">Tuyên bố bảo mật</a> và 
                            <a href="#">Hướng dẫn du lịch của chính phủ</a> và đã đọc và chấp nhận 
                            <a href="#">Quy tắc & Giới hạn</a> và 
                            <a href="#">Điều khoản sử dụng</a>.
                        </div>

                        <button type="submit" class="complete-booking-btn">Hoàn tất đặt ›</button>

                        <div class="security-notice">
                            🔒 Chúng tôi sử dụng phương thức truyền tải và lưu trữ dữ liệu mã hóa để bảo vệ thông tin cá nhân của quý vị.
                        </div>

                        <div style="font-size: 12px; color: #6b7280; line-height: 1.4; margin-top: 16px;">
                            Khoản thanh toán được xử lý ở Tây Ban Nha, từ trường hợp nhà cung cấp dịch vụ du lịch (khách sạn, hãng hàng không, v.v.) xử lý khoản thanh toán của bạn bên ngoài Tây Ban Nha. Trong trường hợp đó, đơn vị phát hành thẻ của bạn có thể sẽ thu một khoản phí giao dịch ngoại tệ.
                        </div>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Sidebar -->
            <div class="sidebar-content">
                <!-- Hotel Information -->
                <div class="sidebar">
                    <div class="hotel-image">
                        <button class="image-nav prev">
                            <i class="fas fa-chevron-left"></i>
                        </button>
                        Hotel Boris V. by Happyculture
                        <button class="image-nav next">
                            <i class="fas fa-chevron-right"></i>
                        </button>
                    </div>
                    <div class="hotel-info">
                        <h3 class="hotel-name">Hotel Boris V. by Happyculture</h3>

                        <div style="margin-bottom: 16px;">
                            <span class="hotel-rating">8 Rất tốt</span>
                            <span style="font-size: 14px; color: #6b7280; margin-left: 8px;">(417 nhận xét)</span>
                        </div>

                        <div class="hotel-details">
                            <p><strong>1 phòng:</strong> Phòng cách cổ điển</p>
                            <p><strong>Nhận phòng:</strong> T7, 21/06</p>
                            <p><strong>Trả phòng:</strong> CN, 22/06</p>
                            <p>1 đêm lưu trú</p>
                        </div>

                        <button class="special-request-btn">
                            <span>Yêu cầu đặc biệt (tùy chọn)</span>
                            <i class="fas fa-chevron-right"></i>
                        </button>

                        <div class="availability-notice">
                            <i class="fas fa-check"></i>
                            <p>Lựa chọn tuyệt vời! Hãy nhanh tay đặt ngay trước khi hết phòng trống!</p>
                        </div>
                    </div>
                </div>

                <!-- Price Summary -->
                <div class="price-summary">
                    <h3>Chi tiết giá</h3>
                    <div class="price-row">
                        <span>1 phòng, 1 đêm</span>
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

                    <div class="price-note">
                        Giá được báo bằng <strong>Việt Nam đồng</strong>, dựa trên tỉ giá ngoại tệ hiện hành và có thể thay đổi vào thời điểm thực hiện chuyến đi. Nơi lưu trú sẽ thu toán bộ khoản tiền 7.419.955 ₫ bằng Euro (246,26 €). Đơn vị phát hành thẻ của bạn có thể thu phí giao dịch ngoại tệ.
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Form validation and interactions
        document.addEventListener('DOMContentLoaded', function() {
            // Card number formatting
            const cardNumberInput = document.getElementById('cardNumber');
            if (cardNumberInput) {
                cardNumberInput.addEventListener('input', function(e) {
                    let value = e.target.value.replace(/\s/g, '').replace(/[^0-9]/gi, '');
                    let formattedValue = value.match(/.{1,4}/g)?.join(' ') || value;
                    if (formattedValue.length > 19) {
                        formattedValue = formattedValue.substring(0, 19);
                    }
                    e.target.value = formattedValue;
                });
            }

            // CVV validation
            const cvvInput = document.getElementById('cvv');
            if (cvvInput) {
                cvvInput.addEventListener('input', function(e) {
                    e.target.value = e.target.value.replace(/[^0-9]/g, '');
                });
            }

            // Phone validation
            const phoneInput = document.getElementById('phone');
            if (phoneInput) {
                phoneInput.addEventListener('input', function(e) {
                    e.target.value = e.target.value.replace(/[^0-9+\-\s]/g, '');
                });
            }
        });
    </script>
</body>
</html>