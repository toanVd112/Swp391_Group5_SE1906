<%-- 
    Document   : booking-complete
    Created on : Jun 17, 2025, 8:59:46 AM
    Author     : Arcueid
    Updated    : Enhanced version with header and footer
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*" %>
<%@page import="DAO.BookingDAO" %>
<%@page import="model.Booking" %>
<%@page import="model.BookingDetail" %>
<%@page import="model.ServiceUsage" %>
<%@page import="java.util.List" %>
<%
    request.setCharacterEncoding("UTF-8");

    // 1️⃣ Check login
    Boolean isLoggedIn = (Boolean) session.getAttribute("isLoggedIn");
    if (isLoggedIn == null) isLoggedIn = false;

    // 2️⃣ Get user info từ session
    String userFirstName = (String) session.getAttribute("userFirstName");
    String userLastName  = (String) session.getAttribute("userLastName");
    String userEmail     = (String) session.getAttribute("userEmail");
    String userPhone     = (String) session.getAttribute("userPhone");
    String userCountry   = (String) session.getAttribute("userCountry");

    userFirstName = (userFirstName != null) ? userFirstName : "";
    userLastName  = (userLastName  != null) ? userLastName  : "";
    userEmail     = (userEmail     != null) ? userEmail     : "";
    userPhone     = (userPhone     != null) ? userPhone     : "";
    userCountry   = (userCountry   != null) ? userCountry   : "VNM";

    // 3️⃣ Get bookingID từ URL
     String bookingID = request.getParameter("bookingID");
  if (bookingID == null) {
    bookingID = String.valueOf(request.getAttribute("bookingID"));
  }
  System.out.println("DEBUG bookingID: " + bookingID);

    // 4️⃣ Truy vấn Booking từ DB
    BookingDAO bookingDAO = new BookingDAO();
    Booking booking = bookingDAO.getBookingByID(Integer.parseInt(bookingID));
    List<BookingDetail> bookingDetails = bookingDAO.getBookingDetails(Integer.parseInt(bookingID));
    List<ServiceUsage> serviceUsages = bookingDAO.getBookingServices(Integer.parseInt(bookingID));

    // 5️⃣ Bạn có thể để checkIn/checkOut như này (nếu cần):
    String checkInDate = booking.getCheckInDate();
    String checkOutDate = booking.getCheckOutDate();
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

        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">



        <link rel="stylesheet" type="text/css" href="assets/css/booking-form-styles.css">

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
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/roomlist">Phòng</a></li>
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

                    <!-- ✅ MỞ FORM TỪ ĐẦU -->
                    <form method="post" action="/PaymentGatewayServlet" id="bookingForm" novalidate>

                        <!-- ✅ Hidden BookingID -->
                        <input type="hidden" name="bookingID" value="<%= bookingID %>">

                        <!-- ✅ Hidden Check-in/out từ Booking -->
                        <input type="hidden" name="checkInDate" value="<%= booking.getCheckInDate() %>">
                        <input type="hidden" name="checkOutDate" value="<%= booking.getCheckOutDate() %>">

                        <!-- ✅ Hidden: loggedIn flag -->
                        <input type="hidden" name="isLoggedIn" value="<%= isLoggedIn %>">

                        <!-- ✅ THÔNG TIN KHÁCH -->
                        <div class="hidden-info">
                            <strong>Thông tin booking:</strong>
                            Booking ID: <%= bookingID %>,
                            Check-in: <%= booking.getCheckInDate() %>,
                            Check-out: <%= booking.getCheckOutDate() %>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label" for="firstName">Họ: *</label>
                                <input type="text"
                                       class="form-input <%= isLoggedIn && !userFirstName.isEmpty() ? "prefilled" : "" %>"
                                       id="firstName"
                                       name="firstName"
                                       placeholder="(VD: Nguyen)"
                                       value="<%= userFirstName %>"
                                       required>
                                <div class="error-message" id="firstNameError"></div>
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="lastName">Tên: *</label>
                                <input type="text"
                                       class="form-input <%= isLoggedIn && !userLastName.isEmpty() ? "prefilled" : "" %>"
                                       id="lastName"
                                       name="lastName"
                                       placeholder="(VD: Anh)"
                                       value="<%= userLastName %>"
                                       required>
                                <div class="error-message" id="lastNameError"></div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="email">Địa chỉ email *</label>
                            <input type="email"
                                   class="form-input <%= isLoggedIn && !userEmail.isEmpty() ? "prefilled" : "" %>"
                                   id="email"
                                   name="email"
                                   placeholder="Email để xác nhận"
                                   value="<%= userEmail %>"
                                   required>
                            <div class="error-message" id="emailError"></div>
                        </div>

                        <div class="checkbox-group">
                            <input type="checkbox" id="emailOptIn" name="emailOptIn">
                            <label for="emailOptIn">
                                Nhận email về ưu đãi, khuyến mãi và thông tin khác từ chúng tôi.
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
                                <input type="tel"
                                       class="form-input <%= isLoggedIn && !userPhone.isEmpty() ? "prefilled" : "" %>"
                                       id="phone"
                                       name="phone"
                                       value="<%= userPhone %>"
                                       required>
                                <div class="error-message" id="phoneError"></div>
                            </div>
                        </div>

                        <div class="checkbox-group">
                            <input type="checkbox" id="smsOptIn" name="smsOptIn" checked>
                            <label for="smsOptIn">
                                Nhận tin nhắn thông báo về chuyến đi (miễn phí).
                            </label>
                        </div>

                        <!-- ✅ BLOCK PAYMENT METHOD -->
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
                                            ...
                                            <option value="12">12</option>
                                        </select>
                                        <select class="form-select" name="expYear" id="expYear" required>
                                            <option value="">Năm</option>
                                            <option value="2024">2024</option>
                                            <option value="2025">2025</option>
                                            ...
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

                        <!-- ✅ NÚT SUBMIT TRONG FORM -->
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
                            </div>
                        </div>

                    </form>


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
                                    <% for (BookingDetail bd : bookingDetails) { %>
                                    <p><strong>Room Type:</strong> <%= bd.getRoomTypeName() %></p>
                                    <p><strong>Quantity:</strong> <%= bd.getQuantity() %></p>
                                    <% } %>
                                    <p><strong>Nhận phòng:</strong> <span id="displayCheckIn"><%= checkInDate %></span></p>
                                    <p><strong>Trả phòng:</strong> <span id="displayCheckOut"><%= checkOutDate %></span></p>
                                </div>
                            </div>
                        </div>
                    </div>


                    <!-- Price Summary -->
                    <div class="price-summary">
                        <h3>Chi tiết giá</h3>
                        <div class="price-row">
                            <span>1 phòng, <span id="nightCount">1</span> đêm</span>
                            <span>6.300.002 ₫</span> <!-- sẽ bị ghi đè -->
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

    </body>
</html>