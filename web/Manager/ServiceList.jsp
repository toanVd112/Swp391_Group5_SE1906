<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
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
        }
        .table th {
            background-color: #f8f9fa;
        }
        .pagination {
            justify-content: center;
            padding: 10px 0;
            border-top: 1px solid #dee2e6;
            margin-top: 20px;
        }
        .page-item.disabled .page-link {
            pointer-events: none;
            opacity: 0.65;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="d-flex justify-content-between mb-3 align-items-center">
            <form method="GET" action="${pageContext.request.contextPath}/serviceslist" class="d-flex gap-2">
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
                <a href="${pageContext.request.contextPath}/serviceslist" class="btn btn-secondary btn-sm">Clear</a>
            </form>
            <button class="btn btn-success btn-sm ms-2" onclick="window.location.href = '${pageContext.request.contextPath}/Manager/manager.jsp?page=addService.jsp'">Add New</button>
        </div>

        <table class="table table-bordered table-striped">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Price</th>
                    <th>Type</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <c:if test="${empty serviceList}">
                    <tr>
                        <td colspan="6" class="text-center">No services found.</td>
                    </tr>
                </c:if>
                <c:forEach items="${serviceList}" var="s">
                    <tr>
                        <td>${s.id}</td>
                        <td>${s.name}</td>
                        <td><fmt:formatNumber value='${s.price}' pattern='###,###,###₫'/></td>
                        <td>${s.type == null ? "N/A" : s.type}</td>
                        <td>${s.status == "1" ? "Available" : "Not Available"}</td>
                        <td>
                            <button class="btn btn-primary btn-sm mb-1" onclick="window.location.href = '${pageContext.request.contextPath}/Manager/manager.jsp?page=editService.jsp?id=${s.id}'">Edit</button>
                            <c:choose>
                                <c:when test="${s.status == '1'}">
                                    <button class="btn btn-danger btn-sm mb-1" style="width: 80px" onclick="toggleStatus(${s.id})">Inactive</button>
                                </c:when>
                                <c:otherwise>
                                    <button class="btn btn-success btn-sm mb-1" style="width: 80px" onclick="toggleStatus(${s.id})">Active</button>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <!-- Thanh phân trang -->
        <c:if test="${totalPages > 1}">
            <nav aria-label="Page navigation">
                <ul class="pagination">
                    <!-- Nút đến trang đầu -->
                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/serviceslist?page=1&searchKeyword=${currentSearchKeyword}&filterType=${currentFilterType}&filterStatus=${currentFilterStatus}&sortBy=${currentSortBy}">««</a>
                    </li>
                    <!-- Nút trang trước -->
                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/serviceslist?page=${currentPage - 1}&searchKeyword=${currentSearchKeyword}&filterType=${currentFilterType}&filterStatus=${currentFilterStatus}&sortBy=${currentSortBy}">«</a>
                    </li>
                    <!-- Hiển thị các số trang -->
                    <c:forEach var="i" begin="${currentPage - 2 > 0 ? currentPage - 2 : 1}" end="${currentPage + 2 <= totalPages ? currentPage + 2 : totalPages}">
                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/serviceslist?page=${i}&searchKeyword=${currentSearchKeyword}&filterType=${currentFilterType}&filterStatus=${currentFilterStatus}&sortBy=${currentSortBy}">${i}</a>
                        </li>
                    </c:forEach>
                    <!-- Nút trang sau -->
                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/serviceslist?page=${currentPage + 1}&searchKeyword=${currentSearchKeyword}&filterType=${currentFilterType}&filterStatus=${currentFilterStatus}&sortBy=${currentSortBy}">»</a>
                    </li>
                    <!-- Nút đến trang cuối -->
                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/serviceslist?page=${totalPages}&searchKeyword=${currentSearchKeyword}&filterType=${currentFilterType}&filterStatus=${currentFilterStatus}&sortBy=${currentSortBy}">»»</a>
                    </li>
                </ul>
            </nav>
        </c:if>

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

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            let msg = '${msg}';
            if (msg !== '') {
                alert(msg);
            }

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

                setTimeout(() => {
                    window.location.href = '${pageContext.request.contextPath}/serviceslist?page=${currentPage}&searchKeyword=${currentSearchKeyword}&filterType=${currentFilterType}&filterStatus=${currentFilterStatus}&sortBy=${currentSortBy}';
                }, 1000);
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