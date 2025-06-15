<%-- Khai báo loại nội dung của trang là HTML, mã hóa UTF-8 để hỗ trợ tiếng Việt --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%-- Nhúng thư viện JSTL core để sử dụng các thẻ như <c:forEach>, <c:if> --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- Nhúng thư viện JSTL fmt để định dạng số, ngày tháng (ví dụ: giá dịch vụ) --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%-- Import lớp Account từ package model để sử dụng trong đoạn mã Java --%>
<%@ page import="model.Account" %>

<%-- Kiểm tra quyền truy cập --%>
<%
    // Lấy đối tượng Account từ session (phiên đăng nhập của người dùng)
    Account account = (Account) session.getAttribute("account");
    
    // Kiểm tra nếu người dùng chưa đăng nhập (account == null) hoặc không phải Manager
    if (account == null || !"Manager".equals(account.getRole())) {
        // Chuyển hướng về trang đăng nhập (login.jsp) nếu không đủ quyền
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return; // Dừng xử lý JSP
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <%-- Thiết lập mã hóa UTF-8 cho trang web --%>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="keywords" content="" />
    <meta name="author" content="" />
    <meta name="robots" content="" />
    <meta name="description" content="Khách sạn Hoang Nam - Chuỗi khách sạn lớn nhất miền bắc" />
    <meta property="og:title" content="Khách sạn Hoang Nam - Chuỗi khách sạn lớn nhất miền bắc" />
    <meta property="og:description" content="Khách sạn Hoang Nam - Chuỗi khách sạn lớn nhất miền bắc" />
    <meta property="og:image" content="" />
    <meta name="format-detection" content="telephone=no">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <%-- Tiêu đề của trang --%>
    <title>Service List - Hoang Nam Hotel</title>

    <%-- FAVICON ICON --%>
    <link rel="icon" href="${pageContext.request.contextPath}/assets/images/favicon1.ico" type="image/x-icon" />
    <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/images/favicon1.png" />

    <%-- Nhúng Bootstrap CSS --%>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <%-- CSS tùy chỉnh từ header/footer --%>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/assets.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/typography.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/shortcodes/shortcodes.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link class="skin" rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/color/color-1.css">

    <%-- CSS tùy chỉnh cho service list --%>
    <style>
        /* Đảm bảo HTML và body chiếm toàn bộ chiều cao */
        html, body {
            height: 100%;
            margin: 0;
            overflow-x: hidden;
        }

        /* Thiết lập nền và padding cho body */
        body {
            background-color: #f8f9fa;
            color: #333;
            padding-top: 120px; /* Điều chỉnh để phù hợp với top-bar và navbar */
            padding-bottom: 60px; /* Không gian cho footer */
            display: flex;
            flex-direction: column;
        }

        /* Container chính */
        .main-content {
            flex: 1;
            padding: 20px;
            max-width: 1200px;
            margin: 0 auto;
        }

        /* Top Bar */
        .top-bar {
            background-color: #f8f9fa;
            padding: 10px 0;
            border-bottom: 1px solid #dee2e6;
            position: fixed;
            top: 0;
            width: 100%;
            z-index: 1030;
        }

        .top-bar .topbar-left ul, .top-bar .topbar-right ul {
            list-style: none;
            padding: 0;
            margin: 0;
            display: flex;
            align-items: center;
        }

        .top-bar .topbar-left ul li, .top-bar .topbar-right ul li {
            margin-right: 15px;
        }

        .top-bar .topbar-right .header-lang-bx {
            padding: 5px;
            border: 1px solid #dee2e6;
            border-radius: 4px;
        }

        /* Navbar */
        .sticky-header {
            background-color: #007bff;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            position: fixed;
            top: 40px; /* Dưới top-bar */
            width: 100%;
            z-index: 1020;
        }

        .navbar-brand img {
            height: 40px;
        }

        .nav-link {
            color: #fff !important;
        }

        .nav-link:hover {
            background-color: #0056b3;
        }

        .dropdown-menu {
            background-color: #007bff;
        }

        .dropdown-item {
            color: #fff !important;
        }

        .dropdown-item:hover {
            background-color: #0056b3;
        }

        /* Form tìm kiếm và lọc */
        .filter-form {
            gap: 10px;
            align-items: center;
        }

        .filter-form .form-control, .filter-form .form-select {
            max-width: 200px;
        }

        /* Bảng dịch vụ */
        .table {
            background-color: #fff;
            border-radius: 8px;
            overflow: hidden;
        }

        .table th {
            background-color: #e9ecef;
            border-bottom: 2px solid #dee2e6;
        }

        .table td, .table th {
            vertical-align: middle;
        }

        /* Nút hành động */
        .btn-sm {
            padding: 4px 10px;
            font-size: 14px;
        }

        /* Modal hình ảnh */
        .modal-content {
            border-radius: 10px;
        }

        .modal-body img {
            max-height: 70vh;
        }

        /* Thanh phân trang */
        .pagination {
            justify-content: center;
            margin-top: 20px;
            padding: 10px 0;
            background-color: #fff;
            border-top: 1px solid #dee2e6;
        }

        /* Footer */
        .footer-top {
            background-color: #1a2b49;
            color: #fff;
            padding: 40px 0;
        }

        .footer-top .footer-title {
            color: #fff;
            font-weight: 600;
        }

        .footer-top .btn {
            background-color: #007bff;
            color: #fff;
        }

        .footer-top .btn:hover {
            background-color: #0056b3;
        }

        .footer-bottom {
            background-color: #0d1a33;
            color: #fff;
            padding: 15px 0;
            text-align: center;
        }

        /* Responsive design */
        @media (max-width: 768px) {
            .main-content {
                padding: 10px;
                max-width: 100%;
            }
            .filter-form {
                flex-direction: column;
                gap: 5px;
            }
            .filter-form .form-control, .filter-form .form-select {
                max-width: 100%;
            }
            .top-bar .topbar-left ul, .top-bar .topbar-right ul {
                flex-direction: column;
                text-align: center;
            }
            .top-bar .topbar-right ul li {
                margin: 5px 0;
            }
        }
    </style>
</head>
<body>
    <%-- Top Bar --%>
    <div class="top-bar">
        <div class="container">
            <div class="row d-flex justify-content-between">
                <div class="topbar-left">
                    <ul>
                        <li><a href="faq-1.jsp"><i class="fa fa-question-circle"></i> Ask a Question</a></li>
                        <li><a href="javascript:;"><i class="fa fa-envelope-o"></i> Support@website.com</a></li>
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
                                <a class="nav-link" href="admin/user-profile.jsp">Hello, ${sessionScope.user.username}</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/Logout">Logout</a>
                            </li>
                        </c:if>
                    </ul>
                </div>
            </div>
        </div>
    </div>

    <%-- Navbar --%>
    <div class="sticky-header navbar-expand-lg">
        <div class="menu-bar clearfix">
            <div class="container clearfix">
                <div class="menu-logo">
                    <a href="${pageContext.request.contextPath}/Home"><img src="${pageContext.request.contextPath}/assets/images/logo.png" alt="Hoang Nam Hotel"></a>
                </div>
                <button class="navbar-toggler collapsed menuicon justify-content-end" type="button" data-bs-toggle="collapse" data-bs-target="#menuDropdown" aria-controls="menuDropdown" aria-expanded="false" aria-label="Toggle navigation">
                    <span></span>
                    <span></span>
                    <span></span>
                </button>
                <div class="secondary-menu">
                    <div class="secondary-inner">
                        <ul>
                            <li><a href="javascript:;" class="btn-link"><i class="fa fa-facebook"></i></a></li>
                            <li><a href="javascript:;" class="btn-link"><i class="fa fa-google-plus"></i></a></li>
                            <li><a href="javascript:;" class="btn-link"><i class="fa fa-linkedin"></i></a></li>
                        </ul>
                    </div>
                </div>
                <div class="nav-search-bar d-none d-lg-block">
                    <form action="#">
                        <input name="search" value="" type="text" class="form-control" placeholder="Type to search">
                        <span><i class="fa fa-search"></i></span>
                    </form>
                </div>
                <div class="menu-links collapse navbar-collapse justify-content-start" id="menuDropdown">
                    <ul class="nav navbar-nav">	
                        <li class="active"><a href="javascript:;">Home <i class="fa fa-chevron-down"></i></a>
                            <ul class="dropdown-menu">
                                <li><a href="${pageContext.request.contextPath}/Home">Home 1</a></li>
                                <li><a href="${pageContext.request.contextPath}/Home">Home 2</a></li>
                            </ul>
                        </li>
                        <li><a href="javascript:;">Pages <i class="fa fa-chevron-down"></i></a>
                            <ul class="dropdown-menu">
                                <li><a href="javascript:;">About<i class="fa fa-angle-right"></i></a>
                                    <ul class="dropdown-menu">
                                        <li><a href="about-1.html">About 1</a></li>
                                        <li><a href="about-2.html">About 2</a></li>
                                    </ul>
                                </li>
                                <li><a href="javascript:;">Event<i class="fa fa-angle-right"></i></a>
                                    <ul class="dropdown-menu">
                                        <li><a href="event.html">Event</a></li>
                                        <li><a href="events-details.html">Events Details</a></li>
                                    </ul>
                                </li>
                                <li><a href="javascript:;">FAQ's<i class="fa fa-angle-right"></i></a>
                                    <ul class="dropdown-menu">
                                        <li><a href="faq-1.jsp">FAQ's 1</a></li>
                                        <li><a href="faq-2.html">FAQ's 2</a></li>
                                    </ul>
                                </li>
                                <li><a href="javascript:;">Contact Us<i class="fa fa-angle-right"></i></a>
                                    <ul class="dropdown-menu">
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
                            <ul class="dropdown-menu">
                                <li><a href="roomlist">Rooms</a></li>
                                <li><a href="rooms-details.jsp">Rooms Details</a></li>
                                <li><a href="profile.html">Instructor Profile</a></li>
                                <li><a href="event.html">Upcoming Event</a></li>
                                <li><a href="membership.html">Membership</a></li>
                            </ul>
                        </li>
                        <li><a href="javascript:;">Blog <i class="fa fa-chevron-down"></i></a>
                            <ul class="dropdown-menu">
                                <li><a href="blog-classic-grid.html">Blog Classic</a></li>
                                <li><a href="blog-classic-sidebar.html">Blog Classic Sidebar</a></li>
                                <li><a href="blog-list-sidebar.html">Blog List Sidebar</a></li>
                                <li><a href="blog-standard-sidebar.html">Blog Standard Sidebar</a></li>
                                <li><a href="blog-details.html">Blog Details</a></li>
                            </ul>
                        </li>
                        <li class="nav-dashboard"><a href="javascript:;">Dashboard <i class="fa fa-chevron-down"></i></a>
                            <ul class="dropdown-menu">
                                <li><a href="${pageContext.request.contextPath}/admin/Home">Dashboard</a></li>
                                <li><a href="admin/add-listing.html">Add Listing</a></li>
                                <li><a href="admin/bookmark.html">Bookmark</a></li>
                                <li><a href="${pageContext.request.contextPath}/admin/roomlist">Rooms</a></li>
                                <li><a href="admin/review.html">Review</a></li>
                                <li><a href="admin/user-profile.jsp">User Profile</a></li>
                                <li><a href="javascript:;">Calendar<i class="fa fa-angle-right"></i></a>
                                    <ul class="dropdown-menu">
                                        <li><a href="admin/basic-calendar.html">Basic Calendar</a></li>
                                        <li><a href="admin/list-view-calendar.html">List View Calendar</a></li>
                                    </ul>
                                </li>
                                <li><a href="javascript:;">Mailbox<i class="fa fa-angle-right"></i></a>
                                    <ul class="dropdown-menu">
                                        <li><a href="admin/mailbox.html">Mailbox</a></li>
                                        <li><a href="admin/mailbox-compose.html">Compose</a></li>
                                        <li><a href="admin/mailbox-read.html">Mail Read</a></li>
                                    </ul>
                                </li>
                            </ul>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>

    <%-- Nội dung chính --%>
    <div class="main-content">
        <div class="container">
            <%-- Form tìm kiếm và lọc dịch vụ --%>
            <div class="filter-form mb-4 d-flex flex-wrap justify-content-between align-items-center">
                <form method="GET" action="${pageContext.request.contextPath}/services/list" class="d-flex flex-wrap gap-2">
                    <%-- Ô tìm kiếm theo tên dịch vụ --%>
                    <input type="text" class="form-control" name="searchKeyword" placeholder="Search by name..." value="${currentSearchKeyword}">
                    
                    <%-- Dropdown lọc theo loại dịch vụ --%>
                    <select class="form-select" name="filterType">
                        <option value="">All Types</option>
                        <c:forEach items="${serviceTypeList}" var="t">
                            <option value="${t}" ${t == currentFilterType ? 'selected' : ''}>${t}</option>
                        </c:forEach>
                    </select>
                    
                    <%-- Dropdown lọc theo trạng thái --%>
                    <select class="form-select" name="filterStatus">
                        <option value="">All Status</option>
                        <option value="1" ${"1" == currentFilterStatus ? 'selected' : ''}>Available</option>
                        <option value="0" ${"0" == currentFilterStatus ? 'selected' : ''}>Not Available</option>
                    </select>
                    
                    <%-- Nút gửi form để lọc --%>
                    <button type="submit" class="btn btn-primary btn-sm">Filter</button>
                    
                    <%-- Nút xóa bộ lọc, trở về trạng thái mặc định --%>
                    <a href="${pageContext.request.contextPath}/services/list" class="btn btn-secondary btn-sm">Clear</a>
                </form>

                <%-- Nút thêm dịch vụ mới --%>
                <button class="btn btn-success btn-sm" onclick="window.location.href='${pageContext.request.contextPath}/addService'">Add New</button>
            </div>

            <%-- Bảng hiển thị danh sách dịch vụ --%>
            <div class="table-responsive">
                <table class="table table-bordered table-striped">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Price</th>
                            <th>Type</th>
                            <th>Status</th>
                            <th>Created By</th>
                            <th>Create Date</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%-- Kiểm tra nếu danh sách dịch vụ rỗng --%>
                        <c:if test="${empty serviceList}">
                            <tr>
                                <td colspan="8" class="text-center">No services found.</td>
                            </tr>
                        </c:if>
                        
                        <%-- Lặp qua danh sách dịch vụ để hiển thị --%>
                        <c:forEach items="${serviceList}" var="s">
                            <tr>
                                <td>${s.id}</td>
                                <td>${s.name}</td>
                                <td><fmt:formatNumber value='${s.price}' pattern='###,###,###₫'/></td>
                                <td>${s.type == null ? "N/A" : s.type}</td>
                                <td>${s.status == "1" ? "Available" : "Not Available"}</td>
                                <td>${s.createdBy == null ? "N/A" : s.createdBy}</td>
                                <td>${s.createDate}</td>
                                <td>
                                    <button class="btn btn-primary btn-sm mb-1" onclick="window.location.href='${pageContext.request.contextPath}/editService?id=${s.id}'">Edit</button>
                                    <button class="btn btn-info btn-sm mb-1" onclick="showImageModal('${s.serviceImage}')">View Image</button>
                                    <c:choose>
                                        <c:when test="${s.status == '1'}">
                                            <button class="btn btn-danger btn-sm mb-1" style="width: 80px" onclick="toggleStatus(${s.id})">Inactive</button>
                                        </c:when>
                                        <c:otherwise>
                                            <button class="btn btn-success btn-sm mb-1" style="width: 80px" onclick="toggleStatus(${s.id})">Active</button>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <%-- Modal hiển thị hình ảnh dịch vụ --%>
    <div class="modal fade" id="imageModal" tabindex="-1" aria-labelledby="imageModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="imageModalLabel">Service Image</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body text-center">
                    <img id="serviceImage" src="" alt="Service Image" class="img-fluid rounded">
                </div>
            </div>
        </div>
    </div>

    <%-- Thanh phân trang --%>
    <nav class="pagination" aria-label="Page navigation">
        <ul class="pagination">
            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                <a class="page-link" href="${pageContext.request.contextPath}/services/list?page=${currentPage - 1}&searchKeyword=${currentSearchKeyword}&filterType=${currentFilterType}&filterStatus=${currentFilterStatus}" aria-label="Previous">
                    <span aria-hidden="true">«</span>
                </a>
            </li>
            <c:forEach begin="1" end="${totalPages}" var="page">
                <li class="page-item ${page == currentPage ? 'active' : ''}">
                    <a class="page-link" href="${pageContext.request.contextPath}/services/list?page=${page}&searchKeyword=${currentSearchKeyword}&filterType=${currentFilterType}&filterStatus=${currentFilterStatus}">${page}</a>
                </li>
            </c:forEach>
            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                <a class="page-link" href="${pageContext.request.contextPath}/services/list?page=${currentPage + 1}&searchKeyword=${currentSearchKeyword}&filterType=${currentFilterType}&filterStatus=${currentFilterStatus}" aria-label="Next">
                    <span aria-hidden="true">»</span>
                </a>
            </li>
        </ul>
    </nav>

    <%-- Footer --%>
    <div class="footer-top">
        <div class="pt-exebar">
            <div class="container">
                <div class="d-flex align-items-stretch">
                    <div class="pt-logo mr-auto">
                        <a href="${pageContext.request.contextPath}/Home"><img src="${pageContext.request.contextPath}/assets/images/logo-white.png" alt="Hoang Nam Hotel"/></a>
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
                        <a href="#" class="btn">Join Now</a>
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
                                    <input name="email" required="required" class="form-control" placeholder="Your Email Address" type="email">
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
                                    <li><a href="${pageContext.request.contextPath}/Home">Home</a></li>
                                    <li><a href="about-1.html">About</a></li>
                                    <li><a href="faq-1.jsp">FAQs</a></li>
                                    <li><a href="contact-1.jsp">Contact</a></li>
                                </ul>
                            </div>
                        </div>
                        <div class="col-4 col-lg-4 col-md-4 col-sm-4">
                            <div class="widget footer_widget">
                                <h5 class="footer-title">Get In Touch</h5>
                                <ul>
                                    <li><a href="${pageContext.request.contextPath}/admin/Home">Dashboard</a></li>
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
                                    <li><a href="${pageContext.request.contextPath}/roomlist">Rooms</a></li>
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
                            <li><a href="${pageContext.request.contextPath}/assets/images/gallery/pic1.jpg" class="magnific-anchor"><img src="${pageContext.request.contextPath}/assets/images/gallery/pic1.jpg" alt=""></a></li>
                            <li><a href="${pageContext.request.contextPath}/assets/images/gallery/pic2.jpg" class="magnific-anchor"><img src="${pageContext.request.contextPath}/assets/images/gallery/pic2.jpg" alt=""></a></li>
                            <li><a href="${pageContext.request.contextPath}/assets/images/gallery/pic3.jpg" class="magnific-anchor"><img src="${pageContext.request.contextPath}/assets/images/gallery/pic3.jpg" alt=""></a></li>
                            <li><a href="${pageContext.request.contextPath}/assets/images/gallery/pic4.jpg" class="magnific-anchor"><img src="${pageContext.request.contextPath}/assets/images/gallery/pic4.jpg" alt=""></a></li>
                            <li><a href="${pageContext.request.contextPath}/assets/images/gallery/pic5.jpg" class="magnific-anchor"><img src="${pageContext.request.contextPath}/assets/images/gallery/pic5.jpg" alt=""></a></li>
                            <li><a href="${pageContext.request.contextPath}/assets/images/gallery/pic6.jpg" class="magnific-anchor"><img src="${pageContext.request.contextPath}/assets/images/gallery/pic6.jpg" alt=""></a></li>
                            <li><a href="${pageContext.request.contextPath}/assets/images/gallery/pic7.jpg" class="magnific-anchor"><img src="${pageContext.request.contextPath}/assets/images/gallery/pic7.jpg" alt=""></a></li>
                            <li><a href="${pageContext.request.contextPath}/assets/images/gallery/pic8.jpg" class="magnific-anchor"><img src="${pageContext.request.contextPath}/assets/images/gallery/pic8.jpg" alt=""></a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="footer-bottom">
        <div class="container">
            <div class="row">
                <div class="col-12 text-center"><a target="_blank" href="https://www.templateshub.net">Templates Hub</a></div>
            </div>
        </div>
    </div>

    <%-- Nhúng Bootstrap JS và JavaScript tùy chỉnh --%>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Hiển thị thông báo nếu có (được gửi từ Servlet)
        let msg = '${msg}';
        console.log(msg);
        if (msg !== '') {
            alert(msg);
        }

        // Hàm chuyển đổi trạng thái dịch vụ
        function toggleStatus(serviceId) {
            fetch('${pageContext.request.contextPath}/services/toggle', {
                method: 'POST',
                headers: {'Content-Type': 'application/json'},
                body: JSON.stringify({id: serviceId})
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert(data.message || "Status updated.");
                    window.location.reload();
                } else {
                    alert(data.message || "Update failed.");
                }
            })
            .catch(error => {
                alert("Error: " + error.message);
            });
            
            setTimeout(() => {
                window.location.href='${pageContext.request.contextPath}/services/list';
            }, 1000);
        }

        // Hàm hiển thị hình ảnh dịch vụ trong modal
        function showImageModal(imagePath) {
            const fullPath = imagePath.startsWith('http') ? imagePath : '${pageContext.request.contextPath}/' + imagePath;
            document.getElementId("serviceImage").src = fullPath;
            const modal = new bootstrap.Modal(document.getElementById('imageModal'));
            modal.show();
        }
    </script>
</body>
</html>