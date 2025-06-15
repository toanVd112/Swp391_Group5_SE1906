<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Account" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    Account account = (Account) session.getAttribute("account");
    if (account == null || !"Staff".equals(account.getRole())) {
        response.sendRedirect("../login_2.jsp");
        return;
    }
    request.setAttribute("role", account.getRole());
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Receptionist Dashboard</title>


        <!-- CSS giống manager -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/Staff/staff.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/Staff/sidebar3.css" />

    <body>
        <div class="main-wrapper" id="mainWrapper">
            <%@ include file="/header.jsp" %>

            <div class="main-content" id="main-content">
                <jsp:include page="${param.page}" />
            </div>
            <%@ include file="/footer.jsp" %>
        </div>
        <button class="toggle-btn" onclick="toggleSidebar()">☰</button>
        <%@ include file="/sidebar.jsp" %>

        <!-- Wrapper chứa header và nội dung chính -->


        <script>
            function toggleSidebar() {
                const sidebar = document.querySelector('.sidebar');
                const wrapper = document.getElementById('mainWrapper');
                sidebar.classList.toggle('expanded');
                wrapper.classList.toggle('expanded');
            }
        </script>


    </body>
</html>
