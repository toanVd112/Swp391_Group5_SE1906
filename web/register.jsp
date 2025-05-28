<%-- 
    Document   : register
    Created on : May 22, 2025, 3:28:45 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
        <meta name="description" content="Hoang Nam Hotel" />

        <!-- OG -->
        <meta property="og:title" content="Hoang Nam Hotel" />
        <meta property="og:description" content="Hoang Nam Hotel" />
        <meta property="og:image" content="" />
        <meta name="format-detection" content="telephone=no">

        <!-- FAVICONS ICON ============================================= -->
        <link rel="icon" href="assets/images/favicon.ico" type="image/x-icon" />
        <link rel="shortcut icon" type="image/x-icon" href="assets/images/favicon.png" />

        <!-- PAGE TITLE HERE ============================================= -->
        <title>Hoang Nam Hotel </title>

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
            <div class="account-form">
                <div class="account-head" style="background-image:url(assets/images/background/bg2.jpg);">
                    <a href="Home"><img src="https://sdmntprcentralus.oaiusercontent.com/files/00000000-d6e4-61f5-b8f5-ed132ce8136d/raw?se=2025-05-23T18%3A54%3A16Z&sp=r&sv=2024-08-04&sr=b&scid=d42d4d8a-3666-5c1c-aed3-eecb2c5f8c56&skoid=add8ee7d-5fc7-451e-b06e-a82b2276cf62&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2025-05-22T19%3A19%3A10Z&ske=2025-05-23T19%3A19%3A10Z&sks=b&skv=2024-08-04&sig=P147Fz%2B1AhPFYZ2ShbDI9hITzNLLl17opDMuAL%2B9dcI%3D" alt=""></a>
                </div>
                <div class="account-form-inner">
                    <div class="account-container">
                        <div class="heading-bx left">
                            <h2 class="title-head">Sign Up <span>Now</span></h2>
                            <p>Already have an account? <a href="login_2.jsp">Click here</a></p>
                        </div>	
                        <form action="Register" method="post" class="contact-bx">
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

                                <div class="col-lg-12 m-b30">
                                    <button type="submit" class="btn button-md">Sign Up</button>
                                </div>
                            </div>
                        </form>
                        <%
                          String result = (String) request.getAttribute("result");
                        %>

                        <% if (result != null) { %>
                        <div class="alert alert-info">
                            <%= result %>
                        </div>
                        <% } %>

                    </div>
                </div>
            </div>
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
    </body>

</html>
