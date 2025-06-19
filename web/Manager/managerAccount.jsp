<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Tài khoản</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
            color: #333;
            margin: 0;
            padding: 30px;
        }

        .card {
            background: #fff;
            border-radius: 8px;
            padding: 30px;
            max-width: 1200px;
            margin: auto;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }

        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 1px solid #e2e8f0;
        }

        .card-title {
            font-size: 24px;
            margin: 0;
            color: #1e293b;
            font-weight: 600;
        }

        .btn-add {
            background-color: #16a34a;
            color: white;
            border: none;
            padding: 12px 20px;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: background-color 0.2s;
        }

        .btn-add:hover {
            background-color: #15803d;
        }

        .search-controls {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
            gap: 16px;
        }

        .search-group {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .form-input {
            padding: 10px 12px;
            border-radius: 6px;
            border: 1px solid #d1d5db;
            font-size: 14px;
            width: 250px;
        }

        .form-input:focus {
            outline: none;
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        .btn-search {
            background-color: #2563eb;
            color: white;
            border: none;
            padding: 10px 16px;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .btn-search:hover {
            background-color: #1d4ed8;
        }

        .form-select {
            padding: 10px 12px;
            border-radius: 6px;
            border: 1px solid #d1d5db;
            font-size: 14px;
            width: 200px;
            background-color: white;
        }

        .table-container {
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            overflow: hidden;
            margin-bottom: 24px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        table thead {
            background-color: #2563eb;
        }

        table th {
            padding: 16px 12px;
            text-align: left;
            color: white;
            font-weight: 600;
            font-size: 14px;
        }

        table td {
            padding: 12px;
            border-bottom: 1px solid #f3f4f6;
            font-size: 14px;
        }

        table tr:hover {
            background-color: #f9fafb;
        }

        .badge {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 500;
            text-transform: uppercase;
        }

        .badge-active {
            background-color: #dcfce7;
            color: #166534;
        }

        .badge-inactive {
            background-color: #fee2e2;
            color: #dc2626;
        }

        .badge-manager {
            background-color: #dbeafe;
            color: #1d4ed8;
        }

        .badge-staff {
            background-color: #f3f4f6;
            color: #374151;
        }

        .action-buttons {
            display: flex;
            gap: 8px;
        }

        .btn-action {
            padding: 6px 8px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            transition: background-color 0.2s;
        }

        .btn-edit {
            background-color: #dbeafe;
            color: #1d4ed8;
        }

        .btn-edit:hover {
            background-color: #bfdbfe;
        }

        .btn-delete {
            background-color: #fee2e2;
            color: #dc2626;
        }

        .btn-delete:hover {
            background-color: #fecaca;
        }

        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 8px;
            margin: 24px 0;
        }

        .pagination a, .pagination span {
            display: inline-block;
            padding: 8px 12px;
            text-decoration: none;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 500;
        }

        .pagination a {
            background-color: #f8fafc;
            color: #475569;
            border: 1px solid #e2e8f0;
        }

        .pagination a:hover {
            background-color: #f1f5f9;
        }

        .pagination .active {
            background-color: #2563eb;
            color: white;
            border: 1px solid #2563eb;
        }

        .btn-back {
            background-color: #2563eb;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 500;
            margin-top: 20px;
        }

        .btn-back:hover {
            background-color: #1d4ed8;
        }

        /* Modal Styles */
        .amodal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
        }

        .amodal-dialog {
            background-color: #fff;
            margin: 5% auto;
            padding: 0;
            width: 500px;
            border-radius: 8px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
        }

        .amodal-header {
            padding: 20px 24px;
            border-bottom: 1px solid #e5e7eb;
        }

        .amodal-title {
            margin: 0;
            font-size: 18px;
            font-weight: 600;
            color: #1f2937;
        }

        .amodal-body {
            padding: 24px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-label {
            display: block;
            margin-bottom: 6px;
            font-weight: 600;
            color: #374151;
            font-size: 14px;
        }

        .form-control {
            width: 100%;
            padding: 10px 12px;
            border-radius: 6px;
            border: 1px solid #d1d5db;
            font-size: 14px;
            box-sizing: border-box;
        }

        .form-control:focus {
            outline: none;
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        .amodal-footer {
            padding: 20px 24px;
            border-top: 1px solid #e5e7eb;
            display: flex;
            justify-content: flex-end;
            gap: 12px;
        }

        .btn-cancel {
            background-color: #6b7280;
            color: white;
            border: none;
            padding: 10px 16px;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 500;
        }

        .btn-cancel:hover {
            background-color: #4b5563;
        }

        .btn-submit {
            background-color: #16a34a;
            color: white;
            border: none;
            padding: 10px 16px;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 500;
        }

        .btn-submit:hover {
            background-color: #15803d;
        }

        .checkbox {
            width: 16px;
            height: 16px;
            cursor: pointer;
        }

        .password-mask {
            font-family: monospace;
            letter-spacing: 2px;
        }
    </style>
</head>
<body>
    <div class="card">
        <div class="card-header">
            <h2 class="card-title">Quản lý <strong>Tài khoản</strong></h2>
            <a href="#" onclick="openModal()" class="btn-add">
                <i class="fas fa-plus"></i>
                Thêm tài khoản mới
            </a>
        </div>

        <!-- Search and Sort Controls -->
        <form method="get" action="managerAccount">
            <div class="search-controls">
                <div class="search-group">
                    <input type="text" name="search" placeholder="Tìm kiếm theo tên đăng nhập..." 
                           value="${param.search}" class="form-input">
                    <button type="submit" class="btn-search">
                        <i class="fas fa-search"></i>
                        Tìm kiếm
                    </button>
                </div>
                <div>
                    <select name="sort" onchange="this.form.submit()" class="form-select">
                        <option value="">Sắp xếp theo ngày tạo</option>
                        <option value="asc" ${param.sort == 'asc' ? 'selected' : ''}>Cũ nhất trước</option>
                        <option value="desc" ${param.sort == 'desc' ? 'selected' : ''}>Mới nhất trước</option>
                    </select>
                </div>
            </div>
        </form>

        <!-- Data Table -->
        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th><input type="checkbox" id="selectAll" class="checkbox"></th>
                        <th>ID</th>
                        <th>Tên đăng nhập</th>
                        <th>Mật khẩu</th>
                        <th>Vai trò</th>
                        <th>Trạng thái</th>
                        <th>Ngày tạo</th>
                        <th>Email</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${listA}" var="a">
                        <tr>
                            <td><input type="checkbox" value="${a.accountID}" class="checkbox" /></td>
                            <td><strong>${a.accountID}</strong></td>
                            <td>${a.username}</td>
                            <td class="password-mask">${fn:substring("••••••••••••••••", 0, fn:length(a.password))}</td>
                            <td>
                                <span class="badge ${a.role == 'Manager' ? 'badge-manager' : 'badge-staff'}">
                                    ${a.role}
                                </span>
                            </td>
                            <td>
                                <span class="badge ${a.isActive ? 'badge-active' : 'badge-inactive'}">
                                    ${a.isActive ? 'Hoạt động' : 'Không hoạt động'}
                                </span>
                            </td>
                            <td>${a.createdAt}</td>
                            <td>${a.email}</td>
                            <td>
                                <div class="action-buttons">
                                    <a href="loadAccount?aid=${a.accountID}" class="btn-action btn-edit" title="Chỉnh sửa">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    <a href="deleteAccount?aid=${a.accountID}" class="btn-action btn-delete" title="Xóa"
                                       onclick="return confirm('Bạn có chắc chắn muốn xóa tài khoản này?')">
                                        <i class="fas fa-trash"></i>
                                    </a>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <!-- Pagination -->
        <div class="pagination">
            <c:if test="${currentPage > 1}">
                <a href="managerAccount?page=${currentPage - 1}&search=${param.search}&sort=${param.sort}">
                    <i class="fas fa-chevron-left"></i> Trước
                </a>
            </c:if>

            <c:forEach begin="1" end="${totalPages}" var="i">
                <c:choose>
                    <c:when test="${i == currentPage}">
                        <span class="active">${i}</span>
                    </c:when>
                    <c:otherwise>
                        <a href="managerAccount?page=${i}&search=${param.search}&sort=${param.sort}">${i}</a>
                    </c:otherwise>
                </c:choose>
            </c:forEach>

            <c:if test="${currentPage < totalPages}">
                <a href="managerAccount?page=${currentPage + 1}&search=${param.search}&sort=${param.sort}">
                    Sau <i class="fas fa-chevron-right"></i>
                </a>
            </c:if>
        </div>

        <!-- Back Button -->
        <a href="Manager/manager.jsp">
            <button type="button" class="btn-back">Quay lại trang chủ</button>
        </a>
    </div>

    <!-- Add Account Modal -->
    <div id="addAccountModal" class="amodal">
        <div class="amodal-dialog">
            <form action="${pageContext.request.contextPath}/addAccount" method="post">
                <div class="amodal-header">
                    <h4 class="amodal-title">Thêm tài khoản mới</h4>
                </div>
                <div class="amodal-body">
                    <div class="form-group">
                        <label for="username" class="form-label">Tên đăng nhập</label>
                        <input id="username" name="username" type="text" class="form-control" 
                               placeholder="Nhập tên đăng nhập" required>
                    </div>

                    <div class="form-group">
                        <label for="password" class="form-label">Mật khẩu</label>
                        <input id="password" name="password" type="password" class="form-control" 
                               placeholder="Nhập mật khẩu" required>
                    </div>

                    <div class="form-group">
                        <label for="role" class="form-label">Vai trò</label>
                        <select id="role" name="role" class="form-control" required>
                            <option value="Receptionist">Lễ tân</option>
                            <option value="Staff">Nhân viên</option>
                            <option value="Manager">Quản lý</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="isActive" class="form-label">Trạng thái hoạt động</label>
                        <select id="isActive" name="isActive" class="form-control" required>
                            <option value="true">Có</option>
                            <option value="false">Không</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="email" class="form-label">Email</label>
                        <input id="email" name="email" type="email" class="form-control" 
                               placeholder="example@mail.com" required>
                    </div>
                </div>

                <div class="amodal-footer">
                    <button type="button" class="btn-cancel" onclick="closeModal()">Hủy</button>
                    <button type="submit" class="btn-submit">Thêm tài khoản</button>
                </div>
            </form>

            <c:if test="${not empty error}">
                <div style="padding: 0 24px 20px; color: #dc2626; font-size: 14px;">
                    ${error}
                </div>
            </c:if>
        </div>
    </div>

    <script>
        // Modal functions
        function openModal() {
            document.getElementById("addAccountModal").style.display = "block";
        }

        function closeModal() {
            document.getElementById("addAccountModal").style.display = "none";
        }

        // Close modal when clicking outside
        window.addEventListener("click", function (event) {
            const modal = document.getElementById("addAccountModal");
            if (event.target === modal) {
                closeModal();
            }
        });

        // Select all checkbox functionality
        document.getElementById("selectAll").addEventListener("change", function() {
            const checkboxes = document.querySelectorAll('tbody input[type="checkbox"]');
            checkboxes.forEach(checkbox => {
                checkbox.checked = this.checked;
            });
        });

        // Show modal if there's an error
        <c:if test="${showAddModal}">
            window.onload = function () {
                openModal();
            };
        </c:if>
    </script>
</body>
</html>