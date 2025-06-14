<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="model.Account" %>
<%
    Account account = (Account) session.getAttribute("account");
    if (account == null || !"Receptionist".equals(account.getRole())) {
        response.sendRedirect("../login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <title>Gửi Yêu Cầu Bảo Trì</title>
       
        <link href="https://fonts.googleapis.com/css2?family=Roboto&display=swap" rel="stylesheet">
        <style>
            body {
                font-family: 'Roboto', sans-serif;
                background-color: #f3f4f6;
                margin: 0;
                padding: 0;
            }
            .main-content {
                max-width: 1000px;
                margin: 40px auto;
                background-color: #ffffff;
                padding: 30px;
                border-radius: 12px;
                box-shadow: 0 6px 20px rgba(0, 0, 0, 0.1);
            }
            h2 {
                text-align: center;
                color: #1e3a8a;
                margin-bottom: 30px;
            }
            label {
                display: block;
                margin-bottom: 8px;
                font-weight: bold;
                color: #374151;
            }
            input[type="number"],
            textarea,
            select {
                width: 100%;
                padding: 10px;
                border-radius: 8px;
                border: 1px solid #d1d5db;
                margin-bottom: 20px;
                font-size: 16px;
                box-sizing: border-box;
            }
            textarea {
                resize: vertical;
            }
            .btn-submit {
                background-color: #2563eb;
                color: white;
                padding: 12px 20px;
                border: none;
                border-radius: 8px;
                font-size: 16px;
                cursor: pointer;
                width: 100%;
            }
            .btn-submit:hover {
                background-color: #1d4ed8;
            }
            .error-message {
                color: red;
                font-weight: bold;
                text-align: center;
                margin-bottom: 20px;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 40px;
            }
            th, td {
                border: 1px solid #ccc;
                padding: 12px;
                text-align: center;
            }
            th {
                background-color: #3b82f6;
                color: white;
            }
            .status-pending {
                color: orange;
                font-weight: bold;
            }
            .status-done {
                color: green;
                font-weight: bold;
            }
        </style>
    </head>
    <body>

        <div class="main-content">
            <h2>Gửi Yêu Cầu Bảo Trì</h2>

            <c:if test="${not empty error}">
                <p class="error-message">${error}</p>
            </c:if>

            <form method="post" action="${pageContext.request.contextPath}/sendMaintenanceRequest">
                <label for="roomID">Mã Phòng:</label>
                <input type="number" name="roomID" id="roomID" required />

                <label for="description">Mô Tả Yêu Cầu:</label>
                <textarea name="description" id="description" rows="4" required></textarea>

                <label for="staffID">Nhân Viên Phụ Trách:</label>
                <select name="staffID" id="staffID" required>
                    <option value="">-- Chọn nhân viên --</option>
                    <c:forEach var="s" items="${staffList}">
                        <option value="${s.accountID}">${s.username}</option>
                    </c:forEach>
                </select>

                <button type="submit" class="btn-submit">Gửi Yêu Cầu</button>
            </form>

            <!-- Danh sách các yêu cầu đã gửi -->
            <h2 style="margin-top:50px;">Danh Sách Yêu Cầu Đã Gửi</h2>

            <c:if test="${empty requestList}">
                <p style="text-align:center;">Chưa có yêu cầu bảo trì nào được gửi.</p>
            </c:if>

            <c:if test="${not empty requestList}">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Phòng</th>
                            <th>Nhân viên</th>
                            <th>Ngày yêu cầu</th>
                            <th>Mô tả</th>
                            <th>Trạng thái</th>
                            <th>Hoàn thành lúc</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="r" items="${requestList}">
                            <tr>
                                <td>${r.requestID}</td>
                                <td>${r.roomID}</td>
                                <td>${r.staffID}</td>
                                <td>${r.requestDate}</td>
                                <td>${r.description}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${r.isResolved}">
                                            <span class="status-done">Đã xử lý</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-pending">Chưa xử lý</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:out value="${r.resolutionDate != null ? r.resolutionDate : '-'}" />
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>
        </div>

      
    </body>
</html>
