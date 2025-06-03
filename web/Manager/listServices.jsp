<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="model.Account" %>
<%
    Account account = (Account) session.getAttribute("account");
    if (account == null || !"Manager".equals(account.getRole())) {
        response.sendRedirect("../login_2.jsp");
        return;
    }
%>
<html>
<head>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 40px;
            background-color: #f4f4f4;
        }

        h2 {
            color: #333;
            margin-bottom: 20px;
        }

        a {
            text-decoration: none;
            font-weight: bold;
            color: #0066cc;
        }

        a:hover {
            color: #003366;
        }

        .add-btn {
            display: inline-block;
            background-color: #28a745;
            color: white;
            padding: 8px 12px;
            margin-bottom: 15px;
            border-radius: 4px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background-color: white;
            box-shadow: 0 0 8px rgba(0, 0, 0, 0.1);
        }

        th, td {
            padding: 12px;
            border: 1px solid #ddd;
            text-align: center;
        }

        th {
            background-color: #f2f2f2;
        }

        .action-links a {
            margin: 0 5px;
            color: #007bff;
        }

        .action-links a:hover {
            color: red;
        }
    </style>
    <title>Danh sách dịch vụ</title>
</head>
<body>
    
    <h2>Danh sách dịch vụ</h2>
    <a href="services?action=add">➕ Thêm dịch vụ</a>
    <br><br>
    <table border="1" cellpadding="10" cellspacing="0">
        <tr>
            <th>ID</th>
            <th>Tên</th>
            <th>Mô tả</th>
            <th>Giá</th>
            <th>Trạng thái</th>
            <th>Hành động</th>
        </tr>
        <c:forEach var="s" items="${services}">
            <tr>
                <td>${s.serviceID}</td>
                <td>${s.serviceName}</td>
                <td>${s.description}</td>
                <td>${s.price}</td>
                <td>${s.status ? "Hoạt động" : "Ngừng"}</td>
                <td>
                    <a href="services?action=edit&id=${s.serviceID}">Sửa</a> |
                    <a href="services?action=delete&id=${s.serviceID}" onclick="return confirm('Bạn chắc chắn muốn xóa?')">Xóa</a>
                </td>
            </tr>
        </c:forEach>
    </table>
</body>
</html>
