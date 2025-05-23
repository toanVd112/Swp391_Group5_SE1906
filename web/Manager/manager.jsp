<%-- 
    Document   : manager.jsp
    Created on : May 24, 2025, 5:54:42 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%><%@ page import="model.Account" %>
<%
    Account account = (Account) session.getAttribute("account");
    if (account == null || !"Manager".equals(account.getRole())) {
        response.sendRedirect("../login_2.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Manager Dashboard</title>
        <link rel="stylesheet" href="../assets/css/style.css">
        <style>
            body {
                font-family: 'Segoe UI', sans-serif;
                background-color: #f0f4f8;
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
                margin-bottom: 10px;
            }

            h2 {
                color: #34495e;
                margin-top: 30px;
                border-bottom: 2px solid #3498db;
                padding-bottom: 5px;
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

            a.logout {
                display: inline-block;
                margin-top: 30px;
                background-color: #e74c3c;
                color: #fff;
                padding: 10px 18px;
                border-radius: 6px;
                text-decoration: none;
                font-weight: bold;
                transition: background-color 0.3s ease;
            }

            a.logout:hover {
                background-color: #c0392b;
            }
        </style>

    </head>
    <body>
        <div class="container">
            <h1>Welcome, <%= account.getUsername() %> (Manager)</h1>
            <h2>Room Management</h2>
            <ul>
                <li><a href="roomTypes.jsp">View Room Type List</a></li>
                <li><a href="rooms.jsp">View Room List</a></li>
                <li><a href="roomStatus.jsp">View Room Status</a></li>
            </ul>

            <h2>Staff Management</h2>
            <ul>
                <li><a href="staffList.jsp">View Staff List</a></li>
                <li><a href="register.jsp">Add New Staff/Receptionist</a></li>
            </ul>

            <h2>Service & Feedback</h2>
            <ul>
                <li><a href="services.jsp">View Service List</a></li>
                <li><a href="feedbacks.jsp">View Feedback</a></li>
            </ul>

            <h2>Reports</h2>
            <ul>
                <li><a href="revenueReport.jsp">View Revenue Report</a></li>
            </ul>

            <br>
            <a class="nav-link" href="/HotelManagement/Logout">Logout</a>
        </div>
    </body>
</html>
