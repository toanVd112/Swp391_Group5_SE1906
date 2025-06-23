<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý Tài khoản</title>
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
            .badge-manager {
                background-color: #dbeafe;
                color: #1d4ed8;
            }
            .badge-staff {
                background-color: #f3f4f6;
                color: #374151;
            }
            .badge-receptionist {
                background-color: #f0fdf4;
                color: #166534;
            }
            .table-hover tbody tr:hover {
                background-color: rgba(0, 0, 0, 0.02);
            }
            .form-control:invalid, .form-select:invalid {
                border-color: #dc3545;
            }
            .form-control:valid, .form-select:valid {
                border-color: #198754;
            }
        </style>
    </head>
    <body class="bg-light">
        <div class="container py-4">
            <div class="card shadow-sm">
                <div class="card-header bg-white d-flex justify-content-between align-items-center">
                    <h2 class="h4 mb-0">Quản lý <strong>Tài khoản</strong></h2>
                    <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#addAccountModal">
                        <i class="fas fa-plus me-2"></i>Thêm tài khoản
                    </button>
                </div>

                <div class="card-body">
                    <!-- Thông báo lỗi/thành công -->
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

                    <!-- Search and Filter Form -->
                    <form method="get" action="managerAccount" class="mb-4">
                        <div class="row g-3">
                            <div class="col-md-8">
                                <div class="input-group">
                                    <input type="text" name="search" value="${param.search}" 
                                           class="form-control" placeholder="Tìm kiếm theo tên đăng nhập...">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-search me-1"></i> Tìm kiếm
                                    </button>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <select name="sort" onchange="this.form.submit()" class="form-select">
                                    <option value="">Sắp xếp theo ngày tạo</option>
                                    <option value="asc" ${param.sort == 'asc' ? 'selected' : ''}>Cũ nhất trước</option>
                                    <option value="desc" ${param.sort == 'desc' ? 'selected' : ''}>Mới nhất trước</option>
                                </select>
                            </div>
                        </div>
                    </form>

                    <!-- Accounts Table -->
                    <div class="table-responsive">
                        <table class="table table-hover table-bordered">
                            <thead class="table-primary">
                                <tr>
                                    <th width="40"><input type="checkbox" id="selectAll" class="form-check-input"></th>
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
                                <c:forEach items="${listA}" var="account">
                                    <tr>
                                        <td><input type="checkbox" value="${account.accountID}" class="form-check-input"></td>
                                        <td>${account.accountID}</td>
                                        <td>${account.username}</td>
                                        <td class="password-mask">••••••••</td>
                                        <td>
                                            <span class="badge ${account.role == 'Manager' ? 'badge-manager' : 
                                                                 account.role == 'Receptionist' ? 'badge-receptionist' : 'badge-staff'}">
                                                      ${account.role}
                                                  </span>
                                            </td>
                                            <td>
                                                <span class="badge ${account.isActive ? 'badge-active' : 'badge-inactive'}">
                                                    ${account.isActive ? 'Hoạt động' : 'Không hoạt động'}
                                                </span>
                                            </td>
                                            <td>${account.createdAt}</td>
                                            <td>${account.email}</td>
                                            <td>
                                                <div class="d-flex gap-2">
                                                    <a href="loadAccount?aid=${account.accountID}" class="btn btn-sm btn-outline-primary" 
                                                       title="Chỉnh sửa">
                                                        <i class="fas fa-edit"></i>
                                                    </a>
                                                    <a href="deleteAccount?aid=${account.accountID}" class="btn btn-sm btn-outline-danger" 
                                                       title="Xóa" onclick="return confirm('Bạn có chắc chắn muốn xóa tài khoản này?')">
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
                        <nav class="mt-4">
                            <ul class="pagination justify-content-center">
                                <c:if test="${currentPage > 1}">
                                    <li class="page-item">
                                        <a class="page-link" href="managerAccount?page=${currentPage - 1}&search=${param.search}&sort=${param.sort}">
                                            <i class="fas fa-chevron-left"></i>
                                        </a>
                                    </li>
                                </c:if>

                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                                        <a class="page-link" href="managerAccount?page=${i}&search=${param.search}&sort=${param.sort}">${i}</a>
                                    </li>
                                </c:forEach>

                                <c:if test="${currentPage < totalPages}">
                                    <li class="page-item">
                                        <a class="page-link" href="managerAccount?page=${currentPage + 1}&search=${param.search}&sort=${param.sort}">
                                            <i class="fas fa-chevron-right"></i>
                                        </a>
                                    </li>
                                </c:if>
                            </ul>
                        </nav>
                    </div>

                    <div class="card-footer bg-white">
                        <a href="Manager/manager.jsp" class="btn btn-primary">
                            <i class="fas fa-home me-2"></i>Quay lại trang chủ
                        </a>
                    </div>
                </div>
            </div>

            <!-- Add Account Modal -->
            <div class="modal fade" id="addAccountModal" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog">
                    <form action="addAccount" method="post" id="accountForm" class="modal-content" novalidate>
                        <div class="modal-header">
                            <h5 class="modal-title">Thêm tài khoản mới</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div class="mb-3">
                                <label for="username" class="form-label">Tên đăng nhập</label>
                                <input type="text" class="form-control ${not empty usernameError ? 'is-invalid' : ''}" 
                                       id="username" name="username" value="${username}" 
                                       pattern="^\S{4,20}$" required
                                       oninput="validateUsername(this)">
                                <div class="invalid-feedback">
                                    <c:choose>
                                        <c:when test="${not empty usernameError}">${usernameError}</c:when>
                                        <c:otherwise>Tên đăng nhập phải từ 4-20 ký tự và không chứa khoảng trắng</c:otherwise>
                                    </c:choose>
                                </div>
                                <small class="text-muted">Từ 4-20 ký tự, không chứa khoảng trắng</small>
                            </div>

                            <div class="mb-3">
                                <label for="password" class="form-label">Mật khẩu</label>
                                <input type="password" class="form-control ${not empty passwordError ? 'is-invalid' : ''}" 
                                       id="password" name="password" 
                                       pattern="^\S{6,}$" required
                                       oninput="validatePassword(this)">
                                <div class="invalid-feedback">
                                    <c:choose>
                                        <c:when test="${not empty passwordError}">${passwordError}</c:when>
                                        <c:otherwise>Mật khẩu phải có ít nhất 6 ký tự và không chứa khoảng trắng</c:otherwise>
                                    </c:choose>
                                </div>
                                <small class="text-muted">Ít nhất 6 ký tự, không chứa khoảng trắng</small>
                            </div>

                            <div class="mb-3">
                                <label for="email" class="form-label">Email</label>
                                <input type="email" class="form-control ${not empty emailError ? 'is-invalid' : ''}" 
                                       id="email" name="email" value="${email}" required>
                                <div class="invalid-feedback">${emailError}</div>
                            </div>

                            <div class="mb-3">
                                <label for="role" class="form-label">Vai trò</label>
                                <select class="form-select ${not empty roleError ? 'is-invalid' : ''}" 
                                        id="role" name="role" required>
                                    <option value="Receptionist" ${role == 'Receptionist' ? 'selected' : ''}>Lễ tân</option>
                                    <option value="Staff" ${role == 'Staff' ? 'selected' : ''}>Nhân viên</option>
                                </select>
                                <div class="invalid-feedback">${roleError}</div>
                            </div>

                            <div class="mb-3">
                                <label for="isActive" class="form-label">Trạng thái hoạt động</label>
                                <select class="form-select" id="isActive" name="isActive">
                                    <option value="true" selected>Hoạt động</option>
                                    <option value="false">Không hoạt động</option>
                                </select>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-success">Thêm tài khoản</button>
                        </div>
                    </form>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            <script>
                                                           // Select all checkbox functionality
                                                           document.getElementById('selectAll').addEventListener('change', function () {
                                                               const checkboxes = document.querySelectorAll('tbody input[type="checkbox"]');
                                                               checkboxes.forEach(checkbox => checkbox.checked = this.checked);
                                                           });

                                                           // Show modal if there are errors
                <c:if test="${showAddModal}">
                                                           document.addEventListener('DOMContentLoaded', function () {
                                                               const modal = new bootstrap.Modal(document.getElementById('addAccountModal'));
                                                               modal.show();
                                                           });
                </c:if>

                                                           // Validate username in real-time
                                                           function validateUsername(input) {
                                                               const errorElement = input.nextElementSibling;
                                                               const username = input.value;

                                                               if (username.includes(' ')) {
                                                                   input.classList.add('is-invalid');
                                                                   errorElement.textContent = 'Tên đăng nhập không được chứa khoảng trắng';
                                                                   errorElement.style.display = 'block';
                                                               } else if (username.length > 0 && username.length < 4) {
                                                                   input.classList.add('is-invalid');
                                                                   errorElement.textContent = 'Tên đăng nhập phải có ít nhất 4 ký tự';
                                                                   errorElement.style.display = 'block';
                                                               } else if (username.length > 20) {
                                                                   input.classList.add('is-invalid');
                                                                   errorElement.textContent = 'Tên đăng nhập không được quá 20 ký tự';
                                                                   errorElement.style.display = 'block';
                                                               } else {
                                                                   input.classList.remove('is-invalid');
                                                                   errorElement.style.display = 'none';
                                                               }
                                                           }

                                                           // Validate password in real-time
                                                           function validatePassword(input) {
                                                               const errorElement = input.nextElementSibling;
                                                               const password = input.value;

                                                               if (password.includes(' ')) {
                                                                   input.classList.add('is-invalid');
                                                                   errorElement.textContent = 'Mật khẩu không được chứa khoảng trắng';
                                                                   errorElement.style.display = 'block';
                                                               } else if (password.length > 0 && password.length < 6) {
                                                                   input.classList.add('is-invalid');
                                                                   errorElement.textContent = 'Mật khẩu phải có ít nhất 6 ký tự';
                                                                   errorElement.style.display = 'block';
                                                               } else {
                                                                   input.classList.remove('is-invalid');
                                                                   errorElement.style.display = 'none';
                                                               }
                                                           }

                                                           // Form validation before submit
                                                           document.getElementById('accountForm').addEventListener('submit', function (e) {
                                                               let isValid = true;
                                                               const form = this;

                                                               // Validate username
                                                               const username = form.querySelector('#username').value;
                                                               if (username.includes(' ') || username.length < 4 || username.length > 20) {
                                                                   form.querySelector('#username').classList.add('is-invalid');
                                                                   isValid = false;
                                                               }

                                                               // Validate password
                                                               const password = form.querySelector('#password').value;
                                                               if (password.includes(' ') || password.length < 6) {
                                                                   form.querySelector('#password').classList.add('is-invalid');
                                                                   isValid = false;
                                                               }

                                                               if (!isValid) {
                                                                   e.preventDefault();
                                                                   // Scroll to first error
                                                                   const firstInvalid = form.querySelector('.is-invalid');
                                                                   if (firstInvalid) {
                                                                       firstInvalid.scrollIntoView({behavior: 'smooth', block: 'center'});
                                                                   }
                                                               }
                                                           });
            </script>
        </body>
    </html>