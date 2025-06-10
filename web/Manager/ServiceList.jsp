<%-- Khai báo loại nội dung của trang là HTML, mã hóa UTF-8 để hỗ trợ tiếng Việt --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%-- Nhúng thư viện JSTL core để sử dụng các thẻ như <c:forEach>, <c:if> --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- Nhúng thư viện JSTL fmt để định dạng số, ngày tháng (ví dụ: giá dịch vụ) --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%-- Import lớp Account từ package model để sử dụng trong đoạn mã Java --%>
<%@ page import="model.Account" %>

<%-- Kiểm tra quyền truy cập --%>
<%
    // Lấy đối tượng Account từ session (phiên đăng nhập của người dùng)
    Account account = (Account) session.getAttribute("account");
    
    // Kiểm tra nếu người dùng chưa đăng nhập (account == null) hoặc không phải Manager
    if (account == null || !"Manager".equals(account.getRole())) {
        // Chuyển hướng về trang đăng nhập (login.jsp) nếu không đủ quyền
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return; // Dừng xử lý JSP
    }
%>

<%-- Khai báo HTML5 và ngôn ngữ trang là tiếng Anh --%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <%-- Thiết lập mã hóa UTF-8 cho trang web --%>
        <meta charset="UTF-8">
        
        <%-- Tiêu đề của trang --%>
        <title>Service List</title>
        
        <%-- Nhúng Bootstrap CSS để tạo giao diện đẹp và responsive --%>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        
        <%-- CSS tùy chỉnh để điều chỉnh giao diện --%>
        <style>
            /* Đảm bảo HTML và body chiếm toàn bộ chiều cao của trình duyệt */
            html, body {
                height: 100%;
                margin: 0;
                overflow-x: hidden; /* Ngăn cuộn ngang */
            }
            
            /* Thiết lập nền trắng, màu chữ, và padding để tránh chồng lấn với navbar */
            body {
                background-color: #fff;
                color: #333;
                padding-top: 56px; /* Khoảng cách để navbar cố định không che nội dung */
                display: flex;
                flex-direction: column; /* Sắp xếp nội dung theo cột */
            }
            
            /* Nội dung chính nằm bên phải sidebar */
            .main-content {
                margin-left: 250px; /* Khoảng cách để tránh sidebar */
                padding-bottom: 70px; /* Khoảng cách để tránh pagination */
                flex: 1; /* Chiếm toàn bộ không gian còn lại */
            }
            
            /* Sidebar cố định bên trái */
            .sidebar {
                width: 250px; /* Chiều rộng sidebar */
                background-color: #f8f9fa; /* Màu nền nhạt */
                height: calc(100vh - 56px); /* Chiều cao trừ đi navbar */
                position: fixed;
                top: 56px; /* Dưới navbar */
                left: 0;
                overflow-y: auto; /* Cho phép cuộn dọc nếu nội dung dài */
            }
            
            /* Định dạng tiêu đề bảng */
            .table th {
                background-color: #f8f9fa; /* Màu nền nhạt cho tiêu đề bảng */
            }
            
            /* Thanh phân trang cố định ở dưới cùng */
            .pagination {
                justify-content: center; /* Căn giữa */
                position: fixed;
                bottom: 0;
                left: 0;
                right: 0;
                background-color: #fff;
                padding: 10px 0;
                border-top: 1px solid #dee2e6; /* Đường viền trên */
                z-index: 1000; /* Đảm bảo nằm trên các nội dung khác */
            }
        </style>
    </head>
    <body>
            <%-- Nhúng file sidebar.jsp để hiển thị menu bên trái --%>
            <%@ include file="sidebar.jsp" %>
        <%-- Navbar cố định ở trên cùng --%>
        <nav class="navbar navbar-expand-lg navbar-light bg-primary fixed-top" style="margin-left: 240px">
            <div class="container-fluid">
                <%-- Logo hoặc tên ứng dụng --%>
                <a class="navbar-brand" style="color: white;" href="#"><strong>Services Management</strong></a>
                
                <%-- Navbar collapse để hiển thị menu khi màn hình nhỏ --%>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav ms-auto"> <%-- Căn phải các mục navbar --%>
                        <li class="nav-item dropdown">
                            <%-- Hiển thị vai trò người dùng (Manager) và menu dropdown --%>
                            <a class="nav-link dropdown-toggle"  style="color: white;" href="#" role="button" data-bs-toggle="dropdown">
                                Welcome, ${account.role} <%-- Hiển thị vai trò từ session --%>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end">
                                <%-- Liên kết đến trang hồ sơ --%>
                                <li><a class="dropdown-item" href="#">Profile</a></li>
                                <%-- <li><a class="dropdown-item" href="#">Settings</a></li> --%>
                                <li><hr class="dropdown-divider"></li>
                                <%-- Liên kết đăng xuất --%>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/Logout">Logout</a></li>
                            </ul>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>

        <%-- Nội dung chính với sidebar và bảng dịch vụ --%>
        <div class="d-flex">

            <%-- Nội dung chính --%>
            <div class="main-content p-3">
                <div class="container">
                    <%-- Form tìm kiếm và lọc dịch vụ --%>
                    <div class="d-flex justify-content-between mb-3 align-items-center">
                        <form method="GET" action="${pageContext.request.contextPath}/services/list" class="d-flex gap-2">
                            <%-- Ô tìm kiếm theo tên dịch vụ --%>
                            <input type="text" class="form-control" name="searchKeyword" placeholder="Search by name..." value="${currentSearchKeyword}" style="width: 200px;">
                            
                            <%-- Dropdown lọc theo loại dịch vụ --%>
                            <select class="form-select" name="filterType" style="width: 150px;">
                                <option value="">All Types</option>
                                <c:forEach items="${serviceTypeList}" var="t">
                                    <option value="${t}" ${t == currentFilterType ? 'selected' : ''}>${t}</option>
                                </c:forEach>
                            </select>
                            
                            <%-- Dropdown lọc theo trạng thái --%>
                            <select class="form-select" name="filterStatus" style="width: 150px;">
                                <option value="">All Status</option>
                                <option value="1" ${"1" == currentFilterStatus ? 'selected' : ''}>Available</option>
                                <option value="0" ${"0" == currentFilterStatus ? 'selected' : ''}>Not Available</option>
                            </select>
                            
                            <%-- Nút gửi form để lọc --%>
                            <button type="submit" class="btn btn-primary btn-sm">Filter</button>
                            
                            <%-- Nút xóa bộ lọc, trở về trạng thái mặc định --%>
                            <a href="${pageContext.request.contextPath}/services/list" class="btn btn-secondary btn-sm">Clear</a>
                        </form>

                        <%-- Nút thêm dịch vụ mới --%>
                        <button class="btn btn-success btn-sm ms-2" onclick="window.location.href = '${pageContext.request.contextPath}/Manager/addService.jsp'">Add New</button>
                    </div>

                    <%-- Bảng hiển thị danh sách dịch vụ --%>
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
                            <%-- Kiểm tra nếu danh sách dịch vụ rỗng --%>
                            <c:if test="${empty serviceList}">
                                <tr>
                                    <td colspan="8" class="text-center">No services found.</td>
                                </tr>
                            </c:if>
                            
                            <%-- Lặp qua danh sách dịch vụ để hiển thị --%>
                            <c:forEach items="${serviceList}" var="s">
                                <tr>
                                    <td>${s.id}</td> <%-- Hiển thị ID dịch vụ --%>
                                    <td>${s.name}</td> <%-- Hiển thị tên dịch vụ --%>
                                    <%-- Định dạng giá với dấu phẩy và đơn vị VNĐ --%>
                                    <td><fmt:formatNumber value='${s.price}' pattern='###,###,###₫'/></td>
                                    <%-- Hiển thị loại dịch vụ, nếu null thì hiển thị "N/A" --%>
                                    <td>${s.type == null ? "N/A" : s.type}</td>
                                    <%-- Hiển thị trạng thái: "Available" hoặc "Not Available" --%>
                                    <td>${s.status == "1" ? "Available" : "Not Available"}</td>
                                    <%-- Hiển thị người tạo, nếu null thì hiển thị "N/A" --%>
                                    <td>${s.createdBy == null ? "N/A" : s.createdBy}</td>
                                    <td>${s.createDate}</td> <%-- Hiển thị ngày tạo --%>
                                    <td>
                                        <%-- Nút chỉnh sửa dịch vụ --%>
                                        <button class="btn btn-primary btn-sm mb-1" onclick="window.location.href = '${pageContext.request.contextPath}/Manager/editService.jsp?id=${s.id}'">Edit</button>
                                        
                                        <%-- Nút xem hình ảnh dịch vụ --%>
                                        <button class="btn btn-info btn-sm mb-1" onclick="showImageModal('${s.serviceImage}')">View Image</button>
                                        
                                        <%-- Nút chuyển đổi trạng thái (Active/Inactive) --%>
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
                </div>
            </div>
        </div>

        <%-- Modal hiển thị hình ảnh dịch vụ --%>
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

        <%-- Thanh phân trang (hiện đang được comment) --%>
        <!--
        <nav aria-label="Page navigation">
            <ul class="pagination">
                <li class="page-item"><a class="page-link" href="#">««</a></li>
                <li class="page-item"><a class="page-link" href="#">«</a></li>
                <li class="page-item active"><a class="page-link" href="#">1</a></li>
                <li class="page-item"><a class="page-link" href="#">»</a></li>
                <li class="page-item"><a class="page-link" href="#">»»</a></li>
            </ul>
        </nav>
        -->

        <%-- Nhúng Bootstrap JS để hỗ trợ dropdown và modal --%>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        
        <script>
            // Hiển thị thông báo nếu có (được gửi từ Servlet)
            let msg = '${msg}';
            console.log(msg); // In thông báo ra console để debug
            if (msg !== '') {
                alert(msg); // Hiển thị thông báo dạng popup
            }

            // Hàm chuyển đổi trạng thái dịch vụ
            function toggleStatus(serviceId) {
                // Gửi yêu cầu POST AJAX đến Servlet /services/toggle
                fetch('${pageContext.request.contextPath}/services/toggle', {
                    method: 'POST', // Phương thức POST
                    headers: {'Content-Type': 'application/json'}, // Định dạng JSON
                    body: JSON.stringify({id: serviceId}) // Gửi ID dịch vụ
                })
                .then(response => response.json()) // Parse phản hồi JSON
                .then(data => {
                    // Kiểm tra phản hồi từ Servlet
                    if (data.success) {
                        alert(data.message || "Status updated."); // Hiển thị thông báo thành công
                        window.location.reload(); // Làm mới trang
                    } else {
                        alert(data.message || "Update failed."); // Hiển thị thông báo lỗi
                    }
                })
                .catch(error => {
                    alert("Error: " + error.message); // Hiển thị lỗi nếu AJAX thất bại
                });
                
                // Tự động làm mới trang sau 1 giây
                setTimeout(() => {
                    window.location.href='${pageContext.request.contextPath}/services/list';
                }, 1000);
            }

            // Hàm hiển thị hình ảnh dịch vụ trong modal
            function showImageModal(imagePath) {
                // Xử lý đường dẫn hình ảnh (nếu là URL tuyệt đối hoặc tương đối)
                const fullPath = imagePath.startsWith('http') ? imagePath : '${pageContext.request.contextPath}/' + imagePath;
                document.getElementById("serviceImage").src = fullPath; // Cập nhật src của thẻ img
                const modal = new bootstrap.Modal(document.getElementById('imageModal')); // Tạo modal
                modal.show(); // Hiển thị modal
            }
        </script>
    </body>
</html>