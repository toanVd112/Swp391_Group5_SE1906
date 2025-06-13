<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Account" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    Account account = (Account) session.getAttribute("account");
    if (account == null || !"Manager".equals(account.getRole())) {
        response.sendRedirect("../login_2.jsp");
        return;
    }
    request.setAttribute("role", account.getRole());
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Manager Dashboard</title>
        <%@ include file="/header.jsp" %>


        <link rel="stylesheet" type="text/css" href="Manager/manager.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/Manager/sidebar.css" />




    </head>

    <body>
        <button class="toggle-btn" onclick="toggleSidebar()">☰</button>
        <%@ include file="/sidebar.jsp" %>

        <div class="main-content" id="main-content">
            <jsp:include page="${param.page}" />
        </div>
        <a href="${pageContext.request.contextPath}/managerAccount">👥 Manage Account</a>
        <script>
            function toggleSidebar() {
                const sidebar = document.querySelector('.sidebar');
                const mainContent = document.querySelector('.main-content');
                sidebar.classList.toggle('expanded');
                mainContent.classList.toggle('expanded');
            }
        </script>

        <%@ include file="/footer.jsp" %>
    </body>
</html>
