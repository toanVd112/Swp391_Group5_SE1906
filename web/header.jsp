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
                    <div class="dropdown">
                        <button class="btn btn-sm btn-outline-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown">
                            <i class="fas fa-globe me-1"></i>
                            English UK
                        </button>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="#">English UK</a></li>
                            <li><a class="dropdown-item" href="#">English US</a></li>
                        </ul>
                    </div>

                    <c:if test="${sessionScope.account != null}">
                        <span class="text-muted">Hello, ${username}</span>
                        <a href="${pageContext.request.contextPath}/Logout" class="btn btn-sm btn-outline-danger">Logout</a>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <!-- Main Header -->
    <div class="main-header">
        <div class="container-fluid">
            <div class="d-flex justify-content-between align-items-center">
                <div class="d-flex align-items-center">

                    <a href="Home"><img src="assets/images/logo.png" alt=""  class="logo"></a>
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
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile.jsp">Profile</a></li>
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