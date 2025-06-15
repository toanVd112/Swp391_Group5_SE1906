<%-- 
    Document   : pendingMaintenanceRequests.jsp
    Created on : 11 thg 6, 2025, 08:38:17
    Author     : MyPC
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <style>
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                margin: 0;
                padding: 0;
                background-color: #f3f4f6;
            }
            .main-content {
                max-width: 1200px;
                margin: 40px auto;
                background-color: #ffffff;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 6px 20px rgba(0, 0, 0, 0.08);
            }
            h2 {
                color: #1e3a8a;
                margin-bottom: 20px;
                text-align: center;
            }
            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
            }
            th, td {
                padding: 12px;
                border: 1px solid #ccc;
                text-align: center;
            }
            th {
                background-color: #3b82f6;
                color: white;
            }
            .btn-submit {
                padding: 8px 12px;
                background-color: #10b981;
                border: none;
                color: white;
                border-radius: 5px;
                cursor: pointer;
            }
            .btn-submit:hover {
                background-color: #059669;
            }
            .btn-back {
                display: inline-block;
                padding: 10px 20px;
                background-color: #3b82f6;
                color: white;
                text-decoration: none;
                border-radius: 5px;
                font-weight: bold;
            }
            .btn-back:hover {
                background-color: #2563eb;
            }
            .pagination {
                margin-top: 20px;
                text-align: center;
            }
            .pagination li {
                display: inline-block;
                margin: 0 4px;
            }
            .pagination li a {
                padding: 8px 12px;
                background-color: #ddd;
                border-radius: 5px;
                text-decoration: none;
                color: black;
            }
            .pagination li.active a {
                background-color: #3b82f6;
                color: white;
            }
        </style>
    </head>
    <body>
        <div class="main-content">
            <h2>Danh sách yêu cầu bảo trì đang chờ xử lý</h2>

            <form method="get" action="${pageContext.request.contextPath}/pendingMaintenance">
                <div style="display: flex; justify-content: space-between; margin-bottom: 20px;">
                    <div>
                        <input type="text" name="search" placeholder="Tìm ghi chú..." value="${param.search}" 
                               style="padding: 8px; border-radius: 5px; border: 1px solid #ccc;">
                        <button type="submit" style="padding: 8px 12px; border-radius: 5px; background-color: #3498db; color: white; border: none;">Tìm</button>
                        <a href="pendingMaintenance" 
                           style="padding: 8px 12px; border-radius: 5px; background-color: #e74c3c; color: white; text-decoration: none; margin-left: 10px;">
                            Đặt lại
                        </a>
                    </div>
                    <div>
                        <select name="sort" onchange="this.form.submit()" 
                                style="padding: 8px; border-radius: 5px; border: 1px solid #ccc;">
                            <option value="">Sắp xếp theo ngày</option>
                            <option value="asc" ${param.sort == 'asc' ? 'selected' : ''}>Cũ nhất</option>
                            <option value="desc" ${param.sort == 'desc' ? 'selected' : ''}>Mới nhất</option>
                        </select>
                    </div>
                </div>
            </form>

            <c:if test="${empty pendingRequests}">
                <p>Hiện tại không có yêu cầu bảo trì nào đang chờ xử lý.</p>
            </c:if>

            <c:if test="${not empty pendingRequests}">
                <table>
                    <thead>
                        <tr>
                            <th>Request ID</th>
                            <th>Room ID</th>
                            <th>Ngày yêu cầu</th>
                            <th>Mô tả</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="req" items="${pendingRequests}">
                            <tr>
                                <td>${req.requestID}</td>
                                <td>${req.roomID}</td>
                                <td>${req.requestDate}</td>
                                <td>${req.description}</td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/resolveMaintenanceRequest" method="post">
                                        <input type="hidden" name="requestID" value="${req.requestID}" />
                                        <button type="submit" class="btn-submit">Hoàn thành</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <!-- Phân trang -->
                <div class="pagination">
                    <ul>
                        <c:if test="${currentPage > 1}">
                            <li><a href="pendingMaintenance?page=${currentPage - 1}&search=${param.search}&sort=${param.sort}">Trước</a></li>
                            </c:if>

                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <li class="${i == currentPage ? 'active' : ''}">
                                <a href="pendingMaintenance?page=${i}&search=${param.search}&sort=${param.sort}">${i}</a>
                            </li>
                        </c:forEach>

                        <c:if test="${currentPage < totalPages}">
                            <li><a href="pendingMaintenance?page=${currentPage + 1}&search=${param.search}&sort=${param.sort}">Sau</a></li>
                            </c:if>
                    </ul>
                </div>
            </c:if>

            <div style="text-align: center; margin-top: 20px;">
                <a href="${pageContext.request.contextPath}/Staff/staff.jsp" class="btn-back">Quay về trang chính</a>
            </div>
        </div>

    </body>
</html>

