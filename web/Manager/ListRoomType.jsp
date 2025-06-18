<%-- 
    Document   : RoomTypeList
    Created on : Jun 18, 2025, 3:34:59 PM
    Author     : Arcueid
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Loại Phòng</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
            color: #333;
            margin: 0;
        }

        .card h2 {
            font-size: 24px;
            margin-bottom: 20px;
            color: #1e293b;
            font-weight: 600;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .add-btn {
            background-color: #28a745;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
        }

        .add-btn:hover {
            background-color: #218838;
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

        table th, table td {
            padding: 12px 16px;
            text-align: left;
            font-size: 14px;
            border-bottom: 1px solid #e2e8f0;
        }

        table th {
            color: #1e293b;
            font-weight: 600;
        }

        .price {
            font-weight: 600;
            color: #059669;
        }

        .room-count {
            font-weight: 600;
            color: #3b82f6;
        }

        .action-buttons {
            display: flex;
            gap: 5px;
        }

        .action-btn {
            padding: 6px 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
            display: flex;
            align-items: center;
            gap: 5px;
            text-decoration: none;
        }

        .btn-view { background-color: #6c757d; color: white; }
        .btn-edit { background-color: #007bff; color: white; }
        .btn-delete { background-color: #dc3545; color: white; }

        .btn-view:hover { background-color: #5a6268; }
        .btn-edit:hover { background-color: #0056b3; }
        .btn-delete:hover { background-color: #c82333; }

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
    <h2>Danh sách Loại Phòng
        <a class="add-btn" href="ManageRoomType"><i class="fas fa-plus"></i> Thêm mới</a>
    </h2>

    <!-- Bộ lọc -->
    <form method="get" action="RoomTypeListServlet" class="filter">
        <input type="text" name="keyword" placeholder="Tên phòng..." value="${f_keyword}">
        <input type="number" name="minPrice" step="0.01" placeholder="Giá từ" value="${f_minPrice}">
        <input type="number" name="maxPrice" step="0.01" placeholder="Giá đến" value="${f_maxPrice}">
        <select name="sortBy">
            <option value="">-- Sắp xếp theo --</option>
            <option value="name" <c:if test="${f_sortBy == 'name'}">selected</c:if>>Tên loại phòng</option>
            <option value="price" <c:if test="${f_sortBy == 'price'}">selected</c:if>>Giá cơ bản</option>
            <option value="roomCount" <c:if test="${f_sortBy == 'roomCount'}">selected</c:if>>Số phòng</option>
        </select>
        <button type="submit">Tìm</button>
        <a href="RoomTypeListServlet">Reset</a>
    </form>

    <!-- Bảng kết quả -->
    <table>
        <thead>
            <tr>
                <th>#</th>
                <th>Tên loại phòng</th>
                <th>Giá cơ bản</th>
                <th>Số phòng</th>
                <th>Hành động</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="rt" items="${roomTypes}" varStatus="st">
                <tr>
                    <td>${(currentPage - 1) * 10 + st.index + 1}</td>
                    <td>
                        <strong>${rt.name}</strong><br>
                        <small style="color: #6b7280;">${rt.description}</small>
                    </td>
                    <td class="price">
                        <i class="fas fa-dollar-sign"></i> 
                        <fmt:formatNumber value="${rt.basePrice}" type="number" groupingUsed="true"/> VNĐ
                    </td>
                    <td class="room-count">
                        <i class="fas fa-bed" style="margin-right:4px; color:#3b82f6;"></i>
                        ${rt.availableRooms} phòng
                    </td>
                    <td class="action-buttons">
                        <a class="action-btn btn-view" href="ViewRoomTypeServlet?id=${rt.roomTypeID}"><i class="fas fa-eye"></i> Xem</a>
                        <a class="action-btn btn-edit" href="ManageRoomType?id=${rt.roomTypeID}"><i class="fas fa-edit"></i> Sửa</a>
                        <a class="action-btn btn-delete" href="DeleteRoomTypeServlet?id=${rt.roomTypeID}" onclick="return confirm('Xóa ${rt.name}?');"><i class="fas fa-trash"></i> Xóa</a>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty roomTypes}">
                <tr><td colspan="5" style="text-align:center;">Không có dữ liệu</td></tr>
            </c:if>
        </tbody>
    </table>

    <!-- Phân trang -->
    <c:if test="${totalPages > 1}">
        <ul class="pagination">
            <c:forEach var="i" begin="1" end="${totalPages}">
                <li class="${i == currentPage ? 'active' : ''}">
                    <a href="RoomTypeListServlet?page=${i}&keyword=${f_keyword}&minPrice=${f_minPrice}&maxPrice=${f_maxPrice}&sortBy=${f_sortBy}">${i}</a>
                </li>
            </c:forEach>
        </ul>
    </c:if>
</div>

</body>
</html>
