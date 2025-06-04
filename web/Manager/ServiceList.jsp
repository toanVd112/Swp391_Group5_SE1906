<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="model.Account" %>
<%
    Account account = (Account) session.getAttribute("account");
    if (account == null || !"Manager".equals(account.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    // Các giá trị lọc hiện tại đã được servlet đặt vào request attributes
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Service List</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            /* Giữ nguyên CSS của bạn, hoặc điều chỉnh nếu cần */
            html, body { height: 100%; margin: 0; overflow-x: hidden; }
            body { background-color: #fff; color: #333; padding-top: 56px; display: flex; flex-direction: column; }
            .table { color: #333; background-color: #fff; }
            .table th { background-color: #f8f9fa; color: #333; }
            .table td { vertical-align: middle; }
            .pagination { justify-content: center; position: fixed; bottom: 0; left: 0; right: 0; background-color: #fff; padding: 10px 0; border-top: 1px solid #dee2e6; z-index: 1000; }
            .sidebar { width: 250px; background-color: #f8f9fa; height: calc(100vh - 56px); position: fixed; top: 56px; left: 0; overflow-y: auto; }
            .filter-section { display: flex; align-items: center; gap: 10px; }
            .main-content { margin-left: 250px; padding-bottom: 70px; /* Tăng padding để không bị che bởi pagination */ flex: 1; }
             /* Thêm style cho các nút Filter và Clear nếu muốn */
            .filter-section button, .filter-section a.btn {
                /* ví dụ: margin-left: 5px; */
            }
        </style>
    </head>
    <body>
        <nav class="navbar navbar-expand-lg navbar-light bg-light fixed-top"> <%-- Thay đổi bg-dark thành bg-light nếu muốn nền sáng hơn --%>
            <div class="container-fluid">
                <a class="navbar-brand" href="#">Hotel Management</a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav ms-auto">
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                Welcome, ${account.role} <%-- Nên dùng JSTL để truy cập thuộc tính của bean --%>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
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
                        <form method="GET" action="${pageContext.request.contextPath}/services/list" class="filter-section flex-grow-1">
                            <input type="text" class="form-control" name="searchKeyword" placeholder="Search by name..." style="width: 200px;" value="${currentSearchKeyword}">
                            
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

                    <table class="table table-striped table-bordered">
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
                                    <td colspan="8" class="text-center">No services found matching your criteria.</td>
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
                                        <button class="btn btn-primary btn-sm me-1" onclick="window.location.href = '${pageContext.request.contextPath}/Manager/editService.jsp?id=${s.id}'">Edit</button>
                                        <%-- Phần toggle status này sử dụng servlet ToggleServiceStatusServlet đã có của bạn --%>
                                        <c:if test="${s.status == '1'}">
                                            <button class="btn btn-danger btn-sm" onclick="toggleStatus(${s.id})">Inactive</button>
                                        </c:if>
                                        <c:if test="${s.status == '0'}">
                                            <button class="btn btn-success btn-sm" onclick="toggleStatus(${s.id})">Active</button>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <nav aria-label="Page navigation">
            <ul class="pagination">
                <li class="page-item"><a class="page-link" href="#">««</a></li>
                <li class="page-item"><a class="page-link" href="#">«</a></li>
                <li class="page-item active"><a class="page-link" href="#">1</a></li>
                <li class="page-item"><a class="page-link" href="#">»</a></li>
                <li class="page-item"><a class="page-link" href="#">»»</a></li>
            </ul>
        </nav>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Hàm toggleStatus này gọi đến ToggleServiceStatusServlet đã có của bạn
            // Đảm bảo URL trong fetch là chính xác đến servlet đó
            function toggleStatus(serviceId) {
                fetch('${pageContext.request.contextPath}/services/toggle', { // Hoặc URL đúng của ToggleServiceStatusServlet
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        id: serviceId
                    })
                })
                .then(response => {
                    // Xử lý response từ ToggleServiceStatusServlet của bạn
                    if (!response.ok) {
                        // Có thể thử đọc lỗi dạng JSON nếu servlet trả về
                        return response.json().then(err => { throw new Error(err.message || 'Failed to update status'); });
                    }
                    return response.json(); // Giả sử servlet trả về JSON {success: true/false, message: "..."}
                })
                .then(data => {
                    if (data.success) { // Kiểm tra thuộc tính 'success' từ JSON response
                        alert(data.message || "Update Status Success");
                        window.location.reload(); // Tải lại trang để thấy thay đổi
                    } else {
                        alert(data.message || "Failed to update status.");
                    }
                })
                .catch(error => {
                    console.error('Error toggling status:', error);
                    alert('An error occurred: ' + error.message);
                });
                 setTimeout(() => {
        window.location.reload();
    }, 1000);

            }
        </script>
    </body>
</html>