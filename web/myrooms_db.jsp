<%-- 
    Document   : index.jsp
    Created on : May 23, 2025, 9:14:16 AM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


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
        <meta name="description" content="Kh�ch s?n Ho�ng Nam - Chu?i kh�ch s?n l?n nh?t mi?n b?c" />

        <!-- OG -->
        <meta property="og:title" content="Kh�ch s?n Ho�ng Nam - Chu?i kh�ch s?n l?n nh?t mi?n b?c" />
        <meta property="og:description" content="Kh�ch s?n Ho�ng Nam - Chu?i kh�ch s?n l?n nh?t mi?n b?c" />
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
        <link rel="stylesheet" href="assets/css/booking-interface.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <!-- REVOLUTION SLIDER END -->	
        <style>

        </style>
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
                                            <a class="nav-link" href="user-profile">Hello, ${sessionScope.user.username}</a>
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
                                    <li><a href="myrooms"><i class="fa fa-bed"></i> My Rooms</a></li>
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


            <p>DEBUG size: ${fn:length(selectedRooms)}</p>

            <div class="booking-content">
                <!-- Room Selection Panel -->
                <div class="room-selection-panel">
                    <h2 class="panel-title"><i class="fas fa-bed"></i> Available Rooms</h2>

                    <c:choose>
                        <c:when test="${not empty guestCart}">
                            <c:forEach var="room" items="${guestCart}" varStatus="status">
                                <div class="room-card" data-room-type-id="${room.roomTypeId}">
                                    <img src="${room.imageUrl}" width="120" height="90" style="object-fit:cover; border-radius:6px;">
                                    <div class="room-header">
                                        <div class="room-info">
                                            <h3>Phòng loại: ${room.roomName}</h3>
                                            <div class="room-details">
                                                <div><i class="fas fa-users"></i> Sức chứa: ${room.maxguest} người</div>
                                            </div>
                                        </div>
                                        <div class="room-price">
                                            <div class="price-amount">
                                                <fmt:formatNumber value="${room.basePrice}" type="number" groupingUsed="true"/> VND
                                            </div>
                                            <div class="price-unit">/ đêm</div>
                                        </div>
                                    </div>

                                    <!-- Guest Selection -->
                                    <div class="guest-selection">
                                        <h4 style="margin-bottom: 10px; color: #374151; font-size: 0.9rem;">
                                            <i class="fas fa-user-friends"></i> Chọn số lượng khách
                                        </h4>
                                        <div class="guest-controls">
                                            <div class="guest-control">
                                                <label>Người lớn</label>
                                                <div class="counter-group">
                                                    <button type="button" class="counter-btn" onclick="changeGuest('${room.roomTypeId}', 'adults', -1)">
                                                        <i class="fas fa-minus"></i>
                                                    </button>
                                                    <span class="counter-value" id="adults_${room.roomTypeId}">2</span>
                                                    <button type="button" class="counter-btn" onclick="changeGuest('${room.roomTypeId}', 'adults', 1)">
                                                        <i class="fas fa-plus"></i>
                                                    </button>
                                                </div>
                                            </div>
                                            <div class="guest-control">
                                                <label>Trẻ em (6-12)</label>
                                                <div class="counter-group">
                                                    <button type="button" class="counter-btn" onclick="changeGuest('${room.roomTypeId}', 'children', -1)">
                                                        <i class="fas fa-minus"></i>
                                                    </button>
                                                    <span class="counter-value" id="children_${room.roomTypeId}">0</span>
                                                    <button type="button" class="counter-btn" onclick="changeGuest('${room.roomTypeId}', 'children', 1)">
                                                        <i class="fas fa-plus"></i>
                                                    </button>
                                                </div>
                                            </div>
                                            <div class="guest-control">
                                                <label>Em bé (0-5)</label>
                                                <div class="counter-group">
                                                    <button type="button" class="counter-btn" onclick="changeGuest('${room.roomTypeId}', 'babies', -1)">
                                                        <i class="fas fa-minus"></i>
                                                    </button>
                                                    <span class="counter-value" id="babies_${room.roomTypeId}">0</span>
                                                    <button type="button" class="counter-btn" onclick="changeGuest('${room.roomTypeId}', 'babies', 1)">
                                                        <i class="fas fa-plus"></i>
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Action Buttons -->
                                    <div class="room-actions">
                                        <button type="button" class="btn btn-primary" onclick="addToBooking('${room.roomTypeId}')">
                                            <i class="fas fa-plus"></i> Thêm vào đặt phòng
                                        </button>
                                        <form method="post" action="RemoveFromGuestCartServlet" style="display: inline;">
                                            <input type="hidden" name="roomTypeId" value="${room.roomTypeId}">
                                            <button type="submit" class="btn btn-danger">
                                                <i class="fas fa-trash"></i> Xóa
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state">
                                <i class="fas fa-bed"></i>
                                <h3>Không có phòng nào được chọn</h3>
                                <p>Vui lòng quay lại trang tìm kiếm để chọn phòng</p>
                                <a href="searchRooms" class="btn btn-primary">
                                    <i class="fas fa-search"></i> Tìm kiếm phòng
                                </a>
                            </div>
                        </c:otherwise>
                    </c:choose>

                </div>

                <!-- Booking Summary Panel -->
                <div class="booking-summary">
                    <h2 class="panel-title"><i class="fas fa-receipt"></i> Thông tin đặt phòng</h2>

                    <!-- Date Selection -->
                    <div class="summary-section">
                        <h3 class="summary-title">Thời gian lưu trú</h3>
                        <div class="date-inputs">
                            <div class="date-input">
                                <label>Ngày nhận phòng</label>
                                <input type="date" id="checkInDate" onchange="calculateTotal()" value="2025-06-22">
                            </div>
                            <div class="date-input">
                                <label>Ngày trả phòng</label>
                                <input type="date" id="checkOutDate" onchange="calculateTotal()" value="2025-06-23">
                            </div>
                        </div>
                        <div style="text-align: center; color: #6b7280; font-size: 0.9rem; margin-top: 10px;">
                            <span id="nightsCount">1 đêm</span>
                        </div>
                    </div>

                    <!-- Selected Rooms -->
                    <div class="summary-section">
                        <h3 class="summary-title">Phòng đã chọn</h3>
                        <div class="selected-rooms" id="selectedRoomsList">
                            <!-- Will be populated by JavaScript -->
                        </div>
                    </div>

                    <!-- Price Breakdown -->
                    <div class="summary-section">
                        <h3 class="summary-title">Chi tiết giá</h3>
                        <div class="price-breakdown" id="priceBreakdown">
                            <div class="price-row">
                                <span>Tổng tiền phòng:</span>
                                <span class="price-value" id="roomsTotal">0 VND</span>
                            </div>
                            <div class="price-row">
                                <span>Thuế VAT (10%):</span>
                                <span class="price-value" id="taxAmount">0 VND</span>
                            </div>
                            <div class="price-row total">
                                <span>Tổng cộng:</span>
                                <span class="price-value total" id="grandTotal">0 VND</span>
                            </div>
                        </div>
                    </div>

                    <!-- Booking Button -->
                    <button type="button" class="booking-button" id="bookingBtn" onclick="proceedToBooking()" disabled>
                        <i class="fas fa-calendar-check"></i> Đặt phòng ngay
                    </button>
                </div>
            </div>
        </div>

        <script>
            // Booking data
            const bookingData = {
                rooms: {},
                checkIn: '2025-06-22',
                checkOut: '2025-06-23',
                nights: 1
            };

            // Room prices from backend
            const roomPrices = {};
            <c:forEach var="room" items="${selectedRooms}">
            roomPrices[${room.roomID}] = {
                price: ${room.roomType.basePrice},
                name: "${room.roomType.name}",
                roomNumber: "${room.roomnumber}"
            };
            </c:forEach>

            // Change guest count
            function changeGuest(roomId, type, delta) {
                const element = document.getElementById(type + '_' + roomId);
                let currentValue = parseInt(element.textContent);
                let newValue = currentValue + delta;

                // Minimum constraints
                if (type === 'adults' && newValue < 1)
                    newValue = 1;
                if ((type === 'children' || type === 'babies') && newValue < 0)
                    newValue = 0;

                element.textContent = newValue;

                // Update booking data if room is already added
                if (bookingData.rooms[roomId]) {
                    bookingData.rooms[roomId][type] = newValue;
                    updateSelectedRoomsList();
                    calculateTotal();
                }
            }

            // Add room to booking
            function addToBooking(roomId) {
                const adults = parseInt(document.getElementById('adults_' + roomId).textContent);
                const children = parseInt(document.getElementById('children_' + roomId).textContent);
                const babies = parseInt(document.getElementById('babies_' + roomId).textContent);

                bookingData.rooms[roomId] = {
                    adults: adults,
                    children: children,
                    babies: babies,
                    price: roomPrices[roomId].price,
                    name: roomPrices[roomId].name,
                    roomNumber: roomPrices[roomId].roomNumber
                };

                updateSelectedRoomsList();
                calculateTotal();
                updateBookingButton();
            }

            // Remove room from booking
            function removeFromBooking(roomId) {
                delete bookingData.rooms[roomId];
                updateSelectedRoomsList();
                calculateTotal();
                updateBookingButton();
            }

            // Update selected rooms list
            function updateSelectedRoomsList() {
                const container = document.getElementById('selectedRoomsList');
                let html = '';

                for (let roomId in bookingData.rooms) {
                    const room = bookingData.rooms[roomId];
                    const totalGuests = room.adults + room.children + room.babies;

                    html += `
                        <div class="selected-room-item">
                            <div class="selected-room-header">
    <div>
        <div class="selected-room-name">Phòng ${room.roomNumber} - ${room.name}</div>
        <div class="selected-room-details">
            ${totalGuests} khách (${room.adults} NL, ${room.children} TE, ${room.babies} EB)
        </div>
        <div class="selected-room-price">
            <fmt:formatNumber value="${room.price}" type="number" groupingUsed="true" /> VND/đêm
        </div>
    </div>
    <button class="remove-room" onclick="removeFromBooking(${roomId})" title="Xóa phòng">
        <i class="fas fa-times"></i>
    </button>
</div>

                    `;
                }

                if (html === '') {
                    html = '<div style="text-align: center; color: #6b7280; padding: 20px;">Chưa có phòng nào được chọn</div>';
                }

                container.innerHTML = html;
            }

            // Calculate total price
            function calculateTotal() {
                updateDates();

                let roomsTotal = 0;
                for (let roomId in bookingData.rooms) {
                    roomsTotal += bookingData.rooms[roomId].price * bookingData.nights;
                }

                const taxAmount = roomsTotal * 0.1;
                const grandTotal = roomsTotal + taxAmount;

                document.getElementById('roomsTotal').textContent = formatPrice(roomsTotal) + ' VND';
                document.getElementById('taxAmount').textContent = formatPrice(taxAmount) + ' VND';
                document.getElementById('grandTotal').textContent = formatPrice(grandTotal) + ' VND';
            }

            // Update dates and calculate nights
            function updateDates() {
                const checkIn = document.getElementById('checkInDate').value;
                const checkOut = document.getElementById('checkOutDate').value;

                if (checkIn && checkOut) {
                    const checkInDate = new Date(checkIn);
                    const checkOutDate = new Date(checkOut);
                    const timeDiff = checkOutDate.getTime() - checkInDate.getTime();
                    const nights = Math.ceil(timeDiff / (1000 * 3600 * 24));

                    bookingData.checkIn = checkIn;
                    bookingData.checkOut = checkOut;
                    bookingData.nights = Math.max(1, nights);

                    document.getElementById('nightsCount').textContent = bookingData.nights + ' đêm';
                }
            }

            // Format price
            function formatPrice(price) {
                return new Intl.NumberFormat('vi-VN').format(Math.round(price));
            }

            // Update booking button state
            function updateBookingButton() {
                const btn = document.getElementById('bookingBtn');
                const hasRooms = Object.keys(bookingData.rooms).length > 0;

                btn.disabled = !hasRooms;
                if (hasRooms) {
                    btn.innerHTML = '<i class="fas fa-calendar-check"></i> Đặt phòng ngay (' + Object.keys(bookingData.rooms).length + ' phòng)';
                } else {
                    btn.innerHTML = '<i class="fas fa-calendar-check"></i> Đặt phòng ngay';
                }
            }

            // Proceed to booking
            function proceedToBooking() {
                if (Object.keys(bookingData.rooms).length === 0) {
                    alert('Vui lòng chọn ít nhất một phòng!');
                    return;
                }

                // Create form and submit
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = 'booking-confirmation';

                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = 'bookingData';
                input.value = JSON.stringify(bookingData);

                form.appendChild(input);
                document.body.appendChild(form);
                form.submit();
            }

            // Initialize
            document.addEventListener('DOMContentLoaded', function () {
                updateDates();
                calculateTotal();
                updateBookingButton();
            });
        </script>
    </div>
    <!-- Content END-->
    <!-- Footer ==== -->
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
<script src="assets/js/hotel-cart.js"></script>
</body>

</html>