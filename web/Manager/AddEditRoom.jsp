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

        <div class="tabs">
            <button type="button" class="tab-button active" onclick="switchTab('details')">
                Chi tiết
            </button>
            <button type="button" class="tab-button" onclick="switchTab('images')">
                Hình ảnh
            </button>
        </div>

        <!-- Details Tab -->
        <div id="detailsTab" class="tab-content active">
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
                    <div class="status-option">
                        <input type="radio" id="statusAvailable" name="status" value="Available" 
                               class="status-radio" ${room == null || room.status == 'Available' ? 'checked' : ''}>
                        <label for="statusAvailable" class="status-label">Available</label>
                    </div>
                    <div class="status-option">
                        <input type="radio" id="statusOccupied" name="status" value="Occupied" 
                               class="status-radio" ${room != null && room.status == 'Occupied' ? 'checked' : ''}>
                        <label for="statusOccupied" class="status-label">Occupied</label>
                    </div>
                    <div class="status-option">
                        <input type="radio" id="statusMaintenance" name="status" value="Maintenance" 
                               class="status-radio" ${room != null && room.status == 'Maintenance' ? 'checked' : ''}>
                        <label for="statusMaintenance" class="status-label">Maintenance</label>
                    </div>
                    <div class="status-option">
                        <input type="radio" id="statusDirty" name="status" value="Dirty" 
                               class="status-radio" ${room != null && room.status == 'Dirty' ? 'checked' : ''}>
                        <label for="statusDirty" class="status-label">Dirty</label>
                    </div>
                </div>
                <div class="error-message" id="statusError"></div>
            </div>
        </div>

        <!-- Images Tab -->
        <div id="imagesTab" class="tab-content">
            <div class="image-section">
                <div class="form-group">
                    <label class="form-label" for="mainImageUrl">URL ảnh đại diện</label>
                    <input type="url" id="mainImageUrl" name="mainImageUrl" class="form-input"
                           value="${room != null ? room.mainImageUrl : ''}" 
                           placeholder="https://example.com/image.jpg"
                           onchange="previewMainImage(this.value)">
                </div>

                <div id="mainImagePreview" class="image-preview-grid">
                    <c:if test="${room != null && not empty room.mainImageUrl}">
                        <div class="image-preview-item primary">
                            <img src="${room.mainImageUrl}" alt="Ảnh đại diện" onerror="this.parentElement.innerHTML='<div class=loading-placeholder>Không thể tải ảnh</div>'">
                            <div class="primary-badge">Chính</div>
                        </div>
                    </c:if>
                </div>
            </div>

            <div class="image-section">
                <label class="form-label">Ảnh chi tiết (URL)</label>
                
                <div class="image-input-group">
                    <input type="url" id="newDetailImageUrl" class="form-input image-input" 
                           placeholder="https://example.com/detail-image.jpg">
                    <button type="button" class="btn-add-url" onclick="addDetailImageUrl()">
                        + Thêm URL ảnh
                    </button>
                </div>

                <div id="detailImagesList">
                    <c:if test="${room != null && not empty room.detailImageUrls}">
                        <c:forEach var="imageUrl" items="${room.detailImageUrls}" varStatus="status">
                            <div class="detail-image-item">
                                <input type="url" name="detailImageUrls" value="${imageUrl}" 
                                       class="form-input" onchange="updateDetailImagePreview(this)">
                                <button type="button" class="remove-detail-btn" onclick="removeDetailImage(this)">Xóa</button>
                            </div>
                        </c:forEach>
                    </c:if>
                </div>

                <div id="detailImagesPreview" class="image-preview-grid">
                    <c:if test="${room != null && not empty room.detailImageUrls}">
                        <c:forEach var="imageUrl" items="${room.detailImageUrls}">
                            <div class="image-preview-item">
                                <img src="${imageUrl}" alt="Ảnh chi tiết" onerror="this.parentElement.innerHTML='<div class=loading-placeholder>Không thể tải ảnh</div>'">
                                <button type="button" class="set-primary-btn" onclick="setPrimaryImage('${imageUrl}')">Đặt làm ảnh chính</button>
                            </div>
                        </c:forEach>
                    </c:if>
                </div>
            </div>
        </div>

        <div class="card-footer">
            <a href="${pageContext.request.contextPath}/ListRoomsServlet" class="btn btn-secondary">Hủy</a>
            <button type="submit" class="btn btn-primary">Lưu</button>
        </div>
    </div>
</form>

