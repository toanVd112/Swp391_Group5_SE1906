<!DOCTYPE html>
<html lang="en">
    <%@page contentType="text/html" pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
    
    <head>

        <!-- META ============================================= -->
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="keywords" content="" />
        <meta name="author" content="" />
        <meta name="robots" content="" />

        <!-- DESCRIPTION -->
        <meta name="description" content="HoangNam Hotel" />

        <!-- OG -->
        <meta property="og:title" content="HoangNam Hotel" />
        <meta property="og:description" content="HoangNam Hotel" />
        <meta property="og:image" content="" />
        <meta name="format-detection" content="telephone=no">

        <!-- FAVICON1S ICON ============================================= -->
        <link rel="icon" href="assets/images/favicon1.ico" type="image/x-icon" />
        <link rel="shortcut icon" type="image/x-icon" href="assets/images/favicon1.png" />

        <!-- PAGE TITLE HERE ============================================= -->
        <title>HoangNam Hotel </title>

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
        <style>
            .feedback-card {
                background: white;
                border-radius: 12px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                margin-bottom: 20px;
                overflow: hidden;
                transition: transform 0.2s ease;
            }

            .feedback-card:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 15px rgba(0, 0, 0, 0.15);
            }

            .feedback-header {
                background: linear-gradient(135deg, #8b5cf6, #a855f7);
                color: white;
                padding: 20px;
            }

            .feedback-body {
                padding: 20px;
            }

            .rating-stars {
                display: flex;
                gap: 3px;
                margin: 10px 0;
            }

            .rating-stars .star {
                font-size: 20px;
                color: #ddd;
                cursor: pointer;
                transition: all 0.2s ease;
            }

            .rating-stars .star.active {
                color: #ffd700;
            }

            .rating-stars .star:hover {
                transform: scale(1.1);
            }

            .edit-form {
                display: none;
                background: #f8f9fa;
                padding: 20px;
                border-radius: 8px;
                margin-top: 15px;
            }

            .edit-form.show {
                display: block;
            }

            .btn-edit {
                background: #17a2b8;
                color: white;
                border: none;
                padding: 8px 16px;
                border-radius: 6px;
                cursor: pointer;
                transition: background 0.3s ease;
            }

            .btn-edit:hover {
                background: #138496;
            }

            .btn-cancel {
                background: #6c757d;
                color: white;
                border: none;
                padding: 8px 16px;
                border-radius: 6px;
                cursor: pointer;
                margin-left: 10px;
            }

            .btn-save {
                background: #28a745;
                color: white;
                border: none;
                padding: 8px 16px;
                border-radius: 6px;
                cursor: pointer;
            }

            .btn-delete {
                background: #dc3545;
                color: white;
                border: none;
                padding: 8px 16px;
                border-radius: 6px;
                cursor: pointer;
                margin-left: 10px;
            }

            .room-info {
                display: flex;
                align-items: center;
                gap: 15px;
                margin-bottom: 15px;
            }

            .room-image {
                width: 80px;
                height: 60px;
                object-fit: cover;
                border-radius: 8px;
            }

            .feedback-date {
                color: #666;
                font-size: 14px;
            }

            .no-feedback {
                text-align: center;
                padding: 60px 20px;
                color: #666;
            }

            .no-feedback i {
                font-size: 64px;
                color: #ddd;
                margin-bottom: 20px;
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
                                            <li><a href="edit-feedback">Blog Classic Sidebar</a></li>
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
                                            <li><a href="admin/user-profile.html">User Profile</a></li>
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
                </div>
            </header>
            <!-- header END -->
            <!-- Content -->
            <div class="page-content bg-white">
                <!-- inner page banner -->
                <div class="page-banner ovbl-dark" style="background-image:url(assets/images/banner/banner1.jpg);">
                    <div class="container">
                        <div class="page-banner-entry">
                            <h1 class="text-white">Blog Classic Sidebar</h1>
                        </div>
                    </div>
                </div>
                <!-- Breadcrumb row -->
                <div class="breadcrumb-row">
                    <div class="container">
                        <ul class="list-inline">
                            <li><a href="#">Home</a></li>
                            <li>Blog Classic Sidebar</li>
                        </ul>
                    </div>
                </div>
                <!-- Breadcrumb row END -->
                <div class="container mt-4">
                    <div class="row">
                        <div class="col-12">
                            <div class="d-flex justify-content-between align-items-center mb-4">
                                <h2><i class="fas fa-star"></i> My Reviews</h2>
                                <a href="user-profile" class="btn btn-secondary">
                                    <i class="fas fa-arrow-left"></i> Back to Profile
                                </a>
                            </div>

                            <!-- Success/Error Messages -->
                            <c:if test="${not empty successMessage}">
                                <div class="alert alert-success alert-dismissible fade show">
                                    <i class="fas fa-check-circle"></i> ${successMessage}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                </div>
                            </c:if>

                            <c:if test="${not empty errorMessage}">
                                <div class="alert alert-danger alert-dismissible fade show">
                                    <i class="fas fa-exclamation-circle"></i> ${errorMessage}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                </div>
                            </c:if>

                            <!-- Feedback List -->
                            <c:choose>
                                <c:when test="${not empty userFeedbacks}">
                                    <c:forEach var="feedback" items="${userFeedbacks}">
                                        <div class="feedback-card">
                                            <div class="feedback-header">
                                                <div class="room-info">
                                                    <img src="${feedback.roomType.imageUrl}" 
                                                         alt="${feedback.roomTypeName}" 
                                                         class="room-image"
                                                         onerror="this.src='assets/images/default-room.jpg'">
                                                    <div>
                                                        <h5 class="mb-1">${feedback.roomTypeName}</h5>
                                                        <div class="feedback-date">
                                                            <i class="fas fa-calendar"></i>
                                                            <fmt:formatDate value="${feedback.feedbackDate}" pattern="MMM dd, yyyy 'at' HH:mm" />
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="feedback-body">
                                                <!-- Display Mode -->
                                                <div class="feedback-display" id="display-${feedback.feedbackID}">
                                                    <div class="d-flex justify-content-between align-items-start mb-3">
                                                        <div>
                                                            <div class="rating-display mb-2">
                                                                <c:forEach begin="1" end="5" var="i">
                                                                    <span class="star ${i <= feedback.rating ? 'active' : ''}" style="cursor: default;">★</span>
                                                                </c:forEach>
                                                                <span class="ms-2 text-muted">(${feedback.rating}/5)</span>
                                                            </div>
                                                            <c:if test="${feedback.anonymous}">
                                                                <small class="badge bg-secondary">Anonymous Review</small>
                                                            </c:if>
                                                        </div>
                                                        <div>
                                                            <button class="btn-edit" onclick="showEditForm(${feedback.feedbackID})">
                                                                <i class="fas fa-edit"></i> Edit
                                                            </button>
                                                            <button class="btn-delete" onclick="deleteFeedback(${feedback.feedbackID})">
                                                                <i class="fas fa-trash"></i> Delete
                                                            </button>
                                                        </div>
                                                    </div>

                                                    <div class="feedback-comment">
                                                        <c:choose>
                                                            <c:when test="${not empty feedback.comment}">
                                                                <p class="mb-0">${fn:escapeXml(feedback.comment)}</p>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <p class="mb-0 text-muted fst-italic">No comment provided</p>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>

                                                <!-- Edit Mode -->
                                                <div class="edit-form" id="edit-${feedback.feedbackID}">
                                                    <form onsubmit="updateFeedback(event, ${feedback.feedbackID})">
                                                        <div class="mb-3">
                                                            <label class="form-label">Rating:</label>
                                                            <div class="rating-stars" id="editStars-${feedback.feedbackID}">
                                                                <c:forEach begin="1" end="5" var="i">
                                                                    <span class="star ${i <= feedback.rating ? 'active' : ''}" 
                                                                          data-rating="${i}" 
                                                                          onclick="setRating(${feedback.feedbackID}, ${i})">★</span>
                                                                </c:forEach>
                                                            </div>
                                                            <input type="hidden" id="newRating-${feedback.feedbackID}" value="${feedback.rating}">
                                                        </div>

                                                        <div class="mb-3">
                                                            <label for="newComment-${feedback.feedbackID}" class="form-label">Comment:</label>
                                                            <textarea class="form-control" 
                                                                      id="newComment-${feedback.feedbackID}" 
                                                                      rows="4" 
                                                                      maxlength="1000"
                                                                      placeholder="Share your experience...">${fn:escapeXml(feedback.comment)}</textarea>
                                                            <small class="text-muted">Maximum 1000 characters</small>
                                                        </div>

                                                        <div class="mb-3">
                                                            <div class="form-check">
                                                                <input class="form-check-input" 
                                                                       type="checkbox" 
                                                                       id="newAnonymous-${feedback.feedbackID}"
                                                                       ${feedback.anonymous ? 'checked' : ''}>
                                                                <label class="form-check-label" for="newAnonymous-${feedback.feedbackID}">
                                                                    Submit anonymously
                                                                </label>
                                                            </div>
                                                        </div>

                                                        <div>
                                                            <button type="submit" class="btn-save">
                                                                <i class="fas fa-save"></i> Save Changes
                                                            </button>
                                                            <button type="button" class="btn-cancel" onclick="hideEditForm(${feedback.feedbackID})">
                                                                <i class="fas fa-times"></i> Cancel
                                                            </button>
                                                        </div>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="no-feedback">
                                        <i class="fas fa-comments"></i>
                                        <h4>No Reviews Yet</h4>
                                        <p>You haven't submitted any reviews yet. Book a room and share your experience!</p>
                                        <a href="roomlist" class="btn btn-primary">
                                            <i class="fas fa-bed"></i> Browse Rooms
                                        </a>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Left & right section END -->
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
            <!-- scroll top button -->
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
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script src='assets/vendors/switcher/switcher.js'></script>

        <script>
                                                                function showEditForm(feedbackId) {
                                                                    document.getElementById('display-' + feedbackId).style.display = 'none';
                                                                    document.getElementById('edit-' + feedbackId).classList.add('show');
                                                                }

                                                                function hideEditForm(feedbackId) {
                                                                    document.getElementById('display-' + feedbackId).style.display = 'block';
                                                                    document.getElementById('edit-' + feedbackId).classList.remove('show');
                                                                }

                                                                function setRating(feedbackId, rating) {
                                                                    document.getElementById('newRating-' + feedbackId).value = rating;
                                                                    const stars = document.querySelectorAll('#editStars-' + feedbackId + ' .star');
                                                                    stars.forEach((star, index) => {
                                                                        if (index < rating) {
                                                                            star.classList.add('active');
                                                                        } else {
                                                                            star.classList.remove('active');
                                                                        }
                                                                    });
                                                                }

                                                                function updateFeedback(event, feedbackId) {
                                                                    event.preventDefault();

                                                                    const rating = document.getElementById('newRating-' + feedbackId).value;
                                                                    const comment = document.getElementById('newComment-' + feedbackId).value;
                                                                    const isAnonymous = document.getElementById('newAnonymous-' + feedbackId).checked;

                                                                    if (!rating || rating < 1 || rating > 5) {
                                                                        Swal.fire('Error', 'Please select a valid rating (1-5 stars)', 'error');
                                                                        return;
                                                                    }

                                                                    // Show loading
                                                                    Swal.fire({
                                                                        title: 'Updating Review...',
                                                                        allowOutsideClick: false,
                                                                        didOpen: () => {
                                                                            Swal.showLoading();
                                                                        }
                                                                    });

                                                                    // Send update request
                                                                    fetch('edit-feedback', {
                                                                        method: 'POST',
                                                                        headers: {
                                                                            'Content-Type': 'application/x-www-form-urlencoded'
                                                                        },
                                                                        body: 'action=update' +
                                                                                '&feedbackId=' + feedbackId +
                                                                                '&rating=' + rating +
                                                                                '&comment=' + encodeURIComponent(comment) +
                                                                                '&isAnonymous=' + isAnonymous
                                                                    })
                                                                            .then(response => response.json())
                                                                            .then(data => {
                                                                                if (data.success) {
                                                                                    Swal.fire('Success', 'Your review has been updated successfully!', 'success')
                                                                                            .then(() => {
                                                                                                location.reload();
                                                                                            });
                                                                                } else {
                                                                                    Swal.fire('Error', data.message || 'Failed to update review', 'error');
                                                                                }
                                                                            })
                                                                            .catch(error => {
                                                                                console.error('Error:', error);
                                                                                Swal.fire('Error', 'An error occurred while updating your review', 'error');
                                                                            });
                                                                }

                                                                function deleteFeedback(feedbackId) {
                                                                    Swal.fire({
                                                                        title: 'Delete Review?',
                                                                        text: 'Are you sure you want to delete this review? This action cannot be undone.',
                                                                        icon: 'warning',
                                                                        showCancelButton: true,
                                                                        confirmButtonColor: '#dc3545',
                                                                        cancelButtonColor: '#6c757d',
                                                                        confirmButtonText: 'Yes, delete it!',
                                                                        cancelButtonText: 'Cancel'
                                                                    }).then((result) => {
                                                                        if (result.isConfirmed) {
                                                                            // Show loading
                                                                            Swal.fire({
                                                                                title: 'Deleting Review...',
                                                                                allowOutsideClick: false,
                                                                                didOpen: () => {
                                                                                    Swal.showLoading();
                                                                                }
                                                                            });

                                                                            // Send delete request
                                                                            fetch('edit-feedback', {
                                                                                method: 'POST',
                                                                                headers: {
                                                                                    'Content-Type': 'application/x-www-form-urlencoded',
                                                                                },
                                                                                body: `action=delete&feedbackId=${feedbackId}`
                                                                            })
                                                                                    .then(response => response.json())
                                                                                    .then(data => {
                                                                                        if (data.success) {
                                                                                            Swal.fire('Deleted!', 'Your review has been deleted.', 'success')
                                                                                                    .then(() => {
                                                                                                        location.reload();
                                                                                                    });
                                                                                        } else {
                                                                                            Swal.fire('Error', data.message || 'Failed to delete review', 'error');
                                                                                        }
                                                                                    })
                                                                                    .catch(error => {
                                                                                        console.error('Error:', error);
                                                                                        Swal.fire('Error', 'An error occurred while deleting your review', 'error');
                                                                                    });
                                                                        }
                                                                    });
                                                                }
        </script>
    </body>

</html>