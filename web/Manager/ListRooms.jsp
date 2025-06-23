<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- Statistics Cards -->
<div class="stats-grid">
    <div class="stat-card">
        <div class="stat-icon rooms">
            <i class="fas fa-bed"></i>
        </div>
        <div class="stat-info">
            <h3>${totalRooms != null ? totalRooms : 0}</h3>
            <p>ROOMS</p>
        </div>
    </div>
    <div class="stat-card">
        <div class="stat-icon floors">
            <i class="fas fa-building"></i>
        </div>
        <div class="stat-info">
            <h3>4</h3>
            <p>FLOORS</p>
        </div>
    </div>
    <div class="stat-card">
        <div class="stat-icon types">
            <i class="fas fa-list"></i>
        </div>
        <div class="stat-info">
            <h3>${roomTypes != null ? roomTypes.size() : 0}</h3>
            <p>ROOM TYPES</p>
        </div>
    </div>
    <div class="stat-card">
        <div class="stat-icon booked">
            <i class="fas fa-users"></i>
        </div>
        <div class="stat-info">
            <h3>0</h3>
            <p>BOOKED ROOM TODAY</p>
        </div>
    </div>
</div>

<!-- Page Header -->
<div class="page-header">
    <h1 class="page-title">Rooms</h1>
    <a href="${pageContext.request.contextPath}/AddEditRoomServlet" class="add-btn">
        <i class="fas fa-plus"></i> Add
    </a>
</div>

<!-- Messages -->
<c:if test="${not empty successMessage}">
    <div class="alert alert-success">
        <i class="fas fa-check-circle"></i> ${successMessage}
    </div>
</c:if>
<c:if test="${not empty errorMessage}">
    <div class="alert alert-error">
        <i class="fas fa-exclamation-circle"></i> ${errorMessage}
    </div>
</c:if>

