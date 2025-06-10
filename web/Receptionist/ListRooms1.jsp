<%@ page contentType="text/html;charset=UTF-8" %>
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
                font-size: 24px;
                color: #1e293b;
                margin-bottom: 20px;
                border-left: 5px solid #3b82f6;
                padding-left: 10px;
            }

            .filter {
                display: flex;
                flex-wrap: wrap;
                gap: 15px;
                margin-bottom: 20px;
            }

            .filter select,
            .filter input {
                padding: 10px;
                border: 1px solid #d1d5db;
                border-radius: 6px;
                font-size: 14px;
                min-width: 140px;
            }

            .filter button {
                padding: 10px 16px;
                background-color: #2563eb;
                color: white;
                border: none;
                border-radius: 6px;
                font-weight: 500;
                cursor: pointer;
            }

            .filter button:hover {
                background-color: #1e40af;
            }

            .filter a {
                display: inline-block;
                padding: 10px 16px;
                background-color: #e5e7eb;
                color: #111827;
                border-radius: 6px;
                text-decoration: none;
                font-weight: 500;
            }

            .filter a:hover {
                background-color: #d1d5db;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
            }

            table thead {
                background-color: #f1f5f9;
            }

            th, td {
                padding: 12px;
                border-bottom: 1px solid #e5e7eb;
                text-align: left;
                font-size: 14px;
            }

            .status {
                font-weight: bold;
                padding: 5px 10px;
                border-radius: 20px;
                font-size: 13px;
            }

            .status.Available {
                background-color: #d1fae5;
                color: #065f46;
            }

            .status.Occupied {
                background-color: #fef3c7;
                color: #92400e;
            }

            .status.Maintenance {
                background-color: #fee2e2;
                color: #991b1b;
            }

            .status.Dirty {
                background-color: #dbeafe;
                color: #1e3a8a;
            }

            .pagination {
                display: flex;
                justify-content: center;
                list-style: none;
                padding: 0;
                margin-top: 30px;
                gap: 8px;
            }

            .pagination li a {
                display: block;
                padding: 8px 14px;
                background-color: #ffffff;
                color: #1e3a8a;
                border: 1px solid #cbd5e1;
                border-radius: 6px;
                text-decoration: none;
                transition: all 0.3s;
            }

            .pagination li a:hover {
                background-color: #3b82f6;
                color: white;
            }

            .pagination li.active a {
                background-color: #3b82f6;
                color: white;
                font-weight: bold;
                border-color: #3b82f6;
            }
        </style>
    </head>
    <body>

        <div class="main-content">
            <div class="card">
                <h2>Danh sách Phòng</h2>

                <form class="filter" method="get" action="ListRoomsServlet1">
                    <select name="roomTypeId">
                        <option value="">--Loại phòng--</option>
                        <c:forEach var="rt" items="${roomTypes}">
                            <option value="${rt.roomTypeID}" 
                                    <c:if test="${rt.roomTypeID == f_type}">selected</c:if>>
                                ${rt.name}
                            </option>
                        </c:forEach>
                    </select>

                    <select name="status">
                        <option value="">--Trạng thái--</option>
                        <c:forEach var="st" items="${['Available','Occupied','Maintenance','Dirty']}">
                            <option value="${st}" 
                                    <c:if test="${st == f_status}">selected</c:if>>
                                ${st}
                            </option>
                        </c:forEach>
                    </select>

                    <input type="number" name="keyword" placeholder="Số phòng chứa..." value="${f_keyword}" />
                    <input type="number" name="minFloor" placeholder="Tầng từ" style="width:80px" value="${f_minFloor}" />
                    <input type="number" name="maxFloor" placeholder="đến" style="width:80px" value="${f_maxFloor}" />
                    <input type="number" step="0.01" name="minPrice" placeholder="Giá từ" style="width:100px" value="${f_minPrice}" />
                    <input type="number" step="0.01" name="maxPrice" placeholder="đến" style="width:100px" value="${f_maxPrice}" />

                    <button type="submit">Tìm</button>
                    <a href="${pageContext.request.contextPath}/ListRoomsServlet1">Reset</a>
                </form>

                <table>
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Số phòng</th>
                            <th>Tầng</th>
                            <th>Loại phòng</th>
                            <th>Giá cơ bản</th>
                            <th>Trạng thái</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="r" items="${rooms}" varStatus="st">
                            <tr>
                                <td>${(currentPage - 1) * 5 + st.index + 1}</td>
                                <td>${r.roomNumber}</td>
                                <td>${r.floor}</td>
                                <td>${r.roomTypeName}</td>
                                <td>${r.basePrice}</td>
                                <td><span class="status ${r.status}">${r.status}</span></td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty rooms}">
                            <tr><td colspan="6" style="text-align:center">Không tìm thấy phòng nào</td></tr>
                        </c:if>
                    </tbody>
                </table>

                <c:if test="${totalPages > 1}">
                    <ul class="pagination">
                        <c:if test="${currentPage > 1}">
                            <li>
                                <a href="ListRoomsServlet1?page=${currentPage - 1}&roomTypeId=${f_type}&status=${f_status}&keyword=${f_keyword}&minFloor=${f_minFloor}&maxFloor=${f_maxFloor}&minPrice=${f_minPrice}&maxPrice=${f_maxPrice}">Prev</a>
                            </li>
                        </c:if>
                        <c:forEach var="i" begin="1" end="${totalPages}">
                            <li class="${i == currentPage ? 'active' : ''}">
                                <a href="ListRoomsServlet1?page=${i}&roomTypeId=${f_type}&status=${f_status}&keyword=${f_keyword}&minFloor=${f_minFloor}&maxFloor=${f_maxFloor}&minPrice=${f_minPrice}&maxPrice=${f_maxPrice}">${i}</a>
                            </li>
                        </c:forEach>
                        <c:if test="${currentPage < totalPages}">
                            <li>
                                <a href="ListRoomsServlet1?page=${currentPage + 1}&roomTypeId=${f_type}&status=${f_status}&keyword=${f_keyword}&minFloor=${f_minFloor}&maxFloor=${f_maxFloor}&minPrice=${f_minPrice}&maxPrice=${f_maxPrice}">Next</a>
                            </li>
                        </c:if>
                    </ul>
                </c:if>

            </div>
        </div>

        <jsp:include page="/footer.jsp" />
    </body>
</html>
