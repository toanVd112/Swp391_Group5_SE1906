<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý Tài khoản</title>

        <!-- External CSS -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

        <style>
            /* CSS Variables */
            :root {
                --color-active: #dcfce7;
                --color-active-text: #166534;
                --color-inactive: #fee2e2;
                --color-inactive-text: #dc2626;
                --color-manager: #dbeafe;
                --color-manager-text: #1d4ed8;
                --color-staff: #f3f4f6;
                --color-staff-text: #374151;
                --color-receptionist: #f0fdf4;
                --color-receptionist-text: #166534;
            }

            .password-mask {
                font-family: monospace;
                letter-spacing: 2px;
            }

            .badge-active {
                background-color: var(--color-active);
                color: var(--color-active-text);
            }

            .badge-inactive {
                background-color: var(--color-inactive);
                color: var(--color-inactive-text);
            }

            .badge-manager {
                background-color: var(--color-manager);
                color: var(--color-manager-text);
            }

            .badge-staff {
                background-color: var(--color-staff);
                color: var(--color-staff-text);
            }

            .badge-receptionist {
                background-color: var(--color-receptionist);
                color: var(--color-receptionist-text);
            }

            .table-hover tbody tr:hover {
                background-color: rgba(0, 0, 0, 0.02);
            }

            .form-control:invalid,
            .form-select:invalid {
                border-color: #dc3545;
            }

            .form-control:valid,
            .form-select:valid {
                border-color: #198754;
            }

            .table td {
                white-space: nowrap;
                text-overflow: ellipsis;
                overflow: hidden;
                max-width: 200px;
            }

            /* Responsive adjustments */
            @media (max-width: 768px) {
                .card-header {
                    flex-direction: column;
                    gap: 1rem;
                }

                .table-responsive {
                    overflow-x: auto;
                    -webkit-overflow-scrolling: touch;
                }

                .table td {
                    max-width: 150px;
                }
            }
        </style>
    </head>

    <body class="bg-light">
        <div class="container py-4">
            <div class="card shadow-sm">
                <div class="card-header bg-white d-flex justify-content-between align-items-center flex-wrap">
                    <h1 class="h4 mb-0">Quản lý <strong>Tài khoản</strong></h1>
                    <button type="button" class="btn btn-success" data-bs-toggle="modal"
                            data-bs-target="#addAccountModal">
                        <i class="fas fa-plus me-2"></i>Thêm tài khoản
                    </button>
                </div>

                <div class="card-body">
                    <!-- Notification Messages -->
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show mb-4">
                            ${fn:escapeXml(error)}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"
                                    aria-label="Close"></button>
                        </div>
                    </c:if>

                    <c:if test="${not empty success}">
                        <div class="alert alert-success alert-dismissible fade show mb-4">
                            ${fn:escapeXml(success)}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"
                                    aria-label="Close"></button>
                        </div>
                    </c:if>

                    <!-- Search and Filter Form -->
                    <form method="get" action="managerAccount" class="mb-4">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <div class="input-group shadow-sm">
                                    <span class="input-group-text bg-white">
                                        <i class="fas fa-search text-muted"></i>
                                    </span>
                                    <input type="text" name="search" value="${param.search}"
                                           class="form-control" placeholder="Search by username...">
                                </div>
                            </div>
                            <div class="col-md-3">
                                <select name="sort" onchange="this.form.submit()" class="form-select shadow-sm">
                                    <option value="">Sort by Created Date</option>
                                    <option value="asc" ${param.sort=='asc' ? 'selected' : '' }>Oldest</option>
                                    <option value="desc" ${param.sort=='desc' ? 'selected' : '' }>Newest
                                    </option>
                                </select>
                            </div>
                            <div class="col-md-3 d-flex gap-2">
                                <button type="submit" class="btn btn-primary btn-sm">Search</button>
                                <a href="managerAccount" class="btn btn-secondary btn-sm">Reset</a>
                            </div>
                        </div>
                    </form>

                    <!-- Accounts Table -->
                    <div class="table-responsive">
                        <table class="table table-hover table-bordered">
                            <thead class="table-primary">
                                <tr>
                                    <th width="40"><input type="checkbox" id="selectAll"
                                                          class="form-check-input"></th>
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
                                        <td><input type="checkbox" value="${account.accountID}"
                                                   class="form-check-input account-checkbox"></td>
                                        <td>${account.accountID}</td>
                                        <td>${fn:escapeXml(account.username)}</td>
                                        <td class="password-mask">••••••••</td>
                                        <td>
                                            <span class="badge ${account.role == 'Manager' ? 'badge-manager' : 
                                                                 account.role == 'Receptionist' ? 'badge-receptionist' : 'badge-staff'}">
                                                      ${fn:escapeXml(account.role)}
                                                  </span>
                                            </td>
                                            <td>
                                                <span
                                                    class="badge ${account.isActive ? 'badge-active' : 'badge-inactive'}">
                                                    ${account.isActive ? 'Hoạt động' : 'Không hoạt động'}
                                                </span>
                                            </td>
                                            <td>${fn:escapeXml(account.createdAt)}</td>
                                            <td>${fn:escapeXml(account.email)}</td>
                                            <td>
                                                <div class="d-flex gap-1">
                                                    <a href="loadAccount?aid=${account.accountID}"
                                                       class="btn btn-primary btn-sm">Edit</a>
                                                    <c:choose>
                                                        <c:when test="${account.isActive}">
                                                            <a href="deleteAccount?aid=${account.accountID}&action=deactivate"
                                                               class="btn btn-danger btn-sm"
                                                               onclick="return confirm('Bạn có chắc chắn muốn vô hiệu hóa tài khoản này?')">
                                                                Inactive
                                                            </a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <a href="deleteAccount?aid=${account.accountID}&action=activate"
                                                               class="btn btn-success btn-sm"
                                                               onclick="return confirm('Bạn có chắc chắn muốn kích hoạt lại tài khoản này?')">
                                                                Active
                                                            </a>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <!-- Pagination -->
                        <c:if test="${totalPages > 1}">
                            <nav class="mt-4">
                                <ul class="pagination justify-content-center">
                                    <c:if test="${currentPage > 1}">
                                        <li class="page-item">
                                            <a class="page-link"
                                               href="managerAccount?page=${currentPage - 1}&search=${fn:escapeXml(param.search)}&sort=${fn:escapeXml(param.sort)}">
                                                <i class="fas fa-chevron-left"></i>
                                            </a>
                                        </li>
                                    </c:if>

                                    <c:forEach begin="1" end="${totalPages}" var="i">
                                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                                            <a class="page-link"
                                               href="managerAccount?page=${i}&search=${fn:escapeXml(param.search)}&sort=${fn:escapeXml(param.sort)}">${i}</a>
                                        </li>
                                    </c:forEach>

                                    <c:if test="${currentPage < totalPages}">
                                        <li class="page-item">
                                            <a class="page-link"
                                               href="managerAccount?page=${currentPage + 1}&search=${fn:escapeXml(param.search)}&sort=${fn:escapeXml(param.sort)}">
                                                <i class="fas fa-chevron-right"></i>
                                            </a>
                                        </li>
                                    </c:if>
                                </ul>
                            </nav>
                        </c:if>
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
                            <button type="button" class="btn-close" data-bs-dismiss="modal"
                                    aria-label="Close"></button>
                        </div>

                        <div class="modal-body">
                            <div class="mb-3">
                                <label for="username" class="form-label">Tên đăng nhập <span
                                        class="text-danger">*</span></label>
                                <input type="text"
                                       class="form-control ${not empty usernameError ? 'is-invalid' : ''}"
                                       id="username" name="username" pattern="^\S{4,20}$" required>
                                <div class="invalid-feedback">
                                    <c:choose>
                                        <c:when test="${not empty usernameError}">${fn:escapeXml(usernameError)}
                                        </c:when>
                                        <c:otherwise>Tên đăng nhập phải từ 4-20 ký tự và không chứa khoảng trắng
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <small class="text-muted">Từ 4-20 ký tự, không chứa khoảng trắng</small>
                            </div>

                            <div class="mb-3">
                                <label for="password" class="form-label">Mật khẩu <span
                                        class="text-danger">*</span></label>
                                <input type="password"
                                       class="form-control ${not empty passwordError ? 'is-invalid' : ''}"
                                       id="password" name="password" pattern="^\S{6,20}$" required>
                                <div class="invalid-feedback">
                                    <c:choose>
                                        <c:when test="${not empty passwordError}">${fn:escapeXml(passwordError)}
                                        </c:when>
                                        <c:otherwise>Mật khẩu phải có ít nhất 6 ký tự và không chứa khoảng trắng
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <small class="text-muted">Ít nhất 6 ký tự, không chứa khoảng trắng</small>
                            </div>

                            <div class="mb-3">
                                <label for="email" class="form-label">Email <span
                                        class="text-danger">*</span></label>
                                <input type="email" class="form-control ${not empty emailError ? 'is-invalid' : ''}"
                                       id="email" name="email" maxlength="100" value="${fn:escapeXml(email)}" required>
                                <div class="invalid-feedback">${fn:escapeXml(emailError)}</div>
                            </div>

                            <div class="mb-3">
                                <label for="role" class="form-label">Vai trò <span
                                        class="text-danger">*</span></label>
                                <select class="form-select ${not empty roleError ? 'is-invalid' : ''}" id="role"
                                        name="role" required>
                                    <option value="">-- Chọn vai trò --</option>
                                    <option value="Receptionist" ${role=='Receptionist' ? 'selected' : '' }>Lễ tân
                                    </option>
                                    <option value="Staff" ${role=='Staff' ? 'selected' : '' }>Nhân viên</option>
                                </select>
                                <div class="invalid-feedback">${fn:escapeXml(roleError)}</div>
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

            <!-- JavaScript Libraries -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

            <script>
                                                                   document.addEventListener('DOMContentLoaded', function () {
                                                                       // Initialize elements
                                                                       const selectAllCheckbox = document.getElementById('selectAll');
                                                                       const accountCheckboxes = document.querySelectorAll('.account-checkbox');
                                                                       const deleteButtons = document.querySelectorAll('.delete-account');
                                                                       const accountForm = document.getElementById('accountForm');

                                                                       // Select all functionality
                                                                       if (selectAllCheckbox) {
                                                                           selectAllCheckbox.addEventListener('change', function () {
                                                                               accountCheckboxes.forEach(checkbox => {
                                                                                   checkbox.checked = this.checked;
                                                                               });
                                                                           });
                                                                       }

                                                                       // Delete account confirmation
                                                                       deleteButtons.forEach(button => {
                                                                           button.addEventListener('click', function () {
                                                                               const accountId = this.getAttribute('data-id');

                                                                               Swal.fire({
                                                                                   title: 'Xác nhận xóa',
                                                                                   text: 'Bạn có chắc chắn muốn xóa tài khoản này?',
                                                                                   icon: 'warning',
                                                                                   showCancelButton: true,
                                                                                   confirmButtonColor: '#d33',
                                                                                   cancelButtonColor: '#3085d6',
                                                                                   confirmButtonText: 'Xóa',
                                                                                   cancelButtonText: 'Hủy'
                                                                               }).then((result) => {
                                                                                   if (result.isConfirmed) {
                                                                                       window.location.href = 'deleteAccount?aid=' + accountId;
                                                                                   }
                                                                               });
                                                                           });
                                                                       });

                                                                       // Show modal if there are errors
                <c:if test="${showAddModal}">
                                                                       const addAccountModal = new bootstrap.Modal(document.getElementById('addAccountModal'));
                                                                       addAccountModal.show();
                </c:if>

                                                                       // Real-time validation for username
                                                                       const usernameInput = document.getElementById('username');
                                                                       if (usernameInput) {
                                                                           usernameInput.addEventListener('input', function () {
                                                                               validateUsername(this);
                                                                           });
                                                                       }

                                                                       // Real-time validation for password
                                                                       const passwordInput = document.getElementById('password');
                                                                       if (passwordInput) {
                                                                           passwordInput.addEventListener('input', function () {
                                                                               validatePassword(this);
                                                                           });
                                                                       }

                                                                       // Form validation before submit
                                                                       if (accountForm) {
                                                                           accountForm.addEventListener('submit', function (e) {
                                                                               let isValid = true;

                                                                               // Validate username
                                                                               const username = usernameInput.value.trim();
                                                                               if (username.includes(' ') || username.length < 4 || username.length > 20) {
                                                                                   usernameInput.classList.add('is-invalid');
                                                                                   isValid = false;
                                                                               }

                                                                               // Validate password
                                                                               const password = passwordInput.value.trim();
                                                                               if (password.includes(' ') || password.length < 6) {
                                                                                   passwordInput.classList.add('is-invalid');
                                                                                   isValid = false;
                                                                               }

                                                                               // Validate role
                                                                               const roleSelect = document.getElementById('role');
                                                                               if (!roleSelect.value) {
                                                                                   roleSelect.classList.add('is-invalid');
                                                                                   isValid = false;
                                                                               }

                                                                               if (!isValid) {
                                                                                   e.preventDefault();
                                                                                   // Scroll to first error
                                                                                   const firstInvalid = this.querySelector('.is-invalid');
                                                                                   if (firstInvalid) {
                                                                                       firstInvalid.scrollIntoView({behavior: 'smooth', block: 'center'});
                                                                                   }
                                                                               }
                                                                           });
                                                                       }

                                                                       // Validation functions
                                                                       function validateUsername(input) {
                                                                           const errorElement = input.nextElementSibling;
                                                                           const username = input.value.trim();

                                                                           if (username.includes(' ')) {
                                                                               showError(input, 'Tên đăng nhập không được chứa khoảng trắng');
                                                                           } else if (username.length > 0 && username.length < 4) {
                                                                               showError(input, 'Tên đăng nhập phải có ít nhất 4 ký tự');
                                                                           } else if (username.length > 20) {
                                                                               showError(input, 'Tên đăng nhập không được quá 20 ký tự');
                                                                           } else {
                                                                               clearError(input);
                                                                           }
                                                                       }

                                                                       function validatePassword(input) {
                                                                           const password = input.value.trim();

                                                                           if (password.includes(' ')) {
                                                                               showError(input, 'Mật khẩu không được chứa khoảng trắng');
                                                                           } else if (password.length > 0 && password.length < 6) {
                                                                               showError(input, 'Mật khẩu phải có ít nhất 6 ký tự');
                                                                           } else {
                                                                               clearError(input);
                                                                           }
                                                                       }

                                                                       function showError(input, message) {
                                                                           input.classList.add('is-invalid');
                                                                           const errorElement = input.nextElementSibling;
                                                                           errorElement.textContent = message;
                                                                           errorElement.style.display = 'block';
                                                                       }

                                                                       function clearError(input) {
                                                                           input.classList.remove('is-invalid');
                                                                           const errorElement = input.nextElementSibling;
                                                                           errorElement.style.display = 'none';
                                                                       }
                                                                   });
            </script>
        </body>

    </html>