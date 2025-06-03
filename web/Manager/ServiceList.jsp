<%-- src/main/webapp/services.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %> <%-- Để định dạng số, ngày tháng --%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Dịch Vụ</title>
    <%-- Thêm Bootstrap CSS (ví dụ, hoặc CSS của bạn) --%>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { padding: 20px; }
        .filter-form .form-group { margin-right: 15px; }
        .pagination { margin-top: 20px; }
        .service-image-thumbnail { max-width: 100px; max-height: 70px; object-fit: cover; }
        .action-buttons a, .action-buttons button { margin-right: 5px; }
    </style>
</head>
<body>
    <div class="container-fluid">
        <h1 class="mb-4">Danh Sách Dịch Vụ</h1>

        <%-- Nút thêm mới dịch vụ --%>
        <div class="mb-3">
            <a href="${pageContext.request.contextPath}/services?action=new" class="btn btn-success">Thêm Dịch Vụ Mới</a>
        </div>

        <%-- Form tìm kiếm và lọc --%>
        <form action="${pageContext.request.contextPath}/services" method="get" class="form-inline mb-4 filter-form">
            <input type="hidden" name="action" value="list"> <%-- Luôn gửi action=list khi submit form này --%>
            <div class="form-group">
                <label for="search" class="sr-only">Tìm kiếm:</label>
                <input type="text" class="form-control" id="search" name="search" value="<c:out value='${searchTerm}'/>" placeholder="Tên dịch vụ...">
            </div>
            <div class="form-group">
                <label for="serviceType" class="sr-only">Loại Dịch Vụ:</label>
                <select class="form-control" id="serviceType" name="serviceType">
                    <option value="">-- Tất cả loại --</option>
                    <c:forEach var="type" items="${serviceTypes}">
                        <option value="${type}" ${type == selectedServiceType ? 'selected' : ''}>
                            <c:out value="${type}"/>
                        </option>
                    </c:forEach>
                </select>
            </div>
            <div class="form-group">
                <label for="status" class="sr-only">Trạng Thái:</label>
                <select class="form-control" id="status" name="status">
                    <option value="">-- Tất cả trạng thái --</option>
                     <c:forEach var="st" items="${statuses}">
                        <option value="${st}" ${st == selectedStatus ? 'selected' : ''}>
                            <c:out value="${st}"/>
                        </option>
                    </c:forEach>
                </select>
            </div>
            <button type="submit" class="btn btn-primary">Lọc / Tìm</button>
            <a href="${pageContext.request.contextPath}/services?action=list" class="btn btn-secondary ml-2">Xóa Lọc</a>
        </form>

        <%-- Bảng hiển thị dịch vụ --%>
        <table class="table table-striped table-bordered">
            <thead class="thead-dark">
                <tr>
                    <th>ID</th>
                    <th>Hình Ảnh</th>
                    <th>Tên Dịch Vụ</th>
                    <th>Giá</th>
                    <th>Loại Dịch Vụ</th>
                    <th>Trạng Thái</th>
                    <th>Mô Tả</th>
                    <th>Ngày Tạo</th>
                    <th>Hành Động</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty listService}">
                        <c:forEach var="service" items="${listService}" varStatus="loop">
                            <tr>
                                <td><c:out value="${service.serviceID}"/></td>
                                <td>
                                    <c:if test="${not empty service.serviceImage}">
                                        <img src="<c:url value='${service.serviceImage}'/>" alt="<c:out value='${service.serviceName}'/>" class="service-image-thumbnail img-thumbnail">
                                    </c:if>
                                    <c:if test="${empty service.serviceImage}">
                                        <span class="text-muted">N/A</span>
                                    </c:if>
                                </td>
                                <td><c:out value="${service.serviceName}"/></td>
                                <td>
                                    <fmt:setLocale value="vi_VN"/>
                                    <fmt:formatNumber value="${service.price}" type="currency" currencyCode="VND" maxFractionDigits="0"/>
                                </td>
                                <td><c:out value="${service.serviceType}"/></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${service.availabilityStatus == 'Available'}">
                                            <span class="badge badge-success">Available</span>
                                        </c:when>
                                        <c:when test="${service.availabilityStatus == 'Unavailable'}">
                                            <span class="badge badge-danger">Unavailable</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-secondary"><c:out value="${service.availabilityStatus}"/></span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td><c:out value="${service.description}"/></td>
                                <td>
                                    <fmt:formatDate value="${service.createdDate}" pattern="dd/MM/yyyy HH:mm"/>
                                </td>
                                <td class="action-buttons">
                                    <%-- Các nút CRUD (chưa có action cụ thể) --%>
                                    <a href="${pageContext.request.contextPath}/services?action=view&id=${service.serviceID}" class="btn btn-info btn-sm" title="Xem Chi Tiết">👁️</a>
                                    <a href="${pageContext.request.contextPath}/services?action=edit&id=${service.serviceID}" class="btn btn-warning btn-sm" title="Sửa">✏️</a>
                                    <a href="${pageContext.request.contextPath}/services?action=delete&id=${service.serviceID}" class="btn btn-danger btn-sm" title="Xóa" onclick="return confirm('Bạn có chắc chắn muốn xóa dịch vụ này?');">🗑️</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="9" class="text-center">Không tìm thấy dịch vụ nào.</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>

        <%-- Phân trang --%>
        <c:if test="${totalPages > 1}">
            <nav aria-label="Page navigation">
                <ul class="pagination justify-content-center">
                    <%-- Nút Previous --%>
                    <c:if test="${currentPage > 1}">
                        <li class="page-item">
                            <a class="page-link" href="${pageContext.request.contextPath}/services?action=list&page=${currentPage - 1}&search=${searchTerm}&serviceType=${selectedServiceType}&status=${selectedStatus}">Trước</a>
                        </li>
                    </c:if>
                    <c:if test="${currentPage <= 1}">
                        <li class="page-item disabled">
                            <a class="page-link" href="#">Trước</a>
                        </li>
                    </c:if>

                    <%-- Các nút số trang --%>
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <c:choose>
                            <c:when test="${currentPage eq i}">
                                <li class="page-item active"><a class="page-link" href="#">${i}</a></li>
                            </c:when>
                            <c:otherwise>
                                <li class="page-item"><a class="page-link" href="${pageContext.request.contextPath}/services?action=list&page=${i}&search=${searchTerm}&serviceType=${selectedServiceType}&status=${selectedStatus}">${i}</a></li>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>

                    <%-- Nút Next --%>
                     <c:if test="${currentPage < totalPages}">
                        <li class="page-item">
                            <a class="page-link" href="${pageContext.request.contextPath}/services?action=list&page=${currentPage + 1}&search=${searchTerm}&serviceType=${selectedServiceType}&status=${selectedStatus}">Sau</a>
                        </li>
                    </c:if>
                    <c:if test="${currentPage >= totalPages}">
                        <li class="page-item disabled">
                            <a class="page-link" href="#">Sau</a>
                        </li>
                    </c:if>
                </ul>
            </nav>
        </c:if>
    </div>

    <%-- Thêm Bootstrap JS và Popper.js (nếu cần cho các component JS của Bootstrap) --%>
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>