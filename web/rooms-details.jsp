<%-- 
    Document   : rooms-details
    Created on : Jun 3, 2025, 2:31:47 PM
    Author     : Arcueid
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <!-- META ============================================= -->
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="keywords" content="" />
        <meta name="author" content="" />
        <meta name="robots" content="" />
        <meta name="description" content="HoangNam Hotel" />
        <meta property="og:title" content="HoangNam Hotel" />
        <meta property="og:description" content="HoangNam Hotel" />
        <meta property="og:image" content="" />
        <meta name="format-detection" content="telephone=no">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!-- FAVICONS ICON ============================================= -->
        <link rel="icon" href="assets/images/favicon1.ico" type="image/x-icon" />
        <link rel="shortcut icon" type="image/x-icon" href="assets/images/favicon1.png" />

        <!-- PAGE TITLE HERE ============================================= -->
        <title>HoangNam Hotel</title>

        <!-- CSS ============================================= -->
        <link href="https://cdn.jsdelivr.net/npm/remixicon/fonts/remixicon.css" rel="stylesheet">
        <script src="https://unpkg.com/@phosphor-icons/web"></script>
        <link rel="stylesheet" type="text/css" href="assets/css/assets.css">
        <link rel="stylesheet" type="text/css" href="assets/css/typography.css">
        <link rel="stylesheet" type="text/css" href="assets/css/shortcodes/shortcodes.css">
        <link rel="stylesheet" type="text/css" href="assets/css/style.css">
        <link class="skin" rel="stylesheet" type="text/css" href="assets/css/color/color-1.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <link rel="stylesheet" href="assets/css/listRoom.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
        <style>
            body, h1, h2, h3, h4, h5, h6, p, ul, li, .ttr-post-title h2 {
                font-family: 'Roboto', sans-serif !important;
            }
            .available-rooms {
                text-align: center;
                margin: 15px 0;
            }

            .available-rooms h5 {
                font-size: 16px;
                font-weight: 500;
                margin: 0;
            }

            .available-rooms .text-success {
                color: #28a745;
            }

            .available-rooms .text-danger {
                color: #dc3545;
            }

            /* === MODAL WRAPPER === */
            .modal {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.5);
                z-index: 99999 !important;
                overflow-y: auto;
                animation: fadeIn 0.3s ease;
                display: none;
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                }
                to {
                    opacity: 1;
                }
            }

            /* === MODAL CONTENT === */
            .modal-content {
                margin: 40px auto;
                padding: 20px;
                background: #fff;
                width: 100%;
                max-width: 1280px;
                border-radius: 20px !important;
                box-shadow: 0 8px 30px rgba(0,0,0,0.35);
                position: relative;
                max-height: 92vh;
                overflow: hidden;
                display: flex;
                flex-direction: column;
            }

            /* === N�T ?�NG C?I THI?N === */
            .close-btn {
                position: absolute;
                top: 20px;
                left: 20px;
                background: rgba(255, 255, 255, 0.95);
                padding: 10px;
                border-radius: 50%;
                border: 1px solid #e0e0e0;
                cursor: pointer;
                z-index: 999;
                display: flex;
                align-items: center;
                justify-content: center;
                transition: all 0.3s ease;
                width: 40px;
                height: 40px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            }

            .close-btn i {
                font-size: 16px;
                color: #666;
                transition: all 0.3s ease;
            }

            .close-btn:hover {
                background: #f8f9fa;
                border-color: #8b5cf6;
                transform: scale(1.05);
                box-shadow: 0 4px 12px rgba(139, 92, 246, 0.2);
            }

            .close-btn:hover i {
                color: #8b5cf6;
                transform: rotate(90deg);
            }

            /* === CATEGORY TABS C?I THI?N === */
            .category-tabs {
                flex-shrink: 0;
                position: sticky;
                top: 0;
                z-index: 10;
                background: #f8f9fa;
                padding: 15px 20px 15px 70px;
                margin-bottom: 10px;
                border-bottom: 1px solid #e9ecef;
                overflow-x: auto;
                display: flex;
                gap: 12px;
                border-radius: 20px 20px 0 0;
            }

            .category-tabs button {
                padding: 10px 18px;
                white-space: nowrap;
                border: 1px solid #ddd;
                border-radius: 25px;
                background: #fff;
                font-size: 14px;
                color: #666;
                cursor: pointer;
                flex-shrink: 0;
                transition: all 0.3s ease;
                font-weight: 500;
                text-transform: capitalize;
                box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            }

            .category-tabs button.active {
                background: linear-gradient(135deg, #8b5cf6, #a855f7);
                color: #fff;
                border-color: #8b5cf6;
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(139, 92, 246, 0.3);
                font-weight: 600;
            }

            .category-tabs button:hover:not(.active) {
                background: #f3f4f6;
                border-color: #8b5cf6;
                color: #8b5cf6;
                transform: translateY(-1px);
                box-shadow: 0 2px 8px rgba(139, 92, 246, 0.15);
            }

            /* === SCROLLABLE IMAGE AREA === */
            .gallery-scroll {
                overflow-y: auto;
                flex-grow: 1;
                padding: 0 20px 20px 20px;
            }

            .gallery-grid {
                display: grid;
                grid-template-columns: repeat(2, 1fr);
                gap: 24px;
            }

            .gallery-item {
                background: none;
                box-shadow: none;
                overflow: visible;
            }

            .gallery-item img {
                width: 100%;
                max-height: 100%;
                height: auto;
                object-fit: contain;
                display: block;
                margin: 0 auto;
                border-radius: 12px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
                transition: all 0.3s ease;
            }

            .gallery-item img[style*="display: none"] + .image-caption {
                display: none;
            }

            .gallery-item:hover img {
                transform: translateY(-3px);
                box-shadow: 0 8px 25px rgba(0,0,0,0.15);
            }

            .image-caption {
                font-size: 16px;
                color: #333;
                text-align: center;
                padding: 12px 0 0 0;
                margin: 0;
                font-weight: 600;
                text-transform: capitalize;
            }

            .no-data {
                text-align: center;
                color: #666;
                margin: 20px 0;
                font-size: 16px;
            }

            /* === IMAGE GALLERY OUTSIDE MODAL === */
            .image-gallery-row {
                display: flex;
                gap: 16px;
                align-items: stretch;
                flex-wrap: wrap;
                margin-bottom: 24px;
            }

            .main-photo-box {
                flex: 5;
                display: flex;
                cursor: pointer;
            }

            .main-photo-box img {
                width: 100%;
                height: 300px;
                object-fit: cover;
                border-radius: 12px;
            }

            .thumb-2x2-box {
                flex: 4;
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 8px;
            }

            .thumb-2x2-box img {
                width: 100%;
                height: 140px;
                object-fit: cover;
                border-radius: 8px;
                cursor: pointer;
            }

            @media (max-width: 768px) {
                .gallery-grid {
                    grid-template-columns: 1fr;
                }

                .category-tabs {
                    padding: 12px 15px 12px 50px;
                    gap: 8px;
                }

                .category-tabs button {
                    padding: 8px 14px;
                    font-size: 13px;
                }

                .image-gallery-row {
                    flex-direction: column;
                }

                .main-photo-box, .thumb-2x2-box {
                    flex: 1;
                }

                .main-photo-box img {
                    height: 200px;
                }

                .thumb-2x2-box img {
                    height: 100px;
                }
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
                                    <c:choose>
                                        <c:when test="${sessionScope.account != null}">
                                            <li class="nav-item">
                                                <a class="nav-link" href="${pageContext.request.contextPath}/user-profile">Hello, ${sessionScope.account.username}</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-link" href="Logout">Logout</a>
                                            </li>
                                        </c:when>
                                        <c:otherwise>
                                            <li class="nav-item">
                                                <a class="nav-link" href="login.jsp">Login</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-link" href="register.jsp">Register</a>
                                            </li>
                                        </c:otherwise>
                                    </c:choose>
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
                                                    <li><a href="contact-1.html">Contact Us 1</a></li>
                                                    <li><a href="contact-2.html">Contact Us 2</a></li>
                                                </ul>
                                            </li>
                                            <li><a href="portfolio.html">Portfolio</a></li>
                                            <li><a href="profile.html">Profile</a></li>
                                            <li><a href="membership.html">Membership</a></li>
                                            <li><a href="error-404.html">404 Page</a></li>
                                        </ul>
                                    </li>
                                    <li class="add-mega-menu"><a href="javascript:;">Our hotel <i class="fa fa-chevron-down"></i></a>
                                        <ul class="sub-menu add-menu">
                                            <li class="add-menu-left">
                                                <h5 class="menu-adv-title">Our hotel</h5>
                                                <ul>
                                                    <li><a href="roomlist">Rooms </a></li>
                                                    <li><a href="rooms-details.html">Rooms Details</a></li>
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
                                            <li><a href="admin/teacher-profile.html">Teacher Profile</a></li>
                                            <li><a href="${pageContext.request.contextPath}/user-profile">User Profile</a></li>
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
            </header>
            <!-- header END ==== -->
            <div class="search-form-container">
                <form method="get" action="FindAvailableRoomsServlet" class="modern-search-form" onsubmit="return validateForm()">
                    <div class="search-row">
                        <div class="search-field">
                            <label><i class="fas fa-calendar-check"></i> Ng�y nh?n ph�ng</label>
                            <input type="text" id="checkin" name="checkin" placeholder="Ch?n ng�y" value="${param.checkin}" required>
                        </div>
                        <div class="search-field">
                            <label><i class="fas fa-calendar-times"></i> Ng�y tr? ph�ng</label>
                            <input type="text" id="checkout" name="checkout" placeholder="Ch?n ng�y" value="${param.checkout}" required>
                        </div>
                        <div class="search-field">
                            <label><i class="fas fa-users"></i> S? kh�ch</label>
                            <input type="number" id="guests" name="guests" min="1" value="${param.guests}" required>
                        </div>
                        <div class="search-field">
                            <button type="submit" class="search-btn">
                                <i class="fas fa-search"></i>
                                T�m ph�ng
                            </button>
                        </div>
                    </div>
                </form>
            </div>
            <!-- Content -->
            <div class="page-content bg-white">
                <!-- inner page banner -->
                <div class="page-banner ovbl-dark" style="background-image:url(assets/images/banner/banner2.jpg);">
                    <div class="container">
                        <div class="page-banner-entry">
                            <h1 class="text-white">Rooms Details</h1>
                        </div>
                    </div>
                </div>
                <!-- Breadcrumb row -->
                <div class="breadcrumb-row">
                    <div class="container">
                        <ul class="list-inline">
                            <li><a href="Home">Home</a></li>
                            <li><a href="roomlist">Our Rooms</a></li>
                            <li>Rooms Details</li>
                        </ul>   
                    </div>
                </div>
                <!-- Breadcrumb row END -->

                <!-- inner page banner END -->
                <div class="content-block">
                    <!-- About Us -->
                    <div class="section-area section-sp1">
                        <div class="container">
                            <div class="row d-flex flex-row-reverse">
                                <div class="col-lg-3 col-md-4 col-sm-12 m-b30">
                                    <div class="course-detail-bx">
                                        <div class="course-price">
                                            <h4 class="price">$${roomType.basePrice}</h4>
                                        </div>	
                                        <div class="course-buy-now text-center">
                                            <a href="#" class="btn radius-xl text-uppercase">BOOK NOW</a>
                                        </div>
                                        <div class="teacher-bx">
                                            <div class="available-rooms">
                                                <h5 class="availability">
                                                    <h5 class="availability" style="font-size: 20px; font-weight: bold;">
                                                        <c:choose>
                                                            <c:when test="${availableRooms != null and availableRooms > 0}">
                                                                <span class="text-success">${availableRooms} ph�ng c�n tr?ng</span>
                                                            </c:when>
                                                            <c:when test="${availableRooms == 0 or empty availableRooms}">
                                                                <span class="text-danger">H?t ph�ng</span>
                                                            </c:when>
                                                        </c:choose>
                                                    </h5>
                                            </div>
                                        </div>
                                        <div class="cours-more-info">
                                            <div class="review">
                                                <span>3 Review</span>
                                                <ul class="cours-star">
                                                    <li class="active"><i class="fa fa-star"></i></li>
                                                    <li class="active"><i class="fa fa-star"></i></li>
                                                    <li class="active"><i class="fa fa-star"></i></li>
                                                    <li><i class="fa fa-star"></i></li>
                                                    <li><i class="fa fa-star"></i></li>
                                                </ul>
                                            </div>
                                            <div class="categories">
                                                <span> Room Type</span>
                                                <h6 class="text-primary"> ${room.roomType.name}</h6>
                                            </div>
                                        </div>
                                        <div class="course-info-list scroll-page">
                                            <ul class="navbar">
                                                <li><a class="nav-link" href="#overview"><i class="ti-zip"></i>Overview</a></li>
                                                <li><a class="nav-link" href="#pictures"><i class="ti-bookmark-alt"></i>pictures</a></li>
                                                <li><a class="nav-link" href="#instructor"><i class="ti-user"></i>Instructor</a></li>
                                                <li><a class="nav-link" href="#reviews"><i class="ti-comments"></i>Reviews</a></li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-lg-9 col-md-8 col-sm-12">
                                    <div class="rooms-post">
                                        <div class="ttr-post-media media-effect">
                                            <a>
                                                <img src="${fn:escapeXml(roomType.imageUrl)}" alt="${fn:escapeXml(roomType.name)}" onerror="this.style.display='none'" />
                                            </a>
                                        </div>
                                        <div class="ttr-post-info">
                                            <div class="ttr-post-title">
                                                <h2 class="post-title">${fn:escapeXml(roomType.name)}</h2>
                                            </div>
                                            <div class="ttr-post-text">
                                                <p>${fn:escapeXml(roomType.roomDetail)}</p>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="courese-overview" id="overview">
                                        <h4>Overview</h4>
                                        <div class="row">
                                            <!-- C?t tr�i: Ti?n �ch -->
                                            <div class="col-md-12 col-lg-4">
                                                <ul class="course-features">
                                                    <c:choose>
                                                        <c:when test="${not empty amenities}">
                                                            <c:forEach var="a" items="${amenities}">
                                                                <li><i class="${fn:escapeXml(a.icon)}"></i> ${fn:escapeXml(a.amenityName)}</li>
                                                                </c:forEach>
                                                            </c:when>
                                                            <c:otherwise>
                                                            <li class="no-data">Kh�ng c� ti?n �ch n�o ?? hi?n th?.</li>
                                                            </c:otherwise>
                                                        </c:choose>
                                                </ul>
                                            </div>

                                            <!-- C?t ph?i: Policy, Info, FAQ -->
                                            <div class="col-md-12 col-lg-8">
                                                <h5 class="m-b5">Ch�nh s�ch</h5>
                                                <ul>
                                                    <li>Tr? ph�ng: Tr??c 12:00</li>
                                                    <li>C� th? nh?n/tr? ph�ng s?m ho?c mu?n, t�y t�nh h�nh th?c t? v� c� th? thu ph�.</li>
                                                    <li>Tu?i t?i thi?u ?? nh?n ph�ng: 18 tu?i.</li>
                                                    <li>Kh�ng cho ph�p mang v?t nu�i (tr? v?t nu�i h? tr? ng??i khuy?t t?t).</li>
                                                    <li>Kh�ch ch?a k?t h�n c� th? kh�ng ???c l?u tr� chung ph�ng theo quy ??nh ??a ph??ng.</li>
                                                    <li>Kh�ng ???c mang ?? ?n/th?c u?ng b�n ngo�i v�o khu�n vi�n kh�ch s?n.</li>                                                
                                                </ul>

                                                <h5 class="m-b5">Th�ng tin quan tr?ng</h5>
                                                <ul>
                                                    <li>C� d?ch v? ??a ?�n s�n bay, c?n ??t tr??c �t nh?t 48 gi? (ph�: 270,000 VND/ng??i/l??t).</li>
                                                    <li>Ph? ph� b?a s�ng buffet: 345,000 VND (ng??i l?n), 172,500 VND (tr? em).</li>
                                                    <li>Ph� gi??ng ph?: 900,000 VND/?�m.</li>
                                                    <li>C?n mang theo gi?y t? t�y th�n v� ??t c?c b?ng ti?n m?t/th? khi nh?n ph�ng.</li>
                                                    <li>Kh�ch s?n c� kh�ng gian ngo�i tr?i (ban c�ng, s�n th??ng) ? kh�ng ph� h?p v?i tr? nh? n?u kh�ng gi�m s�t.</li>
                                                    <li>Kh�ch d??i 18 tu?i ???c s? d?ng spa d??i s? gi�m s�t c?a ng??i l?n.</li>
                                                    <li>Ch?p nh?n thanh to�n b?ng ti?n m?t, th? ghi n? v� th? t�n d?ng.</li>
                                                </ul>

                                                <h5 class="m-b5">C�u h?i th??ng g?p (FAQ)</h5>
                                                <ul class="list-checked primary">
                                                    <li><strong>Kh�ch s?n Ho�ng Nam c� h? b?i kh�ng?</strong><br/>C�, kh�ch s?n c� h? b?i ph?c v? kh�ch l?u tr�.</li>
                                                    <li><strong>Kh�ch s?n c� cho ph�p mang theo v?t nu�i kh�ng?</strong><br/>Kh�ng, kh�ch s?n kh�ng cho ph�p v?t nu�i.</li>
                                                    <li><strong>Ph� ??u xe l� bao nhi�u?</strong><br/>Vui l�ng li�n h? tr?c ti?p ?? bi?t chi ti?t.</li>
                                                    <li><strong>Gi? nh?n ph�ng t?i kh�ch s?n Ho�ng Nam?</strong><br/>T? 15:00 m?i ng�y.</li>
                                                    <li><strong>Gi? tr? ph�ng?</strong><br/>Tr??c 12:00 tr?a.</li>
                                                    <li><strong>Kh�ch s?n c� d?ch v? ??a ?�n s�n bay kh�ng?</strong><br/>C�, v?i ph? ph� v� c?n ??t tr??c �t nh?t 48 gi?.</li>
                                                    <li><strong>Kh�ch s?n Ho�ng Nam t?a l?c ? ?�u?</strong><br/>Kh�ch s?n n?m t?i trung t�m th�nh ph?, g?n bi?n v� c�c ?i?m tham quan n?i b?t.</li>
                                                </ul>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Ti�u ?? gallery -->
                                    <div class="photo-gallery-title" id="pictures">
                                        <h4>Pictures</h4>
                                        <div class="image-gallery-row">
                                            <div class="main-photo-box">
                                                <c:choose>
                                                    <c:when test="${not empty images and not empty images[0].imageUrl}">
                                                        <img src="${fn:escapeXml(images[0].imageUrl)}"
                                                             alt="?nh ch�nh c?a ${fn:escapeXml(roomType.name)}"
                                                             onclick="openGallery('all')"
                                                             loading="lazy"
                                                             onerror="this.style.display='none'" />
                                                    </c:when>
                                                    <c:otherwise>
                                                        <p class="no-data">Kh�ng c� ?nh ch�nh ?? hi?n th?.</p>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="thumb-2x2-box">
                                                <c:choose>
                                                    <c:when test="${not empty images and fn:length(images) > 1}">
                                                        <c:forEach var="img" items="${images}" begin="1" end="4">
                                                            <img src="${fn:escapeXml(img.imageUrl)}"
                                                                 alt="${not empty img.categoriesAsString ? fn:escapeXml(img.categoriesAsString) : '?nh ph�ng'}"
                                                                 onclick="openGallery('${not empty img.categoriesAsString ? fn:toLowerCase(fn:escapeXml(img.categoriesAsString)) : 'uncategorized'})"
                                                                 loading="lazy"
                                                                 onerror="this.style.display='none'" />
                                                        </c:forEach>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <p class="no-data">Kh�ng c� ?nh ph? ?? hi?n th?.</p>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Modal gallery popup -->
                                    <div id="galleryModal" class="modal" aria-hidden="true">
                                        <div class="modal-content">
                                            <span class="close-btn" onclick="closeGallery()">
                                                <i class="ti-control-backward"></i>
                                            </span>
                                            <div class="category-tabs">
                                                <button class="tab-btn active" data-category="all" onclick="filterCategory('all', this)" aria-pressed="true">T?t c?</button>
                                                <c:choose>
                                                    <c:when test="${not empty categories}">
                                                        <c:forEach var="category" items="${categories}">
                                                            <button class="tab-btn" 
                                                                    data-category="${fn:toLowerCase(fn:escapeXml(category))}"
                                                                    onclick="filterCategory('${fn:toLowerCase(fn:escapeXml(category))}', this)"
                                                                    aria-pressed="false">${fn:escapeXml(category)}</button>
                                                        </c:forEach>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <p class="no-data">Kh�ng c� danh m?c n�o ?? hi?n th?.</p>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="gallery-scroll" id="galleryImages">
                                                <div class="gallery-grid">
                                                    <c:choose>
                                                        <c:when test="${not empty images}">
                                                            <c:forEach var="img" items="${images}">
                                                                <div class="gallery-item" 
                                                                     data-category="${not empty img.categoriesAsString ? fn:toLowerCase(fn:escapeXml(img.categoriesAsString)) : 'uncategorized'}">
                                                                    <img src="${fn:escapeXml(img.imageUrl)}" 
                                                                         alt="${not empty img.categoriesAsString ? fn:escapeXml(img.categoriesAsString) : '?nh ph�ng'}"
                                                                         loading="lazy"
                                                                         onerror="this.style.display='none'" />
                                                                    <p class="image-caption">${not empty img.categoriesAsString ? fn:escapeXml(img.categoriesAsString) : 'Kh�ng x�c ??nh'}</p>
                                                                </div>
                                                            </c:forEach>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <p class="no-data">Kh�ng c� ?nh n�o ?? hi?n th?.</p>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- 🔽 BẮT ĐẦU BLOCK FEEDBACK -->
                                    <div class="section" id="instructor">
                                        <h4>Feedback</h4>
                                        <div class="review-bx">

                                            <!-- ✅ THÔNG BÁO LỖI nếu người dùng chưa đặt phòng mà cố gửi đánh giá -->
                                            <c:if test="${param.error == 'unauthorized'}">
                                                <p class="text-danger mt-2">⚠️ Bạn cần từng đặt loại phòng này mới có thể gửi đánh giá.</p>
                                            </c:if>

                                            <!-- ✅ FORM GỬI ĐÁNH GIÁ: luôn hiển thị nếu đã đăng nhập -->
                                            <c:if test="${sessionScope.user != null}">
                                                <div class="submit-feedback-box mt-4">
                                                    <h5>Gửi đánh giá của bạn</h5>
                                                    <form action="submit-feedback" method="post" class="feedback-form">
                                                        <input type="hidden" name="roomTypeID" value="${roomType.roomTypeID}" />
                                                        <input type="hidden" name="bookingID" value="${bookingID}" />

                                                        <div class="form-group">
                                                            <label>Chọn số sao:</label>
                                                            <select name="rating" class="form-control" required>
                                                                <option value="5">★★★★★ - Tuyệt vời</option>
                                                                <option value="4">★★★★ - Tốt</option>
                                                                <option value="3">★★★ - Trung bình</option>
                                                                <option value="2">★★ - Kém</option>
                                                                <option value="1">★ - Rất tệ</option>
                                                            </select>
                                                        </div>

                                                        <div class="form-group">
                                                            <label>Bình luận:</label>
                                                            <textarea name="comment" class="form-control" rows="4" required placeholder="Nhập cảm nhận của bạn..."></textarea>
                                                        </div>

                                                        <div class="form-group">
                                                            <p>Thông tin hiển thị kèm đánh giá:</p>
                                                            <label><input type="checkbox" name="showEmail" checked> Email</label>
                                                            <label><input type="checkbox" name="showFacebook" checked> Facebook</label>
                                                            <label><input type="checkbox" name="showInstagram" checked> Instagram</label>
                                                        </div>

                                                        <button type="submit" class="btn btn-primary">Gửi đánh giá</button>
                                                    </form>
                                                </div>
                                            </c:if>

                                            <c:if test="${sessionScope.user == null}">
                                                <p class="text-muted mt-3">Vui lòng <a href="login.jsp">đăng nhập</a> để gửi đánh giá.</p>
                                            </c:if>

                                            <!-- ✅ DANH SÁCH FEEDBACK -->
                                            <hr/>
                                            <c:choose>
                                                <c:when test="${not empty feedbacks}">
                                                    <c:forEach var="fb" items="${feedbacks}">
                                                        <div class="instructor-bx m-b30">
                                                            <div class="instructor-info">
                                                                <h6>${empty fb.fullName ? 'Ẩn danh' : fn:escapeXml(fb.fullName)}</h6>

                                                                <ul class="cours-star list-inline m-tb10">
                                                                    <c:forEach var="i" begin="1" end="5">
                                                                        <li class="${i <= fb.rating ? 'active' : ''}"><i class="fa fa-star"></i></li>
                                                                        </c:forEach>
                                                                </ul>

                                                                <p class="m-b5">${empty fb.comment ? 'Không có bình luận' : fn:escapeXml(fb.comment)}</p>

                                                                <div class="m-tb5">
                                                                    <c:if test="${fb.showEmail}">
                                                                        <i class="fa fa-envelope"></i> ${empty fb.email ? 'Ẩn' : fn:escapeXml(fb.email)}<br/>
                                                                    </c:if>
                                                                    <c:if test="${fb.showFacebook}">
                                                                        <i class="fa fa-facebook"></i> ${empty fb.facebook ? 'Ẩn' : fn:escapeXml(fb.facebook)}<br/>
                                                                    </c:if>
                                                                    <c:if test="${fb.showInstagram}">
                                                                        <i class="fa fa-instagram"></i> ${empty fb.instagram ? 'Ẩn' : fn:escapeXml(fb.instagram)}<br/>
                                                                    </c:if>
                                                                </div>

                                                                <small class="text-muted">
                                                                    <c:choose>
                                                                        <c:when test="${not empty fb.feedbackDate}">
                                                                            <fmt:formatDate value="${fb.feedbackDate}" pattern="dd/MM/yyyy HH:mm" />
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="text-warning">Ngày không xác định</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </small>
                                                            </div>
                                                        </div>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise>
                                                    <p class="text-muted">Phòng này chưa có đánh giá nào.</p>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    <!-- 🔼 KẾT THÚC BLOCK FEEDBACK -->


                                    <div class="" id="reviews">
                                        <h4>Reviews</h4>
                                        <div class="review-bx">
                                            <div class="all-review">
                                                <h2 class="rating-type">3</h2>
                                                <ul class="cours-star">
                                                    <li class="active"><i class="fa fa-star"></i></li>
                                                    <li class="active"><i class="fa fa-star"></i></li>
                                                    <li class="active"><i class="fa fa-star"></i></li>
                                                    <li><i class="fa fa-star"></i></li>
                                                    <li><i class="fa fa-star"></i></li>
                                                </ul>
                                                <span>3 Rating</span>
                                            </div>
                                            <div class="review-bar">
                                                <div class="bar-bx">
                                                    <div class="side">
                                                        <div>5 star</div>
                                                    </div>
                                                    <div class="middle">
                                                        <div class="bar-container">
                                                            <div class="bar-5" style="width:90%;"></div>
                                                        </div>
                                                    </div>
                                                    <div class="side right">
                                                        <div>150</div>
                                                    </div>
                                                </div>
                                                <div class="bar-bx">
                                                    <div class="side">
                                                        <div>4 star</div>
                                                    </div>
                                                    <div class="middle">
                                                        <div class="bar-container">
                                                            <div class="bar-5" style="width:70%;"></div>
                                                        </div>
                                                    </div>
                                                    <div class="side right">
                                                        <div>140</div>
                                                    </div>
                                                </div>
                                                <div class="bar-bx">
                                                    <div class="side">
                                                        <div>3 star</div>
                                                    </div>
                                                    <div class="middle">
                                                        <div class="bar-container">
                                                            <div class="bar-5" style="width:50%;"></div>
                                                        </div>
                                                    </div>
                                                    <div class="side right">
                                                        <div>120</div>
                                                    </div>
                                                </div>
                                                <div class="bar-bx">
                                                    <div class="side">
                                                        <div>2 star</div>
                                                    </div>
                                                    <div class="middle">
                                                        <div class="bar-container">
                                                            <div class="bar-5" style="width:40%;"></div>
                                                        </div>
                                                    </div>
                                                    <div class="side right">
                                                        <div>110</div>
                                                    </div>
                                                </div>
                                                <div class="bar-bx">
                                                    <div class="side">
                                                        <div>1 star</div>
                                                    </div>
                                                    <div class="middle">
                                                        <div class="bar-container">
                                                            <div class="bar-5" style="width:20%;"></div>
                                                        </div>
                                                    </div>
                                                    <div class="side right">
                                                        <div>80</div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- contact area END -->
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
                                                    <li><a href="rooms-details.html">Details</a></li>
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
            <script src="assets/js/jquery.scroller.js"></script>
            <script src="assets/js/functions.js"></script>
            <script src="assets/js/contact.js"></script>
            <script src="assets/vendors/switcher/switcher.js"></script>
            <script src="assets/js/hotel-cart.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

            <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
            <script>
                                                                        const checkinRaw = "${param.checkin}";
                                                                        flatpickr("#checkin", {
                                                                            dateFormat: "d/m/Y",
                                                                            defaultDate: checkinRaw ? new Date(checkinRaw) : null
                                                                        });


                                                                        const checkoutRaw = "${param.checkout}";
                                                                        flatpickr("#checkout", {
                                                                            dateFormat: "d/m/Y",
                                                                            defaultDate: checkoutRaw ? new Date(checkoutRaw) : null
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
                        alert('? Ng�y tr? ph�ng ph?i sau ng�y nh?n ph�ng.');
                        checkoutInput.value = '';
                    }
                }

                function validateForm() {
                    const checkin = parseDate(checkinInput.value);
                    const checkout = parseDate(checkoutInput.value);
                    if (checkout <= checkin) {
                        alert('? Ng�y tr? ph�ng ph?i sau ng�y nh?n ph�ng.');
                        return false;
                    }
                    return true;
                }
            </script>
            <script>
                // Initialize: Hide modal on page load
                document.addEventListener('DOMContentLoaded', () => {
                    const modal = document.getElementById("galleryModal");
                    if (modal) {
                        modal.style.display = "none";
                        modal.setAttribute('aria-hidden', 'true');
                    }
                });

                function filterCategory(cat, button) {
                    console.log("Filtering category:", cat);
                    const tabs = document.querySelectorAll(".category-tabs button");
                    const items = document.querySelectorAll("#galleryImages .gallery-item");

                    if (!items.length) {
                        console.warn("No gallery items found.");
                        return;
                    }

                    tabs.forEach(tab => {
                        tab.classList.remove("active");
                        tab.setAttribute('aria-pressed', 'false');
                    });

                    if (button) {
                        button.classList.add("active");
                        button.setAttribute('aria-pressed', 'true');
                    }

                    items.forEach(item => {
                        const itemCategories = (item.getAttribute('data-category') || 'uncategorized').split(',').map(c => c.trim()).filter(c => c);
                        console.log("Item categories:", itemCategories);
                        item.style.display = (cat === 'all' || itemCategories.includes(cat)) ? 'block' : 'none';
                    });
                }

                function openGallery(category) {
                    const modal = document.getElementById("galleryModal");
                    if (!modal) {
                        console.error("Modal element not found!");
                        return;
                    }
                    modal.style.display = "block";
                    modal.setAttribute('aria-hidden', 'false');
                    console.log("Opening modal with category:", category);

                    let button = document.querySelector(`.category-tabs button[data-category="${category}"]`);
                    if (!button) {
                        console.warn(`Category "${category}" not found, falling back to "all"`);
                        button = document.querySelector(`.category-tabs button[data-category="all"]`);
                        category = "all";
                    }

                    if (!button) {
                        console.error("No category buttons found in the gallery.");
                        return;
                    }

                    filterCategory(category, button);

                    setTimeout(() => {
                        document.addEventListener('click', handleClickOutside);
                    }, 0);
                    document.addEventListener('keydown', handleKeyboard);
                }

                function closeGallery() {
                    const modal = document.getElementById("galleryModal");
                    if (modal) {
                        modal.style.display = "none";
                        modal.setAttribute('aria-hidden', 'true');
                    }
                    document.removeEventListener('click', handleClickOutside);
                    document.removeEventListener('keydown', handleKeyboard);
                }

                function handleClickOutside(event) {
                    const modalContent = document.querySelector("#galleryModal .modal-content");
                    if (modalContent && !modalContent.contains(event.target)) {
                        closeGallery();
                    }
                }

                function handleKeyboard(event) {
                    if (event.key === "Escape") {
                        closeGallery();
                    }
                }
            </script>
    </body>
</html>