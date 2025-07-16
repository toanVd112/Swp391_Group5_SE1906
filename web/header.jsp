<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<header class="header">
    <!-- Top Bar -->
    <div class="top-bar">
        <div class="container-fluid">
            <div class="d-flex justify-content-between align-items-center">
                <div class="d-flex align-items-center gap-4">
                    <a href="${pageContext.request.contextPath}/faq.jsp" class="top-link">
                        <i class="fas fa-question-circle me-1"></i>
                        Ask a Question
                    </a>
                    <a href="mailto:support@website.com" class="top-link">
                        <i class="fas fa-envelope me-1"></i>
                        Support@website.com
                    </a>
                </div>
                <div class="d-flex align-items-center gap-3">
                    

                    <div class="topbar-right">
                                <ul>
                                    <c:choose>
                                        <c:when test="${sessionScope.account != null}">
                                            <li class="nav-item">
                                                <a class="nav-link" href="${pageContext.request.contextPath}/user-profile">Hello, ${sessionScope.account.username}</a>
                                            </li>
<!--                                            <li class="nav-item">
                                                <a class="nav-link" href="${pageContext.request.contextPath}/Logout">Logout</a>
                                            </li>-->
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
    </div>

    <!-- Main Header -->
    <div class="main-header">
        <div class="container-fluid">
            <div class="d-flex justify-content-between align-items-center">
                <div class="d-flex align-items-center">

                    <a href="${pageContext.request.contextPath}/Home"><img src="${pageContext.request.contextPath}/assets/images/logo.png" alt=""  class="logo"></a>
                </div>

                <nav class="d-none d-md-flex align-items-center gap-4">
                    <a href="${pageContext.request.contextPath}/Home" class="nav-link">Home</a>
                    <a href="${pageContext.request.contextPath}/pages.jsp" class="nav-link">Pages</a>
                    <a href="${pageContext.request.contextPath}/hotel.jsp" class="nav-link">Our Hotel</a>
                    <a href="${pageContext.request.contextPath}/blog.jsp" class="nav-link">Blog</a>
                    <a href="${pageContext.request.contextPath}/layout.jsp?page=dashboard.jsp" class="nav-link">Dashboard</a>
                </nav>

                <div class="d-flex align-items-center gap-3">
                    <div class="search-box">
                        <input type="text" class="form-control" placeholder="Type to search...">
                        <i class="fas fa-search search-icon"></i>
                    </div>
                    <div class="dropdown">
                        <button class="btn btn-outline-secondary" type="button" data-bs-toggle="dropdown">
                            <i class="fas fa-user"></i>
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/user-profile">Profile</a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/settings.jsp">Settings</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/Logout">Logout</a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
</header>