<!-- Main Card -->
<div class="main-card">
    <div class="card-header">
        <!-- Controls -->
        <div class="controls">
            <div class="show-entries">
                <label>Show</label>
                <select onchange="changePageSize(this.value)">
                    <option value="5" ${pageSize == 5 ? 'selected' : ''}>5</option>
                    <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
                    <option value="25" ${pageSize == 25 ? 'selected' : ''}>25</option>
                    <option value="50" ${pageSize == 50 ? 'selected' : ''}>50</option>
                </select>
                <label>entries</label>
            </div>
            <div class="search-box">
                <label>Search:</label>
                <input type="text" id="quickSearch" placeholder="Tìm kiếm..." value="${f_keyword}">
            </div>
        </div>

        <!-- Filters -->
        <form class="filters" method="get" action="ListRoomsServlet">
            <select name="roomTypeId">
                <option value="">--Loại phòng--</option>
                <c:forEach var="rt" items="${roomTypes}">
                    <option value="${rt.roomTypeID}" 
                            <c:if test="${rt.roomTypeID == f_type}">selected</c:if>>
                        ${rt.name}
                    </option>
                </c:forEach>
            </select>

            <select name="status">
                <option value="">--Trạng thái--</option>
                <option value="Available" <c:if test="${'Available' == f_status}">selected</c:if>>Available</option>
                <option value="Occupied" <c:if test="${'Occupied' == f_status}">selected</c:if>>Occupied</option>
                <option value="Maintenance" <c:if test="${'Maintenance' == f_status}">selected</c:if>>Maintenance</option>
                <option value="Dirty" <c:if test="${'Dirty' == f_status}">selected</c:if>>Dirty</option>
            </select>

            <input type="text" name="keyword" placeholder="Số phòng..." value="${f_keyword}" />

            <input type="number" name="minFloor" placeholder="Tầng từ" style="width:100px" value="${f_minFloor}" />
            <input type="number" name="maxFloor" placeholder="đến" style="width:80px" value="${f_maxFloor}" />

            <input type="number" step="0.01" name="minPrice" placeholder="Giá từ" style="width:120px" value="${f_minPrice}" />
            <input type="number" step="0.01" name="maxPrice" placeholder="đến" style="width:120px" value="${f_maxPrice}" />

            <button type="submit" class="filter-btn">
                <i class="fas fa-search"></i> Tìm kiếm
            </button>
            <a href="${pageContext.request.contextPath}/ListRoomsServlet" class="reset-link">
                <i class="fas fa-undo"></i> Reset
            </a>
        </form>
    </div>

    <!-- Table -->
    <div class="table-container">
        <table>
            <thead>
                <tr>
                    <th>#</th>
                    <th>
                        <i class="fas fa-sort"></i> Room Number
                    </th>
                    <th>
                        <i class="fas fa-sort"></i> Room Type
                    </th>
                    <th>
                        <i class="fas fa-sort"></i> Floor Number
                    </th>
                    <th>Status</th>
                    <th>
                        <i class="fas fa-cog"></i> Action
                    </th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="room" items="${rooms}" varStatus="status">
                    <tr>
                        <td>${(currentPage - 1) * pageSize + status.index + 1}</td>
                        <td><strong>${room.roomnumber}</strong></td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty room.roomType}">
                                    ${room.roomType.name}
                                </c:when>
                                <c:otherwise>
                                    N/A
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>${room.floor} - Floor</td>
                        <td>
                            <span class="status-badge ${room.status != null ? room.status.toLowerCase() : 'unknown'}">
                                ${room.status != null ? room.status : 'Unknown'}
                            </span>
                        </td>
                        <td>
                            <div class="action-buttons">
                                <a href="#" class="btn btn-housekeeping" 
                                   onclick="updateRoomStatus(${room.roomID}, 'Available')"
                                   title="Housekeeping">
                                    <i class="fas fa-broom"></i> Housekeeping
                                </a>
                                <a href="${pageContext.request.contextPath}/AddEditRoomServlet?action=edit&roomId=${room.roomID}" 
                                   class="btn btn-edit" title="Edit">
                                    <i class="fas fa-edit"></i> Edit
                                </a>
                                <a href="#" class="btn btn-delete" 
                                   onclick="confirmDelete(${room.roomID}, '${room.roomnumber}')"
                                   title="Delete">
                                    <i class="fas fa-trash"></i> Delete
                                </a>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty rooms}">
                    <tr>
                        <td colspan="6" style="text-align:center; padding: 40px; color: #6b7280;">
                            <i class="fas fa-inbox" style="font-size: 48px; margin-bottom: 10px; display: block;"></i>
                            Không tìm thấy phòng nào
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>

    <!-- Table Footer -->
    <div class="table-footer">
        <div class="showing-info">
            Showing ${startRecord} to ${endRecord} of ${totalRooms} entries
        </div>

        <c:if test="${totalPages > 1}">
            <ul class="pagination">
                <li class="${currentPage <= 1 ? 'disabled' : ''}">
                    <a href="${currentPage > 1 ? 'ListRoomsServlet?page='.concat(currentPage - 1).concat('&').concat(pageContext.request.queryString != null ? pageContext.request.queryString.replaceAll('page=\\d+&?', '') : '') : '#'}">
                        Previous
                    </a>
                </li>

                <c:forEach var="i" begin="1" end="${totalPages}">
                    <li class="${i == currentPage ? 'active' : ''}">
                        <a href="ListRoomsServlet?page=${i}&roomTypeId=${f_type}&status=${f_status}&keyword=${f_keyword}&minFloor=${f_minFloor}&maxFloor=${f_maxFloor}&minPrice=${f_minPrice}&maxPrice=${f_maxPrice}&pageSize=${pageSize}">
                            ${i}
                        </a>
                    </li>
                </c:forEach>

                <li class="${currentPage >= totalPages ? 'disabled' : ''}">
                    <a href="${currentPage < totalPages ? 'ListRoomsServlet?page='.concat(currentPage + 1).concat('&roomTypeId=').concat(f_type != null ? f_type : '').concat('&status=').concat(f_status != null ? f_status : '').concat('&keyword=').concat(f_keyword != null ? f_keyword : '').concat('&minFloor=').concat(f_minFloor != null ? f_minFloor : '').concat('&maxFloor=').concat(f_maxFloor != null ? f_maxFloor : '').concat('&minPrice=').concat(f_minPrice != null ? f_minPrice : '').concat('&maxPrice=').concat(f_maxPrice != null ? f_maxPrice : '').concat('&pageSize=').concat(pageSize) : '#'}">
                        Next
                    </a>
                </li>
            </ul>
        </c:if>
    </div>
