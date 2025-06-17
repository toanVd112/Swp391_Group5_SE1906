<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="model.Account" %>

<%
    Account account = (Account) session.getAttribute("account");
    if (account == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    request.setAttribute("role", account.getRole());
    request.setAttribute("username", account.getUsername());
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hoang Nam Hotel - Management System</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/layout.css">
</head>
<body>
    <div class="layout-container">
        <!-- Sidebar -->
        <%@ include file="/sidebar.jsp" %>
        
        <!-- Main Content -->
        <div class="main-content">
            <!-- Header -->
            <%@ include file="/header.jsp" %>
            
            <!-- Page Content -->
            <main class="content-area">
                <jsp:include page="${param.page != null ? param.page : 'dashboard.jsp'}" />
            </main>
            
            <!-- Footer -->
            <%@ include file="/footer.jsp" %>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Custom JS -->
    <script src="${pageContext.request.contextPath}/assets/js/layout.js"></script>
</body>
</html>