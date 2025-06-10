<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="model.Account" %>
<%
    Account account = (Account) session.getAttribute("account");
    if (account == null || !"Manager".equals(account.getRole())) {
        response.sendRedirect("../login_2.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <%@ include file="/header.jsp" %>
        <style>
            .nav-menu {
                max-width: 900px;
                margin: 60px auto;
                padding: 40px;
                background: #ffffff;
                border-radius: 20px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.06);
                text-align: center;
                font-family: 'Roboto', sans-serif;
            }

            .nav-menu h2 {
                font-size: 28px;
                font-weight: 700;
                color: #0f172a;
                margin-bottom: 40px;
            }

            .menu-grid {
                display: flex;
                justify-content: center;
                gap: 20px;
                flex-wrap: wrap;
            }

            .menu-grid a {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
                padding: 12px 24px;
                font-size: 16px;
                font-weight: 500;
                color: white;
                background-color: #3b82f6;
                text-decoration: none;
                border-radius: 12px;
                box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
                transition: background-color 0.3s, transform 0.2s;
            }

            .menu-grid a:hover {
                background-color: #2563eb;
                transform: translateY(-2px);
            }

            .menu-grid a.logout {
                background-color: #ef4444;
            }

            .menu-grid a.logout:hover {
                background-color: #dc2626;
            }


        </style>
    </head>
    <body>
        <div class="wrapper">
            <div class="nav-menu">
                <h2>Manager Dashboard</h2>
                <div class="menu-grid">
                    <a href="${pageContext.request.contextPath}/managerAccount">👥 Manage Account</a>
                    <a href="${pageContext.request.contextPath}/services/list">🔔 Service List</a>
                    <a class="logout" href="${pageContext.request.contextPath}/Logout">🧾 Logout</a>
                </div>
            </div>
        </div>
        <%@ include file="/footer.jsp" %>
    </body>


</html>
