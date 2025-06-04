<%@page contentType="text/html;charset=UTF-8"%>
<%@ page import="model.Account" %>
<%
    Account account = (Account) session.getAttribute("account");
    if (account == null || !"Staff".equals(account.getRole())) {
        response.sendRedirect("../login_2.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Staff Dashboard</title>
        <link rel="stylesheet" href="../assets/css/style.css">
        <style>
            body {
                font-family: 'Segoe UI', sans-serif;
                margin: 0;
                padding: 0;
                display: flex;
                background-color: #f5f8fa;
            }

            .main-content {
                margin-left: 260px;
                padding: 30px;
                width: calc(100% - 260px);
                box-sizing: border-box;
            }

            .main-content h1 {
                color: #2c3e50;
                margin-bottom: 20px;
            }

            .card {
                background-color: #fff;
                border-radius: 10px;
                padding: 25px;
                box-shadow: 0 0 12px rgba(0, 0, 0, 0.05);
            }
        </style>
    </head>
    <body>

        <%@ include file="sidebarStaff.jsp" %>

        <div class="main-content">
            <h1>Welcome to your dashboard</h1>
            <div class="card">
                <p>Please use the sidebar to manage your tasks.</p>
            </div>
        </div>

    </body>
</html>
