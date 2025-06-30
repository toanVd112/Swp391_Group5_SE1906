<%-- 
    Document   : user_profile2
    Created on : Jun 19, 2025, 9:23:32 AM
    Author     : AD
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
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

    <!-- FAVICONS ICON ============================================= -->
    <link rel="icon" href="assets/images/favicon1.ico" type="image/x-icon" />
    <link rel="shortcut icon" type="image/x-icon" href="assets/images/favicon1.png" />

    <!-- PAGE TITLE HERE ============================================= -->
    <title>HoangNam Hotel</title>

    <!-- MOBILE SPECIFIC ============================================= -->
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- All PLUGINS CSS ============================================= -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Customer/profile.css">

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
            const nameRegex = /^[a-zA-ZÀ-?\s]+$/;
            const emailRegex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
            const phoneRegex = /^\d{10}$/;
            const dateRegex = /^\d{4}-\d{2}-\d{2}$/;
            let errors = [];

            if (!fullName || fullName.trim() === "") {
                errors.push("H? và tên không ???c ?? tr?ng!");
            } else if (fullName.length > 100) {
                errors.push("H? và tên không ???c v??t quá 100 ký t?!");
            } else if (!nameRegex.test(fullName)) {
                errors.push("H? và tên ch? ???c ch?a ch? cái và kho?ng tr?ng!");
            }
            if (!emailRegex.test(email)) {
                errors.push("??nh d?ng email không h?p l?!");
            }
            if (!phoneRegex.test(phone)) {
                errors.push("S? ?i?n tho?i ph?i là 10 ch? s?!");
            }
            if (dateOfBirth && !dateRegex.test(dateOfBirth)) {
                errors.push("??nh d?ng ngày sinh không h?p l?! S? d?ng YYYY-MM-DD.");
            }
            if (errors.length > 0) {
                alert(errors.join("\n"));
                return false;
            }
            return true;
        }

        // Preview ?nh
        document.addEventListener("DOMContentLoaded", function() {
            const photoInput = document.getElementById("photo");
            if (photoInput) {
                photoInput.addEventListener("change", function(event) {
                    const file = event.target.files[0];
                    if (file) {
                        const reader = new FileReader();
                        reader.onload = function(e) {
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
    <div class="profile-container">
        <div class="profile-header">
            <div class="avatar-container">
                <div class="avatar">
                    <c:choose>
                        <c:when test="${not empty user.avatarPath}">
                            <img src="${pageContext.request.contextPath}/${user.avatarPath}" alt="Avatar">
                        </c:when>
                        <c:otherwise>
                            <span class="avatar-initials">
                                <c:choose>
                                    <c:when test="${not empty user.fullName}">
                                        ${fn:substring(user.fullName, 0, 1)}
                                    </c:when>
                                    <c:otherwise>?</c:otherwise>
                                </c:choose>
                            </span>
                        </c:otherwise>
                    </c:choose>
                </div>
                <button class="camera-btn">
                    <svg class="icon" viewBox="0 0 24 24">
                        <path d="M12 15.5A3.5 3.5 0 0 1 8.5 12A3.5 3.5 0 0 1 12 8.5a3.5 3.5 0 0 1 3.5 3.5a3.5 3.5 0 0 1-3.5 3.5m7.43-2.53c.04-.32.07-.64.07-.97c0-.33-.03-.65-.07-.97l2.11-1.63c.19-.15.24-.42.12-.64l-2-3.46c-.12-.22-.39-.31-.61-.22l-2.49 1c-.52-.39-1.06-.73-1.69-.98l-.37-2.65A.506.506 0 0 0 14 2h-4c-.25 0-.46.18-.5.42l-.37 2.65c-.63.25-1.17.59-1.69.98l-2.49-1c-.22-.09-.49 0-.61.22l-2 3.46c-.13.22-.07.49.12.64L4.57 11c-.04.32-.07.65-.07.97c0 .33.03.65.07.97L2.46 14.6c-.19.15-.24.42-.12.64l2 3.46c.12.22.39.31.61.22l2.49-1c.52.39 1.06.73 1.69.98l.37 2.65c.04.24.25.42.5.42h4c.25 0 .46-.18.5-.42l.37-2.65c.63-.25 1.17-.59 1.69-.98l2.49 1c.22.09.49 0 .61-.22l2-3.46c.12-.22.07-.49-.12-.64l-2.11-1.63Z"/>
                    </svg>
                </button>
            </div>
            <div class="profile-name"><c:out value="${user.fullName}"/></div>
            <div class="profile-email"><c:out value="${user.email}"/></div>
            <div class="profile-phone"><c:out value="${user.phone}"/></div>
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
                    <label class="form-label" for="username">Tên ??ng nh?p</label>
                    <div class="readonly-field"><c:out value="${account.username}"/></div>
                </div>
                <div class="form-group">
                    <label class="form-label" for="role">Vai trò</label>
                    <div class="readonly-field"><c:out value="${account.role}"/></div>
                </div>
                <div class="form-group">
                    <label class="form-label" for="fullName">H? và tên</label>
                    <input type="text" id="fullName" name="fullName" class="form-input" value="${not empty tempFullName ? tempFullName : user.fullName}" required>
                </div>
                <div class="form-group">
                    <label class="form-label" for="email">??a ch? email</label>
                    <input type="email" id="email" name="email" class="form-input" value="${not empty tempEmail ? tempEmail : user.email}" required>
                </div>
                <div class="form-group">
                    <label class="form-label" for="phone">S? ?i?n tho?i</label>
                    <div class="phone-input">
                        <span class="phone-prefix">+84</span>
                        <input type="tel" id="phone" name="phone" class="form-input with-prefix" value="${not empty tempPhone ? tempPhone : user.phone}" required>
                    </div>
                </div>
                <div class="form-group">
                    <label class="form-label" for="dateOfBirth">Ngày sinh</label>
                    <input type="date" id="dateOfBirth" name="dateOfBirth" class="form-input" <%= dobAttr %>>
                </div>
                <div class="form-group">
                    <label class="form-label" for="address">??a ch?</label>
                    <textarea id="address" name="address" class="form-input form-textarea" placeholder="Nh?p ??a ch? c?a b?n"><c:out value="${not empty tempAddress ? tempAddress : user.address}"/></textarea>
                </div>
                <div class="form-group">
                    <label class="form-label" for="photo">?nh ??i di?n</label>
                    <input type="file" id="photo" name="photo" class="form-input" accept="image/*">
                </div>
                <div class="btn-group">
                    <button type="submit" class="btn btn-primary">
                        <svg class="icon" viewBox="0 0 24 24">
                            <path d="M15,9H5V5H15M12,19A3,3 0 0,1 9,16A3,3 0 0,1 12,13A3,3 0 0,1 15,16A3,3 0 0,1 12,19M17,3H5C3.89,3 3,3.9 3,5V19A2,2 0 0,0 5,21H19A2,2 0 0,0 21,19V7L17,3Z"/>
                        </svg>
                        L?u h? s?
                    </button>
                    <button type="reset" class="btn btn-secondary">
                        <svg class="icon" viewBox="0 0 24 24">
                            <path d="M12,2A10,10 0 0,0 2,12A10,10 0 0,0 12,22A10,10 0 0,0 22,12A10,10 0 0,0 12,2M12,4A8,8 0 0,1 20,12A8,8 0 0,1 12,20A8,8 0 0,1 4,12A8,8 0 0,1 12,4M14,12A2,2 0 0,1 12,14A2,2 0 0,1 10,12A2,2 0 0,1 12,10A2,2 0 0,1 14,12Z"/>
                        </svg>
                        ??t l?i
                    </button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>