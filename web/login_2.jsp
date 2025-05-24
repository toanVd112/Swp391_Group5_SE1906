<%-- 
    Document   : login_2.jsp
    Created on : May 23, 2025, 8:56:04 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Staff Login</title>
        <link rel="stylesheet" href="assets/css/style.css">
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
            <div class="account-form">
                <div class="account-head" style="background-image:url(assets/images/background/bg2.jpg);">
                    <a href="index.html"><img src="assets/images/logo-white-2.png" alt=""></a>
                </div>
                <div class="account-form-inner">
                    <div class="account-container">
                        <div class="heading-bx left">
                            <h2 class="title-head">Manager,Staff,Receptionist Login <span>Portal</span></h2>
                            <p>Return to main login? <a href="login.jsp">Click here</a></p>
                        </div>

                        <!-- FORM -->
                        <form action="LoginStaff" method="post" class="contact-bx">
                            <div class="row placeani">
                                <div class="col-lg-12">
                                    <div class="form-group">
                                        <label>Username</label>
                                        <input name="username" type="text" class="form-control" required>
                                    </div>
                                </div>

                                <div class="col-lg-12">
                                    <div class="form-group">
                                        <label>Password</label>
                                        <input name="password" type="password" class="form-control" required>
                                    </div>
                                </div>

                                <!-- ROLE SELECTION -->
                                <div class="col-lg-12">
                                    <div class="form-group">
                                        <label>Role</label>
                                        <select name="role" class="form-control" required>
                                            <option value="Manager">Manager</option>
                                            <option value="Receptionist">Receptionist</option>
                                            <option value="Staff">Staff</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="col-lg-12 m-b30">
                                    <button type="submit" class="btn button-md">Login</button>
                                </div>
                            </div>
                        </form>

                        <% String result = (String) request.getAttribute("result"); %>
                        <% if (result != null) { %>
                        <div class="alert alert-danger"><%= result %></div>
                        <% } %>

                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
