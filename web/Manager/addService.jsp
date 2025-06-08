<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="model.Account" %>
<%@ page import="model.Service" %>
<%@ page import="DAO.ServiceDAO" %>
<%@ page import="java.util.List" %>
<%
    Account account = (Account) session.getAttribute("account");
    if (account == null || !"Manager".equals(account.getRole())) {
        response.sendRedirect("../login.jsp");
        return;
    }
    
    List<String> types = new ServiceDAO().getAllDistinctServiceType();
    request.setAttribute("serviceTypes", types);
%>
<html>
<head>
    <title>Thêm Dịch vụ</title>
    <style>
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background-color: #f5f6fa;
            margin: 0;
            padding: 20px;
            display: flex;
            justify-content: center;
            min-height: 100vh;
        }
        .container {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 500px;
        }
        h2 {
            color: #333;
            text-align: center;
            margin-bottom: 30px;
            font-size: 24px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 8px;
            color: #555;
            font-weight: 500;
        }
        input[type="text"],
        input[type="number"],
        textarea,
        select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
            box-sizing: border-box;
            transition: border-color 0.3s;
        }
        input[type="text"]:focus,
        input[type="number"]:focus,
        textarea:focus,
        select:focus {
            outline: none;
            border-color: #007bff;
            box-shadow: 0 0 5px rgba(0,123,255,0.3);
        }
        textarea {
            resize: vertical;
            min-height: 100px;
        }
        input[type="submit"] {
            background-color: #007bff;
            color: white;
            padding: 12px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            width: 100%;
            transition: background-color 0.3s;
        }
        input[type="submit"]:hover {
            background-color: #0056b3;
        }
        .back-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            color: #007bff;
            text-decoration: none;
            font-size: 16px;
        }
        .back-link:hover {
            text-decoration: underline;
        }
        @media (max-width: 600px) {
            .container {
                padding: 20px;
            }
            h2 {
                font-size: 20px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Thêm Dịch vụ mới</h2>
       <form action="${pageContext.request.contextPath}/addService" method="post">
            <div class="form-group">
                <label for="name">Tên dịch vụ:</label>
                <input type="text" id="name" name="name" required>
            </div>
            <div class="form-group">
                <label for="description">Mô tả:</label>
                <textarea id="description" name="description" rows="4"></textarea>
            </div>
            <div class="form-group">
                <label for="price">Giá:</label>
                <input type="number" id="price" step="1" name="price" required>
            </div>
            <div class="form-group">
                <label for="status">Trạng thái:</label>
                <select id="status" name="status">
                    <option value="1" selected>Hoạt động</option>
                    <option value="0">Ngừng Hoạt động</option>
                </select>
            </div>
            <div class="form-group">
                <label for="serviceType">Loại dịch vụ:</label>
                <select id="serviceType" name="serviceType">
                    <option value="">Chọn loại</option>
                    <c:forEach var="type" items="${serviceTypes}">  <%-- items="${serviceTypes}" --%>
            <option value="${type}" ${service.type eq type ? 'selected' : ''}>${type}</option>
        </c:forEach>
                </select>
            </div>
            <div class="form-group">
                <label for="serviceImage">Hình ảnh:</label>
                <input type="text" id="serviceImage" name="serviceImage">
            </div>
            <input type="submit" value="Lưu">
        </form>
        <a class="back-link" href="${pageContext.request.contextPath}/services/list">← Quay lại danh sách</a>
    </div>
</body>
</html>