<!-- CSS Styles -->
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

    .tabs {
        display: flex;
        border-bottom: 1px solid #e5e7eb;
    }

    .tab-button {
        flex: 1;
        padding: 16px 24px;
        background: none;
        border: none;
        font-size: 14px;
        font-weight: 500;
        color: #6b7280;
        cursor: pointer;
        transition: all 0.2s;
        border-bottom: 2px solid transparent;
    }

    .tab-button:hover {
        color: #374151;
        background: #f9fafb;
    }

    .tab-button.active {
        color: #2563eb;
        border-bottom-color: #2563eb;
        background: white;
    }

    .tab-content {
        display: none;
        padding: 24px;
    }

    .tab-content.active {
        display: block;
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

    .form-input {
        width: 100%;
        padding: 12px 16px;
        border: 1px solid #d1d5db;
        border-radius: 8px;
        font-size: 14px;
        transition: border-color 0.2s, box-shadow 0.2s;
    }

    .form-input:focus {
        outline: none;
        border-color: #2563eb;
        box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
    }

    .form-select {
        width: 100%;
        padding: 12px 16px;
        border: 1px solid #d1d5db;
        border-radius: 8px;
        font-size: 14px;
        background: white;
        cursor: pointer;
    }

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

    .image-section {
        margin-bottom: 24px;
    }

    .image-input-group {
        display: flex;
        gap: 12px;
        margin-bottom: 16px;
    }

    .image-input {
        flex: 1;
    }

    .btn-add-url {
        padding: 8px 16px;
        background: #2563eb;
        color: white;
        border: none;
        border-radius: 6px;
        font-size: 14px;
        font-weight: 500;
        cursor: pointer;
        transition: background 0.2s;
        white-space: nowrap;
    }

    .btn-add-url:hover {
        background: #1d4ed8;
    }

    .image-preview-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(120px, 1fr));
        gap: 12px;
        margin-top: 16px;
    }

    .image-preview-item {
        position: relative;
        aspect-ratio: 1;
        border-radius: 8px;
        overflow: hidden;
        border: 2px solid #e5e7eb;
        background: #f9fafb;
    }

    .image-preview-item.primary {
        border-color: #2563eb;
    }

    .image-preview-item img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }

    .image-preview-item .primary-badge {
        position: absolute;
        top: 4px;
        left: 4px;
        background: #2563eb;
        color: white;
        padding: 2px 6px;
        border-radius: 4px;
        font-size: 10px;
        font-weight: 600;
    }

    .image-preview-item .remove-btn {
        position: absolute;
        top: 4px;
        right: 4px;
        width: 20px;
        height: 20px;
        background: #ef4444;
        color: white;
        border: none;
        border-radius: 50%;
        font-size: 12px;
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .image-preview-item .set-primary-btn {
        position: absolute;
        bottom: 4px;
        left: 4px;
        right: 4px;
        background: rgba(0, 0, 0, 0.7);
        color: white;
        border: none;
        padding: 4px;
        border-radius: 4px;
        font-size: 10px;
        cursor: pointer;
    }

    .detail-image-item {
        display: flex;
        align-items: center;
        gap: 12px;
        padding: 12px;
        border: 1px solid #e5e7eb;
        border-radius: 8px;
        margin-bottom: 8px;
    }

    .detail-image-item input {
        flex: 1;
    }

    .detail-image-item .remove-detail-btn {
        padding: 6px 12px;
        background: #ef4444;
        color: white;
        border: none;
        border-radius: 4px;
        font-size: 12px;
        cursor: pointer;
    }

    .card-footer {
        padding: 20px 24px;
        border-top: 1px solid #e5e7eb;
        background: #f9fafb;
        display: flex;
        justify-content: flex-end;
        gap: 12px;
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

    .loading-placeholder {
        display: flex;
        align-items: center;
        justify-content: center;
        height: 120px;
        background: #f3f4f6;
        border-radius: 8px;
        color: #6b7280;
        font-size: 14px;
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
        
        .image-preview-grid {
            grid-template-columns: repeat(auto-fill, minmax(100px, 1fr));
        }
    }
</style>

<!-- JavaScript -->
<script>
    // Tab switching
    function switchTab(tabName) {
        // Remove active class from all tabs
        document.querySelectorAll('.tab-button').forEach(btn => btn.classList.remove('active'));
        document.querySelectorAll('.tab-content').forEach(content => content.classList.remove('active'));
        
        // Add active class to selected tab
        event.target.classList.add('active');
        document.getElementById(tabName + 'Tab').classList.add('active');
    }

    // Preview main image
    function previewMainImage(url) {
        const preview = document.getElementById('mainImagePreview');
        preview.innerHTML = '';
        
        if (url && isValidUrl(url)) {
            const imageItem = document.createElement('div');
            imageItem.className = 'image-preview-item primary';
            imageItem.innerHTML = `
                <img src="${url}" alt="Ảnh đại diện" onerror="this.parentElement.innerHTML='<div class=loading-placeholder>Không thể tải ảnh</div>'">
                <div class="primary-badge">Chính</div>
            `;
            preview.appendChild(imageItem);
        }
    }

    // Add detail image URL
    function addDetailImageUrl() {
        const urlInput = document.getElementById('newDetailImageUrl');
        const url = urlInput.value.trim();
        
        if (!url) {
            alert('Vui lòng nhập URL ảnh');
            return;
        }
        
        if (!isValidUrl(url)) {
            alert('URL không hợp lệ');
            return;
        }
        
        // Add to input list
        const detailImagesList = document.getElementById('detailImagesList');
        const imageItem = document.createElement('div');
        imageItem.className = 'detail-image-item';
        imageItem.innerHTML = `
            <input type="url" name="detailImageUrls" value="${url}" class="form-input" onchange="updateDetailImagePreview(this)">
            <button type="button" class="remove-detail-btn" onclick="removeDetailImage(this)">Xóa</button>
        `;
        detailImagesList.appendChild(imageItem);
        
        // Add to preview
        addDetailImagePreview(url);
        
        // Clear input
        urlInput.value = '';
    }

    // Add detail image preview
    function addDetailImagePreview(url) {
        const preview = document.getElementById('detailImagesPreview');
        const imageItem = document.createElement('div');
        imageItem.className = 'image-preview-item';
        imageItem.innerHTML = `
            <img src="${url}" alt="Ảnh chi tiết" onerror="this.parentElement.innerHTML='<div class=loading-placeholder>Không thể tải ảnh</div>'">
            <button type="button" class="set-primary-btn" onclick="setPrimaryImage('${url}')">Đặt làm ảnh chính</button>
        `;
        preview.appendChild(imageItem);
    }

    // Remove detail image
    function removeDetailImage(button) {
        const imageItem = button.parentElement;
        const url = imageItem.querySelector('input').value;
        
        // Remove from input list
        imageItem.remove();
        
        // Remove from preview
        const previewItems = document.querySelectorAll('#detailImagesPreview .image-preview-item');
        previewItems.forEach(item => {
            const img = item.querySelector('img');
            if (img && img.src === url) {
                item.remove();
            }
        });
    }

    // Set primary image
    function setPrimaryImage(url) {
        document.getElementById('mainImageUrl').value = url;
        previewMainImage(url);
    }

    // Update detail image preview when URL changes
    function updateDetailImagePreview(input) {
        // Refresh all previews
        refreshDetailImagePreviews();
    }

    // Refresh detail image previews
    function refreshDetailImagePreviews() {
        const preview = document.getElementById('detailImagesPreview');
        const inputs = document.querySelectorAll('input[name="detailImageUrls"]');
        
        preview.innerHTML = '';
        
        inputs.forEach(input => {
            const url = input.value.trim();
            if (url && isValidUrl(url)) {
                addDetailImagePreview(url);
            }
        });
    }

    // Validate URL
    function isValidUrl(string) {
        try {
            new URL(string);
            return true;
        } catch (_) {
            return false;
        }
    }

    // Form validation
    document.getElementById('roomForm').addEventListener('submit', function(e) {
        let isValid = true;
        
        // Clear previous errors
        document.querySelectorAll('.error-message').forEach(el => el.textContent = '');
        
        // Validate room number
        const roomNumber = document.getElementById('roomNumber').value.trim();
        if (!roomNumber) {
            document.getElementById('roomNumberError').textContent = 'Vui lòng nhập số phòng';
            isValid = false;
        }
        
        // Validate floor
        const floor = document.getElementById('floor').value;
        if (!floor || floor < 1) {
            document.getElementById('floorError').textContent = 'Vui lòng nhập số tầng hợp lệ';
            isValid = false;
        }
        
        // Validate room type
        const roomType = document.getElementById('roomTypeId').value;
        if (!roomType) {
            document.getElementById('roomTypeError').textContent = 'Vui lòng chọn loại phòng';
            isValid = false;
        }
        
        // Validate status
        const status = document.querySelector('input[name="status"]:checked');
        if (!status) {
            document.getElementById('statusError').textContent = 'Vui lòng chọn trạng thái phòng';
            isValid = false;
        }
        
        if (!isValid) {
            e.preventDefault();
            // Switch to details tab if there are errors
            switchTab('details');
        }
    });
</script>
