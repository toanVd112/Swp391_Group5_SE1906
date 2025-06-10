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
        </style>
    </head>
    <body>
        <div class="main-content">
            <h2>Danh sách yêu cầu kiểm tra phòng đang chờ xử lý</h2>

            <c:if test="${empty pendingRequests}">
                <p>Hiện tại không có yêu cầu kiểm tra nào đang chờ xử lý.</p>
            </c:if>

            <c:if test="${not empty pendingRequests}">
                <form method="get" action="${pageContext.request.contextPath}/pendingCheckout">
                    <div style="display: flex; justify-content: space-between; margin-bottom: 20px;">
                        <div>
                            <input type="text" name="search" placeholder="Search by username..." value="${param.search}" 
                                   style="padding: 8px; border-radius: 5px; border: 1px solid #ccc;">
                            <button type="submit" style="padding: 8px 12px; border-radius: 5px; background-color: #3498db; color: white; border: none;">Search</button>
                            <a href="pendingCheckout" 
                               style="padding: 8px 12px; border-radius: 5px; background-color: #e74c3c; color: white; text-decoration: none; margin-left: 10px;">
                                Reset
                            </a>
                        </div>
                        <div>
                            <select name="sort" onchange="this.form.submit()" 
                                    style="padding: 8px; border-radius: 5px; border: 1px solid #ccc;">
                                <option value="">Sort by Created Date</option>
                                <option value="asc" ${param.sort == 'asc' ? 'selected' : ''}>Oldest</option>
                                <option value="desc" ${param.sort == 'desc' ? 'selected' : ''}>Newest</option>
                            </select>
                        </div>
                    </div>
                </form>

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
                                    <form action="${pageContext.request.contextPath}/Staff/submitInspectionReport.jsp" method="get">
                                        <input type="hidden" name="reportID" value="${report.reportID}" />
                                        <button type="submit" class="btn-submit">Gửi báo cáo</button>
                                    </form>
                                </td>

                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
                <ul class="pagination">
                    <c:if test="${currentPage > 1}">
                        <li><a href="pendingCheckout?page==${currentPage - 1}&search=${param.search}&sort=${param.sort}">Prev</a></li>
                        </c:if>

                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <li class="${i == currentPage ? 'active' : ''}">
                            <a href="pendingCheckout?page=${i}&search=${param.search}&sort=${param.sort}">${i}</a>
                        </li>
                    </c:forEach>

                    <c:if test="${currentPage < totalPages}">
                        <li><a href="pendingCheckout?page=${currentPage + 1}&search=${param.search}&sort=${param.sort}">Next</a></li>
                        </c:if>
                </ul>

            </c:if>
            <!-- sau thẻ </form> -->
            <div style="text-align: center; margin-top: 20px;">
                <a href="${pageContext.request.contextPath}/Staff/staff.jsp" class="btn-back">Quay về trang chính</a>
            </div>

        </div>

        <%@ include file="/footer.jsp" %>
    </body>
</html>