</div>

<!-- CSS Styles -->
<style>
    .container {
        max-width: 1400px;
        margin: 0 auto;
        padding: 20px;
    }

    /* Statistics Cards */
    .stats-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: 20px;
        margin-bottom: 30px;
    }

    .stat-card {
        background: white;
        border-radius: 12px;
        padding: 20px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        display: flex;
        align-items: center;
        gap: 15px;
    }

    .stat-icon {
        width: 60px;
        height: 60px;
        border-radius: 8px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 24px;
        color: white;
    }

    .stat-icon.rooms { background: #0ea5e9; }
    .stat-icon.floors { background: #f97316; }
    .stat-icon.types { background: #10b981; }
    .stat-icon.booked { background: #f59e0b; }

    .stat-info h3 {
        font-size: 28px;
        font-weight: 700;
        margin-bottom: 5px;
    }

    .stat-info p {
        color: #64748b;
        font-size: 14px;
        text-transform: uppercase;
        font-weight: 500;
    }

    /* Header */
    .page-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 25px;
    }

    .page-title {
        font-size: 24px;
        font-weight: 600;
        color: #1e293b;
    }

    .add-btn {
        background: #10b981;
        color: white;
        border: none;
        padding: 12px 20px;
        border-radius: 8px;
        font-weight: 600;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        transition: all 0.2s;
    }

    .add-btn:hover {
        background: #059669;
        transform: translateY(-1px);
    }

    /* Main Card */
    .main-card {
        background: white;
        border-radius: 12px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        overflow: hidden;
    }

    .card-header {
        padding: 20px;
        border-bottom: 1px solid #e2e8f0;
    }

    /* Controls */
    .controls {
        display: flex;
        justify-content: space-between;
        align-items: center;
        flex-wrap: wrap;
        gap: 15px;
        margin-bottom: 20px;
    }

    .show-entries {
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .show-entries select {
        padding: 8px 12px;
        border: 1px solid #cbd5e1;
        border-radius: 6px;
        font-size: 14px;
    }

    .search-box {
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .search-box input {
        padding: 8px 12px;
        border: 1px solid #cbd5e1;
        border-radius: 6px;
        font-size: 14px;
        width: 200px;
    }

    /* Filters */
    .filters {
        display: flex;
        flex-wrap: wrap;
        gap: 10px;
        margin-bottom: 20px;
        align-items: center;
    }

    .filters select,
    .filters input {
        padding: 8px 12px;
        border: 1px solid #cbd5e1;
        border-radius: 6px;
        font-size: 14px;
    }

    .filter-btn {
        background: #3b82f6;
        color: white;
        border: none;
        padding: 8px 16px;
        border-radius: 6px;
        cursor: pointer;
        font-weight: 500;
        transition: background 0.2s;
    }

    .filter-btn:hover {
        background: #2563eb;
    }

    .reset-link {
        color: #6b7280;
        text-decoration: none;
        font-weight: 500;
        margin-left: 10px;
    }

    .reset-link:hover {
        color: #374151;
    }

    /* Table */
    .table-container {
        overflow-x: auto;
    }

    table {
        width: 100%;
        border-collapse: collapse;
    }

    table th {
        background: #f8fafc;
        padding: 15px 12px;
        text-align: left;
        font-weight: 600;
        color: #374151;
        border-bottom: 1px solid #e2e8f0;
        font-size: 14px;
    }

    table td {
        padding: 15px 12px;
        border-bottom: 1px solid #f1f5f9;
        font-size: 14px;
    }

    table tbody tr:hover {
        background: #f8fafc;
    }

    /* Status badges */
    .status-badge {
        padding: 4px 12px;
        border-radius: 20px;
        font-size: 12px;
        font-weight: 600;
        text-transform: uppercase;
    }

    .status-badge.available {
        background: #dcfce7;
        color: #166534;
    }

    .status-badge.occupied {
        background: #fed7aa;
        color: #9a3412;
    }

    .status-badge.maintenance {
        background: #fecaca;
        color: #991b1b;
    }

    .status-badge.dirty {
        background: #fef3c7;
        color: #92400e;
    }

    /* Action buttons */
    .action-buttons {
        display: flex;
        gap: 5px;
    }

    .btn {
        padding: 6px 12px;
        border: none;
        border-radius: 4px;
        font-size: 12px;
        font-weight: 500;
        cursor: pointer;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        gap: 4px;
        transition: all 0.2s;
    }

    .btn-housekeeping {
        background: #0ea5e9;
        color: white;
    }

    .btn-housekeeping:hover {
        background: #0284c7;
    }

    .btn-edit {
        background: #3b82f6;
        color: white;
    }

    .btn-edit:hover {
        background: #2563eb;
    }

    .btn-delete {
        background: #ef4444;
        color: white;
    }

    .btn-delete:hover {
        background: #dc2626;
    }

    /* Pagination */
    .table-footer {
        padding: 20px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        border-top: 1px solid #e2e8f0;
        flex-wrap: wrap;
        gap: 15px;
    }

    .showing-info {
        color: #6b7280;
        font-size: 14px;
    }

    .pagination {
        display: flex;
        gap: 5px;
        list-style: none;
    }

    .pagination a {
        padding: 8px 12px;
        border: 1px solid #d1d5db;
        color: #374151;
        text-decoration: none;
        border-radius: 4px;
        font-size: 14px;
        transition: all 0.2s;
    }

    .pagination a:hover {
        background: #f3f4f6;
    }

    .pagination .active a {
        background: #3b82f6;
        color: white;
        border-color: #3b82f6;
    }

    .pagination .disabled a {
        color: #9ca3af;
        cursor: not-allowed;
    }

    .pagination .disabled a:hover {
        background: transparent;
    }

    /* Messages */
    .alert {
        padding: 12px 16px;
        border-radius: 8px;
        margin-bottom: 20px;
        font-weight: 500;
    }

    .alert-success {
        background: #dcfce7;
        color: #166534;
        border: 1px solid #bbf7d0;
    }

    .alert-error {
        background: #fecaca;
        color: #991b1b;
        border: 1px solid #fca5a5;
    }

    /* Responsive */
    @media (max-width: 768px) {
        .controls {
            flex-direction: column;
            align-items: stretch;
        }

        .filters {
            flex-direction: column;
            align-items: stretch;
        }

        .filters select,
        .filters input {
            width: 100%;
        }

        .action-buttons {
            flex-direction: column;
        }

        .table-footer {
            flex-direction: column;
            text-align: center;
        }
    }
</style>

<!-- JavaScript -->
<script>
    function changePageSize(size) {
        const url = new URL(window.location);
        url.searchParams.set('pageSize', size);
        url.searchParams.set('page', '1'); // Reset to first page
        window.location.href = url.toString();
    }

    function confirmDelete(roomId, roomnumber) {
        if (confirm('Bạn có chắc chắn muốn xóa phòng ' + roomnumber + '?')) {
            window.location.href = 'ListRoomsServlet?action=delete&roomId=' + roomId;
        }
    }

    function updateRoomStatus(roomId, status) {
        if (confirm('Cập nhật trạng thái phòng thành ' + status + '?')) {
            window.location.href = 'ListRoomsServlet?action=updateStatus&roomId=' + roomId + '&status=' + status;
        }
    }

    // Quick search functionality
    document.getElementById('quickSearch').addEventListener('keypress', function (e) {
        if (e.key === 'Enter') {
            const url = new URL(window.location);
            url.searchParams.set('keyword', this.value);
            url.searchParams.set('page', '1');
            window.location.href = url.toString();
        }
    });

    // Auto-hide messages after 5 seconds
    setTimeout(function () {
        const alerts = document.querySelectorAll('.alert');
        alerts.forEach(function (alert) {
            alert.style.opacity = '0';
            alert.style.transition = 'opacity 0.5s';
            setTimeout(function () {
                alert.remove();
            }, 500);
        });
    }, 5000);
</script>
