<%-- 
    Document   : login_2.jsp
    Created on : May 23, 2025, 8:56:04 PM
    Author     : Admin
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
                <div class="account-head" style="background-image:url(assets/images/background/bg2.jpg);"></div>
                <div class="account-form-inner">
                    <div class="account-container">
                        <div class="heading-bx left">
                            <h2 class="title-head">
                                Manager, Staff, Receptionist Login <span>Portal</span>
                            </h2>
                            <p>Customer? <a href="login.jsp">Customer Login here</a></p>
                        </div>

                        <!-- FORM -->
                        <form action="LoginStaff" method="post" class="contact-bx">
                            <div class="row placeani">
                                <div class="col-lg-12">
                                    <div class="form-group">
                                        <label>Username</label>
                                        <!-- đổ lại username nếu có -->
                                        <input name="username" type="text" class="form-control"
                                               required
                                               value="${username != null ? username : ''}">
                                    </div>
                                </div>

                                <div class="col-lg-12">
                                    <div class="form-group">
                                        <label>Password</label>
                                        <!-- thường không đổ password lại vì bảo mật -->
                                        <input name="password" type="password" class="form-control"
                                               required
                                               value="${pass != null ? pass : ''}">
                                    </div>
                                </div>

                                <!-- ROLE SELECTION -->
                                <div class="col-lg-12">
                                    <div class="form-group">
                                        <label>Role</label>
                                        <select name="role" class="form-control" required>
                                            <option value="Manager"
                                                    ${role=='Manager' ? 'selected="selected"' : ''}>
                                                Manager
                                            </option>
                                            <option value="Receptionist"
                                                    ${role=='Receptionist' ? 'selected="selected"' : ''}>
                                                Receptionist
                                            </option>
                                            <option value="Staff"
                                                    ${role=='Staff' ? 'selected="selected"' : ''}>
                                                Staff
                                            </option>
                                        </select>
                                    </div>
                                </div>

                                <div class="col-lg-12 m-b30">
                                    <button type="submit" class="btn button-md">Login</button>
                                </div>
                            </div>
                        </form>

                        <!-- Hiển thị lỗi nếu login thất bại -->
                        <c:if test="${not empty result}">
                            <p class="alert alert-danger">${result}</p>
                        </c:if>

                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
