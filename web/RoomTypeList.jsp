<%-- 
    Document   : RoomTypeList
    Created on : Jun 18, 2025, 3:34:59 PM
    Author     : Arcueid
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Loại Phòng - Hotel Management System</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
            color: #333;
        }

        /* Header Styles */
        .header {
            background-color: #2c3e50;
            color: white;
            padding: 12px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .header-left {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .menu-toggle {
            background: none;
            border: none;
            color: white;
            font-size: 18px;
            cursor: pointer;
        }

        .header-right {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .header-icon {
            background: none;
            border: none;
            color: white;
            font-size: 16px;
            cursor: pointer;
            padding: 8px;
            border-radius: 4px;
            transition: background-color 0.3s;
        }

        .header-icon:hover {
            background-color: rgba(255,255,255,0.1);
        }

        .user-profile {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .user-avatar {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background-color: #34495e;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 14px;
        }

        /* Breadcrumb Styles */
        .breadcrumb-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 60px 20px;
            position: relative;
            overflow: hidden;
        }

        .breadcrumb-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="25" cy="25" r="1" fill="white" opacity="0.1"/><circle cx="75" cy="75" r="1" fill="white" opacity="0.1"/><circle cx="50" cy="10" r="1" fill="white" opacity="0.1"/><circle cx="10" cy="60" r="1" fill="white" opacity="0.1"/><circle cx="90" cy="40" r="1" fill="white" opacity="0.1"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
        }

        .breadcrumb-content {
            position: relative;
            z-index: 1;
            display: flex;
            justify-content: space-between;
            align-items: center;
            max-width: 1200px;
            margin: 0 auto;
        }

        .page-title {
            color: white;
            font-size: 28px;
            font-weight: 300;
        }

        .page-subtitle {
            color: rgba(255,255,255,0.8);
            font-size: 14px;
            margin-top: 5px;
        }

        .breadcrumb {
            display: flex;
            align-items: center;
            gap: 10px;
            color: rgba(255,255,255,0.9);
            font-size: 14px;
        }

        .breadcrumb a {
            color: rgba(255,255,255,0.9);
            text-decoration: none;
            transition: color 0.3s;
        }

        .breadcrumb a:hover {
            color: white;
        }

        /* Main Content */
        .main-content {
            max-width: 1200px;
            margin: -30px auto 0;
            padding: 0 20px;
            position: relative;
            z-index: 2;
        }

        .card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            overflow: hidden;
            padding: 20px;
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
            transition: background-color 0.3s;
        }

        .add-btn:hover {
            background-color: #218838;
        }

        /* Filter Styles */
        .filter {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-bottom: 20px;
            align-items: center;
            padding: 15px;
            background-color: #f8f9fa;
            border-radius: 6px;
            border: 1px solid #e9ecef;
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
            transition: background-color 0.3s;
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

        .filter a:hover {
            text-decoration: underline;
        }

        /* Table Styles */
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

        table tbody tr:hover {
            background-color: #f8f9fa;
        }

        /* Price formatting */
        .price {
            font-weight: 600;
            color: #059669;
        }

        .room-count {
            font-weight: 600;
            color: #3b82f6;
        }

        /* Action Buttons */
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
            transition: all 0.3s;
        }

        .btn-view {
            background-color: #6c757d;
            color: white;
        }

        .btn-view:hover {
            background-color: #5a6268;
        }

        .btn-edit {
            background-color: #007bff;
            color: white;
        }

        .btn-edit:hover {
            background-color: #0056b3;
        }

        .btn-delete {
            background-color: #dc3545;
            color: white;
        }

        .btn-delete:hover {
            background-color: #c82333;
        }

        /* Pagination */
        .pagination {
            list-style: none;
            display: flex;
            gap: 8px;
            margin-top: 20px;
            padding-left: 0;
            justify-content: center;
        }

        .pagination li a {
            display: inline-block;
            padding: 8px 12px;
            background-color: #e2e8f0;
            color: #1e293b;
            text-decoration: none;
            border-radius: 4px;
            transition: all 0.3s;
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

        /* Responsive Design */
        @media (max-width: 768px) {
            .header {
                padding: 10px 15px;
            }

            .breadcrumb-content {
                flex-direction: column;
                gap: 15px;
                text-align: center;
            }

            .filter {
                flex-direction: column;
                align-items: stretch;
            }

            .filter > * {
                width: 100%;
            }

            table {
                font-size: 12px;
            }

            .action-buttons {
                flex-direction: column;
            }

            .card h2 {
                flex-direction: column;
                gap: 15px;
                align-items: stretch;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header class="header">
        <div class="header-left">
            <button class="menu-toggle">
                <i class="fas fa-bars"></i>
            </button>
        </div>
        <div class="header-right">
            <button class="header-icon">
                <i class="fas fa-bell"></i>
            </button>
            <button class="header-icon">
                <i class="fas fa-envelope"></i>
            </button>
            <button class="header-icon">
                <i class="fas fa-cog"></i>
            </button>
            <div class="user-profile">
                <div class="user-avatar">
                    <i class="fas fa-user"></i>
                </div>
                <span>Adnan Sharaf</span>
            </div>
            <button class="header-icon">
                <i class="fas fa-sign-out-alt"></i>
            </button>
        </div>
    </header>

    <!-- Breadcrumb Section -->
    <section class="breadcrumb-section">
        <div class="breadcrumb-content">
            <div>
                <h1 class="page-title">Quản lý Loại Phòng</h1>
                <p class="page-subtitle">Danh sách</p>
            </div>
            <nav class="breadcrumb">
                <i class="fas fa-home"></i>
                <a href="${pageContext.request.contextPath}/dashboard">Dashboard</a>
                <i class="fas fa-chevron-right"></i>
                <span>Loại Phòng</span>
            </nav>
        </div>
    </section>

    <!-- Main Content -->
    <main class="main-content">
        <div class="card">
            <h2>
                Danh sách Loại Phòng
                <button class="add-btn" onclick="window.location.href='${pageContext.request.contextPath}/AddRoomTypeServlet'">
                    <i class="fas fa-plus"></i>
                    Thêm Loại Phòng
                </button>
            </h2>

            <!-- Filter Form -->
            <form class="filter" method="get" action="${pageContext.request.contextPath}/ListRoomTypesServlet">
                <input type="text" name="keyword" placeholder="Tìm theo tên loại phòng..." value="${f_keyword}" />
                
                <input type="number" step="0.01" name="minPrice" placeholder="Giá từ" style="width:120px" value="${f_minPrice}" />
                <input type="number" step="0.01" name="maxPrice" placeholder="đến" style="width:120px" value="${f_maxPrice}" />
                
                <select name="sortBy">
                    <option value="">--Sắp xếp theo--</option>
                    <option value="name" <c:if test="${f_sortBy == 'name'}">selected</c:if>>Tên loại phòng</option>
                    <option value="price" <c:if test="${f_sortBy == 'price'}">selected</c:if>>Giá cơ bản</option>
                    <option value="roomCount" <c:if test="${f_sortBy == 'roomCount'}">selected</c:if>>Số phòng</option>
                </select>

                <button type="submit">
                    <i class="fas fa-search"></i>
                    Tìm kiếm
                </button>
                <a href="${pageContext.request.contextPath}/ListRoomTypesServlet">
                    <i class="fas fa-refresh"></i>
                    Reset
                </a>
            </form>

            <!-- Room Types Table -->
            <table>
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Loại phòng</th>
                        <th>Giá cơ bản</th>
                        <th>Số phòng hiện có</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="rt" items="${roomTypes}" varStatus="st">
                        <tr>
                            <td>${(currentPage - 1) * 10 + st.index + 1}</td>
                            <td>
                                <strong>${rt.name}</strong>
                                <c:if test="${not empty rt.description}">
                                    <br><small style="color: #6c757d;">${rt.description}</small>
                                </c:if>
                            </td>
                            <td class="price">
                                <i class="fas fa-dollar-sign"></i>
                                ${rt.basePrice} VNĐ
                            </td>
                            <td class="room-count">
                                <i class="fas fa-bed"></i>
                                ${rt.availableRooms} phòng
                            </td>
                            <td>
                                <div class="action-buttons">
                                    <button class="action-btn btn-view" onclick="viewRoomType(${rt.roomTypeID})">
                                        <i class="fas fa-eye"></i>
                                        Xem
                                    </button>
                                    <button class="action-btn btn-edit" onclick="editRoomType(${rt.roomTypeID})">
                                        <i class="fas fa-edit"></i>
                                        Sửa
                                    </button>
                                    <button class="action-btn btn-delete" onclick="deleteRoomType(${rt.roomTypeID}, '${rt.name}')">
                                        <i class="fas fa-trash"></i>
                                        Xóa
                                    </button>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty roomTypes}">
                        <tr>
                            <td colspan="5" style="text-align:center; padding: 40px; color: #6c757d;">
                                <i class="fas fa-inbox" style="font-size: 48px; margin-bottom: 10px; display: block;"></i>
                                Không tìm thấy loại phòng nào
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>

            <!-- Pagination -->
            <c:if test="${totalPages > 1}">
                <ul class="pagination">
                    <c:if test="${currentPage > 1}">
                        <li>
                            <a href="ListRoomTypesServlet?page=${currentPage - 1}&keyword=${f_keyword}&minPrice=${f_minPrice}&maxPrice=${f_maxPrice}&sortBy=${f_sortBy}">
                                <i class="fas fa-chevron-left"></i> Trước
                            </a>
                        </li>
                    </c:if>

                    <c:forEach var="i" begin="1" end="${totalPages}">
                        <li class="${i == currentPage ? 'active' : ''}">
                            <a href="ListRoomTypesServlet?page=${i}&keyword=${f_keyword}&minPrice=${f_minPrice}&maxPrice=${f_maxPrice}&sortBy=${f_sortBy}">${i}</a>
                        </li>
                    </c:forEach>

                    <c:if test="${currentPage < totalPages}">
                        <li>
                            <a href="ListRoomTypesServlet?page=${currentPage + 1}&keyword=${f_keyword}&minPrice=${f_minPrice}&maxPrice=${f_maxPrice}&sortBy=${f_sortBy}">
                                Sau <i class="fas fa-chevron-right"></i>
                            </a>
                        </li>
                    </c:if>
                </ul>
            </c:if>
        </div>
    </main>

    <script>
        // View room type details
        function viewRoomType(id) {
            window.location.href = '${pageContext.request.contextPath}/ViewRoomTypeServlet?id=' + id;
        }

        // Edit room type
        function editRoomType(id) {
            window.location.href = '${pageContext.request.contextPath}/EditRoomTypeServlet?id=' + id;
        }

        // Delete room type with confirmation
        function deleteRoomType(id, name) {
            if (confirm('Bạn có chắc chắn muốn xóa loại phòng "' + name + '"?\n\nLưu ý: Việc xóa loại phòng có thể ảnh hưởng đến các phòng đang sử dụng loại này.')) {
                // Create a form to submit DELETE request
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/DeleteRoomTypeServlet';
                
                const idInput = document.createElement('input');
                idInput.type = 'hidden';
                idInput.name = 'id';
                idInput.value = id;
                
                form.appendChild(idInput);
                document.body.appendChild(form);
                form.submit();
            }
        }

        // Auto-submit form when sort option changes
        document.querySelector('select[name="sortBy"]').addEventListener('change', function() {
            this.form.submit();
        });

        // Format price inputs
        document.querySelectorAll('input[name="minPrice"], input[name="maxPrice"]').forEach(input => {
            input.addEventListener('blur', function() {
                if (this.value) {
                    this.value = parseFloat(this.value).toFixed(2);
                }
            });
        });
    </script>
</body>
</html>