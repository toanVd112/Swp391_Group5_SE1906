<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- Statistics Cards -->
<div class="rs-stats-grid">
    <div class="rs-stat-card">
        <div class="rs-stat-icon rooms">
            <i class="fas fa-bed"></i>
        </div>
        <div class="rs-stat-info">
            <h3>${totalRooms != null ? totalRooms : 0}</h3>
            <p>PHÒNG</p>
        </div>
    </div>
    <div class="rs-stat-card">
        <div class="rs-stat-icon floors">
            <i class="fas fa-building"></i>
        </div>
        <div class="rs-stat-info">
            <h3>4</h3>
            <p>TẦNG</p>
        </div>
    </div>
    <div class="rs-stat-card">
        <div class="rs-stat-icon types">
            <i class="fas fa-list"></i>
        </div>
        <div class="rs-stat-info">
            <h3>${roomTypes != null ? roomTypes.size() : 0}</h3>
            <p>LOẠI PHÒNG</p>
        </div>
    </div>
    <div class="rs-stat-card">
        <div class="rs-stat-icon booked">
            <i class="fas fa-users"></i>
        </div>
        <div class="rs-stat-info">
            <h3>0</h3>
            <p>PHÒNG ĐÃ ĐẶT HÔM NAY</p>
        </div>
    </div>
</div>

<div class="rs-page-header">
    <h1 class="rs-page-title">Quản lý phòng</h1>
    <a href="${pageContext.request.contextPath}/AddEditRoomServlet" class="rs-add-btn">
        <i class="fas fa-plus"></i> Thêm phòng
    </a>
</div>

<c:if test="${not empty successMessage}">
    <div class="rs-alert rs-alert-success">
        <i class="fas fa-check-circle"></i> ${successMessage}
    </div>
</c:if>

<c:if test="${not empty errorMessage}">
    <div class="rs-alert rs-alert-error">
        <i class="fas fa-exclamation-circle"></i> ${errorMessage}
    </div>
</c:if>

