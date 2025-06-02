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
    <title>Sửa Dịch vụ</title>
</head>
<body>
   
    <h2>Sửa Dịch vụ</h2>

    <form action="services" method="post">
        <input type="hidden" name="id" value="${service.serviceID}" />

        <label>Tên dịch vụ:</label><br>
        <input type="text" name="name" value="${service.serviceName}" required><br><br>

        <label>Mô tả:</label><br>
        <textarea name="description" rows="4" cols="40">${service.description}</textarea><br><br>

        <label>Giá:</label><br>
        <input type="text" name="price" value="${service.price}" required><br><br>

        <label>Trạng thái:</label><br>
        <select name="status">
            <option value="1" ${service.status ? "selected" : ""}>Hoạt động</option>
            <option value="0" ${!service.status ? "selected" : ""}>Ngừng</option>
        </select><br><br>

        <input type="submit" value="Cập nhật">
    </form>

    <br><a href="services">← Quay lại danh sách</a>
</body>
</html>
