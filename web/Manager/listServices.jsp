<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %><%@ page import="model.Account" %>
<%
    Account account = (Account) session.getAttribute("account");
    if (account == null || !"Manager".equals(account.getRole())) {
        response.sendRedirect("../login_2.jsp");
        return;
    }
%>
<html>
<head>
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