<div class="rs-main-card">
    <div class="rs-card-header">
        <!-- Top Controls Row -->
        <div class="rs-top-controls">
            <div class="rs-show-entries">
                <label>Hiển thị</label>
                <select onchange="changePageSize(this.value)">
                    <option value="5" ${pageSize == 5 ? 'selected' : ''}>5</option>
                    <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
                    <option value="25" ${pageSize == 25 ? 'selected' : ''}>25</option>
                    <option value="50" ${pageSize == 50 ? 'selected' : ''}>50</option>
                </select>
                <label>mục</label>
            </div>
            <div class="rs-quick-search">
                <input type="text" id="quickSearch" placeholder="Tìm kiếm nhanh..." value="${f_keyword}">
                <button onclick="quickSearch()" class="rs-search-btn">
                    <i class="fas fa-search"></i>
                </button>
            </div>
        </div>

        <!-- Advanced Filters -->
        <div class="rs-filter-section">
            <div class="rs-filter-toggle">
                <button type="button" onclick="toggleFilters()" class="rs-toggle-btn">
                    <i class="fas fa-filter"></i> Bộ lọc nâng cao
                    <i class="fas fa-chevron-down" id="filterChevron"></i>
                </button>
            </div>

            <form class="rs-filters" id="advancedFilters" method="get" action="ListRoomsServlet" onsubmit="return validateFilters()">
                <div class="rs-filter-row">
                    <div class="rs-filter-group">
                        <label>Loại phòng</label>
                        <select name="roomTypeId">
                            <option value="">Tất cả loại phòng</option>
                            <c:forEach var="rt" items="${roomTypes}">
                                <option value="${rt.roomTypeID}" <c:if test="${rt.roomTypeID == f_type}">selected</c:if>>
                                    ${rt.name}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="rs-filter-group">
                        <label>Trạng thái</label>
                        <select name="status">
                            <option value="">Tất cả trạng thái</option>
                            <option value="Available" <c:if test="${'Available' == f_status}">selected</c:if>>Available</option>
                            <option value="Occupied" <c:if test="${'Occupied' == f_status}">selected</c:if>>Occupied</option>
                            <option value="Maintenance" <c:if test="${'Maintenance' == f_status}">selected</c:if>>Maintenance</option>
                            <option value="Dirty" <c:if test="${'Dirty' == f_status}">selected</c:if>>Dirty</option>
                            </select>
                        </div>
                        <div class="rs-filter-group">
                            <label>Số phòng</label>
                            <input type="text" name="keyword" placeholder="Nhập số phòng..." value="${f_keyword}" />
                    </div>
                </div>

                <div class="rs-filter-row">
                    <div class="rs-filter-group rs-range-group">
                        <label>Tầng</label>
                        <div class="rs-range-inputs">
                            <input type="number" name="minFloor" placeholder="Từ" value="${f_minFloor}" min="0" />
                            <span>-</span>
                            <input type="number" name="maxFloor" placeholder="Đến" value="${f_maxFloor}" min="0" />
                        </div>
                    </div>
                    <div class="rs-filter-group rs-range-group">
                        <label>Giá ($)</label>
                        <div class="rs-range-inputs">
                            <input type="number" step="0.01" name="minPrice" placeholder="Từ" value="${f_minPrice}" min="0" />
                            <span>-</span>
                            <input type="number" step="0.01" name="maxPrice" placeholder="Đến" value="${f_maxPrice}" min="0" />
                        </div>
                    </div>
                    <div class="rs-filter-group rs-range-group">
                        <label>Số khách</label>
                        <div class="rs-range-inputs">
                            <input type="number" name="minGuests" placeholder="Từ" value="${f_minGuests}" min="0" />
                            <span>-</span>
                            <input type="number" name="maxGuests" placeholder="Đến" value="${f_maxGuests}" min="0" />
                        </div>
                    </div>
                </div>

                <div class="rs-filter-row">
                    <div class="rs-filter-group">
                        <label>Sắp xếp theo giá</label>
                        <select name="sort">
                            <option value="">Mặc định</option>
                            <option value="asc" <c:if test="${'asc' == sort}">selected</c:if>>Giá tăng dần</option>
                            <option value="desc" <c:if test="${'desc' == sort}">selected</c:if>>Giá giảm dần</option>
                            </select>
                        </div>
                        <div class="rs-filter-actions">
                            <button type="submit" class="rs-filter-btn">
                                <i class="fas fa-search"></i> Tìm kiếm
                            </button>
                            <a href="${pageContext.request.contextPath}/ListRoomsServlet" class="rs-reset-btn">
                            <i class="fas fa-undo"></i> Đặt lại
                        </a>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <div class="rs-table-container">
        <table class="rs-table">
            <thead>
                <tr>
                    <th class="rs-th-center">#</th>
                    <th class="rs-th-sortable">
                        <i class="fas fa-sort"></i> Số phòng
                    </th>
                    <th class="rs-th-sortable">
                        <i class="fas fa-sort"></i> Loại phòng
                    </th>
                    <th class="rs-th-center rs-th-sortable">
                        <i class="fas fa-sort"></i> Tầng
                    </th>
                    <th class="rs-th-right">Giá</th>
                    <th class="rs-th-center">Số khách</th>
                    <th class="rs-th-center">Trạng thái</th>
                    <th class="rs-th-center rs-th-actions">
                        <i class="fas fa-cog"></i> Hành động
                    </th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="room" items="${rooms}" varStatus="status">
                    <tr class="rs-table-row">
                        <td class="rs-td-center rs-td-index">${(currentPage - 1) * pageSize + status.index + 1}</td>
                        <td class="rs-td-room-number">
                            <strong>${room.roomnumber}</strong>
                        </td>
                        <td class="rs-td-room-type">
                            <c:choose>
                                <c:when test="${not empty room.roomType}">
                                    <span class="rs-room-type-badge">${room.roomType.name}</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="rs-na-text">N/A</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="rs-td-center">
                            <span class="rs-floor-badge">T${room.floor}</span>
                        </td>
                        <td class="rs-td-right rs-td-price">
                            <c:choose>
                                <c:when test="${not empty room.roomType}">
                                    <span class="rs-price">
                                        $<fmt:formatNumber value="${room.roomType.basePrice}" pattern="#,##0.##" />
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="rs-na-text">N/A</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="rs-td-center">
                            <c:choose>
                                <c:when test="${not empty room.roomType}">
                                    <span class="rs-guests-badge">
                                        ${room.roomType.maxGuests}
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="rs-na-text">N/A</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="rs-td-center">
                            <span class="rs-status-badge ${room.status != null ? room.status.toLowerCase() : 'unknown'}">
                                ${room.status != null ? room.status : 'Unknown'}
                            </span>
                        </td>
                        <td class="rs-td-center">
                            <div class="rs-action-buttons">
                                <a href="#" class="rs-btn rs-btn-housekeeping" onclick="updateRoomStatus(${room.roomID}, 'Available')" title="Housekeeping">
                                    <i class="fas fa-broom"></i>
                                </a>
                                <a href="${pageContext.request.contextPath}/AddEditRoomServlet?action=edit&roomId=${room.roomID}" 
                                   class="rs-btn rs-btn-edit" title="Sửa">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <a href="#" class="rs-btn rs-btn-delete" onclick="confirmDelete(${room.roomID}, '${room.roomnumber}')" title="Xóa">
                                    <i class="fas fa-trash"></i>
                                </a>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty rooms}">
                    <tr>
                        <td colspan="8" class="rs-empty-state">
                            <div class="rs-empty-content">
                                <i class="fas fa-inbox"></i>
                                <h3>Không tìm thấy phòng nào</h3>
                                <p>Thử điều chỉnh bộ lọc hoặc thêm phòng mới</p>
                            </div>
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>

    <div class="rs-table-footer">
        <div class="rs-showing-info">
            Hiển thị ${startRecord} đến ${endRecord} của ${totalRooms} mục
        </div>
        <c:if test="${totalPages > 1}">
            <ul class="rs-pagination">
                <li class="${currentPage <= 1 ? 'disabled' : ''}">
                    <a href="${currentPage > 1 ? 'ListRoomsServlet?page='.concat(currentPage - 1).concat('&roomTypeId=').concat(f_type != null ? f_type : '').concat('&status=').concat(f_status != null ? f_status : '').concat('&keyword=').concat(f_keyword != null ? f_keyword : '').concat('&minFloor=').concat(f_minFloor != null ? f_minFloor : '').concat('&maxFloor=').concat(f_maxFloor != null ? f_maxFloor : '').concat('&minPrice=').concat(f_minPrice != null ? f_minPrice : '').concat('&maxPrice=').concat(f_maxPrice != null ? f_maxPrice : '').concat('&minGuests=').concat(f_minGuests != null ? f_minGuests : '').concat('&maxGuests=').concat(f_maxGuests != null ? f_maxGuests : '').concat('&pageSize=').concat(pageSize).concat('&sort=').concat(sort != null ? sort : '') : '#'}">
                        Trước
                    </a>
                </li>
                <c:forEach var="i" begin="1" end="${totalPages}">
                    <li class="${i == currentPage ? 'active' : ''}">
                        <a href="ListRoomsServlet?page=${i}&roomTypeId=${f_type}&status=${f_status}&keyword=${f_keyword}&minFloor=${f_minFloor}&maxFloor=${f_maxFloor}&minPrice=${f_minPrice}&maxPrice=${f_maxPrice}&minGuests=${f_minGuests}&maxGuests=${f_maxGuests}&pageSize=${pageSize}&sort=${sort}">
                            ${i}
                        </a>
                    </li>
                </c:forEach>
                <li class="${currentPage >= totalPages ? 'disabled' : ''}">
                    <a href="${currentPage < totalPages ? 'ListRoomsServlet?page='.concat(currentPage + 1).concat('&roomTypeId=').concat(f_type != null ? f_type : '').concat('&status=').concat(f_status != null ? f_status : '').concat('&keyword=').concat(f_keyword != null ? f_keyword : '').concat('&minFloor=').concat(f_minFloor != null ? f_minFloor : '').concat('&maxFloor=').concat(f_maxFloor != null ? f_maxFloor : '').concat('&minPrice=').concat(f_minPrice != null ? f_minPrice : '').concat('&maxPrice=').concat(f_maxPrice != null ? f_maxPrice : '').concat('&minGuests=').concat(f_minGuests != null ? f_minGuests : '').concat('&maxGuests=').concat(f_maxGuests != null ? f_maxGuests : '').concat('&pageSize=').concat(pageSize).concat('&sort=').concat(sort != null ? sort : '') : '#'}">
                        Tiếp
                    </a>
                </li>
            </ul>
        </c:if>
    </div>
