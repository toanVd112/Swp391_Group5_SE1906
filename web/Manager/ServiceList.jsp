<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="model.Account" %>
<%
    Account account = (Account) session.getAttribute("account");
    if (account == null || !"Manager".equals(account.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Service List</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            html, body {
                height: 100%;
                margin: 0;
                overflow-x: hidden;
            }
            body {
                background-color: #fff;
                color: #333;
                padding-top: 56px;
                display: flex;
                flex-direction: column;
            }
            .main-content {
                margin-left: 250px;
                padding-bottom: 70px;
                flex: 1;
            }
            .sidebar {
                width: 250px;
                background-color: #f8f9fa;
                height: calc(100vh - 56px);
                position: fixed;
                top: 56px;
                left: 0;
                overflow-y: auto;
            }
            .table th {
                background-color: #f8f9fa;
            }
            .pagination {
                justify-content: center;
                position: fixed;
                bottom: 0;
                left: 0;
                right: 0;
                background-color: #fff;
                padding: 10px 0;
                border-top: 1px solid #dee2e6;
                z-index: 1000;
            }
        </style>
    </head>
    <body>
        <nav class="navbar navbar-expand-lg navbar-light bg-light fixed-top">
            <div class="container-fluid">
                <a class="navbar-brand" href="#">Hotel Management</a>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav ms-auto">
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                                Welcome, ${account.role}
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end">
                                <li><a class="dropdown-item" href="#">Profile</a></li>
                                <li><a class="dropdown-item" href="#">Settings</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/Logout">Logout</a></li>
                            </ul>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>

        <div class="d-flex">
            <%@ include file="sidebar.jsp" %>

            <div class="main-content p-3">
                <div class="container">
                    <div class="d-flex justify-content-between mb-3 align-items-center">
                        <form method="GET" action="${pageContext.request.contextPath}/services/list" class="d-flex gap-2">
                            <input type="text" class="form-control" name="searchKeyword" placeholder="Search by name..." value="${currentSearchKeyword}" style="width: 200px;">
                            <select class="form-select" name="filterType" style="width: 150px;">
                                <option value="">All Types</option>
                                <c:forEach items="${serviceTypeList}" var="t">
                                    <option value="${t}" ${t == currentFilterType ? 'selected' : ''}>${t}</option>
                                </c:forEach>
                            </select>
                            <select class="form-select" name="filterStatus" style="width: 150px;">
                                <option value="">All Status</option>
                                <option value="1" ${"1" == currentFilterStatus ? 'selected' : ''}>Available</option>
                                <option value="0" ${"0" == currentFilterStatus ? 'selected' : ''}>Not Available</option>
                            </select>
                            <button type="submit" class="btn btn-primary btn-sm">Filter</button>
                            <a href="${pageContext.request.contextPath}/services/list" class="btn btn-secondary btn-sm">Clear</a>
                        </form>

                        <button class="btn btn-success btn-sm ms-2" onclick="window.location.href = '${pageContext.request.contextPath}/Manager/addService.jsp'">Add New</button>
                    </div>

                    <table class="table table-bordered table-striped">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Name</th>
                                <th>Price</th>
                                <th>Type</th>
                                <th>Status</th>
                                <th>Created By</th>
                                <th>Create Date</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:if test="${empty serviceList}">
                                <tr>
                                    <td colspan="8" class="text-center">No services found.</td>
                                </tr>
                            </c:if>
                            <c:forEach items="${serviceList}" var="s">
                                <tr>
                                    <td>${s.id}</td>
                                    <td>${s.name}</td>
                                    <td>${s.price}</td>
                                    <td>${s.type == null ? "N/A" : s.type}</td>
                                    <td>${s.status == "1" ? "Available" : "Not Available"}</td>
                                    <td>${s.createdBy == null ? "N/A" : s.createdBy}</td>
                                    <td>${s.createDate}</td>
                                    <td>
                                        <button class="btn btn-primary btn-sm mb-1" onclick="window.location.href = '${pageContext.request.contextPath}/Manager/editService.jsp?id=${s.id}'">Edit</button>
                                        <button class="btn btn-info btn-sm mb-1" onclick="showImageModal('${s.serviceImage}')">View Image</button>
                                        <c:choose>
                                            <c:when test="${s.status == '1'}">
                                                <button class="btn btn-danger btn-sm" onclick="toggleStatus(${s.id})">Inactive</button>
                                            </c:when>
                                            <c:otherwise>
                                                <button class="btn btn-success btn-sm" onclick="toggleStatus(${s.id})">Active</button>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Modal hiển thị hình ảnh dịch vụ -->
        <div class="modal fade" id="imageModal" tabindex="-1" aria-labelledby="imageModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="imageModalLabel">Service Image</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body text-center">
                        <img id="serviceImage" src="" alt="Service Image" class="img-fluid rounded">
                    </div>
                </div>
            </div>
        </div>

<!--        <nav aria-label="Page navigation">
            <ul class="pagination">
                <li class="page-item"><a class="page-link" href="#">««</a></li>
                <li class="page-item"><a class="page-link" href="#">«</a></li>
                <li class="page-item active"><a class="page-link" href="#">1</a></li>
                <li class="page-item"><a class="page-link" href="#">»</a></li>
                <li class="page-item"><a class="page-link" href="#">»»</a></li>
            </ul>
        </nav>-->

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                                    function toggleStatus(serviceId) {
                                                        fetch('${pageContext.request.contextPath}/services/toggle', {
                                                            method: 'POST',
                                                            headers: {'Content-Type': 'application/json'},
                                                            body: JSON.stringify({id: serviceId})
                                                        })
                                                                .then(response => response.json())
                                                                .then(data => {
                                                                    if (data.success) {
                                                                        alert(data.message || "Status updated.");
                                                                        window.location.reload();
                                                                    } else {
                                                                        alert(data.message || "Update failed.");
                                                                    }
                                                                })
                                                                .catch(error => {
                                                                    alert("Error: " + error.message);
                                                                });
                                                    }

                                                    function showImageModal(imagePath) {
                                                        const fullPath = imagePath.startsWith('http') ? imagePath : '${pageContext.request.contextPath}/' + imagePath;
                                                        document.getElementById("serviceImage").src = fullPath;
                                                        const modal = new bootstrap.Modal(document.getElementById('imageModal'));
                                                        modal.show();
                                                    }
        </script>
    </body>
</html>
