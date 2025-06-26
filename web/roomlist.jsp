

<%@ page contentType="text/html; charset=UTF-8" language="java" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
        <link rel="stylesheet" href="assets/css/confirm-add-room.css">

        <!-- REVOLUTION SLIDER END -->	
        <style>
            /* Responsive cho form tìm kiếm */
            @media (max-width: 1200px) {
                .cours-search {
                    flex-wrap: wrap !important;
                    gap: 15px !important;
                }

                .cours-search > div {
                    min-width: auto !important;
                    flex: 1 1 200px;
                }
            }

            @media (max-width: 768px) {
                .cours-search {
                    flex-direction: column !important;
                    align-items: stretch !important;
                }

                .cours-search > div {
                    width: 100% !important;
                    min-width: auto !important;
                }

                .cours-search > div:last-child button {
                    margin-top: 5px !important;
                }

                .guest-room-dropdown {
                    position: fixed !important;
                    left: 10px !important;
                    right: 10px !important;
                    top: auto !important;
                    width: auto !important;
                }
            }

            /* Style cho date inputs */
            .cours-search input[type="date"] {
                color: #333;
                font-size: 14px;
            }

            .cours-search input[type="date"]::-webkit-calendar-picker-indicator {
                cursor: pointer;
                filter: invert(0);
            }

            /* Style cho select và input */
            .cours-search select,
            .cours-search input {
                font-size: 14px;
                color: #333;
                background-color: #fff;
            }

            .cours-search select:focus,
            .cours-search input:focus {
                outline: none;
                box-shadow: 0 0 0 2px rgba(255, 193, 7, 0.5);
            }

            /* Label styling */
            .cours-search label {
                font-weight: 500;
                white-space: nowrap;
            }

            /* Button hover effects */
            .guest-room-dropdown button:hover {
                background-color: #f8f9fa !important;
                border-color: #007bff !important;
                color: #007bff !important;
            }

            /* Dropdown animation */
            .guest-room-dropdown {
                transition: all 0.3s ease;
            }

            /* Selector display hover */
            .selector-display:hover {
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            }
            #booking-bar {
                position: sticky;
                top: 80px; /* chỉnh theo chiều cao header của bạn */
                z-index: 999;
                background-color: #fff;
                border-bottom: 1px solid #eaeaea;
            }

            #booking-bar .form-group {
                min-width: 150px;
                flex: 1;
            }

            #booking-bar label {
                font-weight: 600;
                margin-bottom: 6px;
            }

            #booking-bar input {
                border-radius: 6px;
                border: 1px solid #ced4da;
                padding: 8px 12px;
                font-size: 15px;
            }

            #booking-bar input:focus {
                border-color: #ffc107;
                box-shadow: 0 0 0 2px rgba(255, 193, 7, 0.25);
            }

            #booking-bar button {
                border-radius: 6px;
            }
            #booking-bar .invisible-label label {
                visibility: hidden;
            }

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

            <!-- 1. THÔNG TIN TÌM KIẾM -->
            <h2>🔍 Kết quả tìm phòng cho <strong>${guests}</strong> người</h2>
            <p>
                Ngày đến: <strong>${checkin}</strong> |
                Ngày đi: <strong>${checkout}</strong> |
                Số người: <strong>${guests}</strong> |

            </p>
            <hr/>

            <!-- 2. FILTER PANEL -->
            <h2>	🛠 Bộ lọc nâng cao</h2>

            <form method="get" action="FindAvailableRoomsServlet" style="border: 1px solid #ccc; padding: 15px; margin-bottom: 20px;">
                <div style="display: flex; flex-wrap: wrap; gap: 20px; align-items: flex-end;">

                    <div>
                        <label>Ngày đến</label><br>
                        <input type="date" name="checkin" value="${param.checkin}" required>
                    </div>
                    <div>
                        <label>Ngày đi</label><br>
                        <input type="date" name="checkout" value="${param.checkout}" required>
                    </div>
                    <div>
                        <label>Số người</label><br>
                        <input type="number" name="guests" value="${param.guests}" min="1" required>
                    </div>

                    <div>
                        <label>Loại phòng</label><br>
                        <select name="roomType">
                            <option value="">-- Tất cả --</option>
                            <c:forEach var="type" items="${roomTypes}">
                                <option value="${type.name}" <c:if test="${param.roomType == type.name}">selected</c:if>>${type.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div>
                        <label>Giá tối đa</label><br>
                        <input type="number" name="maxPrice" value="${param.maxPrice}">
                    </div>

                    <!-- Lọc từng phòng -->
                    <label>Sức chứa tối thiểu của từng phòng:</label>
                    <input type="number" name="minGuestsPerRoom" value="${param.minGuestsPerRoom}"/>

                    <!-- Lọc tổ hợp -->
                    <label>Tổng sức chứa tối thiểu của tổ hợp:</label>
                    <input type="number" name="minTotalGuests" value="${param.minTotalGuests}"/>

                    <div>
                        <button type="submit" style="margin-top: 6px;">🔍 Tìm và Gợi ý</button>
                    </div>
                </div>
                <c:if test="${not empty error}">
                    <div style="color:red; margin-bottom:10px;">${error}</div>
                </c:if>
                <c:if test="${not empty errorMessage}">
                    <div style="color:red; font-weight:bold;">${errorMessage}</div>
                </c:if>


            </form>

            <hr/>
            <c:choose>
                <c:when test="${empty rooms}">
                    <p>Hệ thống đang tự động gợi ý tổ hợp phòng tối ưu cho <strong>${guests}</strong> người.</p>
                </c:when>

            </c:choose>

            <!-- 3. GỢI Ý PHÂN BỔ PHÒNG -->

            <h3>  🤖 Gợi ý tổ hợp phòng phù hợp cho ${guests} người</h3>
            <table border="1" cellpadding="10">
                <tr>
                    <th>#</th>
                    <th>Tổ hợp</th>
                    <th>Sức chứa</th>
                    <th>Số phòng</th>
                    <th>Hành động</th>
                    <th>Tổng giá tạm tính</th>
                </tr>
                <c:forEach var="combo" items="${suggestions}" varStatus="idx">
                    <tr>
                        <td>${idx.count}</td>
                        <td>
                            <c:forEach var="sug" items="${combo}">
                                ${sug.quantity} x ${sug.roomType.name}<br/>
                            </c:forEach>
                        </td>
                        <td>
                            <c:set var="total" value="0"/>
                            <c:forEach var="sug" items="${combo}">
                                <c:set var="total" value="${total + sug.quantity * sug.roomType.maxGuests}" />
                            </c:forEach>
                            ${total}
                        </td>
                        <td>
                            <c:set var="totalRooms" value="0"/>
                            <c:forEach var="sug" items="${combo}">
                                <c:set var="totalRooms" value="${totalRooms + sug.quantity}" />
                            </c:forEach>
                            ${totalRooms}
                        </td>
                        <td>
                            <form action="addComboToCart" method="post">
                                <c:forEach var="sug" items="${combo}">
                                    <input type="hidden" name="roomTypeId" value="${sug.roomType.roomTypeID}" />
                                    <input type="hidden" name="quantity" value="${sug.quantity}" />
                                </c:forEach>
                                <button>Chọn tổ hợp</button>
                            </form>
                        </td>
                        <td>
                            <c:set var="totalPrice" value="0"/>
                            <c:forEach var="sug" items="${combo}">
                                <c:set var="totalPrice" value="${totalPrice + sug.quantity * sug.roomType.basePrice}" />
                            </c:forEach>
                            $${totalPrice}
                        </td>
                    </tr>
                </c:forEach>
            </table>
            <div style="text-align:center; margin-top: 15px;">
                <c:if test="${totalPages > 1}">
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <c:choose>
                            <c:when test="${i == currentPage}">
                                <strong>[${i}]</strong>
                            </c:when>
                            <c:otherwise>
                                <a href="FindAvailableRoomsServlet?checkin=${checkin}
                                   &checkout=${checkout}
                                   &guests=${guests}
                                   &roomType=${param.roomType}
                                   &minGuests=${param.minGuests}
                                   &maxPrice=${param.maxPrice}
                                   &suggestPage=${i}">[${i}]</a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                </c:if>
            </div>

            <hr/>

            <!-- 4. DANH SÁCH PHÒNG CÓ SẴN -->
            <h3>🏨 Tự chọn phòng từ danh sách còn trống</h3>
            <c:forEach var="room" items="${availableRooms}">
                <div style="border:1px solid #ccc; margin:10px; padding:10px;">
                    <img src="${room.imageUrl}" width="200px" style="float:left; margin-right:10px;">
                    <h4>${room.name}</h4>
                    <p>${room.description}</p>
                    <p>Sức chứa: ${room.maxGuests} người</p>

                    <p>Giá : <c:out value="${room.basePrice}" default="(null)" /></p>

                    <p>Phòng còn trống: ${room.availableRooms}</p>
                    <form method="post" action="addToCart">
                        <input type="hidden" name="roomTypeId" value="${room.roomTypeID}">
                        <input type="hidden" name="checkin" value="${checkin}">
                        <input type="hidden" name="checkout" value="${checkout}">
                        <input type="number" name="quantity" min="1" max="${room.availableRooms}" value="1">
                        <button>Đặt phòng</button>
                    </form>
                    <div style="clear:both;"></div>
                </div>
            </c:forEach>



            <hr/>

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
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    </body>
</html>