</div>

<!-- Enhanced CSS Styles -->
<style>
    .rs-container {
        max-width: 1400px;
        margin: 0 auto;
        padding: 20px;
    }

    /* Statistics Cards */
    .rs-stats-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: 20px;
        margin-bottom: 30px;
    }

    .rs-stat-card {
        background: white;
        border-radius: 12px;
        padding: 20px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        display: flex;
        align-items: center;
        gap: 15px;
        transition: transform 0.2s, box-shadow 0.2s;
    }

    .rs-stat-card:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
    }

    .rs-stat-icon {
        width: 60px;
        height: 60px;
        border-radius: 8px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 24px;
        color: white;
    }

    .rs-stat-icon.rooms {
        background: #0ea5e9;
    }
    .rs-stat-icon.floors {
        background: #f97316;
    }
    .rs-stat-icon.types {
        background: #10b981;
    }
    .rs-stat-icon.booked {
        background: #f59e0b;
    }

    .rs-stat-info h3 {
        font-size: 28px;
        font-weight: 700;
        margin-bottom: 5px;
        color: #1e293b;
    }

    .rs-stat-info p {
        color: #64748b;
        font-size: 14px;
        text-transform: uppercase;
        font-weight: 500;
        margin: 0;
    }

    /* Page Header */
    .rs-page-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 25px;
    }

    .rs-page-title {
        font-size: 24px;
        font-weight: 600;
        color: #1e293b;
        margin: 0;
    }

    .rs-add-btn {
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

    .rs-add-btn:hover {
        background: #059669;
        transform: translateY(-1px);
        color: white;
    }

    /* Main Card */
    .rs-main-card {
        background: white;
        border-radius: 12px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        overflow: hidden;
    }

    .rs-card-header {
        padding: 20px;
        border-bottom: 1px solid #e2e8f0;
        background: #f8fafc;
    }

    /* Top Controls */
    .rs-top-controls {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 20px;
        flex-wrap: wrap;
        gap: 15px;
    }

    .rs-show-entries {
        display: flex;
        align-items: center;
        gap: 10px;
        font-size: 14px;
        color: #64748b;
    }

    .rs-show-entries select {
        padding: 8px 12px;
        border: 1px solid #cbd5e1;
        border-radius: 6px;
        font-size: 14px;
        background: white;
    }

    .rs-quick-search {
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .rs-quick-search input {
        padding: 10px 16px;
        border: 1px solid #cbd5e1;
        border-radius: 8px;
        font-size: 14px;
        width: 250px;
        transition: border-color 0.2s;
    }

    .rs-quick-search input:focus {
        outline: none;
        border-color: #3b82f6;
        box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
    }

    .rs-search-btn {
        background: #3b82f6;
        color: white;
        border: none;
        padding: 10px 16px;
        border-radius: 8px;
        cursor: pointer;
        transition: background 0.2s;
    }

    .rs-search-btn:hover {
        background: #2563eb;
    }

    /* Filter Section */
    .rs-filter-section {
        border-top: 1px solid #e2e8f0;
        padding-top: 20px;
    }

    .rs-filter-toggle {
        margin-bottom: 15px;
    }

    .rs-toggle-btn {
        background: #f1f5f9;
        border: 1px solid #cbd5e1;
        padding: 10px 16px;
        border-radius: 8px;
        cursor: pointer;
        display: flex;
        align-items: center;
        gap: 8px;
        font-weight: 500;
        color: #475569;
        transition: all 0.2s;
    }

    .rs-toggle-btn:hover {
        background: #e2e8f0;
    }

    .rs-filters {
        display: none;
        background: white;
        border: 1px solid #e2e8f0;
        border-radius: 8px;
        padding: 20px;
        margin-top: 10px;
    }

    .rs-filters.show {
        display: block;
    }

    /* Make filter section more compact */
    .rs-filter-row {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
        gap: 12px;
        margin-bottom: 12px;
        align-items: end;
    }

    .rs-filter-row:last-child {
        margin-bottom: 0;
    }

    .rs-filter-group {
        display: flex;
        flex-direction: column;
        gap: 5px;
    }

    .rs-filter-group label {
        font-size: 11px;
        font-weight: 600;
        color: #374151;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        margin-bottom: 4px;
    }

    .rs-filter-group select,
    .rs-filter-group input {
        padding: 8px 10px;
        border: 1px solid #cbd5e1;
        border-radius: 6px;
        font-size: 13px;
        transition: border-color 0.2s;
    }

    .rs-filter-group select:focus,
    .rs-filter-group input:focus {
        outline: none;
        border-color: #3b82f6;
        box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
    }

    .rs-range-group .rs-range-inputs {
        display: flex;
        align-items: center;
        gap: 6px;
    }

    .rs-range-group .rs-range-inputs input {
        flex: 1;
        min-width: 60px;
    }

    .rs-range-group .rs-range-inputs span {
        color: #6b7280;
        font-weight: 500;
    }

    .rs-filter-actions {
        display: flex;
        gap: 8px;
        align-items: end;
        justify-content: flex-end;
    }

    .rs-filter-btn,
    .rs-reset-btn {
        padding: 8px 16px;
        font-size: 13px;
        border-radius: 6px;
        font-weight: 500;
    }

    .rs-filter-btn {
        background: #3b82f6;
        color: white;
        border: none;
        cursor: pointer;
        transition: background 0.2s;
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .rs-filter-btn:hover {
        background: #2563eb;
    }

    .rs-reset-btn {
        background: #f1f5f9;
        color: #64748b;
        border: 1px solid #cbd5e1;
        text-decoration: none;
        transition: all 0.2s;
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .rs-reset-btn:hover {
        background: #e2e8f0;
        color: #475569;
    }

    /* Table Styles */
    .rs-table-container {
        overflow-x: auto;
    }

    .rs-table {
        width: 100%;
        border-collapse: collapse;
        font-size: 14px;
    }

    /* Compact table styles */
    .rs-table th {
        padding: 12px 8px;
        font-size: 12px;
        background: #f8fafc;
        text-align: left;
        font-weight: 600;
        color: #374151;
        border-bottom: 2px solid #e2e8f0;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        white-space: nowrap;
    }

    .rs-th-center {
        text-align: center;
    }
    .rs-th-right {
        text-align: right;
    }
    .rs-th-sortable {
        cursor: pointer;
        transition: background 0.2s;
    }
    .rs-th-sortable:hover {
        background: #f1f5f9;
    }
    .rs-th-actions {
        width: 140px;
    }
    .rs-th-desc {
        max-width: 200px;
    }

    .rs-table td {
        padding: 10px 8px;
        font-size: 13px;
        border-bottom: 1px solid #f1f5f9;
        vertical-align: middle;
    }

    .rs-table-row:hover {
        background: #f8fafc;
    }

    .rs-td-center {
        text-align: center;
    }
    .rs-td-right {
        text-align: right;
    }
    .rs-td-index {
        font-weight: 600;
        color: #6b7280;
        width: 40px;
    }

    .rs-td-room-number {
        width: 80px;
    }

    .rs-td-room-number strong {
        color: #1e293b;
        font-size: 14px;
    }

    .rs-room-type-badge {
        background: #dbeafe;
        color: #1e40af;
        padding: 3px 6px;
        border-radius: 4px;
        font-size: 11px;
        font-weight: 500;
        white-space: nowrap;
    }

    .rs-floor-badge {
        background: #f3f4f6;
        color: #374151;
        padding: 3px 6px;
        border-radius: 4px;
        font-size: 11px;
        font-weight: 500;
    }

    .rs-price {
        font-weight: 600;
        color: #059669;
        font-size: 14px;
    }

    .rs-guests-badge {
        background: #fef3c7;
        color: #92400e;
        padding: 3px 8px;
        border-radius: 4px;
        font-size: 11px;
        font-weight: 500;
        min-width: 20px;
        text-align: center;
    }

    .rs-description {
        max-width: 200px;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
        color: #6b7280;
        font-size: 13px;
    }

    .rs-na-text {
        color: #9ca3af;
        font-style: italic;
        font-size: 13px;
    }

    /* Status badges */
    .rs-status-badge {
        padding: 4px 8px;
        border-radius: 12px;
        font-size: 10px;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        white-space: nowrap;
    }

    .rs-status-badge.available {
        background: #dcfce7;
        color: #166534;
    }

    .rs-status-badge.occupied {
        background: #fed7aa;
        color: #9a3412;
    }

    .rs-status-badge.maintenance {
        background: #fecaca;
        color: #991b1b;
    }

    .rs-status-badge.dirty {
        background: #fef3c7;
        color: #92400e;
    }

    .rs-status-badge.unknown {
        background: #f3f4f6;
        color: #6b7280;
    }

    /* Action buttons */
    .rs-action-buttons {
        display: flex;
        gap: 3px;
        justify-content: center;
    }

    .rs-btn {
        padding: 6px 8px;
        border: none;
        border-radius: 4px;
        font-size: 11px;
        font-weight: 500;
        cursor: pointer;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        transition: all 0.2s;
        min-width: 28px;
        height: 28px;
    }

    .rs-btn-housekeeping {
        background: #0ea5e9;
        color: white;
    }

    .rs-btn-housekeeping:hover {
        background: #0284c7;
        transform: translateY(-1px);
    }

    .rs-btn-edit {
        background: #3b82f6;
        color: white;
    }

    .rs-btn-edit:hover {
        background: #2563eb;
        transform: translateY(-1px);
    }

    .rs-btn-delete {
        background: #ef4444;
        color: white;
    }

    .rs-btn-delete:hover {
        background: #dc2626;
        transform: translateY(-1px);
    }

    /* Empty State */
    .rs-empty-state {
        text-align: center;
        padding: 60px 20px;
    }

    .rs-empty-content i {
        font-size: 48px;
        color: #cbd5e1;
        margin-bottom: 16px;
    }

    .rs-empty-content h3 {
        font-size: 18px;
        font-weight: 600;
        color: #374151;
        margin-bottom: 8px;
    }

    .rs-empty-content p {
        color: #6b7280;
        font-size: 14px;
        margin: 0;
    }

    /* Pagination */
    .rs-table-footer {
        padding: 20px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        border-top: 1px solid #e2e8f0;
        flex-wrap: wrap;
        gap: 15px;
        background: #f8fafc;
    }

    .rs-showing-info {
        color: #6b7280;
        font-size: 14px;
        font-weight: 500;
    }

    .rs-pagination {
        display: flex;
        gap: 4px;
        list-style: none;
        margin: 0;
        padding: 0;
    }

    .rs-pagination a {
        padding: 10px 14px;
        border: 1px solid #d1d5db;
        color: #374151;
        text-decoration: none;
        border-radius: 6px;
        font-size: 14px;
        font-weight: 500;
        transition: all 0.2s;
        min-width: 44px;
        text-align: center;
    }

    .rs-pagination a:hover {
        background: #f3f4f6;
        border-color: #9ca3af;
    }

    .rs-pagination .active a {
        background: #3b82f6;
        color: white;
        border-color: #3b82f6;
    }

    .rs-pagination .disabled a {
        color: #9ca3af;
        cursor: not-allowed;
        background: #f9fafb;
    }

    .rs-pagination .disabled a:hover {
        background: #f9fafb;
        border-color: #d1d5db;
    }

    /* Messages */
    .rs-alert {
        padding: 16px 20px;
        border-radius: 8px;
        margin-bottom: 20px;
        font-weight: 500;
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .rs-alert-success {
        background: #dcfce7;
        color: #166534;
        border: 1px solid #bbf7d0;
    }

    .rs-alert-error {
        background: #fecaca;
        color: #991b1b;
        border: 1px solid #fca5a5;
    }

    /* Input error styling */
    .rs-filters input:invalid,
    .rs-filters input.error {
        border-color: #ef4444;
        box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.1);
    }

    /* Responsive */
    @media (max-width: 1024px) {
        .rs-filter-row {
            grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
            gap: 10px;
        }
    }

    @media (max-width: 768px) {
        .rs-filter-row {
            grid-template-columns: 1fr 1fr;
        }

        .rs-table th,
        .rs-table td {
            padding: 8px 6px;
            font-size: 12px;
        }

        .rs-action-buttons {
            flex-direction: column;
            gap: 2px;
        }

        .rs-btn {
            min-width: 24px;
            height: 24px;
            padding: 4px 6px;
        }
    }

    @media (max-width: 480px) {
        .rs-filter-row {
            grid-template-columns: 1fr;
        }

        .rs-table {
            font-size: 11px;
        }

        .rs-room-type-badge,
        .rs-floor-badge,
        .rs-guests-badge,
        .rs-status-badge {
            font-size: 10px;
            padding: 2px 4px;
        }
    }
</style>

<!-- Enhanced JavaScript -->
<script>
    // Filter toggle functionality
    function toggleFilters() {
        const filters = document.getElementById('advancedFilters');
        const chevron = document.getElementById('filterChevron');

        if (filters.classList.contains('show')) {
            filters.classList.remove('show');
            chevron.style.transform = 'rotate(0deg)';
        } else {
            filters.classList.add('show');
            chevron.style.transform = 'rotate(180deg)';
        }
    }

    // Auto-show filters if any filter is active
    document.addEventListener('DOMContentLoaded', function () {
        const hasActiveFilters = ${not empty f_type || not empty f_status || not empty f_keyword || not empty f_minFloor || not empty f_maxFloor || not empty f_minPrice || not empty f_maxPrice || not empty f_minGuests || not empty f_maxGuests || not empty sort};

        if (hasActiveFilters) {
            document.getElementById('advancedFilters').classList.add('show');
            document.getElementById('filterChevron').style.transform = 'rotate(180deg)';
        }
    });

    function changePageSize(size) {
        const url = new URL(window.location);
        url.searchParams.set('pageSize', size);
        url.searchParams.set('page', '1');
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

    function quickSearch() {
        const keyword = document.getElementById('quickSearch').value;
        const url = new URL(window.location);
        url.searchParams.set('keyword', keyword);
        url.searchParams.set('page', '1');
        window.location.href = url.toString();
    }

    function validateFilters() {
        let isValid = true;
        const inputs = [
            {name: 'minFloor', maxName: 'maxFloor', label: 'Tầng'},
            {name: 'minPrice', maxName: 'maxPrice', label: 'Giá'},
            {name: 'minGuests', maxName: 'maxGuests', label: 'Số khách'}
        ];

        inputs.forEach(({ name, maxName, label }) => {
            const minInput = document.querySelector(`input[name="${name}"]`);
            const maxInput = document.querySelector(`input[name="${maxName}"]`);
            const minValue = minInput.value ? parseFloat(minInput.value) : null;
            const maxValue = maxInput.value ? parseFloat(maxInput.value) : null;

            minInput.classList.remove('error');
            maxInput.classList.remove('error');

            if (minValue !== null && maxValue !== null && minValue > maxValue) {
                minInput.classList.add('error');
                maxInput.classList.add('error');
                alert(`${label} tối thiểu không được lớn hơn ${label} tối đa!`);
                isValid = false;
        }
        });

        return isValid;
    }

    // Enhanced quick search with debounce
    let searchTimeout;
    document.getElementById('quickSearch').addEventListener('input', function () {
        clearTimeout(searchTimeout);
        searchTimeout = setTimeout(quickSearch, 500);
    });

    // Auto-hide messages with fade effect
    setTimeout(function () {
        const alerts = document.querySelectorAll('.rs-alert');
        alerts.forEach(function (alert) {
            alert.style.opacity = '0';
            alert.style.transition = 'opacity 0.5s';
            setTimeout(function () {
                alert.remove();
            }, 500);
        });
    }, 5000);

    // Add loading states for buttons
    document.querySelectorAll('.rs-filter-btn, .rs-search-btn').forEach(button => {
        button.addEventListener('click', function () {
            const originalText = this.innerHTML;
            this.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang tìm...';
            this.disabled = true;

            setTimeout(() => {
                this.innerHTML = originalText;
                this.disabled = false;
            }, 2000);
        });
    });
</script>
