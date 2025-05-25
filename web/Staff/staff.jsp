<%-- 
    Document   : staff
    Created on : May 24, 2025, 5:55:04 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
            /* === Dashboard Shared Styles === */

            body {
                font-family: 'Segoe UI', sans-serif;
                background-color: #f5f8fa;
                margin: 0;
                padding: 0;
            }

            .container {
                max-width: 900px;
                margin: 40px auto;
                padding: 30px;
                background-color: #ffffff;
                border-radius: 12px;
                box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
            }

            h1 {
                text-align: center;
                color: #2c3e50;
                font-size: 28px;
                margin-bottom: 20px;
            }

            h2 {
                color: #2980b9;
                margin-top: 30px;
                font-size: 22px;
                border-bottom: 2px solid #2980b9;
                padding-bottom: 6px;
            }

            ul {
                list-style-type: none;
                padding-left: 0;
            }

            ul li {
                margin: 10px 0;
            }

            a {
                text-decoration: none;
                color: #3498db;
                font-weight: 500;
                transition: color 0.3s ease;
            }

            a:hover {
                color: #1abc9c;
            }

            .logout-btn {
                display: inline-block;
                margin-top: 40px;
                padding: 10px 20px;
                background-color: #e74c3c;
                color: #fff;
                border-radius: 6px;
                text-decoration: none;
                font-weight: bold;
                transition: background-color 0.3s ease;
            }

            .logout-btn:hover {
                background-color: #c0392b;
            }

        </style>
    </head>
    <body>
        <div class="container">
            <h1>Welcome, <%= account.getUsername() %> (Staff)</h1>

            <h2>Room Tasks</h2>
            <ul>
                <li><a href="roomList.jsp">View Room</a></li>
                <li><a href="updateRoomStatus.jsp">Update Room Status</a></li>
                <li><a href="roomReport.jsp">Send Room Status Report</a></li>
            </ul>

            <h2>Service Tasks</h2>
            <ul>
                <li><a href="viewServices.jsp">View Services</a></li>
                <li><a href="setServiceStatus.jsp">Set Service Status</a></li>
                <li><a href="serviceReport.jsp">Send Service Report</a></li>
                <li><a href="notifications.jsp">Receive Service Notifications</a></li>
            </ul>

            <a href="${pageContext.request.contextPath}/LogoutServlet">Logout</a>
        </div>
    </body>
</html>
