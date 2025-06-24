<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Messages -->
<c:if test="${not empty errorMessage}">
    <div class="alert alert-error">
        <i class="fas fa-exclamation-circle"></i> ${errorMessage}
    </div>
</c:if>

<form action="${pageContext.request.contextPath}/AddEditRoomServlet" method="post" id="roomForm">
    <input type="hidden" name="action" value="${room != null ? 'edit' : 'add'}">
    <c:if test="${room != null}">
        <input type="hidden" name="roomId" value="${room.roomID}">
    </c:if>

    <div class="card">
        <div class="card-header">
            <h2 class="card-title">${room != null ? 'Sửa phòng' : 'Thêm phòng mới'}</h2>
        </div>

        <div class="card-body">
            <div class="form-row">
                <div class="form-group">
                    <label class="form-label" for="roomNumber">Số phòng *</label>
                    <input type="text" id="roomNumber" name="roomNumber" class="form-input"
                           value="${room != null ? room.roomnumber : ''}" 
                           placeholder="Nhập số phòng" required>
                    <div class="error-message" id="roomNumberError"></div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="floor">Số tầng *</label>
                    <input type="number" id="floor" name="floor" class="form-input"
                           value="${room != null ? room.floor : ''}" 
                           placeholder="Nhập số tầng" min="1" max="50" required>
                    <div class="error-message" id="floorError"></div>
                </div>
            </div>

            <div class="form-group">
                <label class="form-label" for="roomTypeId">Loại phòng *</label>
                <select id="roomTypeId" name="roomTypeId" class="form-select" required>
                    <option value="">-- Chọn loại phòng --</option>
                    <c:forEach var="roomType" items="${roomTypes}">
                        <option value="${roomType.roomTypeID}" 
                                ${room != null && room.roomType.roomTypeID == roomType.roomTypeID ? 'selected' : ''}>
                            ${roomType.name} - ${roomType.basePrice} VNĐ/đêm
                        </option>
                    </c:forEach>
                </select>
                <div class="error-message" id="roomTypeError"></div>
            </div>

            <div class="form-group">
                <label class="form-label">Trạng thái phòng *</label>
                <div class="status-group">
                    <c:forEach var="status" items="${['Available', 'Occupied', 'Maintenance', 'Dirty']}">
                        <div class="status-option">
                            <input type="radio" id="status${status}" name="status" value="${status}" class="status-radio"
                                   ${room == null && status == 'Available' || room != null && room.status == status ? 'checked' : ''}>
                            <label for="status${status}" class="status-label">${status}</label>
                        </div>
                    </c:forEach>
                </div>
                <div class="error-message" id="statusError"></div>
            </div>
        </div>

        <div class="card-footer">
            <a href="${pageContext.request.contextPath}/ListRoomsServlet" class="btn btn-secondary">Hủy</a>
            <button type="submit" class="btn btn-primary">Lưu</button>
        </div>
    </div>
</form>

<style>
    .card {
        background: white;
        border-radius: 12px;
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        border: 1px solid #e5e7eb;
        overflow: hidden;
        margin-bottom: 20px;
    }

    .card-header {
        padding: 20px 24px;
        border-bottom: 1px solid #e5e7eb;
        background: #f9fafb;
    }

    .card-title {
        font-size: 18px;
        font-weight: 600;
        color: #111827;
        margin: 0;
    }

    .card-body {
        padding: 24px;
    }

    .card-footer {
        padding: 20px 24px;
        border-top: 1px solid #e5e7eb;
        background: #f9fafb;
        display: flex;
        justify-content: flex-end;
        gap: 12px;
    }

    .form-group {
        margin-bottom: 20px;
    }

    .form-label {
        display: block;
        margin-bottom: 8px;
        font-size: 14px;
        font-weight: 500;
        color: #374151;
    }

    .form-input,
    .form-select {
        width: 100%;
        padding: 12px 16px;
        border: 1px solid #d1d5db;
        border-radius: 8px;
        font-size: 14px;
        transition: border-color 0.2s, box-shadow 0.2s;
    }

    .form-input:focus,
    .form-select:focus {
        outline: none;
        border-color: #2563eb;
        box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
    }

    .form-row {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 16px;
    }

    .status-group {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        gap: 12px;
    }

    .status-option {
        position: relative;
    }

    .status-radio {
        position: absolute;
        opacity: 0;
        cursor: pointer;
    }

    .status-label {
        display: flex;
        align-items: center;
        padding: 12px 16px;
        border: 2px solid #e5e7eb;
        border-radius: 8px;
        cursor: pointer;
        transition: all 0.2s;
        font-size: 14px;
        font-weight: 500;
    }

    .status-radio:checked + .status-label {
        border-color: #2563eb;
        background: #eff6ff;
        color: #2563eb;
    }

    .status-label:hover {
        border-color: #9ca3af;
    }

    .btn {
        padding: 10px 20px;
        border-radius: 8px;
        font-size: 14px;
        font-weight: 500;
        cursor: pointer;
        transition: all 0.2s;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        justify-content: center;
    }

    .btn-secondary {
        background: #f3f4f6;
        color: #374151;
        border: 1px solid #d1d5db;
    }

    .btn-secondary:hover {
        background: #e5e7eb;
    }

    .btn-primary {
        background: #10b981;
        color: white;
        border: 1px solid #10b981;
    }

    .btn-primary:hover {
        background: #059669;
    }

    .error-message {
        color: #ef4444;
        font-size: 12px;
        margin-top: 4px;
    }

    .alert {
        padding: 12px 16px;
        border-radius: 8px;
        margin-bottom: 20px;
        font-weight: 500;
    }

    .alert-error {
        background: #fecaca;
        color: #991b1b;
        border: 1px solid #fca5a5;
    }

    @media (max-width: 768px) {
        .form-row {
            grid-template-columns: 1fr;
        }

        .status-group {
            grid-template-columns: 1fr;
        }
    }
</style>
<!-- JavaScript -->
<script>
    document.getElementById('roomForm').addEventListener('submit', function (e) {
        let isValid = true;
        document.querySelectorAll('.error-message').forEach(el => el.textContent = '');

        const roomNumber = document.getElementById('roomNumber').value.trim();
        if (!roomNumber) {
            document.getElementById('roomNumberError').textContent = 'Vui lòng nhập số phòng';
            isValid = false;
        }

        const floor = document.getElementById('floor').value;
        if (!floor || floor < 1) {
            document.getElementById('floorError').textContent = 'Vui lòng nhập số tầng hợp lệ';
            isValid = false;
        }

        const roomType = document.getElementById('roomTypeId').value;
        if (!roomType) {
            document.getElementById('roomTypeError').textContent = 'Vui lòng chọn loại phòng';
            isValid = false;
        }

        const status = document.querySelector('input[name="status"]:checked');
        if (!status) {
            document.getElementById('statusError').textContent = 'Vui lòng chọn trạng thái phòng';
            isValid = false;
        }

        if (!isValid) {
            e.preventDefault();
        }
    });
</script>
