<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <jsp:include page="/header.jsp" />
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
                font-size: 22px;
                color: #1e293b;
                margin-bottom: 20px;
                border-left: 5px solid #3b82f6;
                padding-left: 12px;
            }

            form {
                display: grid;
                gap: 15px;
                grid-template-columns: 1fr 1fr;
                background-color: #f9fafb;
                padding: 20px;
                border-radius: 10px;
                border: 1px solid #e5e7eb;
                margin-bottom: 40px;
            }

            form label {
                font-weight: 600;
            }

            form input, form select {
                padding: 8px;
                font-size: 14px;
                width: 100%;
                border: 1px solid #cbd5e1;
                border-radius: 6px;
            }

            form input[type="submit"] {
                grid-column: span 2;
                background-color: #3b82f6;
                color: white;
                border: none;
                padding: 12px;
                font-weight: bold;
                cursor: pointer;
                transition: background-color 0.3s;
            }

            form input[type="submit"]:hover {
                background-color: #2563eb;
            }

            .error {
                color: red;
                font-style: italic;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 10px;
                background-color: #fff;
                border-radius: 10px;
                overflow: hidden;
            }

            th {
                background-color: #f1f5f9;
                text-align: left;
                padding: 12px;
                border-bottom: 2px solid #e2e8f0;
                font-size: 14px;
            }

            td {
                padding: 12px;
                border-bottom: 1px solid #e5e7eb;
                font-size: 14px;
            }

            .status {
                font-weight: bold;
                padding: 6px 12px;
                border-radius: 999px;
                font-size: 13px;
            }

            .status-true {
                background-color: #d1fae5;
                color: #065f46;
            }

            .status-false {
                background-color: #fee2e2;
                color: #991b1b;
            }

            .status-pending {
                background-color: #fef9c3;
                color: #92400e;
            }

            .center-text {
                text-align: center;
                font-style: italic;
                color: #6b7280;
            }
        </style>
    </head>
    <body>
        <div class="main-content">

            <h2>Thêm Yêu cầu kiểm tra</h2>
            <form action="${pageContext.request.contextPath}/roomInspection" method="post">
                <div>
                    <label>Booking ID:</label>
                    <input type="number" name="bookingId" required>
                </div>

                <div>
                    <label>Room ID:</label>
                    <input type="number" name="roomId" required>
                </div>

                <div>
                    <label>Chọn nhân viên kiểm tra:</label>
                    <select name="staffId" required>
                        <c:forEach var="staff" items="${staffList}">
                            <option value="${staff.accountID}">${staff.username}</option>
                        </c:forEach>
                    </select>
                    <c:if test="${not empty catchError}">
                        <p class="error">Lỗi khi hiển thị staffList: ${catchError}</p>
                    </c:if>
                </div>

                <div>
                    <label>Ghi chú:</label>
                    <input type="text" name="notes" required>
                </div>

                <input type="submit" value="Gửi Yêu cầu">
            </form>

            <h2>Danh sách Yêu cầu kiểm tra</h2>
            <table>
                <tr>
                    <th>Report ID</th>
                    <th>Booking ID</th>
                    <th>Room ID</th>
                    <th>Thời gian kiểm</th>
                    <th>Staff</th>
                    <th>Trạng thái</th>
                    <th>Ghi chú</th>
                </tr>

                <c:forEach var="report" items="${reports}">
                    <tr>
                        <td>${report.reportID}</td>
                        <td>${report.bookingID}</td>
                        <td>${report.roomID}</td>
                        <td>${report.inspectionTime}</td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty report.staffID}">
                                    ${report.staffID}
                                </c:when>
                                <c:otherwise>
                                    <span class="center-text">Chưa phân công</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${report.isRoomOk == true}">
                                    <span class="status status-true">OK</span>
                                </c:when>
                                <c:when test="${report.isRoomOk == false}">
                                    <span class="status status-false">Không OK</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="status status-pending">Chưa kiểm</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty report.notes}">
                                    ${report.notes}
                                </c:when>
                                <c:otherwise>
                                    <span class="center-text">Chưa có</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty reports}">
                    <tr>
                        <td colspan="7" class="center-text">Không có yêu cầu nào</td>
                    </tr>
                </c:if>
            </table>

            <c:if test="${not empty error}">
                <p class="error">${error}</p>
            </c:if>

        </div>

        <jsp:include page="/footer.jsp" />
    </body>
</html>
