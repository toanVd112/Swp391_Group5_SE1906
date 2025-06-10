<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="model.Account" %>
<%
    Account account = (Account) session.getAttribute("account");
    if (account == null || !"Receptionist".equals(account.getRole())) {
        response.sendRedirect("../login_2.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <%@ include file="/header.jsp" %> <!-- Gồm phần <meta>, CSS, logo, menu... -->
        <style>
            .nav-menu {
                max-width: 900px;
                margin: 60px auto;
                padding: 30px;
                background: #fff;
                border-radius: 12px;
                box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
                text-align: center;
            }

            .nav-menu h2 {
                font-size: 24px;
                color: #1e3a8a;
                margin-bottom: 30px;
            }

            .menu-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
                gap: 20px;
            }

            .menu-grid a {
                display: block;
                padding: 14px;
                background: #3b82f6;
                color: white;
                text-decoration: none;
                border-radius: 8px;
                font-weight: 500;
                box-shadow: 0 2px 6px rgba(0,0,0,0.1);
                transition: background 0.3s;
            }

            .menu-grid a:hover {
                background: #2563eb;
            }

            .menu-grid .logout {
                background: #ef4444;
            }

            .menu-grid .logout:hover {
                background: #dc2626;
            }
        </style>


    </head>
    <body>
        <div class="wrapper">
            <!-- Sidebar -->
            <div class="nav-menu">
                <h2> Receptionist Dashbord</h2>
                <div class="menu-grid">
                    <a href="${pageContext.request.contextPath}/ListRoomsServlet1">📋 View Room List</a>
                    <a href="${pageContext.request.contextPath}/assignStaffServlet">📅 Assign Task to staff</a>
                  
                   
                    <a class="logout" href="${pageContext.request.contextPath}/LogoutServlet">🚪 Logout</a>
                </div>
            </div>


            <%@ include file="/footer.jsp" %> <!-- Gồm script, thông tin cuối trang -->
    </body>
</html>
