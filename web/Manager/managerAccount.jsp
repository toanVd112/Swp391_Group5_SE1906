<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Account Management</title>
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

            .table td {
                white-space: nowrap;
                text-overflow: ellipsis;
                overflow: hidden;
                max-width: 200px;
            }
        </style>
    </head>
    <body class="bg-light">
        <div class="container py-4">
            <div class="card shadow-sm">
                <div class="card-header bg-white d-flex justify-content-between align-items-center">
                    <h2 class="h4 mb-0">Account <strong>Management</strong></h2>
                    <button type="button" class="btn btn-success btn-sm" data-bs-toggle="modal" data-bs-target="#addAccountModal">
                        Add Account
                    </button>
                </div>

                <div class="card-body">
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

                    <!-- Filter/Search -->
                    <form method="get" action="managerAccount" class="mb-4">
                        <div class="row g-3 align-items-center">
                            <div class="col-md-6">
                                <div class="input-group shadow-sm">
                                    <span class="input-group-text bg-white">
                                        <i class="fas fa-search text-muted"></i>
                                    </span>
                                    <input type="text" name="search" value="${param.search}" class="form-control" placeholder="Search by username...">
                                </div>
                            </div>
                            <div class="col-md-3">
                                <select name="sort" onchange="this.form.submit()" class="form-select shadow-sm">
                                    <option value="">Sort by created date</option>
                                    <option value="asc" ${param.sort == 'asc' ? 'selected' : ''}>Oldest first</option>
                                    <option value="desc" ${param.sort == 'desc' ? 'selected' : ''}>Newest first</option>
                                </select>
                            </div>
                            <div class="col-md-3 d-flex gap-2">
                                <button type="submit" class="btn btn-primary btn-sm">Filter</button>
                                <a href="managerAccount" class="btn btn-secondary btn-sm">Reset</a>
                            </div>
                        </div>
                    </form>

                    <!-- Account Table -->
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
                                        <td>
                                            <span class="badge
                                                  ${account.role == 'Manager' ? 'badge-manager' :
                                                    account.role == 'Receptionist' ? 'badge-receptionist' : 'badge-staff'}">
                                                      ${account.role}
                                                  </span>
                                            </td>
                                            <td>
                                                <span class="badge ${account.isActive ? 'badge-active' : 'badge-inactive'}">
                                                    ${account.isActive ? 'Active' : 'Inactive'}
                                                </span>
                                            </td>
                                            <td>${account.createdAt}</td>
                                            <td>${account.email}</td>
                                            <td>
                                                <div class="d-flex gap-1">
                                                    <a href="loadAccount?aid=${account.accountID}" class="btn btn-primary btn-sm">Edit</a>
                                                    <a href="deleteAccount?aid=${account.accountID}" class="btn btn-danger btn-sm"
                                                       onclick="return confirm('Are you sure you want to delete this account?')">Delete</a>
                                                    <a href="staffProfile?aid=${account.accountID}" class="btn btn-info btn-sm">Details</a>
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
                                            &laquo;
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
                                            &raquo;
                                        </a>
                                    </li>
                                </c:if>
                            </ul>
                        </nav>
                    </div>

                    <div class="card-footer bg-white">
                        <a href="Manager/manager.jsp" class="btn btn-primary btn-sm">
                            Back to Dashboard
                        </a>
                    </div>
                </div>
            </div>

            <!-- Add Account Modal (optional fields) -->
            <div class="modal fade" id="addAccountModal" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog">
                    <form action="addAccount" method="post" id="accountForm" class="modal-content" novalidate>
                        <div class="modal-header">
                            <h5 class="modal-title">Add New Account</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <%-- Add your form fields here as in previous versions (username, password, role, email, isActive) --%>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-success btn-sm">Add</button>
                        </div>
                    </form>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            <script>
               document.getElementById('selectAll').addEventListener('change', function () {
                   document.querySelectorAll('tbody input[type="checkbox"]').forEach(cb => cb.checked = this.checked);
               });

                <c:if test="${showAddModal}">
               document.addEventListener('DOMContentLoaded', function () {
                   new bootstrap.Modal(document.getElementById('addAccountModal')).show();
               });
                </c:if>
            </script>
        </body>
    </html>
