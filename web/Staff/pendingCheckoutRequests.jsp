<%-- 
    Document   : pendingCheckoutRequests
    Created on : 10 thg 6, 2025, 22:13:58
    Author     : MyPC
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <%@ include file="/header.jsp" %>
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
        </style>
    </head>
    <body>
        <div class="main-content">
            <h2>Danh sách yêu cầu kiểm tra phòng đang chờ xử lý</h2>

            <c:if test="${empty pendingRequests}">
                <p>Hiện tại không có yêu cầu kiểm tra nào đang chờ xử lý.</p>
            </c:if>

            <c:if test="${not empty pendingRequests}">
                <table>
                    <thead>
                        <tr>
                            <th>Report ID</th>
                            <th>Booking ID</th>
                            <th>Room ID</th>
                            <th>Ngày yêu cầu</th>
                            <th>Ghi chú</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="report" items="${pendingRequests}">
                            <tr>
                                <td>${report.reportID}</td>
                                <td>${report.bookingID}</td>
                                <td>${report.roomID}</td>
                                <td>${report.inspectionTime}</td>
                                <td>${report.notes}</td>
                                <td>
                                    <form action="submitInspectionReport.jsp" method="get">
                                        <input type="hidden" name="reportID" value="${report.reportID}" />
                                        <button type="submit">Gửi báo cáo</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>
        </div>

        <%@ include file="/footer.jsp" %>
    </body>
</html>
