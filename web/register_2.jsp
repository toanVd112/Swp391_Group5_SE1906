<%-- 
    Document   : register_2
    Created on : May 26, 2025, 11:13:10 AM
    Author     : Admin
--%>


<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="model.Account" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="keywords" content="" />
    <meta name="author" content="" />
    <meta name="robots" content="" />
    <meta name="description" content="Hoang Nam Hotel" />
    <meta property="og:title" content="Hoang Nam Hotel" />
    <meta property="og:description" content="Hoang Nam Hotel" />
    <meta name="format-detection" content="telephone=no">
    <link rel="icon" href="assets/images/favicon.ico" type="image/x-icon" />
    <link rel="shortcut icon" type="image/x-icon" href="assets/images/favicon.png" />
    <title>Hoang Nam Hotel - Register Staff</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- CSS -->
    <link rel="stylesheet" type="text/css" href="assets/css/assets.css">
    <link rel="stylesheet" type="text/css" href="assets/css/typography.css">
    <link rel="stylesheet" type="text/css" href="assets/css/shortcodes/shortcodes.css">
    <link rel="stylesheet" type="text/css" href="assets/css/style.css">
    <link class="skin" rel="stylesheet" type="text/css" href="assets/css/color/color-1.css">
</head>

<body id="bg">
    <%
        Account account = (Account) session.getAttribute("account");
        if (account == null || !"Manager".equals(account.getRole())) {
            response.sendRedirect("login_2.jsp");
            return;
        }
    %>

    <div class="page-wraper">
        <div id="loading-icon-bx"></div>
        <div class="account-form">
            <div class="account-head" style="background-image:url(assets/images/background/bg2.jpg);">
                <a href="Home">
                    <img src="assets/images/logo.png" alt="Hoang Nam Hotel Logo">
                </a>
            </div>
            <div class="account-form-inner">
                <div class="account-container">
                    <div class="heading-bx left">
                        <h2 class="title-head">Tạo tài khoản <span>nhân viên</span></h2>
                        <p>Bạn đã có tài khoản? <a href="login_2.jsp">Đăng nhập</a></p>
                    </div>
                    <form action="RegisterStaff" method="post" class="contact-bx">
                        <div class="row placeani">
                            <div class="col-lg-12">
                                <div class="form-group">
                                    <label>Username</label>
                                    <input name="username" type="text" required class="form-control">
                                </div>
                            </div>
                            <div class="col-lg-12">
                                <div class="form-group">
                                    <label>Password</label>
                                    <input name="password" type="password" required class="form-control">
                                </div>
                            </div>
                            <div class="col-lg-12">
                                <div class="form-group">
                                    <label>Email</label>
                                    <input name="email" type="email" required class="form-control">
                                </div>
                            </div>
                            <div class="col-lg-12">
                                <div class="form-group">
                                    <label>Role</label>
                                    <select name="role" class="form-control" required>
                                        <option value="Receptionist">Receptionist</option>
                                        <option value="Staff">Staff</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-lg-12 m-b30">
                                <button type="submit" class="btn button-md">Tạo tài khoản</button>
                            </div>
                        </div>
                    </form>

                    <%
                        String result = (String) request.getAttribute("result");
                        if (result != null) {
                    %>
                        <div class="alert alert-info">
                            <%= result %>
                        </div>
                    <%
                        }
                    %>
                </div>
            </div>
        </div>
    </div>

    <!-- JS -->
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
    <script src="assets/vendors/switcher/switcher.js"></script>
</body>

</html>
