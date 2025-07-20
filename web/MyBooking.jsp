<%-- Document : index.jsp Created on : May 23, 2025, 9:14:16 AM Author : Admin --%>

<%@page contentType="text/html" pageEncoding="UTF-8" %>
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
        <meta property="og:description"
              content="Kh�ch s?n Ho�ng Nam - Chu?i kh�ch s?n l?n nh?t mi?n b?c" />
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

        <link rel="stylesheet" href="assets/css/booking-styles.css">
        <link rel="stylesheet"
              href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <!-- Flatpickr CSS & JS -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
        <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>

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
                                    <li><a href="faq-1.jsp"><i class="fa fa-question-circle"></i>Ask a
                                            Question</a></li>
                                    <li><a href="javascript:;"><i
                                                class="fa fa-envelope-o"></i>Support@website.com</a>
                                    </li>
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

                                    <c:if test="${sessionScope.account != null}">
                                        <li class="nav-item">
                                            <a class="nav-link" href="user-profile">Hello,
                                                ${sessionScope.account.username}</a>
                                        </li>
                                        <li class="nav-item">
                                            <a class="nav-link" href="Logout">Logout</a>

                                        </li>
                                    </c:if>
                                    <c:if test="${sessionScope.account == null}">
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
                            <button class="navbar-toggler collapsed menuicon justify-content-end"
                                    type="button" data-toggle="collapse" data-target="#menuDropdown"
                                    aria-controls="menuDropdown" aria-expanded="false"
                                    aria-label="Toggle navigation">
                                <span></span>
                                <span></span>
                                <span></span>
                            </button>
                            <!-- Author Nav ==== -->
                            <div class="secondary-menu">
                                <div class="secondary-inner">
                                    <ul>

                                        <!-- Search Button ==== -->
                                        <li class="search-btn"><button id="quik-search-btn" type="button" class="btn-link"><i class="fa fa-search"></i></button></li>
                                    </ul>
                                </div>
                            </div>
                            <!-- Search Box ==== -->
                            <div class="nav-search-bar">
                                <form action="#">
                                    <input name="search" value="" type="text" class="form-control"
                                           placeholder="Type to search">
                                    <span><i class="ti-search"></i></span>
                                </form>
                                <span id="search-remove"><i class="ti-close"></i></span>
                            </div>
                            <!-- Navigation Menu ==== -->
                            <div class="menu-links navbar-collapse collapse justify-content-start"
                                 id="menuDropdown">
                                <div class="menu-logo">
                                    <a href="Home"><img src="assets/images/logo.png" alt=""></a>
                                </div>
                                <ul class="nav navbar-nav">
                                    <li class="active"><a href="javascript:;">Home <i
                                                class="fa fa-chevron-down"></i></a>
                                        <ul class="sub-menu">
                                            <li><a href="Home">Home 1</a></li>
                                            <li><a href="Home">Home 2</a></li>
                                        </ul>
                                    </li>
                                    <li><a href="javascript:;">Pages <i
                                                class="fa fa-chevron-down"></i></a>
                                        <ul class="sub-menu">
                                            <li><a href="javascript:;">About<i
                                                        class="fa fa-angle-right"></i></a>
                                                <ul class="sub-menu">
                                                    <li><a href="about-1.html">About 1</a></li>
                                                    <li><a href="about-2.html">About 2</a></li>
                                                </ul>
                                            </li>
                                            <li><a href="javascript:;">Event<i
                                                        class="fa fa-angle-right"></i></a>
                                                <ul class="sub-menu">
                                                    <li><a href="event.html">Event</a></li>
                                                    <li><a href="events-details.html">Events Details</a>
                                                    </li>
                                                </ul>
                                            </li>
                                            <li><a href="javascript:;">FAQ's<i
                                                        class="fa fa-angle-right"></i></a>
                                                <ul class="sub-menu">
                                                    <li><a href="faq-1.jsp">FAQ's 1</a></li>
                                                    <li><a href="faq-2.html">FAQ's 2</a></li>
                                                </ul>
                                            </li>
                                            <li><a href="javascript:;">Contact Us<i
                                                        class="fa fa-angle-right"></i></a>
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
                                    <li class="add-mega-menu"><a href="javascript:;">Our Hotel <i
                                                class="fa fa-chevron-down"></i></a>
                                        <ul class="sub-menu add-menu">
                                            <li class="add-menu-left">
                                                <h5 class="menu-adv-title">Our Hotel</h5>
                                                <ul>
                                                    <li><a href="roomlist">Rooms </a></li>
                                                    <li><a href="rooms-details.jsp">Rooms Details</a>
                                                    </li>
                                                    <li><a href="profile.html">Instructor Profile</a>
                                                    </li>
                                                    <li><a href="event.html">Upcoming Event</a></li>
                                                    <li><a href="membership.html">Membership</a></li>
                                                </ul>
                                            </li>
                                            <li class="add-menu-right">
                                                <img src="assets/images/adv/adv.jpg" alt="" />
                                            </li>
                                        </ul>
                                    </li>
                                    <li><a href="javascript:;">Blog <i
                                                class="fa fa-chevron-down"></i></a>
                                        <ul class="sub-menu">
                                            <li><a href="blog-classic-grid.html">Blog Classic</a></li>
                                            <li><a href="blog-classic-sidebar.html">Blog Classic
                                                    Sidebar</a></li>
                                            <li><a href="blog-list-sidebar.html">Blog List Sidebar</a>
                                            </li>
                                            <li><a href="blog-standard-sidebar.html">Blog Standard
                                                    Sidebar</a></li>
                                            <li><a href="blog-details.html">Blog Details</a></li>
                                        </ul>
                                    </li>
                                    <li class="nav-dashboard"><a href="javascript:;">Dashboard <i
                                                class="fa fa-chevron-down"></i></a>
                                        <ul class="sub-menu">
                                            <li><a href="admin/Home">Dashboard</a></li>
                                            <li><a href="admin/add-listing.html">Add Listing</a></li>
                                            <li><a href="admin/bookmark.html">Bookmark</a></li>
                                            <li><a href="admin/roomlist">Rooms</a></li>
                                            <li><a href="admin/review.html">Review</a></li>
                                            <li><a href="admin/user-profile.jsp">User Profile</a></li>
                                            <li><a href="javascript:;">Calendar<i
                                                        class="fa fa-angle-right"></i></a>
                                                <ul class="sub-menu">
                                                    <li><a href="admin/basic-calendar.html">Basic
                                                            Calendar</a></li>
                                                    <li><a href="admin/list-view-calendar.html">List
                                                            View Calendar</a></li>
                                                </ul>
                                            </li>
                                            <li><a href="javascript:;">Mailbox<i
                                                        class="fa fa-angle-right"></i></a>
                                                <ul class="sub-menu">
                                                    <li><a href="admin/mailbox.html">Mailbox</a></li>
                                                    <li><a href="admin/mailbox-compose.html">Compose</a>
                                                    </li>
                                                    <li><a href="admin/mailbox-read.html">Mail Read</a>
                                                    </li>
                                                </ul>
                                            </li>
                                        </ul>
                                    </li>
                                    <li><a href="myrooms"><i class="fa fa-bed"></i> My Booking</a></li>
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


            <c:choose>
                <c:when test="${empty sessionScope.userInfo}">
                    <!-- Guest: form tra cứu -->
                    <div class="guest-lookup-section">
                        <div class="container">
                            <div class="lookup-form-wrapper">
                                <h3 class="lookup-title">Booking Lookup</h3>
                                <form method="get" action="MyBookingServlet" class="lookup-form">
                                    <div class="form-row">
                                        <div class="form-group">
                                            <label>Booking ID</label>
                                            <input type="text" name="bookingID" class="form-control" required>
                                        </div>
                                        <div class="form-group">
                                            <label>Booking Token</label>
                                            <input type="text" name="bookingToken" class="form-control" required>
                                        </div>
                                        <div class="form-group">
                                            <button type="submit" class="btn btn-primary lookup-btn">
                                                <i class="fa fa-search"></i> Lookup Booking
                                            </button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- Guest: bảng booking nếu tra cứu thành công -->
                    <c:if test="${not empty bookings}">
                        <div class="container">
                            <div class="booking-results">
                                <h4 class="results-title">Booking Results</h4>
                                <div class="table-responsive">
                                    <table class="table booking-table">
                                        <thead>
                                            <tr>
                                                <th width="10%">Booking ID</th>
                                                <th width="12%">Booking Date</th>
                                                <th width="12%">Check-in</th>
                                                <th width="12%">Check-out</th>
                                                <th width="8%">Guests</th>
                                                <th width="12%">Total Amount</th>
                                                <th width="10%">Status</th>
                                                <th width="14%">Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="b" items="${bookings}">
                                                <tr>
                                                    <td class="booking-id">#${b.bookingID}</td>
                                                    <td>${b.bookingDate}</td>
                                                    <td>${b.checkInDate}</td>
                                                    <td>${b.checkOutDate}</td>
                                                    <td class="text-center">${b.guestsCount}</td>
                                                    <td class="amount">$${b.totalAmount}</td>
                                                    <td>
                                                        <span class="status-badge status-${fn:toLowerCase(b.status)}">${b.status}</span>
                                                    </td>
                                                    <td>
                                                        <button class="btn btn-info btn-sm viewBookingBtn"
                                                                data-booking-id="${b.bookingID}">
                                                            <i class="fa fa-eye"></i> View
                                                        </button>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </c:if>

                    <!-- Guest: nếu không có booking -->
                    <c:if test="${empty bookings && not empty param.bookingID}">
                        <div class="container">
                            <div class="alert alert-warning no-results">
                                <i class="fa fa-exclamation-triangle"></i>
                                Không tìm thấy booking với thông tin đã cung cấp!
                            </div>
                        </div>
                    </c:if>

                </c:when>
                <c:otherwise>
                    <div class="booking-management-section">
                        <div class="container">
                            <div class="booking-header">
                                <h2 class="page-title">
                                    <i class="fa fa-calendar-check"></i> My Bookings
                                </h2>
                            </div>

                            <!-- Customer: bộ lọc -->
                            <div class="filter-section">
                                <form method="get" action="MyBookingServlet" class="filter-form">
                                    <input type="hidden" name="page" value="1">
                                    <div class="filter-row">
                                        <div class="filter-group">
                                            <label>Status Filter</label>
                                            <select name="statusFilter" class="form-select" >
                                                <option value="">All Status</option>
                                                <option value="Pending" ${statusFilter == 'Pending' ? 'selected' : ''}>Pending</option>
                                                <option value="Upcoming" ${statusFilter == 'Upcoming' ? 'selected' : ''}>Upcoming</option>
                                                <option value="Active" ${statusFilter == 'Active' ? 'selected' : ''}>Active</option>
                                                <option value="Completed" ${statusFilter == 'Completed' ? 'selected' : ''}>Completed</option>
                                                <option value="Cancelled" ${statusFilter == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                                                <option value="Expired" ${statusFilter == 'Expired' ? 'selected' : ''}>Expired</option>
                                            </select>
                                        </div>
                                        <div class="filter-group">
                                            <label>Booking ID</label>
                                            <input type="number" name="searchBookingId" class="form-control"
                                                   placeholder="Enter Booking ID" value="${searchBookingId}">
                                        </div>
                                        <div class="filter-group">
                                            <label>Booking Date (From)</label>
                                            <input type="text" id="bookingDateFrom" name="bookingDateFrom" class="form-control" value="${param.bookingDateFrom}" autocomplete="off">
                                        </div>
                                        <div class="filter-group">
                                            <label>Booking Date (To)</label>
                                            <input type="text" id="bookingDateTo" name="bookingDateTo" class="form-control" value="${param.bookingDateTo}" autocomplete="off">
                                        </div>
                                        <div class="filter-group">
                                            <label>Check-in Date</label>
                                            <input type="text" id="checkinDate" name="checkinDate" class="form-control" value="${param.checkinDate}" autocomplete="off">
                                        </div>
                                        <div class="filter-group">
                                            <label>Check-out Date</label>
                                            <input type="text" id="checkoutDate" name="checkoutDate" class="form-control" value="${param.checkoutDate}" autocomplete="off">
                                        </div>


                                        <div class="filter-group">
                                            <button type="submit" class="btn btn-primary search-btn">
                                                <i class="fa fa-search"></i> Search
                                            </button>
                                        </div>
                                    </div>
                                </form>
                            </div>

                            <!-- Bảng booking -->
                            <c:if test="${not empty bookings}">
                                <div class="booking-results">
                                    <div class="table-responsive">
                                        <table class="table booking-table">
                                            <thead>
                                                <tr>
                                                    <th width="8%">Booking ID</th>
                                                    <th width="12%">Booking Date</th>
                                                    <th width="12%">Expire Time</th>
                                                    <th width="10%">Check-in</th>
                                                    <th width="10%">Check-out</th>
                                                    <th width="6%">Guests</th>
                                                    <th width="10%">Total Amount</th>
                                                    <th width="10%">Status</th>
                                                    <th width="22%">Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="b" items="${bookings}">
                                                    <tr>
                                                        <td class="booking-id">#${b.bookingID}</td>
                                                        <td>${b.bookingDate}</td>
                                                        <td>${b.expiryTime}</td>
                                                        <td>${b.checkInDate}</td>
                                                        <td>${b.checkOutDate}</td>
                                                        <td class="text-center">${b.guestsCount}</td>
                                                        <td class="amount">$${b.totalAmount}</td>
                                                        <td>
                                                            <span class="status-badge status-${fn:toLowerCase(b.status)}">${b.status}</span>
                                                        </td>
                                                        <td class="actions-cell">
                                                            <button class="btn btn-info btn-sm viewBookingBtn"
                                                                    data-booking-id="${b.bookingID}">
                                                                <i class="fa fa-eye"></i> View
                                                            </button>
                                                            <c:if test="${b.status == 'Pending'}">
                                                                <a href="CancelBookingServlet?bookingID=${b.bookingID}"
                                                                   class="btn btn-danger btn-sm cancel-booking-btn"
                                                                   onclick="return confirmCancel();">
                                                                    <i class="fa fa-times"></i> Cancel
                                                                </a>
                                                            </c:if>

                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>

                                    <!-- Pagination -->
                                    <c:if test="${totalPages > 1}">
                                        <nav aria-label="Page navigation" class="pagination-wrapper">
                                            <ul class="pagination">
                                                <c:if test="${currentPage > 1}">
                                                    <li class="page-item">
                                                        <a class="page-link"
                                                           href="MyBookingServlet?page=${currentPage - 1}&statusFilter=${statusFilter}&searchBookingId=${searchBookingId}">
                                                            <i class="fa fa-chevron-left"></i> Previous
                                                        </a>
                                                    </li>
                                                </c:if>

                                                <c:forEach begin="1" end="${totalPages}" var="i">
                                                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                                                        <a class="page-link"
                                                           href="MyBookingServlet?page=${i}&statusFilter=${statusFilter}&searchBookingId=${searchBookingId}">${i}</a>
                                                    </li>
                                                </c:forEach>

                                                <c:if test="${currentPage < totalPages}">
                                                    <li class="page-item">
                                                        <a class="page-link"
                                                           href="MyBookingServlet?page=${currentPage + 1}&statusFilter=${statusFilter}&searchBookingId=${searchBookingId}">
                                                            Next <i class="fa fa-chevron-right"></i>
                                                        </a>
                                                    </li>
                                                </c:if>
                                            </ul>
                                        </nav>
                                    </c:if>
                                </div>
                            </c:if>

                            <!-- Không có booking -->
                            <c:if test="${empty bookings}">
                                <div class="no-bookings">
                                    <div class="no-bookings-content">
                                        <i class="fa fa-calendar-times"></i>
                                        <h4>No Bookings Found</h4>
                                        <p>You don't have any bookings matching the current filters.</p>
                                        <a href="roomlist" class="btn btn-primary">
                                            <i class="fa fa-plus"></i> Make a New Booking
                                        </a>
                                    </div>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>


            <!-- Content END-->
            <!-- Footer ==== -->
            <footer>
                <div class="footer-top">
                    <div class="pt-exebar">
                        <div class="container">
                            <div class="d-flex align-items-stretch">
                                <div class="pt-logo mr-auto">
                                    <a href="Home"><img src="assets/images/logo-white.png" alt="" /></a>
                                </div>
                                <div class="pt-social-link">
                                    <ul class="list-inline m-a0">
                                        <li><a href="#" class="btn-link"><i
                                                    class="fa fa-facebook"></i></a></li>
                                        <li><a href="#" class="btn-link"><i
                                                    class="fa fa-twitter"></i></a></li>
                                        <li><a href="#" class="btn-link"><i
                                                    class="fa fa-linkedin"></i></a></li>
                                        <li><a href="#" class="btn-link"><i
                                                    class="fa fa-google-plus"></i></a></li>
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
                                    <p class="text-capitalize m-b20">Weekly Breaking news analysis and
                                        cutting edge advices on job searching.</p>
                                    <div class="subscribe-form m-b20">
                                        <form class="subscription-form"
                                              action="http://educhamp.themetrades.com/demo/assets/script/mailchamp.php"
                                              method="post">
                                            <div class="ajax-message"></div>
                                            <div class="input-group">
                                                <input name="email" required="required"
                                                       class="form-control"
                                                       placeholder="Your Email Address" type="email">
                                                <span class="input-group-btn">
                                                    <button name="submit" value="Submit" type="submit"
                                                            class="btn"><i
                                                            class="fa fa-arrow-right"></i></button>
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
                                                <li><a
                                                        href="http://educhamp.themetrades.com/admin/Home">Dashboard</a>
                                                </li>
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
                                        <li><a href="assets/images/gallery/pic1.jpg"
                                               class="magnific-anchor"><img
                                                    src="assets/images/gallery/pic1.jpg" alt=""></a>
                                        </li>
                                        <li><a href="assets/images/gallery/pic2.jpg"
                                               class="magnific-anchor"><img
                                                    src="assets/images/gallery/pic2.jpg" alt=""></a>
                                        </li>
                                        <li><a href="assets/images/gallery/pic3.jpg"
                                               class="magnific-anchor"><img
                                                    src="assets/images/gallery/pic3.jpg" alt=""></a>
                                        </li>
                                        <li><a href="assets/images/gallery/pic4.jpg"
                                               class="magnific-anchor"><img
                                                    src="assets/images/gallery/pic4.jpg" alt=""></a>
                                        </li>
                                        <li><a href="assets/images/gallery/pic5.jpg"
                                               class="magnific-anchor"><img
                                                    src="assets/images/gallery/pic5.jpg" alt=""></a>
                                        </li>
                                        <li><a href="assets/images/gallery/pic6.jpg"
                                               class="magnific-anchor"><img
                                                    src="assets/images/gallery/pic6.jpg" alt=""></a>
                                        </li>
                                        <li><a href="assets/images/gallery/pic7.jpg"
                                               class="magnific-anchor"><img
                                                    src="assets/images/gallery/pic7.jpg" alt=""></a>
                                        </li>
                                        <li><a href="assets/images/gallery/pic8.jpg"
                                               class="magnific-anchor"><img
                                                    src="assets/images/gallery/pic8.jpg" alt=""></a>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="footer-bottom">
                    <div class="container">
                        <div class="row">
                            <div class="col-lg-12 col-md-12 col-sm-12 text-center"><a target="_blank"
                                                                                      href="https://www.templateshub.net">Templates Hub</a></div>
                        </div>
                    </div>
                </div>
            </footer>
            <!-- Footer END ==== -->
            <button class="back-to-top fa fa-chevron-up"></button>
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
        <!-- Flatpickr & Validation -->

        <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

        <script
        src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <script>

        </script>

        <script src="assets/js/hotel-cart.js"></script>
        <!-- 📌 Modal Booking Detail -->
        <div class="modal fade" id="bookingDetailModal" tabindex="-1">
            <div class="modal-dialog modal-xl">
                <div class="modal-content">

                    <div class="modal-header">
                        <h5 class="modal-title">Booking Details</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>

                    <div class="modal-body">
                        <!-- Info Booking -->
                        <div id="bookingInfo" class="mb-3"></div>

                        <!-- Rooms -->
                        <h6>Rooms</h6>
                        <div class="table-responsive">
                            <table
                                class="table table-bordered table-striped table-hover text-center align-middle">
                                <thead>
                                    <tr>
                                        <th>Room</th>
                                        <th>Type</th>
                                        <th>Price/Night</th>
                                        <th>Nights</th>
                                        <th>Guests</th>
                                        <th>Subtotal</th>
                                    </tr>
                                </thead>
                                <tbody id="roomsTable"></tbody>
                            </table>
                        </div>
                        <!-- Services -->
                        <h6>Services</h6>
                        <div class="table-responsive">
                            <table class="table table-bordered">
                                <thead>
                                    <tr>
                                        <th>Service</th>
                                        <th>Quantity</th>
                                        <th>Unit</th>
                                        <th>Unit Price</th>
                                        <th>Subtotal</th>
                                    </tr>
                                </thead>
                                <tbody id="servicesTable"></tbody>
                            </table>
                        </div>
                    </div>

                </div>
            </div>
        </div>

        <script>
                                                                       function isValidDateFormat(dateStr) {
                                                                           return /^\d{2}\/\d{2}\/\d{4}$/.test(dateStr);
                                                                       }

                                                                       function parseDate(dateStr) {
                                                                           const parts = dateStr.split('/');
                                                                           return new Date(parts[2], parts[1] - 1, parts[0]);
                                                                       }

                                                                       function validateMyBookingForm() {
                                                                           const from = document.getElementById("bookingDateFrom").value.trim();
                                                                           const to = document.getElementById("bookingDateTo").value.trim();
                                                                           const ci = document.getElementById("checkinDate").value.trim();
                                                                           const co = document.getElementById("checkoutDate").value.trim();

                                                                           for (let d of [from, to, ci, co]) {
                                                                               if (d && !isValidDateFormat(d)) {
                                                                                   Swal.fire("Invalid Date", "Use dd/MM/yyyy format!", "warning");
                                                                                   return false;
                                                                               }
                                                                           }

                                                                           if (ci && co && parseDate(co) <= parseDate(ci)) {
                                                                               Swal.fire("Invalid Check-out", "Check-out must be after check-in!", "warning");
                                                                               return false;
                                                                           }

                                                                           return true;
                                                                       }

                                                                       // Gắn flatpickr
                                                                       ["bookingDateFrom", "bookingDateTo", "checkinDate", "checkoutDate"].forEach(id => {
                                                                           flatpickr("#" + id, {
                                                                               dateFormat: "d/m/Y",
                                                                               allowInput: true
                                                                           });
                                                                       });
        </script>

        <script>
            $(document).ready(function () {
                $('.viewBookingBtn').click(function () {
                    const bookingID = $(this).data('booking-id');

                    $.ajax({
                        url: 'BookingDetailServlet',
                        method: 'GET',
                        data: {bookingID: bookingID},
                        success: function (data) {
                            console.log('Data response:', data);

                            $('#bookingInfo').empty();
                            $('#roomsTable').empty();
                            $('#servicesTable').empty();
                            console.log('CHECK:', data.bookingID);
                            $('#bookingInfo').html('<p><strong>Booking ID:</strong> #' + data.bookingID + '</p>');




                            if (data.bookingDetails && Array.isArray(data.bookingDetails)) {
                                data.bookingDetails.forEach(d => {
                                    const pricePerNight = Number(d.pricePerNight || 0).toLocaleString();
                                    const nights = d.nights !== undefined && d.nights !== null ? d.nights : '-';
                                    const subTotal = Number(d.subTotal || 0).toLocaleString();
                                    $('#roomsTable').append(
                                            '<tr>'
                                            + '<td>' + (typeof d.roomID !== 'undefined' && d.roomID !== null ? d.roomID : '-') + '</td>'
                                            + '<td>' + (typeof d.roomTypeName !== 'undefined' && d.roomTypeName !== null ? d.roomTypeName : '-') + '</td>'
                                            + '<td>' + pricePerNight + '</td>'
                                            + '<td>' + nights + '</td>'
                                            + '<td>' + (typeof d.guestsCount !== 'undefined' && d.guestsCount !== null ? d.guestsCount : '-') + '</td>'
                                            + '<td>' + subTotal + '</td>'
                                            + '</tr>'
                                            );


                                });
                            }

                            if (data.serviceUsages && Array.isArray(data.serviceUsages)) {
                                data.serviceUsages.forEach(s => {
                                    const unitPrice = Number(s.unitPrice || 0).toLocaleString();
                                    const subTotal = Number(s.subTotal || 0).toLocaleString();

                                    $('#servicesTable').append(
                                            '<tr>'
                                            + '<td>' + (typeof s.serviceName !== 'undefined' && s.serviceName !== null ? s.serviceName : '-') + '</td>'
                                            + '<td>' + (typeof s.quantity !== 'undefined' && s.quantity !== null ? s.quantity : '-') + '</td>'
                                            + '<td>' + (typeof s.unit !== 'undefined' && s.unit !== null ? s.unit : '-') + '</td>'
                                            + '<td>$' + unitPrice + '</td>'
                                            + '<td>$' + subTotal + '</td>'
                                            + '</tr>'
                                            );

                                });
                            }
                            console.log('INFO DIV:', $('#bookingInfo').html());
                            $('#bookingDetailModal').modal('show');
                        },
                        error: function () {
                            alert('Failed to load booking detail!');
                        }
                    });
                });
            });
        </script>


        <script>
            function confirmCancel() {
                return confirm('Are you sure you want to cancel this booking?');
            }
        </script>

    </body>

</html>