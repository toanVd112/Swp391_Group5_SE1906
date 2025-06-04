

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.Account" %>
<%
    Account account = (Account) session.getAttribute("account");
    if (account == null || !"Receptionist".equals(account.getRole())) {
        response.sendRedirect("../login_2.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Receptionist Dashboard</title>
        <link href="https://fonts.googleapis.com/css2?family=Roboto&display=swap" rel="stylesheet">
        <style>
            body {
                font-family: 'Roboto', sans-serif;
                margin: 0;
                padding: 0;
                display: flex;
                background-color: #f4f7f9;
            }

            /* Sidebar style */
            #sidebar {
                width: 240px;
                background-color: #6a1b9a; /* tím */
                padding: 20px;
                box-shadow: 2px 0 12px rgba(0, 0, 0, 0.15);
                height: 100vh;
                position: fixed;
                color: #fff;
            }

            #sidebar h2 {
                font-size: 20px;
                margin-bottom: 20px;
                color: #fff;
            }

            #sidebar ul {
                list-style: none;
                padding: 0;
            }

            #sidebar li {
                margin: 12px 0;
            }

            #sidebar a {
                text-decoration: none;
                color: #ffffff;
                display: block;
                padding: 8px 12px;
                border-radius: 6px;
                transition: background-color 0.3s, color 0.3s;
            }

            #sidebar a:hover {
                background-color: #ffffff;
                color: #6a1b9a;
            }

            #sidebar a.active {
                background-color: #ffffff;
                color: #6a1b9a;
                font-weight: bold;
            }

            #sidebar hr {
                border: 0;
                height: 1px;
                background: rgba(255, 255, 255, 0.2);
                margin: 16px 0;
            }

            .logout {
                display: inline-block;
                margin-top: 20px;
                color: #fff;
                background-color: #e74c3c;
                padding: 6px 10px;
                border-radius: 4px;
                text-decoration: none;
            }

            .logout:hover {
                background-color: #c0392b;
            }

            /* Main content style */
            .main-content {
                margin-left: 260px;
                padding: 30px;
                flex: 1;
            }

            .main-content h1 {
                font-size: 24px;
                margin-bottom: 20px;
                color: #2c3e50;
            }

            .card {
                background-color: #fff;
                border-radius: 10px;
                padding: 25px;
                box-shadow: 0 0 12px rgba(0,0,0,0.1);
            }
        </style>
    </head>

    <body>
        <%@ include file="sidebarRecep.jsp" %>

        <div class="main-content">
            <h1>Welcome to Receptionist Dashboard</h1>
            <div class="card">
                <p>Use the sidebar to manage bookings, services, and guest information.</p>
            </div>
        </div>

    </body>
</html>
