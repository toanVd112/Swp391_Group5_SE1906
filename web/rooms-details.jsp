<%-- 
    Document   : rooms-details
    Created on : Jun 3, 2025, 2:31:47 PM
    Author     : Arcueid
--%>
<!DOCTYPE html>
<html lang="en">
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
    <%@ page contentType="text/html" pageEncoding="UTF-8"%>

    <head>
        <link href="https://cdn.jsdelivr.net/npm/remixicon/fonts/remixicon.css" rel="stylesheet">
        <script src="https://unpkg.com/@phosphor-icons/web"></script>

       <style>
    body {
        font-family: 'Roboto', sans-serif;
        background-color: #f4f7f9;
        margin: 0;
        padding: 20px;
    }

    .photo-gallery-title {
        font-size: 20px;
        font-weight: 600;
        margin-bottom: 12px;
    }

    .gallery-preview {
        display: flex;
        flex-direction: column;
        gap: 12px;
    }

    .gallery-preview .main-photo img {
        width: 100%;
        height: 400px;
        object-fit: cover;
        display: block;
        cursor: pointer;
    }

    .gallery-preview .sub-photo-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
        gap: 12px;
    }

    .gallery-preview .sub-photo-grid img {
        width: 100%;
        height: 200px;
        object-fit: cover;
        display: block;
        cursor: pointer;
    }

    .gallery-preview img[loading="lazy"] {
        background: #e0e0e0;
    }

    /* Gallery Modal */
    .gallery-modal {
        position: fixed;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        width: 90%;
        max-width: 1280px;
        max-height: 90%;
        background: #fff;
        border-radius: 16px;
        overflow: hidden;
        z-index: 10000;
        box-shadow: 0 8px 30px rgba(0, 0, 0, 0.2);
        padding: 24px;
        display: none;
        flex-direction: column;
    }

    .gallery-modal.show {
        display: flex;
    }

    .gallery-modal .close-btn {
        position: absolute;
        top: 12px;
        right: 16px;
        font-size: 24px;
        background: none;
        border: none;
        cursor: pointer;
        color: #444;
        font-weight: bold;
    }

    .modal-tabs {
        display: flex;
        gap: 10px;
        overflow-x: auto;
        padding-bottom: 6px;
        border-bottom: 1px solid #ccc;
        margin-bottom: 16px;
    }

    .filter-btn {
        flex-shrink: 0;
        padding: 6px 14px;
        font-size: 14px;
        background-color: #f1f1f1;
        border: none;
        border-radius: 20px;
        cursor: pointer;
        white-space: nowrap;
        transition: all 0.3s;
    }

    .filter-btn.active {
        background-color: #0064d2;
        color: white;
        font-weight: bold;
    }

    .gallery-modal-body {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
        gap: 16px;
        overflow-y: auto;
    }

    .gallery-item img {
        width: 100%;
        height: 220px;
        object-fit: cover;
        background: #f0f0f0;
    }

    .gallery-item p {
        margin: 0;
        padding: 10px 14px;
        font-size: 14px;
        background: #f9f9f9;
        color: #333;
        border-top: 1px solid #eee;
        text-align: left;
    }

    .gallery.no-caption .gallery-item p {
        display: none;
    }

    @media screen and (max-width: 768px) {
        .gallery-modal-body {
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
        }
    }

    @media screen and (max-width: 480px) {
        .gallery-modal-body {
            grid-template-columns: 1fr;
        }

        .gallery-preview .main-photo img {
            height: 240px;
        }

        .gallery-preview .sub-photo-grid img {
            height: 160px;
        }
    }
