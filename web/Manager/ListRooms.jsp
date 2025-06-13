<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Quản lý Phòng</title>
        <style>
            .card h2 {
                font-size: 24px;
                margin-bottom: 20px;
                color: #1e293b;
                font-weight: 600;
            }

            .filter {
                display: flex;
                flex-wrap: wrap;
                gap: 10px;
                margin-bottom: 20px;
                align-items: center;
            }

            .filter select,
            .filter input {
                padding: 8px 12px;
                border: 1px solid #cbd5e1;
                border-radius: 6px;
                font-size: 14px;
            }

            .filter button {
                background-color: #2563eb;
                color: white;
                border: none;
                padding: 8px 16px;
                border-radius: 6px;
                cursor: pointer;
                font-weight: bold;
            }

            .filter button:hover {
                background-color: #1d4ed8;
            }

            .filter a {
                margin-left: 10px;
                color: #3b82f6;
                text-decoration: none;
                font-weight: 500;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                background-color: white;
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
                border-radius: 8px;
                overflow: hidden;
            }

            table thead {
                background-color: #f3f4f6;
            }

            table th,
            table td {
                padding: 12px 16px;
                text-align: left;
                font-size: 14px;
                border-bottom: 1px solid #e2e8f0;
            }

            table th {
                color: #1e293b;
                font-weight: 600;
            }

            .status {
                font-weight: bold;
                padding: 4px 10px;
                border-radius: 20px;
                font-size: 12px;
                display: inline-block;
            }

            .status.Available {
                color: #10b981;
                background-color: #d1fae5;
            }

            .status.Occupied {
                color: #f97316;
                background-color: #ffedd5;
            }

            .status.Maintenance {
                color: #f43f5e;
                background-color: #ffe4e6;
            }

            .status.Dirty {
                color: #eab308;
                background-color: #fef9c3;
            }

            .pagination {
                list-style: none;
                display: flex;
                gap: 8px;
                margin-top: 20px;
                padding-left: 0;
            }

            .pagination li a {
                display: inline-block;
                padding: 6px 12px;
                background-color: #e2e8f0;
                color: #1e293b;
                text-decoration: none;
                border-radius: 4px;
            }

            .pagination li.active a {
                background-color: #3b82f6;
                color: white;
                font-weight: bold;
            }

            .pagination li a:hover {
                background-color: #60a5fa;
                color: white;
            }
        </style>

    </head>
    <body>



        <div class="card">
            <h2>Danh sách Phòng</h2>

            <form class="filter" method="get" action="ListRoomsServlet">
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

                <input type="number" name="minFloor" placeholder="Tầng từ" style="width:93px" value="${f_minFloor}" />
                <input type="number" name="maxFloor" placeholder="đến" style="width:80px" value="${f_maxFloor}" />

                <input type="number" step="0.01" name="minPrice" placeholder="Giá từ" style="width:100px" value="${f_minPrice}" />
                <input type="number" step="0.01" name="maxPrice" placeholder="đến" style="width:100px" value="${f_maxPrice}" />

                <button type="submit">Tìm</button>
                <a href="${pageContext.request.contextPath}/ListRoomsServlet">Reset</a>
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
                        <tr>
                            <td colspan="6" style="text-align:center">Không tìm thấy phòng nào</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
            <c:if test="${totalPages > 1}">
                <ul class="pagination">

                    <c:if test="${currentPage > 1}">
                        <li>
                            <a href="ListRoomsServlet?page=${currentPage - 1}&roomTypeId=${f_type}&status=${f_status}&keyword=${f_keyword}&minFloor=${f_minFloor}&maxFloor=${f_maxFloor}&minPrice=${f_minPrice}&maxPrice=${f_maxPrice}">Prev</a>
                        </li>
                    </c:if>

                    <c:forEach var="i" begin="1" end="${totalPages}">
                        <li class="${i == currentPage ? 'active' : ''}">
                            <a href="ListRoomsServlet?page=${i}&roomTypeId=${f_type}&status=${f_status}&keyword=${f_keyword}&minFloor=${f_minFloor}&maxFloor=${f_maxFloor}&minPrice=${f_minPrice}&maxPrice=${f_maxPrice}">${i}</a>
                        </li>
                    </c:forEach>

                    <c:if test="${currentPage < totalPages}">
                        <li>
                            <a href="ListRoomsServlet?page=${currentPage + 1}&roomTypeId=${f_type}&status=${f_status}&keyword=${f_keyword}&minFloor=${f_minFloor}&maxFloor=${f_maxFloor}&minPrice=${f_minPrice}&maxPrice=${f_maxPrice}">Next</a>
                        </li>
                    </c:if>

                </ul>
            </c:if>


        </div>

    </body>
</html>
