<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    String reportID = request.getParameter("reportID");
    if (reportID == null && request.getAttribute("reportID") != null) {
        reportID = String.valueOf(request.getAttribute("reportID"));
    }
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <title>Gửi báo cáo kiểm tra</title>
        <style>
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                margin: 0;
                padding: 0;
                background-color: #f3f4f6;
            }
            .main-content {
                max-width: 600px;
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
            label, textarea, select {
                display: block;
                width: 100%;
                margin-bottom: 15px;
            }
            textarea, select {
                padding: 8px;
                border: 1px solid #ccc;
                border-radius: 5px;
            }
            button {
                padding: 10px 20px;
                background-color: #3b82f6;
                color: white;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                font-weight: bold;
            }
            button:hover {
                background-color: #2563eb;
            }
            .btn-back {
                display: inline-block;
                margin-top: 20px;
                text-align: center;
                text-decoration: none;
                background-color: #10b981;
                color: white;
                padding: 10px 20px;
                border-radius: 5px;
                font-weight: bold;
            }
            .btn-back:hover {
                background-color: #059669;
            }
            .error {
                color: red;
                text-align: center;
                margin-bottom: 15px;
                font-weight: bold;
            }
        </style>
    </head>
    <body>
        <div class="main-content">
            <h2>Gửi báo cáo kiểm tra phòng</h2>

            <c:if test="${not empty error}">
                <p class="error">${error}</p>
            </c:if>

            <form action="${pageContext.request.contextPath}/submitInspectionReport" method="post">
                <input type="hidden" name="reportID" value="<%= reportID %>"/>

                <label for="isRoomOk">Kết quả kiểm tra:</label>
                <select name="isRoomOk" required>
                    <option value="1">Đạt</option>
                    <option value="0">Không đạt</option>
                </select>

                <label for="notes">Ghi chú:</label>
                <textarea name="notes" rows="5" placeholder="Nhập ghi chú..."></textarea>

                <div style="text-align: right;">
                    <button type="submit">Gửi báo cáo</button>
                </div>
            </form>

            <!-- Nút quay về trang chính -->
            <div style="text-align: center;">
                <a href="${pageContext.request.contextPath}/Staff/staff.jsp" class="btn-back">Quay về trang chính</a>
            </div>
        </div>
    </body>
</html>