</style>

        <script>
            function filterSelection(category, btn) {
                const modal = btn.closest('.gallery-modal');
                const scope = modal || document;

                const items = scope.querySelectorAll('.gallery-item');
                const buttons = scope.querySelectorAll('.filter-btn');

                // Cập nhật trạng thái active
                buttons.forEach(b => b.classList.remove('active'));
                btn.classList.add('active');

                // Lọc ảnh
                items.forEach(item => {
                    const show = category === 'all' || item.classList.contains(category);
                    item.style.display = show ? 'block' : 'none';
                });

                // Cập nhật tiêu đề nếu có
                const galleryTitle = scope.querySelector('.photo-gallery-title');
                if (galleryTitle) {
                    galleryTitle.textContent = btn.textContent;
                }
            }

            function openGalleryModal() {
                const modal = document.getElementById("galleryModal");
                if (!modal)
                    return;

                modal.classList.add('show');
                document.body.style.overflow = "hidden";

                document.addEventListener('keydown', closeOnEsc);
            }

            function closeGallery() {
                const modal = document.getElementById("galleryModal");
                if (!modal)
                    return;

                modal.classList.remove('show');
                document.body.style.overflow = "auto";

                document.removeEventListener('keydown', closeOnEsc);
            }

            function closeOnEsc(e) {
                if (e.key === 'Escape') {
                    closeGallery();
                }
            }

        </script>



        <!-- META ============================================= -->
        <meta charset="UTF-8">
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
                                    <li><a href="login.jsp">Login</a></li>
                                    <li><a href="register.html">Register</a></li>
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
            <!-- header END ==== -->
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

                                            <h4 class="price">$${room.roomType.basePrice}</h4>
                                        </div>	
                                        <div class="course-buy-now text-center">
                                            <a href="#" class="btn radius-xl text-uppercase">BOOK NOW</a>
                                        </div>
                                        <div class="teacher-bx">
                                            <div class="teacher-info">
                                                <div class="teacher-thumb">

                                                </div>
                                                <h5>
                                                    <span class="status-${room.status.toLowerCase()}">${room.status}</span>
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
                                            <a href="#">
                                                <img src="${pageContext.request.contextPath}/${room.roomImage}" alt="Room ${room.roomnumber}" />
                                            </a>
                                        </div>

                                        <div class="ttr-post-info">
                                            <div class="ttr-post-title">
                                                <h2 class="post-title"> Phòng ${room.roomnumber}</h2>
                                            </div>

                                            <div class="ttr-post-text">
                                                <p>${room.roomType.roomDetail}</p>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="courese-overview" id="overview">
                                        <h4>Overview</h4>
                                        <div class="row">
                                            <div class="col-md-12 col-lg-4">
                                                <ul class="course-features">    
                                                    <li><i class="ri-hotel-bed-line"></i> 2 giường đơn</li>
                                                    <li><i class="ri-windy-line"></i> Máy điều hòa</li>
                                                    <li><i class="ri-building-line"></i> Ban công</li>
                                                    <li><i class="ph ph-shower"></i> Phòng tắm riêng</li>
                                                    <li><i class="ri-custom-size"></i> 19 mét vuông</li>
                                                    <li><i class="ri-restaurant-line"></i> ban cong</li>
                                                    <li><i class="ri-rss-line"></i> Wifi miễn phí</li>
                                                    <li><i class="ri-customer-service-2-line"></i> phuc vu day du</li>


                                                </ul>
                                            </div>
                                            <div class="col-md-12 col-lg-8">
                                                <!-- Chính sách -->
                                                <c:if test="${not empty policies}">
                                                    <h5 class="m-b5">Policy</h5>
                                                    <c:forEach var="item" items="${policies}">
                                                        <h6>${item.title}</h6>
                                                        <p>${item.content}</p>
                                                    </c:forEach>
                                                </c:if>

                                                <!-- Thông tin quan tr?ng -->
                                                <c:if test="${not empty importantInfos}">
                                                    <h5 class="m-b5">Important Information</h5>
                                                    <c:forEach var="item" items="${importantInfos}">
                                                        <h6>${item.title}</h6>
                                                        <p>${item.content}</p>
                                                    </c:forEach>
                                                </c:if>

                                                <!-- Câu h?i th??ng g?p -->
                                                <c:if test="${not empty faqs}">
                                                    <h5 class="m-b5">FAQ</h5>
                                                    <ul class="list-checked primary">
                                                        <c:forEach var="item" items="${faqs}">
                                                            <li><strong>${item.title}</strong><br/>${item.content}</li>
                                                                </c:forEach>
                                                    </ul>
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="container" id="pictures">
    <h2 class="photo-gallery-title">Tất cả ảnh</h2>
    <div class="gallery-preview">
        <c:if test="${not empty images}">
            <div class="main-photo" onclick="openGalleryModal()">
                <img src="${pageContext.request.contextPath}/${images[0].imageUrl}" alt="Ảnh chính" loading="lazy" />
            </div>
            <div class="sub-photo-grid">
                <c:forEach var="img" begin="1" items="${images}">
                    <img src="${pageContext.request.contextPath}/${img.imageUrl}"
                         alt="Ảnh phụ"
                         class="${fn:toLowerCase(img.category)}"
                         onclick="openGalleryModal()"
                         loading="lazy" />
                </c:forEach>
            </div>
        </c:if>
    </div>
