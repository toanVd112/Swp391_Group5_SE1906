

<%@ page contentType="text/html; charset=UTF-8" language="java" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<fmt:formatNumber value="${totalPrice}" type="number" maxFractionDigits="0"/>

<c:set var="isCustomer" value="${not empty sessionScope.user}" />

<!DOCTYPE html>
<html lang="en">


    <head>

        <!-- META ============================================= -->
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="keywords" content="" />
        <meta name="author" content="" />
        <meta name="robots" content="" />

        <!-- DESCRIPTION -->
        <meta name="description" content="Kh?ch s?n Ho?ng Nam - Chu?i kh?ch s?n l?n nh?t mi?n b?c" />

        <!-- OG -->
        <meta property="og:title" content="Kh?ch s?n HoĐ?ng Nam - Chu?i kh?ch s?n l?n nh?t mi?n b?c" />
        <meta property="og:description" content="Kh?ch s?n Ho?ng Nam - Chu?i kh?ch s?n l?n nh?t mi?n b?c" />
        <meta property="og:image" content="" />
        <meta name="format-detection" content="telephone=no">

        <!-- FAVICON1S ICON ============================================= -->
        <link rel="icon" href="assets/images/favicon1.ico" type="image/x-icon" />
        <link rel="shortcut icon" type="image/x-icon" href="assets/images/favicon1.png" />

        <!-- PAGE TITLE HERE ============================================= -->
        <title>Hoang Nam Hotel</title>

        <!-- MOBILE SPECIFIC ============================================= -->
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!--[if lt IE 9]>
        <script src="assets/js/html5shiv.min.js"></script>
        <script src="assets/js/respond.min.js"></script>
        <![endif]-->

        <!-- All PLUGINS CSS ============================================= -->
        <link rel="stylesheet" type="text/css" href="assets/css/assets.css">

        <!-- TYPOGRAPHY ============================================= -->
        <link rel="stylesheet" type="text/css" href="assets/css/typography.css">

        <!-- SHORTCODES ============================================= -->
        <link rel="stylesheet" type="text/css" href="assets/css/shortcodes/shortcodes.css">

        <!-- STYLESHEETS ============================================= -->
        <link rel="stylesheet" type="text/css" href="assets/css/style.css">
        <link class="skin" rel="stylesheet" type="text/css" href="assets/css/color/color-1.css">

        <!-- REVOLUTION SLIDER CSS ============================================= -->
        <link rel="stylesheet" type="text/css" href="assets/vendors/revolution/css/layers.css">
        <link rel="stylesheet" type="text/css" href="assets/vendors/revolution/css/settings.css">
        <link rel="stylesheet" type="text/css" href="assets/vendors/revolution/css/navigation.css">


        <!-- REVOLUTION SLIDER END -->	
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <link rel="stylesheet" href="assets/css/listRoom.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">

    </head>

    <body id="bg">
        <div class="page-wraper">
            <div id="loading-icon-bx"></div>
            <!-- Header Top ==== -->
            <header class="header rs-nav">
                <div class="top-bar">
                    <div class="container">
                        <div class="row d-flex justify-content-between">
                            <div class="topbar-left">
                                <ul>
                                    <li><a href="faq-1.jsp"><i class="fa fa-question-circle"></i>Ask a Question</a></li>
                                    <li><a href="javascript:;"><i class="fa fa-envelope-o"></i>Support@website.com</a></li>
                                </ul>
                            </div>
                            <div class="topbar-right">
                                <ul>
                                    <li>
                                        <select class="header-lang-bx">
                                            <option data-icon="flag flag-uk">English UK</option>
                                            <option data-icon="flag flag-us">English US</option>
                                        </select>
                                    </li>

                                    <c:if test="${sessionScope.user != null}">
                                        <li class="nav-item">
                                            <a class="nav-link" href="user_profile2.html">Hello, ${sessionScope.user.username}</a>
                                        </li>
                                        <li class="nav-item">
                                            <a class="nav-link" href="Logout">Logout</a>

                                        </li>
                                    </c:if>
                                    <c:if test="${sessionScope.user == null}">
                                        <li class="nav-item">
                                            <a class="nav-link" href="login.jsp">Login</a>
                                        </li>
                                        <li class="nav-item">
                                            <a class="nav-link" href="register.jsp">Register</a>
                                        </li>
                                    </c:if>

                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="sticky-header navbar-expand-lg">
                    <div class="menu-bar clearfix">
                        <div class="container clearfix">
                            <!-- Header Logo ==== -->
                            <div class="menu-logo">
                                <a href="Home"><img src="assets/images/logo.png" alt=""></a>
                            </div>
                            <!-- Mobile Nav Button ==== -->
                            <button class="navbar-toggler collapsed menuicon justify-content-end" type="button" data-toggle="collapse" data-target="#menuDropdown" aria-controls="menuDropdown" aria-expanded="false" aria-label="Toggle navigation">
                                <span></span>
                                <span></span>
                                <span></span>
                            </button>
                            <!-- Author Nav ==== -->
                            <div class="secondary-menu">
                                <div class="secondary-inner">
                                    <ul>
                                        <li><a href="javascript:;" class="btn-link"><i class="fa fa-facebook"></i></a></li>
                                        <li><a href="javascript:;" class="btn-link"><i class="fa fa-google-plus"></i></a></li>
                                        <li><a href="javascript:;" class="btn-link"><i class="fa fa-linkedin"></i></a></li>
                                        <!-- Search Button ==== -->
                                        <li class="search-btn"><button id="quik-search-btn" type="button" class="btn-link"><i class="fa fa-search"></i></button></li>
                                    </ul>
                                </div>
                            </div>
                            <!-- Search Box ==== -->
                            <div class="nav-search-bar">
                                <form action="#">
                                    <input name="search" value="" type="text" class="form-control" placeholder="Type to search">
                                    <span><i class="ti-search"></i></span>
                                </form>
                                <span id="search-remove"><i class="ti-close"></i></span>
                            </div>
                            <!-- Navigation Menu ==== -->
                            <div class="menu-links navbar-collapse collapse justify-content-start" id="menuDropdown">
                                <div class="menu-logo">
                                    <a href="Home"><img src="assets/images/logo.png" alt=""></a>
                                </div>
                                <ul class="nav navbar-nav">	
                                    <li class="active"><a href="javascript:;">Home <i class="fa fa-chevron-down"></i></a>
                                        <ul class="sub-menu">
                                            <li><a href="Home">Home 1</a></li>
                                            <li><a href="Home">Home 2</a></li>
                                        </ul>
                                    </li>
                                    <li><a href="javascript:;">Pages <i class="fa fa-chevron-down"></i></a>
                                        <ul class="sub-menu">
                                            <li><a href="javascript:;">About<i class="fa fa-angle-right"></i></a>
                                                <ul class="sub-menu">
                                                    <li><a href="about-1.html">About 1</a></li>
                                                    <li><a href="about-2.html">About 2</a></li>
                                                </ul>
                                            </li>
                                            <li><a href="javascript:;">Event<i class="fa fa-angle-right"></i></a>
                                                <ul class="sub-menu">
                                                    <li><a href="event.html">Event</a></li>
                                                    <li><a href="events-details.html">Events Details</a></li>
                                                </ul>
                                            </li>
                                            <li><a href="javascript:;">FAQ's<i class="fa fa-angle-right"></i></a>
                                                <ul class="sub-menu">
                                                    <li><a href="faq-1.jsp">FAQ's 1</a></li>
                                                    <li><a href="faq-2.html">FAQ's 2</a></li>
                                                </ul>
                                            </li>
                                            <li><a href="javascript:;">Contact Us<i class="fa fa-angle-right"></i></a>
                                                <ul class="sub-menu">
                                                    <li><a href="contact-1.jsp">Contact Us 1</a></li>
                                                    <li><a href="contact-2.html">Contact Us 2</a></li>
                                                </ul>
                                            </li>
                                            <li><a href="portfolio.html">Portfolio</a></li>
                                            <li><a href="profile.html">Profile</a></li>
                                            <li><a href="membership.html">Membership</a></li>
                                            <li><a href="error-404.html">404 Page</a></li>
                                        </ul>
                                    </li>
                                    <li class="add-mega-menu"><a href="javascript:;">Our Hotel <i class="fa fa-chevron-down"></i></a>
                                        <ul class="sub-menu add-menu">
                                            <li class="add-menu-left">
                                                <h5 class="menu-adv-title">Our Hotel</h5>
                                                <ul>
                                                    <li><a href="roomlist">Rooms </a></li>
                                                    <li><a href="rooms-details.jsp">Rooms Details</a></li>
                                                    <li><a href="profile.html">Instructor Profile</a></li>
                                                    <li><a href="event.html">Upcoming Event</a></li>
                                                    <li><a href="membership.html">Membership</a></li>
                                                </ul>
                                            </li>
                                            <li class="add-menu-right">
                                                <img src="assets/images/adv/adv.jpg" alt=""/>
                                            </li>
                                        </ul>
                                    </li>
                                    <li><a href="javascript:;">Blog <i class="fa fa-chevron-down"></i></a>
                                        <ul class="sub-menu">
                                            <li><a href="blog-classic-grid.html">Blog Classic</a></li>
                                            <li><a href="blog-classic-sidebar.html">Blog Classic Sidebar</a></li>
                                            <li><a href="blog-list-sidebar.html">Blog List Sidebar</a></li>
                                            <li><a href="blog-standard-sidebar.html">Blog Standard Sidebar</a></li>
                                            <li><a href="blog-details.html">Blog Details</a></li>
                                        </ul>
                                    </li>
                                    <li class="nav-dashboard"><a href="javascript:;">Dashboard <i class="fa fa-chevron-down"></i></a>
                                        <ul class="sub-menu">
                                            <li><a href="admin/Home">Dashboard</a></li>
                                            <li><a href="admin/add-listing.html">Add Listing</a></li>
                                            <li><a href="admin/bookmark.html">Bookmark</a></li>
                                            <li><a href="admin/roomlist">Rooms</a></li>
                                            <li><a href="admin/review.html">Review</a></li>
                                            <li><a href="admin/user-profile.jsp">User Profile</a></li>
                                            <li><a href="javascript:;">Calendar<i class="fa fa-angle-right"></i></a>
                                                <ul class="sub-menu">
                                                    <li><a href="admin/basic-calendar.html">Basic Calendar</a></li>
                                                    <li><a href="admin/list-view-calendar.html">List View Calendar</a></li>
                                                </ul>
                                            </li>
                                            <li><a href="javascript:;">Mailbox<i class="fa fa-angle-right"></i></a>
                                                <ul class="sub-menu">
                                                    <li><a href="admin/mailbox.html">Mailbox</a></li>
                                                    <li><a href="admin/mailbox-compose.html">Compose</a></li>
                                                    <li><a href="admin/mailbox-read.html">Mail Read</a></li>
                                                </ul>
                                            </li>
                                        </ul>
                                    </li>
                                    <c:choose>
                                        <%-- Nếu người dùng đã đăng nhập --%>
                                        <c:when test="${not empty sessionScope.user}">
                                            <li><a href="customerCart"><i class="fa fa-bed"></i> My Rooms</a></li>
                                            </c:when>

                                        <%-- Nếu chưa đăng nhập --%>
                                        <c:otherwise>
                                            <li><a href="myrooms_db.jsp"><i class="fa fa-bed"></i> My Rooms</a></li>
                                            </c:otherwise>
                                        </c:choose>

                                </ul>
                                <div class="nav-social-link">
                                    <a href="javascript:;"><i class="fa fa-facebook"></i></a>
                                    <a href="javascript:;"><i class="fa fa-google-plus"></i></a>
                                    <a href="javascript:;"><i class="fa fa-linkedin"></i></a>
                                </div>
                            </div>
                            <!-- Navigation Menu END ==== -->
                        </div>
                    </div>
                </div>
            </header>
            <div class="search-section">
                <div class="search-form-container">
                    <form method="get" action="FindAvailableRoomsServlet" class="modern-search-form" onsubmit="return validateForm()">
                        <div class="search-row">
                            <div class="search-field">
                                <label><i class="fas fa-calendar-check"></i> Ngày nhận phòng</label>
                                <input type="text" id="checkin" name="checkin" placeholder="Chọn ngày" value="${param.checkin}" required>
                            </div>
                            <div class="search-field">
                                <label><i class="fas fa-calendar-times"></i> Ngày trả phòng</label>
                                <input type="text" id="checkout" name="checkout" placeholder="Chọn ngày" value="${param.checkout}" required>
                            </div>
                            <div class="search-field">
                                <label><i class="fas fa-users"></i> Số khách</label>
                                <input type="number" id="guests" name="guests" min="1" value="${param.guests}" required>
                            </div>
                            <div class="search-field">
                                <button type="submit" class="search-btn">
                                    <i class="fas fa-search"></i>
                                    Tìm phòng
                                </button>
                            </div>
                        </div>
                    </form>
                </div>

                <div class="search-results-header">
                    <h1 class="results-title">Kết quả tìm phòng cho ${guests} người</h1>
                    <p class="results-subtitle">Tìm thấy các tổ hợp phòng phù hợp và phòng trống cho kỳ nghỉ của bạn</p>
                </div>
            </div>

            <!-- Main Content -->
            <div class="main-wrapper">
                <div class="container-fluid">
                    <div class="room-search-layout">
                        <!-- Left Content -->
                        <div class="room-content-area">
                            <!-- Search Header -->

                            <!-- Tab Navigation -->
                            <div class="tab-navigation" id="tabNavigation">
                                <div class="tab-nav-container">
                                    <div class="tab-buttons">
                                        <button class="tab-btn active" onclick="switchTab('suggestions')" id="suggestionsTab">
                                            <i class="fas fa-magic"></i>
                                            <span>Gợi ý tổ hợp</span>
                                        </button>
                                        <button class="tab-btn" onclick="switchTab('manual')" id="manualTab">
                                            <i class="fas fa-list"></i>
                                            <span>Tự chọn phòng</span>
                                        </button>
                                        <button class="tab-btn" onclick="switchTab('services')" id="servicesTab">
                                            <i class="fas fa-concierge-bell"></i>
                                            <span>Dịch vụ</span>
                                        </button>
                                    </div>
                                    <button class="filter-toggle-btn" onclick="toggleFilters()">
                                        <i class="fas fa-filter"></i>
                                        <span>Bộ lọc</span>
                                    </button>
                                </div>
                            </div>

                            <!-- Filter Panel -->
                            <div class="filter-panel" id="filterPanel">
                                <div class="filter-content">
                                    <h3><i class="fas fa-filter"></i> Bộ lọc nâng cao</h3>
                                    <form method="get" action="FindAvailableRoomsServlet">
                                        <div class="filter-row">
                                            <input type="hidden" name="checkin" value="${param.checkin}">
                                            <input type="hidden" name="checkout" value="${param.checkout}">
                                            <input type="hidden" name="guests" value="${param.guests}">

                                            <div class="filter-field">
                                                <label>Loại phòng</label>
                                                <select name="roomType">
                                                    <option value="">Tất cả loại phòng</option>
                                                    <c:forEach var="type" items="${roomTypes}">
                                                        <option value="${type.name}" <c:if test="${param.roomType == type.name}">selected</c:if>>${type.name}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <div class="filter-field">
                                                <label>Giá tối đa (VND)</label>
                                                <input type="number" name="maxPrice" placeholder="Nhập giá tối đa" value="${param.maxPrice}">
                                            </div>
                                            <div class="filter-field">
                                                <button type="submit" class="filter-btn">
                                                    <i class="fas fa-search"></i>
                                                    Áp dụng
                                                </button>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                            </div>

                            <!-- Tab Contents -->
                            <div class="tab-contents">
                                <!-- Suggestions Tab -->
                                <div id="suggestionsContent" class="tab-content active">
                                    <div class="suggestions-section">
                                        <div class="section-header">
                                            <h2><i class="fas fa-magic"></i> Gợi ý tổ hợp phòng phù hợp</h2>
                                            <p>Các tổ hợp phòng được đề xuất dựa trên số lượng khách và ngân sách của bạn</p>
                                        </div>

                                        <c:choose>
                                            <c:when test="${not empty suggestions}">
                                                <div class="suggestions-grid">
                                                    <c:forEach var="combo" items="${suggestions}" varStatus="idx">
                                                        <div class="suggestion-card" data-index="${idx.count}">
                                                            <div class="suggestion-header">
                                                                <span class="suggestion-number">#${idx.count}</span>
                                                                <div class="suggestion-stats">
                                                                    <span class="stat-item">
                                                                        <i class="fas fa-users"></i>
                                                                        <c:set var="totalCapacity" value="0"/>
                                                                        <c:forEach var="sug" items="${combo}">
                                                                            <c:set var="totalCapacity" value="${totalCapacity + sug.quantity * sug.roomType.maxGuests}" />
                                                                        </c:forEach>
                                                                        ${totalCapacity} khách
                                                                    </span>
                                                                    <span class="stat-item">
                                                                        <i class="fas fa-door-open"></i>
                                                                        <c:set var="totalRooms" value="0"/>
                                                                        <c:forEach var="sug" items="${combo}">
                                                                            <c:set var="totalRooms" value="${totalRooms + sug.quantity}" />
                                                                        </c:forEach>
                                                                        ${totalRooms} phòng
                                                                    </span>
                                                                </div>
                                                            </div>

                                                            <div class="suggestion-rooms">
                                                                <c:forEach var="sug" items="${combo}">
                                                                    <div class="room-combo-item">
                                                                        <div class="room-combo-image">
                                                                            <img src="${sug.roomType.imageUrl}" alt="${sug.roomType.name}" 
                                                                                 onerror="this.src='/placeholder.svg?height=120&width=180'">
                                                                            <div class="room-quantity">${sug.quantity}x</div>
                                                                        </div>
                                                                        <div class="room-combo-info">
                                                                            <h4><a href="RoomDetail?id=${sug.roomType.roomTypeID}">${sug.roomType.name}</a></h4>
                                                                            <p class="room-capacity"><i class="fas fa-user"></i> Tối đa ${sug.roomType.maxGuests} người</p>
                                                                            <p class="room-price">
                                                                                <fmt:formatNumber value="${sug.roomType.basePrice}" type="number" maxFractionDigits="0"/> VND/đêm
                                                                            </p>
                                                                        </div>
                                                                    </div>
                                                                </c:forEach>
                                                            </div>

                                                            <div class="suggestion-footer">
                                                                <div class="total-price">
                                                                    <span class="price-label">Tổng cộng:</span>
                                                                    <c:set var="totalPrice" value="0"/>
                                                                    <c:forEach var="sug" items="${combo}">
                                                                        <c:set var="totalPrice" value="${totalPrice + sug.quantity * sug.roomType.basePrice}" />
                                                                    </c:forEach>
                                                                    <span class="price-value">
                                                                        <fmt:formatNumber value="${totalPrice}" type="number" maxFractionDigits="0"/> VND
                                                                    </span>
                                                                </div>

                                                                <div class="combo-row" data-index="${idx.count}">
                                                                    <c:forEach var="sug" items="${combo}">
                                                                        <input type="hidden" name="roomTypeId" value="${sug.roomType.roomTypeID}"
                                                                               data-base-price="${sug.roomType.basePrice != null ? sug.roomType.basePrice : 0}"
                                                                               data-room-name="${sug.roomType.name}"
                                                                               data-room-capacity="${sug.roomType.maxGuests}" />
                                                                        <input type="hidden" name="quantity" value="${sug.quantity}" />
                                                                    </c:forEach>
                                                                    <button type="button" class="select-combo-btn" onclick="handleComboSelection(${idx.count})">
                                                                        <i class="fas fa-check"></i>
                                                                        Chọn tổ hợp này
                                                                    </button>
                                                                </div>

                                                            </div>
                                                        </div>
                                                    </c:forEach>
                                                </div>

                                                <div class="load-more-section" id="loadMoreSection">
                                                    <button id="showMoreBtn" class="load-more-btn" onclick="showMoreCombos()">
                                                        <i class="fas fa-chevron-down"></i>
                                                        Xem thêm tổ hợp
                                                    </button>
                                                    <button id="showLessBtn" class="load-more-btn secondary" onclick="showLessCombos()" style="display: none;">
                                                        <i class="fas fa-chevron-up"></i>
                                                        Thu gọn
                                                    </button>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="empty-state">
                                                    <div class="empty-icon">
                                                        <i class="fas fa-search"></i>
                                                    </div>
                                                    <h3>Không tìm thấy tổ hợp phù hợp</h3>
                                                    <p>Vui lòng thử điều chỉnh lại số người, loại phòng, hoặc ngày nhận/trả phòng.</p>
                                                    <button class="retry-btn" onclick="switchTab('manual')">
                                                        <i class="fas fa-list"></i>
                                                        Tự chọn phòng
                                                    </button>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <!-- Manual Selection Tab -->
                                <div id="manualContent" class="tab-content">
                                    <div class="manual-section">
                                        <div class="section-header">
                                            <h2><i class="fas fa-list"></i> Tự chọn phòng từ danh sách</h2>
                                            <p>Chọn từng phòng theo ý muốn từ danh sách phòng còn trống</p>
                                        </div>

                                        <c:choose>
                                            <c:when test="${not empty availableRooms}">
                                                <div class="rooms-grid">
                                                    <c:forEach var="room" items="${availableRooms}">
                                                        <div class="room-card">
                                                            <div class="room-image-container">
                                                                <img src="${room.imageUrl}" alt="${room.name}" class="room-image" 
                                                                     onerror="this.src='/placeholder.svg?height=250&width=400'">
                                                                <div class="room-badge">
                                                                    <i class="fas fa-door-open"></i>
                                                                    ${room.availableRooms} phòng trống
                                                                </div>
                                                            </div>

                                                            <div class="room-details">
                                                                <div class="room-header">
                                                                    <h3 class="room-title">
                                                                        <a href="RoomDetail?id=${room.roomTypeID}">${room.name}</a>
                                                                    </h3>
                                                                    <div class="room-price">
                                                                        <span class="price-amount">
                                                                            <fmt:formatNumber value="${room.basePrice}" type="number" maxFractionDigits="0"/> VND
                                                                        </span>
                                                                        <span class="price-unit">/ đêm</span>
                                                                    </div>
                                                                </div>

                                                                <p class="room-description">${room.description}</p>

                                                                <div class="room-meta">
                                                                    <span class="meta-item">
                                                                        <i class="fas fa-users"></i>
                                                                        Tối đa ${room.maxGuests} người
                                                                    </span>
                                                                </div>


                                                                <form class="room-selection-form" data-room-capacity="${room.maxGuests}" onsubmit="return handleManualSelection(this)">
                                                                    <input type="hidden" name="roomTypeId" value="${room.roomTypeID}">
                                                                    <input type="hidden" name="roomName" value="${room.name}">
                                                                    <input type="hidden" name="checkin" value="${checkin}">
                                                                    <input type="hidden" name="checkout" value="${checkout}">
                                                                    <input type="hidden" name="roomCapacity" value="${room.maxGuests}">

                                                                    <div class="quantity-selection">
                                                                        <label>Số lượng phòng:</label>
                                                                        <div class="quantity-controls">
                                                                            <button type="button" class="qty-btn minus" onclick="changeQuantity(this, -1)">
                                                                                <i class="fas fa-minus"></i>
                                                                            </button>
                                                                            <input type="number" name="quantity" class="qty-input" min="1" max="${room.availableRooms}" value="1">
                                                                            <button type="button" class="qty-btn plus" onclick="changeQuantity(this, 1)">
                                                                                <i class="fas fa-plus"></i>
                                                                            </button>
                                                                        </div>
                                                                    </div>

                                                                    <button type="submit" class="select-room-btn">
                                                                        <i class="fas fa-plus-circle"></i>
                                                                        Thêm vào giỏ
                                                                    </button>
                                                                </form>
                                                            </div>
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="empty-state">
                                                    <div class="empty-icon">
                                                        <i class="fas fa-bed"></i>
                                                    </div>
                                                    <h3>Không còn phòng trống</h3>
                                                    <p>Hiện tại không còn phòng nào trống trong khoảng thời gian bạn chọn.</p>
                                                    <button class="retry-btn" onclick="document.getElementById('checkin').focus()">
                                                        <i class="fas fa-calendar"></i>
                                                        Thay đổi ngày
                                                    </button>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <!-- Services Tab -->
                                <div id="servicesContent" class="tab-content">
                                    <div class="services-section">
                                        <div class="section-header">
                                            <h2><i class="fas fa-concierge-bell"></i> Dịch vụ bổ sung</h2>
                                            <p>Nâng cao trải nghiệm của bạn với các dịch vụ cao cấp</p>
                                        </div>

                                        <div class="services-grid">
                                            <c:forEach var="service" items="${services}">
                                                <div class="service-card">
                                                    <c:if test="${not empty service.serviceImage}">
                                                        <div class="service-image">
                                                            <img src="${service.serviceImage}" alt="${service.name}" 
                                                                 onerror="this.src='/placeholder.svg?height=120&width=180'" />
                                                        </div>
                                                    </c:if>

                                                    <div class="service-content">
                                                        <div class="service-header">
                                                            <label class="service-checkbox">
                                                                <input type="checkbox" value="${service.id}"
                                                                       data-name="${fn:escapeXml(service.name)}"
                                                                       data-price="${service.price}"
                                                                       onchange="toggleService(this)" />
                                                                <span class="checkmark"></span>
                                                                <div class="service-info">
                                                                    <h4 class="service-name">${service.name}</h4>
                                                                    <span class="service-price">
                                                                        <fmt:formatNumber value="${service.price}" type="number" maxFractionDigits="0"/> VND
                                                                    </span>
                                                                </div>
                                                            </label>
                                                        </div>
                                                        <c:if test="${not empty service.description}">
                                                            <p class="service-description">${service.description}</p>
                                                        </c:if>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Right Sidebar - Cart -->
                        <div class="cart-sidebar">
                            <div class="cart-container">
                                <div class="cart-header">
                                    <h3><i class="fas fa-shopping-cart"></i> Thông tin đặt phòng</h3>
                                </div>

                                <div class="cart-content">
                                    <div class="selected-rooms" id="selectedRoomsList">
                                        <div class="empty-cart">
                                            <i class="fas fa-bed"></i>
                                            <p>Chưa có phòng nào được chọn</p>
                                        </div>
                                    </div>

                                    <div class="cart-summary">
                                        <div class="summary-row">
                                            <span>Số đêm:</span>
                                            <span id="nightsCount">0 đêm</span>
                                        </div>
                                        <div class="summary-row">
                                            <span>Tạm tính:</span>
                                            <span id="roomsTotal">0 VND</span>
                                        </div>
                                        <div class="summary-row">
                                            <span>Thuế (10%):</span>
                                            <span id="taxAmount">0 VND</span>
                                        </div>
                                        <div class="summary-row total">
                                            <span>Tổng cộng:</span>
                                            <span id="grandTotal">0 VND</span>
                                        </div>
                                    </div>

                                    <button id="bookingBtn" type="button" class="checkout-btn" onclick="proceedToBooking()" disabled>
                                        <i class="fas fa-credit-card"></i>
                                        Tiến hành thanh toán
                                    </button>
                                </div>
                            </div>

                            <!-- ✅ Form ẩn: đặt ngay sau Sidebar -->
                            <form id="bookingForm" action="${pageContext.request.contextPath}/ProceedBookingServlet" method="POST">
                                <input type="hidden" name="selectedRoomsJSON" id="selectedRoomsJSON">
                                <input type="hidden" name="selectedServicesJSON" id="selectedServicesJSON">
                                <input type="hidden" name="checkin" id="hiddenCheckin">
                                <input type="hidden" name="checkout" id="hiddenCheckout">
                                <input type="hidden" name="guests" id="hiddenGuests">

                                <!-- 👇 BẮT BUỘC PHẢI CÓ 3 trường này -->
                                <input type="hidden" name="fullName" id="fullName">
                                <input type="hidden" name="email" id="email">
                                <input type="hidden" name="phone" id="phone">
                                <input type="hidden" name="totalAmount" id="totalAmount">


                                <!-- Modal vẫn để đây -->
                                <div id="guestInfoModal" class="modal">
                                    <div class="modal-content">
                                        <span class="close-btn" onclick="closeModal()">&times;</span>
                                        <h3>Nhập thông tin liên hệ</h3>
                                        <label>Họ tên: <input type="text" id="guestFullName"></label><br>
                                        <label>Email: <input type="email" id="guestEmail"></label><br>
                                        <label>Điện thoại: <input type="tel" id="guestPhone"></label><br>
                                        <button onclick="confirmGuestInfo()">Xác nhận</button>
                                    </div>
                                </div>
                            </form>

                            <!-- Modal nhập thông tin Guest -->



                        </div>
                    </div>
                </div>
            </div>


            <!-- 5. PHÂN TRANG -->

            <footer>
                <div class="footer-top">
                    <div class="pt-exebar">
                        <div class="container">
                            <div class="d-flex align-items-stretch">
                                <div class="pt-logo mr-auto">
                                    <a href="Home"><img src="assets/images/logo-white.png" alt=""/></a>
                                </div>
                                <div class="pt-social-link">
                                    <ul class="list-inline m-a0">
                                        <li><a href="#" class="btn-link"><i class="fa fa-facebook"></i></a></li>
                                        <li><a href="#" class="btn-link"><i class="fa fa-twitter"></i></a></li>
                                        <li><a href="#" class="btn-link"><i class="fa fa-linkedin"></i></a></li>
                                        <li><a href="#" class="btn-link"><i class="fa fa-google-plus"></i></a></li>
                                    </ul>
                                </div>
                                <div class="pt-btn-join">
                                    <a href="#" class="btn ">Join Now</a>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="container">
                        <div class="row">
                            <div class="col-lg-4 col-md-12 col-sm-12 footer-col-4">
                                <div class="widget">
                                    <h5 class="footer-title">Sign Up For A Newsletter</h5>
                                    <p class="text-capitalize m-b20">Weekly Breaking news analysis and cutting edge advices on job searching.</p>
                                    <div class="subscribe-form m-b20">
                                        <form class="subscription-form" action="http://educhamp.themetrades.com/demo/assets/script/mailchamp.php" method="post">
                                            <div class="ajax-message"></div>
                                            <div class="input-group">
                                                <input name="email" required="required"  class="form-control" placeholder="Your Email Address" type="email">
                                                <span class="input-group-btn">
                                                    <button name="submit" value="Submit" type="submit" class="btn"><i class="fa fa-arrow-right"></i></button>
                                                </span> 
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                            <div class="col-12 col-lg-5 col-md-7 col-sm-12">
                                <div class="row">
                                    <div class="col-4 col-lg-4 col-md-4 col-sm-4">
                                        <div class="widget footer_widget">
                                            <h5 class="footer-title">Company</h5>
                                            <ul>
                                                <li><a href="Home">Home</a></li>
                                                <li><a href="about-1.html">About</a></li>
                                                <li><a href="faq-1.jsp">FAQs</a></li>
                                                <li><a href="contact-1.html">Contact</a></li>
                                            </ul>
                                        </div>
                                    </div>
                                    <div class="col-4 col-lg-4 col-md-4 col-sm-4">
                                        <div class="widget footer_widget">
                                            <h5 class="footer-title">Get In Touch</h5>
                                            <ul>
                                                <li><a href="http://educhamp.themetrades.com/admin/Home">Dashboard</a></li>
                                                <li><a href="blog-classic-grid.html">Blog</a></li>
                                                <li><a href="portfolio.html">Portfolio</a></li>
                                                <li><a href="event.html">Event</a></li>
                                            </ul>
                                        </div>
                                    </div>
                                    <div class="col-4 col-lg-4 col-md-4 col-sm-4">
                                        <div class="widget footer_widget">
                                            <h5 class="footer-title">Rooms</h5>
                                            <ul>
                                                <li><a href="roomlist">Rooms</a></li>
                                                <li><a href="rooms-details.jsp">Details</a></li>
                                                <li><a href="membership.html">Membership</a></li>
                                                <li><a href="profile.html">Profile</a></li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-12 col-lg-3 col-md-5 col-sm-12 footer-col-4">
                                <div class="widget widget_gallery gallery-grid-4">
                                    <h5 class="footer-title">Our Gallery</h5>
                                    <ul class="magnific-image">
                                        <li><a href="assets/images/gallery/pic1.jpg" class="magnific-anchor"><img src="assets/images/gallery/pic1.jpg" alt=""></a></li>
                                        <li><a href="assets/images/gallery/pic2.jpg" class="magnific-anchor"><img src="assets/images/gallery/pic2.jpg" alt=""></a></li>
                                        <li><a href="assets/images/gallery/pic3.jpg" class="magnific-anchor"><img src="assets/images/gallery/pic3.jpg" alt=""></a></li>
                                        <li><a href="assets/images/gallery/pic4.jpg" class="magnific-anchor"><img src="assets/images/gallery/pic4.jpg" alt=""></a></li>
                                        <li><a href="assets/images/gallery/pic5.jpg" class="magnific-anchor"><img src="assets/images/gallery/pic5.jpg" alt=""></a></li>
                                        <li><a href="assets/images/gallery/pic6.jpg" class="magnific-anchor"><img src="assets/images/gallery/pic6.jpg" alt=""></a></li>
                                        <li><a href="assets/images/gallery/pic7.jpg" class="magnific-anchor"><img src="assets/images/gallery/pic7.jpg" alt=""></a></li>
                                        <li><a href="assets/images/gallery/pic8.jpg" class="magnific-anchor"><img src="assets/images/gallery/pic8.jpg" alt=""></a></li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="footer-bottom">
                    <div class="container">
                        <div class="row">
                            <div class="col-lg-12 col-md-12 col-sm-12 text-center"><a target="_blank" href="https://www.templateshub.net">Templates Hub</a></div>
                        </div>
                    </div>
                </div>
            </footer>
            <!-- Footer END ==== -->
            <button class="back-to-top fa fa-chevron-up" ></button>
        </div>
        <div id="imageModal" class="image-modal" onclick="closeImageModal()">
            <span class="image-modal-content">
                <img id="imageModalImg" src="" alt="">
            </span>
        </div>

        <!-- External JavaScripts -->
        <script src="assets/js/jquery.min.js"></script>
        <script src="assets/vendors/bootstrap/js/popper.min.js"></script>
        <script src="assets/vendors/bootstrap/js/bootstrap.min.js"></script>
        <script src="assets/vendors/bootstrap-select/bootstrap-select.min.js"></script>
        <script src="assets/vendors/bootstrap-touchspin/jquery.bootstrap-touchspin.js"></script>
        <script src="assets/vendors/magnific-popup/magnific-popup.js"></script>
        <script src="assets/vendors/counter/waypoints-min.js"></script>
        <script src="assets/vendors/counter/counterup.min.js"></script>
        <script src="assets/vendors/imagesloaded/imagesloaded.js"></script>
        <script src="assets/vendors/masonry/masonry.js"></script>
        <script src="assets/vendors/masonry/filter.js"></script>
        <script src="assets/vendors/owl-carousel/owl.carousel.js"></script>
        <script src="assets/js/functions.js"></script>
        <script src="assets/js/contact.js"></script>
        <script src='assets/vendors/switcher/switcher.js'></script>

        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
        <script>
            const isCustomer = ${sessionScope.user != null ? true : false};
            document.getElementById('guestInfoModal').style.display = 'block';
            document.getElementById('guestInfoModal').style.display = 'none';
            function closeModal() {
                document.getElementById('guestInfoModal').style.display = 'none';
            }


        </script>

        <script>
            flatpickr("#checkin", {
                dateFormat: "d/m/Y", // Định dạng dd/mm/yyyy
                defaultDate: "${param.checkin}"   // Ngày từ request param
            });

            flatpickr("#checkout", {
                dateFormat: "d/m/Y",
                defaultDate: "${param.checkout}"
            });
        </script>
        <script>
            const checkinInput = document.getElementById('checkin');
            const checkoutInput = document.getElementById('checkout');

            checkinInput.addEventListener('change', validateDates);
            checkoutInput.addEventListener('change', validateDates);

            function parseDate(dateStr) {
                // format: dd/MM/yyyy
                const parts = dateStr.split('/');
                const day = parseInt(parts[0], 10);
                const month = parseInt(parts[1], 10) - 1; // JS month: 0-11
                const year = parseInt(parts[2], 10);
                return new Date(year, month, day);
            }

            function validateDates() {
                const checkin = parseDate(checkinInput.value);
                const checkout = parseDate(checkoutInput.value);

                if (checkin && checkout && checkout <= checkin) {
                    alert('❌ Ngày trả phòng phải sau ngày nhận phòng.');
                    checkoutInput.value = '';
                }
            }

            function validateForm() {
                const checkin = parseDate(checkinInput.value);
                const checkout = parseDate(checkoutInput.value);

                if (checkout <= checkin) {
                    alert('❌ Ngày trả phòng phải sau ngày nhận phòng.');
                    return false;
                }
                return true;
            }
        </script>
        <script >
            function changeQuantity(btn, delta) {
                const input = btn.parentElement.querySelector('.qty-input');
                let val = parseInt(input.value) || 1;
                const min = parseInt(input.min) || 1;
                const max = parseInt(input.max) || 99;

                val += delta;

                if (val < min)
                    val = min;
                if (val > max)
                    val = max;

                input.value = val;
            }

        </script>
        <script>
            const isCustomer = ${sessionScope.user != null ? 'true' : 'false'};
        </script>
        <script src="assets/js/listRoom.js"></script>
        <script src="assets/js/hotel-cart.js"></script>




        <script>
            document.addEventListener("DOMContentLoaded", function () {
                const rows = document.querySelectorAll(".combo-row");
                const showMoreBtn = document.getElementById("showMoreBtn");
                const showLessBtn = document.getElementById("showLessBtn");
                const limit = 5;

                rows.forEach((row, idx) => {
                    if (idx >= limit)
                        row.style.display = "none";
                });

                if (rows.length <= limit) {
                    showMoreBtn.style.display = "none";
                }

                window.showMoreCombos = function () {
                    rows.forEach(row => row.style.display = "");
                    showMoreBtn.style.display = "none";
                    showLessBtn.style.display = "";
                };

                window.showLessCombos = function () {
                    rows.forEach((row, idx) => {
                        if (idx >= limit)
                            row.style.display = "none";
                    });
                    showMoreBtn.style.display = "";
                    showLessBtn.style.display = "none";
                };
            });
        </script>


        <script>
            localStorage.setItem('selectedRooms',
                    JSON.stringify(
                            (JSON.parse(localStorage.getItem('selectedRooms')) || []).filter(item => !item.rooms)
                            )
                    );
        </script>
    </body>
</html>