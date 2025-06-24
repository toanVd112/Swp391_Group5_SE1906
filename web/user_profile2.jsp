<%-- 
    Document   : user_profile2
    Created on : Jun 19, 2025, 9:23:32 AM
    Author     : AD
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:useBean id="user" class="model.User" scope="session" />

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
        <meta property="og:title" content="Hoang Nam Hotel" />
        <meta property="og:description" content="HoangNam Hotel" />
        <meta property="og:image" content="" />
        <meta name="format-detection" content="telephone=no">

        <!-- FAVICON1S ICON ============================================= -->
        <link rel="icon" href="assets/images/favicon1.ico" type="image/x-icon" />
        <link rel="shortcut icon" type="image/x-icon" href="assets/images/favicon1.png" />

        <!-- PAGE TITLE HERE ============================================= -->
        <title>HoangNam Hotel</title>

        <!-- MOBILE SPECIFIC ============================================= -->
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!-- All PLUGINS CSS ============================================= -->
        <link rel="stylesheet" href="Customer/profile.css">


    </head>
    
    <body>
    <div class="profile-container">
        <div class="profile-header">
            <div class="avatar-container">
                <div class="avatar">
                    <span class="avatar-initials">
                        <c:choose>
                            <c:when test="${not empty user.fullName}">
                                ${fn:substring(user.fullName, 0, 1)}
                            </c:when>
                        <c:otherwise>?</c:otherwise>
                    </span>
                </div>
                <button class="camera-btn">
                    <svg class="icon" viewBox="0 0 24 24">
                        <path d="M12 15.5A3.5 3.5 0 0 1 8.5 12A3.5 3.5 0 0 1 12 8.5a3.5 3.5 0 0 1 3.5 3.5a3.5 3.5 0 0 1-3.5 3.5m7.43-2.53c.04-.32.07-.64.07-.97c0-.33-.03-.65-.07-.97l2.11-1.63c.19-.15.24-.42.12-.64l-2-3.46c-.12-.22-.39-.31-.61-.22l-2.49 1c-.52-.39-1.06-.73-1.69-.98l-.37-2.65A.506.506 0 0 0 14 2h-4c-.25 0-.46.18-.5.42l-.37 2.65c-.63.25-1.17.59-1.69.98l-2.49-1c-.22-.09-.49 0-.61.22l-2 3.46c-.13.22-.07.49.12.64L4.57 11c-.04.32-.07.65-.07.97c0 .33.03.65.07.97L2.46 14.6c-.19.15-.24.42-.12.64l2 3.46c.12.22.39.31.61.22l2.49-1c.52.39 1.06.73 1.69.98l.37 2.65c.04.24.25.42.5.42h4c.25 0 .46-.18.5-.42l.37-2.65c.63-.25 1.17-.59 1.69-.98l2.49 1c.22.09.49 0 .61-.22l2-3.46c.12-.22.07-.49-.12-.64l-2.11-1.63Z"/>
                    </svg>
                </button>
            </div>
            <div class="profile-name">${user.fullName}</div>
            <div class="profile-email">${user.email}</div>
            <div class="profile-phone">${user.phone}</div>
        </div>
        
        <!-- Hi?n th? l?i n?u có -->
        <c:if test="${not empty errorMessage}">
            <div class="error-message" style="color: red; text-align:center; margin: 10px 0;">
                ${errorMessage}
            </div>
        </c:if>

        <div class="profile-content">
            <form class="profile-form" method="post" action="profile">
                <div class="form-group">
                    <label class="form-label" for="fullName">Full Name</label>
                    <input type="text" id="fullName" class="form-input" value="${not empty tempFullName ? tempFullName : user.fullName}">
                </div>

                <div class="form-group">
                    <label class="form-label" for="email">Email Address</label>
                    <input type="email" id="email" class="form-input" value="${not empty tempEmail ? tempEmail : user.email}">
                </div>

                <div class="form-group">
                    <label class="form-label" for="phone">Phone Number</label>
                    <div class="phone-input">
                        <span class="phone-prefix">+1</span>
                        <input type="tel" id="phone" class="form-input with-prefix" value="${not empty tempPhone ? tempPhone : user.phone}">
                    </div>
                </div>

                <!-- Date of Birth -->
                <div class="form-group">
                    <label for="dateOfBirth">Date of Birth</label>
                    <input type="date" id="dateOfBirth" name="dateOfBirth" class="form-input" <%= dobAttr %> />
                </div>

                <!-- Address -->
                <div class="form-group">
                    <label for="address">Address</label>
                    <textarea id="address" name="address" class="form-input form-textarea"
                              placeholder="Enter your full address"><c:out value='${not empty tempAddress ? tempAddress : user.address}'/></textarea>
                </div>

                <div class="form-group">
                    <label class="form-label" for="photo">Profile Photo</label>
                    <input type="file" id="photo" class="form-input" accept="image/*">
                </div>

                <!-- Buttons -->
                <div class="btn-group">
                    <button type="submit" class="btn btn-primary">Save Profile</button>
                    <button type="reset" class="btn btn-secondary">Reset</button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
