<%-- 
    Document   : staff
    Created on : May 24, 2025, 5:55:04 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Hello World!</h1>
    <c:if test="${sessionScope.user != null}">
        <li class="nav-item">
            <a class="nav-link" href="#">Hello, ${sessionScope.user.username}</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="Logout">Logout</a>
        </li>
    </c:if>
    <c:if test="${sessionScope.user == null}">
        <li class="nav-item">
            <a class="nav-link" href="login_2.jsp">Login</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="register_2.jsp">Register</a>
        </li>
    </c:if>
</body>
</html>
