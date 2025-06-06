<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Quản lý Phòng</title>
        <style>
            /* KHÔNG có .sidebar ở đây nữa */

            .main-content {
                margin-left: 260px;
                padding: 30px;
                width: calc(100% - 260px);
                box-sizing: border-box;
            }

            .card {
                background: #fff;
                padding: 20px;
                border-radius: 8px;
                max-width: 1200px;
                margin: auto;
                box-shadow: 0 4px 12px rgba(0,0,0,.1);
            }

            .filter {
                display: flex;
                gap: 10px;
                flex-wrap: wrap;
                margin-bottom: 20px;
            }

            .filter select, .filter input {
                padding: 6px;
                border: 1px solid #ccc;
                border-radius: 4px;
            }

            .filter button {
                padding: 6px 12px;
                border: none;
                border-radius: 4px;
                background: #2563eb;
                color: #fff;
                cursor: pointer;
            }

            .filter a {
                padding: 6px 12px;
                background: #ccc;
                color: #000;
                text-decoration: none;
                border-radius: 4px;
            }

            table {
                width: 100%;
                border-collapse: collapse;
            }

            th, td {
                padding: 10px;
                border-bottom: 1px solid #eaeaea;
                text-align: left;
            }

            th {
                background: #fafafa;
            }

            .status.Available {
                color: green;
                font-weight: 600;
            }

            .status.Occupied {
                color: orange;
                font-weight: 600;
            }

            .status.Maintenance {
                color: red;
                font-weight: 600;
            }

            .status.Dirty {
                color: blue;
                font-weight: 600;
            }
            .pagination {
                display: flex;
                justify-content: center;
                padding: 0;
                margin-top: 20px;
                list-style-type: none;
                gap: 5px;
            }

            .pagination li {
                display: inline-block;
            }

            .pagination a {
                display: block;
                padding: 8px 14px;
                text-decoration: none;
                border-radius: 6px;
                border: 1px solid #ccc;
                background-color: #f9f9f9;
                color: #2c3e50;
                font-weight: 500;
                transition: background-color 0.3s, color 0.3s;
            }

            .pagination a:hover {
                background-color: #3498db;
                color: white;
            }

            .pagination .active a {
                background-color: #3498db;
                color: white;
                border-color: #3498db;
                font-weight: bold;
            }

        </style>
    </head>
    <body>
        <%@ include file="sidebar.jsp" %>

        <div class="main-content">
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

                    <input type="text" name="keyword" placeholder="Số phòng chứa..." value="${f_keyword}" />

                    <input type="number" name="minFloor" placeholder="Tầng từ" style="width:80px" value="${f_minFloor}" />
                    <input type="number" name="maxFloor" placeholder="đến" style="width:80px" value="${f_maxFloor}" />

                    <input type="number" step="0.01" name="minPrice" placeholder="Giá từ" style="width:100px" value="${f_minPrice}" />
                    <input type="number" step="0.01" name="maxPrice" placeholder="đến" style="width:100px" value="${f_maxPrice}" />

                    <button type="submit">Tìm</button>
                    <a href="${pageContext.request.contextPath}/manager/rooms">Reset</a>
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
        </div>
    </body>
</html>