</div>

                                    <div id="galleryModal" class="gallery-modal">
                                        <div class="gallery-content">
                                            <button class="close-btn" onclick="closeGallery()">×</button>
                                            <div class="filter-container modal-tabs">
                                                <button class="filter-btn active" onclick="filterSelection('all', this)">Tất cả</button>
                                                <c:set var="usedCatsModal" value="" />
                                                <c:forEach var="img" items="${images}">
                                                    <c:if test="${not fn:contains(usedCatsModal, img.category)}">
                                                        <button class="filter-btn" onclick="filterSelection('${fn:toLowerCase(img.category)}', this)">
                                                            ${img.category}
                                                        </button>
                                                        <c:set var="usedCatsModal" value="${usedCatsModal}${img.category}," />
                                                    </c:if>
                                                </c:forEach>
                                            </div>

                                            <div class="gallery gallery-modal-body">
                                                <c:forEach var="img" items="${images}">
                                                    <div class="gallery-item ${fn:toLowerCase(img.category)}">
                                                        <img src="${pageContext.request.contextPath}/${img.imageUrl}" 
                                                             alt="Hình ảnh ${img.category} của phòng ${room.roomnumber}" 
                                                             loading="lazy" />
                                                        <p>${img.category}</p>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="" id="instructor">
                                        <h4>Instructor</h4>
                                        <div class="instructor-bx">
                                            <div class="instructor-author">
                                                <img src="assets/images/testimonials/pic1.jpg" alt="">
                                            </div>
                                            <div class="instructor-info">
                                                <h6>Keny White </h6>
                                                <span>Professor</span>
                                                <ul class="list-inline m-tb10">
                                                    <li><a href="#" class="btn sharp-sm facebook"><i class="fa fa-facebook"></i></a></li>
                                                    <li><a href="#" class="btn sharp-sm twitter"><i class="fa fa-twitter"></i></a></li>
                                                    <li><a href="#" class="btn sharp-sm linkedin"><i class="fa fa-linkedin"></i></a></li>
                                                    <li><a href="#" class="btn sharp-sm google-plus"><i class="fa fa-google-plus"></i></a></li>
                                                </ul>
                                                <p class="m-b0">Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries</p>
                                            </div>
                                        </div>
                                        <div class="instructor-bx">
                                            <div class="instructor-author">
                                                <img src="assets/images/testimonials/pic2.jpg" alt="">
                                            </div>
                                            <div class="instructor-info">
                                                <h6>Keny White </h6>
                                                <span>Professor</span>
                                                <ul class="list-inline m-tb10">
                                                    <li><a href="#" class="btn sharp-sm facebook"><i class="fa fa-facebook"></i></a></li>
                                                    <li><a href="#" class="btn sharp-sm twitter"><i class="fa fa-twitter"></i></a></li>
                                                    <li><a href="#" class="btn sharp-sm linkedin"><i class="fa fa-linkedin"></i></a></li>
                                                    <li><a href="#" class="btn sharp-sm google-plus"><i class="fa fa-google-plus"></i></a></li>
                                                </ul>
                                                <p class="m-b0">Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries</p>
                                            </div>
                                        </div>
                                    </div>
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


    </body>

</html>