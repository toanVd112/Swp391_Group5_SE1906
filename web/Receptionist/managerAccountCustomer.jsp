<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Quản lý Tài khoản</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            .password-mask {
                font-family: monospace;
                letter-spacing: 2px;
            }
            .badge-active {
                background-color: #dcfce7;
                color: #166534;
            }
            .badge-inactive {
                background-color: #fee2e2;
                color: #dc2626;
            }
            .table-hover tbody tr:hover {
                background-color: rgba(0, 0, 0, 0.02);
            }
        </style>
    </head>
    <body class="bg-light">
        <div class="container py-4">
            <div class="card shadow-sm">
                <div class="card-header bg-white d-flex justify-content-between align-items-center">
                    <h2 class="h4 mb-0">Quản lý <strong>Tài khoản</strong></h2>
                </div>

                <div class="card-body">
                    <!-- Thông báo -->
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show mb-4">
                            ${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    <c:if test="${not empty success}">
                        <div class="alert alert-success alert-dismissible fade show mb-4">
                            ${success}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <!-- Form tìm kiếm -->
                    <form method="get" action="managerAccountC" class="mb-4">
                        <div class="row g-3 align-items-center">
                            <div class="col-md-7">
                                <div class="input-group shadow-sm">
                                    <span class="input-group-text bg-white"><i class="fas fa-search text-muted"></i></span>
                                    <input type="text" name="search" value="${param.search}" class="form-control" placeholder="Tìm kiếm theo tên đăng nhập...">
                                </div>
                            </div>
                            <div class="col-md-3">
                                <select name="sort" onchange="this.form.submit()" class="form-select shadow-sm">
                                    <option value="">Sắp xếp theo ngày tạo</option>
                                    <option value="asc" ${param.sort == 'asc' ? 'selected' : ''}>Cũ nhất trước</option>
                                    <option value="desc" ${param.sort == 'desc' ? 'selected' : ''}>Mới nhất trước</option>
                                </select>
                            </div>
                            <div class="col-md-2 d-flex gap-2">
                                <button type="submit" class="btn btn-primary btn-sm">Tìm kiếm</button>
                                <a href="managerAccountC" class="btn btn-secondary btn-sm">Đặt lại</a>
                            </div>
                        </div>
                    </form>

                    <!-- Bảng tài khoản -->
                    <div class="table-responsive">
                        <table class="table table-hover table-bordered">
                            <thead class="table-primary">
                                <tr>
                                    <th><input type="checkbox" id="selectAll" class="form-check-input"></th>
                                    <th>ID</th>
                                    <th>Username</th>
                                    <th>Password</th>
                                    <th>Role</th>
                                    <th>Status</th>
                                    <th>Created At</th>
                                    <th>Email</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${listA}" var="account">
                                    <tr>
                                        <td><input type="checkbox" value="${account.accountID}" class="form-check-input"></td>
                                        <td>${account.accountID}</td>
                                        <td>${account.username}</td>
                                        <td class="password-mask">••••••••</td>
                                        <td>${account.role}</td>
                                        <td>
                                            <span class="badge ${account.isActive ? 'badge-active' : 'badge-inactive'}">
                                                ${account.isActive ? 'Hoạt động' : 'Không hoạt động'}
                                            </span>
                                        </td>
                                        <td>${account.createdAt}</td>
                                        <td>${account.email}</td>
                                        <td>
                                            <div class="d-flex gap-2">
                                                <form action="loadAccountC" method="post">
                                                    <input type="hidden" name="aid" value="${account.accountID}" />
                                                    <button type="submit" class="btn btn-primary btn-sm">Edit</button>
                                                </form>
                                                <a href="deleteAccountC?aid=${account.accountID}" class="btn btn-danger btn-sm"
                                                   onclick="return confirm('Bạn có chắc chắn muốn xóa tài khoản này?')">Delete</a>
                                                <a href="staffProfileC?aid=${account.accountID}" class="btn btn-info btn-sm">Details</a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <!-- Phân trang -->
                    <nav class="mt-4">
                        <ul class="pagination justify-content-center">
                            <c:if test="${currentPage > 1}">
                                <li class="page-item">
                                    <a class="page-link" href="managerAccountC?page=${currentPage - 1}&search=${param.search}&sort=${param.sort}">
                                        &laquo;
                                    </a>
                                </li>
                            </c:if>
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                    <a class="page-link" href="managerAccountC?page=${i}&search=${param.search}&sort=${param.sort}">${i}</a>
                                </li>
                            </c:forEach>
                            <c:if test="${currentPage < totalPages}">
                                <li class="page-item">
                                    <a class="page-link" href="managerAccountC?page=${currentPage + 1}&search=${param.search}&sort=${param.sort}">
                                        &raquo;
                                    </a>
                                </li>
                            </c:if>
                        </ul>
                    </nav>
                </div>

                <!-- Footer -->
                <div class="card-footer bg-white">
                    <a href="Receptionist/reception.jsp" class="btn btn-primary btn-sm">
                        <i class="fas fa-home me-2"></i>Quay lại trang chủ
                    </a>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                                   document.getElementById('selectAll').addEventListener('change', function () {
                                                       document.querySelectorAll('tbody input[type="checkbox"]').forEach(cb => cb.checked = this.checked);
                                                   });
        </script>
    </body>
</html>
