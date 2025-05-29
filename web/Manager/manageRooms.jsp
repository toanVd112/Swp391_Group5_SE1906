<%-- 
    Document   : manageRooms
    Created on : May 29, 2025, 9:24:11 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Quản lí Phòng</title>
    <style>
        body{font-family:Arial; background:#f4f7f9; margin:0}
        .wrap{max-width:1100px;margin:auto;padding:30px}
        .card{background:#fff;border-radius:8px;box-shadow:0 2px 8px rgba(0,0,0,.1);padding:25px}
        h2{margin-top:0}
        .filter{display:flex;gap:12px;margin-bottom:18px}
        select,button{padding:6px 10px;border-radius:6px;border:1px solid #ccc}
        table{width:100%;border-collapse:collapse}
        th,td{padding:10px 8px;border-bottom:1px solid #eaeaea;text-align:left}
        th{background:#fafafa}
        .status.Available{color:#16a34a;font-weight:bold}
        .status.Occupied{color:#d97706;font-weight:bold}
        .status.Maintenance{color:#dc2626;font-weight:bold}
        .status.Dirty{color:#2563eb;font-weight:bold}
    </style>
</head>
<body>
<div class="wrap">
    <div class="card">
        <h2>Danh sách Phòng</h2>

        <!-- Bộ lọc loại phòng -->
        <form class="filter" method="get">
            <select name="roomTypeId">
                <option value="">Tất cả loại phòng</option>
                <c:forEach var="rt" items="${roomTypes}">
                    <option value="${rt.roomTypeID}"
                        <c:if test="${rt.roomTypeID == selectedType}">selected</c:if>>
                        ${rt.name}
                    </option>
                </c:forEach>
            </select>
            <button type="submit">Lọc</button>
        </form>

        <!-- Bảng phòng -->
        <table>
            <thead>
                <tr>
                    <th>#</th>
                    <th>Số phòng</th>
                    <th>Tầng</th>
                    <th>Loại phòng</th>
                    <th>Giá gốc</th>
                    <th>Trạng thái</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="r" items="${rooms}" varStatus="st">
                    <tr>
                        <td>${st.count}</td>
                        <td>${r.roomNumber}</td>
                        <td>${r.floor}</td>
                        <td>${r.roomTypeName}</td>
                        <td>${r.basePrice}</td>
                        <td><span class="status ${r.status}">${r.status}</span></td>
                    </tr>
                </c:forEach>
                <c:if test="${rooms.empty}">
                    <tr><td colspan="6" style="text-align:center">Không có phòng</td></tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>
