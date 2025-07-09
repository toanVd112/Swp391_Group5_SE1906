<%-- 
    Document   : user_profile2
    Created on : Jun 19, 2025, 9:23:32 AM
    Author     : AD
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    String dobAttr = "";
    String tmpDob = (String) request.getAttribute("tempDob");
    String formDob = (String) request.getAttribute("formattedDob");
    if (tmpDob != null && !tmpDob.isEmpty()) {
        dobAttr = "value=\"" + tmpDob + "\"";
    } else if (formDob != null && !formDob.isEmpty()) {
        dobAttr = "value=\"" + formDob + "\"";
    }
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <!-- META ============================================= -->
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="keywords" content="" />
        <meta name="author" content="" />
        <meta name="robots" content="" />

        <!-- DESCRIPTION -->
        <meta name="description" content="Hoang Nam Hotel" />
        <meta property="og:title" content="Hoang Nam Hotel" />
        <meta property="og:description" content="HoangNam Hotel" />
        <meta property="og:image" content="" />
        <meta name="format-detection" content="telephone=no">

        <!-- FAVICONS ICON ============================================= -->
        <link rel="icon" href="assets/images/favicon1.ico" type="image/x-icon" />
        <link rel="shortcut icon" type="image/x-icon" href="assets/images/favicon1.png" />

        <!-- PAGE TITLE HERE ============================================= -->
        <title>HoangNam Hotel</title>

        <!-- MOBILE SPECIFIC ============================================= -->
        <meta name="viewport" content="width=device-width, initial-scale=1">
        
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

        <!-- All PLUGINS CSS ============================================= -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/Customer/profile.css">
        <link rel="stylesheet" type="text/css" href="assets/css/assets.css">

        <style>
            .error-list {
                color: #d32f2f;
                font-size: 0.9em;
                margin-bottom: 20px;
                text-align: center;
            }
            .error-list li {
                margin-bottom: 5px;
            }
            .error-message {
                color: #d32f2f;
                font-size: 0.9em;
                margin-bottom: 20px;
                text-align: center;
            }
            .success-message {
                color: #2e7d32;
                font-size: 0.9em;
                margin-bottom: 20px;
                text-align: center;
            }
        </style>

        <script>
            function validateForm() {
                const fullName = document.getElementById("fullName").value;
                const email = document.getElementById("email").value;
                const phone = document.getElementById("phone").value;
                const dateOfBirth = document.getElementById("dateOfBirth").value;
                const nameRegex = /^[a-zA-Z?-?\s]+$/;
                const emailRegex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
                const phoneRegex = /^\d{10}$/;
                const dateRegex = /^\d{4}-\d{2}-\d{2}$/;
                let errors = [];

//                if (!fullName || fullName.trim() === "") {
//                    errors.push("H? v? t?n kh?ng ???c ?? tr?ng!");
//                } else if (fullName.length > 100) {
//                    errors.push("H? v? t?n kh?ng ???c v??t qu? 100 k? t?!");
//                } else if (!nameRegex.test(fullName)) {
//                    errors.push("H? v? t?n ch? ???c ch?a ch? c?i v? kho?ng tr?ng!");
//                }
//                if (!emailRegex.test(email)) {
//                    errors.push("??nh d?ng email kh?ng h?p l?!");
//                }
//                if (!phoneRegex.test(phone)) {
//                    errors.push("S? ?i?n tho?i ph?i l? 10 ch? s?!");
//                }
//                if (dateOfBirth && !dateRegex.test(dateOfBirth)) {
//                    errors.push("??nh d?ng ng?y sinh kh?ng h?p l?! S? d?ng YYYY-MM-DD.");
//                }
//                if (errors.length > 0) {
//                    alert(errors.join("\n"));
//                    return false;
//                }
//                return true;
//            }

            // Preview ?nh
            document.addEventListener("DOMContentLoaded", function () {
                const photoInput = document.getElementById("photo");
                if (photoInput) {
                    photoInput.addEventListener("change", function (event) {
                        const file = event.target.files[0];
                        if (file) {
                            const reader = new FileReader();
                            reader.onload = function (e) {
                                const avatarImg = document.querySelector(".avatar img");
                                if (avatarImg) {
                                    avatarImg.src = e.target.result;
                                } else {
                                    const avatarContainer = document.querySelector(".avatar");
                                    const img = document.createElement("img");
                                    img.src = e.target.result;
                                    img.alt = "Avatar";
                                    img.style.maxWidth = "100%";
                                    img.style.maxHeight = "100%";
                                    avatarContainer.innerHTML = "";
                                    avatarContainer.appendChild(img);
                                }
                            };
                            reader.readAsDataURL(file);
                        }
                    });
                }
            });
        </script>
    </head>
    <body>
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
                                    

                                    <c:if test="${sessionScope.user != null}">
                                        <li class="nav-item">
                                            <a class="nav-link" href="${pageContext.request.contextPath}/user-profile">Hello, ${sessionScope.user.username}</a>
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
                                    <c:choose>
                                        <%-- N?u ng??i d?ng ?? ??ng nh?p --%>
                                        <c:when test="${not empty sessionScope.user}">
                                            <li><a href="customerCart"><i class="fa fa-bed"></i> My Rooms</a></li>
                                            </c:when>

                                        <%-- N?u ch?a ??ng nh?p --%>
                                        <c:otherwise>
                                            <li><a href="cart.jsp"><i class="fa fa-bed"></i> My Rooms</a></li>
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

        <div class="profile-container">
            <div class="profile-header">
                <div class="avatar-container">
                    <div class="avatar">
                        <c:choose>
                            <c:when test="${not empty user and not empty user.avatarPath}">
                                <img src="${pageContext.request.contextPath}/${user.avatarPath}" alt="Avatar">
                            </c:when>
                            <c:otherwise>
                                <span class="avatar-initials">
                                    <c:choose>
                                        <c:when test="${not empty user and not empty user.fullName}">
                                            ${fn:substring(user.fullName, 0, 1)}
                                        </c:when>
                                        <c:otherwise>?</c:otherwise>
                                    </c:choose>
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                  
                </div>
                <div class="profile-name"><c:out value="${not empty user ? user.fullName : ''}"/></div>

            </div>

            <c:if test="${not empty message}">
                <div class="success-message">${message}</div>
            </c:if>
            <c:if test="${not empty errors}">
                <ul class="error-list">
                    <c:forEach var="error" items="${errors}">
                        <li><c:out value="${error}"/></li>
                        </c:forEach>
                </ul>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="error-message">${errorMessage}</div>
            </c:if>

            <div class="profile-content">
                <form class="profile-form" method="post" action="user-profile" enctype="multipart/form-data" onsubmit="return validateForm()">
                    <div class="form-group">
                        <label class="form-label" for="username">User name</label>
                        <div class="readonly-field"><c:out value="${not empty account ? account.username : ''}"/></div>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="fullName">Full Name</label>
                        <input type="text" id="fullName" name="fullName" class="form-input" value="${not empty tempFullName ? tempFullName : (not empty user ? user.fullName : '')}" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="email">Email</label>
                        <input type="email" id="email" name="email" class="form-input" value="${not empty tempEmail ? tempEmail : (not empty user ? user.email : '')}" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="phone">Phone Number</label>
                        <div class="phone-input">
                            <span class="phone-prefix">+84</span>
                            <input type="tel" id="phone" name="phone" class="form-input with-prefix" value="${not empty tempPhone ? tempPhone : (not empty user ? user.phone : '')}" required>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="dateOfBirth">Date of Birth</label>
                        <input type="date" id="dateOfBirth" name="dateOfBirth" class="form-input"
                               value="${not empty tempDob ? tempDob : formattedDob}">
                    </div>
  
                    <div class="form-group">
                        <label class="form-label" for="address">Address</label>
                        <textarea id="address" name="address" class="form-input form-textarea" ><c:out value="${not empty tempAddress ? tempAddress : (not empty user ? user.address : '')}"/></textarea>
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="photo">Photo</label>
                        <input type="file" id="photo" name="photo" class="form-input" accept="image/*">
                    </div>
                    <div class="btn-group">
                        <button type="submit" class="btn btn-primary">
                            <svg class="icon" viewBox="0 0 24 24">
                            <path d="M15,9H5V5H15M12,19A3,3 0 0,1 9,16A3,3 0 0,1 12,13A3,3 0 0,1 15,16A3,3 0 0,1 12,19M17,3H5C3.89,3 3,3.9 3,5V19A2,2 0 0,0 5,21H19A2,2 0 0,0 21,19V7L17,3Z"/>
                            </svg>
                            Save changes
                        </button>
                    
                        <a href="changePassword" class="btn btn-warning">
                        <svg class="icon" viewBox="0 0 24 24">
                            <path d="M12,17A2,2 0 0,0 14,15C14,13.89 13.1,13 12,13A2,2 0 0,0 10,15A2,2 0 0,0 12,17M18,8A2,2 0 0,1 20,10V20A2,2 0 0,1 18,22H6A2,2 0 0,1 4,20V10C4,8.89 4.9,8 6,8H7V6A5,5 0 0,1 12,1A5,5 0 0,1 17,6V8H18M12,3A3,3 0 0,0 9,6V8H15V6A3,3 0 0,0 12,3Z"/>
                        </svg>
                        Change Password
                    </a>
                    </div>
                </form>
            </div>
        </div>
                    
                    

    </body>
</html>